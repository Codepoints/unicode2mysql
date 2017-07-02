#!/bin/bash

URL="https://$SRCLANG.wikipedia.org/w/api.php?action=query&redirects&format=json&prop=extracts&exintro&titles="
CHAR="$1"
QCHAR="$(echo -n "$CHAR" | python3 -c 'import sys;from urllib.parse import quote;print(quote(sys.stdin.read(), safe=""))')"
XCHAR="$(echo -n "$CHAR" | python3 -c 'import sys;print("%04X" % ord(sys.stdin.read()))')"

$CURL $CURL_OPTS "$URL$QCHAR" | $JQ -r '.query.pages[].extract' > "$(dirname $0)/../cache/abstracts/$SRCLANG/$XCHAR"
