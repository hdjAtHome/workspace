CREATE view [dbo].[vw_Nedskriv_Prg] 
as

select 
vwnp.Dim_Fabrik, vwnp.Dim_Materiale, vwnp.Materiale, vwnp.FraTil_Tid, round(vwnp.Beholdning, 18, 3) Beholdning, round(vwnp.Vaerdi_GP, 18, 3) Vaerdi_GP,
round(vwnp.GlidGnsPris, 18, 3) GlidGnsPris, round(vwnp.Vaerdi_SP, 18, 3) Vaerdi_SP, vwnp.DUF_DagtilProg, round(vwnp.ProgNedskrPct, 8, 7) ProgNedskrPct
,Case when isnull(vwnp.Vaerdi_GP, 0) <> 0 then round(vwnp.Vaerdi_GP * vwnp.ProgNedskrPct, 10, 7) else null end as [ProgNedVaerdi] 
,Case When Isnull(vwns.StatusNedskrPct, 0) = 0
	  Then	Case	When	Isnull(vwnp.ProgNedskrPct, 0)	= 0
					Then	Case	When	Isnull(vwnr.RaekkeNedskrPct, 0) = 0
							Then	Case	When	vwnl.LitraNedskrPct	<	0
									Then	'Litr'
									Else	'Uned'
								End
							Else	Case	When	vwnl.LitraNedskrPct	<	vwnr.RaekkeNedskrPct
									Then	'Litr'
									Else	'Rækk'
								End
						End
					Else	Case	When	Isnull(vwnr.RaekkeNedskrPct, 0) = 0
							Then	Case	When	vwnl.LitraNedskrPct	<	vwnp.ProgNedskrPct
									Then	'Litr'
									Else	'Lang'
								End
							Else	Case	When	vwnl.LitraNedskrPct	<	vwnr.RaekkeNedskrPct
									Then	'Litr'
									Else	'Rækk'
								End
						End
				End				
			Else	Case	When	Isnull(vwnp.ProgNedskrPct, 0)	= 0
					Then	Case	When	vwns.StatusNedskrPct		<	vwnr.RaekkeNedskrPct
							Then	Case	When	vwnl.LitraNedskrPct	<	vwns.StatusNedskrPct
									Then	'Litr'
									Else	'Stat'
								End
							Else	Case	When	vwnl.LitraNedskrPct	<	vwnr.RaekkeNedskrPct
									Then	'Litr'
									Else	'Rækk'
								End
						End
					Else	Case	When	vwns.StatusNedskrPct		<	vwnp.ProgNedskrPct
							Then	Case	When	vwnl.LitraNedskrPct	<	vwns.StatusNedskrPct
									Then	'Litr'
									Else	'Stat'
								End	
							Else	Case	When	vwnl.LitraNedskrPct	<	vwnp.ProgNedskrPct
									Then	'Litr'
									Else	'Lang'
								End
						End	
				End
End	As [LNType]
,round(Case		When	Isnull(vwns.StatusNedskrPct, 0) = 0
			Then	Case	When	Isnull(vwnp.ProgNedskrPct, 0)	= 0
							Then	Case	When	Isnull(vwnr.RaekkeNedskrPct, 0) = 0
											Then	Case	When	vwnl.LitraNedskrPct	<	0
															Then	vwnl.LitraNedskrPct * vwnp.Vaerdi_GP
															Else	0
													End
											Else	Case	When	vwnl.LitraNedskrPct	<	vwnr.RaekkeNedskrPct
															Then	vwnl.LitraNedskrPct * vwnp.Vaerdi_GP
															Else	vwnr.RaekkeNedskrPct * vwnp.Vaerdi_GP
													End
									End
							
							Else	Case	When	Isnull(vwnr.RaekkeNedskrPct, 0) = 0
											Then	Case	When	vwnl.LitraNedskrPct	<	vwnp.ProgNedskrPct
															Then	vwnl.LitraNedskrPct * vwnp.Vaerdi_GP
															Else	vwnp.ProgNedskrPct * vwnp.Vaerdi_GP
													End
											Else	Case	When	vwnl.LitraNedskrPct	<	vwnr.RaekkeNedskrPct
															Then	vwnl.LitraNedskrPct * vwnp.Vaerdi_GP
															Else	vwnr.RaekkeNedskrPct * vwnp.Vaerdi_GP
													End
									End
					End				
			Else	Case	When	Isnull(vwnp.ProgNedskrPct, 0)	= 0
							Then	Case	When	vwns.StatusNedskrPct		<	vwnr.RaekkeNedskrPct
											Then	Case	When	vwnl.LitraNedskrPct	<	vwns.StatusNedskrPct
															Then	vwnl.LitraNedskrPct * vwnp.Vaerdi_GP
															Else	vwns.StatusNedskrPct * vwnp.Vaerdi_GP
													End
											Else	Case	When	vwnl.LitraNedskrPct	<	vwnr.RaekkeNedskrPct
															Then	vwnl.LitraNedskrPct * vwnp.Vaerdi_GP
															Else	vwnr.RaekkeNedskrPct * vwnp.Vaerdi_GP
													End
									End
							Else	Case	When	vwns.StatusNedskrPct		<	vwnp.ProgNedskrPct
											Then	Case	When	vwnl.LitraNedskrPct	<	vwns.StatusNedskrPct
															Then	vwnl.LitraNedskrPct * vwnp.Vaerdi_GP
															Else	vwns.StatusNedskrPct * vwnp.Vaerdi_GP
													End	
											Else	Case	When	vwnl.LitraNedskrPct	<	vwnp.ProgNedskrPct
															Then	vwnl.LitraNedskrPct * vwnp.Vaerdi_GP
															Else	vwnp.ProgNedskrPct * vwnp.Vaerdi_GP
													End
									End	
					End			
	End, 18, 3)	As [LogNedBrutto]
