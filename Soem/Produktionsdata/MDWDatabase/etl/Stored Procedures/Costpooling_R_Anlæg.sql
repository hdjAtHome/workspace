CREATE PROC [etl].[Costpooling_R_Anlæg] @Periode varchar(50)
as 
BEGIN



--select * from [dbo].[MD_G_KRIT_Costpool_Anlæg]
--select * from poemaktuel.dbo.GD_R_anlæg
--select name from syscolumns where id = object_id('dbo.GD_R_anlæg')

 --Påsæt teknisk rækkenummer (row_number()) på rd_sap_drift
if object_id('tempdb..#GD_R_Økonomi_Anlæg_med_rækkeNummer') is not null drop table #GD_R_Økonomi_Anlæg_med_rækkeNummer
	select row_number() over (order by	HovednrUnr,
										AktiverDato,
										BetegnelseAnlaegAktiv,
										Balkonto,
										AnlKlasse,
										AkkAfskrPrimo,
										AkkAfskrUltimo,
										Afskrivning,
										BogfoertVaerdiPrimo,
										BogfoertVaerdiUltimo,
										OmkStedUltimo,
										OmkStedNavnUltimo,
										Sats,
										AnskVaerdi,
										Profitcenter,
										AfskrivningerAM,
										Afvigelse,
										Forrentningsgrundlag,
										Forrentning,
										Timestamp,
										Firmakode,
										Delområde,
										Kilde_Beskrivelse,
										Periode,
										KildeArk	) 
			as rækkeNummer, 
			*
	into #GD_R_Økonomi_Anlæg_med_rækkeNummer
	from 

		(select HovednrUnr,
				AktiverDato,
				BetegnelseAnlaegAktiv,
				Balkonto,
				AnlKlasse,
				AkkAfskrPrimo,
				AkkAfskrUltimo,
				Afskrivning as Afskrivning,
				BogfoertVaerdiPrimo,
				BogfoertVaerdiUltimo,
				OmkStedUltimo,
				OmkStedNavnUltimo,
				Sats,
				AnskVaerdi,
				Profitcenter,
				AfskrivningerAM,
				Afvigelse,
				Forrentningsgrundlag,
				Forrentning,
				Timestamp,
				Firmakode,
				Delområde, 
				Beskrivelse as Kilde_Beskrivelse,
				Periode, 
				KildeArk
		from 
				dbo.GD_R_Økonomi_Anlæg
		where periode = @periode
	)  as A

--where 
--	CeArtGrp <> 'A' --SKAL IND IGEN SENERE
		-- and KontrolGrp <> 'Skat' --??



	--Påsæt alle matchende rækker fra MD_K_COSTPOOL_KRITERIER_DRIFT uden hensyn til prioritet
	-- Id på MD_K_COSTPOOL_KRITERIER_DRIFT omdøbes til Prioritet
	if object_id('tempdb..#GD_R_Økonomi_Anlæg_med_rækkeNummer_left_joined_med_alle_matchende_costpool_uden_hensyn_til_prioritet') is not null drop table #GD_R_Økonomi_Anlæg_med_rækkeNummer_left_joined_med_alle_matchende_costpool_uden_hensyn_til_prioritet
	select 
			convert(int,y.id) as Prioritet, 
			y.costpool, 
			x.Rækkenummer,
			x.HovednrUnr,
			x.AktiverDato,
			x.BetegnelseAnlaegAktiv,
			x.Balkonto,
			x.AnlKlasse,
			x.AkkAfskrPrimo,
			x.AkkAfskrUltimo,
			x.Afskrivning,
			x.BogfoertVaerdiPrimo,
			x.BogfoertVaerdiUltimo,
			x.OmkStedUltimo,
			x.OmkStedNavnUltimo,
			x.Sats,
			x.AnskVaerdi,
			x.Profitcenter,
			x.AfskrivningerAM,
			x.Afvigelse,
			x.Forrentningsgrundlag,
			x.Forrentning,
			x.Kilde_Beskrivelse,
			x.Delområde,
			x.Periode,
			x.KildeArk
	into 
			#GD_R_Økonomi_Anlæg_med_rækkeNummer_left_joined_med_alle_matchende_costpool_uden_hensyn_til_prioritet
	from 
			#GD_R_Økonomi_Anlæg_med_rækkeNummer as x
				left outer join 
		 	dbo.MD_G_KRIT_Costpool_Anlæg as y 
		on 
		(
				(x.profitcenter			between y.pctrfra and y.pctrTil					OR (y.pctrfra is null or y.pctrtil is null))
			and	(x.OmkStedUltimo		between y.omkstedfra and y.omkstedTil			OR (y.omkstedfra is null or y.omkstedTil is null))
			and (x.HovednrUnr			between y.HUnrFra and y.HUnrTil					OR (y.HUnrFra is null or y.HUnrTil is null))	
			and (x.AnlKlasse			between y.KlasseFra and y.KlasseTil				OR (y.KlasseFra is null or y.KlasseTil is null))	
			and (x.Delområde			between y.DelområdeFra and y.DelområdeTil		OR (y.DelområdeFra is null or y.DelområdeTil is null))	
			/* Skal ind senere ?:
			and	(x.[StationsNr]			between y.StationsNrfra and y.StationsNrtil		OR (y.StationsNrfra is null or y.StationsNrtil is null))
			and	(x.[StationsType]		between y.StationsTypefra and y.StationsTypetil OR (y.StationsTypefra is null or y.StationsTypetil is null))
			*/

		)
