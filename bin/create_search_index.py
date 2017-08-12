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
import multiprocessing
import MySQLdb
import nltk
from os.path import dirname, isfile, realpath
import re
import sys


# get database connection settings
config = configparser.RawConfigParser()
config.read(dirname(__file__)+'/../data/db.conf')


def sql_convert(s):
    """format a string to be printed in an SQL statement"""
    if isinstance(s, str):
        s = "'"+s.replace("\\", "\\\\").replace("'", "\\'")+"'"
    if isinstance(s, bytes):
        s = "'"+s.decode('utf-8').replace("\\", "\\\\").replace("'", "\\'")+"'"
    else:
        s = str(s)
    return s


def tokenize(terms):
    """create a stream of tokens from plain text"""
    stopwords = nltk.corpus.stopwords.words('english')
    punctrm = re.compile(r'[!-/:-@\[-`{-~\u2212\u201C\u201D]', re.UNICODE)
    wnl = nltk.WordNetLemmatizer()
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
             ('/cache/codepoints.net/codepoints.net/data/U+%04X.en.md' % cp)

    if not isfile(mdfile):
        return tokens

    with open(mdfile, encoding='utf-8') as f:
        abstract = markdown(f.read())
        terms = BeautifulSoup(abstract, 'lxml').get_text()
        tokens = tokenize(terms)
    return tokens


def get_abstract_tokens(cur, cp):
    """Fetch abstract for cp and split it in tokens"""
    cur.execute("SELECT abstract FROM codepoint_abstract WHERE cp = %s AND lang = 'en'", (cp,))
    abstract = (cur.fetchone() or {'abstract':None})['abstract']
    if abstract:
        terms = BeautifulSoup(abstract, 'lxml').get_text()
        tokens = tokenize(terms)
    else:
        tokens = []
    return tokens


def get_decomp(cur, cp):
    """get the decomposition mapping of a codepoint"""
    cur.execute("""SELECT `other` FROM codepoint_relation
                   WHERE cp = %s AND relation = 'dm' ORDER BY `order` ASC""",
                   (cp,))
    dms = cur.fetchall()

    if len(dms) and dms[0]['other'] != cp:
        return reduce(lambda x, y: x + chr(int(y['other'])), dms, '').lower()
    return None


def get_aliases(cur, cp):
    """get all aliases of a codepoint"""
    cur.execute("SELECT alias FROM codepoint_alias WHERE cp = %s", (cp,))
    return map(lambda s: s['alias'], cur.fetchall())


def get_block(cur, cp):
    """get block name of a codepoint"""
    cur.execute("SELECT name FROM blocks WHERE first <= %s AND last >= %s", (cp,cp))
    blk = cur.fetchone()
    if blk:
        blk = blk['name']
    return blk


def get_scripts(cur, cp):
    """get scripts of a codepoint"""
    cur.execute("SELECT sc, `primary` FROM codepoint_script WHERE cp = %s", (cp,))
    r = []
    for row in cur.fetchall():
        r.append((row['sc'], int(row['primary'])))
    return r


def has_confusables(cur, cp):
    """whether the CP has any confusables"""
    cur.execute('''
            SELECT COUNT(*) AS c
               FROM codepoint_confusables
              WHERE codepoint_confusables.cp = %s
                 OR codepoint_confusables.other = %s''', (cp,cp))
    return cur.fetchone()['c']


def term(cp, term, weight):
    """create a new search term query"""
    return [ (cp, term, weight) ]
    #query = ('INSERT INTO search_index (cp, term, weight) '
    #         'VALUES (%s, %s, %s);\n')
    #return query % tuple(map(sql_convert, (cp, term, weight)))


def handle_row(config, item):
    """take a codepoint row from db and create search index terms"""
    cur = get_cur(config)

    cp = item['cp']
    sql = []

    sql += term(cp, 'int:{}'.format(cp), 80)

    for j, weight in (('na', 100), ('na1', 90), ('kDefinition', 50)):
        if item[j]:
            # add the full value: "na:foo bar baz"
            if j != 'kDefinition':
                sql += term(cp, '%s:%s' % (j, item[j].lower()), weight)
            for w in re.split(r'\s+', str(item[j]).lower()):
                sql += term(cp, w, weight)
                if '-' in w:
                    # we need this to find cps like "TAG HYPHEN-MINUS"
                    # when searching for "hyphen".
                    for w2 in w.split('-'):
                        sql += term(cp, w2, weight-20)

    for prop in item.keys():
        if (prop not in ('na', 'na1', 'kDefinition', 'cp') and
            prop is not None and item[prop] is not None):
            # all other properties get stored as foo:bar pairs, with foo
            # as property and bar as its value
            _i = item[prop]
            sql += term(cp, '%s:%s' % (prop, _i), 50)

    for w in get_aliases(cur, cp):
        sql += term(cp, w, 40)

    for w in get_abstract_tokens(cur, cp):
        sql += term(cp, w, 1)

    for w in get_addinfo_tokens(cp):
        sql += term(cp, w, 1)

    dm = get_decomp(cur, cp)
    if dm:
        sql += term(cp, dm, 30)

    h = '0'
    if has_confusables(cur, cp):
        h = '1'
    sql += term(cp, 'confusables:'+h, 50)

    block = get_block(cur, cp)
    if block:
        sql += term(cp, 'blk:%s' % block, 30)

    for script in get_scripts(cur, cp):
        # scx props get lesser weight than true sc
        sql += term(cp, 'sc:%s' % script[0], 50 if script[1] else 25)

    return sql


def get_cur(config):
    """get a database cursor from a new DB connection"""
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
    return cur


def errprint(s):
    sys.stderr.write('%s\n' % s)


_buffer = []
def add_to_buffer(*params):
    global _buffer
    _buffer.append(params)
    if len(_buffer) > 1000:
        write_buffer()

def write_buffer():
    global _buffer
    local_buffer = []
    while len(_buffer) and len(local_buffer) <= 1005:
        local_buffer.append(_buffer.pop(0))
    print("INSERT INTO search_index (cp, term, weight) VALUES" +
          ',\n'.join(map(lambda items: "(%s, %s, %s)" % tuple(map(sql_convert, items)), local_buffer)) +
          ";")


with multiprocessing.Pool(4) as pool:
    cur = get_cur(config)
    cur.execute('SELECT * FROM codepoints;')
    all_cps = cur.fetchall()
    cur.close()

    #for row in all_cps:
    #    pool.apply_async(handle_row, (config, row,), callback=print, error_callback=errprint)

    for result in pool.starmap(handle_row, map(lambda row: (config, row), all_cps), chunksize=8):
        for r in result:
            add_to_buffer(*r)

    pool.close()
    pool.join()

write_buffer()
