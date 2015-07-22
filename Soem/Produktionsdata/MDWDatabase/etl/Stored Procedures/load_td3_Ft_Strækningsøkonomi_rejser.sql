
CREATE proc [etl].[load_td3_Ft_Strækningsøkonomi_rejser]  
as
begin

--M1087	201312
--M1088	201112


declare @model_id int
declare @periode varchar(50) 
select 
	@model_id = pk_id,
	@periode = li.periode
	
from 
	edw.dim_model dm
		inner join 
	dbo.MD_Kontrol_ModelLoadInfo li on 
		dm.model = li.abm_model 
		and dm.år = li.periode
		
		
delete from  edw.[Ft_Strækningsøkonomi_Rejser_Togsystem] where model_id in (select pk_id from edw.dim_model where periode = @periode)


--LAV PIVOT på GD-tabel for rejseindtægter for Fjern og regional så measures vendes op fra rækker som kolonner

if object_id('tempdb.dbo.#temprejseindtægterFRPivot') is not null drop table #temprejseindtægterFRPivot
SELECT  
	costobjekt, --dimensionsnøgle
	Delrejser,
	Passagerkm
INTO 
	#temprejseindtægterFRPivot
FROM
	(SELECT 
		costobjekt, 
		enhed, 
		værdi
    FROM 
		[dbo].[GD_R_RejseIndtægter_Togsystem_FR] 
	WHERE 
		enhed IN ('Delrejser','Passagerkm')
		and periodeindlæst = @periode) AS SourceTable
 PIVOT
	(
	SUM(værdi) 
	FOR Enhed IN (Delrejser,Passagerkm)
	) AS PivotTable



insert into [edw].[Ft_Strækningsøkonomi_Rejser_Togsystem]
(	Model_id,
	costobjekt1_key,
	costobjekt,
	Delrejser,
	Passagerkm
)
select
	@model_id as Model_id,
	isnull(kC.pk_key, -1) as costobjekt1_key,
	b.costobjekt,
	b.Delrejser,
	b.Passagerkm
from 
	#temprejseindtægterFRPivot b
		left outer join
	[ods].[Key_Dim_Member] kC on kC.DimensionName = 'Costobject' and B.costobjekt = kC.memberrefnum

--LAV PIVOT på GD-tabel for rejseindtægter for s-Tog så measures vendes op fra rækker som kolonner

if object_id('tempdb.dbo.#temprejseindtægterSTOGPivot') is not null drop table #temprejseindtægterSTOGPivot
SELECT  
	costobjekt, --dimensionsnøgle
	Delrejser--, kommer på senere
	--Passagerkm kommer på senere
INTO 
	#temprejseindtægterSTOGPivot
FROM
	(SELECT 
		costobjekt, 
		enhed, 
		værdi
    FROM 
		[dbo].[GD_R_RejserIndtægter_Stog] 
	WHERE 
		enhed IN ('Delrejser') -- kommer på senere:,'Passagerkm')
		and periodeindlæst = @periode) AS SourceTable
 PIVOT
	(
	SUM(værdi) 
	FOR Enhed IN (Delrejser) -- kommer på senere: ,Passagerkm)
	) AS PivotTable


insert into [edw].[Ft_Strækningsøkonomi_Rejser_Togsystem]
(	Model_id,
	costobjekt1_key,
	costobjekt,
	Delrejser--, kommer på senere
	--Passagerkm  kommer på senere
)
select
	@model_id as Model_id,
	isnull(kC.pk_key, -1) as costobjekt1_key,
	b.costobjekt,
	b.Delrejser-- ,kommer på senere
	--b.Passagerkm kommer på senre
from 
	#temprejseindtægterSTOGPivot b
		left outer join
	[ods].[Key_Dim_Member] kC on kC.DimensionName = 'Costobject' and B.costobjekt = kC.memberrefnum

end