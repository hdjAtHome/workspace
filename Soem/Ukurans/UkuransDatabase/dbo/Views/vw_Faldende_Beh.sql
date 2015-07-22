






CREATE view [dbo].[vw_Faldende_Beh]
-- Ajourført 141112-1: Indarbejdet fradrag for kasserede materialer, der ikke skal medtages under faldende beholdninger
-- Ajourført 141113-1: Justeret formler for Nedskrivning netto mv.
-- Ajourført 141114-1: Ændret FraTil_Tid med en Cast, da det fyldte 8000... 
-- Ajourført 141121-1: Ændret kriterie for ly-join til FraTil_Tid og rettet ly-periode med ny PrimoPrimoDato
-- Ajourført 141124-1: Ændret NedskrNetto til at blive beregnet ud fra LogNedBrutto
-- Ajourført 150306-1: Indarbejdet nye cases så faldende beholdning ikke går i positiv når der er kasseret ...
-- Ajourført 150318-1: Ændret join for kassation, så der joines på Materiale i stedet for Dim_Materiale
as
Select q1.Dim_Fabrik, q1.Dim_Materiale, q1.Materiale, q1.LNType, q1.FLNType, q1.FraTil_tid, sum(q1.Beholdning) Beholdning, 
sum(q1.AnskVaerdi) AnskVaerdi, sum(q1.NedForPrinc) NedForPrinc, sum(q1.NedskrNetto) NedskrNetto, sum(q1.Vaerdi_SP) Vaerdi_SP


