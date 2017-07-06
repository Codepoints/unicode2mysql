#!/usr/bin/python3
"""
Create the search index table and fill it

The search index is a simple table that contains codepoints and their
search terms: name, abstract, ... We create it from the other information
stored in the ucd.sqlite database. Some, like abstract and kDefinition,
get split, stopwords removed and inserted in pieces.

The terms are weighted. That means, each term has an associated number
representing its importance for the codepoint. Names get the highest weight,
words in the Wikipedia abstract the lowest. This ensures, that the search
for "ox" finds U+1F402 OX before any other codepoint that happens to
relate to oxen.
"""

from bs4 import BeautifulSoup
import configparser
from functools import reduce
from markdown import markdown
import MySQLdb
import nltk
from os.path import dirname, isfile, realpath
import re
import sys


# get database connection settings
config = configparser.RawConfigParser()
config.read(dirname(__file__)+'/../data/db.conf')


# pre-create the NLP structures for later splitting text
stopwords = nltk.corpus.stopwords.words('english')
punctrm = re.compile(r'[!-/:-@\[-`{-~\u2212\u201C\u201D]', re.UNICODE)
wnl = nltk.WordNetLemmatizer()


def sql_convert(s):
    """format a string to be printed in an SQL statement"""
    if isinstance(s, str):
        s = "'"+s.replace("\\", "\\\\").replace("'", "\\'")+"'"
    if isinstance(s, bytes):
        s = "'"+s.decode('utf-8').replace("\\", "\\\\").replace("'", "\\'")+"'"
    else:
        s = str(s)
    return s


def exec_sql(*sql):
    """execute or store an SQL query"""
    sql0 = sql[0]
    if len(sql) > 1:
        params = tuple(map(sql_convert, sql[1]))
        sql0 = sql0 % params
    print(sql0)


def tokenize(terms):
    """create a stream of tokens from plain text"""
    return [wnl.lemmatize(t) for t in
            set(
                filter(lambda w: re.sub(punctrm, '', w) != '',
                    [w for w
                        in map(lambda s: s.lower(),
                            nltk.word_tokenize(terms))
                        if w not in stopwords]
                )
            )
        ]


def get_addinfo_tokens(cp):
    """fetch, if exists, the tokens from the additional Markdown file"""
    tokens = []
    mdfile = dirname(dirname(realpath(__file__))) + \
             ('/codepoints.net/data/U+%04X.en.md' % cp)

    if not isfile(mdfile):
        return tokens

    with open(mdfile) as f:
        abstract = markdown(f.read())
        terms = BeautifulSoup(abstract).get_text()
        tokens = tokenize(terms)
    return tokens


def get_abstract_tokens(cp):
    """Fetch abstract for cp and split it in tokens"""
    cur.execute("SELECT abstract FROM codepoint_abstract WHERE cp = %s AND lang = 'en'", (cp,))
    abstract = (cur.fetchone() or {'abstract':None})['abstract']
    if abstract:
        terms = BeautifulSoup(abstract).get_text()
        tokens = tokenize(terms)
    else:
        tokens = []
    return tokens


def get_decomp(cp):
    """get the decomposition mapping of a codepoint"""
    cur.execute("""SELECT `other` FROM codepoint_relation
                   WHERE cp = %s AND relation = 'dm' ORDER BY `order` ASC""",
                   (cp,))
    dms = cur.fetchall()

    if len(dms) and dms[0]['other'] != cp:
        return reduce(lambda x, y: x + chr(int(y['other'])), dms, '').lower()
    return None


def get_aliases(cp):
    """get all aliases of a codepoint"""
    cur.execute("SELECT alias FROM codepoint_alias WHERE cp = %s", (cp,))
    return map(lambda s: s['alias'], cur.fetchall())


def get_block(cp):
    """get block name of a codepoint"""
    cur.execute("SELECT name FROM blocks WHERE first <= %s AND last >= %s", (cp,cp))
    blk = cur.fetchone()
    if blk:
        blk = blk['name']
    return blk


def get_scripts(cp):
    """get scripts of a codepoint"""
    cur.execute("SELECT sc, `primary` FROM codepoint_script WHERE cp = %s", (cp,))
    r = []
    for row in cur.fetchall():
        r.append((row['sc'], int(row['primary'])))
    return r


def has_confusables(cp):
    """whether the CP has any confusables"""
    cur.execute('''
            SELECT COUNT(*) AS c
               FROM codepoint_confusables
              WHERE codepoint_confusables.cp = %s
                 OR codepoint_confusables.other = %s''', (cp,cp))
    return cur.fetchone()['c']


def term(cp, term, weight):
    """create a new search term query"""
    exec_sql('INSERT INTO search_index (cp, term, weight) '
             'VALUES (%s, %s, %s);', (cp, term, weight))


def handle_row(item):
    """take a codepoint row from db and create search index terms"""
    cp = item['cp']

    term(cp, 'int:{}'.format(cp), 80)

    for j, weight in (('na', 100), ('na1', 90), ('kDefinition', 50)):
        if item[j]:
            # add the full value: "na:foo bar baz"
            term(cp, '%s:%s' % (j, item[j].lower()), weight)
            for w in re.split(r'\s+', item[j].lower()):
                term(cp, w, weight)
                if '-' in w:
                    # we need this to find cps like "TAG HYPHEN-MINUS"
                    # when searching for "hyphen".
                    for w2 in w.split('-'):
                        term(cp, w2, weight-20)

    for prop in item.keys():
        if (prop not in ('na', 'na1', 'kDefinition', 'cp') and
            prop is not None and item[prop] is not None):
            # all other properties get stored as foo:bar pairs, with foo
            # as property and bar as its value
            _i = item[prop]
            term(cp, '%s:%s' % (prop, _i), 50)

    for w in get_aliases(cp):
        term(cp, w, 40)

    for w in get_abstract_tokens(cp):
        term(cp, w, 1)

    dm = get_decomp(cp)
    if dm:
        term(cp, dm, 30)

    h = '0'
    if has_confusables(cp):
        h = '1'
    term(cp, 'confusables:'+h, 50)

    block = get_block(cp)
    if block:
        term(cp, 'blk:%s' % block, 30)

    for script in get_scripts(cp):
        # scx props get lesser weight than true sc
        term(cp, 'sc:%s' % script[0], 50 if script[1] else 25)


conn = MySQLdb.connect(
        host='localhost',
        user=config['clientreadonly']['user'],
        passwd=config['clientreadonly']['password'],
        db=config['clientreadonly']['database'])
conn.set_character_set('utf8')
cur = conn.cursor(MySQLdb.cursors.DictCursor)
cur.execute('SET NAMES utf8mb4;')
cur.execute('SET CHARACTER SET utf8mb4;')
cur.execute('SET character_set_connection=utf8mb4;')

cur.execute('SELECT * FROM codepoints;')
all_cps = cur.fetchall()

i = 0
for item in all_cps:
    i += 1

    handle_row(item)

    if i % 1000 == 0:
        sys.stderr.write('-- U+%04X' % item['cp'])


cur.close()
conn.commit()
conn.close()
