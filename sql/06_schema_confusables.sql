-- vim: ft=mysql

--
-- other codepoints to be confusable with this
--
CREATE TABLE codepoint_confusables (
  id       INTEGER(7) NOT NULL,
  cp       INTEGER(7) NOT NULL REFERENCES codepoints,
  other    INTEGER(7) NOT NULL REFERENCES codepoints,
  `order`  INTEGER NOT NULL DEFAULT 1,
  UNIQUE ( id, cp, other, `order` )
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE INDEX codepoint_confusables_cp ON codepoint_confusables ( cp );
CREATE INDEX codepoint_confusables_other ON codepoint_confusables ( other );
