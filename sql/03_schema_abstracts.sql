-- vim: ft=mysql

--
-- Wikipedia abstract of a codepoint
--
CREATE TABLE codepoint_abstract (
  cp       INTEGER REFERENCES codepoints,
  abstract BLOB,
  lang     VARCHAR(6) DEFAULT 'en',
  UNIQUE ( cp, lang )
) CHARACTER SET utf8mb4;
CREATE INDEX codepoint_abstract_cp ON codepoint_abstract ( cp );
CREATE INDEX codepoint_abstract_cp_lang ON codepoint_abstract ( cp, lang );

--
-- Wikipedia abstract of a Unicode block
--
CREATE TABLE block_abstract (
  block    VARCHAR(255) REFERENCES blocks,
  abstract BLOB,
  lang     VARCHAR(6) DEFAULT 'en',
  UNIQUE ( block, lang )
) CHARACTER SET utf8mb4;
CREATE INDEX block_abstract_block ON block_abstract ( block );
CREATE INDEX block_abstract_block_lang ON block_abstract ( block, lang );

--
-- Wikipedia abstract of a script
--
CREATE TABLE script_abstract (
  sc       VARCHAR(4) REFERENCES scripts,
  abstract BLOB,
  lang     VARCHAR(6) DEFAULT 'en',
  src      VARCHAR(255), -- explicitly give a source, since the Wikipedia name
                         -- might not be obvious.
  UNIQUE ( sc, lang )
) CHARACTER SET utf8mb4;
CREATE INDEX script_abstract_sc ON script_abstract ( sc );
CREATE INDEX script_abstract_sc_lang ON script_abstract ( sc, lang );