,round(-Case	When	Isnull(vwnp.ProgNedskrPct, 0)	= 0
				Then	Case	When	Isnull(vwnr.RaekkeNedskrPct, 0) = 0
								Then	Case	When	vwnl.LitraNedskrPct	<	0
												Then	vwnl.LitraNedskrPct * vwnp.Vaerdi_GP
												Else	0
										End
								Else	Case	When	vwnl.LitraNedskrPct	<	vwnr.RaekkeNedskrPct
												Then	vwnl.LitraNedskrPct * vwnp.Vaerdi_GP
												Else	vwnr.RaekkeNedskrPct * vwnp.Vaerdi_GP
										End
						End
								
				Else	Case	When	Isnull(vwnr.RaekkeNedskrPct, 0) = 0
								Then	Case	When	vwnl.LitraNedskrPct	<	vwnp.ProgNedskrPct
												Then	vwnl.LitraNedskrPct * vwnp.Vaerdi_GP
												Else	vwnp.ProgNedskrPct * vwnp.Vaerdi_GP
										End
								Else	Case	When	vwnl.LitraNedskrPct	<	vwnr.RaekkeNedskrPct
												Then	vwnl.LitraNedskrPct * vwnp.Vaerdi_GP
												Else	vwnr.RaekkeNedskrPct * vwnp.Vaerdi_GP
										End
						End
		End				
		+
Case		When	Isnull(vwns.StatusNedskrPct, 0) = 0
				Then	Case	When	Isnull(vwnp.ProgNedskrPct, 0)	= 0
								Then	Case	When	Isnull(vwnr.RaekkeNedskrPct, 0) = 0
												Then	Case	When	vwnl.LitraNedskrPct	<	0
																Then	vwnl.LitraNedskrPct * vwnp.Vaerdi_GP
																Else	0
														End
												Else	Case	When	vwnl.LitraNedskrPct	<	vwnr.RaekkeNedskrPct
																Then	vwnl.LitraNedskrPct * vwnp.Vaerdi_GP
																Else	vwnr.RaekkeNedskrPct * vwnp.Vaerdi_GP
														End
										End
								
								Else	Case	When	Isnull(vwnr.RaekkeNedskrPct, 0) = 0
												Then	Case	When	vwnl.LitraNedskrPct	<	vwnp.ProgNedskrPct
																Then	vwnl.LitraNedskrPct * vwnp.Vaerdi_GP
																Else	vwnp.ProgNedskrPct * vwnp.Vaerdi_GP
														End
												Else	Case	When	vwnl.LitraNedskrPct	<	vwnr.RaekkeNedskrPct
																Then	vwnl.LitraNedskrPct * vwnp.Vaerdi_GP
																Else	vwnr.RaekkeNedskrPct * vwnp.Vaerdi_GP
														End
										End
						End				
				Else	Case	When	Isnull(vwnp.ProgNedskrPct, 0)	= 0
								Then	Case	When	vwns.StatusNedskrPct		<	vwnr.RaekkeNedskrPct
												Then	Case	When	vwnl.LitraNedskrPct	<	vwns.StatusNedskrPct
																Then	vwnl.LitraNedskrPct * vwnp.Vaerdi_GP
																Else	vwns.StatusNedskrPct * vwnp.Vaerdi_GP
														End
												Else	Case	When	vwnl.LitraNedskrPct	<	vwnr.RaekkeNedskrPct
																Then	vwnl.LitraNedskrPct * vwnp.Vaerdi_GP
																Else	vwnr.RaekkeNedskrPct * vwnp.Vaerdi_GP
														End
										End
								Else	Case	When	vwns.StatusNedskrPct		<	vwnp.ProgNedskrPct
												Then	Case	When	vwnl.LitraNedskrPct	<	vwns.StatusNedskrPct
																Then	vwnl.LitraNedskrPct * vwnp.Vaerdi_GP
																Else	vwns.StatusNedskrPct * vwnp.Vaerdi_GP
														End	
												Else	Case	When	vwnl.LitraNedskrPct	<	vwnp.ProgNedskrPct
																Then	vwnl.LitraNedskrPct * vwnp.Vaerdi_GP
																Else	vwnp.ProgNedskrPct * vwnp.Vaerdi_GP
														End
										End	
						End			
		End, 18, 3)
As [StatProgNedReelt]
from dbo.vw_NedskrSfaDUFProg vwnp
left join dbo.vw_NedskrSfaStat vwns
on vwnp.Dim_Materiale = vwns.Dim_Materiale
--left join dbo.vw_NedskrSfaDUFProg vwnd
--on vwnp.Dim_Materiale = vwnd.Dim_Materiale
left join dbo.vw_NedskrSfaLitra vwnl
on vwnp.Dim_Materiale = vwnl.Dim_Materiale
left join dbo.vw_NedskrSfaRID vwnr
on vwnp.Dim_Materiale = vwnr.Dim_Materiale