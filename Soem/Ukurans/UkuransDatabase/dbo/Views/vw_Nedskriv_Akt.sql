



CREATE view [dbo].[vw_Nedskriv_Akt] 
-- Ajourført 141222-1: Midlertidigt indsat kriterie for at der ikke korrigeres ved IC4, denne linie er indsat 3 steder
-- Ajourført 150310-1: Ændret join til FT_Indk12md til at være på ultimo måned samt ændret 'is null' til 'isnull = 0' (da IC4 nu er 0%)
-- Ajourført 150330-1: Rettet tidligere indsat kriterie for at der alligevel skal korrigeres ved IC4, når gamle regnskaber genberegnes
as
select 
ftb.Dim_Fabrik, ftb.Dim_Materiale, ftb.Materiale, ftb.Beholdning,
ftb.Vaerdi_GP, ftb.GlidGnsPris, vwnl.LitraGr2
      ,Case		When	Isnull(vwns.StatusNedskrPct, 0) = 0
				Then	Case	When	Isnull(vwnd.LangNedskrPct, 0)	= 0
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
								Then	Case	When	vwnl.LitraNedskrPct	<	vwnd.LangNedskrPct
										Then	'Litr'
										Else	'Lang'
									End
								Else	Case	When	vwnl.LitraNedskrPct	<	vwnr.RaekkeNedskrPct
										Then	'Litr'
										Else	'Rækk'
									End
							End
					End				
				Else	Case	When	Isnull(vwnd.LangNedskrPct, 0)	= 0
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
						Else	Case	When	vwns.StatusNedskrPct		<	vwnd.LangNedskrPct
								Then	Case	When	vwnl.LitraNedskrPct	<	vwns.StatusNedskrPct
										Then	'Litr'
										Else	'Stat'
									End	
								Else	Case	When	vwnl.LitraNedskrPct	<	vwnd.LangNedskrPct
										Then	'Litr'
										Else	'Lang'
									End
							End	
					End
	End
		As [LNType]
	,Case		When	Isnull(vwns.StatusNedskrPct, 0) = 0
				Then	Case	When	Isnull(vwnd.LangNedskrPct, 0)	= 0
								Then	Case	When	Isnull(vwnr.RaekkeNedskrPct, 0) = 0
												Then	Case	When	vwnl.LitraNedskrPct	<	0
																Then	vwnl.LitraNedskrPct
																Else	0
														End
												Else	Case	When	vwnl.LitraNedskrPct	<	vwnr.RaekkeNedskrPct
																Then	vwnl.LitraNedskrPct
																Else	vwnr.RaekkeNedskrPct
														End
										End
								Else	Case	When	Isnull(vwnr.RaekkeNedskrPct, 0) = 0
												Then	Case	When	vwnl.LitraNedskrPct	<	vwnd.LangNedskrPct
																Then	vwnl.LitraNedskrPct
																Else	vwnd.LangNedskrPct
														End
												Else	Case	When	vwnl.LitraNedskrPct	<	vwnr.RaekkeNedskrPct
																Then	vwnl.LitraNedskrPct
																Else	vwnr.RaekkeNedskrPct
														End
										End
						End				
				Else	Case	When	Isnull(vwnd.LangNedskrPct, 0)	= 0
								Then	Case	When	vwns.StatusNedskrPct		<	vwnr.RaekkeNedskrPct
												Then	Case	When	vwnl.LitraNedskrPct	<	vwns.StatusNedskrPct
																Then	vwnl.LitraNedskrPct
																Else	vwns.StatusNedskrPct
														End
												Else	Case	When	vwnl.LitraNedskrPct	<	vwnr.RaekkeNedskrPct
																Then	vwnl.LitraNedskrPct
																Else	vwnr.RaekkeNedskrPct
														End
									End
 								Else	Case	When	vwns.StatusNedskrPct		<	vwnd.LangNedskrPct
												Then	Case	When	vwnl.LitraNedskrPct	<	vwns.StatusNedskrPct
																Then	vwnl.LitraNedskrPct
																Else	vwns.StatusNedskrPct
														End	
												Else	Case	When	vwnl.LitraNedskrPct	<	vwnd.LangNedskrPct
																Then	vwnl.LitraNedskrPct
																Else	vwnd.LangNedskrPct
														End
										End	
						End
		End
	As [LavNedPct]
	,Case		When	Isnull(vwns.StatusNedskrPct, 0) = 0
				Then	Case	When	Isnull(vwnd.LangNedskrPct, 0)	= 0
								Then	Case	When	Isnull(vwnr.RaekkeNedskrPct, 0) = 0
												Then	Case	When	vwnl.LitraNedskrPct	<	0
																Then	vwnl.LitraNedskrPct * ftb.Vaerdi_GP
																Else	0
														End
												Else	Case	When	vwnl.LitraNedskrPct	<	vwnr.RaekkeNedskrPct
																Then	vwnl.LitraNedskrPct * ftb.Vaerdi_GP
																Else	vwnr.RaekkeNedskrPct * ftb.Vaerdi_GP
														End
										End
								
								Else	Case	When	Isnull(vwnr.RaekkeNedskrPct, 0) = 0
												Then	Case	When	vwnl.LitraNedskrPct	<	vwnd.LangNedskrPct
																Then	vwnl.LitraNedskrPct * ftb.Vaerdi_GP
																Else	vwnd.LangNedskrPct * ftb.Vaerdi_GP
														End
												Else	Case	When	vwnl.LitraNedskrPct	<	vwnr.RaekkeNedskrPct
																Then	vwnl.LitraNedskrPct * ftb.Vaerdi_GP
																Else	vwnr.RaekkeNedskrPct * ftb.Vaerdi_GP
														End
										End
						End				
				Else	Case	When	Isnull(vwnd.LangNedskrPct, 0)	= 0
								Then	Case	When	vwns.StatusNedskrPct		<	vwnr.RaekkeNedskrPct
												Then	Case	When	vwnl.LitraNedskrPct	<	vwns.StatusNedskrPct
																Then	vwnl.LitraNedskrPct * ftb.Vaerdi_GP
																Else	vwns.StatusNedskrPct * ftb.Vaerdi_GP
														End
												Else	Case	When	vwnl.LitraNedskrPct	<	vwnr.RaekkeNedskrPct
																Then	vwnl.LitraNedskrPct * ftb.Vaerdi_GP
																Else	vwnr.RaekkeNedskrPct * ftb.Vaerdi_GP
														End
										End
								Else	Case	When	vwns.StatusNedskrPct		<	vwnd.LangNedskrPct
												Then	Case	When	vwnl.LitraNedskrPct	<	vwns.StatusNedskrPct
																Then	vwnl.LitraNedskrPct * ftb.Vaerdi_GP
																Else	vwns.StatusNedskrPct * ftb.Vaerdi_GP
														End	
												Else	Case	When	vwnl.LitraNedskrPct	<	vwnd.LangNedskrPct
																Then	vwnl.LitraNedskrPct * ftb.Vaerdi_GP
																Else	vwnd.LangNedskrPct * ftb.Vaerdi_GP
														End
										End	
						End			
		End
	As [LogNedBrutto]
	,Case		When	vwnl.FTrDato < cast(( select Vaerdi from [edw].[MD_Styringstabel] where parameter = 'UltimoDato')as datetime)	- 1095 --ultimo dato - parametrizeres
						Or vwnl.FTrDato Is Null
						-- Ajourført 150330-1: Rettet tidligere indsat kriterie for at der alligevel skal korrigeres ved IC4, når gamle regnskaber genberegnes
						Or (d.LitraGr2 = 'IC4' and (select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'UltimoDato') >= '201411'
										)
				Then	0
				Else	-Case		When	Isnull(vwns.StatusNedskrPct, 0) = 0 
									Then	Case	When	Isnull(vwnd.LangNedskrPct, 0)	= 0
													Then	Case	When	Isnull(vwnr.RaekkeNedskrPct, 0) = 0
																	Then	Case	When	vwnl.LitraNedskrPct	<	0
																					Then	vwnl.LitraNedskrPct * ftb.Vaerdi_GP
																					Else	0
																			End
																	Else	Case	When	vwnl.LitraNedskrPct	<	vwnr.RaekkeNedskrPct
																					Then	vwnl.LitraNedskrPct * ftb.Vaerdi_GP
																					Else	vwnr.RaekkeNedskrPct * ftb.Vaerdi_GP
																			End
															End
											
													Else	Case	When	Isnull(vwnr.RaekkeNedskrPct, 0) = 0
																	Then	Case	When	vwnl.LitraNedskrPct	<	vwnd.LangNedskrPct
																					Then	vwnl.LitraNedskrPct * ftb.Vaerdi_GP
																					Else	vwnd.LangNedskrPct * ftb.Vaerdi_GP
																			End
																	Else	Case	When	vwnl.LitraNedskrPct	<	vwnr.RaekkeNedskrPct
																					Then	vwnl.LitraNedskrPct * ftb.Vaerdi_GP
																					Else	vwnr.RaekkeNedskrPct * ftb.Vaerdi_GP
																			End
															End
											End				
									Else	Case	When	Isnull(vwnd.LangNedskrPct, 0)	= 0
													Then	Case	When	vwns.StatusNedskrPct		<	vwnr.RaekkeNedskrPct
																	Then	Case	When	vwnl.LitraNedskrPct	<	vwns.StatusNedskrPct
																					Then	vwnl.LitraNedskrPct * ftb.Vaerdi_GP
																					Else	vwns.StatusNedskrPct * ftb.Vaerdi_GP
																			End
																	Else	Case	When	vwnl.LitraNedskrPct	<	vwnr.RaekkeNedskrPct
																					Then	vwnl.LitraNedskrPct * ftb.Vaerdi_GP
																					Else	vwnr.RaekkeNedskrPct * ftb.Vaerdi_GP
																			End
															End
													Else	Case	When	vwns.StatusNedskrPct		<	vwnd.LangNedskrPct
																	Then	Case	When	vwnl.LitraNedskrPct	<	vwns.StatusNedskrPct
																					Then	vwnl.LitraNedskrPct * ftb.Vaerdi_GP
																					Else	vwns.StatusNedskrPct * ftb.Vaerdi_GP
																			End	
																	Else	Case	When	vwnl.LitraNedskrPct	<	vwnd.LangNedskrPct
																					Then	vwnl.LitraNedskrPct * ftb.Vaerdi_GP
																					Else	vwnd.LangNedskrPct * ftb.Vaerdi_GP
																			End
															End	
											End			
						End
		End
		+	Case		When	vwnl.FTrDato >= cast(( select Vaerdi from [edw].[MD_Styringstabel] where parameter = 'UltimoDato')as datetime) - 1095 --ultimo dato - parametrizeres
						Then	case	When	vwnl.LitraNedskrPct	<	0 
										Then vwnl.LitraNedskrPct * ftb.Vaerdi_GP
										Else 0 
								End
			End					
