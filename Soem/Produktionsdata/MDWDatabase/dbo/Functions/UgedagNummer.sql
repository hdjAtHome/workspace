
CREATE function [dbo].[UgedagNummer](@date datetime) returns tinyint
as
begin
return case ((@@datefirst + datepart(dw, @date) - 2) % 7) when 0 then 1 when 1 then 2 when 2 then 3 when 3 then 4 when 4 then 5 when 5 then 6 when 6 then 7 else 0 end
end