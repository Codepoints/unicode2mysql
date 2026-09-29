#!/bin/bash
#
# 1. fetch a list of all scripts and their WP articles in the given languages
#    from WikiData
#
#    SPARQL query:
#
#        SELECT DISTINCT ?iso ?lang ?name ?article WHERE {
#          ?script wdt:P506 ?iso .
#          VALUES ?wikis {
#                        <https://de.wikipedia.org/>
#                        <https://en.wikipedia.org/>
#                        <https://es.wikipedia.org/>
#                        <https://pl.wikipedia.org/>
#          }
#          ?article schema:about ?script ;
#                      schema:inLanguage ?lang ;
#                      schema:name ?name ;
#                      schema:isPartOf ?wikis .
#          FILTER(?lang in ('en', 'de', 'pl', 'es')) .
#        }
#
#    Sandbox: https://w.wiki/VqHZ
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

$CURL $CURL_OPTS 'https://query.wikidata.org/sparql?query=SELECT%20DISTINCT%20%3Fiso%20%3Flang%20%3Fname%20%3Farticle%20WHERE%7B%3Fscript%20wdt%3AP506%20%3Fiso.VALUES%20%3Fwikis%7B%3Chttps%3A//de.wikipedia.org/%3E%20%3Chttps%3A//en.wikipedia.org/%3E%20%3Chttps%3A//es.wikipedia.org/%3E%20%3Chttps%3A//pl.wikipedia.org/%3E%7D%3Farticle%20schema%3Aabout%20%3Fscript%3Bschema%3AinLanguage%20%3Flang%3Bschema%3Aname%20%3Fname%3Bschema%3AisPartOf%20%3Fwikis.FILTER%28%3Flang%20in%20%28%27en%27%2C%20%27de%27%2C%20%27pl%27%2C%20%27es%27%29%29.%7D&format=json' | \
    $JQ -r '.results.bindings[] | [.iso.value, .article.value, .lang.value, .name.value] | join("\t")' | \
    while IFS= read -r line; do
        sleep 1
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
