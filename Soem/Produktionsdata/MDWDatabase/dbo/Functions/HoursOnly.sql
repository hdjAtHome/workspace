
CREATE function [dbo].[HoursOnly] (@tidspunkt varchar(max))
returns varchar(2)
as 
begin
	declare @resultat varchar(2)
	--@tidspunkt skal være formateret som h:mm eller hh:mm
	--Der returneres h eller hh
	if	len(@tidspunkt) in (4,5)
		and isnumeric(substring(@tidspunkt,len(@tidspunkt)-1,2))=1 --tjek mm
		and substring(@tidspunkt,len(@tidspunkt)-2,1) = ':' -- tjek :
		and isnumeric(substring(@tidspunkt,1,len(@tidspunkt)-3))=1 --tjek h eller hh
		set @resultat =  substring(@tidspunkt,1,len(@tidspunkt)-3) --set resultat = h eller hh
	else 
		set @resultat = null
	return @resultat
end
