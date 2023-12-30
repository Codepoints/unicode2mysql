-- vim: ft=mysql

--
-- other codepoints to be confusable with this
--

CREATE TABLE codepoint_confusables (
  id       INTEGER(7) NOT NULL,
  cp       INTEGER NOT NULL,
  other    INTEGER NOT NULL,
  `order`  INTEGER NOT NULL DEFAULT 1,
  UNIQUE ( id, cp, other, `order` ),
  CONSTRAINT `fk_codepoint_confusables_cp`
    FOREIGN KEY (cp) REFERENCES codepoints (cp)
    ON DELETE CASCADE
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_codepoint_confusables_other`
    FOREIGN KEY (other) REFERENCES codepoints (cp)
    ON DELETE CASCADE
    ON UPDATE RESTRICT
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE INDEX codepoint_confusables_cp ON codepoint_confusables ( cp );
CREATE INDEX codepoint_confusables_other ON codepoint_confusables ( other );
