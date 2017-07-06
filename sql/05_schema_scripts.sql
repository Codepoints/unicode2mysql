-- vim: ft=mysql

--
-- Scripts defined by their ISO name
--
CREATE TABLE scripts (
  iso  VARCHAR(4) PRIMARY KEY NOT NULL,
  name VARCHAR(255)
);


--
-- The script the codepoint belongs to
--
-- `primary` is true if the script is referenced in the `sc` property of the
-- codepoint, false if it's referenced in the `scx` property.
--
CREATE TABLE codepoint_script (
  cp        INTEGER REFERENCES codepoints,
  sc        VARCHAR(4) REFERENCES scripts,
  `primary` BOOLEAN DEFAULT 1,
  UNIQUE ( cp, sc )
);
CREATE INDEX codepoint_script_cp ON codepoint_script ( cp );
CREATE INDEX codepoint_script_sc ON codepoint_script ( sc );
