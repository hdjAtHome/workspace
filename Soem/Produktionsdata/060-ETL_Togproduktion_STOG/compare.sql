 /*
 ods.rd_stog_korelobtider OK
 ods.md_stog_stationer
 ods.rd_stog_Straekninger
 edw.di_s_station_straekning
 edw.DI_S_Materiel
 ods.MD_Stog_litra_typer
edw.DI_S_Straekning
 ods.MD_Stog_finger_straekninger
edw.DI_S_Doegn_Inddeling
ods.MD_Stog_DoegnInddeling
edw.FT_Togproduktion_S_Tog
[etl].[edw_togproduktion_s_tog_set_tidsinterval] 
dbo.getIsDanishHolyDay
dbo.UgedagNummer
[etl].[edw_TD_S_materiale_til_Litra_mapping]
edw.FT_Togproduktion_S_Tog_Litra
[etl].[TD_S_materiale_til_Litra_mapping]


 */
 /*afvikles i SQLCMD mode. Query - SQLCMD*/

:CONNECT oesmsqlt01\soem
--truncate table [MDW_udv1].edw.di_s_station_straekning 
--go
SELECT 
--*
count(*),sum([Litrakm]),sum([Pladskm])  
FROM  mdw_udv1.
--ods.rd_stog_korelobtider
--ods.md_stog_stationer
--ods.rd_stog_Straekninger
--edw.di_s_station_straekning
--edw.DI_S_Materiel
--ods.MD_Stog_finger_straekninger
--edw.DI_S_Straekning
edw.FT_Togproduktion_S_Tog_Litra
where [DI_Tid] between '20150301' and '20150331'
--with cube
go

:CONNECT mssqlp01\alpha
SELECT
--*
count(*),sum([Litrakm]),sum([Pladskm])
FROM mdw.
--ods.rd_stog_korelobtider
--ods.md_stog_stationer
--ods.rd_stog_Straekninger
--edw.di_s_station_straekning
--edw.DI_S_Materiel
--ods.MD_Stog_finger_straekninger
--edw.DI_S_Straekning
edw.FT_Togproduktion_S_Tog_Litra
where [DI_Tid] between '20150301' and '20150331'
--with cube
go