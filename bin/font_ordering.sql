SELECT
    CONCAT(
        'INSERT INTO font_order ( `order`, font, first, last ) VALUES (',
        @row := @row + 1,
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
    ) p,
    ( SELECT @row := 0 ) r
;
