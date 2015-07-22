create PROC [etl].[load_Dim_Art_Hierearki_ny_dirk]
as 
BEGIN
/*
Initialt:
CREATE TABLE [ods].[key_Dim_Art_Hierarki](
	[pk_key] [int] IDENTITY(-1,1) NOT NULL,
	[Art] [varchar](50) NOT NULL
insert into [ods].[key_Dim_Art_Hierarki] (Art) values ('Ikke allokeret') --PK_KEY = -1
insert into [ods].[key_Dim_Art_Hierarki] (Art) values ('Ukendt') --PK_KEY = 0
) */
INSERT INTO [ods].[key_Dim_Art_Hierarki] 
	(Art)
	
SELECT ArtID FROM 
(	SELECT  
		ArtID 
	FROM 
	 	ods.md_art_dim_ny_dirk 
		
	UNION

	SELECT  
		Art as ArtId
	FROM 
		ods.md_artshierarki_manuelle_tilføjelser_ny_dirk
) A

EXCEPT

SELECT DISTINCT 
	Art 
FROM 
	[ods].[key_Dim_Art_Hierarki] 
	
/*
CREATE TABLE [edw].[Dim_Art_Hierarki](
	[Pk_key] [int],
	[Art] [varchar](255) NULL,
	[Artsnavn] [varchar](255) NULL,
	[Parent_Key] [int] NULL,
	[Parent] [varchar](255) NULL
) 
*/

TRUNCATE TABLE [edw].[Dim_Art_Hierarki_ny_dirk]

--Indsæt arter fra Dirk
INSERT INTO [edw].[Dim_Art_Hierarki_ny_dirk] (
	[Pk_key],
	[Art],
	[Artsnavn],
	[Parent_Key],
	[Parent]
	)
SELECT DISTINCT 
	k.pk_key,
	k.Art,
	a.membername,
	parentK.pk_key,
	a.parent
FROM 
	ods.MD_Art_Dim_ny_dirk a
		left outer join
	ods.key_Dim_Art_Hierarki k on a.artid = k.art
		left outer join
	ods.key_Dim_Art_Hierarki parentK on a.parent = parentK.art

--Indsæt manuelle arter, som ikke er allerede er overført fra Dirk
INSERT INTO [edw].[Dim_Art_Hierarki_ny_dirk] (
	[Pk_key],
	[Art],
	[Artsnavn],
	[Parent_Key],
	[Parent]
	)
SELECT DISTINCT 
	k.pk_key,
	k.Art,
	a.membername,
	parentK.pk_key,
	a.parent
FROM 
	(select Art as ArtId, Artsnavn as MemberName, Parent from ods.md_artshierarki_manuelle_tilføjelser_ny_dirk
		except
	select ArtID,MemberName,Parent from ods.md_art_dim_ny_dirk) a
		left outer join
	ods.key_Dim_Art_Hierarki k on a.artid = k.art
		left outer join
	ods.key_Dim_Art_Hierarki parentK on a.parent = parentK.art



END