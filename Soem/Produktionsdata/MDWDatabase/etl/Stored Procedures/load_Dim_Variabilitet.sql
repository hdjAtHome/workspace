CREATE proc [etl].[load_Dim_Variabilitet]
as
begin

/*Initielt for dimensionens key tabel:

insert into [ods].[key_Dim_Variabilitet] ([Variabilitet_Reference]) values ('Ingen') -- -1
insert into [ods].[key_Dim_Variabilitet] ([Variabilitet_Reference]) values ('Ukendt') -- 0
*/
	
--Dan surrogatnøgle pk_key for nye 
 
INSERT INTO [ods].[key_Dim_variabilitet] 
	([Variabilitet_Reference])
	
SELECT [variabilitet] FROM 
(	select distinct variabilitet from dbo.md_g_krit_variabilitet where variabilitet is not null
) A

EXCEPT

SELECT DISTINCT 
	[Variabilitet_Reference] 
FROM 
	[ods].[key_Dim_variabilitet] 

TRUNCATE TABLE [edw].[Dim_Variabilitet]

INSERT INTO [edw].[Dim_Variabilitet] (
	[Pk_key],
	[Variabilitet_Reference],
	[Variabilitet_Navn]
	)
SELECT DISTINCT 
	k.pk_key,
	d.Variabilitet as Variabilitet_Reference,
	d.VariabilitetNavn as Variabilitet_Navn
FROM 
	dbo.md_g_krit_variabilitet d
		left outer join
	[ods].[key_Dim_variabilitet]  k on d.Variabilitet = k.[Variabilitet_Reference]
WHERE variabilitet_reference is not null
UNION 
SELECT k.pk_key,
	k.Variabilitet_Reference,
	'' as Variabilitet_Navn
FROM 
	[ods].[key_Dim_Variabilitet]  k 
WHERE pk_key <  1

		
--select * from [edw].[Dim_Variabilitet]

end