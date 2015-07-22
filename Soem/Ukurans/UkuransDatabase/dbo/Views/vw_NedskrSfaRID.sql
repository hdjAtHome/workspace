CREATE view [dbo].[vw_NedskrSfaRID] -- OK
-- Kalkuler nedskrivningsprocent som følge af lang rækkevidde
as
Select ftm.Materiale, ftm.Dim_Materiale, ftm.Dim_Tid
,dlh.LitraGr2
,dlh.RID_NedskrTekst
,dlh.RID_NedskrFaktor
,ftm.MinRID
,ftm.Forbrug_pr_dag
,Case when ftm.MinRid > 365 then  Power(dlh.RID_NedskrFaktor,ftm.MinRID)-1 Else 0 End As RaekkeNedskrPct
From edw.FT_MinRID ftm
Left Join [edw].[Dim_Materiale] dm 
On ftm.Dim_Materiale = dm.pk_id 
Left Join edw.[Dim_Litra] dlh 
On dm.Litra_PKID = dlh.PK_ID
Where ftm.Dim_Tid =  ( select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'UltimoDato')
	and dm.OmlVare is null 
--	and ftm.MinRID > 365