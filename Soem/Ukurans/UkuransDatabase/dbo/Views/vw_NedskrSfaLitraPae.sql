CREATE view [dbo].[vw_NedskrSfaLitraPae]
as
select dm.pk_id Dim_Materiale, dm.Materiale, dm.FTrDato
,dm.LitraGr2
,Case when dlh.LitraNedskrPct is not null 
     then  dlh.LitraNedskrPct 
     Else 0 
     End As LitraNedskrPct
from edw.Dim_Materiale dm
left join edw.[Dim_Litra] dlh
on dm.LitraGr2 = dlh.LitraGr2
and dlh.GyldigFra <= (select left(Vaerdi, 8) + '01' from [edw].[MD_Styringstabel] where parameter = 'PrimoDato') 
and dlh.GyldigTil >= ( select Vaerdi from [edw].[MD_Styringstabel] where parameter = 'PrimoDato')
where convert(datetime, substring(replace(convert(varchar, dm.GyldigFra, 102), '.', '-'), 1, 8) + '01') 
		<= (select left(Vaerdi, 8) + '01' from [edw].[MD_Styringstabel] where parameter = 'PrimoDato')
   and dm.GyldigTil >= ( select Vaerdi from [edw].[MD_Styringstabel] where parameter = 'PrimoDato')   and dm.OmlVare is null