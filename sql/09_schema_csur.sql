-- vim: ft=mysql

--
-- CSUR names
--
-- Since these are all in the PUA, we do not reference the codepoints table.
--

CREATE TABLE csur (
    cp    INTEGER NOT NULL,
    name  VARCHAR(255)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
