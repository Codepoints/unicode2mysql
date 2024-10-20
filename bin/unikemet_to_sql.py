#!/usr/bin/python3

import json
import os

unikemet = {}

with open(os.path.join(os.path.dirname(os.path.dirname(__file__)), 'cache/unicode/Unikemet.txt')) as file:
    for line in file:
        if not line.strip() or line[0] == '#':
            continue
        xcp, field, value = line.strip().split('\t')
        cp = int(xcp.replace('U+', ''), 16)
        if cp not in unikemet:
            unikemet[cp] = {}
        unikemet[cp][field] = value

for cp, data in unikemet.items():
    print("UPDATE codepoint_props SET unikemet = '%s' WHERE cp = %s;" % (
        json.dumps(data, separators=(',', ':')).replace("'", "''"),
        cp
    ))
