









Create view [dbo].[vw_KorrNyeMat36m]
-- Ajourført 141114-1: Ændret FraTil_Tid med en Cast, da det fyldte 8000...
-- Ajourført 141121-1: Ændret kriterie for ly-join til FraTil_Tid og rettet ly-periode med ny PrimoPrimoDato
-- Ajourført 150311-1: Ændret kriterie for NedForPrinC fra "Is null" til "Isnull = 0" nedskrivningsprocent på 0 medtages
-- Ajourført 150325-1: Ændret sub-query til at være select fra edw.FT_Nedskriv i stedet for fra dbo.vw_Nedskriv
as
Select q1.Dim_Materiale, q1.Dim_Fabrik, q1.Materiale, q1.LNType, q1.FLNType, q1.FraTil_tid, sum(q1.Beholdning) Beholdning, 
sum(q1.AnskVaerdi) AnskVaerdi, sum(q1.NedForPrinc) NedForPrinc, sum(q1.NedskrNetto) NedskrNetto, sum(q1.Vaerdi_SP) Vaerdi_SP
from (
select isnull(cy.Dim_Materiale, isnull(ly.Dim_Materiale, cy.Dim_Materiale)) Dim_Materiale, 
isnull(cy.Dim_Fabrik, isnull(ly.Dim_Fabrik, cy.Dim_Fabrik)) Dim_Fabrik, 
isnull(cy.Materiale, isnull(ly.Materiale, cy.Materiale)) Materiale, 
isnull(cy.LNType, 'AUB') LNType,
isnull(ly.LNType, 'AEPD') FLNType,
Cast(( select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'PrimoDato') 
	+ '-' +( select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'UltimoDato') 
	as Varchar (13)) as FraTil_tid,
Case	When	cy.Beholdning > 0 Then cy.Beholdning Else Null End	as Beholdning,
ly.LogNedBrutto nslyLogNedBr, cy.LogNedBrutto nscyLogNedBr,
Case When isnull(cy.Vaerdi_GP, 0)	>	0
     Then Case When	isnull(cy.beholdning, 0) > 0	
			   Then cy.Vaerdi_GP
		       Else null
			   End
	 Else null
	 End AnskVaerdi,
Case	When cy.Vaerdi_GP > 0	
		Then	Case	When isnull(cy.Beholdning, 0) > 0	
						Then	Case	When	isnull(cy.LitraNedskrPct, 0) = 0 -- Rettelse 150311-1
										Then	isnull(cy.NedKorrNytMatPae, 0)
										Else	null
								End
						Else Null
				End
		Else	Null
 End as NedForPrinC,
Case When isnull(cy.Vaerdi_GP, 0) > 0	
	 Then Case When	isnull(cy.Beholdning, 0) > 0	
			   Then isnull(cy.NedKorrNytMat, 0)
			   Else	Null
			   End
	 Else	Null
	 End as	NedskrNetto,
Case When cy.Vaerdi_SP > 0	
     Then Case When isnull(cy.Beholdning, 0) > 0	
				Then cy.Vaerdi_SP
				Else Null
				End
	 Else	Null
	 End Vaerdi_SP
from 
	(
	 Select Dim_Fabrik, Dim_Materiale, a.Materiale, Vaerdi_GP, Vaerdi_SP, Beholdning,
     LogNedBrutto, LogNedBruttoPae, NedKorrNytMat, NedKorrNytMatPae, NedskrNetto, LNType, LavNedPct, c.LitraNedskrPct
	 from edw.ft_Nedskriv a
	 Left join edw.Dim_Materiale b on a.Dim_Materiale = b.PK_ID
	 Left join edw.Dim_Litra c on b.Litra_PKID = c.PK_ID
     where a.FraTil_Tid = (select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'PrimoDato') + '-' 
			    		 +(select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'UltimoDato')
		and a.Dim_Materiale in (select distinct x.Dim_Materiale from edw.ft_NySeneste3Aar x
								where Dim_Tid = 
								(select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'UltimoDato'))
	 ) cy
full outer join
     (
      Select Dim_Fabrik, Dim_Materiale, Materiale,  Dim_Tid, Vaerdi_GP, Vaerdi_SP, beholdning Beholdning,
      LogNedBrutto, NedskrNetto, LNType, LavNedPct
      From edw.ft_Nedskriv
      Where FraTil_Tid = (select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'PrimoPrimoDato') + '-' 
						+(select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'PrimoDato')
		and Dim_Materiale in (select distinct Dim_Materiale from edw.ft_NySeneste3Aar 
								where Dim_Tid = 
								(select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'PrimoDato'))
      ) ly
	  on cy.Dim_Fabrik = ly.Dim_Fabrik and cy.Materiale = ly.Materiale
) q1
where
(isnull(q1.Beholdning, 0) <> 0 or isnull(q1.AnskVaerdi, 0) <> 0 or isnull(q1.NedForPrinc, 0) <> 0
or isnull(q1.NedskrNetto, 0) <> 0 or isnull(q1.Vaerdi_SP, 0) <> 0)

group by q1.Dim_Materiale, q1.Dim_Fabrik, q1.Materiale, q1.LNType, q1.FLNType, q1.FraTil_tid