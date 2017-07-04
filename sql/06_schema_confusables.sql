-- vim: ft=mysql

--
-- other codepoints to be confusable with this
--
CREATE TABLE codepoint_confusables (
  id       INTEGER PRIMARY KEY NOT NULL,
  cp       INTEGER(7) NOT NULL REFERENCES codepoints,
  other    INTEGER(7) NOT NULL REFERENCES codepoints,
  `order`  INTEGER NOT NULL DEFAULT 1
);
CREATE INDEX codepoint_confusables_cp ON codepoint_confusables ( cp );
CREATE INDEX codepoint_confusables_other ON codepoint_confusables ( other );
