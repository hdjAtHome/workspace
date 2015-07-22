CREATE PROC [etl].[load_Dim_Ordre]
as 
BEGIN
/*
Initialt:

insert into [ods].[key_Dim_Ordre] (Ordre) values ('Ikke allokeret') --PK_KEY = -1
insert into [ods].[key_Dim_Ordre] (Ordre) values ('Ukendt') --PK_KEY = 0
 */
INSERT INTO [ods].[key_Dim_Ordre] 
	(Ordre)
SELECT DISTINCT 
	Ordre 
FROM 
	ods.td0_CD_G_ETL5_Ressourceportal_Drift
WHERE Ordre is not null

EXCEPT

SELECT DISTINCT 
	Ordre 
FROM 
	[ods].[key_Dim_Ordre] 


SET ANSI_Warnings off

INSERT INTO [edw].[Dim_Ordre] (
	[Pk_key],
	[Ordre],
	[Ordrenavn]--,
	--[Parent_Key],
	--[Parent]
	)
SELECT DISTINCT 
	k.pk_key,
	k.Ordre,
	max(a.Ordrenavn)--,
	--parentK.pk_key,
	--a.parent
FROM 
	ods.td0_CD_G_ETL5_Ressourceportal_Drift a
		inner join
	ods.key_Dim_Ordre k on a.Ordre = k.Ordre
		left outer join 
	[edw].[Dim_Ordre] x on x.ordre = k.ordre
where 
	x.ordre is null -- = den findes ikke i ofr
GROUP BY
	 k.pk_key, k.ordre	




END