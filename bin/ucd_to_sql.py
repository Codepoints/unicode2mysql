#!/usr/bin/python3

import re
import sys
from xml.parsers import expat
from block_map import block_map

template = "INSERT INTO codepoint_props (%(fields)s) VALUES (%(values)s);\n"

# boolean fields
boolfields = (
    'Bidi_M', 'Bidi_C', 'CE', 'Comp_Ex', 'XO_NFC', 'XO_NFD', 'XO_NFKC',
    'XO_NFKD', 'Join_C', 'Upper', 'Lower', 'OUpper', 'OLower', 'CI', 'Cased',
    'CWCF', 'CWCM', 'CWL', 'CWKCF', 'CWT', 'CWU', 'IDS', 'OIDS', 'XIDS',
    'IDC', 'OIDC', 'XIDC', 'Pat_Syn', 'Pat_WS', 'Dash', 'Hyphen', 'QMark',
    'Term', 'STerm', 'Dia', 'Ext', 'SD', 'Alpha', 'OAlpha', 'Math', 'OMath',
    'Hex', 'AHex', 'DI', 'ODI', 'LOE', 'WSpace', 'Gr_Base', 'Gr_Ext',
    'OGr_Ext', 'Gr_Link', 'Ideo', 'UIdeo', 'IDSB', 'IDST', 'Radical', 'Dep',
    'VS', 'NChar', 'PCM', 'RI', 'Emoji', 'EPres', 'EMod', 'EBase', 'EComp',
    'ExtPict',
)

# single codepoints (INT, need '#' resolution)
cpfields = (
    'cp', 'bmg', 'suc', 'slc', 'stc', 'scf', 'bpb', 'EqUIdeo',
)

# multiple codepoints (need '#' resolution, 'na' is a special case, here)
cppfields = (
    'dm', 'FC_NFKC', 'uc', 'lc', 'tc', 'cf', 'NFKC_CF',
)

# integer fields
intfields = (
    'ccc',
)


relation_fields = cpfields + cppfields


name_map = {}
def add_to_name_map(cp, na, na1, gc):
    global name_map
    name_map[cp] = [na if na else na1 + '*' if na1 else '', gc]


cps_buffer = {}
def add_to_cps_buffer(fields, values):
    global cps_buffer
    if fields not in cps_buffer:
        cps_buffer[fields] = []
    cps_buffer[fields].append(values)
    if len(cps_buffer[fields]) > 500:
        write_cps_buffer(fields)

def write_cps_buffer(fields=None):
    global cps_buffer
    if not fields:
        while cps_buffer:
            write_cps_buffer(list(cps_buffer)[0])
    else:
        print("INSERT INTO codepoint_props (%s) VALUES\n(" % fields)
        print('),\n('.join(cps_buffer[fields]))
        print(");\n")
        del(cps_buffer[fields])


rel_buffer = []
def add_to_rel_buffer(*params):
    global rel_buffer
    rel_buffer.append(params)
    if len(rel_buffer) > 500:
        write_rel_buffer()

def write_rel_buffer():
    global rel_buffer
    print("INSERT INTO codepoint_relation (cp, other, relation, `order`) VALUES\n")
    print(',\n'.join(map(lambda items: "(%s, %s, '%s', %s)" % items, rel_buffer)))
    print(";\n")
    rel_buffer = []


script_buffer = []
def add_to_script_buffer(*params):
    global script_buffer
    script_buffer.append(params)
    if len(script_buffer) > 500:
        write_script_buffer()

def write_script_buffer():
    global script_buffer
    print("INSERT INTO codepoint_script (cp, sc, `primary`) VALUES\n")
    print(',\n'.join(map(lambda items: "(%s, '%s', %s)" % items, script_buffer)))
    print(";\n")
    script_buffer = []


update_script_buffer = []
def add_to_update_script_buffer(*params):
    global update_script_buffer
    update_script_buffer.append(params)

def write_update_script_buffer():
    global update_script_buffer
    print('\n'.join(map(lambda items: "UPDATE codepoint_script SET `primary` = 1 WHERE cp = %s AND sc = '%s';" % items, update_script_buffer)))
    update_script_buffer = []


def handle_cp(hex_cp, attrs):
    cp = int(hex_cp, 16)
    ucp = str(hex_cp)
    fields = ['cp']
    values = [str(cp)]
    sc = ''
    scx = ''
    for f, v in attrs.items():
        if f in ('cp', 'first-cp', 'last-cp'):
            continue
        if f == 'na':
            fields.append(f)
            values.append("'%s'" % v.replace("'", "''").replace('#', ucp))
        elif f in boolfields:
            fields.append(f)
            if v == "Y":
                values.append("1")
            elif v == "N":
                values.append("0")
            else:
                values.append("NULL")
        elif f in intfields:
            fields.append(f)
            values.append(str(int(v)))
        elif f in relation_fields:
            v = v.replace('#', ucp).split()
            if len(v) > 1:
                for i, vv in enumerate(v):
                    add_to_rel_buffer(cp, int(vv, 16), f, i+1)
            elif len(v) == 1:
                add_to_rel_buffer(cp, int(v[0], 16), f, 0)
        elif f == 'sc':
            if scx and v in scx:
                add_to_update_script_buffer(cp, v)
            else:
                add_to_script_buffer(cp, v, 1)
            sc = v
        elif f == 'scx':
            for script in v.split(' '):
                if not sc or script != sc:
                    add_to_script_buffer(cp, script, 0)
            scx = v
        elif f == 'blk':
            fields.append(f)
            values.append("'%s'" % block_map.get(v, v).replace("'", "''"))
        else:
            fields.append(f)
            values.append("'%s'" % v.replace("'", "''"))
    add_to_cps_buffer(','.join(fields), ','.join(values))
    add_to_name_map(
        cp,
        attrs['na'].replace('#', ucp),
        'NONCHARACTER' if attrs.get('NChar') == 'Y' else attrs.get('na1', ''),
        attrs['gc'])


def start_element(element, attrs):
    if element in ('char', 'noncharacter') and 'cp' in attrs:
        handle_cp(attrs['cp'], attrs)
    elif element == 'noncharacter' and 'first-cp' in attrs and 'last-cp' in attrs:
        for icp in range(int(attrs['first-cp'], 16), int(attrs['last-cp'], 16)+1):
            handle_cp('%X' % icp, attrs)


p = expat.ParserCreate()
p.StartElementHandler = start_element
with open(sys.argv[1]) as ucd_file:
    p.Parse(ucd_file.read())

write_cps_buffer()
write_rel_buffer()
write_script_buffer()
write_update_script_buffer()

with open(sys.argv[2]) as alias_file:
    for line in alias_file:
        if not line.strip() or not re.match('[0-9A-F]', line):
            continue
        hex_cp, alias, type_ = line.strip().split(';')
        cp = int(hex_cp, 16)
        if type_ == 'correction':
            name_map[cp][0] = alias + '*'
        elif not name_map[cp][0] and type_ in ('control', 'figment'):
            name_map[cp][0] = alias + '*'

for cp, props in name_map.items():
    print("INSERT INTO codepoints (cp, name, gc) VALUES ({}, '{}', '{}');\n".format(
        cp, props[0].replace("'", "''"), props[1]))
