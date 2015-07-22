create function [dbo].[getActivity_2013] (@level char(1), @col1  varchar(20) = null, @col2 varchar(20) = null, @col3 varchar(20) = null, @col4 varchar(20) = null, @col5 varchar(20)= null, @col6 varchar(20) = null)
returns varchar(20) 
as begin 
	
	return case when substring(@col1, 1, 2) = 'A'+@level then @col1
				when substring(@col2, 1, 2) = 'A'+@level then @col2
				when substring(@col3, 1, 2) = 'A'+@level then @col3
				when substring(@col4, 1, 2) = 'A'+@level then @col4
				when substring(@col5, 1, 2) = 'A'+@level then @col5
				when substring(@col6, 1, 2) = 'A'+@level then @col6
				else null
	end
end