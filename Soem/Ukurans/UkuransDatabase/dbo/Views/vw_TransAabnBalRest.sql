
CREATE view [dbo].[vw_TransAabnBalRest]
as
Select vwtam.Dim_Fabrik
, vwtam.Dim_Materiale
, vwtam.Materiale
, vwtam.Dim_Tid
, sum(ftb.Beholdning) as BehIalt
, avg(ftb.GlidGnsPris) as NuvStkPris
, vwtam.AnskMgdIalt
, Case when (vwtam.AnskMgdIalt >= sum(ftb.Beholdning)) then 0
	Else (sum(ftb.Beholdning) - vwtam.AnskMgdIalt) End  RestAabnBalBeh
, Case when (vwtam.AnskMgdIalt >= sum(ftb.Beholdning)) then 0
	Else (sum(ftb.Beholdning) - vwtam.AnskMgdIalt) * avg(ftb.GlidGnsPris) End  RestAabnBalVaerdi
, Case	when substring(ftb.Materiale,1,2) = '91' then -0.8
		when substring(ftb.Materiale,1,2) = '96' then -0.7
		when substring(ftb.Materiale,1,2) = '97' then -0.8
		Else -0.25
	End as AabnBalNedskrPct
, (sum(ftb.Beholdning) - vwtam.AnskMgdIalt) * avg(ftb.GlidGnsPris)  *	Case	when substring(ftb.Materiale,1,2) = '91' then -0.8
		when substring(ftb.Materiale,1,2) = '96' then -0.7
		when substring(ftb.Materiale,1,2) = '97' then -0.8
		Else -0.25
	End as AabnBalNedskrVaerdi
--Into [edw].[TD37_MatTransAabnBalRest] 
From dbo.vw_TransAnskMgd vwtam
Left Join edw.ft_Beholdning ftb 
on vwtam.Dim_Fabrik = ftb.Dim_Fabrik and vwtam.Dim_Materiale = ftb.Dim_Materiale and vwtam.Dim_Tid = ftb.Dim_Tid
Where ftb.GlidGnsPris >0
Group by vwtam.Dim_Fabrik, vwtam.Materiale, vwtam.Dim_Materiale, ftb.Materiale, vwtam.Dim_Tid, vwtam.AnskMgdIalt
--With rollup
Having vwtam.AnskMgdIalt < sum(ftb.Beholdning)