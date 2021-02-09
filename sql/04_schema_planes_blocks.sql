-- vim: ft=mysql

--
-- defined Unicode blocks
--
-- first and last might not be defined codepoints, hence no reference to the
-- `codepoints` table.
--
CREATE TABLE blocks (
  name   VARCHAR(127) PRIMARY KEY,
  first  INTEGER(7),
  last   INTEGER(7)
);
CREATE INDEX blocks_cps ON blocks ( first, last );


--
-- defined Unicode planes
--
CREATE TABLE planes (
  name   VARCHAR(127) PRIMARY KEY NOT NULL,
  first  INTEGER(7) NOT NULL,
  last   INTEGER(7) NOT NULL
);
CREATE INDEX planes_cps ON planes ( first, last );
INSERT INTO planes (name, first, last) VALUES ('Basic Multilingual Plane',                  0,   0xFFFF);
INSERT INTO planes (name, first, last) VALUES ('Supplementary Multilingual Plane',    0x10000,  0x1FFFF);
INSERT INTO planes (name, first, last) VALUES ('Supplementary Ideographic Plane',     0x20000,  0x2FFFF);
INSERT INTO planes (name, first, last) VALUES ('Tertiary Ideographic Plane',          0x30000,  0x3FFFF);
INSERT INTO planes (name, first, last) VALUES ('Plane 5 (unassigned)',                0x40000,  0x4FFFF);
INSERT INTO planes (name, first, last) VALUES ('Plane 6 (unassigned)',                0x50000,  0x5FFFF);
INSERT INTO planes (name, first, last) VALUES ('Plane 7 (unassigned)',                0x60000,  0x6FFFF);
INSERT INTO planes (name, first, last) VALUES ('Plane 8 (unassigned)',                0x70000,  0x7FFFF);
INSERT INTO planes (name, first, last) VALUES ('Plane 9 (unassigned)',                0x80000,  0x8FFFF);
INSERT INTO planes (name, first, last) VALUES ('Plane 10 (unassigned)',               0x90000,  0x9FFFF);
INSERT INTO planes (name, first, last) VALUES ('Plane 11 (unassigned)',               0xA0000,  0xAFFFF);
INSERT INTO planes (name, first, last) VALUES ('Plane 12 (unassigned)',               0xB0000,  0xBFFFF);
INSERT INTO planes (name, first, last) VALUES ('Plane 13 (unassigned)',               0xC0000,  0xCFFFF);
INSERT INTO planes (name, first, last) VALUES ('Plane 14 (unassigned)',               0xD0000,  0xDFFFF);
INSERT INTO planes (name, first, last) VALUES ('Supplementary Special-purpose Plane', 0xE0000,  0xEFFFF);
INSERT INTO planes (name, first, last) VALUES ('Supplementary Private Use Area - A',  0xF0000,  0xFFFFF);
INSERT INTO planes (name, first, last) VALUES ('Supplementary Private Use Area - B', 0x100000, 0x10FFFF);
