-- vim: ft=mysql

--
-- Codepoints and their properties
--
-- Properties that refer to other codepoints are placed in table
-- codepoint_relation. Scripts are in codepoint_script.
--
CREATE TABLE codepoints (
  cp                    INTEGER PRIMARY KEY NOT NULL,
  age                   VARCHAR(4) REFERENCES prop_age NOT NULL,
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
  NFKC_QC               VARCHAR(1) REFERENCES prop_nfc_qc,
  NFKD_QC               VARCHAR(1) REFERENCES prop_nfd_qc,
  XO_NFC                BOOLEAN,
  XO_NFD                BOOLEAN,
  XO_NFKC               BOOLEAN,
  XO_NFKD               BOOLEAN,
  nt                    VARCHAR(4) REFERENCES prop_nt,
  nv                    VARCHAR(255),
  jt                    VARCHAR(1) REFERENCES prop_jt,
  jg                    VARCHAR(31) REFERENCES prop_jg,
  Join_C                BOOLEAN,
  lb                    VARCHAR(2) REFERENCES prop_lb,
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
  isc                   VARCHAR(2047),
  hst                   VARCHAR(3) REFERENCES prop_hst,
  JSN                   VARCHAR(3),
  InSC                  VARCHAR(26) REFERENCES prop_InSC,    -- 6.0
  InMC                  VARCHAR(24) REFERENCES prop_InMC,    -- 6.0
  InPC                  VARCHAR(24) REFERENCES prop_InPC,    -- 8.0
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
  GCB                   VARCHAR(4) REFERENCES prop_GCB,
  WB                    VARCHAR(6) REFERENCES prop_WB,
  SB                    VARCHAR(2) REFERENCES prop_SB,
  Ideo                  BOOLEAN,
  UIdeo                 BOOLEAN,
  IDSB                  BOOLEAN,
  IDST                  BOOLEAN,
  Radical               BOOLEAN,
  Dep                   BOOLEAN,
  VS                    BOOLEAN,
  NChar                 BOOLEAN,
  kAccountingNumeric    VARCHAR(255),
  kAlternateHanYu       VARCHAR(2047),
  kAlternateJEF         VARCHAR(2047),
  kAlternateKangXi      VARCHAR(2047),
  kAlternateMorohashi   VARCHAR(2047),
  kBigFive              VARCHAR(4),
  kCCCII                VARCHAR(6),
  kCNS1986              VARCHAR(6),
  kCNS1992              VARCHAR(6),
  kCangjie              VARCHAR(255),
  kCantonese            VARCHAR(255),
  kCheungBauer          VARCHAR(2047),
  kCheungBauerIndex     VARCHAR(255),
  kCihaiT               VARCHAR(255),
  kCompatibilityVariant VARCHAR(7),
  kCowles               VARCHAR(255),
  kDaeJaweon            VARCHAR(8),
  kDefinition           VARCHAR(2047),
  kEACC                 VARCHAR(6),
  kFenn                 VARCHAR(255),
  kFennIndex            VARCHAR(255),
  kFourCornerCode       VARCHAR(255),
  kFrequency            VARCHAR(1),
  kGB0                  VARCHAR(4),
  kGB1                  VARCHAR(4),
  kGB3                  VARCHAR(4),
  kGB5                  VARCHAR(4),
  kGB7                  VARCHAR(4),
  kGB8                  VARCHAR(4),
  kGradeLevel           VARCHAR(1),
  kGSR                  VARCHAR(255),
  kHangul               VARCHAR(2047),
  kHanYu                VARCHAR(255),
  kHanyuPinlu           VARCHAR(255),
  kHanyuPinyin          VARCHAR(255),
  kHDZRadBreak          VARCHAR(20),
  kHKGlyph              VARCHAR(255),
  kHKSCS                VARCHAR(4),
  kIBMJapan             VARCHAR(4),
  kIICore               VARCHAR(3),
  kIRGDaeJaweon         VARCHAR(8),
  kIRGDaiKanwaZiten     VARCHAR(6),
  kIRGHanyuDaZidian     VARCHAR(9),
  kIRGKangXi            VARCHAR(8),
  kIRG_GSource          VARCHAR(24),
  kIRG_HSource          VARCHAR(4),
  kIRG_JSource          VARCHAR(10),
  kIRG_KPSource         VARCHAR(7),
  kIRG_KSource          VARCHAR(8),
  kIRG_MSource          VARCHAR(8),
  kIRG_TSource          VARCHAR(255),
  kIRG_USource          VARCHAR(8),
  kIRG_VSource          VARCHAR(6),
  kJHJ                  VARCHAR(2047),
  kJIS0213              VARCHAR(7),
  kJa                   VARCHAR(6),    -- 8.0
  kJapaneseKun          VARCHAR(255),
  kJapaneseOn           VARCHAR(255),
  kJis0                 VARCHAR(4),
  kJis1                 VARCHAR(4),
  kKPS0                 VARCHAR(4),
  kKPS1                 VARCHAR(4),
  kKSC0                 VARCHAR(4),
  kKSC1                 VARCHAR(4),
  kKangXi               VARCHAR(8),
  kKarlgren             VARCHAR(5),
  kKorean               VARCHAR(255),
  kLau                  VARCHAR(255),
  kMainlandTelegraph    VARCHAR(4),
  kMandarin             VARCHAR(255),
  kMatthews             VARCHAR(6),
  kMeyerWempe           VARCHAR(255),
  kMorohashi            VARCHAR(6),
  kNelson               VARCHAR(255),
  kOtherNumeric         VARCHAR(255),
  kPhonetic             VARCHAR(255),
  kPrimaryNumeric       VARCHAR(255),
  kPseudoGB1            VARCHAR(4),
  kRSAdobe_Japan1_6     VARCHAR(255),
  kRSJapanese           VARCHAR(6),
  kRSKanWa              VARCHAR(6),
  kRSKangXi             VARCHAR(6),
  kRSKorean             VARCHAR(6),
  kRSMerged             VARCHAR(2047),
  kRSUnicode            VARCHAR(255),
  kSBGY                 VARCHAR(255),
  kSemanticVariant      VARCHAR(255),
  kSimplifiedVariant    VARCHAR(255),
  kSpecializedSemanticVariant VARCHAR(255),
  kTaiwanTelegraph      VARCHAR(4),
  kTang                 VARCHAR(255),
  kTotalStrokes         VARCHAR(3),
  kTraditionalVariant   VARCHAR(255),
  kVietnamese           VARCHAR(255),
  kXHC1983              VARCHAR(255),
  kWubi                 VARCHAR(2047),
  kXerox                VARCHAR(7),
  kZVariant             VARCHAR(255),
  kRSTUnicode           VARCHAR(255), -- 9.0
  kTGT_MergedSrc        VARCHAR(255), -- 9.0
  kSrc_NushuDuben       VARCHAR(255), -- 10.0
  kReading              VARCHAR(255), -- 10.0
  Emoji                 BOOLEAN NOT NULL DEFAULT 0, -- emoji 5.0
  Emoji_Presentation    BOOLEAN NOT NULL DEFAULT 0, -- emoji 5.0
  Emoji_Modifier_Base   BOOLEAN NOT NULL DEFAULT 0, -- emoji 5.0
  Emoji_Component       BOOLEAN NOT NULL DEFAULT 0, -- emoji 5.0
  blk                   VARCHAR(255)
);
CREATE INDEX codepoints_name ON codepoints ( na );
CREATE INDEX codepoints_blk ON codepoints ( blk );


