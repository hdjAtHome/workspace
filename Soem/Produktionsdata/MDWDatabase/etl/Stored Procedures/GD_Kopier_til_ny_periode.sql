
CREATE proc [etl].[GD_Kopier_til_ny_periode] @fraPeriode varchar(6), @tilPeriode varchar(6), @TilladOverskrivTilperiode bit = 0
as
set nocount on

if @TilladOverskrivTilperiode = 0
begin
	--Tjek om der i forvejen findes rækker i nogen af GD_ tabellerne for perioden der kopieres til (@tilPeriode)
	create table #temp (c1 char(1))
	insert into #temp 
		select 'x' as c1 from dbo.GD_R_Togførertid_FR Where PeriodeIndlæst = @tilPeriode
		union all select 'x' from dbo.GD_R_Personaledata Where PeriodeIndlæst = @tilPeriode
		union all select 'x' from dbo.GD_R_LønsumAnsættelsetype Where PeriodeIndlæst = @tilPeriode
		union all select 'x' from dbo.GD_R_Lokoførertid_STog Where PeriodeIndlæst = @tilPeriode
		union all select 'x' from dbo.GD_R_Baneafgifter_FR Where PeriodeIndlæst = @tilPeriode
		union all select 'x' from dbo.GD_R_Togproduktion_FR Where PeriodeIndlæst = @tilPeriode
		union all select 'x' from dbo.GD_R_Lokoførertid_FR Where PeriodeIndlæst = @tilPeriode
		union all select 'x' from dbo.GD_R_Lokoførertid_FR_Fix Where PeriodeIndlæst = @tilPeriode
		union all select 'x' from dbo.GD_R_RejserIndtægter_Stog Where PeriodeIndlæst = @tilPeriode
		union all select 'x' from dbo.GD_R_RejserIndtægter_FR Where PeriodeIndlæst = @tilPeriode
		union all select 'x' from dbo.GD_R_Økonomi_Anlæg Where Periode = @tilPeriode
		union all select 'x' from dbo.GD_R_Økonomi_Drift Where Periode = @tilPeriode
		union all select 'x' from dbo.GD_R_RejseIndtægter_Togsystem_FR Where PeriodeIndlæst = @tilPeriode
		union all select 'x' from dbo.GD_R_Togproduktion_STog Where PeriodeIndlæst = @tilPeriode
		
	if @@rowcount > 0 
	begin 
			declare @fejlbesked varchar(200)
			set @fejlbesked = 'Der eksisterer rækker for tilPerioden i forvejen. Sæt @TilladOverskrivTilPeriode til 1 hvis en eksisterende periode skal overskrives. '+'Eksempel: exec etl.GD_Kopier_til_ny_periode '+quotename(@fraPeriode,'''')+', '+quotename(@tilPeriode,'''')+', 1'
			raiserror(@fejlbesked,1,1)
			return -1
	end
end


--set nocount on

/* dbo.GD_R_Togførertid_FR*/

Delete from dbo.GD_R_Togførertid_FR where PeriodeIndlæst = @tilPeriode
 
Insert into dbo.GD_R_Togførertid_FR (
   [PeriodeIndlæst],
   [Turdepot],
   [TurdepotNavn],
   [OpgaveType],
   [OpgaveGruppe],
   [OpgaveGruppeNavn],
   [ElementKode],
   [ElementKodeNavn],
   [Produkt],
   [Togsystem],
   [TogsystemNavn],
   [Timer],
   [Costobjekt],
   [TidsintervalNavn]
)
Select 
   @tilPeriode,   ---PeriodeIndlæst
   [Turdepot],   ---Turdepot
   [TurdepotNavn],   ---TurdepotNavn
   [OpgaveType],   ---OpgaveType
   [OpgaveGruppe],   ---OpgaveGruppe
   [OpgaveGruppeNavn],   ---OpgaveGruppeNavn
   [ElementKode],   ---ElementKode
   [ElementKodeNavn],   ---ElementKodeNavn
   [Produkt],   ---Produkt
   [Togsystem],   ---Togsystem
   [TogsystemNavn],   ---TogsystemNavn
   [Timer],   ---Timer
   [Costobjekt],   ---Costobjekt
   [TidsintervalNavn]   ---TidsintervalNavn
From
   dbo.GD_R_Togførertid_FR
Where
   PeriodeIndlæst = @fraPeriode
 
 
/* dbo.GD_R_Personaledata*/
Delete from dbo.GD_R_Personaledata where PeriodeIndlæst = @tilPeriode
 
Insert into dbo.GD_R_Personaledata (
   [PeriodeIndlæst],
   [Profitcenter],
   [ProfitcenterNavn],
   [OmkStedKont],
   [OmkStedNavn],
   [Fuldtidsstillinger]
)
Select 
   @tilPeriode,   ---PeriodeIndlæst
   [Profitcenter],   ---Profitcenter
   [ProfitcenterNavn],   ---ProfitcenterNavn
   [OmkStedKont],   ---OmkStedKont
   [OmkStedNavn],   ---OmkStedNavn
   [Fuldtidsstillinger]   ---Fuldtidsstillinger
From
   dbo.GD_R_Personaledata
Where
   PeriodeIndlæst = @fraPeriode
 
/* dbo.GD_R_LønsumAnsættelsetype*/
Delete from dbo.GD_R_LønsumAnsættelsetype where PeriodeIndlæst = @tilPeriode
 
Insert into dbo.GD_R_LønsumAnsættelsetype (
   [Profitcenter],
   [ProfitcenterNavn],
   [Art],
   [ArtNavn],
   [Medarb_Grp],
   [Medarb_GrpNavn],
   [PeriodeIndlæst],
   [Lønsum]
)
Select 
   [Profitcenter],   ---Profitcenter
   [ProfitcenterNavn],   ---ProfitcenterNavn
   [Art],   ---Art
   [ArtNavn],   ---ArtNavn
   [Medarb_Grp],   ---Medarb_Grp
   [Medarb_GrpNavn],   ---Medarb_GrpNavn
   @tilPeriode,   ---PeriodeIndlæst
   [Lønsum]   ---Lønsum
From
   dbo.GD_R_LønsumAnsættelsetype
Where
   PeriodeIndlæst = @fraPeriode
 
/* dbo.GD_R_Lokoførertid_STog*/
Delete from dbo.GD_R_Lokoførertid_STog where periodeIndlæst = @tilPeriode
 
Insert into dbo.GD_R_Lokoførertid_STog (
   [periodeIndlæst],
   [Turdepot],
   [TurdepotNavn],
   [OpgaveType],
   [OpgaveGruppe],
   [OpgaveGruppeNavn],
   [Togsystem],
   [TogsystemNavn],
   [Costobjekt],
   [TidsintervalNavn],
   [Timer]
)
Select 
   @tilPeriode,   ---periodeIndlæst
   [Turdepot],   ---Turdepot
   [TurdepotNavn],   ---TurdepotNavn
   [OpgaveType],   ---OpgaveType
   [OpgaveGruppe],   ---OpgaveGruppe
   [OpgaveGruppeNavn],   ---OpgaveGruppeNavn
   [Togsystem],   ---Togsystem
   [TogsystemNavn],   ---TogsystemNavn
   [Costobjekt],   ---Costobjekt
   [TidsintervalNavn],   ---TidsintervalNavn
   [Timer]   ---Timer
From
   dbo.GD_R_Lokoførertid_STog
Where
   periodeIndlæst = @fraPeriode
 
 
/* dbo.GD_R_Baneafgifter_FR*/
Delete from dbo.GD_R_Baneafgifter_FR where PeriodeIndlæst = @tilPeriode
 
Insert into dbo.GD_R_Baneafgifter_FR (
   [PeriodeIndlæst],
   [Afgift],
   [Passage],
   [Produkt],
   [Togsystem],
   [TogsystemNavn],
   [Costobjekt],
   [Enhed],
   [Værdi]
)
Select 
   @tilPeriode,   ---PeriodeIndlæst
   [Afgift],   ---Afgift
   [Passage],   ---Passage
   [Produkt],   ---Produkt
   [Togsystem],   ---Togsystem
   [TogsystemNavn],   ---TogsystemNavn
   [Costobjekt],   ---Costobjekt
   [Enhed],   ---Enhed
   [Værdi]   ---Værdi
From
   dbo.GD_R_Baneafgifter_FR
Where
   PeriodeIndlæst = @fraPeriode
 
/* dbo.GD_R_Togproduktion_FR*/
Delete from dbo.GD_R_Togproduktion_FR where PeriodeIndlæst = @tilPeriode
 
Insert into dbo.GD_R_Togproduktion_FR (
   [PeriodeIndlæst],
   [Materielkørsel],
   [LitraTypeID],
   [LitraTypeNavn],
   [Togsystem],
   [TogsystemNavn],
   [TidsintervalNavn],
   [CostObjekt],
   [Enhed],
   [Værdi]
)
Select 
   @tilPeriode,   ---PeriodeIndlæst
   [Materielkørsel],   ---Materielkørsel
   [LitraTypeID],   ---LitraTypeID
   [LitraTypeNavn],   ---LitraTypeNavn
   [Togsystem],   ---Togsystem
   [TogsystemNavn],   ---TogsystemNavn
   [TidsintervalNavn],   ---TidsintervalNavn
   [CostObjekt],   ---CostObjekt
   [Enhed],   ---Enhed
   [Værdi]   ---Værdi
From
   dbo.GD_R_Togproduktion_FR
Where
   PeriodeIndlæst = @fraPeriode
 
/* dbo.GD_R_Lokoførertid_FR*/
Delete from dbo.GD_R_Lokoførertid_FR where PeriodeIndlæst = @tilPeriode
 
Insert into dbo.GD_R_Lokoførertid_FR (
   [PeriodeIndlæst],
   [Turdepot],
   [TurdepotNavn],
   [OpgaveType],
   [OpgaveGruppe],
   [OpgaveGruppeNavn],
   [ElementKode],
   [ElementKodeNavn],
   [Produkt],
   [Togsystem],
   [TogsystemNavn],
   [Timer],
   [Costobjekt],
   [TidsintervalNavn]
)
Select 
   @tilPeriode,   ---PeriodeIndlæst
   [Turdepot],   ---Turdepot
   [TurdepotNavn],   ---TurdepotNavn
   [OpgaveType],   ---OpgaveType
   [OpgaveGruppe],   ---OpgaveGruppe
   [OpgaveGruppeNavn],   ---OpgaveGruppeNavn
   [ElementKode],   ---ElementKode
   [ElementKodeNavn],   ---ElementKodeNavn
   [Produkt],   ---Produkt
   [Togsystem],   ---Togsystem
   [TogsystemNavn],   ---TogsystemNavn
   [Timer],   ---Timer
   [Costobjekt],   ---Costobjekt
   [TidsintervalNavn]   ---TidsintervalNavn
From
   dbo.GD_R_Lokoførertid_FR
Where
   PeriodeIndlæst = @fraPeriode
 
/* dbo.GD_R_Lokoførertid_FR_Fix*/
Delete from dbo.GD_R_Lokoførertid_FR_Fix where PeriodeIndlæst = @tilPeriode
 
Insert into dbo.GD_R_Lokoførertid_FR_Fix (
   [PeriodeIndlæst],
   [Turdepot],
   [TurdepotNavn],
   [OpgaveType],
   [OpgaveGruppe],
   [OpgaveGruppeNavn],
   [ElementKode],
   [ElementKodeNavn],
   [Produkt],
   [Togsystem],
   [TogsystemNavn],
   [Timer],
   [Costobjekt],
   [TidsintervalNavn]
)
Select 
   @tilPeriode,   ---PeriodeIndlæst
   [Turdepot],   ---Turdepot
   [TurdepotNavn],   ---TurdepotNavn
   [OpgaveType],   ---OpgaveType
   [OpgaveGruppe],   ---OpgaveGruppe
   [OpgaveGruppeNavn],   ---OpgaveGruppeNavn
   [ElementKode],   ---ElementKode
   [ElementKodeNavn],   ---ElementKodeNavn
   [Produkt],   ---Produkt
   [Togsystem],   ---Togsystem
   [TogsystemNavn],   ---TogsystemNavn
   [Timer],   ---Timer
   [Costobjekt],   ---Costobjekt
   [TidsintervalNavn]   ---TidsintervalNavn
From
   dbo.GD_R_Lokoførertid_FR_Fix
Where
   PeriodeIndlæst = @fraPeriode
  
/* dbo.GD_R_RejserIndtægter_Stog*/
Delete from dbo.GD_R_RejserIndtægter_Stog where PeriodeIndlæst = @tilPeriode
 
Insert into dbo.GD_R_RejserIndtægter_Stog (
   [PeriodeIndlæst],
   [Togsystem],
   [TogsystemNavn],
   [Costobjekt],
   [Enhed],
   [Værdi]
)
Select 
   @tilPeriode,   ---PeriodeIndlæst
   [Togsystem],   ---Togsystem
   [TogsystemNavn],   ---TogsystemNavn
   [Costobjekt],   ---Costobjekt
   [Enhed],   ---Enhed
   [Værdi]   ---Værdi
From
   dbo.GD_R_RejserIndtægter_Stog
Where
   PeriodeIndlæst = @fraPeriode
 
/* dbo.GD_R_RejserIndtægter_FR*/
Delete from dbo.GD_R_RejserIndtægter_FR where PeriodeIndlæst = @tilPeriode
 
Insert into dbo.GD_R_RejserIndtægter_FR (
   [PeriodeIndlæst],
   [Stationsnr],
   [Stationsnavn],
   [Stationstype],
   [Landsdel],
   [Togsystem],
   [TogsystemNavn],
   [CostObjekt],
   [Produkt],
   [TidsintervalNavn],
   [Enhed],
   [Værdi]
)
Select 
   @tilPeriode,   ---PeriodeIndlæst
   [Stationsnr],   ---Stationsnr
   [Stationsnavn],   ---Stationsnavn
   [Stationstype],   ---Stationstype
   [Landsdel],   ---Landsdel
   [Togsystem],   ---Togsystem
   [TogsystemNavn],   ---TogsystemNavn
   [CostObjekt],   ---CostObjekt
   [Produkt],   ---Produkt
   [TidsintervalNavn],   ---TidsintervalNavn
   [Enhed],   ---Enhed
   [Værdi]   ---Værdi
From
   dbo.GD_R_RejserIndtægter_FR
Where
   PeriodeIndlæst = @fraPeriode
 
/* dbo.GD_R_Økonomi_Anlæg*/
Delete from dbo.GD_R_Økonomi_Anlæg where Periode = @tilPeriode
 
Insert into dbo.GD_R_Økonomi_Anlæg (
   [HovednrUnr],
   [Firmakode],
   [AktiverDato],
   [BetegnelseAnlaegAktiv],
   [Balkonto],
   [AnlKlasse],
   [AkkAfskrPrimo],
   [AkkAfskrUltimo],
   [Afskrivning],
   [BogfoertVaerdiPrimo],
   [BogfoertVaerdiUltimo],
   [OmkStedUltimo],
   [OmkStedNavnUltimo],
   [Sats],
   [AnskVaerdi],
   [Profitcenter],
   [AfskrivningerAM],
   [Afvigelse],
   [Forrentningsgrundlag],
   [Forrentning],
   [Timestamp],
   [Delområde],
   [Beskrivelse],
   [Periode]
)
Select 
   [HovednrUnr],   ---HovednrUnr
   [Firmakode],   ---Firmakode
   [AktiverDato],   ---AktiverDato
   [BetegnelseAnlaegAktiv],   ---BetegnelseAnlaegAktiv
   [Balkonto],   ---Balkonto
   [AnlKlasse],   ---AnlKlasse
   [AkkAfskrPrimo],   ---AkkAfskrPrimo
   [AkkAfskrUltimo],   ---AkkAfskrUltimo
   [Afskrivning],   ---Afskrivning
   [BogfoertVaerdiPrimo],   ---BogfoertVaerdiPrimo
   [BogfoertVaerdiUltimo],   ---BogfoertVaerdiUltimo
   [OmkStedUltimo],   ---OmkStedUltimo
   [OmkStedNavnUltimo],   ---OmkStedNavnUltimo
   [Sats],   ---Sats
   [AnskVaerdi],   ---AnskVaerdi
   [Profitcenter],   ---Profitcenter
   [AfskrivningerAM],   ---AfskrivningerAM
   [Afvigelse],   ---Afvigelse
   [Forrentningsgrundlag],   ---Forrentningsgrundlag
   [Forrentning],   ---Forrentning
   [Timestamp],   ---Timestamp
   [Delområde],   ---Delområde
   [Beskrivelse],   ---Beskrivelse
   @tilPeriode   ---Periode
From
   dbo.GD_R_Økonomi_Anlæg
Where
   Periode = @fraPeriode
 
/* dbo.GD_R_Økonomi_Drift*/
Delete from dbo.GD_R_Økonomi_Drift where Periode = @tilPeriode
 
Insert into dbo.GD_R_Økonomi_Drift (
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
   [Beskrivelse],
   [FaktiskBeløb],
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
   [indlæstTidspunktManuelledata],
   [indlæstAfManuelleDAta],
   [indlæstTidspunkt],
   [indlæstAf],
   [Periode]
)
Select 
   [Profitcenter],   ---Profitcenter
   [Profitcenternavn_dont_use],   ---Profitcenternavn_dont_use
   [Omkostningssted],   ---Omkostningssted
   [Omkostningsstednavn_dont_use],   ---Omkostningsstednavn_dont_use
   [Omkostningsart],   ---Omkostningsart
   [Omkostningsartnavn_dont_use],   ---Omkostningsartnavn_dont_use
   [PSP-element],   ---PSP-element
   [PSP-elementNavn_dont_use],   ---PSP-elementNavn_dont_use
   [Ordre],   ---Ordre
   [Ordrenavn_dont_use],   ---Ordrenavn_dont_use
   [Litratype],   ---Litratype
   [Litratypenavn_dont_use],   ---Litratypenavn_dont_use
   [Delområde],   ---Delområde
   [DelområdeNavn],   ---DelområdeNavn
   [StationsNr],   ---StationsNr
   [StationsNavn],   ---StationsNavn
   [StationsType],   ---StationsType
   [StationsTypeNavn],   ---StationsTypeNavn
   [NøgleFastEjendom],   ---NøgleFastEjendom
   [Beskrivelse],   ---Beskrivelse
   [FaktiskBeløb],   ---FaktiskBeløb
   [indlæstTidspunktRådata],   ---indlæstTidspunktRådata
   [indlæstAfRådata],   ---indlæstAfRådata
   [Momsstatus],   ---Momsstatus
   [CeArtGrp],   ---CeArtGrp
   [CeArtGrpNavn],   ---CeArtGrpNavn
   [ArtGrp],   ---ArtGrp
   [ArtGrpNavn],   ---ArtGrpNavn
   [Variabilitet],   ---Variabilitet
   [VariabilitetNavn],   ---VariabilitetNavn
   [Reversibilitet],   ---Reversibilitet
   [ReversibilitetNavn],   ---ReversibilitetNavn
   [indlæstTidspunktManuelledata],   ---indlæstTidspunktManuelledata
   [indlæstAfManuelleDAta],   ---indlæstAfManuelleDAta
   [indlæstTidspunkt],   ---indlæstTidspunkt
   [indlæstAf],   ---indlæstAf
   @tilPeriode   ---Periode
From
   dbo.GD_R_Økonomi_Drift
Where
   Periode = @fraPeriode
  
/* dbo.GD_R_RejseIndtægter_Togsystem_FR*/
Delete from dbo.GD_R_RejseIndtægter_Togsystem_FR where PeriodeIndlæst = @tilPeriode
 
Insert into dbo.GD_R_RejseIndtægter_Togsystem_FR (
   [PeriodeIndlæst],
   [togsystemnummer],
   [Togsystemnavn_Kort],
   [costObjekt],
   [Enhed],
   [værdi]
)
Select 
   @tilPeriode,   ---PeriodeIndlæst
   [togsystemnummer],   ---togsystemnummer
   [Togsystemnavn_Kort],   ---Togsystemnavn_Kort
   [costObjekt],   ---costObjekt
   [Enhed],   ---Enhed
   [værdi]   ---værdi
From
   dbo.GD_R_RejseIndtægter_Togsystem_FR
Where
   PeriodeIndlæst = @fraPeriode

/* dbo.GD_R_Togproduktion_STog*/
Delete from dbo.GD_R_Togproduktion_STog where PeriodeIndlæst = @tilPeriode
 
Insert into dbo.GD_R_Togproduktion_STog (
   [PeriodeIndlæst],
   [Litratype],
   [Togsystem],
   [TogsystemNavn],
   [Costobjekt],
   [Enhed],
   [Værdi],
   [TidsintervalNavn]
)
Select 
   @tilPeriode,   ---PeriodeIndlæst
   [Litratype],   ---Litratype
   [Togsystem],   ---Togsystem
   [TogsystemNavn],   ---TogsystemNavn
   [Costobjekt],   ---Costobjekt
   [Enhed],   ---Enhed
   [Værdi],   ---Værdi
   [TidsintervalNavn]   ---TidsintervalNavn
From
   dbo.GD_R_Togproduktion_STog
Where
   PeriodeIndlæst = @fraPeriode