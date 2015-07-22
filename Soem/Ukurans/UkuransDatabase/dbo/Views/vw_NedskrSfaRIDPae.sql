
CREATE view [dbo].[vw_NedskrSfaRIDPae]
-- Kalkuler nedskrivningsprocent som følge af lang rækkevidde
as
Select ftm.Materiale, ftm.Dim_Materiale, ftm.Dim_Tid
,dlh.LitraGr2
,dlh.RID_NedskrTekst
,dlh.RID_NedskrFaktor
,ftm.MinRID
,ftm.Forbrug_pr_dag
,Case when ftm.MinRid > 365 then case	when dlh.RID_NedskrFaktor is null							
										then case	when dlh2.RID_NedskrFaktor is null				
													then Power(0.999749131299698,ftm.MinRID)-1		-- Manuel nedskrivningsfaktor (aktuelle)
													else Power(dlh2.RID_NedskrFaktor,ftm.MinRID)-1	
											 end
										else Power(dlh.RID_NedskrFaktor,ftm.MinRID)-1				
								 end
							Else 0 
 end As RaekkeNedskrPct	
From edw.FT_MinRID ftm

Left Join [edw].[Dim_Materiale] dm 
On ftm.Materiale = dm.Materiale
	and convert(datetime, substring(replace(convert(varchar, dm.GyldigFra, 102), '.', '-'), 1, 8) + '01') 
		 <= (select left(Vaerdi, 8) + '01' from [edw].[MD_Styringstabel] where parameter = 'PrimoDato')
    and dm.GyldigTil >= ( select Vaerdi from [edw].[MD_Styringstabel] where parameter = 'PrimoDato')
Left Join edw.[Dim_Litra] dlh 
on dm.LitraGr2 = dlh.LitraGr2
and dlh.GyldigFra <= ( select Vaerdi from [edw].[MD_Styringstabel] where parameter = 'PrimoDato')
and dlh.GyldigTil >= ( select Vaerdi from [edw].[MD_Styringstabel] where parameter = 'PrimoDato')

-- når et nyere materiale ikke har en observation tilbage i tid, da anvendes nuværende [Dim_Litra]
Left Join [edw].[Dim_Materiale] dm2 
On ftm.Materiale = dm2.Materiale
	and convert(datetime, substring(replace(convert(varchar, dm2.GyldigFra, 102), '.', '-'), 1, 8) + '01') 
		 <= (select left(Vaerdi, 8) + '01' from [edw].[MD_Styringstabel] where parameter = 'PrimoDato')
    and dm2.GyldigTil >= ( select Vaerdi from [edw].[MD_Styringstabel] where parameter = 'PrimoDato')
    and dm2.GyldigTil >= ( select Vaerdi from [edw].[MD_Styringstabel] where parameter = 'UltimoDato')
Left Join edw.[Dim_Litra] dlh2 
on dm2.LitraGr2 = dlh2.LitraGr2
and dlh2.GyldigFra <= ( select Vaerdi from [edw].[MD_Styringstabel] where parameter = 'PrimoDato')
and dlh2.GyldigTil >= ( select Vaerdi from [edw].[MD_Styringstabel] where parameter = 'PrimoDato')

Where ftm.Dim_Tid =  ( select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'UltimoDato')
	and dm.OmlVare is null 
	and ftm.MinRID > 365