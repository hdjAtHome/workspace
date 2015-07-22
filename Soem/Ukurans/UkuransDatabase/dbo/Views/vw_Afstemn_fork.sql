




CREATE view [dbo].[vw_Afstemn_fork]
-- Ajourført 141114-1: Ændret FraTil_Tid med en Cast, da det fyldte 8000...
-- Ajourført 141114-2: Tilføjet Kassation i afstemningen
-- Ajourført 150319-1: Ændret afstemningsudgangspunktet til at være dbo.vw_Nedskriv_Primo_Brutto
as
Select q1.Aendring, q1.Dim_Fabrik, q1.Materiale, q1.Dim_Materiale, q1.LNType, q1.FLNType, q1.FraTil_Tid, 
q1.Beholdning, q1.AnskVaerdi, 
q1.NedForPrinc, q1.NedskrNetto, q1.Vaerdi_SP, q1.AnskVaerdi - q1.Vaerdi_SP Forskel
from (
		select 'AFSTEMNING1' Aendring, 
	coalesce(prim.Dim_Fabrik, fald.Dim_Fabrik, kas.Dim_Fabrik, stig.Dim_Fabrik, 
		samm.Dim_Fabrik, nyik.Dim_Fabrik, lnb.Dim_Fabrik) Dim_Fabrik,
--  Evaluates the arguments in order and returns the current value of the first expression that initially does not evaluate to NULL
	coalesce(prim.Materiale, fald.Materiale, kas.Materiale, stig.Materiale, 
		samm.Materiale, nyik.Materiale, lnb.Materiale) Materiale,
	coalesce(prim.Dim_Materiale, fald.Dim_Materiale, kas.Dim_Materiale, 
		stig.Dim_Materiale, samm.Dim_Materiale, nyik.Dim_Materiale, lnb.Dim_Materiale) Dim_Materiale,
	Cast((select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'PrimoDato') 
		+ '-' +( select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'UltimoDato') 
		as Varchar (13)) as FraTil_tid,
	isnull(prim.LNType, isnull(fald.LNType, isnull(stig.LNType, isnull(samm.LNType, isnull(nyik.LNType, lnb.LNType))))) as LNType,
	isnull(prim.FLNType, isnull(fald.FLNType, isnull(stig.FLNType, isnull(samm.FLNType, isnull(nyik.FLNType, lnb.FLNType))))) as FLNType,
	((isnull(prim.Beholdning, 0) + isnull(kas.Beholdning, 0)+ isnull(fald.Beholdning, 0) + isnull(stig.Beholdning, 0) 
		+ isnull(samm.Beholdning, 0) + isnull(nyik.Beholdning, 0)) - isnull(lnb.Beholdning, 0)) *-1 As Beholdning,
	((isnull(prim.AnskVaerdi, 0) + isnull(kas.AnskVaerdi, 0) + isnull(fald.AnskVaerdi, 0) + isnull(stig.AnskVaerdi, 0) 
		+ isnull(samm.AnskVaerdi, 0) + isnull(nyik.AnskVaerdi, 0)) - isnull(lnb.AnskVaerdi, 0)) * -1  as AnskVaerdi,
	((isnull(prim.NedForPrinc, 0) + isnull(kas.NedForPrinc, 0) + isnull(fald.NedForPrinc, 0) + isnull(stig.NedForPrinc, 0) 
		+ isnull(samm.NedForPrinc, 0) + isnull(nyik.NedForPrinc, 0)) - isnull(lnb.NedForPrinc, 0)) * -1 as NedForPrinc,
	((isnull(prim.NedskrNetto, 0) + isnull(kas.NedskrNetto, 0) + isnull(fald.NedskrNetto, 0) + isnull(stig.NedskrNetto, 0) 
		+ isnull(samm.NedskrNetto, 0) + isnull(nyik.NedskrNetto, 0)) - isnull(lnb.NedskrNetto, 0)) * -1 as NedskrNetto,
	((isnull(prim.Vaerdi_SP, 0) + isnull(kas.Vaerdi_SP, 0) + isnull(fald.Vaerdi_SP, 0) + isnull(stig.Vaerdi_SP, 0) 
		+ isnull(samm.Vaerdi_SP, 0) + isnull(nyik.Vaerdi_SP, 0))- isnull(lnb.Vaerdi_SP, 0)) * -1 As Vaerdi_SP
	from dbo.vw_Nedskriv_Primo_Brutto prim
	full outer join dbo.[vw_Faldende_Beh] fald
	on prim.Dim_Fabrik = fald.Dim_Fabrik and prim.Materiale = fald.Materiale
	full outer join dbo.[vw_Stigende_Beh] stig
	on prim.Dim_Fabrik = stig.Dim_Fabrik and prim.Materiale = stig.Materiale
	full outer join dbo.[vw_Samme_Beh] samm
	on prim.Dim_Fabrik = samm.Dim_Fabrik and prim.Materiale = samm.Materiale
	full outer join dbo.[vw_NyIndkPer_Beh] nyik
	on prim.Dim_Fabrik = nyik.Dim_Fabrik and prim.Materiale = nyik.Materiale
	full outer join dbo.vw_LogNedsBrutto lnb
	on prim.Dim_Fabrik = lnb.Dim_Fabrik and prim.Materiale = lnb.Materiale
	full outer join dbo.vw_Kassation kas
	on prim.Dim_Fabrik = kas.Dim_Fabrik and prim.Materiale = kas.Materiale
) q1

where isnull(q1.Beholdning, 0) >= 1 or isnull(q1.Beholdning, 0) <= -1
or isnull(q1.AnskVaerdi, 0) >= 1 or isnull(q1.AnskVaerdi, 0) <= -1
--isnull(round(q1.NedForPrinc, 3), 0) <> 0 or isnull(round(q1.NedskrNetto, 3), 0) <> 0 or isnull(round(q1.Vaerdi_SP, 3), 0) <> 0