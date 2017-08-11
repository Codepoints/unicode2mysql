-- vim: ft=mysql


--
-- graphical representation as string (base64 PNG or SVG)
--
CREATE TABLE codepoint_image (
  cp     INTEGER REFERENCES codepoints,
  image  MEDIUMTEXT,
  font   VARCHAR(127),
  width  INTEGER,
  height INTEGER,
  UNIQUE ( cp, font )
);


--
-- order fonts for glyph selection from table above
--
CREATE TABLE font_order (
  `order` INTEGER(4),
  font    VARCHAR(127),
  first   INTEGER(7),
  last    INTEGER(7),
  UNIQUE( `order`, font )
);
CREATE INDEX font_order_order ON font_order ( `order` );
CREATE INDEX font_order_first_last ON font_order ( first, last );
