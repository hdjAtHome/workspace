






CREATE view [dbo].[vw_Nedskriv_Pae] 
as
-- Ajourført 150113-1: FLNType sker nu efterfølgende ved brug af procedure
-- Ajourført 150120-1: Midlertidigt indsat hardkodet kriterie for at der ikke korrigeres ved IC4
-- Ajourført 150225-1: Indsat where-betingelser, der afgør om IC4-korrektion skal vises som modelændring eller ej
-- Ajourført 150310-1: Ændret join til FT_Indk12md til at være på ultimo måned samt ændret 'is null' til 'isnull = 0' (da IC4 nu er 0%)
Select 
ftb.Dim_Fabrik, ftb.Dim_Materiale, ftb.Materiale, ftb.Beholdning,
ftb.Vaerdi_GP, ftb.GlidGnsPris, vwnlpa.LitraGr2, vwndpa.LangNedskrPct, vwnrpa.RaekkeNedskrPct, vwnlpa.LitraNedskrPct, vwnspa.StatusNedskrPct
,''	As [FLNType]
,Case		When	vwnspa.StatusNedskrPct	Is Null
				Then	Case	When	vwndpa.LangNedskrPct	Is Null
								Then	Case	When	vwnrpa.RaekkeNedskrPct Is Null
												Then	Case	When	vwnlpa.LitraNedskrPct	<	0
																Then	vwnlpa.LitraNedskrPct * ftb.Vaerdi_GP
																Else	0
														End
												Else	Case	When	vwnlpa.LitraNedskrPct	<	vwnrpa.RaekkeNedskrPct
																Then	vwnlpa.LitraNedskrPct * ftb.Vaerdi_GP
																Else	vwnrpa.RaekkeNedskrPct * ftb.Vaerdi_GP
														End
										End
								
								Else	Case	When	vwnrpa.RaekkeNedskrPct Is null
												Then	Case	When	vwnlpa.LitraNedskrPct	<	vwndpa.LangNedskrPct
																Then	vwnlpa.LitraNedskrPct * ftb.Vaerdi_GP
																Else	vwndpa.LangNedskrPct * ftb.Vaerdi_GP
														End
												Else	Case	When	vwnlpa.LitraNedskrPct	<	vwnrpa.RaekkeNedskrPct
																Then	vwnlpa.LitraNedskrPct * ftb.Vaerdi_GP
																Else	vwnrpa.RaekkeNedskrPct * ftb.Vaerdi_GP
														End
										End
						End				
				Else	Case	When	vwndpa.LangNedskrPct	Is Null
								Then	Case	When	vwnspa.StatusNedskrPct		<	vwnrpa.RaekkeNedskrPct
												Then	Case	When	vwnlpa.LitraNedskrPct	<	vwnspa.StatusNedskrPct
																Then	vwnlpa.LitraNedskrPct * ftb.Vaerdi_GP
																Else	vwnspa.StatusNedskrPct * ftb.Vaerdi_GP
														End
												Else	Case	When	vwnlpa.LitraNedskrPct	<	vwnrpa.RaekkeNedskrPct
																Then	vwnlpa.LitraNedskrPct * ftb.Vaerdi_GP
																Else	vwnrpa.RaekkeNedskrPct * ftb.Vaerdi_GP
														End
										End
								Else	Case	When	vwnspa.StatusNedskrPct		<	vwndpa.LangNedskrPct
												Then	Case	When	vwnlpa.LitraNedskrPct	<	vwnspa.StatusNedskrPct
																Then	vwnlpa.LitraNedskrPct * ftb.Vaerdi_GP
																Else	vwnspa.StatusNedskrPct * ftb.Vaerdi_GP
														End	
												Else	Case	When	vwnlpa.LitraNedskrPct	<	vwndpa.LangNedskrPct
																Then	vwnlpa.LitraNedskrPct * ftb.Vaerdi_GP
																Else	vwndpa.LangNedskrPct * ftb.Vaerdi_GP
														End
										End	
						End			
		End
	As [LogNedBruttoPae] --convert(datetime, substring(replace(convert(varchar, dm.gyldigfradato, 102), '.', '-'), 1, 8) + '01') 
,Case When vwnlpa.FTrDato 
					 < cast(( select Vaerdi from [edw].[MD_Styringstabel] where parameter = 'UltimoDato')as datetime) - 1095
						Or vwnlpa.FTrDato Is Null
