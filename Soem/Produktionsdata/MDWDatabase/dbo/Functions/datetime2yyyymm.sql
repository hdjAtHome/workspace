
create function [dbo].[datetime2yyyymm]
(
	@DATE			datetime
)
returns		varchar(6)
as
begin

	return convert(varchar(6), @date, 112)

end

