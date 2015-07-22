

CREATE view [dbo].[vw_NedskrSfaStat]
as
-- Kalkuler statusnedskrivning ved ekstraordinære forhold
-- Ajourført 140918-1: Rettelser ifm. særskilt håndtering af statusgruppe FLUK tilføjet (så FLUK ikke medtages deri)
-- Ajourført 140918-2: Særskilt håndtering af materialer med statusgruppe FLUK tilføjet
-- Ajourført 150327-1: Erstattet kriterie om aktiv FLUK til at være datostyret (så gamle regnskaber kan køres igen)
(Select ftd.Dim_Materiale, ftd.Materiale, ftd.Dim_Tid
,dsh.StatusGr2
,ftd.MinDuf
,dsh.DUF_NedskrAar as StatusDUF_NedskrAar	
,	Case when ftd.MinDUF < 366 and dsh.StatusGr2 Not in ('USN' , 'FLUK') then 0									-- FLUK Rettelse 140918-1
		when ftd.MinDUF > 2555 and dsh.StatusGr2 Not in ('USN' , 'FLUK') then -1								-- FLUK Rettelse 140918-1
		when dsh.DUF_NedskrAar = 3 then md.Tidshorisont3
		when dsh.DUF_NedskrAar = 5 then md.Tidshorisont5
		when dsh.DUF_NedskrAar = 7 then md.Tidshorisont7
		Else Null
	End as StatusNedskrPct
--	into #temp
From edw.ft_MinDUF ftd 
Left Join [edw].[Dim_Materiale] dm 
On ftd.Dim_Materiale = dm.pk_id
Left Join edw.[Dim_Litra] dlh 
On dm.Litra_PKID = dlh.PK_ID
Left Join [ods].[MD_MatDUF_NedskrPct] md 
On ftd.MinDUF = md.DUF
Left Join [edw].[Dim_StatusHierarki] dsh 
on dm.StatusGr2 = dsh.StatusGr2 and dsh.GyldigTil = '9999-12-31'
Where 
ftd.Dim_Tid = (select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'UltimoDato')
and dm.OmlVare is null 
	and ftd.MinDUF >= 365
	and dsh.StatusGr2 Not in ('USN' , 'FLUK')																	-- FLUK Rettelse 140918-1
)

Union 


-- Særskilt tilføjelse for ekstraordinære forhold sfa. FLUK ved 2. gennemløb af en periode, rettelser 140918-2
(Select ftd.Dim_Materiale, ftd.Materiale, ftd.Dim_Tid
,dsh.StatusGr2 
,ftd.MinDUF
,dlh.DUF_NedskrAar as StatusDUF_NedskrAar 
,z.FLUK_Pct																										-- FLUK 
From edw.ft_MinDUF ftd 
Left Join [edw].[Dim_Materiale] dm on ftd.Dim_Materiale = dm.pk_id 
Left Join edw.[Dim_Litra] dlh On dm.Litra_PKID = dlh.PK_ID
Left Join [ods].[MD_MatDUF_NedskrPct] md On ftd.MinDUF = md.DUF
Left Join [edw].[Dim_StatusHierarki] dsh on dm.StatusGr2 = dsh.StatusGr2 and dsh.GyldigTil = '9999-12-31'
Left join edw.MP_MatTid_Att z on ftd.Materiale = z.Materiale 
--  and z.Aktiv = 'J'  Rettet 150327-1: Gyldig FLUK rettet til datostyret join for at gamle regnskaber kan køres igen
	and z.GyldigFra <=  (select Vaerdi from [edw].[MD_Styringstabel] where parameter = 'UltimoDato')
	and z.GyldigTil >=  (select cast(left(vaerdi, 8) + '01' as datetime) from edw.md_styringstabel where parameter = 'UltimoDato')									-- FLUK Rettelse
Where ftd.Dim_Tid = (select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'UltimoDato')
and dm.OmlVare is null 
and ftd.MinDUF >= 365
and z.FLUK_Pct is not null																						-- FLUK 
)