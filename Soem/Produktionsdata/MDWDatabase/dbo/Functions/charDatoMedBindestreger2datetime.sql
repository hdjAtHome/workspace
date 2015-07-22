
CREATE function [dbo].[charDatoMedBindestreger2datetime]
(
	@cd			varchar(10)
)
returns		datetime
as
begin
	
	declare	 @DATETIMEDATE	datetime
	if len(@cd) = 10 
	begin
		-- yyyy-mm-dd:	
		if	isnumeric(substring(@cd,1,4))=1 and substring(@cd,5,1) = '-' and isnumeric(substring(@cd,6,2))=1 and substring(@cd,8,1) = '-' and isnumeric(substring(@cd,9,2))=1
				SELECT  @DATETIMEDATE = CONVERT(DATETIME, @cd)
		else if
		-- mm-dd-yyyy:	
			isnumeric(substring(@cd,1,2))=1 and substring(@cd,3,1) = '-' and isnumeric(substring(@cd,4,2))=1 and substring(@cd,6,1) = '-' and isnumeric(substring(@cd,7,4))=1	
				SELECT  @DATETIMEDATE = CONVERT(DATETIME, substring(@cd,7,4)+'-'+substring(@cd,4,2)+'-'+substring(@cd,1,2))
	end
	return @DATETIMEDATE

end


