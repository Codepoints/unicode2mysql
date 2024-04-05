#!/bin/bash

set -euo pipefail

SRCLANG="$1"
QCHAR="$2"
TARGET="$3"

URL="https://$SRCLANG.wikipedia.org/w/api.php?action=query&redirects&format=json&prop=extracts&exintro&titles="

echo "https://$SRCLANG.wikipedia.org/wiki/$QCHAR" > "$TARGET"
$CURL $CURL_OPTS --location "$URL$QCHAR" | \
    $JQ -r '.query.pages | to_entries [0].value.extract' | \
    $PYTHON "$(dirname "$0")/scrub_wp_html.py" >> "$TARGET"

# prevent running into API limits
sleep 0.01
