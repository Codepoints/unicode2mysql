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

import configparser
from functools import reduce
import json
from markdown import markdown
import multiprocessing
import MySQLdb
from os.path import dirname, isfile, realpath
from os import cpu_count
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


def get_addinfo(cp):
    """fetch, if exists, the tokens from the additional Markdown file"""
    mdfile = dirname(dirname(realpath(__file__))) + \
             ('/cache/codepoints.net/codepoints.net/data/U+%04X.en.md' % cp)
    if isfile(mdfile):
        with open(mdfile, encoding='utf-8') as f:
            return markdown(f.read())
    return ''


def get_abstract(cur, cp):
    """Fetch abstract for cp"""
    cur.execute("SELECT abstract FROM codepoint_abstract WHERE cp = %s AND lang = 'en'", (cp,))
    return (cur.fetchone() or {}).get('abstract', '')


def get_emoji_annotations(cur, cp):
    """Fetch emoji annotation for cp and split it in tokens"""
    cur.execute("SELECT annotation FROM codepoint_annotation WHERE cp = %s", (cp,))
    return ' '.join(x['annotation'] for x in cur.fetchall() or [])


def get_decomp(cur, cp):
    """get the decomposition mapping of a codepoint"""
    cur.execute("""SELECT `other` FROM codepoint_relation
                   WHERE cp = %s AND relation = 'dm' ORDER BY `order` ASC""",
                   (cp,))
    dms = cur.fetchall()

    if len(dms) and dms[0]['other'] != cp:
        return reduce(lambda x, y: x + chr(int(y['other'])), dms, '').lower()
    return ''


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
    return blk or ''


def get_scripts(cur, cp):
    """get scripts of a codepoint

    The primary script is added twice to boost it in searches."""
    cur.execute("SELECT sc, `primary` FROM codepoint_script WHERE cp = %s", (cp,))
    r = []
    for row in cur.fetchall():
        r.append('{sc} sc_{sc}'.format(sc=row['sc']) * (1 + int(row['primary'])))
    return r


def has_confusables(cur, cp):
    """whether the CP has any confusables"""
    cur.execute('''
            SELECT COUNT(*) AS c
               FROM codepoint_confusables
              WHERE codepoint_confusables.cp = %s
                 OR codepoint_confusables.other = %s''', (cp,cp))
    return cur.fetchone()['c']


def handle_row(config, item):
    """take a codepoint row from db and create search index terms"""
    cur = get_cur(config)

    cp = item['cp']
    item['kDefinition'] = ''
    if item['unihan']:
        item['kDefinition'] = json.loads(item['unihan']).get('kDefinition', '')

    props = ''
    for prop in item.keys():
        if (prop not in ('na', 'na1', 'kDefinition', 'cp') and
            prop is not None and item[prop] is not None):
            props += ' prop_%s_%s' % (prop, item[prop])

    doc = '''
{rendered} {rendered} {rendered} {rendered}
{rendered} {rendered} {rendered} {rendered}
{na} {na} {na} {na} {na} {na} na_{na}
{na_no_hyphen}
{na1} {na1} {na1} {na1} {na1} na1_{na1}
{kDefinition} {kDefinition} {kDefinition} kDefinition_{kDefinition}
int_{int}
{int:X} {int:04X} hex_{int:X} hex_{int:04X} U+{int:04X} U+{int:04X} U+{int:04X}
0x{int:04X} 0x{int:X}
{props}
{aliases} {aliases}
{abstract}
{emoji_annotations} {emoji_annotations}
{addinfo}
{decomposition}
confusables_{confusables}
{block} blk_{block}
{script}
    '''.format(
        rendered=(chr(cp) if item['gc'][0] != 'C' else ''),
        na=item['na'],
        na_no_hyphen=item['na'].replace('-', ''),
        na1=item['na1'],
        kDefinition=item['kDefinition'],
        int=cp,
        props=props,
        aliases=' '.join(get_aliases(cur, cp)),
        abstract=get_abstract(cur, cp),
        emoji_annotations=get_emoji_annotations(cur, cp),
        addinfo=get_addinfo(cp),
        decomposition=get_decomp(cur, cp),
        confusables=('1' if has_confusables(cur, cp) else '0'),
        block=get_block(cur, cp),
        script=' '.join(get_scripts(cur, cp))
    )

    return [cp, doc]


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
def add_to_buffer(params):
    global _buffer
    _buffer.append(params)
    if len(_buffer) > 1000:
        write_buffer()

def write_buffer():
    global _buffer
    local_buffer = []
    while len(_buffer) and len(local_buffer) <= 1005:
        local_buffer.append(_buffer.pop(0))
    print("INSERT INTO search_index (cp, text) VALUES" +
          ',\n'.join("({}, {})".format(sql_convert(item[0]), sql_convert(item[1])) for item in local_buffer) +
          ";")


cpus = cpu_count() or 2

print("SET NAMES 'utf8mb4' COLLATE 'utf8mb4_unicode_ci';\n")

with multiprocessing.Pool(cpus) as pool:
    cur = get_cur(config)
    cur.execute('SELECT * FROM codepoint_props;')
    all_cps = cur.fetchall()
    cur.close()

    for result in pool.starmap(handle_row, map(lambda row: (config, row), all_cps), chunksize=len(all_cps)//cpus):
        add_to_buffer(result)

    pool.close()
    pool.join()

write_buffer()
