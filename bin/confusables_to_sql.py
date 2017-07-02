#!/usr/bin/python3

import sys

xcp, xothers = sys.argv[1].strip().split(';')
for i, xother in enumerate(xothers.split(' ')):
    print("INSERT INTO codepoint_confusables (cp, other, `order`) VALUES (%s, %s, %s);" % (
        int(xcp, 16),
        int(xother, 16),
        i + 1,
    ))
