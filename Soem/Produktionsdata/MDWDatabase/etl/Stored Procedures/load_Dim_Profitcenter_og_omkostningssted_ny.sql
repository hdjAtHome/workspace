
CREATE proc [etl].[load_Dim_Profitcenter_og_omkostningssted_ny]
as
BEGIN

insert into ods.key_dim_profitcenter
(profitcenter, gyldigfra, gyldigtil)
select 
	Profitcenter,
	[dbo].[charDatoMedBindestreger2datetime](replace(gyldigfradato,'.','-')) as GyldigfraDatetime,
	[dbo].[charDatoMedBindestreger2datetime](replace(gyldigtildato,'.','-')) as GyldigtilDatetime
from 
	ods.rd_sap_profitcenterstam where profitcenter = 'DSBDummy'
	and not exists (select 'x' from ods.key_dim_profitcenter where profitcenter = 'DSBDummy')

--DAN Surrogatnøgler for dim_profitcenter

insert into ods.key_dim_profitcenter
(profitcenter, gyldigfra)
select 
	Profitcenter,
	[dbo].[charDatoMedBindestreger2datetime](replace(gyldigfradato,'.','-')) as GyldigfraDatetime
	--[dbo].[charDatoMedBindestreger2datetime](replace(gyldigtildato,'.','-')) as GyldigtilDatetime
from 
	ods.rd_sap_profitcenterstam 
except 
	select profitcenter,
	gyldigfra
	--gyldigtil
from 
	ods.key_dim_profitcenter
order by profitcenter, GyldigfraDatetime


update k1
set k1.gyldigtil = [dbo].[charDatoMedBindestreger2datetime](replace(k2.gyldigtildato,'.','-'))
from	 ods.key_dim_profitcenter k1
			inner join
ods.rd_sap_profitcenterstam  k2 on k1.profitcenter = k2.profitcenter and k1.gyldigfra = [dbo].[charDatoMedBindestreger2datetime](replace(k2.gyldigfradato,'.','-'))
where gyldigtil is null or k1.gyldigtil <> [dbo].[charDatoMedBindestreger2datetime](replace(k2.gyldigtildato,'.','-'))


--DAN Surrogatnøgler for Dim_Omkostningssted]
insert into ods.[Key_Dim_Omkostningssted]
([Omkostningssted], gyldigfra)
select 
	Omksted,
	[dbo].[charDatoMedBindestreger2datetime](replace(gyldigfradato,'.','-')) as GyldigfraDatetime
	--[dbo].[charDatoMedBindestreger2datetime](replace(gyldigtildato,'.','-')) as GyldigtilDatetime
from 
	ods.rd_sap_omkstedstam 
except 
	select [Omkostningssted],
	gyldigfra
	--gyldigtil
from 
	ods.[Key_Dim_Omkostningssted]
order by Omksted, GyldigfraDatetime


update k1
set k1.gyldigtil = [dbo].[charDatoMedBindestreger2datetime](replace(k2.gyldigtildato,'.','-'))
from	 ods.key_dim_omkostningssted k1
			inner join
ods.rd_sap_omkstedstam  k2 on k1.omkostningssted = k2.omksted and k1.gyldigfra = [dbo].[charDatoMedBindestreger2datetime](replace(k2.gyldigfradato,'.','-'))
where gyldigtil is null or k1.gyldigtil <> [dbo].[charDatoMedBindestreger2datetime](replace(k2.gyldigtildato,'.','-'))



--Load di_profitcenter_ny
truncate table edw.di_profitcenter_ny
insert into edw.di_profitcenter_ny
	(PK_ID,
	Profitcenter,
	ProfitcenterNavn,
	ProfitcenterParent_FH,
	ProfitcenterAnsvarlig,
	ProfitcenterBeskrivelse,
	Enhed,
	GyldigFradato,
	GyldigTildato,
	Aktiv,
	Timestamp)
select 
	pck.pk_key, --PK_ID,
	pc.Profitcenter,
	pc.ProfitcenterNavn,
	pc.standardhierarki, --ProfitcenterParent_FH,
	pc.ProfitcenterAnsvarlig,
	pc.ProfitcenterBeskrivelse,
	md_pc.Enhed,
	pck.gyldigfra, --GyldigFradato,
	pck.gyldigtil, --GyldigTildato,
	case pck.gyldigtil when '9999-12-31' then 'j' else 'n' end as Aktiv,
	null
from  
	ods.rd_sap_profitcenterstam pc   
		left outer join --1562
	ods.key_dim_profitcenter pck on pc.profitcenter = pck.profitcenter and pck.gyldigfra =  [dbo].[charDatoMedBindestreger2datetime](replace(pc.gyldigfradato,'.','-'))
		left outer join
	edw.md_a_profitcenter_enhed md_pc on pc.profitcenter = md_pc.profitcenter
update edw.di_profitcenter_ny set enhed = 'K' where profitcenter = '10000'

--load di_omksted_ny

truncate table edw.di_omksted_ny
insert into edw.di_omksted_ny
(
	PK_ID,
	OmkSted,
	OmkStedNavn,
	OmkStedAnsvarlig,
	OmkStedBeskrivelse,
	Profitcenter,
	FK_Profitcenter_PKID,
	GyldigFradato,
	GyldigTildato,
	Aktiv,
	Timestamp)
--7716 rækker
select 
	ko.pk_key,--PK_ID,
	dbo.fjernforanstilledenuller(o.OmkSted) as omksted,
	o.OmkStedNavn,
	o.OmkStedAnsvarlig,
	o.OmkStedBeskrivelse,
	dbo.fjernforanstilledenuller(o.Profitcenter) as profitcenter,
	isnull(po.pk_key,-1) as FK_Profitcenter_PKID, --profitcenter pk_id
	ko.GyldigFra,
	ko.GyldigTil,
	case ko.gyldigtil when '9999-12-31' then 'j' else 'n' end as Aktiv,
	o.timestamp
from 
	ods.rd_sap_omkstedstam o
		left outer join
	ods.key_dim_omkostningssted ko on o.omksted = ko.omkostningssted and [dbo].[charDatoMedBindestreger2datetime](replace(gyldigfradato,'.','-')) = ko.gyldigfra
		left outer join
	ods.key_dim_profitcenter po  on dbo.fjernforanstilledenuller(o.profitcenter) = po.profitcenter and  [dbo].[charDatoMedBindestreger2datetime](replace(gyldigtildato,'.','-')) between po.gyldigfra and po.gyldigtil

END