--Virker ikke nu men skal implementeres når kriteriefilen er endelig: where y.model = 'G' or y.model = 'R'
	order by 
		x.rækkeNummer
--select * from #GD_R_Økonomi_Anlæg_med_rækkeNummer_left_joined_med_alle_matchende_costpool_uden_hensyn_til_prioritet where hovednrunr in ('9991000', '9991800')


	--Find den højest prioriterede (svarende til minimum) matchende costpool pr rækkeNummer
	select 
		min(prioritet) as min_prioritet, 
		rækkeNummer 
	into 
		#første_prioritet_pr_rækkeNummer
	from 
		#GD_R_Økonomi_Anlæg_med_rækkeNummer_left_joined_med_alle_matchende_costpool_uden_hensyn_til_prioritet
	group by 
		rækkeNummer

	
	--Påsæt (kun) den højest prioriterede costpool til k_drift
	--if object_id('dbo.CD_G_ETL5_Ressourceportal_Anlæg') is not null drop table dbo.CD_G_ETL5_Ressourceportal_Anlæg
delete from dbo.CD_G_ETL5_Ressourceportal_Anlæg where periode = @periode

	Insert into dbo.CD_G_ETL5_Ressourceportal_Anlæg (
			Rækkenummer,
			HovednrUnr,
			AktiverDato,
			BetegnelseAnlaegAktiv,
			Balkonto,
			AnlKlasse,
			AkkAfskrPrimo,
			AkkAfskrUltimo,
			Afskrivning,
			BogfoertVaerdiPrimo,
			BogfoertVaerdiUltimo,
			OmkStedUltimo,
			OmkStedNavnUltimo,
			Sats,
			AnskVaerdi,
			Profitcenter,
			AfskrivningerAM,
			Afvigelse,
			Forrentningsgrundlag,
			Forrentning,
			Kilde_Beskrivelse,
			Delområde,
			Periode,
			costpool,
			Reference_ID,
			Niveau,
			Sort,
			Reference_Name,
			Reference_Parent,
			Reference_Name_Parent,
			Type,
			EvenlyAssigned,
			DriverName,
			Model,
			Aktiv,
			Ressource_Beskrivelse,
			ATT_ResType,
			IndlæstTidspunktEX_MD_G_ACCHIER_Ressource,
			KildeArk
		)
	select 
			x.Rækkenummer,
			x.HovednrUnr,
			x.AktiverDato,
			x.BetegnelseAnlaegAktiv,
			x.Balkonto,
			x.AnlKlasse,
			x.AkkAfskrPrimo,
			x.AkkAfskrUltimo,
			x.Afskrivning,
			x.BogfoertVaerdiPrimo,
			x.BogfoertVaerdiUltimo,
			x.OmkStedUltimo,
			x.OmkStedNavnUltimo,
			x.Sats,
			x.AnskVaerdi,
			x.Profitcenter,
			x.AfskrivningerAM,
			x.Afvigelse,
			x.Forrentningsgrundlag,
			x.Forrentning,
			x.Kilde_Beskrivelse,
			x.Delområde,
			x.Periode,
			z.costpool, 
			'R1_' + z.costpool + '_A' as Reference_ID,
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
			x.KildeArk
		from 
			#GD_R_Økonomi_Anlæg_med_rækkeNummer x 
				left outer join 
			#første_prioritet_pr_rækkeNummer y on x.rækkeNummer = y.rækkeNummer
				left outer join 
			#GD_R_Økonomi_Anlæg_med_rækkeNummer_left_joined_med_alle_matchende_costpool_uden_hensyn_til_prioritet z on y.min_prioritet =  z.prioritet and y.rækkeNummer = z.rækkeNummer
				left outer join 
			dbo.MD_G_ACCHIER_Ressource r on 'R1_' + z.costpool + '_A' = r.reference_id
				left outer join 
	 		dbo.MD_G_ACCHIER_Ressource rparent on r.reference_Parent = rparent.reference_id

		


declare @fejlref varchar(8000)
select @fejlref = isnull(@fejlref+', ','') + reference_id  from dbo.CD_G_ETL5_Ressourceportal_Anlæg where reference_name  is null and periode = @periode
if ( @fejlref is not null and @fejlref <> '') 
begin
	declare @fejltekst varchar(8000)
	set @fejltekst = 'Ressourceportal_Anlæg. Reference_name er null for reference_id: ' + @fejlref
	raiserror(@fejltekst,16,1)
end
	



end