#
# It's unlikely that this Makefile will run under any other platform than
# a Debian derivative. Look into the Dockerfile for required packages.
# Additionally, you will need GNU-compatible bc, nl, tr, sed, xargs, grep,
# zcat, and a bsdtar that unzips .zip files from stdin.
#

SHELL := /bin/bash

# executables and their options

CURL := curl
CURL_OPTS := --silent --show-error --location --max-redirs 3 --user-agent "Unicode2MySQL,github.com/Codepoints/unicode2mysql"

JQ := jq

SAXON := saxonb-xslt

PYTHON := virtualenv/bin/python

FONTFORGE := fontforge

BSDTAR := bsdtar

MYSQL := mysql

MYSQL_OPTS := --default-character-set=utf8mb4

# control variables

EMOJI_VERSION := 5.0

LANGUAGES := de en es pl

WIKIPEDIA_DUMP_MIRROR := https://dumps.wikimedia.your.org

DUMMY_DB := codepoints_dummy


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
	sql/38_emojis.sql \
	sql/40_digraphs.sql \
	sql/50_wp_codepoints_de.sql \
	sql/50_wp_codepoints_en.sql \
	sql/50_wp_codepoints_es.sql \
	sql/50_wp_codepoints_pl.sql \
	sql/51_wp_scripts_en.sql \
	sql/52_wp_blocks_en.sql \
	sql/60_font_Symbola.sql \
	sql/60_font_Aegean.sql \
	sql/60_font_HANNOMB.sql \
	sql/60_font_HanaMinA.sql \
	sql/60_font_HanaMinB.sql \
	sql/60_font_damase_v.2.sql
.PHONY: sql-static

sql-dynamic: sql/70_search_index.sql sql/71_font_order.sql
.PHONY: sql-dynamic


cache/confusables.txt:
	@echo create $@
	@$(CURL) $(CURL_OPTS) http://www.unicode.org/Public/security/latest/confusables.txt > $@
.SECONDARY: cache/confusables.txt

cache/rfc1345.txt:
	@echo create $@
	@$(CURL) $(CURL_OPTS) http://www.rfc-editor.org/rfc/rfc1345.txt > $@
.SECONDARY: cache/rfc1345.txt

cache/htmlentities.json:
	@echo create $@
	@$(CURL) $(CURL_OPTS) https://html.spec.whatwg.org/entities.json > $@
.SECONDARY: cache/htmlentities.json

cache/emoji-data.txt:
	@echo create $@
	@$(CURL) $(CURL_OPTS) http://www.unicode.org/Public/emoji/$(EMOJI_VERSION)/emoji-data.txt > $@
.SECONDARY: cache/emoji-data.txt

cache/ucd.all.flat.xml:
	@echo create $@
	@$(CURL) $(CURL_OPTS) http://www.unicode.org/Public/UCD/latest/ucdxml/ucd.all.flat.zip | \
	    $(BSDTAR) -xf- --cd cache
.SECONDARY: cache/ucd.all.flat.xml

cache/unicode/ReadMe.txt:
	@echo fetch Unicode data
	@mkdir -p cache/unicode
	@$(CURL) $(CURL_OPTS) http://www.unicode.org/Public/UCD/latest/ucd/UCD.zip | \
	    $(BSDTAR) -xf- --cd cache/unicode
.SECONDARY: cache/unicode/ReadMe.txt

cache/%wiki-latest-all-titles-in-ns0.gz:
	@echo create $@
	@for l in $(LANGUAGES); do \
	    $(CURL) $(CURL_OPTS) "$(WIKIPEDIA_DUMP_MIRROR)/$${l}wiki/latest/$${l}wiki-latest-all-titles-in-ns0.gz" > "cache/$${l}wiki-latest-all-titles-in-ns0.gz"; \
	    if grep -q "503 Service Temporarily Unavailable" "cache/$${l}wiki-latest-all-titles-in-ns0.gz"; then \
	        echo "Wikipedia sent an error when fetching cache/$${l}wiki-latest-all-titles-in-ns0.gz" >&2; \
	        exit 1; \
	    fi; \
	done
