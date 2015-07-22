
CREATE PROC [etl].[Costpooling_R_Drift] @Periode varchar(50)
as 
BEGIN





 --Påsæt rækkenummer (row_number()) på rd_sap_drift. Rækkenummer bruges i costpoolingen til group by for at finde den højest prioriterede rækker
if object_id('tempdb..#GD_R_Økonomi_Drift_med_rækkeNummer') is not null drop table #GD_R_Økonomi_Drift_med_rækkeNummer
	select row_number() over (order by	[Profitcenter],
										[Profitcenternavn_dont_use],
										[Omkostningssted],
										[Omkostningsstednavn_dont_use],
										[Omkostningsart],
										[Omkostningsartnavn_dont_use],
										[PSP-element],
										[PSP-elementNavn_dont_use],
										[Ordre],
										[Ordrenavn_dont_use],
										[Litratype],
										[Litratypenavn_dont_use],
										[Delområde],
										[DelområdeNavn],
										[StationsNr],
										[StationsNavn],
										[StationsType],
										[StationsTypeNavn],
										[NøgleFastEjendom],
										Beløb,
										[indlæstTidspunktRådata],
										[indlæstAfRådata],
										[Momsstatus],
										[CeArtGrp],
										[CeArtGrpNavn],
										[ArtGrp],
										[ArtGrpNavn],
										[Variabilitet],
										[VariabilitetNavn],
										[Reversibilitet],
										[ReversibilitetNavn],
										[indlæstTidspunktMD_G_Stam_Artskontoplan]  ,
										[indlæstAfMD_G_Stam_Artskontoplan],
										[indlæstTidspunktGD_R_Økonomi_Drift],
										[indlæstAfGD_R_Økonomi_Drift],
										[Kilde_Beskrivelse],
										[Periode],
										[KildeArk]	) 
			as rækkeNummer, 
			*
	into #GD_R_Økonomi_Drift_med_rækkeNummer
	from 

		(select 
								[Profitcenter],
								[Profitcenternavn_dont_use],
								[Omkostningssted],
								[Omkostningsstednavn_dont_use],
								[Omkostningsart],
								[Omkostningsartnavn_dont_use],
								[PSP-element],
								[PSP-elementNavn_dont_use],
								[Ordre],
								[Ordrenavn_dont_use],
								[Litratype],
								[Litratypenavn_dont_use],
								[Delområde],
								[DelområdeNavn],
								[StationsNr],
								[StationsNavn],
								[StationsType],
								[StationsTypeNavn],
								[NøgleFastEjendom],
								convert(float,[FaktiskBeløb]) as Beløb,
								[indlæstTidspunktRådata],
								[indlæstAfRådata],
								[Momsstatus],
								[CeArtGrp],
								[CeArtGrpNavn],
								[ArtGrp],
								[ArtGrpNavn],
								[Variabilitet],
								[VariabilitetNavn],
								[Reversibilitet],
								[ReversibilitetNavn],
								[indlæstTidspunktManuelledata] as [indlæstTidspunktMD_G_Stam_Artskontoplan] ,
								[indlæstAfManuelleDAta] as [indlæstAfMD_G_Stam_Artskontoplan],
								[indlæstTidspunkt] as [indlæstTidspunktGD_R_Økonomi_Drift],
								[indlæstAf] as [indlæstAfGD_R_Økonomi_Drift],
								[Beskrivelse] as [Kilde_beskrivelse],
								[Periode],
								[KildeArk]
		from 
			dbo.GD_R_Økonomi_Drift where periode = @periode and faktiskbeløb is not null



	)  as A

