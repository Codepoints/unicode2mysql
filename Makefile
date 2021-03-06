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

EMOJI_VERSION := 13.1

LANGUAGES := de en es pl

WIKIPEDIA_DUMP_MIRROR := https://dumps.wikimedia.your.org

DUMMY_DB := codepoints_dummy

UNIFONT_VERSION := 13.0.06


all: sql
.PHONY: all

sql: sql-static sql-dynamic
.PHONY: sql

sql-static: \
	sql/30_ucd.sql \
	sql/31_htmlentities.sql \
	sql/32_confusables.sql \
	sql/34_aliases.sql \
	sql/35_blocks.sql \
	sql/36_encodings.sql \
	sql/37_latex.sql \
	sql/39_emoji_annotations_de.sql \
	sql/39_emoji_annotations_en.sql \
	sql/39_emoji_annotations_es.sql \
	sql/39_emoji_annotations_pl.sql \
	sql/40_digraphs.sql \
	sql/41_namedsequences.sql \
	sql/50_wp_codepoints_de.sql \
	sql/50_wp_codepoints_en.sql \
	sql/50_wp_codepoints_es.sql \
	sql/50_wp_codepoints_pl.sql \
	sql/51_wp_scripts.sql \
	sql/52_wp_blocks.sql \
	sql-fonts
.PHONY: sql-static

sql-fonts: \
	sql/60_font_noto.sql \
	sql/60_font_noto_emoji.sql \
	sql/60_font_noto_cjk.sql \
	sql/61_font_HanaMinA.sql \
	sql/61_font_HanaMinB.sql \
	sql/61_font_BabelStoneKhitanSmallLinear.sql \
	sql/61_font_ScheherazadeNew-Regular.sql \
	sql/62_font_unifont.sql \
	sql/62_font_unifont_upper.sql
	#sql/61_font_HANNOMB.sql \
	#sql/61_font_damase_v.2.sql \
	#sql/61_font_KikakuiSansPro.ot.sql \
	#sql/61_font_SuttonSignWriting8.sql \
	#sql/61_font_TangutYinchuan.sql \
	#sql/61_font_BabelStoneMarchen.sql
.PHONY: sql-fonts

sql-dynamic: sql/70_search_index.sql # sql/71_font_order.sql
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

cache/unicode/NamedSequences.txt: cache/unicode/ReadMe.txt
.SECONDARY: cache/unicode/NamedSequences.txt

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

# grep localized to use UTF-8 will filter all titles with a single UTF-8
# character.
#
# xargs takes over parallelization. 3 parallel calls, each with a 0.01 s sleep
# should make sure, that we don't exceed the current limit of 200 API calls per
# second
#
# bin/char_to_abstract.sh calls the WP API and stores the excerpt.
cache/abstracts/de/0041 \
cache/abstracts/en/0041 \
cache/abstracts/es/0041 \
cache/abstracts/pl/0041: \
cache/abstracts/%/0041: cache/%wiki-latest-all-titles-in-ns0.gz
	@echo create $@
	@mkdir -p cache/abstracts/$*
	@zcat cache/$*wiki-latest-all-titles-in-ns0.gz | \
		LANG=C.UTF-8 grep '^.$$' | \
		CURL='$(CURL)' CURL_OPTS='$(CURL_OPTS)' JQ='$(JQ)' SRCLANG="$*" \
			xargs -d '\n' -i -n 1 -P 3 bin/char_to_abstract.sh '{}'
.SECONDARY: cache/abstracts/de/0041
.SECONDARY: cache/abstracts/en/0041
.SECONDARY: cache/abstracts/es/0041
.SECONDARY: cache/abstracts/pl/0041

