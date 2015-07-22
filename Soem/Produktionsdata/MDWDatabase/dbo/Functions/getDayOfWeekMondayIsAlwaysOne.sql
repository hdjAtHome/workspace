

create function [dbo].[getDayOfWeekMondayIsAlwaysOne](@date datetime) returns tinyint
as
begin
return ((@@datefirst + datepart(dw, @date) - 2) % 7)+1
end