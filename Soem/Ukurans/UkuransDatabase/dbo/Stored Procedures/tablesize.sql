

CREATE proc [dbo].[tablesize] @schema sysname, @orderby varchar(20) = 'size'
as
begin
if @orderby <> 'name' 
begin
	select 
		s.name+'.'+o.name as Name,
		o.Create_date, 
		o.Modify_date ,
		8*SUM (reserved_page_count) as Reserved_KB,
		8*SUM (CASE WHEN (index_id < 2) THEN (in_row_data_page_count + lob_used_page_count + row_overflow_used_page_count) ELSE lob_used_page_count + row_overflow_used_page_count END)  as Data_KB,
		SUM (CASE WHEN (index_id < 2) THEN row_count ELSE 0 END) as Rows,
		1014*(8*SUM (CASE WHEN (index_id < 2) THEN (in_row_data_page_count + lob_used_page_count + row_overflow_used_page_count) ELSE lob_used_page_count + row_overflow_used_page_count END))
		/(SUM (CASE WHEN (index_id < 2) THEN row_count ELSE 0.1 END)) as Bytes_pr_row
		
	from 
		sys.objects o	
			inner join 
		sys.schemas s on o.schema_id = s.schema_id
			inner join
		sys.dm_db_partition_stats stat on o.object_id = stat.object_id
	where 
	--o.name like '%dirk_fact%' and
	s.name = @schema
	--and o.name = 'DI_Costobject'
	group by s.name, o.name, o.create_date,o.modify_date
	order by 8*SUM (CASE WHEN (index_id < 2) THEN (in_row_data_page_count + lob_used_page_count + row_overflow_used_page_count) ELSE lob_used_page_count + row_overflow_used_page_count END)   desc
end
else
begin
	select 
		s.name+'.'+o.name as Name,
		o.Create_date, 
		o.Modify_date ,
		8*SUM (reserved_page_count) as Reserved_KB,
		8*SUM (CASE WHEN (index_id < 2) THEN (in_row_data_page_count + lob_used_page_count + row_overflow_used_page_count) ELSE lob_used_page_count + row_overflow_used_page_count END)  as Data_KB,
		SUM (CASE WHEN (index_id < 2) THEN row_count ELSE 0 END) as Rows,
			1014*(8*SUM (CASE WHEN (index_id < 2) THEN (in_row_data_page_count + lob_used_page_count + row_overflow_used_page_count) ELSE lob_used_page_count + row_overflow_used_page_count END))
		/(SUM (CASE WHEN (index_id < 2) THEN row_count ELSE 0.1 END)) as Bytes_pr_row
	from 
		sys.objects o	
			inner join 
		sys.schemas s on o.schema_id = s.schema_id
			inner join
		sys.dm_db_partition_stats stat on o.object_id = stat.object_id
	where 
	--o.name like '%dirk_fact%' and
	s.name = @schema or @schema = '%'
	--and o.name = 'DI_Costobject'
	group by s.name, o.name, o.create_date,o.modify_date
	order by s.name, o.name

end

end