-- vim: ft=mysql

CREATE TABLE search_index (
    cp     INTEGER(7) REFERENCES codepoints,
    text   TEXT
) CHARACTER SET utf8mb4;
CREATE FULLTEXT INDEX search_index_text ON search_index ( text );
