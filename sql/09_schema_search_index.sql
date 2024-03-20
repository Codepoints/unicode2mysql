-- vim: ft=mysql

--
-- full-text search index
--

CREATE TABLE search_index (
    cp      INTEGER NOT NULL REFERENCES codepoints(cp),
    text    TEXT,
    version VARCHAR(127) NOT NULL DEFAULT '00000000',
    CONSTRAINT search_index_unique_cp UNIQUE (cp)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE FULLTEXT INDEX search_index_text ON search_index ( text );
