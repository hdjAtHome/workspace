
CREATE PROC [etl].[load_Dim_Profitcenter_Hierarki]
as 
BEGIN

--DAN surrogatnøgler (uden historik) for nye profitcentre fra DIRK
insert into ods.key_dim_profitcenter_uden_historik
	(profitcenter)
select distinct
	NyeKnuder.PCHier_Reference
from
(
	select 
		dimprofitcenterid as PCHier_Reference
	from 
		ods.rd_dirk_profitcenterhierarki
	except 
	select 
		profitcenter
	from 
		ods.key_dim_profitcenter_uden_historik
	--order by PCHier_Reference
) as NyeKnuder

order by pchier_reference

--DAN surrogatnøgler (uden historik) for nye profitcentre fra "manuelle" stamdata udtrukket fra SAP
insert into ods.key_dim_profitcenter_uden_historik
	(profitcenter)
select distinct
	sapStam.profitcenter
from
	(
	select 
		profitcenter
	from 
		ods.rd_sap_profitcenterstam 
	except 
	select 
		profitcenter
	from 
		ods.key_dim_profitcenter_uden_historik
	--order by PCHier_Reference
) as sapStam

order by profitcenter

--Opbyg profitcenter_hierarki dimensionen


if object_id('tempdb..#temp') is not null drop table #temp
--Rekursiv select på dirks profitcenterhierarki, hvor kun de profitcentre, der ligger under DSB, kommer med
;with DSBHier as
(	select a.DimProfitcenterID, a.Parent, 1 as Level
	from ods.rd_dirk_profitcenterhierarki a
	where a.parent = 'DSB' and a.DimProfitcenterID = 'DSB'  -- toplevel (level 1)

	union all 
	
	select b.DimProfitcenterID, b.Parent, DSBHier.Level+1
	from ods.rd_dirk_profitcenterhierarki b
			inner join 
		 DSBHier on b.Parent = DSBHier.DimProfitcenterID  
	where b.DimProfitcenterID <> 'DSB' --for at toplevel ikke looper med sig selv, da den peger på sig selv (Parent = 'DSB')
			and not (b.Parent = 'DSB' and b.DimProfitcenterID not in ('DSB-SV', 'S-TOG')) --I det niveau der ligger lige under 'DSB' (level 2) vil vi kun have 'DSB-SV', 'S-TOG' med
)
	select DimProfitcenterID, Parent, level 
	into #temp 
	from DSBHier 

TRUNCATE TABLE [edw].[Dim_Profitcenter_Hierarki]

INSERT INTO [edw].[Dim_Profitcenter_Hierarki] (
	[Pk_key] ,
	[Profitcenter],
	[Profitcenternavn],
	[Parent_Key],
	[ParentProfitcenter],
	[Niveau]
	)
SELECT DISTINCT 
	k.[pk_key],
	k.[Profitcenter],
	b.[membername],
	parentK.[pk_key],
	a.[parent],
	a.[level]
FROM 
	#temp a --ProfitcenterHierarki fra DIRK minus profitcentre, der ikke ligger under 'DSB-SV' 'S-TOG'
		left outer join
	ods.rd_dirk_profitcenterhierarki b on a.DimProfitcenterID = b.DimProfitcenterID -- for at få navnet fra membername
		left outer join 
	ods.key_dim_profitcenter_uden_historik k on a.[dimprofitcenterid] = k.profitcenter -- for at få nøgle child
		left outer join
	ods.key_dim_profitcenter_uden_historik parentK on a.[parent] = parentK.profitcenter -- for at få nøgle parent

END