.SECONDARY: cache/*wiki-latest-all-titles-in-ns0.gz

export CURL CURL_OPTS JQ
cache/abstracts/de/0041 \
cache/abstracts/en/0041 \
cache/abstracts/es/0041 \
cache/abstracts/pl/0041: \
cache/abstracts/%/0041: cache/%wiki-latest-all-titles-in-ns0.gz
	@echo create $@
	@mkdir -p cache/abstracts/$*
	@zcat cache/$*wiki-latest-all-titles-in-ns0.gz | \
	    LANG=C.UTF-8 grep '^.$$' | \
	    SRCLANG="$*" xargs -d '\n' -i -n 1 -P 0 bin/char_to_abstract.sh '{}'
.SECONDARY: cache/abstracts/de/0041
.SECONDARY: cache/abstracts/en/0041
.SECONDARY: cache/abstracts/es/0041
.SECONDARY: cache/abstracts/pl/0041

cache/noto/NotoSans-Regular.svg: cache/noto/NotoSans-Regular.ttf
	@echo convert Noto fonts to SVG
	@for font in cache/noto/NotoSans*-Regular.ttf cache/noto/NotoSansCJK*-Regular.otf; do \
	    $(FONTFORGE) -quiet -lang=ff -script bin/ttf_to_svg.ff "$$font"; \
	    sed -i 's/ unicode="&#x\(e01[0-9a-f]\|fe0\)[0-9a-f];"//g' "$$(echo "$$font" | sed 's/\.[ot]tf$$/.svg/')"; \
	done

cache/noto/NotoSans-Regular.ttf:
	@echo fetch Noto fonts
	@mkdir -p cache/noto
	@$(CURL) $(CURL_OPTS) https://noto-website.storage.googleapis.com/pkgs/Noto-unhinted.zip | \
	    $(BSDTAR) -xf- --cd cache/noto
.SECONDARY: cache/noto/NotoSans-Regular.ttf

cache/encoding/README.md:
	@echo fetch Encoding spec
	@$(CURL) $(CURL_OPTS) https://github.com/whatwg/encoding/archive/master.zip | \
	    $(BSDTAR) -xf- --cd cache/
	@mv cache/encoding-master cache/encoding
.SECONDARY: cache/encoding

cache/latex.xml:
	@echo create $@
	@$(CURL) $(CURL_OPTS) http://www.w3.org/Math/characters/unicode.xml > cache/latex.xml
	@$(CURL) $(CURL_OPTS) http://www.w3.org/Math/characters/charlist.dtd > cache/charlist.dtd

cache/codepoints.net:
	@echo fetch codepoints.net repo
	@$(CURL) $(CURL_OPTS) https://github.com/Codepoints/Codepoints.net/archive/master.zip | \
	    $(BSDTAR) -xf- --cd cache/
	@mv cache/Codepoints.net-master cache/codepoints.net

cache/fonts:
	@mkdir -p $@

cache/fonts/Symbola.ttf: cache/fonts
	@echo download font Symbola
	@$(CURL) $(CURL_OPTS) http://users.teilar.gr/~g1951d/Symbola.zip | \
	    $(BSDTAR) -xf- --cd cache/fonts

cache/fonts/Aegean.ttf: cache/fonts
	@echo download font Aegean
	@$(CURL) $(CURL_OPTS) http://users.teilar.gr/~g1951d/AegeanFonts.zip | \
	    $(BSDTAR) -xf- --cd cache/fonts

cache/fonts/HANNOMB.ttf: cache/fonts
	@echo download font Han Nom B
	@$(CURL) $(CURL_OPTS) https://downloads.sourceforge.net/project/vietunicode/hannom/hannom%20v2005/hannomH.zip | \
	    $(BSDTAR) -xf- --cd cache/fonts
	@mv "cache/fonts/HAN NOM B.ttf" "$@"

cache/fonts/HanaMinA.ttf: cache/fonts
	@echo download font Hanazono
	@$(CURL) $(CURL_OPTS) http://rwthaachen.dl.osdn.jp/hanazono-font/64385/hanazono-20160201.zip | \
	    $(BSDTAR) -xf- --cd cache/fonts

cache/fonts/HanaMinB.ttf: cache/fonts/HanaMinA.ttf

cache/fonts/damase_v.2.ttf: cache/fonts
	@echo download font damase
	@$(CURL) $(CURL_OPTS) http://www.wazu.jp/downloads/damase_v.2.zip | \
	    $(BSDTAR) -xf- --cd cache/fonts

cache/fonts/Symbola.svg \
cache/fonts/Aegean.svg \
cache/fonts/HANNOMB.svg \
cache/fonts/HanaMinA.svg \
cache/fonts/HanaMinB.svg \
cache/fonts/damase_v.2.svg:
cache/fonts/%.svg: cache/fonts/%.ttf
	@echo convert $(notdir $<) to SVG
	@$(FONTFORGE) -quiet -lang=ff -script bin/ttf_to_svg.ff "$<"
	@sed -i 's/ unicode="&#x\(e01[0-9a-f]\|fe0\)[0-9a-f];"//g' "$@"


sql/30_ucd.sql: cache/ucd.all.flat.xml
	@echo create $@
	@< $< $(PYTHON) bin/ucd_to_sql.py > $@

sql/31_htmlentities.sql: cache/htmlentities.json
	@echo create $@
	@cat $< | \
	    $(JQ) -r '. as $$orig | keys[] | { n: ., o: $$orig[.].codepoints } | select( ( .o | length ) == 1 ) | "INSERT INTO codepoint_alias (cp, alias, `type`) VALUES (" + (.o[0] | tostring) + ", \"" + .n + "\", \"html\");"' \
	    > $@

sql/32_confusables.sql: cache/confusables.txt
	@echo create $@
	@true > $@
	@cat $< | \
	    sed -e 1d -e '/^#/d' -e '/^\s*$$/d' | \
	    sed 's/\s*;\s*MA\s.\+//' | \
	    sed 's/\s*;\s*/;/' | \
	    while read line; do \
	        $(PYTHON) bin/confusables_to_sql.py "$$line" >> $@ ; \
	    done

