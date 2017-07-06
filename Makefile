SHELL := /bin/bash

CURL := curl
CURL_OPTS := --silent --show-error --user-agent "Unicode2MySQL,github.com/Codepoints/unicode2mysql"

JQ := jq

SAXON := saxonb-xslt

PYTHON := virtualenv/bin/python

EMOJI_VERSION := 5.0

DUMMY_DB := codepoints_dummy

define TTF2SVG
Open($$1);
Reencode("unicode");
Generate($$1:r + ".svg");
Quit(0);
endef


all: sql
.PHONY: all

sql: sql-static sql-dynamic
.PHONY: sql

sql-static: \
	sql/30_ucd.sql \
	sql/31_htmlentities.sql \
	sql/32_confusables.sql \
	sql/33_images.sql \
	sql/34_aliases.sql \
	sql/35_blocks.sql \
	sql/36_encodings.sql \
	sql/37_latex.sql \
	sql/40_digraphs.sql \
	sql/50_wp_codepoints_de.sql \
	sql/50_wp_codepoints_en.sql \
	sql/50_wp_codepoints_es.sql \
	sql/50_wp_codepoints_pl.sql \
	sql/51_wp_scripts_en.sql \
	sql/60_emojis.sql
.PHONY: sql-static

sql-dynamic: sql/70_search_index.sql
.PHONY: sql-dynamic


cache/confusables.txt:
	@$(CURL) $(CURL_OPTS) http://www.unicode.org/Public/security/latest/confusables.txt > $@
.SECONDARY: cache/confusables.txt

cache/rfc1345.txt:
	@$(CURL) $(CURL_OPTS) http://www.rfc-editor.org/rfc/rfc1345.txt > $@
.SECONDARY: cache/rfc1345.txt

cache/htmlentities.json:
	@$(CURL) $(CURL_OPTS) https://html.spec.whatwg.org/entities.json > $@
.SECONDARY: cache/htmlentities.json

cache/emoji-data.txt:
	@$(CURL) $(CURL_OPTS) http://www.unicode.org/Public/emoji/$(EMOJI_VERSION)/emoji-data.txt > $@
.SECONDARY: cache/emoji-data.txt

cache/ucd.all.flat.xml:
	@$(CURL) $(CURL_OPTS) http://www.unicode.org/Public/UCD/latest/ucdxml/ucd.all.flat.zip | \
	    bsdtar -xf- --cd cache
.SECONDARY: cache/ucd.all.flat.xml

cache/unicode/ReadMe.txt:
	@mkdir -p cache/unicode
	@$(CURL) $(CURL_OPTS) http://www.unicode.org/Public/UCD/latest/ucd/UCD.zip | \
	    bsdtar -xf- --cd cache/unicode
.SECONDARY: cache/unicode/ReadMe.txt

cache/dewiki-latest-all-titles-in-ns0.gz \
cache/enwiki-latest-all-titles-in-ns0.gz \
cache/eswiki-latest-all-titles-in-ns0.gz \
cache/plwiki-latest-all-titles-in-ns0.gz: \
cache/%wiki-latest-all-titles-in-ns0.gz:
	@$(CURL) $(CURL_OPTS) https://dumps.wikimedia.org/$*wiki/latest/$*wiki-latest-all-titles-in-ns0.gz > "$@"
.SECONDARY: cache/dewiki-latest-all-titles-in-ns0.gz
.SECONDARY: cache/enwiki-latest-all-titles-in-ns0.gz
.SECONDARY: cache/eswiki-latest-all-titles-in-ns0.gz
.SECONDARY: cache/plwiki-latest-all-titles-in-ns0.gz

export CURL CURL_OPTS JQ
cache/abstracts/de/0041 \
cache/abstracts/en/0041 \
cache/abstracts/es/0041 \
cache/abstracts/pl/0041: \
cache/abstracts/%/0041: cache/%wiki-latest-all-titles-in-ns0.gz
	@mkdir -p cache/abstracts/$*
	@zcat cache/$*wiki-latest-all-titles-in-ns0.gz | \
	    LANG=C.UTF-8 grep '^.$$' | \
	    SRCLANG="$*" xargs -d '\n' -i -n 1 -P 0 bin/char_to_abstract.sh '{}'
.SECONDARY: cache/abstracts/de/0041
.SECONDARY: cache/abstracts/en/0041
.SECONDARY: cache/abstracts/es/0041
.SECONDARY: cache/abstracts/pl/0041

