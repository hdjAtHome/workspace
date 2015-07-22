
CREATE view [dbo].[vw_NedskrSfaDUFProg] 
as
-- Beregner nedskrivningsprocent som følge af langsomt omsætteligheds Prognose
-- Prognosen beregnes på bagrung af Ultimo periode (dvs. sidst indlæsnings måned)
select q1.Dim_Fabrik, q1.Materiale, q1.Dim_Materiale, q1.Dim_Tid, left(q1.FraTil_Tid, 13) FraTil_Tid,
q1.Beholdning, q1.Vaerdi_GP, q1.GlidGnsPris, q1.Vaerdi_SP,
q1.MinDUF, q1.DUF_DagtilProg, 
q1.LitraGr2, q1.DUF_NedskrAar
,	Case when q1.DUF_DagtilProg Is Null then 0
		when q1.DUF_DagtilProg < 366 then 0
		when q1.DUF_DagtilProg > 2555 then -1
		when q1.DUF_NedskrAar = 3 then md.Tidshorisont3
		when q1.DUF_NedskrAar = 5 then md.Tidshorisont5
		when q1.DUF_NedskrAar = 7 then md.Tidshorisont7
		Else Null
	End as ProgNedskrPct
from (
Select ftb.Dim_Fabrik, ftb.Materiale, ftb.Dim_Materiale, ftb.Dim_Tid,
replace(left(convert(varchar,( SELECT replace(left(Vaerdi, 7), '-', '')
								FROM [edw].[MD_Styringstabel]
								where parameter = 'UltimoDato'
							  ), 102), 7), '.', '') + '-' + 
replace(left(convert(varchar,( SELECT replace(left(Vaerdi, 7), '-', '')
								FROM [edw].[MD_Styringstabel]
								where parameter = 'PrognBeregDato'
							  ), 102), 7), '.', '') FraTil_Tid,
ftb.Beholdning, ftb.Vaerdi_GP, ftb.GlidGnsPris, ftb.Vaerdi_SP
,ftm.MinDuf
,ftm.MinDuf
+ datediff( day, 
( SELECT Vaerdi
  FROM [edw].[MD_Styringstabel]
  where parameter = 'UltimoDato'
 ),
(
SELECT Vaerdi
  FROM [edw].[MD_Styringstabel]
  where parameter = 'PrognBeregDato'
 )
 ) as DUF_DagtilProg
,dm.LitraGr2
,dlh.DUF_NedskrAar
From edw.ft_beholdning ftb
left join [edw].[ft_MinDUF] ftm
on ftb.Dim_Materiale = ftm.Dim_Materiale and ftb.Dim_Tid = ftm.Dim_Tid
Left Join [edw].[Dim_Materiale] dm
On ftb.Materiale = dm.Materiale
   and convert(datetime, substring(replace(convert(varchar, dm.GyldigFra, 102), '.', '-'), 1, 8) + '01') 
		<= convert(datetime, ( select Vaerdi from [edw].[MD_Styringstabel] where parameter = 'UltimoDato'))
   and dm.GyldigTil >= convert(datetime, ( select Vaerdi from [edw].[MD_Styringstabel] where parameter = 'UltimoDato'))
Left Join edw.[Dim_Litra] dlh 
on dm.LitraGr2 = dlh.LitraGr2
and dlh.GyldigFra <= convert(datetime, ( select Vaerdi from [edw].[MD_Styringstabel] where parameter = 'UltimoDato'))
and dlh.GyldigTil >= convert(datetime, ( select Vaerdi from [edw].[MD_Styringstabel] where parameter = 'UltimoDato'))

Where ftb.Dim_Tid= ( select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'UltimoDato')
	and dm.OmlVare is null 
--	and ftm.MinDUF > 365
    and isnull(ftb.Vaerdi_GP, 0) <> 0
) q1
Left Join [ods].[MD_MatDUF_NedskrPct] md 
On q1.DUF_DagtilProg = md.DUF