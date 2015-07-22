









CREATE view [dbo].[vw_Stigende_Beh]
-- Ajourført 141114-1: Ændret FraTil_Tid med en Cast, da det fyldte 8000...
-- Ajourført 141117-1: Indarbejdet kassation i stigningen med en outer join og beregning i felterne fra Beholdning til NedskrNetto
-- Ajourført 141117-2: Forenklet case/when så der ikke analyseres på om der er beholdning hhv. værdi forrige periode
-- Ajourført 150115-1: Ændret join for edw.ft_NySeneste3Aar, så nye eksisterende medtages i stigende beholdninger
-- Ajourført 150318-1: Ændret join for kassation, så der joines på Materiale i stedet for Dim_Materiale
-- Ajourført 150319-1: Ændret kriterie for ly-join til FraTil_Tid og rettet ly-periode med ny PrimoPrimoDato
as
Select q1.Dim_Materiale, q1.Dim_Fabrik, q1.Materiale, q1.LNType, q1.FLNType, q1.FraTil_tid, sum(q1.Beholdning) Beholdning, sum(q1.behly) ForrigBeh,
sum(q1.AnskVaerdi) AnskVaerdi, sum(q1.NedForPrinc) NedForPrinc, sum(q1.NedskrNetto) NedskrNetto, sum(q1.Vaerdi_SP) Vaerdi_SP
from (
	select isnull(cy.Dim_Materiale, isnull(ly.Dim_Materiale, cy.Dim_Materiale)) Dim_Materiale, 
	isnull(cy.Dim_Fabrik, isnull(ly.Dim_Fabrik, cy.Dim_Fabrik)) Dim_Fabrik, 
	isnull(cy.Materiale, isnull(ly.Materiale, cy.Materiale)) Materiale, ly.Beholdning behly,
	isnull(cy.LNType, 'AUB') as LNType,
	isnull(ly.LNType, 'AEPD') as FLNType,
	Cast(( select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'PrimoDato') 
		+ '-' +( select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'UltimoDato') 
		as Varchar (13)) as FraTil_tid,

	  Case	When (isnull(cy.Beholdning, 0) - isnull(kas.Beholdning, 0)) > isnull(ly.Beholdning, 0)	
			Then (isnull(cy.Beholdning, 0) - isnull(kas.Beholdning, 0)) - isnull(ly.Beholdning, 0)
							
			Else	0
	  End as Beholdning,

	  Case  When isnull(cy.Vaerdi_SP, 0) > 0
			Then Case	When (isnull(cy.Beholdning, 0) - isnull(kas.Beholdning, 0)) > isnull(ly.Beholdning, 0)
						Then (isnull(cy.Beholdning, 0) - isnull(kas.Beholdning, 0) - isnull(ly.Beholdning, 0)) 
						   * (isnull(cy.Vaerdi_SP, 0) / isnull(cy.Beholdning, 0)) 
						Else 0
				 End
			Else 0
	  End as Vaerdi_SP,

	  Case  When isnull(cy.Vaerdi_GP, 0) > 0
			Then Case	When (isnull(cy.Beholdning, 0) - isnull(kas.Beholdning, 0)) > isnull(ly.Beholdning, 0)
						Then (isnull(cy.Beholdning, 0) - isnull(kas.Beholdning, 0) - isnull(ly.Beholdning, 0)) 
						   * (isnull(cy.Vaerdi_GP, 0) / isnull(cy.Beholdning, 0)) 
						Else 0
				 End
			Else 0
	  End as AnskVaerdi,

	-- ly.LogNedBrutto as lyLogNedBr, cy.LogNedBrutto as nscyLogNedBr,

	  Case  When isnull(cy.LogNedBruttoPae, 0) < 0
			Then Case	When (isnull(cy.Beholdning, 0) - isnull(kas.Beholdning, 0)) > isnull(ly.Beholdning, 0)
						Then (isnull(cy.Beholdning, 0) - isnull(kas.Beholdning, 0) - isnull(ly.Beholdning, 0)) 
						   * (isnull(cy.LogNedBruttoPae, 0) / isnull(cy.Beholdning, 0)) 
						Else 0
				 End
			Else 0
	  End as NedForPrinc,

	  Case  When isnull(cy.LogNedBrutto, 0) < 0
			Then Case	When (isnull(cy.Beholdning, 0) - isnull(kas.Beholdning, 0)) > isnull(ly.Beholdning, 0)
						Then (isnull(cy.Beholdning, 0) - isnull(kas.Beholdning, 0) - isnull(ly.Beholdning, 0)) 
						   * (isnull(cy.LogNedBrutto, 0) / isnull(cy.Beholdning, 0)) 
						Else 0
				 End
			Else 0
	  End as NedskrNetto

	from 
	(select Dim_Fabrik, Dim_Materiale, Materiale,  LogNedBrutto, LogNedBruttoPae, NedskrNetto, LNType, LavNedPct, Vaerdi_GP, Vaerdi_SP, Beholdning
		  from dbo.vw_Nedskriv--( select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'UltimoDato')
		  where substring(Dim_Fabrik, 1, 2) = '21') cy

Full outer join
	(select Dim_Fabrik, Dim_Materiale, Materiale,  LogNedBrutto, LogNedBruttoPae, NedskrNetto, LNType, LavNedPct, Vaerdi_GP Vaerdi_GP, Vaerdi_SP, beholdning Beholdning
		  from edw.ft_Nedskriv Where FraTil_Tid = (select replace(left(Vaerdi, 7), '-', '')										-- Rettelse 150319-1
													from [edw].[MD_Styringstabel] where parameter = 'PrimoPrimoDato') + '-'     -- Rettelse 150319-1
												 +(select replace(left(Vaerdi, 7), '-', '')										-- Rettelse 150319-1
													from [edw].[MD_Styringstabel] where parameter = 'PrimoDato')				-- Rettelse 150319-1
		  and substring(Dim_Fabrik, 1, 2) = '21') ly
		on cy.Dim_Fabrik = ly.Dim_Fabrik and cy.Materiale = ly.Materiale 

/*
Full outer join (select  Dim_Fabrik, Materiale from edw.ft_NySeneste3Aar 
				 where Dim_Tid = ( select replace(left(Vaerdi, 7), '-', '') 
				 from [edw].[MD_Styringstabel] where parameter = 'UltimoDato')) ft3
	on cy.Dim_Fabrik = ft3.Dim_Fabrik and cy.Materiale = ft3.Materiale 
*/
-- Ny join 150115-1 start for edw.ft_NySeneste3Aar, eksisterende medtages i stigende beholdninger
Full outer join (Select a.Dim_Fabrik, a.Materiale from edw.ft_NySeneste3Aar a					-- join-reference tilføjet 
				 Left join edw.Dim_Materiale b on a.Materiale = b.Materiale and b.Aktiv = 'J'	-- Join tilføjet 
				 where Dim_Tid = (select replace(left(Vaerdi, 7), '-', '') 
								  from [edw].[MD_Styringstabel] 
								  where parameter = 'UltimoDato') 
					and b.FTrDato <= (select Vaerdi												-- kriterie tilføjet 
									  from edw.MD_Styringstabel 
									  where Parameter = 'PrimoDato')) ft3
	on cy.Dim_Fabrik = ft3.Dim_Fabrik and cy.Materiale = ft3.Materiale 
-- Ny join 150115-1 slut

Full outer join dbo.[vw_kassation] kas
	on ly.Dim_Fabrik = kas.Dim_Fabrik and ly.Materiale = kas.Materiale -- 150318-1: Ændret join for kassation, så der joines på Materiale i stedet for Dim_Materiale
	where isnull(cy.Beholdning, 0) <> 0
--	and	ft3.Dim_Fabrik is null and ft3.Materiale is null										-- Subkriterie slettet 150115-1
) q1
Left join edw.Dim_Materiale e on q1.Materiale = e.Materiale and e.Aktiv = 'J'					-- join-reference tilføjet 150115-1
Where e.FTrDato !> (select Vaerdi from edw.MD_Styringstabel where Parameter = 'PrimoDato')		-- Subkriterie tilføjet 150115-1 (ikke større end)
	and (isnull(q1.Beholdning, 0) <> 0 
		or isnull(q1.AnskVaerdi, 0) <> 0 
		or isnull(q1.NedForPrinc, 0) <> 0
		or isnull(q1.NedskrNetto, 0) <> 0 
		or isnull(q1.Vaerdi_SP, 0) <> 0)

Group by q1.Dim_Materiale, q1.Dim_Fabrik, q1.Materiale, q1.LNType, q1.FLNType, q1.FraTil_tid