where 
	CeArtGrp <> 'A' or [Omkostningsart] = '44444' --(det sidste er en undtagelse for at få manuelle anlægskorrektioner, der er lagt ind i drift-efterposter)
		-- and KontrolGrp <> 'Skat' --??





	--Påsæt #GD_R_Økonomi_Drift_med_rækkeNummer alle matchende rækker fra MD_K_COSTPOOL_KRITERIER_DRIFT - i første omgang uden hensyn til prioritet
	-- Id på MD_K_COSTPOOL_KRITERIER_DRIFT omdøbes til Prioritet
	if object_id('tempdb..#GD_R_Økonomi_Drift_med_rækkeNummer_left_joined_med_alle_matchende_costpool_uden_hensyn_til_prioritet') is not null drop table #GD_R_Økonomi_Drift_med_rækkeNummer_left_joined_med_alle_matchende_costpool_uden_hensyn_til_prioritet
	select 
			convert(int,y.id) as Prioritet, 
			y.costpool, 
			x.rækkeNummer,
			x.[Profitcenter],
			x.[Profitcenternavn_dont_use],
			x.[Omkostningssted],
			x.[Omkostningsstednavn_dont_use],
			x.[Omkostningsart],
			x.[Omkostningsartnavn_dont_use],
			x.[PSP-element],
			x.[PSP-elementNavn_dont_use],
			x.[Ordre],
			x.[Ordrenavn_dont_use],
			x.[Litratype],
			x.[Litratypenavn_dont_use],
			x.[Delområde],
			x.[DelområdeNavn],
			x.[StationsNr],
			x.[StationsNavn],
			x.[StationsType],
			x.[StationsTypeNavn],
			x.[NøgleFastEjendom],
			x.[Beløb],
			x.[Momsstatus],
			x.[CeArtGrp],
			x.[CeArtGrpNavn],
			x.[ArtGrp],
			x.[ArtGrpNavn],
			x.[Variabilitet],
			x.[VariabilitetNavn],
			x.[Reversibilitet],
			x.[ReversibilitetNavn],
			x.[indlæstTidspunktRådata],
			x.[indlæstAfRådata],
			x.[indlæstTidspunktMD_G_Stam_Artskontoplan] ,
			x.[indlæstAfMD_G_Stam_Artskontoplan],
			x.[indlæstTidspunktGD_R_Økonomi_Drift],
			x.[indlæstAfGD_R_Økonomi_Drift],
			x.[Kilde_Beskrivelse],
			x.[Periode]	,
			x.[KildeArk]
	into 
			#GD_R_Økonomi_Drift_med_rækkeNummer_left_joined_med_alle_matchende_costpool_uden_hensyn_til_prioritet
	from 
			#GD_R_Økonomi_Drift_med_rækkeNummer x
				left outer join 
			dbo.MD_G_KRIT_Costpool_Drift as y 
		on 
		(
				(x.profitcenter			between y.pctrfra and y.pctrTil					OR (y.pctrfra is null or y.pctrtil is null))
			and	(x.[Omkostningssted]	between y.omkstedfra and y.omkstedTil			OR (y.omkstedfra is null or y.omkstedTil is null))
			and	(x.Omkostningsart		between y.ArtFra and y.ArtTil					OR (y.ArtFra is null or y.ArtTil is null))
			and	(x.ArtGrp				between y.ArtGrpFra and y.ArtGrpTil				OR (y.ArtGrpFra is null or y.ArtGrpTil is null))
			and	(x.Litratype			between y.LitraFra and y.LitraTil				OR (y.LitraFra is null or y.LitraTil is null))
			and	(x.[CeArtGrp]			between y.CeArtGrpFra and y.CeArtGrpTil			OR (y.CeArtGrpFra is null or y.CeArtGrpTil is null))
			and	(x.ordre				between y.OrdreFra and y.OrdreTil				OR (y.OrdreFra is null or y.OrdreTil is null))
			and	(x.[PSP-element]		between y.PSPFra and y.PSPTil					OR (y.PSPFra is null or y.PSPTil is null))
			and	(x.[Delområde]			between y.Delområdefra and y.Delområdetil		OR (y.Delområdefra is null or y.Delområdetil is null))
			and	(x.[StationsNr]			between y.StationsNrfra and y.StationsNrtil		OR (y.StationsNrfra is null or y.StationsNrtil is null))
			and	(x.[StationsType]		between y.StationsTypefra and y.StationsTypetil OR (y.StationsTypefra is null or y.StationsTypetil is null))
		)
