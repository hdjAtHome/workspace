

CREATE view [dbo].[vw_Nedskriv_Primo_Netto]
-- Ajourført 141002-1: Tilføjet ultimoværdier for LNType og FLNType på overførte værdier fra primo periode
-- Ajourført 141013-1: Rettet kriterier i ultimo-sub-query, så det er FraTil_Tid, der er kriterium
-- Ajourført 141114-1: Ændret FraTil_Tid med en Cast, da det fyldte 8000...
-- Ajourført 141121-1: Ændret kriterie for ly-join til FraTil_Tid og rettet ly-periode med ny PrimoPrimoDato
-- Ajourført 150320-1: Ændret ultimo periodes FraTil_Tid-kriterie 
as

Select primo.Dim_Fabrik, primo.Dim_Materiale, primo.Materiale, isnull(ultimo.LNType, 'AUB') as LNType, primo.LNType as FLNType
,primo.FraTil_tid, primo.Beholdning, Primo.AnskVaerdi, Primo.NedForPrinc, Primo.NedskrNetto, Primo.Vaerdi_SP
From
	(Select Dim_Fabrik, Dim_Materiale, Materiale, LNType, FLNType
	,Cast((select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'PrimoDato') + '-' 
		+(select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'UltimoDato') 
		as Varchar (13)) as FraTil_tid
	,sum(Beholdning) as Beholdning, sum(Vaerdi_GP) as AnskVaerdi, sum(NedskrNetto)  as NedForPrinc
	,sum(NedskrNetto)  as NedskrNetto, sum(Vaerdi_SP) as Vaerdi_SP
	from edw.FT_Nedskriv
	where FraTil_Tid = (select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'PrimoPrimoDato') + '-' 	
						  +(select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'PrimoDato')
		and (isnull(Vaerdi_GP, 0) <> 0 or isnull(Vaerdi_SP, 0) <> 0 or isnull(LogNedBrutto, 0) <> 0 
	or isnull(LogNedBrutto, 0) <> 0 or isnull(Beholdning, 0) <> 0)
	group by Dim_fabrik, Dim_materiale, materiale, LNType, FLNType
) primo
left join 
	(select Dim_Fabrik, Materiale, LNType, FLNType
		from edw.FT_Nedskriv
		where FraTil_Tid = (select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'PrimoDato') + '-' 
						  +(select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'UltimoDato')
		group by Dim_fabrik, Dim_materiale, materiale, LNType, FLNType
	) ultimo
	on primo.Dim_Fabrik = ultimo.Dim_Fabrik and primo.Materiale = ultimo.Materiale