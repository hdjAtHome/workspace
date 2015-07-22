
CREATE proc [etl].[load_Dim_Reversibilitet]
as
begin

/*Initielt for dimensionens key tabel:

insert into [ods].[key_Dim_Reversibilitet] ([Reversibilitet_Reference]) values ('Ingen') -- -1
insert into [ods].[key_Dim_Reversibilitet] ([Reversibilitet_Reference]) values ('Ukendt') -- 0
*/

--Dan surrogatnøgle pk_key for nye
 
INSERT INTO [ods].[key_Dim_Reversibilitet] 
	([Reversibilitet_Reference])
	

SELECT [Reversibilitet] FROM 
(	select distinct reversibilitet from dbo.md_g_krit_reversibilitet where reversibilitet is not null
) A

EXCEPT

SELECT DISTINCT 
	[Reversibilitet_Reference] 
FROM 
	[ods].[key_Dim_reversibilitet] 

--Load  dimensionen

TRUNCATE TABLE [edw].[Dim_Reversibilitet]

INSERT INTO [edw].[Dim_Reversibilitet] (
	[Pk_key],
	[Reversibilitet_Reference],
	[Reversibilitet_Navn]
	)
SELECT DISTINCT 
	k.pk_key,
	d.Reversibilitet as Reversibilitet_Reference,
	d.ReversibilietNavn as Reversibilitet_Navn
FROM 
	dbo.md_g_krit_Reversibilitet d
		left outer join
	[ods].[key_Dim_Reversibilitet]  k on d.Reversibilitet = k.[Reversibilitet_Reference]
WHERE Reversibilitet_reference is not null
UNION 
SELECT k.pk_key,
	k.Reversibilitet_Reference,
	'' as Reversibilitet_Navn
FROM 
	[ods].[key_Dim_Reversibilitet]  k 
WHERE pk_key <  1


end