
CREATE function [dbo].[FjernForanstilledeNuller] (@tekst varchar(255))
returns varchar(8)
begin
--return reverse(@tekst)+'00000000'
	declare @result varchar(8)
	if isnumeric(@tekst) = 1 set @result = convert(varchar(255),convert(bigint,@tekst))
	else begin
		while left(@tekst,1) = '0' 
			begin 
				set @tekst = right(@tekst, len(@tekst)-1)
			end
			set @result = @tekst
		end
	
	return @result
end


