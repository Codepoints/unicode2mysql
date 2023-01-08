-- vim: ft=mysql


--
-- graphical representation as string (base64 PNG or SVG)
--
CREATE TABLE codepoint_image (
  cp     INTEGER PRIMARY KEY REFERENCES codepoints,
  image  MEDIUMTEXT,
  font   VARCHAR(127),
  width  INTEGER,
  height INTEGER
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
