-- vim: ft=mysql

--
-- property lookup tables
--

CREATE TABLE prop_age ( age VARCHAR(4) PRIMARY KEY ) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
INSERT INTO  prop_age VALUES ('1.1'), ('2.0'), ('2.1'), ('3.0'), ('3.1'),
('3.2'), ('4.0'), ('4.1'), ('5.0'), ('5.1'), ('5.2'), ('6.0'), ('6.1'),
('6.2'), ('6.3'), ('7.0'), ('8.0'), ('9.0'), ('10.0'), ('11.0'), ('12.0'),
('12.1'), ('13.0'), ('14.0'), ('15.0'), ('15.1');

CREATE TABLE prop_gc ( gc VARCHAR(2) PRIMARY KEY ) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
INSERT INTO  prop_gc VALUES
('Cc'), ('Cf'), ('Co'), ('Cn'), ('Cs'),
('Ll'), ('Lm'), ('Lo'), ('Lt'), ('Lu'),
('Mc'), ('Me'), ('Mn'),
('Nd'), ('Nl'), ('No'),
('Pc'), ('Pd'), ('Pe'), ('Pf'), ('Pi'), ('Po'), ('Ps'),
('Sc'), ('Sk'), ('Sm'), ('So'),
('Zl'), ('Zp'), ('Zs');

CREATE TABLE prop_bc ( bc VARCHAR(3) PRIMARY KEY ) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
INSERT INTO  prop_bc VALUES
('AL'), ('AN'),
('B'), ('BN'),
('CS'),
('EN'), ('ES'), ('ET'),
('FSI'),
('L'), ('LRE'), ('LRI'), ('LRO'),
('NSM'),
('ON'),
('PDF'), ('PDI'),
('R'), ('RLE'), ('RLI'), ('RLO'),
('S'),
('WS');

CREATE TABLE prop_bpt ( bpt VARCHAR(1) PRIMARY KEY ) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
INSERT INTO  prop_bpt VALUES ('c'), ('n'), ('o');

CREATE TABLE prop_dt ( dt VARCHAR(4) PRIMARY KEY ) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
INSERT INTO  prop_dt VALUES ('can'), ('com'), ('enc'), ('fin'), ('font'),
('fra'), ('init'), ('iso'), ('med'), ('nar'), ('nb'), ('none'), ('sml'),
('sqr'), ('sub'), ('sup'), ('vert'), ('wide');

CREATE TABLE prop_nfc_qc ( nfc_qc VARCHAR(1) PRIMARY KEY ) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
INSERT INTO  prop_nfc_qc VALUES ('M'), ('N'), ('Y');

CREATE TABLE prop_nfd_qc ( nfd_qc VARCHAR(1) PRIMARY KEY ) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
INSERT INTO  prop_nfd_qc VALUES ('N'), ('Y');

CREATE TABLE prop_nt ( nt VARCHAR(4) PRIMARY KEY ) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
INSERT INTO  prop_nt VALUES ('De'), ('Di'), ('None'), ('Nu');

CREATE TABLE prop_jt ( jt VARCHAR(1) PRIMARY KEY ) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
INSERT INTO  prop_jt VALUES ('C'), ('D'), ('L'), ('R'), ('T'), ('U');

