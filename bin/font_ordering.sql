-- Generate SQL statements. The idea is to look, which font has the greatest
-- coverage of a block and to choose this one for rendering the block's
-- glyphs. On a draw, Noto Sans should win, Unifont should be a last resort.
SET @row := 0;
SELECT
    CONCAT(
        'INSERT INTO font_order ( `order`, font, first, last ) VALUES (',
        CASE
            WHEN font LIKE 'Unifont%' THEN row + 100
            WHEN font LIKE 'Noto Sans CJK%' THEN row + 50
            WHEN font LIKE 'Noto Sans%' THEN row - 100
            ELSE row
        END,
        ', \'',
        font,
        '\', ',
        first,
        ', ',
        last,
        ');'
    ) AS '-- data'
FROM
    (
        SELECT
            @row := @row + 1 AS row,
            COUNT(name) AS count,
            font,
            first,
            last
        FROM
            blocks,
            codepoint_image
        WHERE
            first <= cp
            AND
            last >= cp
        GROUP BY
            font, name
        ORDER BY
            first, count DESC
    ) AS p
ORDER BY row
;
