-- vim: ft=mysql

--
-- CSUR names
--

CREATE TABLE csur (
  cp                    INTEGER PRIMARY KEY REFERENCES codepoints,
  name                  VARCHAR(255)
);
