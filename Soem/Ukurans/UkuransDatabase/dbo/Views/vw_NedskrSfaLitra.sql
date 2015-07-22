
CREATE view [dbo].[vw_NedskrSfaLitra]
as
select 
dm.pk_id Dim_Materiale, dm.Materiale, dm.FTrDato
,dm.LitraGr2
,Case when dlh.LitraNedskrPct is not null 
     then  dlh.LitraNedskrPct 
     Else 0 
     End As LitraNedskrPct
from edw.Dim_Materiale dm
left join edw.[Dim_Litra] dlh
on dm.Litra_PKID = dlh.PK_ID
where OmlVare is null