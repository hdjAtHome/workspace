

CREATE function [dbo].[Hverdag](@date datetime) returns bit
as
begin
return case when dbo.getDayOfWeekMondayIsAlwaysOne(@date) < 6 and  dbo.getIsDanishHolyDay(@date) = 0 then 1 else 0 end
end