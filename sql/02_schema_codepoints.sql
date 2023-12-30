-- vim: ft=mysql

--
-- Codepoints and their properties
--
-- Properties that refer to other codepoints are placed in table
-- codepoint_relation. Scripts are in codepoint_script.
--

CREATE TABLE codepoints (
  cp                    INTEGER PRIMARY KEY NOT NULL,
  name                  VARCHAR(255),
  gc                    VARCHAR(2) REFERENCES prop_gc(gc)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE codepoint_props (
  cp                    INTEGER NOT NULL REFERENCES codepoints,
  age                   VARCHAR(4) REFERENCES prop_age,
  na                    VARCHAR(255),
  na1                   VARCHAR(255),
  gc                    VARCHAR(2) REFERENCES prop_gc,
  ccc                   TINYINT UNSIGNED,  -- 0..255
  bc                    VARCHAR(3) REFERENCES prop_bc,
  Bidi_M                BOOLEAN,
  Bidi_C                BOOLEAN,
  bpt                   VARCHAR(1) REFERENCES prop_bpt, -- 6.3
  dt                    VARCHAR(4) REFERENCES prop_dt,
  CE                    BOOLEAN,
  Comp_Ex               BOOLEAN,
  NFC_QC                VARCHAR(1) REFERENCES prop_nfc_qc,
  NFD_QC                VARCHAR(1) REFERENCES prop_nfd_qc,
  NFKC_QC               VARCHAR(1) REFERENCES prop_nfkc_qc,
  NFKD_QC               VARCHAR(1) REFERENCES prop_nfkd_qc,
  XO_NFC                BOOLEAN,
  XO_NFD                BOOLEAN,
  XO_NFKC               BOOLEAN,
  XO_NFKD               BOOLEAN,
  nt                    VARCHAR(4) REFERENCES prop_nt,
  nv                    VARCHAR(255),
  jt                    VARCHAR(1) REFERENCES prop_jt,
  jg                    VARCHAR(31) REFERENCES prop_jg,
  Join_C                BOOLEAN,
  lb                    VARCHAR(3) REFERENCES prop_lb,
  ea                    VARCHAR(2) REFERENCES prop_ea,
  Upper                 BOOLEAN,
  Lower                 BOOLEAN,
  OUpper                BOOLEAN,
  OLower                BOOLEAN,
  CI                    BOOLEAN, -- 5.2
  Cased                 BOOLEAN, -- 5.2
  CWCF                  BOOLEAN, -- 5.2
  CWCM                  BOOLEAN, -- 5.2
  CWL                   BOOLEAN, -- 5.2
  CWKCF                 BOOLEAN, -- 5.2
  CWT                   BOOLEAN, -- 5.2
  CWU                   BOOLEAN, -- 5.2
  isc                   TEXT(2047),
  hst                   VARCHAR(3) REFERENCES prop_hst,
  JSN                   VARCHAR(3),
  InSC                  VARCHAR(31) REFERENCES prop_InSC,    -- 6.0
  InMC                  VARCHAR(24) REFERENCES prop_InMC,    -- 6.0
  InPC                  VARCHAR(24) REFERENCES prop_InPC,    -- 8.0
  InCB                  VARCHAR(24) REFERENCES prop_InCB,    -- 15.1
  IDS                   BOOLEAN,
  OIDS                  BOOLEAN,
  XIDS                  BOOLEAN,
  IDC                   BOOLEAN,
  OIDC                  BOOLEAN,
  XIDC                  BOOLEAN,
  Pat_Syn               BOOLEAN,
  Pat_WS                BOOLEAN,
  Dash                  BOOLEAN,
  Hyphen                BOOLEAN,
  QMark                 BOOLEAN,
  Term                  BOOLEAN,
  STerm                 BOOLEAN,
  Dia                   BOOLEAN,
  Ext                   BOOLEAN,
  PCM                   BOOLEAN, -- 9.0
  SD                    BOOLEAN,
  Alpha                 BOOLEAN,
  OAlpha                BOOLEAN,
  Math                  BOOLEAN,
  OMath                 BOOLEAN,
  Hex                   BOOLEAN,
  AHex                  BOOLEAN,
  DI                    BOOLEAN,
  ODI                   BOOLEAN,
  LOE                   BOOLEAN,
  WSpace                BOOLEAN,
  vo                    VARCHAR(2) REFERENCES prop_vo, -- 10.0
  RI                    BOOLEAN, -- 10.0
  Gr_Base               BOOLEAN,
  Gr_Ext                BOOLEAN,
  OGr_Ext               BOOLEAN,
  Gr_Link               BOOLEAN,
  GCB                   VARCHAR(3) REFERENCES prop_GCB,
  WB                    VARCHAR(9) REFERENCES prop_WB,
  SB                    VARCHAR(2) REFERENCES prop_SB,
  Ideo                  BOOLEAN,
  UIdeo                 BOOLEAN,
  IDSB                  BOOLEAN,
  IDST                  BOOLEAN,
  Radical               BOOLEAN,
  Dep                   BOOLEAN,
  VS                    BOOLEAN,
  NChar                 BOOLEAN,
  unihan                TEXT, -- JSON blob to store all k* properties
  Emoji                 BOOLEAN NOT NULL DEFAULT 0, -- emoji 5.0
  EPres                 BOOLEAN NOT NULL DEFAULT 0, -- emoji 5.0
  EMod                  BOOLEAN NOT NULL DEFAULT 0, -- emoji 5.0
  EBase                 BOOLEAN NOT NULL DEFAULT 0, -- emoji 5.0
  EComp                 BOOLEAN NOT NULL DEFAULT 0, -- emoji 5.0
  ExtPict               BOOLEAN NOT NULL DEFAULT 0, -- emoji 11.0
  ID_Compat_Math_Start  BOOLEAN NOT NULL DEFAULT 0, -- 15.1
  ID_Compat_Math_Continue BOOLEAN NOT NULL DEFAULT 0, -- 15.1
  IDSU                  BOOLEAN NOT NULL DEFAULT 0, -- 15.1
  blk                   VARCHAR(127)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE INDEX codepoint_props_cp ON codepoint_props ( cp );
CREATE INDEX codepoint_props_name ON codepoint_props ( na );
CREATE INDEX codepoint_props_blk ON codepoint_props ( blk );


--
-- cross-references between codepoints
--
CREATE TABLE codepoint_relation (
  cp       INTEGER NOT NULL,
  other    INTEGER NOT NULL,
  relation VARCHAR(8),
  `order`  INTEGER(3) DEFAULT 0,
  UNIQUE ( cp, other, relation, `order` ),
  CONSTRAINT `fk_codepoint_relation_cp`
    FOREIGN KEY (cp) REFERENCES codepoints (cp)
    ON DELETE CASCADE
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_codepoint_relation_other`
    FOREIGN KEY (other) REFERENCES codepoints (cp)
    ON DELETE CASCADE
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_codepoint_relation_relation`
    FOREIGN KEY (relation) REFERENCES prop_relation (relation)
    ON DELETE CASCADE
    ON UPDATE RESTRICT
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE INDEX codepoint_relation_cp ON codepoint_relation ( cp );
CREATE INDEX codepoint_relation_other ON codepoint_relation ( other );


--
-- alias names for a codepoint
--
-- We do not reference the codepoints table, since we have aliases for PU
-- code points, too.
--
CREATE TABLE codepoint_alias (
  cp     INTEGER NOT NULL,
  alias  VARCHAR(127),
  `type` VARCHAR(25)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE INDEX codepoint_alias_cp ON codepoint_alias ( cp );
CREATE INDEX codepoint_alias_alias ON codepoint_alias ( alias );


--
-- named sequences of characters, TR #34
--
CREATE TABLE namedsequences (
  cp      INTEGER NOT NULL REFERENCES codepoints(cp),
  name    VARCHAR(127),
  `order` INTEGER(3),
  UNIQUE ( cp, name, `order` )
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE INDEX namedsequences_cp ON namedsequences ( cp );
