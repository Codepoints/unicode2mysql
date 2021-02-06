#!/bin/bash


URL="https://$SRCLANG.wikipedia.org/api/rest_v1/page/summary/"
CHAR="$1"
QCHAR="$(echo -n "$CHAR" | python3 -c 'import sys;from urllib.parse import quote;print(quote(sys.stdin.read(), safe=""))')"
XCHAR="$(echo -n "$CHAR" | python3 -c 'import sys;print("%04X" % ord(sys.stdin.read()))')"

$CURL $CURL_OPTS "$URL$QCHAR" | $JQ -r '.extract_html' > "$(dirname $0)/../cache/abstracts/$SRCLANG/$XCHAR"

# prevent running into API limits
sleep 0.01
