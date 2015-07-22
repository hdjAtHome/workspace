


CREATE view [dbo].[vw_Kasseret]
as
-- Ajourført 150112-1: Ændret frakriterie til at være større end PrimoDato
-- Ajourført 150318-1: Elimineret Dim_Materiale, sættes i dbo.vw_Kassation til at aktuel PK_ID uanset hvornår kassation fysisk er sket (da kass. kan ske på flere end 2 i perioden)

select Dim_Fabrik, /*Dim_Materiale, */ Materiale, 
cast((select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'PrimoDato') 
	+'-'+ ( select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'UltimoDato') as varchar(13)) FraTil_Tid,
sum(Maengde) Maengde, sum(Vaerdi_SP) Vaerdi
from edw.FT_Transaktioner
left join edw.Dim_BevArt
on edw.FT_Transaktioner.Dim_BevArt = edw.Dim_BevArt.BevArt
where RegistrDato >		(select Vaerdi from [edw].[MD_Styringstabel] where parameter = 'PrimoDato')
	and RegistrDato <=  (select Vaerdi from [edw].[MD_Styringstabel] where parameter = 'UltimoDato')
	and BevArtType = 'Kassation'
group by Dim_Fabrik, /* Dim_Materiale, */ Materiale