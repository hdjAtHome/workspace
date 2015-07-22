
CREATE VIEW [dbo].[vw_LogNedsBrutto_Prg]

AS
select q1.Dim_Fabrik, q1.Materiale, q1.Dim_Materiale, 
isnull(q1.LNType, 'AUB') LNType, 
q1.FraTil_tid, q1.AnskVaerdi,
case when q1.NedskrNetto = 0 
	 then 0 
	 else case when isnull(NedForPrinc, -1) = -1 
			   then q1.NedskrNetto
			   else q1.NedForPrinc
			   end
	 end NedForPrinc,
/*Case When q1.NedskrNetto <> 0 
	 Then Case When q1.NedForPrinc	<>	0 
			   Then	q1.NedskrNetto	-	q1.NedForPrinc
			   Else	q1.NedskrNetto
			   End
	 Else Case When	q1.NedForPrinc	<>	0
			   Then	q1.NedForPrinc * -1
			   Else	0
			   End
	 End DSystAnedr,*/
Case When q1.NedForPrinc <>	0
     then q1.NedForPrinc * -1
     else isnull(q1.NedskrNetto, 0) - isnull(q1.NedForPrinc, 0) 
     end DSystAnedr,
q1.NedskrNetto, q1.Beholdning, q1.Vaerdi_SP, 
	Case	When	q1.AnskVaerdi <> 0 
			Then	Case	When	q1.Vaerdi_SP	<>	0 
							Then	q1.AnskVaerdi	-	q1.Vaerdi_SP
							Else	q1.AnskVaerdi
					End
			Else	Case	When	q1.Vaerdi_SP	<>	0
							Then	q1.Vaerdi_SP * -1
							Else	Null
					End
	End Forskel
from (
select nspp.Dim_Fabrik, nspp.Materiale, nspp.Dim_Materiale, nspp.LNType,
( select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'UltimoDato') + '-' +( select replace(left(vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'PrognBeregDato') FraTil_tid,
nspp.Vaerdi_GP AnskVaerdi, nsbp.LogNedBrutto NedskrNetto, nspp.Beholdning,
nspp.LogNedBrutto NedForPrinc, nspp.Vaerdi_SP
from (select Dim_Fabrik, Dim_Materiale, Materiale, LNType, Beholdning, Vaerdi_GP, LogNedBrutto, Vaerdi_SP 
	  from dbo.vw_Nedskriv_Prg) nspp --(cy)
full outer join 
     (select Dim_Fabrik, Dim_Materiale, Materiale, Beholdning, Vaerdi_GP, LogNedBrutto, Vaerdi_SP 
	  from dbo.vw_Nedskriv) nsbp --(ly)
on nspp.Dim_Fabrik = nsbp.Dim_Fabrik and nspp.Dim_Materiale = nsbp.Dim_Materiale
) q1
where q1.Dim_Fabrik is not null and  q1.Dim_Materiale is not null