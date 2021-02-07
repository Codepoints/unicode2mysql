#!/usr/bin/python3
"""Create SQL from the list of Unicode aliases"""

from os.path import dirname
import string

template = "INSERT INTO codepoint_alias (cp, alias, `type`) VALUES (%s, '%s', '%s');"

def handle_buf(buffer, template):
    cp = int(buffer.split("\t")[0], 16)
    for line in buffer.split("\n"):
        if line.startswith("\t= "):
            buffer = ""
            aliases = []
            for chunk in line[3:].split(','):
                if buffer and ")" in chunk:
                    aliases.append(buffer+","+chunk)
                    buffer = ""
                elif buffer:
                    buffer += ',' + chunk
                elif "(" in chunk and ")" not in chunk:
                    buffer = chunk
                else:
                    aliases.append(chunk)
            if buffer:
                aliases.append(buffer)

            for alias in aliases:
                print(template % (cp, alias.strip().replace("'", "''"), 'alias'))

with open(dirname(__file__)+'/../cache/unicode/NameAliases.txt', encoding='utf-8') as mapfile:
    for line in mapfile:
        if ";" in line and line[0] != "#":
            (cp, name, typ) = line.strip().split(";")
            print(template % (int(cp, 16), name.replace("'", "''"), typ))

with open(dirname(__file__)+'/../cache/unicode/NamesList.txt', encoding='utf-8') as mapfile:
    buffer = ''
    for line in mapfile:
        if line[0] in string.hexdigits:
            if buffer != '':
                handle_buf(buffer, template)
            buffer = line
        elif line[0] == '\t' and buffer != '':
            buffer += line