As [NedKorrNytMat]
,left(convert(varchar(20),  vwnl.FTrDato,121),7) as FTrMd
, fti12.BrutIndk12mdMgd
,vwns.StatusNedskrPct, vwnd.LangNedskrPct, vwnr.RaekkeNedskrPct, vwnl.LitraNedskrPct, -- fti12.UltBehIndk12mdVd,
 Case When fti12.UltBehIndk12mdVd Is Null
		-- Ajourført 150330-1: Rettet tidligere indsat kriterie for at der alligevel skal korrigeres ved IC4, når gamle regnskaber genberegnes
		Or (d.LitraGr2 = 'IC4' and (select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'UltimoDato') >= '201411')
      Then 0
      Else -Case When	Isnull(vwns.StatusNedskrPct, 0) = 0 
				 Then	Case When	Isnull(vwnd.LangNedskrPct, 0)	= 0
							 Then Case When	Isnull(vwnr.RaekkeNedskrPct, 0) = 0
									   Then	0
									   Else	Case When	vwnl.LitraNedskrPct	<	vwnr.RaekkeNedskrPct
												 Then	0 
												 Else vwnr.RaekkeNedskrPct * fti12.UltBehIndk12mdVd--ftb.Vaerdi_GP
												 End
									   End
							 Else	Case When	Isnull(vwnr.RaekkeNedskrPct, 0) = 0
										 Then	Case When	vwnl.LitraNedskrPct	<	vwnd.LangNedskrPct
													 Then	0 
													 Else	vwnd.LangNedskrPct * fti12.UltBehIndk12mdVd--ftb.Vaerdi_GP
													 End
										 Else	Case When	vwnl.LitraNedskrPct	<	vwnr.RaekkeNedskrPct
													 Then	0 
													 Else	vwnr.RaekkeNedskrPct * fti12.UltBehIndk12mdVd--ftb.Vaerdi_GP
													 End
										 End
							 End
				 Else	Case When	Isnull(vwnd.LangNedskrPct, 0)	= 0
							 Then	Case When	vwns.StatusNedskrPct		<	vwnr.RaekkeNedskrPct
										 Then	Case When	vwnl.LitraNedskrPct	<	vwns.StatusNedskrPct
													 Then	0 
													 Else	vwns.StatusNedskrPct * fti12.UltBehIndk12mdVd--ftb.Vaerdi_GP
													 End
										 Else	Case When	vwnl.LitraNedskrPct	<	vwnr.RaekkeNedskrPct
													 Then	0 
													 Else	vwnr.RaekkeNedskrPct * fti12.UltBehIndk12mdVd--ftb.Vaerdi_GP
													 End
										 End
							 Else	Case When	vwns.StatusNedskrPct		<	vwnd.LangNedskrPct
										 Then	Case When	vwnl.LitraNedskrPct	<	vwns.StatusNedskrPct
													 Then	0 
													 Else	vwns.StatusNedskrPct * fti12.UltBehIndk12mdVd--ftb.Vaerdi_GP
													 End	
										 Else	Case When	vwnl.LitraNedskrPct	<	vwnd.LangNedskrPct
													 Then	0 
													 Else	vwnd.LangNedskrPct * fti12.UltBehIndk12mdVd--ftb.Vaerdi_GP
													 End
										 End	
							 End			
			--	/ (ftb.Beholdning * fti12.BrutIndk12mdMgd)
				End 
