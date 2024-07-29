#!/usr/bin/python

import binascii, codecs, logging, ebcdic, sys

logger = logging.getLogger('enc')

encs = (
'ascii',
'big5',
'big5hkscs',
'cp037',
'cp273',
'cp424',
'cp437',
'cp500',
'cp720',
'cp737',
'cp775',
'cp850',
'cp852',
'cp855',
'cp856',
'cp857',
'cp858',
'cp860',
'cp861',
'cp862',
'cp863',
'cp864',
'cp865',
'cp866',
'cp869',
'cp874',
'cp875',
'cp932',
'cp949',
'cp950',
'cp1006',
'cp1026',
'cp1125',
'cp1140',
'cp1250',
'cp1251',
'cp1252',
'cp1253',
'cp1254',
'cp1255',
'cp1256',
'cp1257',
'cp1258',
'euc_jp',
'euc_jis_2004',
'euc_jisx0213',
'euc_kr',
'gb2312',
'gbk',
'gb18030',
'hz',
'iso2022_jp',
'iso2022_jp_1',
'iso2022_jp_2',
'iso2022_jp_2004',
'iso2022_jp_3',
'iso2022_jp_ext',
'iso2022_kr',
'latin_1',
'iso8859_2',
'iso8859_3',
'iso8859_4',
'iso8859_5',
'iso8859_6',
'iso8859_7',
'iso8859_8',
'iso8859_9',
'iso8859_10',
'iso8859_11',
'iso8859_13',
'iso8859_14',
'iso8859_15',
'iso8859_16',
'johab',
'koi8_r',
'koi8_t',
'koi8_u',
'kz1048',
'mac_cyrillic',
'mac_greek',
'mac_iceland',
'mac_latin2',
'mac_roman',
'mac_turkish',
'ptcp154',
'shift_jis',
'shift_jis_2004',
'shift_jisx0213',
) + tuple(ebcdic.codec_names)

batch = []

def print_batch():
    global batch
    print(('INSERT INTO codepoint_alias (cp, alias, `type`) VALUES {};').format(
        ','.join(
            '({}, \'{}\', \'enc:{}\')'.format(cp, encoded_value, enc)
                for cp, encoded_value, enc in batch)))
    batch = []

print('DELETE FROM codepoint_alias WHERE `type` LIKE "enc:%";')
for enc in encs:
    sys.stderr.write(f'{enc}\n')
    sys.stderr.flush()
    for cp in range(0x10FFFF):
        try:
            encoded_value = binascii.b2a_hex(
              codecs.encode(chr(cp), encoding=enc), ' ').decode('utf-8').upper()
        except UnicodeEncodeError:
            if cp == 0x85 and enc in ebcdic.codec_names and codecs.encode('\n', encoding=enc) == b'\x25':
                # fix problem in ebcdic library where U+0085 and U+000A are
                # mixed up in place 0x15
                batch.append((cp, '15', enc))
            else:
                logger.debug('%s(%s)', enc, cp)
        except Exception as e:
            logger.warning('%s(%s)' % (enc, cp))
            raise
        else:
            batch.append((cp, encoded_value, enc))
            if len(batch) == 500:
                print_batch()
print_batch()
