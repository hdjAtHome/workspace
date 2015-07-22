 /*
dbo.GD_R_Baneafgifter_FR
dbo.GD_R_Togførertid_FR
dbo.GD_R_Lokoførertid_FR
dbo.GD_R_LønsumAnsættelsetype
[dbo].[GD_R_Lokoførertid_STog]
dbo.GD_R_Personaledata
dbo.[GD_R_RejseIndtægter_Togsystem_FR]
dbo.GD_R_RejserIndtægter_FR
dbo.GD_R_RejserIndtægter_Stog
[ods].[RD_Stog_Rejsedata]
dbo.GD_R_Togproduktion_FR
[dbo].[GD_R_Togproduktion_STog]
dbo.GD_R_Lokoførertid_FR_Fix
dbo.GD_R_Økonomi_Anlæg
dbo.GD_R_Økonomi_Drift

(views)
edw.ft_togproduktion_tog_IssueId42
edw.ft_togproduktion_litra_IssueId42

(prod)
[etl].[GD_Kopier_til_ny_periode] 

 */
 /*afvikles i SQLCMD mode. Query - SQLCMD*/

:CONNECT oesmsqlt01\soem
--truncate table [MDW_udv1].edw.di_s_station_straekning 
--go
SELECT 
--*
count(*),sum([Værdi])--,sum([Litrakm]),sum([Pladskm])  
FROM  mdw_udv1.
--dbo.GD_R_Baneafgifter_FR
--dbo.GD_R_Togførertid_FR
--dbo.GD_R_Lokoførertid_FR
--dbo.GD_R_LønsumAnsættelsetype
--[dbo].[GD_R_Lokoførertid_STog]
--dbo.GD_R_Personaledata
--dbo.[GD_R_RejseIndtægter_Togsystem_FR]
--dbo.GD_R_RejserIndtægter_FR
--dbo.GD_R_RejserIndtægter_Stog
--dbo.GD_R_Togproduktion_FR
[dbo].[GD_R_Togproduktion_STog]
where [PeriodeIndlæst]='201504'
--where [DI_Tid] between '20150301' and '20150331'
--with cube
go

:CONNECT mssqlt01\alpha
SELECT
--*
count(*),sum([Værdi])--,sum([Litrakm]),sum([Pladskm])
FROM poemaktuel.
--dbo.GD_R_Baneafgifter_FR
--dbo.GD_R_Togførertid_FR
--dbo.GD_R_Lokoførertid_FR
--dbo.GD_R_LønsumAnsættelsetype
--[dbo].[GD_R_Lokoførertid_STog]
--dbo.GD_R_Personaledata
--dbo.[GD_R_RejseIndtægter_Togsystem_FR]
--dbo.GD_R_RejserIndtægter_FR
--dbo.GD_R_RejserIndtægter_Stog
--dbo.GD_R_Togproduktion_FR
[dbo].[GD_R_Togproduktion_STog]
where [PeriodeIndlæst]='201503'
--where [DI_Tid] between '20150301' and '20150331'
--with cube
go