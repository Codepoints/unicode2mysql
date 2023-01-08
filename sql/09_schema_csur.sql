-- vim: ft=mysql

--
-- CSUR names
--

CREATE TABLE csur (
  cp                    INTEGER PRIMARY KEY REFERENCES codepoints,
  name                  VARCHAR(255)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
