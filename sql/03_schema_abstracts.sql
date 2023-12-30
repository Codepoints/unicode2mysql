-- vim: ft=mysql

--
-- Wikipedia abstract of a codepoint
--
-- We do not reference the codepoints table, since we have abstracts for PU
-- code points, too.
--
CREATE TABLE codepoint_abstract (
  cp       INTEGER NOT NULL,
  abstract BLOB,
  lang     VARCHAR(6) NOT NULL DEFAULT 'en',
  src      VARCHAR(255), -- explicitly give a source, since the Wikipedia name
                         -- might not be obvious.
  UNIQUE ( cp, lang )
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE INDEX codepoint_abstract_cp ON codepoint_abstract ( cp );
CREATE INDEX codepoint_abstract_cp_lang ON codepoint_abstract ( cp, lang );
