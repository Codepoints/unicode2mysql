#!/usr/bin/python3

import sys
from xml.parsers import expat

template = "INSERT INTO codepoints (%(fields)s) VALUES (%(values)s);\n"
cp_template = "INSERT INTO codepoint_relation (cp, other, relation) VALUES (%s, %s, '%s');\n"
cpp_template = "INSERT INTO codepoint_relation (cp, other, relation, `order`) VALUES (%s, %s, '%s', %s);\n"
sc_template = "INSERT INTO codepoint_script (cp, sc, `primary`) VALUES (%s, '%s', %s);\n"

# boolean fields
boolfields = (
    'Bidi_M', 'Bidi_C', 'CE', 'Comp_Ex', 'XO_NFC', 'XO_NFD', 'XO_NFKC',
    'XO_NFKD', 'Join_C', 'Upper', 'Lower', 'OUpper', 'OLower', 'CI', 'Cased',
    'CWCF', 'CWCM', 'CWL', 'CWKCF', 'CWT', 'CWU', 'IDS', 'OIDS', 'XIDS',
    'IDC', 'OIDC', 'XIDC', 'Pat_Syn', 'Pat_WS', 'Dash', 'Hyphen', 'QMark',
    'Term', 'STerm', 'Dia', 'Ext', 'SD', 'Alpha', 'OAlpha', 'Math', 'OMath',
    'Hex', 'AHex', 'DI', 'ODI', 'LOE', 'WSpace', 'Gr_Base', 'Gr_Ext',
    'OGr_Ext', 'Gr_Link', 'Ideo', 'UIdeo', 'IDSB', 'IDST', 'Radical', 'Dep',
    'VS', 'NChar', 'PCM', 'RI',
)

# single codepoints (INT, need '#' resolution)
cpfields = (
    'cp', 'bmg', 'suc', 'slc', 'stc', 'scf', 'bpb',
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


def handle_cp(hex_cp, attrs):
    cp = int(hex_cp, 16)
    ucp = str(hex_cp)
    fields = ['cp']
    values = [str(cp)]
    add = ''
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
                    add += cpp_template % (cp, int(vv, 16), f, i+1)
            elif len(v) == 1:
                add += cp_template % (cp, int(v[0], 16), f)
        elif f == 'sc':
            if scx and v in scx:
                add += "UPDATE codepoint_script SET `primary` = 1 WHERE cp = %s AND sc = '%s'" % (cp, v)
            else:
                add += sc_template % (cp, v, 1)
        elif f == 'scx':
            for script in v.split(' '):
                if not sc or script != sc:
                    add += sc_template % (cp, script, 0)
        else:
            fields.append(f)
            values.append("'%s'" % v.replace("'", "''"))
    print(template % {
        'fields': ','.join(fields),
        'values': ','.join(values),
    })
    if add:
        print(add)


def start_element(element, attrs):
    if element in ('char', 'noncharacter') and 'cp' in attrs:
        handle_cp(attrs['cp'], attrs)
    elif element == 'noncharacter' and 'first-cp' in attrs and 'last-cp' in attrs:
        for icp in range(int(attrs['first-cp'], 16), int(attrs['last-cp'], 16)+1):
            handle_cp('%X' % icp, attrs)


p = expat.ParserCreate()
p.StartElementHandler = start_element
p.Parse(sys.stdin.read())
