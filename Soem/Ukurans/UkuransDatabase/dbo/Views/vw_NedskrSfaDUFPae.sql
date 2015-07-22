
CREATE view [dbo].[vw_NedskrSfaDUFPae]
as
-- Kalkuler nedskrivningsprocent som følge af langsomt omsættelighed
Select ftm.Materiale, ftm.Dim_Materiale, ftm.Dim_Tid
,ftm.MinDuf
,dm.LitraGr2
,dlh.DUF_NedskrAar
,	Case when ftm.MinDUF Is Null then 0
		when ftm.MinDUF < 366 then 0
		when ftm.MinDUF > 2555 then -1
		when dlh.DUF_NedskrAar = 3 then md.Tidshorisont3
		when dlh.DUF_NedskrAar = 5 then md.Tidshorisont5
		when dlh.DUF_NedskrAar = 7 then md.Tidshorisont7
		Else Null
	End as LangNedskrPct
From [edw].[ft_MinDUF] ftm
Left Join [edw].[Dim_Materiale] dm
On ftm.Materiale = dm.Materiale
   and convert(datetime, substring(replace(convert(varchar, dm.GyldigFra, 102), '.', '-'), 1, 8) + '01') 
		<= (select left(Vaerdi, 8) + '01' from [edw].[MD_Styringstabel] where parameter = 'PrimoDato')
   and dm.GyldigTil >= ( select Vaerdi from [edw].[MD_Styringstabel] where parameter = 'PrimoDato')
Left Join edw.[Dim_Litra] dlh 
on dm.LitraGr2 = dlh.LitraGr2
and dlh.GyldigFra <= ( select Vaerdi from [edw].[MD_Styringstabel] where parameter = 'PrimoDato')
and dlh.GyldigTil >= ( select Vaerdi from [edw].[MD_Styringstabel] where parameter = 'PrimoDato')
full outer Join [ods].[MD_MatDUF_NedskrPct] md 
On ftm.MinDUF = md.DUF
Where ftm.Dim_Tid= ( select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'UltimoDato')
	and dm.OmlVare is null 
	and ftm.MinDUF > 365