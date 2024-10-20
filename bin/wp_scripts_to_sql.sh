#!/bin/bash
#
# 1. fetch a list of all scripts and their WP articles in the given languages
#    from WikiData
#
#    SPARQL query:
#
#        SELECT DISTINCT ?iso ?lang ?name ?article WHERE {
#          ?script wdt:P506 ?iso .
#          ?article schema:about ?script ;
#                      schema:inLanguage ?lang ;
#                      schema:name ?name ;
#                      schema:isPartOf [ wikibase:wikiGroup "wikipedia" ] .
#          FILTER(?lang in ('en', 'de', 'pl', 'es')) .
#        }
#
#    Sandbox: https://w.wiki/xTJ
#
# 2. run the result through `jq` to make a TSV data on the fly.
#
# 3. read each line into a bash array.
#
# 4. fetch the excerpt from the Wikipedia via their REST API.
#
# 5. Put everything together in an SQL statement and print it into the target
#    file.
#

set -euo pipefail

TARGET="$1"

$CURL $CURL_OPTS 'https://query.wikidata.org/sparql?query=SELECT%20DISTINCT%20%3Fiso%20%3Flang%20%3Fname%20%3Farticle%20WHERE%20%7B%0A%20%20%3Fscript%20wdt%3AP506%20%3Fiso%20.%0A%20%20%3Farticle%20schema%3Aabout%20%3Fscript%20%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20schema%3AinLanguage%20%3Flang%20%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20schema%3Aname%20%3Fname%20%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20schema%3AisPartOf%20%5B%20wikibase%3AwikiGroup%20%22wikipedia%22%20%5D%20.%0A%20%20FILTER(%3Flang%20in%20('"'en'%2C%20'de'%2C%20'pl'%2C%20'es'"'))%20.%0A%7D&format=json' | \
    $JQ -r '.results.bindings[] | [.iso.value, .article.value, .lang.value, .name.value] | join("\t")' | \
    while IFS= read -r line; do
        IFS=$'\t'
        PARTS=($line)
        IFS=' '
        ABSTRACT="$($CURL $CURL_OPTS "$(echo -n "${PARTS[1]}" | \
            sed 's#/wiki/#/api/rest_v1/page/summary/#')" | \
            jq -r '.extract_html' | \
            sed "s/'/\\\\'/g" )"
        printf "INSERT INTO script_abstract ( sc, lang, abstract, src ) VALUES ( '%s', '%s', '%s', '%s' );\n" \
            "${PARTS[0]}" "${PARTS[2]}" "$ABSTRACT" "${PARTS[1]}"
    done > "$TARGET"