cache/noto/NotoSans/NotoSans-Regular.svg: cache/noto/NotoSans/NotoSans-Regular.ttf
	@echo convert Noto fonts to SVG
	@for font in cache/noto/*/*-Regular.ttf cache/noto/NotoSans*-Regular.otf; do \
	    $(FONTFORGE) -quiet -lang=ff -script bin/ttf_to_svg.ff "$$font"; \
	    sed -i 's/ unicode="&#x\(e01[0-9a-f]\|fe0\)[0-9a-f];"//g' "$$(echo "$$font" | sed 's/\.[ot]tf$$/.svg/')"; \
	done

cache/noto/NotoSans/NotoSans-Regular.ttf:
	@echo fetch Noto fonts
	@mkdir -p cache
	@docker run --rm \
		--volume "$$PWD":/src \
		--user "$$(id -u)" \
		jgsqware/svn-client \
		export --force --quiet \
		https://github.com/googlefonts/noto-fonts/trunk/unhinted/ttf \
		cache/noto
	@$(CURL) $(CURL_OPTS) https://github.com/googlefonts/noto-cjk/raw/main/NotoSansCJKsc-Regular.otf > cache/noto/NotoSansCJKsc-Regular.otf
	@$(CURL) $(CURL_OPTS) https://github.com/googlefonts/noto-cjk/raw/main/NotoSansCJKtc-Regular.otf > cache/noto/NotoSansCJKtc-Regular.otf
	@$(CURL) $(CURL_OPTS) https://github.com/googlefonts/noto-cjk/raw/main/NotoSansCJKkr-Regular.otf > cache/noto/NotoSansCJKkr-Regular.otf
	@$(CURL) $(CURL_OPTS) https://github.com/googlefonts/noto-cjk/raw/main/NotoSansCJKjp-Regular.otf > cache/noto/NotoSansCJKjp-Regular.otf
	@$(CURL) $(CURL_OPTS) https://github.com/googlefonts/noto-cjk/raw/main/NotoSansCJKhk-Regular.otf > cache/noto/NotoSansCJKhk-Regular.otf
	@docker run --rm \
		--volume "$$PWD":/src \
		--user "$$(id -u)" \
		jgsqware/svn-client \
		export --force --quiet \
		https://github.com/googlefonts/noto-emoji/trunk/svg \
		cache/noto/emoji
.SECONDARY: cache/noto/NotoSans/NotoSans-Regular.ttf

cache/encoding/README.md:
	@echo fetch Encoding spec
	@$(CURL) $(CURL_OPTS) https://github.com/whatwg/encoding/archive/main.zip | \
	    $(BSDTAR) -xf- --cd cache/
	@mv cache/encoding-main cache/encoding
.SECONDARY: cache/encoding

cache/latex.xml: cache/charlist.dtd
	@echo create $@
	@$(CURL) $(CURL_OPTS) http://www.w3.org/Math/characters/unicode.xml > $@
.SECONDARY: cache/latex.xml

cache/charlist.dtd:
	@echo create $@
	@$(CURL) $(CURL_OPTS) http://www.w3.org/Math/characters/charlist.dtd > $@
.SECONDARY: cache/charlist.dtd

cache/codepoints.net/README.md:
	@echo fetch codepoints.net repo
	@$(CURL) $(CURL_OPTS) https://github.com/Codepoints/Codepoints.net/archive/master.zip | \
	    $(BSDTAR) -xf- --cd cache/
	@mv cache/Codepoints.net-master cache/codepoints.net
.SECONDARY: cache/codepoints.net/README.md

cache/cldr_annotations_de.xml \
cache/cldr_annotations_en.xml \
cache/cldr_annotations_es.xml \
cache/cldr_annotations_pl.xml:
cache/cldr_annotations_%.xml:
	@echo create $@
	@$(CURL) $(CURL_OPTS) \
		"https://raw.githubusercontent.com/unicode-org/cldr/master/common/annotations/$*.xml" | \
		sed '/<!DOCTYPE/d' > "$@"
.SECONDARY: cache/cldr_annotations_*.xml

cache/fonts/HANNOMB.ttf:
	@echo download font Han Nom B
	@$(CURL) $(CURL_OPTS) https://downloads.sourceforge.net/project/vietunicode/hannom/hannom%20v2005/hannomH.zip | \
	    $(BSDTAR) -xf- --cd cache/fonts
	@mv "cache/fonts/HAN NOM B.ttf" "$@"
.SECONDARY: cache/fonts/HANNOMB.ttf

cache/fonts/HanaMinA.ttf:
	@echo download font Hanazono
	@$(CURL) $(CURL_OPTS) 'https://de.osdn.net/frs/redir.php?m=rwthaachen&f=hanazono-font%2F68253%2Fhanazono-20170904.zip' | \
	    $(BSDTAR) -xf- --cd cache/fonts
.SECONDARY: cache/fonts/HanaMinA.ttf

cache/fonts/HanaMinB.ttf: cache/fonts/HanaMinA.ttf
.SECONDARY: cache/fonts/HanaMinB.ttf

cache/fonts/damase_v.2.ttf:
	@echo download font damase
	@$(CURL) $(CURL_OPTS) http://www.wazu.jp/downloads/damase_v.2.zip | \
	    $(BSDTAR) -xf- --cd cache/fonts
.SECONDARY: cache/fonts/damase_v.2.ttf

cache/fonts/KikakuiSansPro.ot.ttf:
	@echo download font KikakuiSansPro
	@$(CURL) $(CURL_OPTS) https://github.com/athinkra/mende-kikakui/raw/master/fonts/src/ot/KikakuiSansPro.ot.ttf > $@
.SECONDARY: cache/fonts/KikakuiSansPro.ot.ttf

cache/fonts/SuttonSignWriting8.ttf:
	@echo download font SuttonSignWriting
	@$(CURL) $(CURL_OPTS) https://github.com/Slevinski/signwriting_2010_fonts/raw/master/fonts/SuttonSignWriting8.ttf > $@
.SECONDARY: cache/fonts/SuttonSignWriting8.ttf

cache/fonts/TangutYinchuan.ttf:
	@echo download font TangutYinchuan
	@$(CURL) $(CURL_OPTS) https://babelstone.co.uk/Fonts/Download/TangutYinchuan.ttf > $@
.SECONDARY: cache/fonts/TangutYinchuan.ttf

cache/fonts/BabelStoneMarchen.ttf:
	@echo download font BabelStoneMarchen
	@$(CURL) $(CURL_OPTS) https://www.babelstone.co.uk/Fonts/Download/BabelStoneMarchen.ttf > $@
.SECONDARY: cache/fonts/BabelStoneMarchen.ttf

cache/fonts/BabelStoneKhitanSmallLinear.ttf:
	@echo download font BabelStoneKhitanSmallLinear
	@$(CURL) $(CURL_OPTS) https://babelstone.co.uk/Fonts/Download/BabelStoneKhitanSmallLinear.ttf > $@
.SECONDARY: cache/fonts/BabelStoneKhitanSmallLinear.ttf

cache/fonts/unifont.ttf:
	@echo download font Unifont
	@$(CURL) $(CURL_OPTS) http://unifoundry.com/pub/unifont/unifont-$(UNIFONT_VERSION)/font-builds/unifont-$(UNIFONT_VERSION).ttf > $@
.SECONDARY: cache/fonts/unifont.ttf

cache/fonts/unifont_upper.ttf:
	@echo download font Unifont Upper
	@$(CURL) $(CURL_OPTS) http://unifoundry.com/pub/unifont/unifont-$(UNIFONT_VERSION)/font-builds/unifont_upper-$(UNIFONT_VERSION).ttf > $@
.SECONDARY: cache/fonts/unifont_upper.ttf

cache/fonts/ScheherazadeNew-Regular.ttf:
	@$(CURL) $(CURL_OPTS) 'https://software.sil.org/downloads/r/scheherazade/ScheherazadeNew-3.000.zip' | \
	    $(BSDTAR) -xf- --cd cache/fonts '*-Regular.ttf'
	@mv 'cache/fonts/ScheherazadeNew-3.000/ScheherazadeNew-Regular.ttf' cache/fonts/
	@rmdir 'cache/fonts/ScheherazadeNew-3.000'
.SECONDARY: cache/fonts/ScheherazadeNew-Regular.ttf


cache/fonts/HANNOMB.svg \
cache/fonts/HanaMinA.svg \
cache/fonts/HanaMinB.svg \
cache/fonts/damase_v.2.svg \
cache/fonts/KikakuiSansPro.ot.svg \
cache/fonts/SuttonSignWriting8.svg \
cache/fonts/TangutYinchuan.svg \
cache/fonts/BabelStoneMarchen.svg \
cache/fonts/BabelStoneKhitanSmallLinear.svg \
cache/fonts/ScheherazadeNew-Regular.svg \
cache/fonts/unifont.svg \
cache/fonts/unifont_upper.svg:
cache/fonts/%.svg: cache/fonts/%.ttf
	@echo convert $(notdir $<) to SVG
	@$(FONTFORGE) -quiet -lang=ff -script bin/ttf_to_svg.ff "$<"
	@sed -i 's/ unicode="&#x\(e01[0-9a-f]\|fe0\)[0-9a-f];"//g' "$@"
.SECONDARY: \
	cache/fonts/HANNOMB.svg \
	cache/fonts/HanaMinA.svg \
	cache/fonts/HanaMinB.svg \
	cache/fonts/damase_v.2.svg \
	cache/fonts/KikakuiSansPro.ot.svg \
	cache/fonts/SuttonSignWriting8.svg \
	cache/fonts/TangutYinchuan.svg \
	cache/fonts/BabelStoneMarchen.svg \
	cache/fonts/BabelStoneKhitanSmallLinear.svg \
	cache/fonts/ScheherazadeNew-Regular.svg \
	cache/fonts/unifont.svg \
	cache/fonts/unifont_upper.svg


sql/30_ucd.sql: cache/ucd.all.flat.xml cache/unicode/ReadMe.txt
	@echo create $@
	@$(PYTHON) bin/ucd_to_sql.py "$<" "cache/unicode/NameAliases.txt" > $@

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
#
# TODO: This is a bit inefficient. It'd be better, if we could store, which
# cps we've already handled. Currently double cps both end in the SQL file,
# but the latter will be simply ignored.
sql/60_font_noto.sql: cache/noto/NotoSans/NotoSans-Regular.svg
	@echo "create $@"
	@cat data/noto_loading_order.txt | \
		sed 's#^#cache/noto/#' | \
		nl | \
		xargs -n 2 -P 0 sh -c '$(SAXON) -s "$$1" -xsl bin/font2sql.xsl > "$@.$$0"'
	@cat "$@".?* > "$@" && /bin/rm "$@".?*

sql/60_font_noto_emoji.sql: cache/noto/NotoSans/NotoSans-Regular.svg
	@echo "create $@"
	@$(PYTHON) bin/emojis_to_sql.py cache/noto/emoji > "$@"

sql/60_font_noto_cjk.sql: cache/noto/NotoSans/NotoSans-Regular.svg
	@echo "create $@"
	@$(PYTHON) bin/cjk_to_sql.py cache/noto > "$@"

sql/34_aliases.sql: cache/unicode/ReadMe.txt
	@echo "create $@"
	@$(PYTHON) bin/alias_to_sql.py > $@

sql/35_blocks.sql: cache/unicode/ReadMe.txt
	@echo "create $@"
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

sql/39_emoji_annotations_de.sql \
sql/39_emoji_annotations_en.sql \
sql/39_emoji_annotations_es.sql \
sql/39_emoji_annotations_pl.sql:
sql/39_emoji_annotations_%.sql: cache/cldr_annotations_%.xml
	@echo create $@
	@$(SAXON) -s "$<" -xsl bin/cldrannotations_to_sql.xsl lang="$*" > "$@"

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

sql/41_namedsequences.sql: cache/unicode/NamedSequences.txt
	@echo create $@
	@cat $< | \
		sed -n '/^[A-Z]/p' | \
		while IFS= read -r line; do \
			NAME="$${line%;*}" ; \
			I=1 ; \
			for cp in $${line#*;}; do \
				printf "INSERT INTO namedsequences (cp, name, \`order\`) VALUES (CAST(0x%s AS UNSIGNED), '$$NAME', %s);\n" "$$cp" "$$I" ; \
				I=$$((I + 1)) ; \
			done ; \
		done > $@

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
	    printf "INSERT INTO codepoint_abstract ( cp, abstract, lang, src ) VALUES ( %s, '%s', '%s', '%s' );\n" \
	        $$(basename $$file | tr a-f A-F | sed 's/^/ibase=16;/' | bc) \
	        "$$(sed -n '2,$$p' $$file | sed "s/'/\\\\'/g")" \
	        "$*" \
	        "$$(sed -n 1p $$file | tr -d $$'\n')" \
	    >> $@; \
	done

sql/51_wp_scripts.sql:
	@echo create $@
	@CURL='$(CURL)' CURL_OPTS='$(CURL_OPTS)' JQ='$(JQ)' bin/wp_scripts_to_sql.sh "$@"

sql/52_wp_blocks.sql:
	@echo create $@
	@CURL='$(CURL)' CURL_OPTS='$(CURL_OPTS)' JQ='$(JQ)' bin/wp_blocks_to_sql.sh "$@"

sql/61_font_HANNOMB.sql \
sql/61_font_HanaMinA.sql \
sql/61_font_HanaMinB.sql \
sql/61_font_damase_v.2.sql \
sql/61_font_KikakuiSansPro.ot.sql \
sql/61_font_SuttonSignWriting8.sql \
sql/61_font_TangutYinchuan.sql \
sql/61_font_BabelStoneMarchen.sql \
sql/61_font_BabelStoneKhitanSmallLinear.sql \
sql/61_font_ScheherazadeNew-Regular.sql:
sql/61_font_%.sql: cache/fonts/%.svg
	@echo create $@
	@$(SAXON) -s "$<" -xsl bin/font2sql.xsl > "$@"

sql/62_font_unifont.sql \
sql/62_font_unifont_upper.sql:
sql/62_font_%.sql: cache/fonts/%.svg
	@echo create $@
	@$(SAXON) -s "$<" -xsl bin/font2sql.xsl > "$@"

sql/70_search_index.sql: cache/codepoints.net/README.md sql-static db-up
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
	    echo 'Database $(DUMMY_DB) already exists. Use "make db-down" to delete a stale one.' >&2; \
	fi
.PHONY: db-schema

# the 6[12]*.sql files all access the codepoint_image table, so we do them sequencially
db-data-static: db-schema sql-static
	@echo insert static data into db
	@if [ "$$(echo 'select count(*) from codepoints' | $(MYSQL) $(MYSQL_OPTS) -N $(DUMMY_DB))" == "0" ]; then \
	    ls sql/[1-5]*.sql | xargs -n 1 -P 0 -i sh -c '$(MYSQL) $(MYSQL_OPTS) --force $(DUMMY_DB) < {}'; \
	    cat sql/60_font_*.sql | $(MYSQL) $(MYSQL_OPTS) $(DUMMY_DB); \
	    cat sql/61_font_*.sql | $(MYSQL) $(MYSQL_OPTS) $(DUMMY_DB); \
	    cat sql/62_font_*.sql | $(MYSQL) $(MYSQL_OPTS) $(DUMMY_DB); \
	else \
	    echo 'Database $(DUMMY_DB) is already populated. Use "make db-down" to delete a stale one.' >&2; \
	fi
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
	    sql/34_aliases.sql \
	    sql/35_blocks.sql \
	    sql/36_encodings.sql \
	    sql/37_latex.sql \
	    sql/39_emoji_annotations_de.sql \
	    sql/39_emoji_annotations_en.sql \
	    sql/39_emoji_annotations_es.sql \
	    sql/39_emoji_annotations_pl.sql \
	    sql/40_digraphs.sql \
	    sql/41_namedsequences.sql \
	    sql/50_wp_codepoints_*.sql \
	    sql/51_wp_scripts.sql \
	    sql/52_wp_blocks.sql \
	    sql/60_font_*.sql \
	    sql/61_font_*.sql \
	    sql/62_font_*.sql \
	    sql/70_search_index.sql \
	    sql/71_font_order.sql \
	    cache/*
	@mkdir cache/fonts
	@touch cache/fonts/.gitignore
.PHONY: clean


virtualenv:
	@virtualenv -p /usr/bin/python3 ./virtualenv
	@./virtualenv/bin/pip install -r requirements.txt
.PHONY: virtualenv

find_missing_image_scripts:
	@echo 'SELECT count, iso, name FROM (SELECT COUNT(*) as count, sc AS iso FROM codepoints c LEFT JOIN codepoint_script s USING (cp) LEFT JOIN `codepoint_image` USING (cp) WHERE image IS NULL GROUP BY sc ORDER BY count DESC) x LEFT JOIN scripts USING (iso)' | \
		$(MYSQL) $(MYSQL_OPTS) $(DUMMY_DB)
.PHONY: find_missing_image_scripts
