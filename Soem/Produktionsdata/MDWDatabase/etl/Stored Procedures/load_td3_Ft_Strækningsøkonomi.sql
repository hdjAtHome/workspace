create proc [etl].[load_td3_Ft_Strækningsøkonomi]  @model varchar(50), @periode varchar(50)
as
begin 
set  nocount on



select @model = upper(@model)
print 'Model: '+@model
print 'Periode: '+@periode
declare @model_id int
declare @aktiv bit

--TEST
--insert into adhoc.test_modelogperiode select  @model as model, @periode as periode 
--return

if not exists (select 'x' from edw.dim_model b where b.model  = @model and b.år = @periode)
begin
	insert into edw.dim_model  (model, år, aktiv) select @model, @periode, 1 
	update edw.dim_model set aktiv = 0 where år = @periode and model <> @model
	update edw.dim_model set periode = år, dataserie = 'R' where model  = @model and år = @periode
end 
else
begin
	update edw.dim_model set aktiv = 1 where år = @periode and model = @model and aktiv <> 1
end

--Opdatere UnaryOperator så nyeste periode for hvert år (substring(periode,1,4)) får '+', hvilket betyder, at de medtages i total for året. Andre (tidligere) perioder får '~', hvilket betyder at de ikke medregnes i total

update edw.dim_model 
set UnaryOperator = '+' 
where periode in (select max(periode) from edw.dim_Model group by substring(Periode,1,4)) 
		and aktiv = 1

update edw.dim_model 
set UnaryOperator = '~' 
where periode not in (select max(periode) from edw.dim_Model group by substring(Periode,1,4))
		or aktiv = 0

select @model_id = pk_id, @aktiv = aktiv from edw.dim_model where model = @model and år = @periode

print 'Model_Id: '+convert(varchar(9),@model_id)
print 'Aktiv: '+convert(char(1),@aktiv)
--select * from edw.dim_model
--exec script_table 'ods.td_Mxxxx_costelement'

IF object_id('ods.td_Mxxxx_costelement') is not null
DROP TABLE ods.td_Mxxxx_costelement

CREATE TABLE ods.td_Mxxxx_costelement(
	[Id] int NULL,
	[PeriodId] smallint NULL,
	[ScenarioId] smallint NULL,
	[SourceId] int NULL,
	[DestinationId] int NULL,
	[Refnum] varchar(256) NULL,
	[Name] varchar(256) NULL,
	[Type] smallint NULL,
	[FixedCost] float NULL,
	[VariableCost] float NULL,
	[AllocatedCost] float NULL,
	[IdleCost] float NULL,
	[FixedQuantity] float NULL,
	[VariableQuantity] float NULL,
	[FixedWeight] float NULL,
	[VariableWeight] float NULL,
	[QuantityBasic] float NULL,
	[QuantityCalculated] float NULL,
	[UserIdleQuantity] float NULL,
	[AssignedIdleQuantity] float NULL
)

exec ('insert into ods.td_Mxxxx_costelement select * from SASABMMODELS.dbo.'+@model+'_Costelement' )


------------ Hent @model+_dimension fra SASABMMODELS ------------ 
IF object_id('ods.td_Mxxxx_dimension') is not null
DROP TABLE ods.td_Mxxxx_dimension
 
CREATE TABLE ods.td_Mxxxx_dimension(
	[Id] int NULL,
	[Name] varchar(64) NULL,
	[OdbcColumnName] varchar(64) NULL,
	[Refnum] varchar(64) NULL,
	[Icon] int NULL,
	[Description] text NULL
)

exec ('insert into ods.td_Mxxxx_dimension select * from SASABMMODELS.dbo.'+@model+'_dimension' )

------------ ------------ ------------ ------------ ------------ 



