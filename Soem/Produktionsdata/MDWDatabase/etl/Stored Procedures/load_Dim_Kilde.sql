--exec [etl].[load_Dim_Kilde]


create PROC [etl].[load_Dim_Kilde]
as 
BEGIN

/*
Initialt:
insert into [ods].[key_Dim_Kilde] (Kilde) values ('Ikke allokeret') --PK_KEY = -1
insert into [ods].[key_Dim_Kilde] (Kilde) values ('Ukendt') --PK_KEY = 0
 */
INSERT INTO [ods].[key_Dim_Kilde] 
(	kildeark,
	kildebeskrivelse )
SELECT DISTINCT 
	KildeArk,
	Kilde_Beskrivelse 
FROM 
	ods.td0_CD_G_ETL5_Ressourceportal_Drift
WHERE 
	Kilde_beskrivelse is not null and kildeark is not null

EXCEPT

SELECT DISTINCT 
	kildeark,
	kildebeskrivelse 
FROM 
	[ods].[key_Dim_Kilde] 

INSERT INTO [ods].[key_Dim_Kilde] 
(	Kildeark,
	kildebeskrivelse)
SELECT DISTINCT 
	Kildeark,
	kilde_beskrivelse
FROM 
	ods.td0_CD_G_ETL5_Ressourceportal_Anlæg
WHERE Kilde_beskrivelse is not null and kildeark is not null

EXCEPT

SELECT DISTINCT 
	Kildeark,
	kildebeskrivelse
FROM 
	[ods].[key_Dim_Kilde] 

SET ANSI_Warnings off

INSERT INTO [edw].[Dim_Kilde] (
	[Pk_key],
	[Kilde],
	[KildeArk],
	[KildeBeskrivelse] --skal udfases når kuben er tilrettet
	)
SELECT DISTINCT 
	k.[pk_key],
	k.[KildeBeskrivelse], 
	k.[KildeArk],
	k.[KildeBeskrivelse] -- skal udfases når kuben er tilrettet
FROM 
	ods.key_Dim_Kilde k 
		left outer join 
	[edw].[Dim_Kilde] x on x.kildeark = k.kildeark and x.Kildebeskrivelse = k.Kildebeskrivelse 
where 
	x.Kildeark is null -- = den findes ikke i forvejen




END