--
-- cross-references between codepoints
--
CREATE TABLE codepoint_relation (
  cp       INTEGER(7) REFERENCES codepoints,
  other    INTEGER(7) REFERENCES codepoints,
  relation VARCHAR(7) REFERENCES prop_relation,
  `order`  INTEGER(3) DEFAULT 0,
  UNIQUE ( cp, other, relation, `order` )
);
CREATE INDEX codepoint_relation_cp ON codepoint_relation ( cp );
CREATE INDEX codepoint_relation_other ON codepoint_relation ( other );


--
-- alias names for a codepoint
--
CREATE TABLE codepoint_alias (
  cp     INTEGER REFERENCES codepoints,
  alias  VARCHAR(255),
  `type` VARCHAR(25)
);
CREATE INDEX codepoint_alias_cp ON codepoint_alias ( cp );
CREATE INDEX codepoint_alias_alias ON codepoint_alias ( alias );


--
-- graphical representation as string (base64 PNG or SVG)
--
CREATE TABLE codepoint_image (
  cp    INTEGER REFERENCES codepoints,
  image MEDIUMTEXT,
  UNIQUE ( cp )
);


--
-- named sequences of characters, TR #34
--
CREATE TABLE namedsequences (
  cp      INTEGER(7) REFERENCES codepoints,
  name    VARCHAR(255),
  `order` INTEGER(3),
  UNIQUE ( cp, name, `order` )
);
CREATE INDEX namedsequences_cp ON namedsequences ( cp );