# parallelization: `nl` prefixes each filename with a number, xargs consumes
# the number and the filename with "-n 2" and makes Saxon create a tmp file
# with the number attached. Then those files get cat'ed into the target.
sql/33_images.sql: cache/noto/NotoSans-Regular.svg
	@echo create $@
	@ls -1 cache/noto/Noto*.svg | \
	    nl | \
	    xargs -n 2 -P 0 sh -c '$(SAXON) -s "$$1" -xsl bin/font2sql.xsl > "$@.$$0"'
	@cat "$@".?* > $@ && /bin/rm "$@".?*

sql/34_aliases.sql: cache/unicode/ReadMe.txt
	@echo create $@
	@$(PYTHON) bin/alias_to_sql.py > $@

sql/35_blocks.sql: cache/unicode/ReadMe.txt
	@echo create $@
	@sed -n '/^[0-9A-F]/p' cache/unicode/Blocks.txt | \
	    sed 's/\([0-9A-F]\+\)\.\.\([0-9A-F]\+\); \?\(.\+\)$$/\3\x00\1\x00\2/' | \
	    tr '\n' '\0' | \
	    xargs -0 -n 3 sh -c 'printf "INSERT INTO blocks (name, first, last) VALUES ('"'%s'"', %s, %s);\n" "$$0" "$$(echo $$1| tr a-f A-F | sed "s/^/ibase=16;/" | bc)" "$$(echo $$2| tr a-f A-F | sed "s/^/ibase=16;/" | bc)"' \
	    > $@