End
--/ (ftb.Beholdning * fti12.BrutIndk12mdMgd)
As [NedKorrIndk]
,fti12.UltBehIndk12mdMgd --as [IndkLagerBeh]
,fti12.UltBehIndk12mdVd --as [IndkLagerVaerdi]
,ftb.Vaerdi_SP as [Vaerdi_SP]
,ftb.Vaerdi_GP - ftb.Vaerdi_SP as [Forskel]
,vwnl.LitraNedskrPct as [LitrNedPct]
,ftb.Vaerdi_GP * vwnl.LitraNedskrPct as [LitraNedVaerdi] 
,vwnd.MinDuf as [DUF]
,ftb.Vaerdi_GP * vwnd.LangNedskrPct as [LangNedVaerdi] 
,vwnr.MinRID as [RID]
,vwnr.RaekkeNedskrPct as [RaekNedPct]
,ftb.Vaerdi_GP * vwnr.RaekkeNedskrPct as [RaekkeNedVaerdi] 
,vwns.StatusNedskrPct as [StatNedPct]
,ftb.Vaerdi_GP * vwns.StatusNedskrPct as [StatNedVaerdi] 
,-Case	When	Isnull(vwnd.LangNedskrPct, 0)	= 0
				Then	Case	When	Isnull(vwnr.RaekkeNedskrPct, 0) = 0
								Then	Case	When	vwnl.LitraNedskrPct	<	0
												Then	vwnl.LitraNedskrPct * ftb.Vaerdi_GP
												Else	0
										End
								Else	Case	When	vwnl.LitraNedskrPct	<	vwnr.RaekkeNedskrPct
												Then	vwnl.LitraNedskrPct * ftb.Vaerdi_GP
												Else	vwnr.RaekkeNedskrPct * ftb.Vaerdi_GP
										End
						End
								
				Else	Case	When	Isnull(vwnr.RaekkeNedskrPct, 0) = 0
								Then	Case	When	vwnl.LitraNedskrPct	<	vwnd.LangNedskrPct
												Then	vwnl.LitraNedskrPct * ftb.Vaerdi_GP
												Else	vwnd.LangNedskrPct * ftb.Vaerdi_GP
										End
								Else	Case	When	vwnl.LitraNedskrPct	<	vwnr.RaekkeNedskrPct
												Then	vwnl.LitraNedskrPct * ftb.Vaerdi_GP
												Else	vwnr.RaekkeNedskrPct * ftb.Vaerdi_GP
										End
						End
		End				
		+
