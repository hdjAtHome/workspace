create function [dbo].[getDayOfWeekMondayIsAlwaysZero](@date datetime) returns tinyint
as
begin
return ((@@datefirst + datepart(dw, @date) - 2) % 7)
end