sql/36_encodings.sql: cache/encoding/README.md
	@echo create $@
	@true > $@
	@for enc in cache/encoding/index-*.txt; do \
	    $(PYTHON) bin/encoding_to_sql.py $$enc >> $@; \
	done

sql/37_latex.sql: cache/latex.xml
	@echo create $@
	@$(SAXON) -s "$<" -xsl bin/latex_to_sql.xsl > "$@"

sql/38_emojis.sql: cache/emoji-data.txt
	@echo create $@
	@sed -n '/^[0-9A-F]/s/\s*#.*//p' $< | \
	    sed 's/^\([A-F0-9]\+\) /\1..\1 /' | \
	    sed 's/\s*;\s*/ /' | sed 's/\.\./ /' | \
	    xargs -n 3 sh -c 'for x in $$(seq $$(echo ibase=16\;$$0|bc) $$(echo ibase=16\;$$1|bc)); do echo UPDATE codepoints SET $$2=1 WHERE cp=$$x\;; done' \
	    > $@

# lines containing digraph definitions have a special format in the RFC. We
# grep for those lines, cut them with tr/xargs and printf a SQL statement from
# that data.
sql/40_digraphs.sql: cache/rfc1345.txt
	@echo create $@
	@true > $@
	@cat $< | \
	    sed -n '/^ [^ ]\{1,6\} \+[0-9A-Fa-f]\{4\}    [^ ].*$$/p' | \
	    sed 's/^ \([^ ]\{1,6\}\) \+\([0-9A-Fa-f]\{4\}\)    [^ ].*$$/\1\t\2/' | \
	    sed 's/'"'"'/\\'"'"'/g' | \
	    tr '\t\n' '\0' | \
	    xargs -0 -n 2 sh -c 'printf "INSERT INTO codepoint_alias (cp, alias, \`type\`) VALUES (%s, '"'"'%s'"'"', '"'"'digraph'"'"');\n" "$$(echo $$1| tr a-f A-F | sed s/^/ibase=16\;/ | bc)" "$$0"' > $@

