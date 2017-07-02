-- vim: ft=mysql

--
-- property lookup tables
--

CREATE TABLE prop_age ( age VARCHAR(4) PRIMARY KEY );
INSERT INTO  prop_age VALUES ('1.1'), ('2.0'), ('2.1'), ('3.0'), ('3.1'),
('3.2'), ('4.0'), ('4.1'), ('5.0'), ('5.1'), ('5.2'), ('6.0'), ('6.1'),
('6.2'), ('6.3'), ('7.0'), ('8.0'), ('9.0'), ('10.0');

CREATE TABLE prop_gc ( gc VARCHAR(2) PRIMARY KEY );
INSERT INTO  prop_gc VALUES ('Cc'), ('Cf'), ('Cn'), ('Ll'), ('Lm'), ('Lo'),
('Lt'), ('Lu'), ('Mc'), ('Me'), ('Mn'), ('Nd'), ('Nl'), ('No'), ('Pc'), ('Pd'),
('Pe'), ('Pf'), ('Pi'), ('Po'), ('Ps'), ('Sc'), ('Sk'), ('Sm'), ('So'), ('Zl'),
('Zp'), ('Zs');

CREATE TABLE prop_bc ( bc VARCHAR(3) PRIMARY KEY );
INSERT INTO  prop_bc VALUES ('AL'), ('AN'), ('B'), ('BN'), ('CS'), ('EN'),
('ES'), ('ET'), ('FSI'), ('L'), ('LRE'), ('LRI'), ('LRO'), ('NSM'), ('ON'),
('PDF'), ('PDI'), ('R'), ('RLE'), ('RLI'), ('RLO'), ('S'), ('WS');

CREATE TABLE prop_bpt ( bpt VARCHAR(1) PRIMARY KEY );
INSERT INTO  prop_bpt VALUES ('c'), ('n'), ('o');

CREATE TABLE prop_dt ( dt VARCHAR(4) PRIMARY KEY );
INSERT INTO  prop_dt VALUES ('can'), ('com'), ('enc'), ('fin'), ('font'),
('fra'), ('init'), ('iso'), ('med'), ('nar'), ('nb'), ('none'), ('sml'),
('sqr'), ('sub'), ('sup'), ('vert'), ('wide');

CREATE TABLE prop_nfc_qc ( nfc_qc VARCHAR(1) PRIMARY KEY );
INSERT INTO  prop_nfc_qc VALUES ('M'), ('N'), ('Y');

CREATE TABLE prop_nfd_qc ( nfd_qc VARCHAR(1) PRIMARY KEY );
INSERT INTO  prop_nfd_qc VALUES ('N'), ('Y');

CREATE TABLE prop_nt ( nt VARCHAR(4) PRIMARY KEY );
INSERT INTO  prop_nt VALUES ('De'), ('Di'), ('None'), ('Nu');

CREATE TABLE prop_jt ( jt VARCHAR(1) PRIMARY KEY );
INSERT INTO  prop_jt VALUES ('C'), ('D'), ('L'), ('R'), ('T'), ('U');

CREATE TABLE prop_jg ( jg VARCHAR(31) PRIMARY KEY );
INSERT INTO  prop_jg VALUES ('African_Feh'), ('African_Noon'), ('African_Qaf'),
('Ain'), ('Alaph'), ('Alef'), ('Alef_Maqsurah'), ('Beh'), ('Beth'),
('Burushaski_Yeh_Barree'), ('Dal'), ('Dalath_Rish'), ('E'), ('Farsi_Yeh'),
('Fe'), ('Feh'), ('Final_Semkath'), ('Gaf'), ('Gamal'), ('Hah'),
('Hamza_On_Heh_Goal'), ('He'), ('Heh'), ('Heh_Goal'), ('Heth'), ('Kaf'),
('Kaph'), ('Khaph'), ('Knotted_Heh'), ('Lam'), ('Lamadh'), ('Malayalam_Nga'),
('Malayalam_Ja'), ('Malayalam_Nya'), ('Malayalam_Tta'), ('Malayalam_Nna'),
('Malayalam_Nnna'), ('Malayalam_Bha'), ('Malayalam_Ra'), ('Malayalam_Lla'),
('Malayalam_Llla'), ('Malayalam_Ssa'), ('Manichaean_Aleph'),
('Manichaean_Ayin'), ('Manichaean_Beth'), ('Manichaean_Daleth'),
('Manichaean_Dhamedh'), ('Manichaean_Five'), ('Manichaean_Gimel'),
('Manichaean_Heth'), ('Manichaean_Hundred'), ('Manichaean_Kaph'),
('Manichaean_Lamedh'), ('Manichaean_Mem'), ('Manichaean_Nun'),
('Manichaean_One'), ('Manichaean_Pe'), ('Manichaean_Qoph'),
('Manichaean_Resh'), ('Manichaean_Sadhe'), ('Manichaean_Samekh'),
('Manichaean_Taw'), ('Manichaean_Ten'), ('Manichaean_Teth'),
('Manichaean_Thamedh'), ('Manichaean_Twenty'), ('Manichaean_Waw'),
('Manichaean_Yodh'), ('Manichaean_Zayin'), ('Meem'), ('Mim'),
('No_Joining_Group'), ('Noon'), ('Nun'), ('Nya'), ('Pe'), ('Qaf'), ('Qaph'),
('Reh'), ('Reversed_Pe'), ('Rohingya_Yeh'), ('Sad'), ('Sadhe'), ('Seen'),
('Semkath'), ('Shin'), ('Straight_Waw'), ('Swash_Kaf'), ('Syriac_Waw'),
('Tah'), ('Taw'), ('Teh_Marbuta'), ('Teh_Marbuta_Goal'), ('Teth'), ('Waw'),
('Yeh'), ('Yeh_Barree'), ('Yeh_With_Tail'), ('Yudh'), ('Yudh_He'), ('Zain'),
('Zhain');

