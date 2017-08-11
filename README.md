# Take the Internet and Mash It into a MySQL Database to Power Codepoints.net

:arrow_up: basically the tl;dr: of what this project does.

## Sources:

* The Unicode data at http://unicode.org/Public
    * the UCD as XML file
    * the UCD as plain text files
    * the emoji data files
    * the "confusables" data file
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
