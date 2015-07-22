
CREATE PROC [etl].[Costpooling_R_Personale] @test int = 0
as 
BEGIN




if object_id ('dbo.TD_G_KRIT_Costpool_Personale') is not null drop table dbo.TD_G_KRIT_Costpool_Personale
select ID,
Costpool,
OmkStedFra,
OmkStedTil,
PctrFra,
PctrTil
into dbo.TD_G_KRIT_Costpool_Personale
from dbo.MD_G_KRIT_Costpool_Drift
where 

DelområdeFra is null and 
DelområdeTil is null and 
ArtFra is null and 
ArtTil is null and 
ArtGrpFra is null and 
ArtGrpTil is null and 
CeArtGrpFra is null and 
CeArtGrpTil is null and 
StationsnrFra is null and 
StationsnrTil is null and 
StationstypeFra is null and 
StationstypeTil is null and 
LitraFra is null and 
LitraTil is null and 
OrdreFra is null and 
OrdreTil is null and 
PSPFra is null and 
PSPTil is null 

--select * from dbo.TD_G_KRIT_Costpool_Personale


select row_number() over (order by PeriodeIndlæst,
Profitcenter,
ProfitcenterNavn,
OmkStedKont,
OmkStedNavn,
Fuldtidsstillinger) as Rækkenummer, 
*
into #GD_R_PersonaledataMedRækkeNummer
from dbo.GD_R_Personaledata
--select * from #tempGD_R_PersonaledataMedRækkeNummer



	if object_id('tempdb..#GD_R_Personale_med_rækkeNummer_left_joined_med_alle_matchende_costpool_uden_hensyn_til_prioritet') is not null drop table #GD_R_Personale_med_rækkeNummer_left_joined_med_alle_matchende_costpool_uden_hensyn_til_prioritet
	select 
			convert(int,y.id) as Prioritet, 
			y.costpool, 
			x.rækkeNummer,
			x.PeriodeIndlæst,
			x.Profitcenter,
			x.ProfitcenterNavn,
			x.OmkStedKont,
			x.OmkStedNavn,
			x.Fuldtidsstillinger
			
			
	into 
			#GD_R_Personale_med_rækkeNummer_left_joined_med_alle_matchende_costpool_uden_hensyn_til_prioritet
	from 
			#GD_R_PersonaledataMedRækkeNummer x
				left outer join 
			dbo.TD_G_KRIT_Costpool_Personale as y 
		on 
		(
				(x.profitcenter			between y.pctrfra and y.pctrTil					OR (y.pctrfra is null or y.pctrtil is null))
			and	(x.[OmkStedKont]	between y.omkstedfra and y.omkstedTil			OR (y.omkstedfra is null or y.omkstedTil is null))
			
		)
--Virker ikke nu men skal implementeres når kriteriefilen er endelig: where y.model = 'G' or y.model = 'R'
	order by 
		x.rækkeNummer



--select * from #GD_R_Personale_med_rækkeNummer_left_joined_med_alle_matchende_costpool_uden_hensyn_til_prioritet
select 
		min(prioritet) as min_prioritet, 
		rækkeNummer 
	into 
		#første_prioritet_pr_rækkeNummer
	from 
		#GD_R_Personale_med_rækkeNummer_left_joined_med_alle_matchende_costpool_uden_hensyn_til_prioritet
	group by 
		rækkeNummer

--select * from #første_prioritet_pr_rækkeNummer

if object_id('dbo.CD_R_ETL5_Ressourceportal_Personale') is not null drop table dbo.CD_R_ETL5_Ressourceportal_Personale
	select 
			x.*,
			z.costpool, 
			'R1_' + z.costpool + '_U' as Reference_ID,
			r.Reference_Name,
			r.ATT_ResType,
			r.EvenlyAssigned, 
			rEvenlyassignedName.Reference_name as EvenlyAssigned_Name

	into 
		dbo.CD_R_ETL5_Ressourceportal_Personale
	from 
		#GD_R_PersonaledataMedRækkeNummer x 
			left outer join 
		#første_prioritet_pr_rækkeNummer y on x.rækkeNummer = y.rækkeNummer
			left outer join 
		#GD_R_Personale_med_rækkeNummer_left_joined_med_alle_matchende_costpool_uden_hensyn_til_prioritet z on y.min_prioritet =  z.prioritet and y.rækkeNummer = z.rækkeNummer
			left outer join 
		dbo.MD_G_ACCHIER_Ressource r on 'R1_' + z.costpool + '_U' = r.reference_id --and att_restype in ('PROD_ENH', 'OMR_OH', 'KC_OH') and evenlyAssigned is not null
			left outer join 
	 dbo.MD_G_ACCHIER_Ressource rEvenlyassignedName on r.EvenlyAssigned = rEvenlyassignedName.reference_id



--select * from dbo.CD_ETL5_Ressourceportal_Personale
end