CREATE TABLE prop_lb ( lb VARCHAR(2) PRIMARY KEY );
INSERT INTO  prop_lb VALUES ('AI'), ('AL'), ('B2'), ('BA'), ('BB'), ('BK'),
('CB'), ('CJ'), ('CL'), ('CM'), ('CP'), ('CR'), ('EB'), ('EM'), ('EX'), ('GL'),
('H2'), ('H3'), ('HL'), ('HY'), ('ID'), ('IN'), ('IS'), ('JL'), ('JT'), ('JV'),
('LF'), ('NL'), ('NS'), ('NU'), ('OP'), ('PO'), ('PR'), ('QU'), ('RI'), ('SA'),
('SG'), ('SP'), ('SY'), ('WJ'), ('XX'), ('ZW'), ('ZWJ');

CREATE TABLE prop_ea ( ea VARCHAR(2) PRIMARY KEY );
INSERT INTO  prop_ea VALUES ('A'), ('F'), ('H'), ('N'), ('Na'), ('W');

CREATE TABLE prop_hst ( hst VARCHAR(3) PRIMARY KEY );
INSERT INTO  prop_hst VALUES ('L'), ('LV'), ('LVT'), ('T'), ('V'), ('NA');

CREATE TABLE prop_InSC ( InSC VARCHAR(26) PRIMARY KEY );
INSERT INTO  prop_InSC VALUES ('Avagraha'), ('Bindu'),
('Brahmi_Joining_Number'), ('Cantillation_Mark'), ('Consonant'),
('Consonant_Dead'), ('Consonant_Final'), ('Consonant_Head_Letter'),
('Consonant_Killer'), ('Consonant_Medial'), ('Consonant_Placeholder'),
('Consonant_Preceding_Repha'), ('Consonant_Prefixed'), ('Consonant_Repha'),
('Consonant_Subjoined'), ('Consonant_Succeeding_Repha'),
('Consonant_With_Stacker'), ('Gemination_Mark'), ('Invisible_Stacker'),
('Joiner'), ('Modifying_Letter'), ('Non_Joiner'), ('Nukta'), ('Number'),
('Number_Joiner'), ('Other'), ('Pure_Killer'), ('Register_Shifter'),
('Syllable_Modifier'), ('Tone_Letter'), ('Tone_Mark'), ('Virama'), ('Visarga'),
('Vowel'), ('Vowel_Dependent'), ('Vowel_Independent');

CREATE TABLE prop_InMC ( InMC VARCHAR(24) PRIMARY KEY );
INSERT INTO  prop_InMC VALUES ('Right'), ('Left'), ('Visual_Order_Left'),
('Left_And_Right'), ('Top'), ('Bottom'), ('Top_And_Bottom'), ('Top_And_Right'),
('Top_And_Left'), ('Top_And_Left_And_Right'), ('Bottom_And_Right'),
('Top_And_Bottom_And_Right'), ('Overstruck'), ('Invisible'), ('NA');

