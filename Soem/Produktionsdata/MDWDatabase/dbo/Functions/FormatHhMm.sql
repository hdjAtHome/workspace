
CREATE function [dbo].[FormatHhMm] (@tidspunkt varchar(max))
returns varchar(5)
as 
begin
	declare @resultat varchar(5)
	--@tidspunkt skal være formateret som h:mm eller hh:mm eller h:m eller hh:m eller hhmm eller hmm eller mm eller m 
	--Der returneres hh:mm
	if len(@tidspunkt)> 2 
		begin
			if substring(@tidspunkt,len(@tidspunkt)-1,1) = ':' --h:m eller hh:m
			and isnumeric(substring(@tidspunkt,len(@tidspunkt),1))=1 --tjek m
				set @tidspunkt = substring(@tidspunkt,1,len(@tidspunkt)-1) +'0'+substring(@tidspunkt,len(@tidspunkt),1)
		end	
	if	len(@tidspunkt) in (4,5)
		and isnumeric(substring(@tidspunkt,len(@tidspunkt)-1,2))=1 --tjek mm
		and substring(@tidspunkt,len(@tidspunkt)-2,1) = ':' -- tjek :
		and isnumeric(substring(@tidspunkt,1,len(@tidspunkt)-3))=1 --tjek h eller hh
		set @resultat = case when len(@tidspunkt) = 4 then '0'+ @tidspunkt else @tidspunkt end--set resultat = h eller hh
	else
	if len (@tidspunkt) = 3 and isnumeric(@tidspunkt) = 1
		set @resultat = '0'+substring(@tidspunkt, 1, 1)+':'+substring(@tidspunkt, 2,2)
	else	
	if len (@tidspunkt) = 4 and isnumeric(@tidspunkt) = 1
		set @resultat = substring(@tidspunkt, 1, 2)+':'+substring(@tidspunkt, 3,2)
	else	
	if len (@tidspunkt) = 2 and isnumeric(@tidspunkt) = 1
		set @resultat = '00'+':'+@tidspunkt
	else
	if len (@tidspunkt) = 1 and isnumeric(@tidspunkt) = 1
		set @resultat = '00:0'+@tidspunkt
	else 
		set @resultat = null
	return @resultat
end

