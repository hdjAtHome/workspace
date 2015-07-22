








CREATE view [dbo].[vw_Reelle_Ekstra_Nedskr]
-- Ajourført 150120-1: Først kreeret indeholdende reelle statusnedskrivninger brutto og netto samt reelle litranedskrivninger

as
Select 'STATUS_REELT_BR' as Dim_Aendring
      ,a.Dim_Fabrik
      ,a.Materiale
      ,a.Dim_Materiale
      ,a.LNType
      ,a.FLNType
      ,a.FraTil_tid
      ,a.Vaerdi_GP as AnskVaerdi
      ,sum((LavNedPct-dbo.minNedSkrPctVaerdi(b.Langnedskrpct,b.Langnedskrpct,b.Raekkenedskrpct,b.Litranedskrpct))* b.Vaerdi_GP) as NedForPrinc
	,Case	When	sum((LavNedPct-dbo.minNedSkrPctVaerdi(a.Langnedskrpct,a.Langnedskrpct,a.Raekkenedskrpct,a.Litranedskrpct))* a.Vaerdi_GP)
					<> 0 
			Then	Case	When	sum((LavNedPct-dbo.minNedSkrPctVaerdi(b.Langnedskrpct,b.Langnedskrpct,b.Raekkenedskrpct,b.Litranedskrpct))* b.Vaerdi_GP)
									<> 0 
							Then	sum((LavNedPct-dbo.minNedSkrPctVaerdi(a.Langnedskrpct,a.Langnedskrpct,a.Raekkenedskrpct,a.Litranedskrpct))* a.Vaerdi_GP)	
									- sum((LavNedPct-dbo.minNedSkrPctVaerdi(b.Langnedskrpct,b.Langnedskrpct,b.Raekkenedskrpct,b.Litranedskrpct))* b.Vaerdi_GP)
							Else	sum((LavNedPct-dbo.minNedSkrPctVaerdi(a.Langnedskrpct,a.Langnedskrpct,a.Raekkenedskrpct,a.Litranedskrpct))* a.Vaerdi_GP)
					End
			Else	Case	When	sum((LavNedPct-dbo.minNedSkrPctVaerdi(b.Langnedskrpct,b.Langnedskrpct,b.Raekkenedskrpct,b.Litranedskrpct))* b.Vaerdi_GP)
									<> 0
							Then	sum((LavNedPct-dbo.minNedSkrPctVaerdi(b.Langnedskrpct,b.Langnedskrpct,b.Raekkenedskrpct,b.Litranedskrpct))* b.Vaerdi_GP)
									* -1
							Else	0
					End
	End as DSystAendr
      ,sum((LavNedPct-dbo.minNedSkrPctVaerdi(a.Langnedskrpct,a.Langnedskrpct,a.Raekkenedskrpct,a.Litranedskrpct))* a.Vaerdi_GP) as NedskrNetto
      ,a.Beholdning
      ,a.Vaerdi_SP
      ,a.Forskel
From edw.FT_Nedskriv a
Left join dbo.vw_Nedskriv_Pae b on a.Dim_Fabrik = b.Dim_Fabrik and a.Dim_Materiale = b.Dim_Materiale
Where a.FraTil_Tid = (select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'PrimoDato') 
		+ '-' +(select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'UltimoDato')
	and a.LNType = 'Stat'
Group by 
       a.Dim_Fabrik
      ,a.Materiale
      ,a.Dim_Materiale
      ,a.LNType
      ,a.FLNType
      ,a.FraTil_tid
      ,a.Vaerdi_GP 
      ,a.Beholdning
      ,a.Vaerdi_SP
      ,a.Forskel
      
union all

