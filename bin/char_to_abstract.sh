#!/bin/bash

URL="https://$SRCLANG.wikipedia.org/w/api.php?action=query&redirects&format=json&prop=extracts&exintro&titles="
CHAR="$1"

declare -A MAP_ZERO=( ["en"]="Zero" ["de"]="Null" ["es"]="Cero" ["pl"]="Zero" )
declare -A MAP_NUMBER=( ["en"]="number" ["es"]="n%C3%BAmero" ["pl"]="liczba" )
declare -A MAP_DE=( ["1"]="Eins" ["2"]="Zwei" ["3"]="Drei" ["4"]="Vier" ["5"]="F%C3%BCnf" ["6"]="Sechs" ["7"]="Sieben" ["8"]="Acht" ["9"]="Neun" )

QCHAR="$(echo -n "$CHAR" | python3 -c 'import sys;from urllib.parse import quote;print(quote(sys.stdin.read(), safe=""))')"
XCHAR="$(echo -n "$CHAR" | python3 -c 'import sys;print("%04X" % ord(sys.stdin.read()))')"

case "$QCHAR" in
    0 )
        QCHAR="${MAP_ZERO[$SRCLANG]}"
        ;;
    1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 )
        case "$SRCLANG" in
            "de" )
                QCHAR="${MAP_DE[$QCHAR]}"
                ;;
            * )
                QCHAR="${QCHAR}_(${MAP_NUMBER[$SRCLANG]})"
                ;;
        esac
        ;;
esac

echo "https://$SRCLANG.wikipedia.org/wiki/$QCHAR" > "$(dirname "$0")/../cache/abstracts/$SRCLANG/$XCHAR"
$CURL $CURL_OPTS --location "$URL$QCHAR" | \
    $JQ -r '.query.pages | to_entries [0].value.extract' >> "$(dirname "$0")/../cache/abstracts/$SRCLANG/$XCHAR"

# prevent running into API limits
sleep 0.01
