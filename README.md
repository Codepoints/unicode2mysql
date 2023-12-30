# Take the Internet and Mash It into a MySQL Database to Power Codepoints.net

:arrow_up: basically the tl;dr: of what this project does.

## Sources:

* The Unicode data at http://unicode.org/Public
    * the UCD as XML file
    * the UCD as plain text files
    * the emoji data files
    * the “confusables” data file
* Wikipedia entries of single characters, scripts and blocks
* The RFC 1345
* Encoding information from the WHATWG
* HTML entities from WHATWG
* LaTeX aliases from the MathML spec at the W3C
* The Noto fonts by Google

## Running it yourself

Maybe your best bet is to use the `Dockerfile` in this repo. You'll need
a ton of tools to get this thing running, amongst them MariaDB, cURL,
the Saxon XSLT processor (and hence Java), bsdtar and GNU make as well
as a full-featured Python 3 `virtualenv` with the packages from
`requirements.txt`.

It's quite unprobable, that this will run under anything else than a
Debian-based Linux system, mostly due to the command-line fu that is
used in the `Makefile`.

You also need the `mysql` cli program configured so that it can create
and drop databases.

If you have such a system, all you need to do is typing

    make -j -O

and waiting. The rest will be done automagically for you.

**Attention:** The Makefile tries to do as much things as possible in parallel.
This means your system might get unresponsive under some circumstances. On the
bright side, this means that all SQL files now get built on my eight core
machine in under one hour (including downloads) where previously it had to run
through the night just to create the search index _or_ the images.

## Resulting files:

* `sql/01_schema_props.sql`: Create lookup tables for allowed property values.
    Basically a bunch of `ENUM` definitions for some properties in the
    `codepoints` table.
* `sql/02_schema_codepoints.sql`: Create the main `codepoints` table that holds
    most of the UCD data, as well as some helper tables.
* `sql/03_schema_abstracts.sql`: Create tables for Wikipedia abstracts of
    codepoints, blocks and scripts.
* `sql/04_schema_planes_blocks.sql`: Create tables for Unicode planes and
    blocks.
* `sql/05_schema_scripts.sql`: Create tables for scripts.
* `sql/06_schema_confusables.sql`: Create a table for confusables.
* `sql/07_schema_images.sql`: Create a table to store images of glyphs, mostly
    derived from the Noto Sans fonts, as well as a helper table to determine,
    which glyph to select.
* `sql/08_schema_cldr.sql`: Create CLDR info tables, currently only annotations
    for emojis.
* `sql/09_schema_search_index.sql`: Create the search index table.
* `sql/10_ucd.sql`: This is the most important import, putting basically all
    info derived from the UCD XML file from Unicode into the DB.
* `sql/11_wellknown_aliases.sql`: Add some well-known aliases, e.g., for ASCII
    control characters.
* `sql/11_wellknown_scripts.sql`: Add names and IDs of ISO-defined scripts.
* `sql/31_htmlentities.sql`: Add HTML entities as aliases.
* `sql/32_confusables.sql`: Add information about which characters can be
    confused with one another.
* `sql/33_images.sql`: Add the glyphs of the Noto Sans fonts as SVG images.
* `sql/34_aliases.sql`: Add alias names from the Unicode standard.
* `sql/35_blocks.sql`: Add names and boundaries of Unicode blocks.
* `sql/36_encodings.sql`: Add character representations in other encodings.
* `sql/37_latex.sql`: Add LaTeX representations for some characters.
* `sql/38_emojis.sql`: Add emoji properties.
* `sql/39_emoji_annotations_LANG.sql`: Add emoji annotations from CLDR for
    each supported language.
* `sql/40_digraphs.sql`: Add RFC 1345 digraph representations.
* `sql/41_namedsequences.sql`: Add Unicode named sequences as described in
    [TR 34](https://www.unicode.org/reports/tr34/).
* `sql/50_wp_codepoints_de.sql`: Add Wikipedia abstracts for single characters
    (German).
* `sql/50_wp_codepoints_en.sql`: Add Wikipedia abstracts for single characters
    (English). This results in a huge number of HTTP requests to the Wikipedia
    API.
* `sql/50_wp_codepoints_es.sql`: Add Wikipedia abstracts for single characters
    (Spanish).
* `sql/50_wp_codepoints_pl.sql`: Add Wikipedia abstracts for single characters
    (Polish). This might fail, since the site hosting Wikipedia dumps will
    impose some rate limiting from time to time letting the fourth request in a
    short time window fail. Try re-running the Makefile after removing the
    dump from the cache folder.
* `sql/51_wp_scripts_en.sql`: Add Wikipedia abstracts for scripts. The mapping
    is done based on `data/script_to_wikipedia.csv`.
* `sql/52_wp_blocks_en.sql`: Add Wikipedia abstracts for Unicode blocks. The
    information is heuristically fetched by examining the entries in the
    “Unicode block” category.
* `sql/60_font_*.sql`: Add glyphs from a font in the form of SVG graphics.
* `sql/70_search_index.sql`: Create the search index. This needs _all_ the
    previous files being generated and put into a temporary MySQL database.
* `sql/71_font_order.sql`: Create a priority order for which font's glyph to
    use. This also needs a running database containing the info from
    `sql/33_images.sql`. The priority is determined simply by how much of a
    block a given font covers.

## Contributing

Thanks for considering to contribute! As of now I haven't made up my mind how
exactly to go forth, e.g., with schema changes from new Unicode versions. The
best might be, if you open a new issue first so that we can discuss how your
contribution might look like.