# if I'd figure out how to handle quotes nested four levels deep, I could
# parallelize that recipe with `xargs -P 0 sh -c`.
sql/50_wp_codepoints_de.sql \
sql/50_wp_codepoints_en.sql \
sql/50_wp_codepoints_es.sql \
sql/50_wp_codepoints_pl.sql: \
sql/50_wp_codepoints_%.sql: cache/abstracts/%/0041
	@echo create $@
	@true > $@
	@for file in cache/abstracts/$*/*; do \
	    printf "INSERT INTO codepoint_abstract ( cp, abstract, lang ) VALUES ( %s, '%s', '%s' );\n" \
	        $$(basename $$file | tr a-f A-F | sed 's/^/ibase=16;/' | bc) \
	        "$$(sed "s/'/\\\\'/g" $$file)" \
	        "$*" \
	    >> $@; \
	done

sql/51_wp_scripts_en.sql:
	@echo create $@
	@true > $@
	@cat data/script_to_wikipedia.csv | \
	    while IFS= read -r line; do \
	        ( \
	        echo -n "INSERT INTO script_abstract ( sc, abstract, lang, src )VALUES ('"; \
	        echo -n "$${line%;*}"; \
	        echo -n "', '"; \
	        $(CURL) $(CURL_OPTS) 'https://en.wikipedia.org/w/api.php?action=query&redirects&format=json&prop=extracts&exintro&titles='$${line##*;} | \
	            $(JQ) -r '.query.pages[].extract' | \
	            sed "s/'/\\\\'/g"; \
	        echo  "', 'en', 'https://en.wikipedia.org/wiki/$${line##*;}');"; \
	        ) >> $@ ; \
	    done

sql/52_wp_blocks_en.sql:
	@echo create $@
	@true > $@
	@$(CURL) $(CURL_OPTS) 'https://en.wikipedia.org/w/api.php?action=query&list=categorymembers&cmtitle=Category:Unicode_blocks&format=json&cmlimit=500&cmprop=title&cmtype=page' | \
	    $(JQ) -r '.query.categorymembers[].title' | \
	    sed '/Unicode Block$$/d' | \
	    while IFS= read -r line; do \
	        ( \
	        echo -n "INSERT INTO block_abstract ( block, abstract, lang ) VALUES ('"; \
	        echo -n "$$line" | sed 's/ (Unicode [bB]lock)//'; \
	        echo -n "', '"; \
	        $(CURL) $(CURL_OPTS) "https://en.wikipedia.org/w/api.php?action=query&redirects&format=json&prop=extracts&exintro&titles="$$($(PYTHON) -c 'from urllib.parse import quote;print(quote('\""$$line"\"', safe=""))') | \
	            $(JQ) -r ".query.pages[].extract" | \
	            sed "s/'/\\\\'/g"; \
	        echo  "', 'en');"; \
	        ) >> $@ ; \
	    done

sql/60_font_Symbola.sql \
sql/60_font_Aegean.sql \
sql/60_font_HANNOMB.sql \
sql/60_font_HanaMinA.sql \
sql/60_font_HanaMinB.sql \
sql/60_font_damase_v.2.sql:
sql/60_font_%.sql: cache/fonts/%.svg
	$(SAXON) -s "$<" -xsl bin/font2sql.xsl > "$@"

sql/70_search_index.sql: cache/codepoints.net sql-static db-up
	@echo create $@
	@$(PYTHON) bin/create_search_index.py > $@

sql/71_font_order.sql: sql-static db-up
	@echo create $@
	@$(MYSQL) $(MYSQL_OPTS) $(DUMMY_DB) < bin/font_ordering.sql > $@


db-up: db-schema db-data-static
.PHONY: db-up

db-schema:
	@echo create db schema
	@if ! echo 'SHOW DATABASES LIKE "$(DUMMY_DB)";' | $(MYSQL) $(MYSQL_OPTS) | grep -q '$(DUMMY_DB)'; then \
	    ( echo 'CREATE DATABASE $(DUMMY_DB); use $(DUMMY_DB);' ; cat sql/0*.sql ) | $(MYSQL); \
	else \
	    echo 'Database $(DUMMY_DB) already exists. Use "make db-down" to delete a stale one.'; \
	fi
.PHONY: db-schema

db-data-static: sql-static
	@echo insert static data into db
	@ls sql/[1-5]*.sql | xargs -n 1 -P 0 -i sh -c '$(MYSQL) $(MYSQL_OPTS) $(DUMMY_DB) < {}'
	@# those files all access the codepoint_image table, so do them sequencially:
	@cat sql/60_font_*.sql | $(MYSQL) $(MYSQL_OPTS) $(DUMMY_DB)
.PHONY: db-data-static

db-data-dynamic: sql-dynamic
	@ls sql/7*.sql | xargs -n 1 -P 0 -i sh -c '$(MYSQL) $(MYSQL_OPTS) $(DUMMY_DB) < {}'
.PHONY: db-data-dynamic

db-down:
	@echo tear down db
	@echo 'DROP DATABASE IF EXISTS $(DUMMY_DB);' | $(MYSQL)
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
	    sql/38_emojis.sql \
	    sql/40_digraphs.sql \
	    sql/50_wp_codepoints_*.sql \
	    sql/51_wp_scripts_en.sql \
	    sql/52_wp_blocks_en.sql \
	    sql/60_font_*.sql \
	    sql/70_search_index.sql \
	    sql/71_font_order.sql \
	    cache/*
.PHONY: clean


virtualenv:
	@virtualenv -p /usr/bin/python3 ./virtualenv
	@./virtualenv/bin/pip install -r requirements.txt
.PHONY: virtualenv
