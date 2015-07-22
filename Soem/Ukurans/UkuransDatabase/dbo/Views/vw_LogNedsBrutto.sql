



CREATE VIEW [dbo].[vw_LogNedsBrutto]
-- 141114-1: Ajourført FraTil_Tid med en Cast, da det fyldte 8000...
-- 141121-1: Ændret kriterie for ly-join til FraTil_Tid og rettet nsly-periode med ny PrimoPrimoDato
-- 150325-1: Ændret opslag fra indeværende periode fra view til facttabel af hensyn til at finde rette laveste nedskrivningstype
--			 (der pt. påsættes med procedure som efterbehandling)
AS
Select q1.Dim_Fabrik, q1.Materiale, q1.Dim_Materiale, isnull(q1.LNType, 'AUB') LNType, isnull(q1.FLNType, 'AEPD') FLNType
,q1.FraTil_tid, q1.AnskVaerdi,q1.NedForPrinc
,Case	when	q1.NedskrNetto <> 0 
			then	case	when	q1.NedForPrinc	<>	0 
							then	q1.NedskrNetto	-	q1.NedForPrinc
							else	q1.NedskrNetto
					end
			else	case	when	q1.NedForPrinc	<>	0
							then	q1.NedForPrinc * -1
							else	0
					end
 end as DSystAnedr
,q1.NedskrNetto, q1.Beholdning, q1.Vaerdi_SP
,case	when	q1.AnskVaerdi <> 0 
			then	case	when	q1.Vaerdi_SP	<>	0 
							then	q1.AnskVaerdi	-	q1.Vaerdi_SP
							else	q1.AnskVaerdi
					end
			else	case	when	q1.Vaerdi_SP	<>	0
							then	q1.Vaerdi_SP * -1
							else	Null
					end
 end as Forskel
From (select nscy.Dim_Fabrik, nscy.Materiale, nscy.Dim_Materiale, nscy.LNType, nsly.LNType as FLNType
	,Cast((select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'PrimoDato') + '-' 
    +(select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'UltimoDato') as varchar (13)) as FraTil_tid
	,nscy.Vaerdi_GP AnskVaerdi, nscy.LogNedBruttoPae NedForPrinc, nscy.Beholdning,nscy.LogNedBrutto NedskrNetto, nscy.Vaerdi_SP
	from (select Dim_Fabrik, Dim_Materiale, Materiale, LNType, FLNType, Beholdning, Vaerdi_GP, LogNedBrutto, LogNedBruttoPae, Vaerdi_SP 
		  from edw.FT_Nedskriv	 -- rettet 150325: nedskrivningstype er påsat ved efterbehandling efter view...
		  where FraTil_Tid = (select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'PrimoDato') + '-' 
							+(select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'UltimoDato')
		 ) nscy

	full outer join 
		 (select Dim_Fabrik, Dim_Materiale,  Materiale, beholdning, LogNedBruttoPae, LogNedBrutto, NedskrNetto, LNType, LavNedPct
		  from edw.ft_Nedskriv   -- rettet 141121: specifikation af hvilken beregning der er udgangspunkt er nødvendig, da der kan være flere
		  where FraTil_Tid = (select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'PrimoPrimoDato') + '-' 
							+(select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'PrimoDato')
		 ) nsly
	on nscy.Dim_Fabrik = nsly.Dim_Fabrik and nscy.Materiale = nsly.Materiale
	) q1
Where q1.Dim_Fabrik is not null and  q1.Dim_Materiale is not null