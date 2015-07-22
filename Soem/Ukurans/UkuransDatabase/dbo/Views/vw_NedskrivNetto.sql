

CREATE VIEW [dbo].[vw_NedskrivNetto]
-- 150522-1: Design rettet
AS
Select q1.Dim_Fabrik, q1.Dim_Materiale, q1.Materiale, q1.LNType, q1.FLNType, q1.FraTil_tid,
q1.AnskVaerdi, q1.NedForPrinc, q1.NedskrNetto, q1.Beholdning, q1.Vaerdi_SP
From (
		select lnb.Dim_Fabrik
		,lnb.Dim_Materiale
		,lnb.Materiale
		,isnull(lnb.LNType
		,'AUB') LNType, isnull(lnb.FLNType, 'AEPD') as FLNType
		,cast(( select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'PrimoDato') + '-' 
			+( select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'UltimoDato') as varchar(13)) as FraTil_tid
		,lnb.AnskVaerdi
		,isnull(lnb.NedForPrinc, 0) + isnull(kn36.NedForPrinc, 0) + isnull(ul12.NedForPrinc, 0) as NedForPrinc
		,isnull(lnb.NedskrNetto, 0) + isnull(kn36.NedskrNetto, 0) + isnull(ul12.NedskrNetto, 0) as NedskrNetto
		,lnb.Beholdning
		,lnb.Vaerdi_SP
		from dbo.vw_LogNedsBrutto lnb
		full outer join dbo.vw_KorrNyeMat36m kn36 on lnb.Dim_Fabrik = kn36.Dim_Fabrik and lnb.Dim_Materiale = kn36.Dim_Materiale
		full outer join dbo.vw_UltBeh_Indk12md ul12 on lnb.Dim_Fabrik = ul12.Dim_Fabrik and lnb.Dim_Materiale = ul12.Dim_Materiale
	) q1
Where q1.Dim_Fabrik is not null and q1.Dim_Materiale is not null