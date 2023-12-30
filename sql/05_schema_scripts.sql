-- vim: ft=mysql

--
-- Scripts defined by their ISO name
--
CREATE TABLE scripts (
  iso  VARCHAR(4) PRIMARY KEY NOT NULL,
  name VARCHAR(255)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;


--
-- The script the codepoint belongs to
--
-- `primary` is true if the script is referenced in the `sc` property of the
-- codepoint, false if it's referenced in the `scx` property.
--
CREATE TABLE codepoint_script (
  cp        INTEGER NOT NULL REFERENCES codepoints(cp),
  sc        VARCHAR(4) NOT NULL REFERENCES scripts(iso),
  `primary` BOOLEAN DEFAULT 1,
  UNIQUE ( cp, sc )
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE INDEX codepoint_script_cp ON codepoint_script ( cp );
CREATE INDEX codepoint_script_sc ON codepoint_script ( sc );

--
-- Wikipedia abstract of a script
--
CREATE TABLE script_abstract (
  sc       VARCHAR(4) NOT NULL REFERENCES scripts(iso),
  abstract BLOB,
  lang     VARCHAR(6) NOT NULL DEFAULT 'en',
  src      VARCHAR(255), -- explicitly give a source, since the Wikipedia name
                         -- might not be obvious.
  UNIQUE ( sc, lang )
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE INDEX script_abstract_sc ON script_abstract ( sc );
CREATE INDEX script_abstract_sc_lang ON script_abstract ( sc, lang );
