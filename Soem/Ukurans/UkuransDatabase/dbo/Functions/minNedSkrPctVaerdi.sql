
create function [dbo].[minNedSkrPctVaerdi](@statusnedskrpct decimal(10,5), @langnedskrpct decimal(10,5), @raekkenedskrpct decimal(10,5), @litranedskrpct decimal(10,5))
returns decimal(10,5)
as 

begin

declare @værdi decimal(10,5)

select @værdi = y.værdi from 
(select top 1 * from 
			(
			select 'UdenNedskriv' as kolonne, 0.00000 as værdi, 0 as prioritet
							union all
			select 'Langnedskrpct' as kolonne, isnull(@Langnedskrpct, 0.00000) as værdi, 1 as prioritet
							union all
			select 'Raekkenedskrpct' as kolonne, isnull(@Raekkenedskrpct, 0.00000) as værdi, 2 as prioritet
							union all
			select 'Litranedskrpct' as kolonne, isnull(@Litranedskrpct, 0.00000) as værdi, 3 as prioritet
							union all
			select 'Statusnedskrpct' as kolonne, isnull(@statusnedskrpct, 0.00000) as værdi, 4 as prioritet			
			) as X
				order by x.værdi , x.prioritet 
) y				
				
return @værdi
end