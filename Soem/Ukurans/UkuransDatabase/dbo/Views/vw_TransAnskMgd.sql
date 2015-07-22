CREATE view [dbo].[vw_TransAnskMgd]
as
select Dim_Fabrik, fttr.Materiale, Dim_Materiale, Dim_Tid, sum(Maengde) AnskMgdIalt
from edw.FT_Transaktioner fttr
left join edw.Dim_Materiale
on fttr.Dim_Materiale = pk_id
where Dim_bevart in ('101' , '102' , '122' , '123' )
	and FTrAar = 'F2000'
	and Dim_Tid = ( select replace(left(Vaerdi, 7), '-', '') from [edw].[MD_Styringstabel] where parameter = 'UltimoDato')
group by Dim_Fabrik, fttr.materiale, Dim_Materiale, Dim_Tid