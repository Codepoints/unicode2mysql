-- vim: ft=mysql

--
-- CLDR annotations/tags for emojis and other characters
--

CREATE TABLE codepoint_annotation (
  cp         INTEGER NOT NULL REFERENCES codepoints(cp),
  annotation MEDIUMTEXT,
  `type`     VARCHAR(7) NOT NULL DEFAULT 'tag' REFERENCES prop_annotation_type(annotation_type),
  lang       VARCHAR(6) NOT NULL DEFAULT 'en'
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE INDEX codepoint_annotation_cp ON codepoint_annotation ( cp );
CREATE INDEX codepoint_annotation_cp_lang ON codepoint_annotation ( cp, lang );
