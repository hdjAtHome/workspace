
CREATE view [dbo].[vw_Nedskriv]
as
SELECT ns.[Dim_Fabrik]
      ,ns.[Dim_Materiale]
      ,ns.[Materiale]
      , cast(( select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'PrimoDato')
       + '-' + ( select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'UltimoDato') as varchar(13)) FraTil_Tid
      ,ns.[Beholdning]
      ,ns.[Vaerdi_GP]
      ,ns.[GlidGnsPris]
      ,ns.[LitraGr2]
      ,ns.[LNType]
      ,nspae.[FLNType]
      ,ns.[LavNedPct]
      ,ns.[LogNedBrutto]
      ,nspae.[LogNedBruttoPae]
      ,Case When isnull(ns.LogNedBrutto, 0) < 0
		    Then Case when isnull(ns.NedKorrNytMat, 0) <> 0
					  then isnull(ns.LogNedBrutto, 0) + isnull(ns.NedKorrNytMat, 0)
					  Else Case when isnull(ns.[NedKorrIndk], 0) <> 0
							    then isnull(ns.LogNedBrutto, 0) + isnull(ns.[NedKorrIndk], 0)
							    Else isnull(ns.LogNedBrutto, 0)
							    End
					  End
			Else	0
			End as NedskrNetto
        ,Case When isnull(ns.LogNedBrutto, 0) < 0
		    Then Case when isnull(nspae.NedKorrNytMatPae, 0) <> 0
					  then isnull(ns.LogNedBrutto, 0) + isnull(nspae.NedKorrNytMatPae, 0)
					  Else Case when isnull(nspae.[NedKorrIndkPae], 0) <> 0
							    then isnull(ns.LogNedBrutto, 0) + isnull(nspae.[NedKorrIndkPae], 0)
							    Else isnull(ns.LogNedBrutto, 0)
							    End
					  End
			Else	0
			End as NedskrNettoPae
      ,ns.[NedKorrNytMat]
      ,nspae.[NedKorrNytMatPae]
      ,ns.[FTrMd]
      ,ns.[BrutIndk12mdMgd]
      ,ns.[StatusNedskrPct]
      ,ns.[LangNedskrPct]
      ,ns.[RaekkeNedskrPct]
      ,ns.[LitraNedskrPct]
      ,ns.[NedKorrIndk]
      ,nspae.LangNedskrPct Langpae
      ,nspae.RaekkeNedskrPct RaekPae
      ,nspae.LitraNedskrPct LitraPae
      ,nspae.StatusNedskrPct StatPae
      ,nspae.[NedKorrIndkPae]
      ,ns.[UltBehIndk12mdMgd]
      ,ns.[UltBehIndk12mdVd]
      ,ns.[Vaerdi_SP]
      ,ns.[Forskel]
      ,ns.[LitraNedVaerdi]
      ,ns.[DUF]
      ,ns.[LangNedVaerdi]
      ,ns.[RID]
      ,ns.[RaekkeNedVaerdi]
      ,ns.[StatNedVaerdi]
      ,ns.[StatNedReelt]
      ,ns.[RestAabnBalBeh]
      ,ns.[AabnNedPct]
      ,ns.[AabnBalNedVaerdi]
  FROM [dbo].[vw_Nedskriv_akt] ns
  left join dbo.vw_Nedskriv_Pae nspae
  on ns.Dim_Fabrik = nspae.Dim_Fabrik and ns.Dim_Materiale = nspae.Dim_Materiale