--Virker ikke nu men skal implementeres når kriteriefilen er endelig: where y.model = 'G' or y.model = 'R'
	order by 
		x.rækkeNummer

	--Find den højest prioriterede (svarende til minimum) matchende costpool pr rækkeNummer
	select 
		min(prioritet) as min_prioritet, 
		rækkeNummer 
	into 
		#første_prioritet_pr_rækkeNummer
	from 
		#GD_R_Økonomi_Drift_med_rækkeNummer_left_joined_med_alle_matchende_costpool_uden_hensyn_til_prioritet
	group by 
		rækkeNummer

	
	--Påsæt (kun) den højest prioriterede costpool til k_drift
	if object_id('dbo.TD1_CD_G_ETL5_Ressourceportal_Drift') is not null drop table dbo.TD1_CD_G_ETL5_Ressourceportal_Drift
	select 
			x.rækkeNummer,
			x.[Profitcenter],
			x.[Profitcenternavn_dont_use] as [Profitcenternavn],
			x.[Omkostningssted],
			x.[Omkostningsstednavn_dont_use] as [Omkostningsstednavn],
			x.[Omkostningsart],
			x.[Omkostningsartnavn_dont_use] as [Omkostningsartnavn],
			x.[PSP-element],
			x.[PSP-elementNavn_dont_use] as [PSP-elementNavn],
			x.[Ordre],
			x.[Ordrenavn_dont_use] as [Ordrenavn] ,
			x.[Litratype],
			x.[Litratypenavn_dont_use] as [Litratypenavn],
			x.[Delområde],
			x.[DelområdeNavn],
			x.[StationsNr],
			x.[StationsNavn],
			x.[StationsType],
			x.[StationsTypeNavn],
			x.[NøgleFastEjendom],
		--	x.[Beskrivelse],
			x.[Beløb],
			x.[Momsstatus],
			x.[CeArtGrp],
			x.[CeArtGrpNavn],
			x.[ArtGrp],
			x.[ArtGrpNavn],
			x.[Variabilitet] as ATT_VarArt,
			x.[VariabilitetNavn] as ATT_VarArt_Navn,
			x.[Reversibilitet] as ATT_ResArt,
			x.[ReversibilitetNavn] as ATT_ResArt_Navn,
			x.[Kilde_Beskrivelse],
			x.[Periode],
			x.[KildeArk],
			z.costpool, 
			'R1_' + z.costpool + '_' + x.ceartgrp as Reference_ID,
 			r.Niveau,
			r.Sort,
			--r.Reference_ID,
			r.Reference_Name,
			r.Reference_Parent,
			rparent.Reference_Name as Reference_Name_Parent,
			r.Type,
			r.EvenlyAssigned,
			r.DriverName,
			r.Model,
			r.Aktiv,
			r.Beskrivelse as Ressource_Beskrivelse,
			r.ATT_ResType,
		
			r.indlæstTidspunkt as IndlæstTidspunktEX_MD_G_ACCHIER_Ressource,
		--	r.indlæstAf as IndlæstAfRessource, 
		--	x.[indlæstTidspunktRådata],
		--	x.[indlæstAfRådata],
			x.[indlæstTidspunktMD_G_Stam_Artskontoplan],
		--	x.[indlæstAfMD_G_Stam_Artskontoplan],
			x.[indlæstTidspunktGD_R_Økonomi_Drift]
		--	x.[indlæstAfGD_R_Økonomi_Drift] 
			
  
--kritrev.att_resart

	into 
		dbo.TD1_CD_G_ETL5_Ressourceportal_Drift
	from 
		#GD_R_Økonomi_Drift_med_rækkeNummer x 
			left outer join 
		#første_prioritet_pr_rækkeNummer y on x.rækkeNummer = y.rækkeNummer
			left outer join 
		#GD_R_Økonomi_Drift_med_rækkeNummer_left_joined_med_alle_matchende_costpool_uden_hensyn_til_prioritet z on y.min_prioritet =  z.prioritet and y.rækkeNummer = z.rækkeNummer
			left outer join 
		dbo.MD_G_ACCHIER_Ressource r on 'R1_' + z.costpool + '_' + x.ceartgrp = r.reference_id
			left outer join 
	 	dbo.MD_G_ACCHIER_Ressource rparent on r.reference_Parent = rparent.reference_id


	