CREATE TABLE prop_InPC ( InPC VARCHAR(24) PRIMARY KEY );
INSERT INTO  prop_InPC VALUES ('Bottom'), ('Bottom_And_Left'),
('Bottom_And_Right'), ('Left'), ('Left_And_Right'), ('NA'), ('Overstruck'),
('Right'), ('Top'), ('Top_And_Bottom'), ('Top_And_Bottom_And_Right'),
('Top_And_Left'), ('Top_And_Left_And_Right'), ('Top_And_Right'),
('Visual_Order_Left');

CREATE TABLE prop_vo ( vo VARCHAR(2) PRIMARY KEY );
INSERT INTO  prop_vo VALUES ('U'), ('R'), ('Tu'), ('Tr');

CREATE TABLE prop_GCB ( GCB VARCHAR(3) PRIMARY KEY );
INSERT INTO  prop_GCB VALUES ('CN'), ('CR'), ('EB'), ('EBG'), ('EM'), ('EX'),
('GAZ'), ('L'), ('LF'), ('LV'), ('LVT'), ('PP'), ('RI'), ('SM'), ('T'), ('V'),
('XX'), ('ZWJ');

CREATE TABLE prop_WB ( WB VARCHAR(6) PRIMARY KEY );
INSERT INTO  prop_WB VALUES ('CR'), ('DQ'), ('EB'), ('EBG'), ('EM'), ('EX'),
('Extend'), ('FO'), ('GAZ'), ('HL'), ('KA'), ('LE'), ('LF'), ('MB'), ('ML'),
('MN'), ('NL'), ('NU'), ('RI'), ('SQ'), ('XX'), ('ZWJ');

CREATE TABLE prop_SB ( SB VARCHAR(2) PRIMARY KEY );
INSERT INTO  prop_SB VALUES ('AT'), ('CL'), ('CR'), ('EX'), ('FO'), ('LE'),
('LF'), ('LO'), ('NU'), ('SC'), ('SE'), ('SP'), ('ST'), ('UP'), ('XX');

CREATE TABLE prop_relation ( relation VARCHAR(7) PRIMARY KEY );
INSERT INTO  prop_relation VALUES ('bmg'), ('dm'), ('FC_NFKC'), ('suc'),
('slc'), ('stc'), ('uc'), ('lc'), ('tc'), ('scf'), ('cf'), ('NFKC_CF'),
('bpb');


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
-- defined Unicode blocks
--
-- first and last might not be defined codepoints, hence no reference to the
-- `codepoints` table.
--
CREATE TABLE blocks (
  name   VARCHAR(255) PRIMARY KEY,
  first  INTEGER(7),
  last   INTEGER(7)
);
CREATE INDEX blocks_cps ON blocks ( first, last );


--
-- The block a codepoint belongs to
--
CREATE TABLE codepoint_block (
  cp   INTEGER REFERENCES codepoints,
  blk  VARCHAR(255) REFERENCES blocks,
  UNIQUE ( cp, blk )
);
CREATE INDEX codepoint_block_cp ON codepoint_block ( cp );
CREATE INDEX codepoint_block_blk ON codepoint_block ( blk );


--
-- defined Unicode planes
--
CREATE TABLE planes (
  name   VARCHAR(255) PRIMARY KEY NOT NULL,
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


--
-- Scripts defined by their ISO name
--
CREATE TABLE scripts (
  iso  VARCHAR(4) PRIMARY KEY,
  name VARCHAR(255)
);


--
-- The script the codepoint belongs to
--
-- `primary` is true if the script is referenced in the `sc` property of the
-- codepoint, false if it's referenced in the `scx` property.
--
CREATE TABLE codepoint_script (
  cp      INTEGER REFERENCES codepoints,
  sc      VARCHAR(4) REFERENCES scripts,
  primary BOOLEAN DEFAULT true,
  UNIQUE ( cp, sc )
);
CREATE INDEX codepoint_script_cp ON codepoint_script ( cp );
CREATE INDEX codepoint_script_sc ON codepoint_script ( sc );


--
-- graphical representation as string (base64 PNG or SVG)
--
CREATE TABLE codepoint_image (
  cp    INTEGER REFERENCES codepoints,
  image MEDIUMTEXT,
  UNIQUE ( cp )
);


--
-- other codepoints to be confusable with this
--
CREATE TABLE codepoint_confusables (
  id       INTEGER PRIMARY KEY NOT NULL,
  cp       INTEGER(7) REFERENCES codepoints NOT NULL,
  other    INTEGER(7) REFERENCES codepoints NOT NULL,
  `order`  INTEGER NOT NULL DEFAULT 1
);
CREATE INDEX codepoint_confusables_cp ON codepoint_confusables ( cp );
CREATE INDEX codepoint_confusables_other ON codepoint_confusables ( other );


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