-- Ajourført 150125-1: Ved kørsler der rækker længere tilbage end Dim_Tid 201411, skal der ikke korrigeres på IC4
						Or (d.LitraGr2 = 'IC4' and (select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'PrimoDato') >= '201411')
				Then	0
				Else	-Case		When	vwnspa.StatusNedskrPct	Is Null 
									Then	Case	When	vwndpa.LangNedskrPct	Is Null
													Then	Case	When	vwnrpa.RaekkeNedskrPct Is Null
																	Then	Case	When	vwnlpa.LitraNedskrPct	<	0
																					Then	vwnlpa.LitraNedskrPct * ftb.Vaerdi_GP
																					Else	0
																			End
																	Else	Case	When	vwnlpa.LitraNedskrPct	<	vwnrpa.RaekkeNedskrPct
																					Then	vwnlpa.LitraNedskrPct * ftb.Vaerdi_GP
																					Else	vwnrpa.RaekkeNedskrPct * ftb.Vaerdi_GP
																			End
															End
											
													Else	Case	When	vwnrpa.RaekkeNedskrPct Is null
																	Then	Case	When	vwnlpa.LitraNedskrPct	<	vwndpa.LangNedskrPct
																					Then	vwnlpa.LitraNedskrPct * ftb.Vaerdi_GP
																					Else	vwndpa.LangNedskrPct * ftb.Vaerdi_GP
																			End
																	Else	Case	When	vwnlpa.LitraNedskrPct	<	vwnrpa.RaekkeNedskrPct
																					Then	vwnlpa.LitraNedskrPct * ftb.Vaerdi_GP
																					Else	vwnrpa.RaekkeNedskrPct * ftb.Vaerdi_GP
																			End
															End
											End				
									Else	Case	When	vwndpa.LangNedskrPct	Is Null
													Then	Case	When	vwnspa.StatusNedskrPct		<	vwnrpa.RaekkeNedskrPct
																	Then	Case	When	vwnlpa.LitraNedskrPct	<	vwnspa.StatusNedskrPct
																					Then	vwnlpa.LitraNedskrPct * ftb.Vaerdi_GP
																					Else	vwnspa.StatusNedskrPct * ftb.Vaerdi_GP
																			End
																	Else	Case	When	vwnlpa.LitraNedskrPct	<	vwnrpa.RaekkeNedskrPct
																					Then	vwnlpa.LitraNedskrPct * ftb.Vaerdi_GP
																					Else	vwnrpa.RaekkeNedskrPct * ftb.Vaerdi_GP
																			End
															End
													Else	Case	When	vwnspa.StatusNedskrPct		<	vwndpa.LangNedskrPct
																	Then	Case	When	vwnlpa.LitraNedskrPct	<	vwnspa.StatusNedskrPct
																					Then	vwnlpa.LitraNedskrPct * ftb.Vaerdi_GP
																					Else	vwnspa.StatusNedskrPct * ftb.Vaerdi_GP
																			End	
																	Else	Case	When	vwnlpa.LitraNedskrPct	<	vwndpa.LangNedskrPct
																					Then	vwnlpa.LitraNedskrPct * ftb.Vaerdi_GP
																					Else	vwndpa.LangNedskrPct * ftb.Vaerdi_GP
																			End
															End	
											End			
						End
		End
		+	Case		When	vwnlpa.FTrDato
								>= cast(( select Vaerdi from [edw].[MD_Styringstabel] where parameter = 'UltimoDato')as datetime)+1 - 1096 
						Then	case	When	vwnlpa.LitraNedskrPct	<	0 
										Then vwnlpa.LitraNedskrPct * ftb.Vaerdi_GP
										Else 0 
								End
			End					