------------ Hent @model+_AccountCenter fra SASABMMODELS ------------ 
------------- Der skal laves dynamisk create at tabellen ods.td0_Mxxxx_AccountCenter, da antallet af kolonner (dem der starter med DIM.... kan variere fra model til model


IF object_id('ods.td0_Mxxxx_AccountCenter') is not null
DROP TABLE ods.td0_Mxxxx_AccountCenter

--kolonner vedr. dimensions kan hentes fra ods.td_mxxxx_dimension:
declare @dimensions varchar(max)
select @dimensions =  coalesce(@dimensions+',','') + ' [Dim'+convert(varchar(10), id) collate Danish_Norwegian_CI_AS + '] int NULL'  from ods.td_Mxxxx_dimension a 

declare @CreateTableSql varchar(max)
set @CreateTableSql = 
'CREATE TABLE ods.td0_Mxxxx_AccountCenter(
	[Id] int NULL,
	[Type] smallint NULL,
	[SourceId] int NULL,
	[DestinationId] int NULL,
	[BalAdjType] smallint NULL,
	[ModuleId] smallint NULL,
	[PeriodId] smallint NULL,
	[ScenarioId] smallint NULL,
	[DriverId] int NULL,
	[Refnum] varchar(256) NULL,
	[Name] varchar(256) NULL,
	[Note] text NULL,
	[CostPrimaryEntered] float NULL,
	[CostPrimaryAssigned] float NULL,
	[CostPrimaryBOC] float NULL,
	[CostReceivedBOC] float NULL,
	[CostReceivedAssigned] float NULL,
	[CostGivenBOC] float NULL,
	[CostGivenAssigned] float NULL,
	[UnitCostEntered] float NULL,
	[IdleCost] float NULL,
	[InventoryCost] float NULL,
	[Revenue] float NULL,
	[TotalDriverQuantityBasic] float NULL,
	[TotalDriverQuantityCalculated] float NULL,
	[UserTotalDriverQuantity] float NULL,
	[SoldQuantity] float NULL,
	[UserInputQuantity] float NULL,
	[UserOutputQuantity] float NULL,
	[ConsumedBOCQuantity] float NULL,
	[Measure] varchar(64) NULL,
	[UnitCostType] bit NULL,
	[AllocatedCostIn] float NULL,
	[AllocatedCost] float NULL,
	[AssignedIdleQuantity] float NULL,
	[UnassignedCost] float NULL,
	[CalcError] smallint NULL,
	[PublishName] varchar(64) NULL,
	[IsBehavior] int NULL,'
	+ @dimensions
	/* @dimensions har indhold ala dette:
		[Dim1001] int NULL,
		[Dim1002] int NULL,
		[Dim1003] int NULL,
		.....
		[Dim1019] int NULL,
		[Dim1020] int NULL,
		[Dim1021] int NULL,
		[Dim1022] int NULL
	*/
	+', [Drivername] varchar(64) NULL
	)'

exec(@CreateTableSql)

exec ('insert into ods.td0_Mxxxx_AccountCenter select a.*,d.name as Drivername from SASABMMODELS.dbo.'+@model+'_AccountCenter a left outer join SASABMMODELS.dbo.'+@model+'_driver d on a.driverid = d.id' )

------------------------------------------------
--	Hent @model+_dimmember fra sasabmmodels


IF object_id('ods.td_Mxxxx_dimmember') is not null
DROP TABLE ods.td_Mxxxx_dimmember

CREATE TABLE ods.td_Mxxxx_dimmember(
	[Id] int NULL,
	[DimensionId] int NULL,
	[ParentId] int NULL,
	[Name] varchar(64) NULL,
	[Refnum] varchar(64) NULL,
	[LevelId] smallint NULL,
	[DisplayOrder] float NULL
)

exec ('insert into ods.td_Mxxxx_dimmember select * from SASABMMODELS.dbo.'+@model+'_dimmember' )

------------------------------------------------------------------------------------------------
--	Flyt accountcenter ods.td0_Mxxxx_AccountCenter tabel over i 
--	ny tabel ods.td_Mxxxx_AccountCenter, hvor dim1001, dim1002 osv. bliver
--	erstattet af kolonner, der er navngivet ud fra dimensionsnavnet (Activity,
--  CostObject,ExternalUnit,MængdeEnhed,Resource,DRIVER,PRODAKT,PRODVAR,RESVAR,...)