Case		When	Isnull(vwns.StatusNedskrPct, 0) = 0
				Then	Case	When	Isnull(vwnd.LangNedskrPct, 0)	= 0
								Then	Case	When	Isnull(vwnr.RaekkeNedskrPct, 0) = 0
												Then	Case	When	vwnl.LitraNedskrPct	<	0
																Then	vwnl.LitraNedskrPct * ftb.Vaerdi_GP
																Else	0
														End
												Else	Case	When	vwnl.LitraNedskrPct	<	vwnr.RaekkeNedskrPct
																Then	vwnl.LitraNedskrPct * ftb.Vaerdi_GP
																Else	vwnr.RaekkeNedskrPct * ftb.Vaerdi_GP
														End
										End
								
								Else	Case	When	Isnull(vwnr.RaekkeNedskrPct, 0) = 0
												Then	Case	When	vwnl.LitraNedskrPct	<	vwnd.LangNedskrPct
																Then	vwnl.LitraNedskrPct * ftb.Vaerdi_GP
																Else	vwnd.LangNedskrPct * ftb.Vaerdi_GP
														End
												Else	Case	When	vwnl.LitraNedskrPct	<	vwnr.RaekkeNedskrPct
																Then	vwnl.LitraNedskrPct * ftb.Vaerdi_GP
																Else	vwnr.RaekkeNedskrPct * ftb.Vaerdi_GP
														End
										End
						End				
				Else	Case	When	Isnull(vwnd.LangNedskrPct, 0)	= 0
								Then	Case	When	vwns.StatusNedskrPct		<	vwnr.RaekkeNedskrPct
												Then	Case	When	vwnl.LitraNedskrPct	<	vwns.StatusNedskrPct
																Then	vwnl.LitraNedskrPct * ftb.Vaerdi_GP
																Else	vwns.StatusNedskrPct * ftb.Vaerdi_GP
														End
												Else	Case	When	vwnl.LitraNedskrPct	<	vwnr.RaekkeNedskrPct
																Then	vwnl.LitraNedskrPct * ftb.Vaerdi_GP
																Else	vwnr.RaekkeNedskrPct * ftb.Vaerdi_GP
														End
										End
								Else	Case	When	vwns.StatusNedskrPct		<	vwnd.LangNedskrPct
												Then	Case	When	vwnl.LitraNedskrPct	<	vwns.StatusNedskrPct
																Then	vwnl.LitraNedskrPct * ftb.Vaerdi_GP
																Else	vwns.StatusNedskrPct * ftb.Vaerdi_GP
														End	
												Else	Case	When	vwnl.LitraNedskrPct	<	vwnd.LangNedskrPct
																Then	vwnl.LitraNedskrPct * ftb.Vaerdi_GP
																Else	vwnd.LangNedskrPct * ftb.Vaerdi_GP
														End
										End	
						End			
		End		
