CREATE PROC [etl].[load_Dim_PSPElement]
as 
BEGIN
/*
Initialt:
insert into [ods].[key_Dim_PSPElement] (PSPElement) values ('Ikke allokeret') --PK_KEY = -1
insert into [ods].[key_Dim_PSPElement] (PSPElement) values ('Ukendt') --PK_KEY = 0
 */
INSERT INTO [ods].[key_Dim_PSPElement] 
	(PSPElement)
SELECT DISTINCT 
	[PSP-Element] 
FROM 
	ods.td0_CD_G_ETL5_Ressourceportal_Drift
WHERE [PSP-Element] is not null

EXCEPT

SELECT DISTINCT 
	PSPElement 
FROM 
	[ods].[key_Dim_PSPElement] 


INSERT INTO [edw].[Dim_PSPElement] (
	[Pk_key],
	[PSPElement],
	[PSPElementnavn]
	)
SELECT DISTINCT 
	k.pk_key,
	k.PSPElement,
	a.[PSP-Elementnavn]
FROM 
	ods.td0_CD_G_ETL5_Ressourceportal_Drift a
		inner join
	ods.key_Dim_PSPElement k on a.[PSP-Element] = k.PSPElement
		left outer join 
	[edw].[Dim_PSPElement] x on a.[psp-element] = x.pspelement
where x.pspelement is null
	

END