As [NedKorrNytMatPae]
,Case When fti12.UltBehIndk12mdVd Is Null
-- Ajourført 150125-1: Ved kørsler der rækker længere tilbage end Dim_Tid 201411, skal der ikke korrigeres på IC4
		Or (d.LitraGr2 = 'IC4' and (select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'PrimoDato') >= '201411')
       Then 0
      Else -Case When	vwnspa.StatusNedskrPct	Is Null 
				 Then	Case When	vwndpa.LangNedskrPct	Is Null
							 Then Case When	vwnrpa.RaekkeNedskrPct Is Null
									   Then	0
									   Else	Case When	vwnlpa.LitraNedskrPct	<	vwnrpa.RaekkeNedskrPct
												 Then	0 
												 Else vwnrpa.RaekkeNedskrPct * fti12.UltBehIndk12mdVd--ftb.Vaerdi_GP
												 End
									   End
							 Else	Case When	vwnrpa.RaekkeNedskrPct Is null
										 Then	Case When	vwnlpa.LitraNedskrPct	<	vwndpa.LangNedskrPct
													 Then	0 
													 Else	vwndpa.LangNedskrPct * fti12.UltBehIndk12mdVd--ftb.Vaerdi_GP
													 End
										 Else	Case When	vwnlpa.LitraNedskrPct	<	vwnrpa.RaekkeNedskrPct
													 Then	0 
													 Else	vwnrpa.RaekkeNedskrPct * fti12.UltBehIndk12mdVd--ftb.Vaerdi_GP
													 End
										 End
							 End
				 Else	Case When	vwndpa.LangNedskrPct	Is Null
							 Then	Case When	vwnspa.StatusNedskrPct		<	vwnrpa.RaekkeNedskrPct
										 Then	Case When	vwnlpa.LitraNedskrPct	<	vwnspa.StatusNedskrPct
													 Then	0 
													 Else	vwnspa.StatusNedskrPct * fti12.UltBehIndk12mdVd--ftb.Vaerdi_GP
													 End
										 Else	Case When	vwnlpa.LitraNedskrPct	<	vwnrpa.RaekkeNedskrPct
													 Then	0 
													 Else	vwnrpa.RaekkeNedskrPct * fti12.UltBehIndk12mdVd--ftb.Vaerdi_GP
													 End
										 End
							 Else	Case When	vwnspa.StatusNedskrPct		<	vwndpa.LangNedskrPct
										 Then	Case When	vwnlpa.LitraNedskrPct	<	vwnspa.StatusNedskrPct
													 Then	0 
													 Else	vwnspa.StatusNedskrPct * fti12.UltBehIndk12mdVd--ftb.Vaerdi_GP
													 End	
										 Else	Case When	vwnlpa.LitraNedskrPct	<	vwndpa.LangNedskrPct
													 Then	0 
													 Else	vwndpa.LangNedskrPct * fti12.UltBehIndk12mdVd--ftb.Vaerdi_GP
													 End
										 End	
							 End			
				 End
 end
 -- / 	ftb.Beholdning * fti12.UltBehIndk12mdMgd
As [NedKorrIndkPae]

from (select Dim_Fabrik, Materiale,Dim_Materiale, Dim_Tid, Vaerdi_GP, Beholdning, GlidGnsPris, Vaerdi_SP
      from edw.FT_Beholdning where Dim_Tid = ( select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'UltimoDato')) ftb
left join dbo.vw_NedskrSfaStatPae vwnspa 
on ftb.Dim_Materiale = vwnspa.Dim_Materiale
left join dbo.vw_NedskrSfaDUFPae vwndpa 
on ftb.Dim_Materiale = vwndpa.Dim_Materiale
left join dbo.vw_NedskrSfaLitraPae vwnlpa
on ftb.Materiale = vwnlpa.Materiale
left join dbo.vw_NedskrSfaRIDPae vwnrpa
on ftb.Materiale = vwnrpa.Materiale 
left join ((Select a.[Dim_Fabrik],a.[Materiale],a.[Dim_Tid],a.[BrutIndk12mdMgd],a.[UltBehIndk12mdMgd]
			,a.[UltBehIndk12mdVd],a.[Dim_Materiale]
			From [edw].[FT_Indk12md] a
			Left join edw.Dim_Materiale b on a.Dim_Materiale = b.PK_ID
			Left join edw.Dim_Litra c on b.Litra_PKID = c.PK_ID
			Where Dim_Tid = (select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'UltimoDato')
			and isnull(c.LitraNedskrPct, 0) = 0)
			) fti12
on ftb.Dim_Fabrik = fti12.Dim_Fabrik and ftb.Dim_Materiale = fti12.Dim_Materiale and ftb.Dim_Tid = fti12.Dim_Tid

-- Ajourført 150120-1: Indsat ny join for at eliminere korrektion for IR4 efter Dim_Tid 201411
Left join edw.Dim_Materiale d on ftb.Dim_Materiale = d.PK_ID