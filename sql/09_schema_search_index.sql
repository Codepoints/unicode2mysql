-- vim: ft=mysql

CREATE TABLE search_index (
    cp     INTEGER(7) REFERENCES codepoints,
    term   VARCHAR(255),
    weight INTEGER(2) DEFAULT 1
) CHARACTER SET utf8mb4;
CREATE INDEX search_index_term ON search_index ( term );
