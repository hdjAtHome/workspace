
CREATE function [etl].[ABM_Lookup_Source_Tables](@model varchar(50), @tabelType varchar(12))
returns @tableList table (table_name varchar(128))
as
begin
  
  declare @prefix varchar(128)
  -- '_' is a wildcard in a select like statement
  declare table_cur CURSOR FOR
  select replace(prefix, '_', '$') as prefix from dbo.MD_Styring_Konsolidering
  where delmodel = @model
  and tabelType = @tabelType;
  
  open table_cur
  FETCH NEXT FROM table_cur INTO @prefix
  WHILE @@FETCH_STATUS = 0   
  BEGIN 
  
    insert into @tableList
    select name from sysobjects
    where replace(name, '_', '$') like REPLACE(@prefix, '*', '%')
    and xtype = 'U'
    
    FETCH NEXT FROM table_cur INTO @prefix
  
  END
  CLOSE table_cur   
  DEALLOCATE table_cur
  
  return 
end