#!/usr/bin/python3

import re
from pathlib import Path
import sys
from scour.scour import scourString


sql_template = (
    "INSERT INTO codepoint_image ( cp, font, width, height, image ) "
    "VALUES ( {}, 'Noto Emoji', {}, {}, '{}') "
    "ON DUPLICATE KEY UPDATE cp=cp;\n")


class ScourOptions:
    strip_ids = True
    enable_viewboxing = True
    indent_type = 'none'
    newlines = False
    strip_xml_prolog = True
    remove_titles = True
    remove_descriptions = True
    remove_metadata = True
    strip_comments = True
    strip_xml_space_attribute = True


def main(args):
    source_path = Path(args[0])

    if not source_path.is_dir():
        raise RuntimeError('{} is no folder'.format(source_path))

    for file_path in source_path.glob('*.svg'):
        match = re.match(r'emoji_u([0-9a-f]+)\.svg$', file_path.name)
        if not match:
            continue
        hex = match[1]
        dec = int(hex, 16)
        with file_path.open() as f:
            content = f.read()
        content = scourString(content, ScourOptions)
        content = re.sub(' enable-background="[^"]*"', '', content)
        content = re.sub('<svg', '<svg id="U{}"'.format(hex.upper()), content, count=1)
        width = 128
        height = 128
        dimensions = re.match(
            '<svg[^>]* viewBox="(-?[0-9]+) (-?[0-9]+) (-?[0-9]+) (-?[0-9]+)"',
            content)
        if dimensions:
            width = int(dimensions[3]) - int(dimensions[1])
            height = int(dimensions[4]) - int(dimensions[2])
        print(sql_template.format(dec, width, height, content.replace("'", "''")))


if __name__ == '__main__':
    main(sys.argv[1:])
