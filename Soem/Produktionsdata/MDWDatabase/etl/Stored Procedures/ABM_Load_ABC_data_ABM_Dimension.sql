CREATE procedure [etl].[ABM_Load_ABC_data_ABM_Dimension] @model varchar(50), @period varchar(50), @scenario varchar(50)
as
begin

-- Pakke variable
DECLARE @return_value INT
DECLARE @Objekt_Type CHAR(1)
DECLARE @Objekt_Navn VARCHAR(50)
DECLARE @Meddelelse VARCHAR(500)
SET @Objekt_Type = 'P'
SET @Objekt_Navn = 'etl.ABM_Load_ABC_data_ABM_Dimension'

BEGIN TRY


  DECLARE @tabel_navn varchar(100)
  DECLARE @SQL_command varchar(1000)
  DECLARE table_cursor CURSOR LOCAL FAST_FORWARD FOR
  select * from [etl].[ABM_Lookup_Source_Tables](@model, 'ATTHIER')
  
  --Opret temp tabel
  if object_id('tempdb..#t_AttributeDimension', 'u') is not null drop table #t_AttributeDimension
  CREATE TABLE #t_AttributeDimension(
	  AttributeDimension [varchar](50) NOT NULL
  )

  -- Indlæs SDL til temp tabel
  OPEN table_cursor
  FETCH NEXT FROM table_cursor INTO @tabel_navn
  while @@FETCH_STATUS = 0
  begin
   
    set @SQL_command = 
    'INSERT INTO #t_AttributeDimension (AttributeDimension)
     select AttributeDimension 
     FROM ' + @tabel_navn +
   ' WHERE Periode = ''' + @period + '''
     GROUP BY AttributeDimension'
    execute (@SQL_command)

  
    FETCH NEXT FROM table_cursor INTO @tabel_navn
  end

  CLOSE table_cursor   
  DEALLOCATE table_cursor

  --Indsæt template dimensioner
  INSERT INTO #t_AttributeDimension (AttributeDimension)
  select dimension from dbo.ABC_Template_Dimension

  insert into dbo.ABM_Dimension (Delmodel, Reference, Name)
  select @model, AttributeDimension, AttributeDimension
  from #t_AttributeDimension

  -- Indsæt i Key tabel
  set @SQL_command = 
  'INSERT INTO dbo.ABM_KEY_Dimension (Delmodel, Reference, Name)
   SELECT Delmodel, Reference, Name
   FROM dbo.ABM_Dimension
   WHERE Delmodel = ''' + @model + ''''
  execute (@SQL_command)

SET @return_value = 0

END TRY


BEGIN CATCH
  
  -- Logging
  SET @Meddelelse = 'MS Fejl: ' + CONVERT(VARCHAR, ERROR_NUMBER()) + ', ' + ERROR_MESSAGE()
  EXEC etl.Log_Besked @Objekt_Type, @Objekt_Navn, 'E',  @Meddelelse

  IF CURSOR_STATUS('global','table_cursor')>=-1
  BEGIN
    DEALLOCATE table_cursor_sdl
  END


  SET @return_value = 1
END CATCH;

RETURN @return_value

end