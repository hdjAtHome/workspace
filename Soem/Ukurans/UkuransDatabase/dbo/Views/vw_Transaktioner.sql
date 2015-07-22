create view [dbo].[vw_Transaktioner]
as
select isnull(Dim_Fabrik, '-1') Dim_Fabrik, isnull(Materiale, '-1') Materiale, isnull( Dim_Materiale, -1) Dim_Materiale, omkart, 
isnull(Dim_BevArt, '-1') BevArt, Maengde, 
Vaerdi_SP, RefBilagNr, IndkBilag, BogfDato, isnull(Dim_Tid, '-1') Dim_Tid, RegistrDato, RegistrDatoKl, Brugernavn, BilagNr, Profitcenter, [Partner]
from edw.FT_Transaktioner