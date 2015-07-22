CREATE procedure [etl].[ABM_Load_ABC_data_ABM_Assignment] @model varchar(50), @period varchar(50), @scenario varchar(50)
as
begin

-- Pakke variable
DECLARE @return_value INT
DECLARE @Objekt_Type CHAR(1)
DECLARE @Objekt_Navn VARCHAR(50)
DECLARE @Meddelelse VARCHAR(500)
SET @Objekt_Type = 'P'
SET @Objekt_Navn = 'etl.ABM_Load_ABC_data_ABM_Accounts'

BEGIN TRY


  DECLARE @tabel_navn varchar(100)
  DECLARE @SQL_command varchar(1000)
  DECLARE table_cursor_sdl CURSOR LOCAL FAST_FORWARD FOR
  select * from [etl].[ABM_Lookup_Source_Tables](@model, 'SDL')
  DECLARE table_cursor_dr CURSOR LOCAL FAST_FORWARD FOR
  select * from [etl].[ABM_Lookup_Source_Tables](@model, 'DR')

  --Opret temp tabeller
  if object_id('tempdb..#t_SDL', 'u') is not null drop table #t_SDL
  CREATE TABLE #t_SDL(
	  [SourceReference] [varchar](50) NOT NULL,
	  [SourceModuleType] [varchar](50) NOT NULL,
	  [DriverName] [varchar](50) NULL,
	  [Comments] [varchar](255) NULL,
	  [DocRef] [varchar](50) NULL
  )

  if object_id('tempdb..#t_DR', 'u') is not null drop table #t_DR
  CREATE TABLE #t_DR(
	  [DriverName] [varchar](50) NOT NULL,
	  [DestModuleType] [varchar](50) NOT NULL,
	  [DestReference] [varchar](50) NOT NULL,
	  [DriverQuantityFixed] [float] NULL,
	  [DriverWeightFixed] [float] NULL)


  -- Indlæs SDL til temp tabel
  OPEN table_cursor_sdl
  FETCH NEXT FROM table_cursor_sdl INTO @tabel_navn
  while @@FETCH_STATUS = 0
  begin
   
    set @SQL_command = 
    'INSERT INTO #t_SDL ([SourceReference], [SourceModuleType], [DriverName], [Comments], [DocRef])
     select SourceReference, SourceModuleType, DriverName, Comments, DocRef 
     FROM ' + @tabel_navn +
   ' WHERE Periode = ''' + @period + ''''
    execute (@SQL_command)

  
    FETCH NEXT FROM table_cursor_sdl INTO @tabel_navn
  end

  CLOSE table_cursor_sdl   
  DEALLOCATE table_cursor_sdl


  -- Indlæs DR til temp tabel
  OPEN table_cursor_dr
  FETCH NEXT FROM table_cursor_dr INTO @tabel_navn
  while @@FETCH_STATUS = 0
  begin
  
    set @SQL_command = 
    'INSERT INTO #t_DR (DriverName, DestModuleType, DestReference, DriverQuantityFixed, DriverWeightFixed)
     select DriverName, DestModuleType, DestReference, DriverQuantityFixed, DriverWeightFixed 
     FROM ' + @tabel_navn +
   ' WHERE Periode = ''' + @period + ''''
    execute (@SQL_command)
    
    FETCH NEXT FROM table_cursor_dr INTO @tabel_navn
  end

  CLOSE table_cursor_dr   
  DEALLOCATE table_cursor_dr

  insert into dbo.ABM_Assignment (Delmodel, Period, Scenario, SourceModuleType, SourceReference, DestinationModuleType,
  DestinationReference, DriverName, DriverQuantityFixed, SourceDimRef1, SourceDimMemberRef1,
  DestinationDimRef1, DestinationDimMemberRef1)
  select @model, @period, @scenario, SDL.SourceModuleType, SDL.SourceReference, DR.DestModuleType, DR.DestReference,
    SDL.DriverName, DR.DriverQuantityFixed, SDL.SourceModuleType, SDL.SourceReference, DR.DestModuleType, DR.DestReference
  from #t_SDL SDL
  inner join #t_DR DR on (DR.DriverName=SDL.DriverName)


  DECLARE table_cursor_ea CURSOR FOR
  select * from [etl].[ABM_Lookup_Source_Tables](@model, 'EA')


  -- Indlæs EA til ABM_Assignment
  OPEN table_cursor_ea
  FETCH NEXT FROM table_cursor_ea INTO @tabel_navn
  while @@FETCH_STATUS = 0
  begin
  
    set @SQL_command = 
    'insert into dbo.ABM_Assignment (Delmodel, Period, Scenario, SourceModuleType, SourceReference,
     DestinationModuleType, DestinationReference, DriverName, SourceDimRef1, SourceDimMemberRef1,
     DestinationDimRef1, DestinationDimMemberRef1)
     select ''' + @model + ''', ''' + @period + ''', ''' + @scenario + ''', SourceModuleType, SourceReference,
     DestModuleType, DestReference, ''Evenly Assigned'', SourceModuleType, SourceReference,
     DestModuleType, DestReference
     FROM ' + @tabel_navn +
   ' WHERE Periode = ''' + @period + ''''
    execute (@SQL_command)
    
    FETCH NEXT FROM table_cursor_ea INTO @tabel_navn
  end

  CLOSE table_cursor_ea   
  DEALLOCATE table_cursor_ea


  -- Indsæt i Key tabel
  set @SQL_command = 
  'INSERT INTO dbo.ABM_Key_Assignment (Delmodel, Period, Scenario, SourceModuleType, SourceReference, 
    DestinationModuleType, DestinationReference, DriverName, DriverQuantityFixed, SourceDimRef1, SourceDimMemberRef1,
    DestinationDimRef1, DestinationDimMemberRef1)
   SELECT Delmodel, Period, Scenario, SourceModuleType, SourceReference, DestinationModuleType,
    DestinationReference, DriverName, DriverQuantityFixed, SourceDimRef1, SourceDimMemberRef1,
    DestinationDimRef1, DestinationDimMemberRef1
   FROM dbo.ABM_Assignment
   WHERE Period = ''' + @period + '''
   AND Delmodel = ''' + @model + ''''
  execute (@SQL_command)


SET @return_value = 0

END TRY


BEGIN CATCH
  
  -- Logging
  SET @Meddelelse = 'MS Fejl: ' + CONVERT(VARCHAR, ERROR_NUMBER()) + ', ' + ERROR_MESSAGE()
  EXEC etl.Log_Besked @Objekt_Type, @Objekt_Navn, 'E',  @Meddelelse

  IF CURSOR_STATUS('global','table_cursor_sdl')>=-1
  BEGIN
    DEALLOCATE table_cursor_sdl
  END

  IF CURSOR_STATUS('global','table_cursor_dr')>=-1
  BEGIN
    DEALLOCATE table_cursor_dr
  END


  SET @return_value = 1
END CATCH;

RETURN @return_value

end