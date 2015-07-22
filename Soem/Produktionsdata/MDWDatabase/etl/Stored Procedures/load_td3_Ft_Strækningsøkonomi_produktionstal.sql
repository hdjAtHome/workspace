
CREATE proc [etl].[load_td3_Ft_Strækningsøkonomi_produktionstal]  
as
begin


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


if object_id('tempdb.dbo.#tempFjernOgRegional') is not null drop table #tempFjernOgRegional
select 
	periodeindlæst, 
	litratypeid, 
	costobjekt, 
	enhed, 
	værdi 
into 
	#tempFjernOgRegional 
from 
	dbo.GD_R_Togproduktion_FR 
where 
	periodeindlæst = @periode 
	and materielkørsel = 'Nej'

--LAV PIVOT på GD-tabel for togproduktion så measures vendes op fra rækker som kolonner
--for meauseres, der både kan knyttes til litratype og costobject (togsystem)

if object_id('tempdb.dbo.#tempFjernOgRegionalA') is not null drop table #tempFjernOgRegionalA
SELECT  
	litratypeid, --dimensionsnøgle
	costobjekt, --dimensionsnøgle
	[Litrakm], --measure
	[Litratimer], --measure
	[Pladskm] --measure
INTO 
	#tempFjernOgRegionalA
FROM
	(SELECT 
		litratypeid, 
		costobjekt, 
		enhed, 
		værdi
    FROM 
		#tempFjernOgRegional 
	WHERE 
		enhed IN ('Litrakm','Litratimer','Pladskm') ) AS SourceTable
PIVOT
	(
	SUM(værdi) 
	FOR Enhed IN (Litrakm, Litratimer, Pladskm)
	) AS PivotTable


delete from  edw.Ft_Strækningsøkonomi_produktionstal_Litra where model_id in (select pk_id from edw.dim_model where periode = @periode)

insert into edw.Ft_Strækningsøkonomi_produktionstal_Litra
(	Model_id,
	attProduktlitra_key,
	litratypeid,
	costobjekt1_key,
	costobjekt,
	Litrakm,
	Litratimer,
	Pladskm  
)
select
	@model_id as Model_id,
	isnull(kL.pk_key, -1) as attProduktlitra_key,
	a.litratypeid,
	isnull(kC.pk_key, -1) as costobjekt1_key,
	a.costobjekt,
	a.Litrakm,
	a.Litratimer,
	a.Pladskm  
from 
	#tempFjernOgRegionalA a
		left outer join 
	[ods].[Key_Dim_Member] kL on kL.DimensionName = 'ProduktLitra' and a.litratypeid = kL.memberrefnum
		left outer join
	[ods].[Key_Dim_Member] kC on kC.DimensionName = 'Costobject' and a.costobjekt = kC.memberrefnum
	

--LAV PIVOT på GD-tabel for togproduktion så measures vendes op fra rækker som kolonner
--for meauseres, der kun kan knyttes til costobject (togsystem)

if object_id('tempdb.dbo.#tempFjernOgRegionalB') is not null drop table #tempFjernOgRegionalB
SELECT  
	costobjekt, --dimensionsnøgle
	[Togkm],	--measure
	[TogTimer]	--measure
INTO 
	#tempFjernOgRegionalB
FROM
	(SELECT 
		costobjekt, 
		enhed, 
		værdi
    FROM 
		#tempFjernOgRegional 
	WHERE 
		enhed IN ('Togkm','Togtimer') ) AS SourceTable
 PIVOT
	(
	SUM(værdi) 
	FOR Enhed IN (Togkm, TogTimer)
	) AS PivotTable

delete from  edw.Ft_Strækningsøkonomi_produktionstal_Togsystem where model_id in (select pk_id from edw.dim_model where periode = @periode)

insert into edw.Ft_Strækningsøkonomi_produktionstal_Togsystem
(	Model_id,
	costobjekt1_key,
	costobjekt,
	Togkm,
	Togtimer 
)
select
	@model_id as Model_id,
	isnull(kC.pk_key, -1) as costobjekt1_key,
	b.costobjekt,
	b.Togkm,
	b.Togtimer 
from 
	#tempFjernOgRegionalB b
		left outer join
	[ods].[Key_Dim_Member] kC on kC.DimensionName = 'Costobject' and B.costobjekt = kC.memberrefnum

----------------------------------------------------------
--For STOG, blot kun for henholdsvis togkm på costobjekt og pladskilometer på litra (-1 / null i første omgagn) og costobjekt (ikke brug for pivot, da der kun er én measure på facttabel)
----------------------------------------------------------
	

insert into edw.Ft_Strækningsøkonomi_produktionstal_Togsystem
(	Model_id,
	costobjekt1_key,
	costobjekt,
	Togkm
)
select
	@model_id as Model_id,
	isnull(kC.pk_key, -1) as costobjekt1_key,
	s.costobjekt,
	sum(s.værdi) as togkm
from 
	dbo.GD_R_Togproduktion_STog s
		left outer join
	[ods].[Key_Dim_Member] kC on kC.DimensionName = 'Costobject' and s.costobjekt = kC.memberrefnum
where 
	s.enhed = 'togkm'
	and periodeindlæst = @periode
group by 
	kC.pk_key, s.costobjekt


insert into edw.Ft_Strækningsøkonomi_produktionstal_Litra
(	Model_id,
	attProduktlitra_key,
	litratypeid,
	costobjekt1_key,
	costobjekt,
	Pladskm  
)
select
	@model_id as Model_id,
	-1 as attProduktlitra_key,
	null,
	isnull(kC.pk_key, -1) as costobjekt1_key,
	s.costobjekt,
	sum(s.værdi)  as pladskm
from 
	dbo.GD_R_Togproduktion_STog s
		left outer join
	[ods].[Key_Dim_Member] kC on kC.DimensionName = 'Costobject' and s.costobjekt = kC.memberrefnum
where 
	s.enhed = 'pladskm'
	and periodeindlæst = @periode
group by 
	kC.pk_key, s.costobjekt
	







end