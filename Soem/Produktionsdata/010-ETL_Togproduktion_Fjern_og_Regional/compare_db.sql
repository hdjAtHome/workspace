/*afvikles i SQLCMD mode. Query - SQLCMD*/

:CONNECT oesmsqlt01\soem
SELECT
--*
--count(*),sum(togkm),sum(togminutter)
--count(*),sum(litrakm)
count(*),sum(antaltog) /*Broafgifter*/
--count(*),sum(antaltog_udenafgift),sum(antaltog_medafgift) /*Strkafgifter*/
--count(*),sum(antal),sum(afgift_kr) /*Togproduktion_Afgifter*/ 
--sum(togkm),sum(togtimer) /*Baneafgifter*/
FROM  mdw_udv1.
--[edw].[FT_Togproduktion_Afgifter]
--[edw].[FT_Togproduktion_Litra]
--[edw].[FT_Togproduktion_tog]
[edw].[FT_Togproduktion_Togstandsninger]
--[ods].[RDP_Strkafgifter]
--[ods].[RDH_Strkafgifter]
--[ods].[RD_Strkafgifter]
--[ods].[RDH_Broafgifter]
--[ods].[RD_Broafgifter]
--[ods].[RDP_Broafgifter]
--[ods].[RDP_Baneafgifter]
--[ods].[RD_Baneafgifter]
--[ods].[RDH_Baneafgifter]
--[edw].[DI_Materiale]

--where maaned='201503' /*Broafgifter Strkafgifter  */
where fk_di_tid='201503' --and [status]='oprindelig'/*Togproduktion_Afgifter*/
--where fk_di_tid between 20150301 and 20150331-- and [status]='oprindelig'/*Togproduktion_Litra*/
--group by AT_Togkategori
--order by fk_di_togsystem,at_togkategori,at_afgiftsdriver
--with  cube
go

:CONNECT mssqlp01\alpha
SELECT 
--*
--count(*),sum(togkm),sum(togminutter)
--count(*),sum(litrakm)
count(*),sum(antaltog) /*Broafgifter*/
--count(*),sum(antaltog_udenafgift),sum(antaltog_medafgift) /*Strkafgifter*/
--count(*),sum(antal),sum(afgift_kr) /*Togproduktion_Afgifter*/
--sum(togkm),sum(togtimer) /*Baneafgifter*/
FROM [mssqlp01\alpha].mdw.
--[edw].[FT_Togproduktion_Afgifter] /*diff*/
--[edw].[FT_Togproduktion_Litra]
--[edw].[FT_Togproduktion_tog]
[edw].[FT_Togproduktion_Togstandsninger]
--[ods].[RDP_Strkafgifter]
--[ods].[RDH_Strkafgifter]
--[ods].[RD_Strkafgifter]
--[ods].[RDH_Broafgifter]
--[ods].[RD_Broafgifter]
--[ods].[RDP_Broafgifter]
--[ods].[RDP_Baneafgifter]
--[ods].[RD_Baneafgifter]
--[ods].[RDH_Baneafgifter]
--[edw].[DI_Materiale]

--where maaned='201503' /*Broafgifter Strkafgifter  */
where fk_di_tid='201503' --and [status]='oprindelig'/*Togproduktion_Afgifter*/
--where fk_di_tid between 20150301 and 20150331 --and [status]='oprindelig'/*Togproduktion_Litra*/
--group by AT_Togkategori
--order by fk_di_togsystem,at_togkategori,at_afgiftsdriver
--with cube
go