CREATE TABLE prop_jg ( jg VARCHAR(31) PRIMARY KEY ) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
INSERT INTO  prop_jg VALUES
('African_Feh'), ('African_Noon'), ('African_Qaf'), ('Ain'), ('Alaph'),
('Alef'), ('Alef_Maqsurah'),
('Beh'), ('Beth'), ('Burushaski_Yeh_Barree'),
('Dal'), ('Dalath_Rish'),
('E'),
('Farsi_Yeh'), ('Fe'), ('Feh'), ('Final_Semkath'),
('Gaf'), ('Gamal'),
('Hah'), ('Hamza_On_Heh_Goal'), ('Hanifi_Rohingya_Kinna_Ya'), ('Hanifi_Rohingya_Pa'),
('He'), ('Heh'), ('Heh_Goal'), ('Heth'),
('Kaf'), ('Kaph'), ('Khaph'), ('Knotted_Heh'),
('Lam'), ('Lamadh'),
('Malayalam_Nga'), ('Malayalam_Ja'), ('Malayalam_Nya'), ('Malayalam_Tta'),
('Malayalam_Nna'), ('Malayalam_Nnna'), ('Malayalam_Bha'), ('Malayalam_Ra'),
('Malayalam_Lla'), ('Malayalam_Llla'), ('Malayalam_Ssa'), ('Manichaean_Aleph'),
('Manichaean_Ayin'), ('Manichaean_Beth'), ('Manichaean_Daleth'),
('Manichaean_Dhamedh'), ('Manichaean_Five'), ('Manichaean_Gimel'),
('Manichaean_Heth'), ('Manichaean_Hundred'), ('Manichaean_Kaph'),
('Manichaean_Lamedh'), ('Manichaean_Mem'), ('Manichaean_Nun'),
('Manichaean_One'), ('Manichaean_Pe'), ('Manichaean_Qoph'),
('Manichaean_Resh'), ('Manichaean_Sadhe'), ('Manichaean_Samekh'),
('Manichaean_Taw'), ('Manichaean_Ten'), ('Manichaean_Teth'),
('Manichaean_Thamedh'), ('Manichaean_Twenty'), ('Manichaean_Waw'),
('Manichaean_Yodh'), ('Manichaean_Zayin'), ('Meem'), ('Mim'),
('No_Joining_Group'), ('Noon'), ('Nun'), ('Nya'),
('Pe'),
('Qaf'), ('Qaph'),
('Reh'), ('Reversed_Pe'), ('Rohingya_Yeh'),
('Sad'), ('Sadhe'), ('Seen'), ('Semkath'), ('Shin'), ('Straight_Waw'),
('Swash_Kaf'), ('Syriac_Waw'),
('Tah'), ('Taw'), ('Teh_Marbuta'), ('Teh_Marbuta_Goal'), ('Teth'), ('Thin_Yeh'),
('Vertical_Tail'),
('Waw'),
('Yeh'), ('Yeh_Barree'), ('Yeh_With_Tail'), ('Yudh'), ('Yudh_He'),
('Zain'), ('Zhain');

CREATE TABLE prop_lb ( lb VARCHAR(3) PRIMARY KEY ) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
INSERT INTO  prop_lb VALUES
('AI'), ('AK'), ('AL'), ('AP'), ('AS'),
('B2'), ('BA'), ('BB'), ('BK'),
('CB'), ('CJ'), ('CL'), ('CM'), ('CP'), ('CR'),
('EB'), ('EM'), ('EX'),
('GL'),
('H2'), ('H3'), ('HL'), ('HY'),
('ID'), ('IN'), ('IS'),
('JL'), ('JT'), ('JV'),
('LF'),
('NL'), ('NS'), ('NU'),
('OP'),
('PO'), ('PR'),
('QU'),
('RI'),
('SA'), ('SG'), ('SP'), ('SY'),
('VF'), ('VI'),
('WJ'),
('XX'),
('ZW'), ('ZWJ');

CREATE TABLE prop_ea ( ea VARCHAR(2) PRIMARY KEY ) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
INSERT INTO  prop_ea VALUES ('A'), ('F'), ('H'), ('N'), ('Na'), ('W');

CREATE TABLE prop_hst ( hst VARCHAR(3) PRIMARY KEY ) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
INSERT INTO  prop_hst VALUES ('L'), ('LV'), ('LVT'), ('T'), ('V'), ('NA');

