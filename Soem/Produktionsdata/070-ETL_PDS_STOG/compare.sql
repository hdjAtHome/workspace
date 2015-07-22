 /*
[ods].[RD_PDS_Lokofører_STOG]
ods.TD_Strækning_Mapping
[etl].[ods_TD_Strækning_Mapping_Standsninger]
[ods].[TD_Strækning_S_Lokofører_Opgaver]
edw.DI_S_Opgave_Straekning
edw.DI_S_Opgave_Lokofører
[edw].[FT_Lokopersonale_S_tog]
edw.DI_Depot
[etl].[get_loadinfo_pds_Stog]


 */
 /*afvikles i SQLCMD mode. Query - SQLCMD*/

:CONNECT oesmsqlt01\soem
--truncate table [MDW_udv1].[ods].[RD_PDS_Lokofører_STOG] 
--go
SELECT 
--*
count(*)
--count(*),sum([Litrakm]),sum([Pladskm])  
FROM  mdw_udv1.
--[ods].[RD_PDS_Lokofører_STOG]
--[ods].[TD_Strækning_Mapping]
--[ods].[TD_Strækning_S_Lokofører_Opgaver]
--edw.DI_S_Opgave_Straekning
--edw.DI_S_Opgave_Lokofører
[edw].[FT_Lokopersonale_S_tog]
--where E_DAY_DATE BETWEEN DATEADD(day, -1, '2015-03-01' ) AND DATEADD(month, 1, '2015-03-01')
--where [DI_Tid] between '20150301' and '20150331'
--with cube
go

:CONNECT mssqlp01\alpha
SELECT
--*
count(*)
--count(*),sum([Litrakm]),sum([Pladskm])
FROM mdw.
--[ods].[RD_PDS_Lokofører_STOG]
--[ods].[TD_Strækning_Mapping]
--[ods].[TD_Strækning_S_Lokofører_Opgaver]
--edw.DI_S_Opgave_Straekning
--edw.DI_S_Opgave_Lokofører
[edw].[FT_Lokopersonale_S_tog]
--where E_DAY_DATE BETWEEN DATEADD(day, -1, '2015-03-01' ) AND DATEADD(month, 1, '2015-03-01')
where [DI_Tid] between '20150301' and '20150331'
--with cube
go