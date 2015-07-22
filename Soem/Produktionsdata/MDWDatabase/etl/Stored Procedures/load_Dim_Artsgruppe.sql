

CREATE proc [etl].[load_Dim_Artsgruppe]
as
begin



/*Initielt for dimensionens key tabel:

	insert into [ods].[key_Dim_Artsgruppe] ([Artsgruppe_reference]) values ('Ikke allokeret') --PK_KEY = -1
	insert into [ods].[key_Dim_Artsgruppe] ([Artsgruppe_reference]) values ('Ukendt') --PK_KEY = 0

*/

--Dan surrogatnøgle pk_key for nye artsgrupper

INSERT INTO [ods].[key_Dim_Artsgruppe] 
	([Artsgruppe_reference])
	
SELECT [Artsgruppe_reference] FROM 
(	SELECT  
		artgrp as [Artsgruppe_reference]
	FROM 
		ods.md_g_stam_artgrp
) A

EXCEPT

SELECT DISTINCT 
	[Artsgruppe_reference] 
FROM 
	[ods].[key_Dim_Artsgruppe] 

--Load artsgruppe dimensionen

TRUNCATE TABLE [edw].[Dim_Artsgruppe]

--Indsæt arter fra Dirk
INSERT INTO [edw].[Dim_Artsgruppe] (
	[Pk_key],
	[Artsgruppe_Reference],
	[Artsgruppe_Navn]
	)
SELECT DISTINCT 
	k.pk_key,
	d.artgrp as Artsgruppe_Neference,
	d.artgrpnavn as Artsgruppe_Navn
FROM 
	ods.md_g_stam_artgrp d
		left outer join
	[ods].[key_Dim_Artsgruppe]  k on d.artgrp = k.artsgruppe_reference
		


end