--select 'y.'+quotename(name,'[')+',' from syscolumns where id = object_id('dbo.TD0_CD_G_ETL5_Ressourceportal_Drift')
	--Påsæt (kun) den højest prioriterede costpool til k_drift
	if object_id('dbo.TD2_CD_G_ETL5_Ressourceportal_Drift') is not null drop table dbo.TD2_CD_G_ETL5_Ressourceportal_Drift
	select 
		y.[rækkeNummer],
		y.[Profitcenter],
		y.[Profitcenternavn],
		y.[Omkostningssted],
		y.[Omkostningsstednavn],
		y.[Omkostningsart],
		y.[Omkostningsartnavn],
		y.[PSP-element],
		y.[PSP-elementNavn],
		y.[Ordre],
		y.[Ordrenavn],
		y.[Litratype],
		y.[Litratypenavn],
		y.[Delområde],
		y.[DelområdeNavn],
		y.[StationsNr],
		y.[StationsNavn],
		y.[StationsType],
		y.[StationsTypeNavn],
		y.[NøgleFastEjendom],
		y.[Beløb],
		y.[Momsstatus],
		y.[CeArtGrp],
		y.[CeArtGrpNavn],
		y.[ArtGrp],
		y.[ArtGrpNavn],
		y.[ATT_VarArt],
		y.[ATT_VarArt_Navn],
		y.[ATT_ResArt],
		y.[ATT_ResArt_Navn],
		y.[costpool],
		y.[Reference_ID],
		y.[Niveau],
		y.[Sort],
		y.[Reference_Name],
		y.[Reference_Parent],
		y.[Reference_Name_Parent],
		y.[Type],
		y.[EvenlyAssigned],
		y.[DriverName],
		y.[Model],
		y.[Aktiv],
		y.[Kilde_Beskrivelse],
		y.[Ressource_Beskrivelse],
		y.[ATT_ResType],
		y.[IndlæstTidspunktEX_MD_G_ACCHIER_Ressource],
		y.[indlæstTidspunktMD_G_Stam_Artskontoplan],
		y.[indlæstTidspunktGD_R_Økonomi_Drift],
		y.[Periode],
		y.[KildeArk],
		kritvar.Variabilitet,
		kritvar.VariabilitetNavn as Variabilitet_Navn
		

	into 
		dbo.TD2_CD_G_ETL5_Ressourceportal_Drift
	from 
		dbo.TD1_CD_G_ETL5_Ressourceportal_Drift y
			left outer join 
		dbo.md_g_krit_variabilitet kritvar on y.att_restype = kritvar.att_restype and y.ATT_VarArt = kritvar.att_varart
		
--Lav drivertabel for lønsumsfordelingen

if object_id('dbo.dr_r_lønsum_ansættelsestype') is not null drop table dbo.dr_r_lønsum_ansættelsestype

select 
	detalje.[Profitcenter],
	detalje.[ProfitcenterNavn],
	detalje.[Art],
	detalje.[ArtNavn],
	detalje.[Medarb_Grp],
	detalje.[Medarb_GrpNavn],
	detalje.[PeriodeIndlæst],
	--case when summenTabel.summen <> 0 then detalje.[Lønsum]/summenTabel.summen else 0 end as andel
	detalje.[Lønsum]/summenTabel.summen as andel
	
into 
	dbo.dr_r_lønsum_ansættelsestype
from
	[dbo].[GD_R_LønsumAnsættelsetype] as detalje
inner join 
		(SELECT 
			[Profitcenter],
			[Art],
			[PeriodeIndlæst],
			sum([Lønsum]) as summen
  		FROM 
			[dbo].[GD_R_LønsumAnsættelsetype]
		WHERE periodeIndlæst = @periode
		GROUP BY 
			profitcenter, art, [PeriodeIndlæst]
		HAVING ABS(sum([Lønsum])) > 0.00001 --- egentligt skulle det være HAVING sum(lønsum) <> 0, men nogle poster og modposter der skulle være ens summer til et meget lille beløb 0.0000000000x
		) as summenTabel on		
								detalje.profitcenter = summenTabel.profitcenter
								and detalje.art = summenTabel.art 
								and detalje.[PeriodeIndlæst] = summenTabel.[PeriodeIndlæst]
		
	order by profitcenter, art


--if object_id('dbo.CD_G_ETL5_Ressourceportal_Drift') is not null drop table dbo.CD_G_ETL5_Ressourceportal_Drift
delete from dbo.CD_G_ETL5_Ressourceportal_Drift where periode = @periode

