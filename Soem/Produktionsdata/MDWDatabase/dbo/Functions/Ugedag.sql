
CREATE function [dbo].[Ugedag](@date datetime) returns varchar(10)
as
begin
return case ((@@datefirst + datepart(dw, @date) - 2) % 7) when 0 then 'Mandag' when 1 then 'Tirsdag' when 2 then 'Onsdag' when 3 then 'Torsdag' when 4 then 'Fredag' when 5 then 'Lørdag' when 6 then 'Søndag' else 'KontaktDinFagforeningDag' end
end