As [StatNedReelt]
,vwtab.RestAabnBalBeh as [RestAabnBalBeh]
,vwtab.AabnBalNedskrPct as [AabnNedPct]
,vwtab.AabnBalNedskrVaerdi as [AabnBalNedVaerdi]
from (select Dim_Fabrik, Materiale,Dim_Materiale, Dim_Tid, Vaerdi_GP, Beholdning, GlidGnsPris, Vaerdi_SP
      from edw.FT_Beholdning where Dim_Tid = ( select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'UltimoDato')) ftb
left join dbo.vw_NedskrSfaStat vwns
on ftb.Dim_Materiale = vwns.Dim_Materiale
left join dbo.vw_NedskrSfaDUF vwnd
on ftb.Dim_Materiale = vwnd.Dim_Materiale
left join dbo.vw_NedskrSfaLitra vwnl
on ftb.Dim_Materiale = vwnl.Dim_Materiale
left join dbo.vw_NedskrSfaRID vwnr
on ftb.Dim_Materiale = vwnr.Dim_Materiale
left join edw.FT_NySeneste3Aar ftns3
on ftb.Dim_Fabrik = ftns3.Dim_Fabrik and ftb.Materiale = ftns3.Materiale and ftb.Dim_Tid = ftns3.Dim_Tid
left join ((Select a.[Dim_Fabrik],a.[Materiale],a.[Dim_Tid],a.[BrutIndk12mdMgd],a.[UltBehIndk12mdMgd]
			,a.[UltBehIndk12mdVd],a.[Dim_Materiale]
			From [edw].[FT_Indk12md] a
			Left join edw.Dim_Materiale b on a.Dim_Materiale = b.PK_ID
			Left join edw.Dim_Litra c on b.Litra_PKID = c.PK_ID
			Where Dim_Tid = (select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'UltimoDato')
			and isnull(c.LitraNedskrPct, 0) = 0)
			) fti12
on ftb.Dim_Fabrik = fti12.Dim_Fabrik and ftb.Dim_Materiale = fti12.Dim_Materiale and ftb.Dim_Tid = fti12.Dim_Tid
left join dbo.vw_TransAabnBalRest vwtab
on ftb.Dim_Fabrik = vwtab.Dim_Fabrik and ftb.Dim_Materiale = vwtab.Dim_Materiale and ftb.Dim_Tid = vwtab.Dim_Tid
-- Ajourført 141222-1: Join for afgørelse af om der skal korrigeres ved IC4
Left join edw.Dim_Materiale d on ftb.Dim_Materiale = d.PK_ID

--Where ftb.Materiale = '600503020'