Insert into dbo.CD_G_ETL5_Ressourceportal_Drift (
	[rækkeNummer],
	[Profitcenter],
	[Profitcenternavn],
	[Omkostningssted],
	[Omkostningsstednavn],
	[Omkostningsart],
	[Omkostningsartnavn],
	[PSP-element],
	[PSP-elementNavn],
	[Ordre],
	[Ordrenavn],
	[Litratype],
	[Litratypenavn],
	[Delområde],
	[DelområdeNavn],
	[StationsNr],
	[StationsNavn],
	[StationsType],
	[StationsTypeNavn],
	[NøgleFastEjendom],
	[Beløb],
	[Momsstatus],
	[CeArtGrp],
	[CeArtGrpNavn],
	[ArtGrp],
	[ArtGrpNavn],
	[ATT_VarArt],
	[ATT_VarArt_Navn],
	[ATT_ResArt],
	[ATT_ResArt_Navn],
	[costpool],
	[Reference_ID],
	[Niveau],
	[Sort],
	[Reference_Name],
	[Reference_Parent],
	[Reference_Name_Parent],
	[Type],
	[EvenlyAssigned],
	[DriverName],
	[Model],
	[Aktiv],
	[Kilde_Beskrivelse],
	[Ressource_Beskrivelse],
	[ATT_ResType],
	[IndlæstTidspunktEX_MD_G_ACCHIER_Ressource],
	[indlæstTidspunktMD_G_Stam_Artskontoplan],
	[indlæstTidspunktGD_R_Økonomi_Drift],
	[Variabilitet],
	[Variabilitet_Navn],
	[Reversibilitet],
	[Reversibilitet_Navn],
	[Medarb_Grp],
	[Periode],
	[KildeArk]
)

	select 
		z.[rækkeNummer],
		z.[Profitcenter],
		z.[Profitcenternavn],
		z.[Omkostningssted],
		z.[Omkostningsstednavn],
		z.[Omkostningsart],
		z.[Omkostningsartnavn],
		z.[PSP-element],
		z.[PSP-elementNavn],
		z.[Ordre],
		z.[Ordrenavn],
		z.[Litratype],
		z.[Litratypenavn],
		z.[Delområde],
		z.[DelområdeNavn],
		z.[StationsNr],
		z.[StationsNavn],
		z.[StationsType],
		z.[StationsTypeNavn],
		z.[NøgleFastEjendom],
		--z.[Beløb],
		case when z.beløb*driver.andel is not null then z.beløb*driver.andel else z.beløb end as Beløb,
		z.[Momsstatus],
		z.[CeArtGrp],
		z.[CeArtGrpNavn],
		z.[ArtGrp],
		z.[ArtGrpNavn],
		z.[ATT_VarArt],
		z.[ATT_VarArt_Navn],
		z.[ATT_ResArt],
		z.[ATT_ResArt_Navn],
		z.[costpool],
		z.[Reference_ID],
		z.[Niveau],
		z.[Sort],
		z.[Reference_Name],
		z.[Reference_Parent],
		z.[Reference_Name_Parent],
		z.[Type],
		z.[EvenlyAssigned],
		z.[DriverName],
		z.[Model],
		z.[Aktiv],
		z.[Kilde_Beskrivelse],
		z.[Ressource_Beskrivelse],
		z.[ATT_ResType],
		z.[IndlæstTidspunktEX_MD_G_ACCHIER_Ressource],
		z.[indlæstTidspunktMD_G_Stam_Artskontoplan],
		z.[indlæstTidspunktGD_R_Økonomi_Drift],
		z.[Variabilitet],
		z.[Variabilitet_Navn],
		--kritrev.Reversibilitet,
		isnull(kritrev.reversibilitet, z.[ATT_ResArt]) as Reversibilitet,		
		isnull(kritrev.[ReversibilietNavn], ATT_ResArt_Navn) as Reversibilitet_Navn,		
		--lønsum.[Medarb_Grp],
		--lønsum.[Medarb_GrpNavn],
		--lønsum.[PeriodeIndlæst],
		--lønsum.[Lønsum],
		driver.[Medarb_Grp],
		--andel,
		--z.beløb*andel as vægtetBeløb,
		z.[Periode],
		z.[KildeArk]
	from 
		dbo.TD2_CD_G_ETL5_Ressourceportal_Drift z
			left outer join 
	 	dr_r_lønsum_ansættelsestype driver  on	z.profitcenter = driver.profitcenter 
												and z.omkostningsart = driver.art
												and z.periode = driver.periodeIndlæst		
			left outer join 
		dbo.md_g_krit_reversibilitet kritRev on driver.[Medarb_Grp] = kritRev.ansættelsestype 


