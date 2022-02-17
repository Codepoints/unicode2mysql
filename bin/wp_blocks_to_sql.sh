#!/bin/bash
#
# Fetching WP block articles via SPARQL:
#
#    SELECT DISTINCT ?lang ?name ?range ?article WHERE {
#      ?block wdt:P31 wd:Q3512806 .
#      ?block wdt:P5949 ?range .
#      ?article schema:about ?block ;
#               schema:inLanguage ?lang ;
#               schema:name ?name ;
#               schema:isPartOf [ wikibase:wikiGroup "wikipedia" ] .
#      FILTER(?lang in ('en', 'de', 'pl', 'es')) .
#    }
#
# Sandbox: https://w.wiki/xjk
#
# Code explanation: see wp_scripts_to_sql.sh, which does more or less the
# same.
#

set -euo pipefail

TARGET="$1"

$CURL $CURL_OPTS 'https://query.wikidata.org/sparql?query=SELECT%20DISTINCT%20%3Flang%20%3Fname%20%3Frange%20%3Farticle%20WHERE%20%7B%0A%20%20%3Fblock%20wdt%3AP31%20wd%3AQ3512806%20.%0A%20%20%3Fblock%20wdt%3AP5949%20%3Frange%20.%0A%20%20%3Farticle%20schema%3Aabout%20%3Fblock%20%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20schema%3AinLanguage%20%3Flang%20%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20schema%3Aname%20%3Fname%20%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20schema%3AisPartOf%20%5B%20wikibase%3AwikiGroup%20%22wikipedia%22%20%5D%20.%0A%20%20FILTER(%3Flang%20in%20(%22en%22%2C%20%22de%22%2C%20%22pl%22%2C%20%22es%22))%20.%0A%7D&format=json' | \
    $JQ -r '.results.bindings[] | [.range.value, .article.value, .lang.value, .name.value] | join("\t")' | \
    while IFS= read -r line; do
        IFS=$'\t'
        PARTS=($line)
        IFS=' '
        ABSTRACT="$($CURL $CURL_OPTS "$(echo -n "${PARTS[1]}" | \
            sed 's#/wiki/#/api/rest_v1/page/summary/#')" | \
            jq -r '.extract_html' | \
            sed "s/'/\\\\'/g" )"
        FIRST="$(echo -n "${PARTS[0]}" | sed 's/^U+\([0-9A-Fa-f]\+\).*/\1/')"
        printf "INSERT INTO block_abstract ( first, abstract, lang, src ) VALUES ( %d, '%s', '%s', '%s' );\n" \
            "0x$FIRST" "$ABSTRACT" "${PARTS[2]}" "${PARTS[1]}"
    done > "$TARGET"
