"""
filter Wikipedia HTML to be as concise and safe to use for our purpose as
possible

One central part is removing comments, because the WP API sometimes also sends
some profiling info in comments back.
"""

import sys
from lxml.html import fragment_fromstring, tostring
from lxml.html.clean import Cleaner

src = sys.stdin.read()
doc = fragment_fromstring('<div>%s</div>' % src)
cleaner = Cleaner(
    # allow_tags was derived from manually filtering
    # cat cache/abstracts/*/* | grep -ohiE '<[a-z0-9]+' | sort | uniq
    allow_tags=(
        'abbr', 'b', 'bdi', 'bdo', 'big', 'blockquote', 'br', 'center', 'cite',
        'code', 'dd', 'dfn', 'dl', 'dt', 'em', 'h2', 'i', 'kbd', 'li', 'math',
        'mfrac', 'mi', 'mn', 'mo', 'mover', 'mpadded', 'mroot', 'mrow', 'mspace',
        'msqrt', 'mstyle', 'msub', 'msubsup', 'msup', 'mtable', 'mtd', 'mtext',
        'mtr', 'munder', 'munderover', 'ol', 'p', 'pre', 'rp', 'rt', 'ruby', 's',
        'small', 'span', 'strong', 'sub', 'sup', 'time', 'tt', 'u', 'ul', 'var',
    ),
    safe_attrs_only=True,
    # safe_attrs was derived, too, by looking at what is currently used:
    # cat cache/abstracts/*/* | grep -ohiE ' [a-z0-9-]+' | sort | uniq
    # width and height are used in MathML context
    safe_attrs=('clear', 'dir', 'height', 'lang', 'title', 'width',),
    # kill_tags: The <annotation> tag is used by WP to add LaTeX metadata to
    # MathML. We do not need that.
    kill_tags=('annotation',))
print(tostring(cleaner.clean_html(doc), encoding='UTF-8').decode('UTF-8')[5:-6].strip() or '')
