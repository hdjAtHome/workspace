
CREATE function [dbo].[LTDDatoOgTidspunktTilDatetime] (@dato datetime, @tidspunkt varchar(5) , @zone tinyint)
returns datetime
as 
begin
	declare @resultat datetime
	if @dato is not null and @tidspunkt is not null and @zone is not null 	
	begin	
		set @tidspunkt = dbo.formatHhMm(@tidspunkt)
		set @resultat =
			case @zone	when 2 then		dateadd(minute,	convert(int,substring(@tidspunkt, len(@tidspunkt)-1,2))		,dateadd( hh, convert(int,dbo.hoursonly(@tidspunkt)),@dato))
						when 3 then		dateadd(minute,	convert(int,substring(@tidspunkt, len(@tidspunkt)-1,2))		,dateadd( hh, convert(int,dbo.hoursonly(@tidspunkt))+24,@dato))--+':'+substring(@tidspunkt, len(@tidspunkt)-1,2)
						else null
			end
	end	
	return @resultat
end

