







CREATE view [dbo].[vw_Flg_Uroerte] 
-- Oprettet 150220-1: Flag for hvilke materialer, der i FraTil-perioden er fuldstændig urørte
-- Ajourført 150311-1: Ændret kriterie til at være fra BogfDato >= til BogfDato >
-- Ajourført 150316-1: Ændret kritirie til at være fra BogfDato > til RegistrDato >
-- Ajourført 150511-1: Justeret kriterie, da en enkelt post fejlede ved anskaffelse præcis den 1. i indeværende måned
as
Select distinct q2.FraTil_Tid, q2.Materiale
,case when max(q2.SidsteTransDato) = '1900-01-01 00:00:00.000' then 1 else 0 end as Flg_Uroerte
From
	(Select  distinct a.FraTil_Tid, q1.Materiale, max(isnull(q1.RegistrDato,0)) as SidsteTransDato , count(*) as Antal
	From edw.FT_Forklaring a
	Left join (	Select distinct a.Materiale, a.FraTil_Tid, b.RegistrDato
				From edw.FT_Forklaring a
				Left join edw.FT_Transaktioner b on a.Materiale = b.Materiale
					and RegistrDato >  (
									Select distinct cast(left(a.FraTil_Tid,4)+'-'+substring(a.FraTil_Tid,5,2)+'-'
									+	case	when substring(a.FraTil_Tid,5,2) in ('01' , '03' , '05' , '07' , '08' , '10' , '12' )	then + '31'
												when substring(a.FraTil_Tid,5,2) in ('04' , '06' , '09' , '11' ) then + '30'
												else	case	when left(a.FraTil_Tid,4) in ( '2016' , '2020' , '2024' , '2028' ) 
																then '29' 
																else '28' 
														end
												end	as datetime) 
									)
					and RegistrDato <= (
									Select distinct cast(substring(a.FraTil_Tid,8,4)+'-'+substring(a.FraTil_Tid,12,2)+'-'
									+	case	when substring(a.FraTil_Tid,12,2) in ('01' , '03' , '05' , '07' , '08' , '10' , '12' )	then + '31'
												when substring(a.FraTil_Tid,12,2) in ('04' , '06' , '09' , '11' ) then + '30'
												else	case	when substring(a.FraTil_Tid,8,4) in ( '2016' , '2020' , '2024' , '2028' ) 
																then '29' 
																else '28' 
														end
												end	as datetime) + 1
									)												
				) q1 on a.FraTil_Tid = q1.FraTil_Tid and a.Materiale = q1.Materiale	
	Group by a.FraTil_Tid, q1.Materiale, q1.RegistrDato
	--With rollup
	--Order by q1.Materiale, a.FraTil_Tid, max(isnull(q1.RegistrDato,0))
) q2
Group by q2.Materiale, q2.FraTil_Tid
-- Order by q2.Materiale, q2.FraTil_Tid