Select 'STATUS_REELT_NT' as Dim_Aendring
      ,a.Dim_Fabrik
      ,a.Materiale
      ,a.Dim_Materiale
      ,a.LNType
      ,a.FLNType
      ,a.FraTil_tid
      ,a.Vaerdi_GP as AnskVaerdi
	  ,(sum((isnull(b.NedKorrNytMatpae, 0) + isnull(b.NedKorrIndkpae, 0))
		  -(isnull(b.NedKorrNytMatpae, 0)+ isnull(b.NedKorrIndkpae, 0))
		  /(dbo.minNedSkrPctVaerdi(b.Statusnedskrpct,b.Langnedskrpct,b.Raekkenedskrpct,b.Litranedskrpct))
		  * (dbo.minNedSkrPctVaerdi(b.Langnedskrpct,b.Langnedskrpct,b.Raekkenedskrpct,b.Litranedskrpct)) 
		  + (LavNedPct-dbo.minNedSkrPctVaerdi(b.Langnedskrpct,b.Langnedskrpct,b.Raekkenedskrpct,b.Litranedskrpct))
		  * b.Vaerdi_GP))
		  as NedForPrinc
	,Case	When	(sum((isnull(a.NedKorrNytMat, 0) + isnull(a.NedKorrIndk, 0))
					  -(isnull(a.NedKorrNytMat, 0)+ isnull(a.NedKorrIndk, 0))
					  /(dbo.minNedSkrPctVaerdi(a.Statusnedskrpct,a.Langnedskrpct,a.Raekkenedskrpct,a.Litranedskrpct))
					  * (dbo.minNedSkrPctVaerdi(a.Langnedskrpct,a.Langnedskrpct,a.Raekkenedskrpct,a.Litranedskrpct)) 
					  + (LavNedPct-dbo.minNedSkrPctVaerdi(a.Langnedskrpct,a.Langnedskrpct,a.Raekkenedskrpct,a.Litranedskrpct))
					  * a.Vaerdi_GP))
					<> 0 
			Then	Case	When	(sum((isnull(b.NedKorrNytMatpae, 0) + isnull(b.NedKorrIndkpae, 0))
									  -(isnull(b.NedKorrNytMatpae, 0)+ isnull(b.NedKorrIndkpae, 0))
									  /(dbo.minNedSkrPctVaerdi(b.Statusnedskrpct,b.Langnedskrpct,b.Raekkenedskrpct,b.Litranedskrpct))
									  * (dbo.minNedSkrPctVaerdi(b.Langnedskrpct,b.Langnedskrpct,b.Raekkenedskrpct,b.Litranedskrpct)) 
									  + (LavNedPct-dbo.minNedSkrPctVaerdi(b.Langnedskrpct,b.Langnedskrpct,b.Raekkenedskrpct,b.Litranedskrpct))
									  * b.Vaerdi_GP))
		  							<>	0 
							Then	(sum((isnull(a.NedKorrNytMat, 0) + isnull(a.NedKorrIndk, 0))
									  -(isnull(a.NedKorrNytMat, 0)+ isnull(a.NedKorrIndk, 0))
									  /(dbo.minNedSkrPctVaerdi(a.Statusnedskrpct,a.Langnedskrpct,a.Raekkenedskrpct,a.Litranedskrpct))
									  * (dbo.minNedSkrPctVaerdi(a.Langnedskrpct,a.Langnedskrpct,a.Raekkenedskrpct,a.Litranedskrpct)) 
									  + (LavNedPct-dbo.minNedSkrPctVaerdi(a.Langnedskrpct,a.Langnedskrpct,a.Raekkenedskrpct,a.Litranedskrpct))
									  * a.Vaerdi_GP))
		  							- (sum((isnull(b.NedKorrNytMatpae, 0) + isnull(b.NedKorrIndkpae, 0))
										  -(isnull(b.NedKorrNytMatpae, 0)+ isnull(b.NedKorrIndkpae, 0))
										  /(dbo.minNedSkrPctVaerdi(b.Statusnedskrpct,b.Langnedskrpct,b.Raekkenedskrpct,b.Litranedskrpct))
										  * (dbo.minNedSkrPctVaerdi(b.Langnedskrpct,b.Langnedskrpct,b.Raekkenedskrpct,b.Litranedskrpct)) 
										  + (LavNedPct-dbo.minNedSkrPctVaerdi(b.Langnedskrpct,b.Langnedskrpct,b.Raekkenedskrpct,b.Litranedskrpct))
										  * b.Vaerdi_GP))
							Else	(sum((isnull(a.NedKorrNytMat, 0) + isnull(a.NedKorrIndk, 0))
									  -(isnull(a.NedKorrNytMat, 0)+ isnull(a.NedKorrIndk, 0))
									  /(dbo.minNedSkrPctVaerdi(a.Statusnedskrpct,a.Langnedskrpct,a.Raekkenedskrpct,a.Litranedskrpct))
									  * (dbo.minNedSkrPctVaerdi(a.Langnedskrpct,a.Langnedskrpct,a.Raekkenedskrpct,a.Litranedskrpct)) 
									  + (LavNedPct-dbo.minNedSkrPctVaerdi(a.Langnedskrpct,a.Langnedskrpct,a.Raekkenedskrpct,a.Litranedskrpct))
									  * a.Vaerdi_GP))
					End
			Else	Case	When	(sum((isnull(b.NedKorrNytMatpae, 0) + isnull(b.NedKorrIndkpae, 0))
									  -(isnull(b.NedKorrNytMatpae, 0)+ isnull(b.NedKorrIndkpae, 0))
									  /(dbo.minNedSkrPctVaerdi(b.Statusnedskrpct,b.Langnedskrpct,b.Raekkenedskrpct,b.Litranedskrpct))
									  * (dbo.minNedSkrPctVaerdi(b.Langnedskrpct,b.Langnedskrpct,b.Raekkenedskrpct,b.Litranedskrpct)) 
									  + (LavNedPct-dbo.minNedSkrPctVaerdi(b.Langnedskrpct,b.Langnedskrpct,b.Raekkenedskrpct,b.Litranedskrpct))
									  * b.Vaerdi_GP))
		  							<>	0
							Then	(sum((isnull(b.NedKorrNytMatpae, 0) + isnull(b.NedKorrIndkpae, 0))
									  -(isnull(b.NedKorrNytMatpae, 0)+ isnull(b.NedKorrIndkpae, 0))
									  /(dbo.minNedSkrPctVaerdi(b.Statusnedskrpct,b.Langnedskrpct,b.Raekkenedskrpct,b.Litranedskrpct))
									  * (dbo.minNedSkrPctVaerdi(b.Langnedskrpct,b.Langnedskrpct,b.Raekkenedskrpct,b.Litranedskrpct)) 
									  + (LavNedPct-dbo.minNedSkrPctVaerdi(b.Langnedskrpct,b.Langnedskrpct,b.Raekkenedskrpct,b.Litranedskrpct))
									  * b.Vaerdi_GP))
									* -1
							Else	0
					End
	End as DSystAendr
      ,(sum((isnull(a.NedKorrNytMat, 0) + isnull(a.NedKorrIndk, 0))
		  -(isnull(a.NedKorrNytMat, 0)+ isnull(a.NedKorrIndk, 0))
		  /(dbo.minNedSkrPctVaerdi(a.Statusnedskrpct,a.Langnedskrpct,a.Raekkenedskrpct,a.Litranedskrpct))
		  * (dbo.minNedSkrPctVaerdi(a.Langnedskrpct,a.Langnedskrpct,a.Raekkenedskrpct,a.Litranedskrpct)) 
		  + (LavNedPct-dbo.minNedSkrPctVaerdi(a.Langnedskrpct,a.Langnedskrpct,a.Raekkenedskrpct,a.Litranedskrpct))* a.Vaerdi_GP)) as NedskrNetto
      ,a.Beholdning
      ,a.Vaerdi_SP
      ,a.Forskel
