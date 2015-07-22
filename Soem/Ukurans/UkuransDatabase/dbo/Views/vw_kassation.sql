






CREATE view [dbo].[vw_kassation]
-- Ajourført 141113-1: NedskrNetto
-- Ajourført 141114-1: Ændret FraTil_Tid med en Cast, da det fyldte 8000...
-- Ajourført 141114-2: Indsat case for Beholdning, så der maks er kasseret sidste års beholdning
-- Ajourført 141124-1: NedForPrinC rettet så det er LogNedBrutto, der beregnes ud fra
-- Ajourført 141124-2: Ændret NedskrNetto til at blive beregnet ud fra LogNedBrutto
-- Ajourført 150318-1: Ændret Dim_Materiale til at aktuel PK_ID uanset hvornår kassation fysisk er sket (da kass. kan ske på flere end 2 i perioden)
-- Ajourført 150318-2: Forrige ændring medfører alle kassationer opgøres. Ændret kriterie ved beholdning så det undersøges, om der har været primo-beholdning
-- Ajourført 150324-1: Indsat LNType og FLNType, AUB såfremt de ikke var til stede i forrige periode
-- Ajourført 150324-2: Indsat ekstra kriterie for at undgå materialer, der ganske vist har kassation, men som ikke havde og ikke har beholdning eller værdi nu.
as
Select kas.Dim_Fabrik, a.PK_ID as Dim_Materiale, kas.Materiale
,Isnull(cp.LNType, 'AUB') as LNType, isnull(lp.LNType, 'AUB') as FLNType  -- Rettet 150324-1:
,kas.FraTil_tid
-- Ny case indsat 141114-2
,Case	when lp.Beholdning	> 0	and	lp.Vaerdi_GP > 0 -- 150318-2: Ændret kriterie så det undersøges, om der har været primo-beholdning af værdi
		then	case	when kas.Maengde < lp.Beholdning * -1
						then -lp.Beholdning
						else kas.Maengde
				end 
		else	0
end as Beholdning
, lp.Vaerdi_GP as Lp_Vaerdi_GP, lp.Beholdning as Lp_Beholdning,
Case When lp.Beholdning	> 0	and	lp.Vaerdi_GP > 0
	 Then case When	lp.Beholdning > kas.Maengde * -1
	 		   Then	kas.Maengde	* lp.Vaerdi_GP / lp.Beholdning
			   Else	lp.Vaerdi_GP * -1
	 		   End
	 Else 0
	 End as AnskVaerdi,
Case When kas.Maengde < 0	
	 Then Case When lp.Beholdning > 0 and lp.LogNedBrutto < 0
			   Then case When lp.Beholdning > kas.Maengde * -1
						 Then (kas.Maengde * -1) * (lp.LogNedBrutto * -1)	/ lp.Beholdning
						 Else lp.LogNedBrutto * -1
						 End
			   Else 0
			   End
	Else 0
	End as NedForPrinC,
Case When lp.Beholdning > 0 and lp.LogNedBrutto < 0
	 Then case When lp.Beholdning > kas.Maengde * -1	
			   Then	(kas.Maengde * -1) * (lp.LogNedBrutto * -1) / lp.Beholdning
			   Else	lp.LogNedBrutto * -1
			   End
	 Else 0
	 End NedskrNetto,
Case When kas.Maengde < 0 
	 Then Case When lp.Beholdning > 0 and lp.Vaerdi_SP	>	0	
			   Then case When lp.Beholdning >kas.Maengde * -1	
						 Then kas.Maengde * lp.Vaerdi_SP / lp.Beholdning
						 Else lp.Vaerdi_SP * -1
						 End
			   Else 0
			   End
	 Else 0
	 End Vaerdi_SP
From dbo.vw_Kasseret kas
left join
(select Dim_Fabrik, Dim_Materiale, Materiale, LNType, Vaerdi_GP, Beholdning, Vaerdi_SP, LogNedBrutto, NedskrNetto
      from edw.ft_Nedskriv where FraTil_Tid = (select replace(left(Vaerdi, 7), '-', '') -- Rettet 150324-2 for at få FLNType
													from [edw].[MD_Styringstabel] where parameter = 'PrimoPrimoDato') + '-' 
											 +(select replace(left(Vaerdi, 7), '-', '') 
													from [edw].[MD_Styringstabel] where parameter = 'PrimoDato')
      and substring(Dim_Fabrik, 1, 2) = '21') lp
on kas.Dim_Fabrik = lp.Dim_Fabrik and kas.Materiale = lp.Materiale 
left join 
(select Dim_Fabrik, Dim_Materiale, Materiale, Vaerdi_GP, Beholdning, Vaerdi_SP, LogNedBrutto, LogNedBruttoPae, NedskrNetto, LNType, LavNedPct
      from dbo.vw_Nedskriv  
      where substring(Dim_Fabrik, 1, 2) = '21') cp
on kas.Dim_Fabrik = cp.Dim_Fabrik and kas.Materiale = cp.Materiale 
left join edw.Dim_Materiale a on kas.Materiale = a.Materiale and a.Aktiv = 'J' -- Rettelse 150318-1: altid aktuel PK_ID uanset hvornår kassation fysisk er sket
Where isnull(kas.Maengde, 0) < 0
	and lp.Beholdning	> 0	and	lp.Vaerdi_GP > 0 -- For at undgå materialer, der ganske vist har kassation, men som ikke havde og ikke har beholdning eller værdi nu.