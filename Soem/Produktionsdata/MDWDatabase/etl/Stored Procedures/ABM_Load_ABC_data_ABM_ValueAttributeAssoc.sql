CREATE procedure [etl].[ABM_Load_ABC_data_ABM_ValueAttributeAssoc] @model varchar(50), @period varchar(50), @scenario varchar(50)
as
begin

-- Pakke variable
DECLARE @return_value INT
DECLARE @Objekt_Type CHAR(1)
DECLARE @Objekt_Navn VARCHAR(50)
DECLARE @Meddelelse VARCHAR(500)
SET @Objekt_Type = 'P'
SET @Objekt_Navn = 'etl.ABM_Load_ABC_data_ABM_ValueAttributeAssoc'

BEGIN TRY

  /*
  -- DEBUG
  -- Logging
  SET @Meddelelse = 'Model: ' + @model + ' Period: ' + @period + ' Scenario: ' + @scenario
  EXEC etl.Log_Besked @Objekt_Type, @Objekt_Navn, 'E',  @Meddelelse
  */
  

  DECLARE @tabel_navn varchar(100)
  DECLARE @SQL_command varchar(1000)
  DECLARE table_cursor_unit CURSOR LOCAL FAST_FORWARD FOR
  select * from [etl].[ABM_Lookup_Source_Tables](@model, 'UNIT')
  
  --Opret temp tabeller
  if object_id('tempdb..#t_UNIT', 'u') is not null drop table #t_UNIT
  CREATE TABLE #t_UNIT(
      AccountReference [varchar](50) NOT NULL,
      AccountModuleType [varchar](50) NOT NULL, 
      Unitlabel [varchar](50) NOT NULL, 
      UnitQuantity float
  )

  
  -- Indlæs UNIT til temp tabel
  OPEN table_cursor_unit
  FETCH NEXT FROM table_cursor_unit INTO @tabel_navn
  while @@FETCH_STATUS = 0
  begin
   
    set @SQL_command = 
    'INSERT INTO #t_UNIT (AccountReference, AccountModuleType, Unitlabel, UnitQuantity)
     select AccountReference, AccountModuleType, Unitlabel, UnitQuantity 
     FROM ' + @tabel_navn +
   ' WHERE Periode = ''' + @period + ''''
    execute (@SQL_command)
    
  
    FETCH NEXT FROM table_cursor_unit INTO @tabel_navn
  end

  CLOSE table_cursor_unit   
  DEALLOCATE table_cursor_unit


  insert into dbo.ABM_ValueAttributeAssociation (Delmodel, Period, Scenario, ItemModuleType, ItemReference,
     AttributeReference, Value, ItemDimRef1, ItemDimMemberRef1)
  select @model, @period, @scenario, u.AccountModuleType, ' ' ItemReference,  t.Reference, 
    CASE WHEN t.Reference = 'Enhedsomk' THEN '0' ELSE REPLACE(STR(u.UnitQuantity, 50,12), ' ', '') END AS Value, 
    u.AccountModuleType, AccountReference
  from #t_UNIT u
  inner join dbo.ABC_Template_VALATT t on (1=1)


  -- Indsæt i Key tabel
  set @SQL_command = 
  'INSERT INTO dbo.ABM_KEY_ValueAttributeAssoc (Delmodel, Period, Scenario, ItemModuleType, ItemReference,
     AttributeReference, Value, ItemDimRef1, ItemDimMemberRef1)
   SELECT Delmodel, Period, Scenario, ItemModuleType, ItemReference,
     AttributeReference, Value, ItemDimRef1, ItemDimMemberRef1
   FROM dbo.ABM_ValueAttributeAssociation
   WHERE Period = ''' + @period + '''
   AND Delmodel = ''' + @model + ''''
  execute (@SQL_command)

SET @return_value = 0

END TRY


BEGIN CATCH
  
  -- Logging
  SET @Meddelelse = 'MS Fejl: ' + CONVERT(VARCHAR, ERROR_NUMBER()) + ', ' + ERROR_MESSAGE()
  EXEC etl.Log_Besked @Objekt_Type, @Objekt_Navn, 'E',  @Meddelelse

  IF CURSOR_STATUS('LOCAL','table_cursor_unit')>=-1
  BEGIN
    DEALLOCATE table_cursor_unit
  END


  SET @return_value = 1
END CATCH;

RETURN @return_value

end