export TTF2SVG
cache/noto/NotoSans-Regular.svg: cache/noto/NotoSans-Regular.ttf
	@for font in cache/noto/NotoSans*-Regular.ttf; do \
	    echo "$$TTF2SVG" | /usr/bin/env fontforge -lang=ff -script /dev/stdin "$$font"; \
	done
	@for font in cache/noto/NotoSansCJK*-Regular.otf; do \
	    echo "$$TTF2SVG" | /usr/bin/env fontforge -lang=ff -script /dev/stdin "$$font"; \
	done

cache/noto/NotoSans-Regular.ttf:
	@mkdir -p cache/noto
	@$(CURL) $(CURL_OPTS) https://noto-website.storage.googleapis.com/pkgs/Noto-unhinted.zip | \
	    bsdtar -xf- --cd cache/noto
.SECONDARY: cache/noto/NotoSans-Regular.ttf

cache/encoding/README.md:
	@test -d cache/encoding || git clone git@github.com:whatwg/encoding.git cache/encoding
	@cd cache/encoding && git pull
.SECONDARY: cache/encoding

cache/latex.xml:
	@$(CURL) $(CURL_OPTS) http://www.w3.org/Math/characters/unicode.xml > cache/latex.xml
	@$(CURL) $(CURL_OPTS) http://www.w3.org/Math/characters/charlist.dtd > cache/charlist.dtd


sql/30_ucd.sql: cache/ucd.all.flat.xml
	@< $< $(PYTHON) bin/ucd_to_sql.py > $@

sql/31_htmlentities.sql: cache/htmlentities.json
	@cat $< | \
	    $(JQ) -r '. as $$orig | keys[] | { n: ., o: $$orig[.].codepoints } | select( ( .o | length ) == 1 ) | "INSERT INTO codepoint_alias (cp, alias, `type`) VALUES (" + (.o[0] | tostring) + ", \"" + .n + "\", \"html\");"' \
	    > $@

sql/32_confusables.sql: cache/confusables.txt
	@true > $@
	@cat $< | \
	    sed -e 1d -e '/^#/d' -e '/^\s*$$/d' | \
	    sed 's/\s*;\s*MA\s.\+//' | \
	    sed 's/\s*;\s*/;/' | \
	    while read line; do \
	        $(PYTHON) bin/confusables_to_sql.py "$$line" >> $@ ; \
	    done

sql/33_images.sql: cache/noto/NotoSans-Regular.svg
	@#sed 's/<\/svg>/<text id="x" font-family="Noto Sans Rejang" font-size="64" x="32" y="48" text-anchor="middle">\&#xA940;<\/text>&/' cache/noto/NotoSansRejang-Regular.svg | inkscape --export-text-to-path --export-plain-svg=/dev/stdout /dev/stdin | inkscape --select=x --verb SelectionUnGroup --export-plain-svg=/dev/stdout /dev/stdin | rsvg-convert -w 64 -h 64 -f svg | svgo -i - -o - | sed s/64pt/64/g
	@ls -1 cache/noto/Noto*.svg | \
	    grep -v NotoSansSymbols-Regular.svg | \
	    nl | \
	    xargs -n 2 -P 0 sh -c '$(SAXON) -s "$$1" -xsl bin/font2sql.xsl > "$@.$$0"'
	@cat "$@".?* > $@ && /bin/rm "$@".?*

sql/34_aliases.sql: cache/unicode/ReadMe.txt
	@$(PYTHON) bin/alias_to_sql.py > $@

sql/35_blocks.sql: cache/unicode/ReadMe.txt
	@sed -n '/^[0-9A-F]/p' cache/unicode/Blocks.txt | \
	    sed 's/\([0-9A-F]\+\)\.\.\([0-9A-F]\+\); \?\(.\+\)$$/\3\x00\1\x00\2/' | \
	    tr '\n' '\0' | \
	    xargs -0 -n 3 sh -c 'printf "INSERT INTO blocks (name, first, last) VALUES ('"'%s'"', %s, %s);\n" "$$0" "$$(echo $$1| tr a-f A-F | sed "s/^/ibase=16;/" | bc)" "$$(echo $$2| tr a-f A-F | sed "s/^/ibase=16;/" | bc)"' \
	    > $@

