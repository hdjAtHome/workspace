




CREATE view [dbo].[vw_Flg_NytMat36md] 
-- Oprettet 150220-1: Flag for hvilke materialer, der set fra Til-perioden er anskaffet indenfor seneste 36 måneder
as
Select distinct q2.FraTil_Tid, q2.Materiale,
		case when max(q2.FoersteTransDato) <> '1900-01-01 00:00:00.000' then 1 else 0 end as Flg_NytMat36md
		From
			(Select  distinct a.FraTil_Tid, q1.Materiale, max(isnull(q1.FTrDato,0)) as FoersteTransDato, count(*) as Antal
			From edw.FT_Forklaring a
			Left join (	Select distinct a.Materiale, a.FraTil_Tid, b.FTrDato
						From edw.FT_Forklaring a
						Left join edw.Dim_Materiale b on a.Materiale = b.Materiale
							and FTrDato >= (
											Select distinct cast(substring(a.FraTil_Tid,8,4)+'-'+substring(a.FraTil_Tid,12,2)+'-'
											+	case	when substring(a.FraTil_Tid,12,2) in ('01' , '03' , '05' , '07' , '08' , '10' , '12' )	then + '31'
														when substring(a.FraTil_Tid,12,2) in ('04' , '06' , '09' , '11' ) then + '30'
														else	case	when substring(a.FraTil_Tid,8,4) in ( '2016' , '2020' , '2024' , '2028' ) 
																		then '29' 
																		else '28' 
																end
														end	as datetime) + 1 - 1095
											--as Fra_dato
											)
							and FTrDato <= (
											Select distinct cast(substring(a.FraTil_Tid,8,4)+'-'+substring(a.FraTil_Tid,12,2)+'-'
											+	case	when substring(a.FraTil_Tid,12,2) in ('01' , '03' , '05' , '07' , '08' , '10' , '12' )	then + '31'
														when substring(a.FraTil_Tid,12,2) in ('04' , '06' , '09' , '11' ) then + '30'
														else	case	when substring(a.FraTil_Tid,8,4) in ( '2016' , '2020' , '2024' , '2028' ) 
																		then '29' 
																		else '28' 
																end
														end	as datetime) + 1
											--as Fra_dato
											)												
		--Order by Materiale, FraTil_Tid
						) q1 on a.FraTil_Tid = q1.FraTil_Tid and a.Materiale = q1.Materiale	
			Group by a.FraTil_Tid, q1.Materiale, q1.FTrDato
			--With rollup
		--	Order by q1.Materiale, a.FraTil_Tid, max(isnull(q1.FTrDato,0))
) q2
Where Materiale is not null
Group by q2.Materiale, q2.FraTil_Tid
-- Order by q2.Materiale, q2.FraTil_Tid