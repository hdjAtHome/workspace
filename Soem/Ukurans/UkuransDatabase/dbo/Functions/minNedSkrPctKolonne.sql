
create function [dbo].[minNedSkrPctKolonne](@statusnedskrpct decimal(10,5) = 0.00000, @langnedskrpct decimal(10,5) = 0.00000, @raekkenedskrpct decimal(10,5) = 0.00000, @litranedskrpct decimal(10,5) = 0.0000)
returns sysname
as 

begin

declare @kolonne sysname

select @kolonne = y.kolonne from 
(select top 1 * from 
			(
			select 'Uned' as kolonne, 0.00000 as værdi, 0 as prioritet
							union all
			select 'Lang' as kolonne, isnull(@Langnedskrpct, 0.00000) as værdi, 1 as prioritet
							union all
			select 'Rækk' as kolonne, isnull(@Raekkenedskrpct, 0.00000) as værdi, 2 as prioritet
							union all
			select 'Litr' as kolonne, isnull(@Litranedskrpct, 0.00000) as værdi, 3 as prioritet
							union all
			select 'Stat' as kolonne, isnull(@statusnedskrpct, 0.00000) as værdi, 4 as prioritet			
			) as X
 order by x.værdi , x.prioritet
)y				
				
return @kolonne

end