sql/36_encodings.sql: cache/encoding/README.md
	@true > $@
	@for enc in cache/encoding/index-*.txt; do \
	    $(PYTHON) bin/encoding_to_sql.py $$enc >> $@; \
	done

sql/37_latex.sql: cache/latex.xml
	@$(SAXON) -s "$<" -xsl bin/latex_to_sql.xsl > "$@"

sql/40_digraphs.sql: cache/rfc1345.txt
	@true > $@
	@cat $< | \
	    sed -n '/^ [^ ]\{1,6\} \+[0-9A-Fa-f]\{4\}    [^ ].*$$/p' | \
	    sed 's/^ \([^ ]\{1,6\}\) \+\([0-9A-Fa-f]\{4\}\)    [^ ].*$$/\1\t\2/' | \
	    sed 's/'"'"'/\\'"'"'/g' | \
	    perl -p -e 's/^([^\t]+)\t([0-9a-f]{4})$$/"INSERT INTO codepoint_alias (cp, alias, `type`) VALUES (".hex("$$2").", '"'"'".$$1."'"'"', '"'"'digraph'"'"');"/e' > $@

sql/50_wp_codepoints_de.sql \
sql/50_wp_codepoints_en.sql \
sql/50_wp_codepoints_es.sql \
sql/50_wp_codepoints_pl.sql: \
sql/50_wp_codepoints_%.sql: cache/abstracts/%/0041
	@true > $@
	@for file in cache/abstracts/$*/*; do \
	    printf "INSERT INTO codepoint_abstract ( cp, abstract, lang ) VALUES ( %s, '%s', '%s' );\n" \
	        $$(basename $$file | tr a-f A-F | sed 's/^/ibase=16;/' | bc) \
	        "$$(sed "s/'/\\\\'/g" $$file)" \
	        "$*" \
	    >> $@; \
	done

sql/51_wp_scripts_en.sql:
	@true > $@
	@cat data/script_to_wikipedia.csv | \
	    while IFS= read -r line; do \
	        ( \
	        echo -n "INSERT INTO script_abstract ( sc, abstract, lang, src )VALUES ('"; \
	        echo -n "$${line%;*}"; \
	        echo -n "', '"; \
	        $(CURL) $(CURL_OPTS) 'https://en.wikipedia.org/w/api.php?action=query&redirects&format=json&prop=extracts&exintro&titles='$${line##*;} | $(JQ) -r '.query.pages[].extract' | sed "s/'/\\\\'/g"; \
	        echo  "', 'en', 'https://en.wikipedia.org/wiki/$${line##*;}');"; \
	        ) >> $@ ; \
	    done

sql/60_emojis.sql: cache/emoji-data.txt
	@sed -n '/^[0-9A-F]/s/\s*#.*//p' $< | \
	    sed 's/^\([A-F0-9]\+\) /\1..\1 /' | \
	    sed 's/\s*;\s*/ /' | sed 's/\.\./ /' | \
	    xargs -n 3 sh -c 'for x in $$(seq $$(echo ibase=16\;$$0|bc) $$(echo ibase=16\;$$1|bc)); do echo UPDATE codepoints SET $$2=1 WHERE cp=$$x\;; done' \
	    > $@

sql/70_search_index.sql: sql-static db-up
	@$(PYTHON) bin/create_search_index.py > $@


db-up: db-down db-schema db-data
.PHONY: db-up

db-schema:
	@( echo 'CREATE DATABASE $(DUMMY_DB); use $(DUMMY_DB);' ; cat sql/0*.sql ) | mysql
.PHONY: db-schema

db-data: sql
	@ls sql/[^1-6]*.sql | xargs -P 0 -i sh -c 'mysql $(DUMMY_DB) < {}'
.PHONY: db-data

db-down:
	@echo 'DROP DATABASE IF EXISTS $(DUMMY_DB);' | mysql
.PHONY: db-down


clean:
	@-/bin/rm -fr \
	    sql/30_ucd.sql \
	    sql/31_htmlentities.sql \
	    sql/32_confusables.sql \
	    sql/33_images.sql \
	    sql/34_aliases.sql \
	    sql/35_blocks.sql \
	    sql/36_encodings.sql \
	    sql/37_latex.sql \
	    sql/40_digraphs.sql \
	    sql/50_wp_codepoints_*.sql \
	    sql/51_wp_scripts_en.sql \
	    sql/60_emojis.sql \
	    sql/70_search_index.sql \
	    cache/*
.PHONY: clean
