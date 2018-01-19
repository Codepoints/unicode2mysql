-- vim: ft=mysql


--
-- CLDR annotations/tags for emojis
--
CREATE TABLE codepoint_annotation (
  cp         INTEGER NOT NULL REFERENCES codepoints,
  annotation MEDIUMTEXT,
  `type`     VARCHAR(127) NOT NULL DEFAULT 'tag' REFERENCES prop_annotation_type,
  lang       VARCHAR(6) NOT NULL DEFAULT 'en' -- ,
  -- UNIQUE ( cp, annotation, `type`, lang )
) CHARACTER SET utf8mb4;
CREATE INDEX codepoint_annotation_cp ON codepoint_annotation ( cp );
CREATE INDEX codepoint_annotation_cp_lang ON codepoint_annotation ( cp, lang );
