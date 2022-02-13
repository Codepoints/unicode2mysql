#!/usr/bin/python3

import sys

for ln, line in enumerate(sys.stdin):
    xcp, xothers = line.strip().split(';')
    for i, xother in enumerate(xothers.split(' ')):
        print("INSERT INTO codepoint_confusables (id, cp, other, `order`) VALUES (%s, %s, %s, %s);" % (
            ln + 1,
            int(xcp, 16),
            int(xother, 16),
            i + 1,
        ))
