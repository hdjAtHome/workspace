CREATE PROCEDURE [etl].[ABM_Load_ABC_data_ABM_CostElements_test] 
    @model VARCHAR(50), 
    @period VARCHAR(50), 
    @scenario VARCHAR(50)
AS
BEGIN

-- Pakke variable
DECLARE @return_value INT
DECLARE @Objekt_Type CHAR(1)
DECLARE @Objekt_Navn VARCHAR(50)
DECLARE @Meddelelse VARCHAR(500)
SET @Objekt_Type = 'P'
SET @Objekt_Navn = 'etl.ABM_Load_ABC_data_ABM_CostElements'

BEGIN TRY

DECLARE @tabel_navn VARCHAR(100)
DECLARE @SQL_command VARCHAR(1000)
DECLARE table_cursor CURSOR LOCAL FAST_FORWARD FOR
select * from [etl].[ABM_Lookup_Source_Tables](@model, 'CE')

OPEN table_cursor
FETCH NEXT FROM table_cursor INTO @tabel_navn
WHILE @@FETCH_STATUS = 0
BEGIN
  
  SET @SQL_command = 
  'INSERT INTO dbo.ABM_EnteredCostElement (Delmodel, Period, Scenario, Moduletype, AccountReference, Reference, Name, EnteredCost)
   SELECT ''' + @model + ''', ''' + @period + ''', ''' + @scenario + ''', ModuleType, AccountReference, Reference, Name, EnteredCost 
   FROM ' + @tabel_navn +
 ' WHERE Periode = ''' + @period + ''''
  print @SQL_command
  
  FETCH NEXT FROM table_cursor INTO @tabel_navn
END

CLOSE table_cursor   
DEALLOCATE table_cursor

-- Indsæt i Key tabel
SET @SQL_command = 
'INSERT INTO dbo.ABM_KEY_EnteredCostElement (Delmodel, Period, Scenario, Moduletype, AccountReference, Reference, Name, EnteredCost)
 SELECT Delmodel, Period, Scenario, Moduletype, AccountReference, Reference, Name, EnteredCost
 FROM dbo.ABM_EnteredCostElement
 WHERE Period = ''' + @period + '''
 AND Delmodel = ''' + @model + ''''
 print @SQL_command

SET @return_value = 0

END TRY


BEGIN CATCH
  -- Logging
  SET @Meddelelse = 'MS Fejl: ' + CONVERT(VARCHAR, ERROR_NUMBER()) + ', ' + ERROR_MESSAGE()
  EXEC etl.Log_Besked @Objekt_Type, @Objekt_Navn, 'E',  @Meddelelse

  IF CURSOR_STATUS('global','table_cursor')>=-1
  BEGIN
    DEALLOCATE table_cursor
  END

  SET @return_value = 1
END CATCH;

RETURN @return_value


END