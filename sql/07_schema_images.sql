-- vim: ft=mysql


--
-- graphical representation as string (base64 PNG or SVG)
--
-- We do not reference the codepoints table, since we have images for PU
-- code points, too.
--
CREATE TABLE codepoint_image (
  cp     INTEGER NOT NULL,
  image  MEDIUMTEXT,
  font   VARCHAR(127),
  width  INTEGER,
  height INTEGER
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE INDEX codepoint_image_cp ON codepoint_image ( cp );