From edw.FT_Nedskriv a
Left join dbo.vw_Nedskriv_Pae b on a.Dim_Fabrik = b.Dim_Fabrik and a.Dim_Materiale = b.Dim_Materiale
Where FraTil_Tid = (select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'PrimoDato') 
		+ '-' +(select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'UltimoDato')
	and LNType = 'Stat'
Group by 
       a.Dim_Fabrik
      ,a.Materiale
      ,a.Dim_Materiale
      ,a.LNType
      ,a.FLNType
      ,a.FraTil_tid
      ,a.Vaerdi_GP 
      ,a.NedskrNettoPae
      ,a.NedskrNetto
      ,a.Beholdning
      ,a.Vaerdi_SP
      ,a.Forskel

Union all

Select 'LITRANEDSKR_REELT' as Dim_Aendring
      ,a.Dim_Fabrik
      ,a.Materiale
      ,a.Dim_Materiale
      ,a.LNType
      ,a.FLNType
      ,a.FraTil_tid
      ,a.Vaerdi_GP as AnskVaerdi
      ,sum((LavNedPct-dbo.minNedSkrPctVaerdi(b.Langnedskrpct,b.Langnedskrpct,b.Raekkenedskrpct,b.Raekkenedskrpct))* b.Vaerdi_GP) as NedForPrinc
	,Case	When	sum((LavNedPct-dbo.minNedSkrPctVaerdi(a.Langnedskrpct,a.Langnedskrpct,a.Raekkenedskrpct,a.Raekkenedskrpct))* a.Vaerdi_GP)
					<> 0 
			Then	Case	When	sum((LavNedPct-dbo.minNedSkrPctVaerdi(b.Langnedskrpct,b.Langnedskrpct,b.Raekkenedskrpct,b.Raekkenedskrpct))* b.Vaerdi_GP)
									<> 0 
							Then	sum((LavNedPct-dbo.minNedSkrPctVaerdi(a.Langnedskrpct,a.Langnedskrpct,a.Raekkenedskrpct,a.Raekkenedskrpct))* a.Vaerdi_GP)	
									- sum((LavNedPct-dbo.minNedSkrPctVaerdi(b.Langnedskrpct,b.Langnedskrpct,b.Raekkenedskrpct,b.Raekkenedskrpct))* b.Vaerdi_GP)
							Else	sum((LavNedPct-dbo.minNedSkrPctVaerdi(a.Langnedskrpct,a.Langnedskrpct,a.Raekkenedskrpct,a.Raekkenedskrpct))* a.Vaerdi_GP)
					End
			Else	Case	When	sum((LavNedPct-dbo.minNedSkrPctVaerdi(b.Langnedskrpct,b.Langnedskrpct,b.Raekkenedskrpct,b.Raekkenedskrpct))* b.Vaerdi_GP)
									<> 0
							Then	sum((LavNedPct-dbo.minNedSkrPctVaerdi(b.Langnedskrpct,b.Langnedskrpct,b.Raekkenedskrpct,b.Raekkenedskrpct))* b.Vaerdi_GP)
									* -1
							Else	0
					End
	End as DSystAendr
      ,sum((LavNedPct-dbo.minNedSkrPctVaerdi(a.Langnedskrpct,a.Langnedskrpct,a.Raekkenedskrpct,a.Raekkenedskrpct))* a.Vaerdi_GP) as NedskrNetto
      ,a.Beholdning
      ,a.Vaerdi_SP
      ,a.Forskel
From edw.FT_Nedskriv a
Left join dbo.vw_Nedskriv_Pae b on a.Dim_Fabrik = b.Dim_Fabrik and a.Dim_Materiale = b.Dim_Materiale
Where a.FraTil_Tid = (select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'PrimoDato') 
		+ '-' +(select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'UltimoDato')
	and a.LNType = 'Litr'
Group by 
       a.Dim_Fabrik
      ,a.Materiale
      ,a.Dim_Materiale
      ,a.LNType
      ,a.FLNType
      ,a.FraTil_tid
      ,a.Vaerdi_GP 
      ,a.Beholdning
      ,a.Vaerdi_SP
      ,a.Forskel