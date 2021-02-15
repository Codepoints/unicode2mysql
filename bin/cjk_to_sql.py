#!/usr/bin/python3

import re
from pathlib import Path
import sys
from scour.scour import scourString
from xml.parsers import expat


sql_template = (
    "INSERT INTO codepoint_image ( cp, font, width, height, image ) "
    "VALUES ( {}, 'Noto CJK', {}, {}, '{}') "
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


def parse_images(identifier, content, image_map):
    default_adv = 0
    ascent = 128
    descent = 128
    units_per_em = 2048
    def start_element(element, attrs):
        nonlocal default_adv, ascent, descent, units_per_em
        if element == 'font':
            default_adv = int(attrs.get('horiz-adv-x', default_adv))
            return None
        if element == 'font-face':
            ascent = int(attrs.get('ascent', ascent))
            descent = int(attrs.get('descent', descent))
            units_per_em = int(attrs.get('units_per_em', units_per_em))
            return None
        if element == 'glyph':
            try:
                cp = ord(attrs.get('unicode'))
            except TypeError:
                return None
            horiz_adv = int(attrs.get('horiz-adv-x', default_adv))
            width = int(attrs.get('horiz-adv-x', default_adv or units_per_em))
            height = abs(descent) + ascent
            glyph = {}
            glyph[identifier] = [
                cp,
                width,
                height,
                ('<svg xmlns="http://www.w3.org/2000/svg" id="U{:04X}" viewBox="0 0 {} {}">'
                    '<path transform="translate({}, {}) scale(1,-1)" d="{}"/>'
                 '</svg>').format(cp, width, height,
                     0 if horiz_adv else units_per_em / 2,
                     ascent, attrs.get('d', ''))
            ]
            if cp not in image_map:
                image_map[cp] = {}
            image_map[cp].update(glyph)
    p = expat.ParserCreate()
    p.StartElementHandler = start_element
    p.Parse(content)


def compose_images(image_map):
    for cp, initial_data in image_map.items():
        data = {}
        seen_images = []
        # condense list of possible images to the ones that actually differ
        for key, content in initial_data.items():
            image = content[3]
            if image in seen_images:
                continue
            data[key] = content
            seen_images.append(image)

        keys = list(data.keys())

        # no images at all: on to the next
        if not len(keys):
            continue

        # a single glyph: return it like all others
        if len(keys) == 1:
            print(sql_template.format(*data[keys[0]]))
            continue

        # differences between sc,tc,jp,hk? Animate between them
        joint_image = ''
        offset = 0
        width = 0
        height = 0
        for key, content in data.items():
            width = width if width > content[1] else content[1]
            height = height if height > content[2] else content[2]
            image = content[3]
            image = re.sub('id="U([^"]+)"', r'id="U\1{}"'.format(key), image)
            # the opacity values are a list of 0s and 1s. Each first and last
            # value in the list have to be the same, otherwise the animation
            # will jump. Solution: 2 times more opacity values than different
            # glyphs.
            opacity = ['0'] * len(keys) * 2
            opacity[offset] = '1'
            opacity[offset - 1] = '1'
            image = re.sub(
                '</svg>',
                '<animate attributeName="opacity" values="{}" dur="{}s" repeatCount="indefinite"/></svg>'.format(
                    ';'.join(opacity), len(keys)
                ),
                image)
            joint_image += image
            offset += 1
        joint_image = '<svg xmlns="http://www.w3.org/2000/svg" id="U{:04X}" viewBox="0 0 {} {}">{}</svg>'.format(
            cp,
            width,
            height,
            joint_image
        )
        print(sql_template.format(cp, width, height, joint_image))



def main(args):
    source_path = Path(args[0])

    image_map = {}

    if not source_path.is_dir():
        raise RuntimeError('{} is no folder'.format(source_path))

    for file_path in source_path.glob('NotoSansCJK??-Regular.svg'):
        with file_path.open() as f:
            content = f.read()
        identifier = re.sub('NotoSansCJK(..)-Regular.svg', r'\1', file_path.name)
        content = scourString(content, ScourOptions)
        parse_images(identifier, content, image_map)

    compose_images(image_map)


if __name__ == '__main__':
    main(sys.argv[1:])
