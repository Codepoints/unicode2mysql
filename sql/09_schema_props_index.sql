-- vim: ft=mysql
--
-- create indexes for all the properties that might be searched
--

CREATE INDEX codepoint_props_age ON codepoint_props ( age );
CREATE INDEX codepoint_props_na1 ON codepoint_props ( na1 );
CREATE INDEX codepoint_props_gc ON codepoint_props ( gc );
CREATE INDEX codepoint_props_ccc ON codepoint_props ( ccc );
CREATE INDEX codepoint_props_bc ON codepoint_props ( bc );
CREATE INDEX codepoint_props_Bidi_M ON codepoint_props ( Bidi_M );
CREATE INDEX codepoint_props_Bidi_C ON codepoint_props ( Bidi_C );
CREATE INDEX codepoint_props_bpt ON codepoint_props ( bpt );
CREATE INDEX codepoint_props_dt ON codepoint_props ( dt );
CREATE INDEX codepoint_props_CE ON codepoint_props ( CE );
CREATE INDEX codepoint_props_Comp_Ex ON codepoint_props ( Comp_Ex );
CREATE INDEX codepoint_props_NFC_QC ON codepoint_props ( NFC_QC );
CREATE INDEX codepoint_props_NFD_QC ON codepoint_props ( NFD_QC );
CREATE INDEX codepoint_props_NFKC_QC ON codepoint_props ( NFKC_QC );
CREATE INDEX codepoint_props_NFKD_QC ON codepoint_props ( NFKD_QC );
CREATE INDEX codepoint_props_XO_NFC ON codepoint_props ( XO_NFC );
CREATE INDEX codepoint_props_XO_NFD ON codepoint_props ( XO_NFD );
CREATE INDEX codepoint_props_XO_NFKC ON codepoint_props ( XO_NFKC );
CREATE INDEX codepoint_props_XO_NFKD ON codepoint_props ( XO_NFKD );
CREATE INDEX codepoint_props_nt ON codepoint_props ( nt );
CREATE INDEX codepoint_props_nv ON codepoint_props ( nv );
CREATE INDEX codepoint_props_jt ON codepoint_props ( jt );
CREATE INDEX codepoint_props_jg ON codepoint_props ( jg );
CREATE INDEX codepoint_props_Join_C ON codepoint_props ( Join_C );
CREATE INDEX codepoint_props_lb ON codepoint_props ( lb );
CREATE INDEX codepoint_props_ea ON codepoint_props ( ea );
CREATE INDEX codepoint_props_Upper ON codepoint_props ( Upper );
CREATE INDEX codepoint_props_Lower ON codepoint_props ( Lower );
CREATE INDEX codepoint_props_OUpper ON codepoint_props ( OUpper );
CREATE INDEX codepoint_props_OLower ON codepoint_props ( OLower );
CREATE INDEX codepoint_props_CI ON codepoint_props ( CI );
CREATE INDEX codepoint_props_Cased ON codepoint_props ( Cased );
CREATE INDEX codepoint_props_CWCF ON codepoint_props ( CWCF );
CREATE INDEX codepoint_props_CWCM ON codepoint_props ( CWCM );
CREATE INDEX codepoint_props_CWL ON codepoint_props ( CWL );
CREATE INDEX codepoint_props_CWKCF ON codepoint_props ( CWKCF );
CREATE INDEX codepoint_props_CWT ON codepoint_props ( CWT );
CREATE INDEX codepoint_props_CWU ON codepoint_props ( CWU );
CREATE INDEX codepoint_props_isc ON codepoint_props ( isc );
CREATE INDEX codepoint_props_hst ON codepoint_props ( hst );
CREATE INDEX codepoint_props_JSN ON codepoint_props ( JSN );
CREATE INDEX codepoint_props_InSC ON codepoint_props ( InSC );
CREATE INDEX codepoint_props_InMC ON codepoint_props ( InMC );
CREATE INDEX codepoint_props_InPC ON codepoint_props ( InPC );
CREATE INDEX codepoint_props_InCB ON codepoint_props ( InCB );
CREATE INDEX codepoint_props_IDS ON codepoint_props ( IDS );
CREATE INDEX codepoint_props_OIDS ON codepoint_props ( OIDS );
CREATE INDEX codepoint_props_XIDS ON codepoint_props ( XIDS );
CREATE INDEX codepoint_props_IDC ON codepoint_props ( IDC );
CREATE INDEX codepoint_props_OIDC ON codepoint_props ( OIDC );
CREATE INDEX codepoint_props_XIDC ON codepoint_props ( XIDC );
CREATE INDEX codepoint_props_Pat_Syn ON codepoint_props ( Pat_Syn );
CREATE INDEX codepoint_props_Pat_WS ON codepoint_props ( Pat_WS );
CREATE INDEX codepoint_props_Dash ON codepoint_props ( Dash );
CREATE INDEX codepoint_props_Hyphen ON codepoint_props ( Hyphen );
CREATE INDEX codepoint_props_QMark ON codepoint_props ( QMark );
CREATE INDEX codepoint_props_Term ON codepoint_props ( Term );
CREATE INDEX codepoint_props_STerm ON codepoint_props ( STerm );
CREATE INDEX codepoint_props_Dia ON codepoint_props ( Dia );
CREATE INDEX codepoint_props_Ext ON codepoint_props ( Ext );
CREATE INDEX codepoint_props_PCM ON codepoint_props ( PCM );
CREATE INDEX codepoint_props_SD ON codepoint_props ( SD );
CREATE INDEX codepoint_props_Alpha ON codepoint_props ( Alpha );
CREATE INDEX codepoint_props_OAlpha ON codepoint_props ( OAlpha );
CREATE INDEX codepoint_props_Math ON codepoint_props ( Math );
CREATE INDEX codepoint_props_OMath ON codepoint_props ( OMath );
CREATE INDEX codepoint_props_Hex ON codepoint_props ( Hex );
CREATE INDEX codepoint_props_AHex ON codepoint_props ( AHex );
CREATE INDEX codepoint_props_DI ON codepoint_props ( DI );
CREATE INDEX codepoint_props_ODI ON codepoint_props ( ODI );
CREATE INDEX codepoint_props_LOE ON codepoint_props ( LOE );
CREATE INDEX codepoint_props_WSpace ON codepoint_props ( WSpace );
CREATE INDEX codepoint_props_vo ON codepoint_props ( vo );
CREATE INDEX codepoint_props_RI ON codepoint_props ( RI );
CREATE INDEX codepoint_props_Gr_Base ON codepoint_props ( Gr_Base );
CREATE INDEX codepoint_props_Gr_Ext ON codepoint_props ( Gr_Ext );
CREATE INDEX codepoint_props_OGr_Ext ON codepoint_props ( OGr_Ext );
CREATE INDEX codepoint_props_Gr_Link ON codepoint_props ( Gr_Link );
CREATE INDEX codepoint_props_GCB ON codepoint_props ( GCB );
CREATE INDEX codepoint_props_WB ON codepoint_props ( WB );
CREATE INDEX codepoint_props_SB ON codepoint_props ( SB );
CREATE INDEX codepoint_props_Ideo ON codepoint_props ( Ideo );
CREATE INDEX codepoint_props_UIdeo ON codepoint_props ( UIdeo );
CREATE INDEX codepoint_props_IDSB ON codepoint_props ( IDSB );
CREATE INDEX codepoint_props_IDST ON codepoint_props ( IDST );
CREATE INDEX codepoint_props_Radical ON codepoint_props ( Radical );
CREATE INDEX codepoint_props_Dep ON codepoint_props ( Dep );
CREATE INDEX codepoint_props_VS ON codepoint_props ( VS );
CREATE INDEX codepoint_props_NChar ON codepoint_props ( NChar );
CREATE INDEX codepoint_props_unihan ON codepoint_props ( unihan );
CREATE INDEX codepoint_props_Emoji ON codepoint_props ( Emoji );
CREATE INDEX codepoint_props_EPres ON codepoint_props ( EPres );
CREATE INDEX codepoint_props_EMod ON codepoint_props ( EMod );
CREATE INDEX codepoint_props_EBase ON codepoint_props ( EBase );
CREATE INDEX codepoint_props_EComp ON codepoint_props ( EComp );
CREATE INDEX codepoint_props_ExtPict ON codepoint_props ( ExtPict );
CREATE INDEX codepoint_props_ID_Compat_Math_Start ON codepoint_props ( ID_Compat_Math_Start );
CREATE INDEX codepoint_props_ID_Compat_Math_Continue ON codepoint_props ( ID_Compat_Math_Continue );
CREATE INDEX codepoint_props_IDSU ON codepoint_props ( IDSU );