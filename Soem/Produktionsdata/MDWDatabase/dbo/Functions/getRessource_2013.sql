create function [dbo].[getRessource_2013] (@level char(1), @col1  varchar(20) = null, @col2 varchar(20) = null, @col3 varchar(20) = null, @col4 varchar(20) = null, @col5 varchar(20)= null, @col6 varchar(20) = null)
returns varchar(20) 
as begin 
	
	return case when substring(@col1, 1, 2) = 'R'+@level then @col1
				when substring(@col2, 1, 2) = 'R'+@level then @col2
				else null
	end
end