declare @dimension varchar(max)
select @dimension =  isnull(@dimension+',','')+ name from syscolumns where id = object_id('ods.td0_Mxxxx_AccountCenter') and name not like 'dim1%'
select @dimension =  coalesce(@dimension+',','') + ' Dim'+convert(varchar(10), id) collate Danish_Norwegian_CI_AS + ' as ' +quotename(name,'''') from ods.td_Mxxxx_dimension a 
declare @sql varchar(max)

set @sql = 'select '+@dimension+' into ods.td_Mxxxx_AccountCenter from ods.td0_Mxxxx_AccountCenter'
if object_id('ods.td_Mxxxx_AccountCenter') is not null drop table ods.td_Mxxxx_AccountCenter
exec(@sql)
create clustered index refnum on  ods.td_mxxxx_accountcenter (refnum)

--------------------------------------------------------------------------------------------------
-- Data er nu overført fra SASABMMODELS og tabellerne joines sammen til facttabel

if object_id('tempdb..#TD_delmodel_costelement') is not null drop table #TD_delmodel_costelement
select 
		a.FixedCost,
		Case when a.Refnum is null then b.Refnum else a.Refnum end as SourceRefnum,
		c.Refnum as DestRefnum, 
        d.Refnum as PeriodRefnum,
		'Aktual' as ScenarioRefnum,
		Case when substring(a.Refnum,1,1)='E' then substring(reverse(a.Refnum),6,1) else NULL end as Artgrp
into 
		#TD_delmodel_costelement
from	
		ods.td_Mxxxx_costelement a
			left join 
		ods.td_Mxxxx_AccountCenter b on a.sourceId = b.Id  
			left join 
		ods.td_Mxxxx_AccountCenter c on a.DestinationId = c.Id
			left join 
		SASABMMODELS.dbo.PeriodDefinition d on a.PeriodId = d.Id
order by 
		sourcerefnum


--2
if object_id('tempdb..#totaldest') is not null drop table #totaldest

SELECT DISTINCT 
	ce.destrefnum,
	Sum(ce.FixedCost) AS TotalDestinationCost 
INTO 
	#totaldest  
FROM 
	#TD_delmodel_costelement ce
GROUP BY 
	ce.destrefnum

--3
if object_id('tempdb..#Assignment') is not null drop table #Assignment
SELECT 
	ce.destrefnum,
	ce.sourcerefnum,
	ce.Periodrefnum,
	ce.scenariorefnum,
	ce.artgrp,
	ce.FixedCost,
	td.TotalDestinationCost,
	case when td.TotalDestinationCost = 0 then 0 else ce.FixedCost/td.TotalDestinationCost end as Andel
INTO 
	#Assignment
FROM 
	#TD_delmodel_costelement ce
left join
	#totaldest td ON convert(varchar(50),td.destrefnum) collate Danish_Norwegian_CI_AS =ce.destrefnum
WHERE 
	ce.FixedCost NOT in (0)

--4
/*danner niveau 0 Costelement og niveau 1*/
if object_id('tempdb..#data1') is not null drop table #data1

SELECT ast.sourcerefnum as level0,
ast.destrefnum as level1,
ast.Periodrefnum,
ast.Scenariorefnum,
ast.artgrp,
ast.FixedCost as destcost,
ast.andel
INTO #data1
FROM #assignment ast
WHERE substring(ast.sourcerefnum,1,1)='E'
if object_id('tempdb..#data2') is not null drop table #data2
/*danner niveau 2*/
SELECT 
#data1.level0,
#data1.level1,
#data1.andel*ast.andel as nextandel,
ast.destrefnum as level2,
ast.Periodrefnum,
ast.Scenariorefnum,
#data1.artgrp,
ast.FixedCost,
ast.andel,
ast.fixedcost*#data1.Andel as Destcost
INTO #data2
FROM #data1
left join 
#assignment ast
ON
#data1.level1= ast.sourcerefnum

/*danner niveau 3*/
if object_id('tempdb..#data3') is not null drop table #data3
SELECT
#data2.level0,
#data2.level1,
#data2.level2,
#data2.nextandel*ast.andel as nextandel,
ast.destrefnum as level3,
ast.Periodrefnum,
ast.Scenariorefnum,
#data2.artgrp,
ast.FixedCost,
ast.andel,
ast.fixedcost*#data2.nextAndel as Destcost
INTO #data3
FROM #data2
left join 
#assignment ast
ON
#data2.level2= ast.sourcerefnum

/*danner niveau 4 */
if object_id('tempdb..#data4') is not null drop table #data4
SELECT
#data3.level0, 
#data3.level1,
#data3.level2,
#data3.level3,
#data3.artgrp,
ast.destrefnum as level4,
#data3.Periodrefnum,
#data3.Scenariorefnum,
ast.FixedCost,
ast.andel,
#data3.nextandel*ast.andel as nextandel,
Destcost=
CASE 
	WHEN ast.FixedCost IS NULL THEN #data3.destcost
    else
         ast.fixedcost*#data3.nextandel 
END
INTO #data4
FROM #data3
left join 
#assignment ast
ON
#data3.level3= ast.sourcerefnum

/*danner niveau 5*/
if object_id('tempdb..#data5') is not null drop table #data5
SELECT
#data4.level0,
#data4.level1,
#data4.level2,
#data4.level3,
#data4.level4,
#data4.artgrp,
ast.destrefnum as level5,
#data4.Periodrefnum,
#data4.Scenariorefnum,
ast.andel,
#data4.nextandel*ast.andel as nextandel,
ast.FixedCost,
Destcost=
CASE 
	WHEN ast.FixedCost IS NULL THEN #data4.destcost
    else
         ast.fixedcost*#data4.nextandel 
END
INTO #data5
FROM #data4
left join 
#assignment ast
ON
#data4.level4= ast.sourcerefnum

/*danner niveau 6*/
if object_id('tempdb..#data6') is not null drop table #data6
SELECT 
#data5.level0,
#data5.level1,
#data5.level2,
#data5.level3,
#data5.level4,
#data5.level5,
#data5.artgrp,
ast.destrefnum as level6,
#data5.Periodrefnum,
#data5.Scenariorefnum,
ast.andel,
#data5.nextandel*ast.andel as nextandel,
ast.FixedCost,
Destcost=
CASE 
	WHEN ast.FixedCost IS NULL THEN #data5.destcost
    else
		ast.fixedcost*#data5.nextandel 
END
INTO #data6
FROM #data5
left join 
#assignment ast
ON
#data5.level5= ast.sourcerefnum




/*
danner niveau 7*/
if object_id('tempdb..#data7') is not null drop table #data7
SELECT
#data6.level0,
#data6.level1,
#data6.level2,
#data6.level3,
#data6.level4,
#data6.level5,
#data6.level6,
#data6.artgrp,
ast.destrefnum as level7,
#data6.Periodrefnum,
#data6.Scenariorefnum,
ast.andel,
#data6.nextandel*ast.andel as nextandel,
ast.FixedCost,
Destcost=
CASE 
	WHEN ast.FixedCost IS NULL THEN #data6.destcost
    else
		ast.fixedcost*#data6.nextandel 
END,
@model as Model,
@model_id as Model_Id
INTO #data7
FROM #data6
left join 
#assignment ast
ON
#data6.level6= ast.sourcerefnum


--select top 100 * from ods.x order by level1, level2, level3

if object_id('ods.td1_ft_strækningsøkonomi_test1') is not null drop table ods.td1_ft_strækningsøkonomi_test1

select 
	level0,
	'R1Refnum' = level1,
	'R2Refnum' = dbo.getRessource_2013(2, level2, null, null, null, null, null),
	'A1Refnum' = dbo.getActivity_2013(1, level2, null, null, null,null,null),
	'A2Refnum' = dbo.getActivity_2013(2, level2, null, null, null,null,null),
	'A3Refnum' = dbo.getActivity_2013(3, level2, null, null, null,null,null),
	'A4Refnum' = dbo.getActivity_2013(4, level2, null, null, null,null,null),
	artgrp,
	'Co1Refnum' = level3,
   -- level3 As Co1Refnum,
	Periodrefnum,
	Scenariorefnum,
	andel,
	nextandel,
	FixedCost,
	Destcost,
	Model,
	Model_Id
into 
	ods.td1_ft_strækningsøkonomi_test1
from 
	#data7 
where 
	level3 is not null and level4 is null
union all
select 
	level0,
	'R1Refnum' = level1,
	'R2Refnum' = dbo.getRessource_2013(2, level2, null, null, null, null, null),
	'A1Refnum' = dbo.getActivity_2013(1, level2, level3, null, null,null,null),
	'A2Refnum' = dbo.getActivity_2013(2, level2, level3, null, null,null,null),
	'A3Refnum' = dbo.getActivity_2013(3, level2, level3, null, null,null,null),
	'A4Refnum' = dbo.getActivity_2013(4, level2, level3, null, null,null,null),
	artgrp,
	'Co1Refnum' = level4,
    --level4 As Co1Refnum,
	Periodrefnum,
	Scenariorefnum,
	andel,
	nextandel,
	FixedCost,
	Destcost,
	Model,
	Model_Id
from 
	#data7
where 
	level4 is not null and level5 is null
union all
select
	level0,
	'R1Refnum' = level1,
	'R2Refnum' = dbo.getRessource_2013(2, level2, null, null, null, null, null),
	'A1Refnum' = dbo.getActivity_2013(1, level2, level3, level4, null,null,null),
	'A2Refnum' = dbo.getActivity_2013(2, level2, level3, level4, null,null,null),
	'A3Refnum' = dbo.getActivity_2013(3, level2, level3, level4, null,null,null),
	'A4Refnum' = dbo.getActivity_2013(4, level2, level3, level4, null,null,null),
	artgrp,
	'Co1Refnum' = level5,
	--level5 As Co1Refnum,
	Periodrefnum,
	Scenariorefnum,
	andel,
	nextandel,
	FixedCost,
	Destcost,
	Model,
	Model_Id
from 
	#data7 
where 
	level5 is not null and level6 is null
union all
select 
	level0,
	'R1Refnum' = level1,
	'R2Refnum' = dbo.getRessource_2013(2, level2, null, null, null, null, null),
	'A1Refnum' = dbo.getActivity_2013(1, level2, level3, level4, level5,null,null),
	'A2Refnum' = dbo.getActivity_2013(2, level2, level3, level4, level5,null,null),
	'A3Refnum' = dbo.getActivity_2013(3, level2, level3, level4, level5,null,null),
	'A4Refnum' = dbo.getActivity_2013(4, level2, level3, level4, level5,null,null),
	artgrp,
	'Co1Refnum' = level6,
    --level6 As Co1Refnum,
	Periodrefnum,
	Scenariorefnum,
	andel,
	nextandel,
	FixedCost,
	Destcost,
	Model,
	Model_Id
from 
	#data7 
where 
	level6 is not null and level7 is null
union all
select 
	level0,
	'R1Refnum' = level1,
	'R2Refnum' = dbo.getRessource_2013(2, level2, null, null, null, null, null),
	'A1Refnum' = dbo.getActivity_2013(1, level2, level3, level4, level5,level6,null),
	'A2Refnum' = dbo.getActivity_2013(2, level2, level3, level4, level5,level6,null),
	'A3Refnum' = dbo.getActivity_2013(3, level2, level3, level4, level5,level6,null),
	'A4Refnum' = dbo.getActivity_2013(4, level2, level3, level4, level5,level6,null),
	artgrp,
	'Co1Refnum' = level7,
--  level7 As Co1Refnum,
	Periodrefnum,
	Scenariorefnum,
	andel,
	nextandel,
	FixedCost,
	Destcost,
	Model,
	Model_Id
from 
	#data7 
where 
	level7 is not null
-- Unassigned (Maries request)
union all
select 
	level0,
	'R1Refnum' = level1,
	'R2Refnum' = dbo.getRessource_2013(2, level2, null, null, null, null, null),
	'A1Refnum' = dbo.getActivity_2013(1, level2, level3, null, null,null,null),
	'A2Refnum' = dbo.getActivity_2013(2, level2, level3, null, null,null,null),
	'A3Refnum' = dbo.getActivity_2013(3, level2, level3, null, null,null,null),
	'A4Refnum' = dbo.getActivity_2013(4, level2, level3, null, null,null,null),
	artgrp,
	'Co1Refnum' = level4,
	Periodrefnum,
	Scenariorefnum,
	andel,
	nextandel,
	FixedCost,
	Destcost,
	Model,
	Model_Id
from 
	#data7
where 
	level3 is null and level4 is null and level5 is null and level6 is null and level7 is null 
/*CREATE TABLE [ods].[Key_Dim_Member](
	[Pk_Key] [int] IDENTITY(1,1) NOT NULL,
	[DimensionName] [varchar](256) NULL,
	[MemberRefnum] [varchar](256) NULL,
	[Created] [datetime] NULL DEFAULT (getdate())
) ON [PRIMARY]
*/
create clustered index co1refnum on ods.td1_ft_strækningsøkonomi_test1 (co1refnum)
create index a1refnum on ods.td1_ft_strækningsøkonomi_test1 (a1refnum)
create index a2refnum on ods.td1_ft_strækningsøkonomi_test1 (a2refnum)
create index a3refnum on ods.td1_ft_strækningsøkonomi_test1 (a3refnum)
create index a4refnum on ods.td1_ft_strækningsøkonomi_test1 (a4refnum)
create index r1refnum on ods.td1_ft_strækningsøkonomi_test1 (r1refnum)
create index r2refnum on ods.td1_ft_strækningsøkonomi_test1 (r2refnum)




insert into ods.key_dim_member (dimensionname, memberrefnum)
select 
	a.Name as Dimensionname,
	b.refnum as MemberRefnum
from 
	ods.td_Mxxxx_dimension a
		inner join 
	ods.td_Mxxxx_dimmember b on a.id = b.dimensionid
except 
select 
	dimensionname, 
	memberrefnum
from 
	ods.key_dim_member




/*

--drop table [edw].[Dim_Member_alle_modeller]
CREATE TABLE [edw].[Dim_Member_alle_modeller](
	[Model_Id] [int] NULL,
	[DimensionId] [int] NULL,
	[DimensionName] [varchar](64) NULL,
	[MemberId] [int] NULL,
	[MemberKey] [int] NULL,
	[ParentId] [int] NULL,
	[ParentKey] [int] NULL,
	[MemberName] [varchar](64) NULL,
	[MemberRefnum] [varchar](64) NULL,
	[MemberLevelId] [smallint] NULL,
	[MemberDisplayOrder] [float] NULL,
	[Parent_Key] [int] NULL,
	[Drivername] [varchar](64) NULL
)*/ 


--Indsæt nye rækker
--OBS ods.dim_dimensionmembers har identity(1,1) kolonne (pk_key)



delete from ods.dimmember_union_all_alle_modeller where model_id = @model_id 

insert into ods.dimmember_union_all_alle_modeller
(
Model_Id,
DimensionId,
Dimensionname,
MemberId,
MemberKey,
ParentId,
ParentKey,
MemberName,
MemberRefnum,
MemberLevelId,
MemberDisplayOrder,
Drivername)
select
	@model_id,
	Dimension.Id as DimensionId,
	Dimension.Name as Dimensionname,
	--Dimension.OdbcColumnName,
	--Dimension.Refnum,
	--Dimension.Icon,
	--Dimension.Description,
	Member.id as MemberId, 
	k.pk_key as MemberKey,
	Member.ParentId,
	kparent.pk_key as ParentKey,
	Member.name as MemberName,
	Member.refnum as MemberRefnum,
	Member.levelId as MemberLevelId,
	Member.DisplayOrder as MemberDisplayOrder,
	account.Drivername 
from 
	ods.td_Mxxxx_dimension Dimension
		inner join 
	ods.td_Mxxxx_dimmember Member on Dimension.id = Member.dimensionid
		left outer join
	ods.td_Mxxxx_dimmember MemberParent on Dimension.id = MemberParent.dimensionid and Member.parentid = MemberParent.id
		left outer join 
	ods.key_dim_member k on Dimension.name = k.Dimensionname and Member.refnum = k.memberrefnum
		left outer join
	ods.key_dim_member kParent on Dimension.name = kParent.Dimensionname and MemberParent.refnum = kParent.memberrefnum
		left outer join 
	ods.td0_Mxxxx_AccountCenter account on member.refnum = account.refnum


--drop table edw.dim_member
/*CREATE TABLE [edw].[dim_member](
	[PK_Key] [int] NULL,
	[DimensionName] [varchar](64) NULL,
	[MemberName] [varchar](64) NULL,
	[MemberRefnum] [varchar](64) NULL,
	[MemberLevelId] [smallint] NULL,
	[MemberDisplayOrder] [float] NULL,
	[Parent_Key] [int] NULL,
	[Drivername] [varchar] (64) NULL
)*/

--indsæt nye


insert into [edw].[dim_member]
(PK_Key,
Parent_key,
Dimensionname,
MemberName,
MemberRefnum,
MemberLevelId,
MemberDisplayOrder,
Drivername
)
select
m.memberkey,
m.parentkey,
m.Dimensionname,
m.MemberName,
m.MemberRefnum,
m.MemberLevelId,
m.MemberDisplayOrder,
m.Drivername
from 
		ods.dimmember_union_all_alle_modeller m
			left outer join 
		[edw].[dim_member] f on m.Dimensionname = f.Dimensionname and m.memberrefnum = f.memberrefnum 
where 
	f.Dimensionname is null --tilfældig kolonne (der ikke kan være null), blot for at kontrollere at række ikke findes i forvejen i f


--opdater eksisterende
update f
set  f.membername = m.membername,
	f.MemberLevelId = m.MemberLevelId,
	f.MemberDisplayOrder = m.MemberDisplayOrder,
	f.Parent_Key = m.parentkey,
	f.Drivername = m.Drivername
	
from 
		[edw].[dim_member] f
			left outer join 
		ods.dimmember_union_all_alle_modeller m on m.Dimensionname = f.Dimensionname and m.memberrefnum = f.memberrefnum 
where 
	m.model_id = @model_id and
	(f.MemberName <> m.MemberName or
	f.MemberLevelId <> m.MemberLevelId or
	f.MemberDisplayOrder <> m.MemberDisplayOrder or
	f.parent_key <>  m.parentkey or
	f.Drivername <> m.Drivername)
	

insert into edw.dim_member (pk_key, dimensionname)
select distinct -1, dimensionname from edw.dim_member
except 
select pk_key, dimensionname from edw.dim_member where pk_key = -1

Insert into edw.dim_member_slettede (
	[PK_Key],
	[DimensionName],
	[MemberName],
	[MemberRefnum],
	[MemberLevelId],
	[MemberDisplayOrder],
	[Parent_Key],
	[Drivername],
	[indlæstTidspunkt],
	[indlæstAf],
	[opdateretTidspunkt],
	[opdateretAf]
)
SELECT 
 [PK_Key],   ---PK_Key
 [DimensionName],   ---DimensionName
 [MemberName],   ---MemberName
 [MemberRefnum],   ---MemberRefnum
 [MemberLevelId],   ---MemberLevelId
 [MemberDisplayOrder],   ---MemberDisplayOrder
 [Parent_Key],   ---Parent_Key
 [Drivername],   ---Drivername
 [indlæstTidspunkt],   ---indlæstTidspunkt
 [indlæstAf],   ---indlæstAf
 [opdateretTidspunkt],   ---opdateretTidspunkt
 [opdateretAf]   ---opdateretAf
From
	edw.dim_member dim
where 
	dim.memberrefnum not in (select memberrefnum from ods.dimmember_union_all_alle_modeller)
	
delete from edw.dim_member
where 
	memberrefnum not in (select memberrefnum from ods.dimmember_union_all_alle_modeller)



--tjek at dim_member og dim_member_model ikke er ud af sync på pk_key
if object_id('tempdb..#fejl') is not null drop table #fejl
select 'Fejl pk_key <> pk_key' as Fejlbeskrivelse, f.Dimensionname, f.memberrefnum  
into #fejl
from edw.dim_member f
		inner join 
ods.dimmember_union_all_alle_modeller m on  m.Dimensionname = f.Dimensionname and m.memberrefnum = f.memberrefnum 
where m.memberkey <> f.pk_key
if @@rowcount > 0 select * from #fejl




--lav tabel til opslag af pk_key med rækker kun for den aktuelle model af hensyn til performance
if object_id('tempdb..#tempdimfælles') is not null drop table #tempdimfælles
select fælles.memberrefnum, fælles.Dimensionname, fælles.memberkey as k, fælles.memberid as id
into #tempdimfælles
from ods.dimmember_union_all_alle_modeller fælles where model_id =  @model_id


--declare @model_id int 
--set @model_id = 4
if object_id('ods.td3_Ft_Strækningsøkonomi') is not null drop table ods.td3_Ft_Strækningsøkonomi --Skal 

select  
	f.Model_id,
	f.Destcost * convert(float,-1) as Destcost,
	isnull(r1.k, -1) as resource1_key,
	isnull(r2.k, -1) as resource2_key,
	isnull(a1.k, -1) as activity1_key,
	isnull(a2.k, -1) as activity2_key,
	isnull(a3.k, -1) as activity3_key,
	isnull(a4.k, -1) as activity4_key,
	isnull(c1.k, -1) as costobject1_key,	
	isnull(ATTressourcetype.k, -1) as attRessourcetype_key,
	isnull(ATTFunkkunde.k, -1) as attFunktionskunde_key,
	isnull(ATTSegment.k, -1) as AttSegment_key,
	isnull(ATTProduktaktivitetsgruppe.k, -1) as AttProduktaktivitetsgruppe_key,
	isnull(ATTProduktVariabilitet.k, -1) as AttProduktVariabilitet_key,
	isnull(ATTProduktLitra.k, -1) as AttProduktLitra_key,
	isnull(ATTTogsystem.k, -1) as AttTogsystem_key,
	right(level0,1) as CEArt
into 
	ods.td3_Ft_Strækningsøkonomi
from 
 	ods.td1_ft_strækningsøkonomi_test1 f
		left outer join 
	#tempdimfælles r1								on f.r1refnum = r1.memberrefnum
		left outer join 
	ods.td_mxxxx_accountcenter r1Att				on f.r1refnum = r1Att.refnum  ---for at få link til attributten ressourcetype
		left outer join 
	#tempdimfælles r2								on f.r2refnum = r2.memberrefnum
		left outer join 
	#tempdimfælles a1								on f.a1refnum = a1.memberrefnum
		left outer join 
	ods.td_mxxxx_accountcenter a1Att				on f.a1refnum = a1Att.refnum  ---for at få link til attributten Funktionskunde
		left outer join 
	#tempdimfælles a2								on f.a2refnum = a2.memberrefnum
		left outer join 
	#tempdimfælles a3								on f.a3refnum = a3.memberrefnum
		left outer join 
	#tempdimfælles a4								on f.a4refnum = a4.memberrefnum
		left outer join 
	ods.td_mxxxx_accountcenter a4Att				on f.a4refnum = a4Att.refnum  ---for at få link til attributterne Segment og Produktaktivitetsgruppe
		left outer join 
	#tempdimfælles c1								on f.co1refnum = c1.memberrefnum
		left outer join 
	ods.td_mxxxx_accountcenter c1Att				on f.co1refnum = c1Att.refnum	---for at få link til attributten Togsystem
		left outer join
	#tempdimfælles ATTressourcetype					on ATTressourcetype.id = r1Att.Ressourcetyp
		left outer join
	#tempdimfælles ATTFunkkunde						on ATTFunkkunde.id = a1Att.Funktionskun
		left outer join
	#tempdimfælles ATTSegment						on ATTSegment.id = a4Att.Segment
		left outer join
	#tempdimfælles ATTProduktaktivitetsgruppe		on ATTProduktaktivitetsgruppe.id = a4Att.ProdGruppe
		left outer join
	#tempdimfælles ATTProduktVariabilitet			on ATTProduktVariabilitet.id = a4Att.Produktvaria
		left outer join
	#tempdimfælles ATTProduktLitra					on ATTProduktLitra.id = a4Att.Produktlitra
		left outer join
	#tempdimfælles ATTTogsystem						on ATTTogsystem.id = c1Att.Togsystem
	




goto theend 



theend:



end --proc