from (
select  isnull(cy.Dim_Fabrik, isnull(ly.Dim_Fabrik, cy.Dim_Fabrik)) Dim_Fabrik, 
 isnull(cy.Dim_Materiale, isnull(ly.Dim_Materiale, cy.Dim_Materiale)) Dim_Materiale,
isnull(cy.Materiale, isnull(ly.Materiale, cy.Materiale)) Materiale,
isnull(cy.LNType, 'AUB') as LNType,
isnull(ly.LNType, 'AEPD') as FLNType,

Cast(( select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'PrimoDato') 
	+ '-' +( select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'UltimoDato') 
	as Varchar (13)) as FraTil_tid,

Case When isnull(ly.Beholdning, 0) > 0																				-- Ja
	 Then Case When	isnull(ly.Beholdning, 0) > isnull(cy.Beholdning, 0)												-- Ja
			   Then Case When isnull(cy.Beholdning, 0) = 0															-- Nej		
						Then Case When	kas.Beholdning	is null	
								   Then (isnull(ly.Beholdning, 0) * -1)
								   Else	(isnull(ly.Beholdning, 0) * -1) - kas.Beholdning
								   End
						Else Case When kas.Beholdning	is null														-- Nej
								   Then	isnull(cy.Beholdning, 0) -ly.Beholdning
								   Else		case	when (isnull(cy.Beholdning, 0) -ly.Beholdning - kas.Beholdning) > 0 			-- 8 - 15 + 12 = +5
													then 0
													else (isnull(cy.Beholdning, 0) -ly.Beholdning - kas.Beholdning)		
											end							 
							 End
					End
				Else	0
			End
	Else 0
End as Beholdning,

Case When isnull(ly.Beholdning, 0) > 0	
	 Then Case When isnull(ly.Vaerdi_GP, 0) > 0	
			   Then Case When isnull(ly.Beholdning, 0) > isnull(cy.Beholdning, 0)
						 Then Case When isnull(cy.Beholdning, 0) = 0	
								   Then Case When kas.AnskVaerdi is null
											 Then (isnull(ly.Vaerdi_GP, 0) * -1) 
											 Else (isnull(ly.Vaerdi_GP, 0) * -1)  - kas.AnskVaerdi
											 End
								   Else Case When kas.AnskVaerdi is null
											Then	(((isnull(ly.Vaerdi_GP, 0) * -1)/isnull(ly.Beholdning, 0))*(isnull(ly.Beholdning, 0) 
													- isnull(cy.Beholdning, 0)))
											 Else	case	when (isnull(cy.Beholdning, 0) -ly.Beholdning - kas.Beholdning) > 0 			-- 8 - 15 + 12 = +5
															then 0
															else ((isnull(ly.Vaerdi_GP, 0) * -1)/isnull(ly.Beholdning, 0))*(isnull(ly.Beholdning, 0)
															-isnull(cy.Beholdning, 0) - isnull( - kas.Beholdning, 0)) 
													end							 
								End
					  End
				 Else	0	
		 End
				Else	0
End
		Else 0
		End as AnskVaerdi,
Case When ly.Beholdning > 0	
	 Then Case When	isnull(ly.LogNedBrutto, 0) < 0	
			   Then Case When isnull(ly.Beholdning, 0) > isnull(cy.Beholdning, 0)	
						 Then Case When isnull(cy.Beholdning, 0) = 0	
								   Then Case When kas.AnskVaerdi is null
											 Then (isnull(ly.LogNedBrutto, 0) * -1) 
											 Else (isnull(ly.LogNedBrutto, 0) * -1) - kas.NedForPrinc
											 End
								   Else Case When kas.AnskVaerdi is null
											 Then (((isnull(ly.LogNedBrutto, 0) * -1) /isnull(ly.Beholdning, 0))*(isnull(ly.Beholdning, 0)-isnull(cy.Beholdning, 0)))---isnull(kas.NedskrNetto, 0)
											 Else case	when (isnull(cy.Beholdning, 0) -ly.Beholdning - kas.Beholdning) > 0 			-- 8 - 15 + 12 = +5
														then 0
														else ((isnull(ly.LogNedBrutto, 0) * -1) /isnull(ly.Beholdning, 0))*(isnull(ly.Beholdning, 0)
														-isnull(cy.Beholdning, 0) - isnull( - kas.Beholdning, 0))
													end
										End
								end		
						  Else	0
						  End
				Else 0	
				End
	  Else 0
End as NedForPrinc,
Case When isnull(ly.Beholdning, 0) >	0	
	 Then Case When isnull(ly.LogNedBrutto, 0) <	0	
			   Then Case When isnull(ly.Beholdning, 0) > isnull(cy.Beholdning, 0)
						 Then Case When	isnull(cy.Beholdning, 0) =	0	
								   Then Case When kas.AnskVaerdi is null
											 Then (isnull(ly.LogNedBrutto, 0) * -1) 
											 Else (isnull(ly.LogNedBrutto, 0) * -1) - kas.NedskrNetto
											 End
								   Else Case When kas.AnskVaerdi is null
											Then  (((isnull(ly.LogNedBrutto, 0) * -1)/isnull(ly.Beholdning, 0))*(isnull(ly.Beholdning, 0) - isnull(cy.Beholdning, 0)))
											Else	case	when (isnull(cy.Beholdning, 0) -ly.Beholdning - kas.Beholdning) > 0 			-- 8 - 15 + 12 = +5
															then 0
															else ((isnull(ly.LogNedBrutto, 0) * -1)/isnull(ly.Beholdning, 0))*(isnull(ly.Beholdning, 0)
																-isnull(cy.Beholdning, 0) - isnull( - kas.Beholdning, 0))
													end
											End		
								   End
						 Else	0
						 End
				Else	0
				End
	 Else 0
	 End as	NedskrNetto,
Case When isnull(ly.Beholdning, 0) > 0	
	  Then Case When ly.Vaerdi_SP > 0	
				Then Case When isnull(ly.Beholdning, 0) > isnull(cy.Beholdning, 0)
						  Then Case When isnull(cy.Beholdning, 0) =	0	
								   Then Case When kas.AnskVaerdi is null
											 Then (isnull(ly.Vaerdi_SP, 0) * -1) 
											 Else (isnull(ly.Vaerdi_SP, 0) * -1) - kas.Vaerdi_SP
											 End
								   Else Case When kas.AnskVaerdi is null
											Then	(((isnull(ly.Vaerdi_SP, 0) * -1)/isnull(ly.Beholdning, 0))*(isnull(ly.Beholdning, 0) - isnull(cy.Beholdning, 0)))
											 Else	case	when (isnull(cy.Beholdning, 0) -ly.Beholdning - kas.Beholdning) > 0 			-- 8 - 15 + 12 = +5
															then 0
															else ((isnull(ly.Vaerdi_SP, 0) * -1)/isnull(ly.Beholdning, 0))*(isnull(ly.Beholdning, 0)
															-isnull(cy.Beholdning, 0) - isnull( - kas.Beholdning, 0))
													end
												End
								   End
   						  Else	0
						  End
				Else	0
				End
	  Else 0
	  End as Vaerdi_SP

from (select Dim_Fabrik, Dim_Materiale, Materiale, LogNedBrutto, NedskrNetto, LNType, LavNedPct,
			 Vaerdi_GP as Vaerdi_GP, beholdning as Beholdning, Vaerdi_SP
      from edw.ft_Nedskriv Where FraTil_Tid = (select replace(left(Vaerdi, 7), '-', '') 
													from [edw].[MD_Styringstabel] where parameter = 'PrimoPrimoDato') + '-' 
											 +(select replace(left(Vaerdi, 7), '-', '') 
													from [edw].[MD_Styringstabel] where parameter = 'PrimoDato')
      and substring(Dim_Fabrik, 1, 2) = '21') ly

full outer join
(select Dim_Fabrik, Dim_Materiale, Materiale, LogNedBrutto, NedskrNetto, LNType, LavNedPct,
			 Vaerdi_GP, Vaerdi_SP, Beholdning
      from dbo.vw_Nedskriv
      where substring(Dim_Fabrik, 1, 2) = '21') cy
on ly.Dim_Fabrik = cy.Dim_Fabrik and ly.Materiale = cy.Materiale
full outer join dbo.[vw_kassation] kas
on ly.Dim_Fabrik = kas.Dim_Fabrik and ly.Materiale = kas.Materiale -- 150318-1: Ændret join for kassation, så der joines på Materiale i stedet for Dim_Materiale

) q1
where  
 (isnull(q1.Beholdning, 0) <> 0 or isnull(q1.NedForPrinc, 0) <> 0
or isnull(q1.NedskrNetto, 0) <> 0 or isnull(q1.Vaerdi_SP, 0) <> 0 
 )

group by q1.Dim_Fabrik, q1.Dim_Materiale, q1.Materiale, q1.LNType, q1.FLNType, q1.FraTil_tid