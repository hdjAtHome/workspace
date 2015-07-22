





CREATE view [dbo].[vw_UltBeh_Indk12md]
-- 141114-1: Ajourført FraTil_Tid med en Cast, da det fyldte 8000...
-- 141121-1: Ajourført kriterie for ly-join til FraTil_Tid og rettet ly-periode med ny PrimoPrimoDato
-- 150309-1: Ajourført kriterie for dl.LitraNedskrProcent i subquery fra edw.FT_Indk12md så 0 medtages
-- 150311-1: Ændret så NedForPrinC henter NedKorrIndkPae fra FT_Nedskriv - ikke nuværende NedKorrIndk...
as

Select q1.Dim_Materiale
,q1.Dim_Fabrik
,q1.Materiale
,q1.LNType
,q1.FLNType
,q1.FraTil_tid
,sum(q1.Beholdning) as Beholdning
,sum(q1.AnskVaerdi) as AnskVaerdi
,sum(q1.NedForPrinc) as NedForPrinc
,sum(q1.NedskrNetto) as NedskrNetto
,sum(q1.Vaerdi_SP) as Vaerdi_SP 
from 
(select fti.Dim_Materiale
,fti.Dim_Fabrik
,fti.Materiale
,isnull(cy.LNType, 'AUB') as LNType
,isnull(ly.LNType, 'AEPD') as FLNType
,Cast((select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'PrimoDato') + '-' 
	  +( select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'UltimoDato') 
	  as Varchar (13)) as FraTil_tid
,Case	When	cy.Beholdning	>		0	
		Then	cy.Beholdning
		Else	Null
 End	as Beholdning
,Case	When cy.Vaerdi_GP > 0
		Then Case When	cy.Beholdning > 0	
			   Then	fti.UltBehIndk12mdVd
			   Else	Null
			   End
		Else	Null
 End	as AnskVaerdi
,Case	When cy.Vaerdi_GP > 0	
		Then Case When cy.Beholdning >	 0	
				   Then	cy.NedKorrIndkPae -- Rettelse 150311-1: Henter forrige princip fra FT_Nedskriv - ikke nuværende...
				   Else	0
				End
		Else	0
 End	as	NedForPrinC
,Case When cy.Vaerdi_GP > 0	
      Then Case When cy.Beholdning > 0	
			   Then cy.NedKorrIndk
			   Else	0
			   End
	 Else	0
 End as NedskrNetto
,Case When cy.Vaerdi_SP > 0	and isnull(cy.Beholdning, 0) > 0
      Then	isnull(cy.Vaerdi_SP, 0) / isnull(cy.Beholdning, 0) * isnull(cy.UltBehIndk12mdMgd, 0) 
	  Else	0
 End	as	Vaerdi_SP

From (Select ft.Dim_Fabrik, ft.Materiale, ft.Dim_Materiale, BrutIndk12mdMgd, UltBehIndk12mdVd 
		from edw.FT_Indk12md ft
		Left join edw.Dim_Materiale dm on ft.Dim_Materiale = dm.PK_ID
		Left join edw.Dim_Litra dl on dm.Litra_PKID = dl.PK_ID
		where Dim_Tid = (select replace(left(Vaerdi, 7), '-', '') 
						from [edw].[MD_Styringstabel] 
						where parameter = 'UltimoDato')
			  and isnull(dl.LitraNedskrPct,0) = 0) fti

Left join (select Dim_Fabrik, Dim_Materiale, Materiale, Vaerdi_GP, Vaerdi_SP, Beholdning,
			LogNedBrutto, LogNedBruttoPae, UltBehIndk12mdMgd, NedKorrIndk, NedKorrIndkPae, LNType, FLNType
		   from dbo.vw_Nedskriv where substring(Dim_Fabrik, 1, 2) = '21'
	) cy 
	on fti.Dim_Fabrik = cy.Dim_Fabrik and fti.Materiale = cy.Materiale 

Left join (select Dim_Fabrik, Dim_Materiale, Materiale, LNType 
           from edw.FT_Nedskriv 
           where FraTil_Tid = (select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'PrimoPrimoDato') + '-' 
							+(select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'PrimoDato')
    ) ly
    on cy.Dim_Fabrik = ly.Dim_Fabrik and cy.Materiale = ly.Materiale 

	) q1

Where  isnull(q1.Beholdning, 0) <> 0 
	or isnull(q1.AnskVaerdi, 0) <> 0 
	or isnull(q1.NedForPrinc, 0) <> 0
	or isnull(q1.NedskrNetto, 0) <> 0 
	or isnull(q1.Vaerdi_SP, 0) <> 0

Group by q1.Dim_Materiale, q1.Dim_Fabrik, q1.Materiale, q1.LNType, q1.FLNType, q1.FraTil_tid