CREATE TABLE prop_InSC ( InSC VARCHAR(27) PRIMARY KEY ) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
INSERT INTO  prop_InSC VALUES
('Avagraha'), ('Bindu'), ('Brahmi_Joining_Number'), ('Cantillation_Mark'),
('Consonant'), ('Consonant_Dead'), ('Consonant_Final'),
('Consonant_Head_Letter'), ('Consonant_Initial_Postfixed'),
('Consonant_Killer'), ('Consonant_Medial'), ('Consonant_Placeholder'),
('Consonant_Preceding_Repha'), ('Consonant_Prefixed'), ('Consonant_Repha'),
('Consonant_Subjoined'), ('Consonant_Succeeding_Repha'),
('Consonant_With_Stacker'), ('Gemination_Mark'), ('Invisible_Stacker'),
('Joiner'), ('Modifying_Letter'), ('Non_Joiner'), ('Nukta'), ('Number'),
('Number_Joiner'), ('Other'), ('Pure_Killer'), ('Register_Shifter'),
('Syllable_Modifier'), ('Tone_Letter'), ('Tone_Mark'), ('Virama'), ('Visarga'),
('Vowel'), ('Vowel_Dependent'), ('Vowel_Independent');

CREATE TABLE prop_InMC ( InMC VARCHAR(24) PRIMARY KEY ) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
INSERT INTO  prop_InMC VALUES ('Right'), ('Left'), ('Visual_Order_Left'),
('Left_And_Right'), ('Top'), ('Bottom'), ('Top_And_Bottom'), ('Top_And_Right'),
('Top_And_Left'), ('Top_And_Left_And_Right'), ('Bottom_And_Right'),
('Top_And_Bottom_And_Right'), ('Overstruck'), ('Invisible'), ('NA');

CREATE TABLE prop_InPC ( InPC VARCHAR(24) PRIMARY KEY ) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
INSERT INTO  prop_InPC VALUES ('Bottom'), ('Bottom_And_Left'),
('Bottom_And_Right'), ('Left'), ('Left_And_Right'), ('NA'), ('Overstruck'),
('Right'), ('Top'), ('Top_And_Bottom'), ('Top_And_Bottom_And_Left'),
('Top_And_Bottom_And_Right'), ('Top_And_Left'), ('Top_And_Left_And_Right'),
('Top_And_Right'), ('Visual_Order_Left');

CREATE TABLE prop_InCB ( InCB VARCHAR(24) PRIMARY KEY ) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
INSERT INTO  prop_InCB VALUES ('None'), ('Linker'),
('Consonant'), ('Extend');

CREATE TABLE prop_vo ( vo VARCHAR(2) PRIMARY KEY ) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
INSERT INTO  prop_vo VALUES ('U'), ('R'), ('Tu'), ('Tr');

CREATE TABLE prop_GCB ( GCB VARCHAR(3) PRIMARY KEY ) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
INSERT INTO  prop_GCB VALUES
('CN'), ('CR'),
('EB'), ('EBG'), ('EM'), ('EX'),
('GAZ'),
('L'), ('LF'), ('LV'), ('LVT'),
('PP'),
('RI'),
('SM'),
('T'),
('V'),
('XX'),
('ZWJ');

CREATE TABLE prop_WB ( WB VARCHAR(9) PRIMARY KEY ) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
INSERT INTO  prop_WB VALUES
('CR'),
('DQ'),
('EB'), ('EBG'), ('EM'), ('EX'), ('Extend'),
('FO'),
('GAZ'),
('HL'),
('KA'),
('LE'), ('LF'),
('MB'), ('ML'), ('MN'),
('NL'), ('NU'),
('RI'),
('SQ'),
('XX'),
('WSegSpace'),
('ZWJ');

CREATE TABLE prop_SB ( SB VARCHAR(2) PRIMARY KEY ) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
INSERT INTO  prop_SB VALUES
('AT'),
('CL'), ('CR'),
('EX'),
('FO'),
('LE'), ('LF'), ('LO'),
('NU'),
('SC'), ('SE'), ('SP'), ('ST'),
('UP'),
('XX');

CREATE TABLE prop_relation ( relation VARCHAR(8) PRIMARY KEY ) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
INSERT INTO  prop_relation VALUES ('bmg'), ('dm'), ('FC_NFKC'), ('suc'),
('slc'), ('stc'), ('uc'), ('lc'), ('tc'), ('scf'), ('cf'), ('NFKC_CF'),
('bpb'), ('EqUIdeo'), ('NFKC_SCF');

CREATE TABLE prop_annotation_type ( annotation_type VARCHAR(7) PRIMARY KEY ) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
INSERT INTO prop_annotation_type VALUES ('tag'), ('tts');