declare @fejlref varchar(8000)
select @fejlref = isnull(@fejlref+', ','') + reference_id  from dbo.CD_G_ETL5_Ressourceportal_drift where reference_name  is null
if ( @fejlref is not null and @fejlref <> '') 
begin
	declare @fejltekst varchar(8000)
	set @fejltekst = 'Ressourceportal_Drift. Reference_name er null for reference_id: ' + @fejlref
	raiserror(@fejltekst,16,1)
end
	

---UPDATE DIVERSE NAVNE FOR MANUELLE KORREKTIONER SÅ DE SVARER TIL SAP :
select distinct profitcenter, max(profitcenternavn) as profitcenternavn
into #dimProfitcenterSAPDrift
from dbo.CD_G_ETL5_Ressourceportal_Drift 
where kilde_beskrivelse = 'SAP Drift' and profitcenternavn is not null
group by profitcenter

update a 
set a.profitcenternavn = b.profitcenternavn
from
	dbo.CD_G_ETL5_Ressourceportal_Drift a
		inner join 
	#dimProfitcenterSAPDrift b on	a.profitcenter = b.profitcenter 
									and isnull(a.profitcenternavn,'') <> b.profitcenternavn
where a.kilde_beskrivelse <> 'SAP Drift'

-----
select distinct Omkostningssted, max(Omkostningsstednavn) as Omkostningsstednavn
into #dimOmkostningsstedSAPDrift
from dbo.CD_G_ETL5_Ressourceportal_Drift 
where kilde_beskrivelse = 'SAP Drift' and Omkostningsstednavn is not null
group by Omkostningssted

update a 
set a.Omkostningsstednavn = b.Omkostningsstednavn
from
	dbo.CD_G_ETL5_Ressourceportal_Drift a
		inner join 
	#dimOmkostningsstedSAPDrift b on	a.Omkostningssted = b.Omkostningssted 
									and isnull(a.Omkostningsstednavn,'') <> b.Omkostningsstednavn
where a.kilde_beskrivelse <> 'SAP Drift'
-----

select distinct Omkostningsart,max(Omkostningsartnavn) as Omkostningsartnavn
into #dimOmkostningsartSAPDrift
from dbo.CD_G_ETL5_Ressourceportal_Drift 
where kilde_beskrivelse = 'SAP Drift' and Omkostningsartnavn is not null
group by Omkostningsart

update a 
set a.Omkostningsartnavn = b.Omkostningsartnavn
from
	dbo.CD_G_ETL5_Ressourceportal_Drift a
		inner join 
	#dimOmkostningsartSAPDrift b on	a.Omkostningsart = b.Omkostningsart 
									and isnull(a.Omkostningsartnavn,'') <> b.Omkostningsartnavn
where a.kilde_beskrivelse <> 'SAP Drift'
-----

select distinct [PSP-element],max([PSP-elementNavn]) as [PSP-elementNavn]
into #dimPSPSAPDrift
from dbo.CD_G_ETL5_Ressourceportal_Drift 
where kilde_beskrivelse = 'SAP Drift' and [PSP-elementNavn] is not null
group by [PSP-element]

update a 
set a.[PSP-elementNavn] = b.[PSP-elementNavn]
from
	dbo.CD_G_ETL5_Ressourceportal_Drift a
		inner join 
	#dimPSPSAPDrift b on	a.[PSP-element] = b.[PSP-element] 
									and isnull(a.[PSP-elementNavn],'') <> b.[PSP-elementNavn]
where a.kilde_beskrivelse <> 'SAP Drift'
-----

select distinct Ordre, max(Ordrenavn) as Ordrenavn
into #dimOrdreSAPDrift
from dbo.CD_G_ETL5_Ressourceportal_Drift 
where kilde_beskrivelse = 'SAP Drift' and Ordrenavn is not null
group by Ordre

update a 
set a.Ordrenavn = b.Ordrenavn
from
	dbo.CD_G_ETL5_Ressourceportal_Drift a
		inner join 
	#dimOrdreSAPDrift b on	a.Ordre = b.Ordre 
									and isnull(a.Ordrenavn,'') <> b.Ordrenavn
where a.kilde_beskrivelse <> 'SAP Drift'




end