CREATE PROCEDURE [etl].[ABM_Load_ABC_data_ABM_DimensionMember] @model VARCHAR(50), @period VARCHAR(50), @scenario VARCHAR(50)
AS
BEGIN



-- Pakke variable
DECLARE @return_value INT
DECLARE @Objekt_Type CHAR(1)
DECLARE @Objekt_Navn VARCHAR(50)
DECLARE @Meddelelse VARCHAR(500)
SET @Objekt_Type = 'P'
SET @Objekt_Navn = 'etl.ABM_Load_ABC_data_ABM_DimensionMember'

BEGIN TRY


DECLARE @tabel_navn varchar(100)
DECLARE @SQL_command varchar(1000)
DECLARE table_cursor_ATTHIER CURSOR LOCAL FAST_FORWARD FOR
select * from [etl].[ABM_Lookup_Source_Tables](@model, 'ATTHIER')

OPEN table_cursor_ATTHIER
FETCH NEXT FROM table_cursor_ATTHIER INTO @tabel_navn
while @@FETCH_STATUS = 0
begin
  
  set @SQL_command = 
  'INSERT INTO dbo.ABM_DimensionMember_UdenSort (Delmodel, DimRef, Reference, Name, ParentReference)
   SELECT ''' + @model + ''', AttributeDimension, AttributeReference, AttributeName, AttributeParentReference
   FROM ' + @tabel_navn +
 ' WHERE Periode = ''' + @period + ''''
  execute (@SQL_command)

  
  FETCH NEXT FROM table_cursor_ATTHIER INTO @tabel_navn
end

CLOSE table_cursor_ATTHIER   
DEALLOCATE table_cursor_ATTHIER

-- UNIT
DECLARE table_cursor_UNIT CURSOR LOCAL FAST_FORWARD FOR
select * from [etl].[ABM_Lookup_Source_Tables](@model, 'UNIT')

OPEN table_cursor_UNIT
FETCH NEXT FROM table_cursor_UNIT INTO @tabel_navn
while @@FETCH_STATUS = 0
begin
  
  set @SQL_command = 
  'INSERT INTO dbo.ABM_DimensionMember_UdenSort (Delmodel, DimRef, Reference, Name, ParentReference)
   SELECT ''' + @model + ''', ''MængdeEnhed'', UnitLabel, UnitLabel, NULL
   FROM ' + @tabel_navn +
 ' WHERE Periode = ''' + @period + '''
   GROUP BY UnitLabel'
  execute (@SQL_command)

  
  FETCH NEXT FROM table_cursor_UNIT INTO @tabel_navn
end

CLOSE table_cursor_UNIT   
DEALLOCATE table_cursor_UNIT

-- ACC
DECLARE table_cursor_ACC CURSOR LOCAL FAST_FORWARD FOR
select * from [etl].[ABM_Lookup_Source_Tables](@model, 'ACC')

OPEN table_cursor_ACC
FETCH NEXT FROM table_cursor_ACC INTO @tabel_navn
while @@FETCH_STATUS = 0
begin
  
  set @SQL_command = 
  'INSERT INTO dbo.ABM_DimensionMember_UdenSort (Delmodel, DimRef, Reference, Name, ParentReference)
   SELECT ''' + @model + ''', ModuleType, Reference, Name, ParentReference
   FROM ' + @tabel_navn +
 ' WHERE Periode = ''' + @period + ''''
  execute (@SQL_command)

  
  FETCH NEXT FROM table_cursor_ACC INTO @tabel_navn
end

CLOSE table_cursor_ACC   
DEALLOCATE table_cursor_ACC

-- HIER
DECLARE table_cursor_HIER CURSOR LOCAL FAST_FORWARD FOR
select * from [etl].[ABM_Lookup_Source_Tables](@model, 'HIER')

OPEN table_cursor_HIER
FETCH NEXT FROM table_cursor_HIER INTO @tabel_navn
while @@FETCH_STATUS = 0
begin
  
  set @SQL_command = 
  'INSERT INTO dbo.ABM_DimensionMember_UdenSort (Delmodel, DimRef, Reference, Name, ParentReference)
   SELECT ''' + @model + ''', ModuleType, Reference, Name, ParentReference
   FROM ' + @tabel_navn +
 ' WHERE Periode = ''' + @period + ''''
  execute (@SQL_command)

  
  FETCH NEXT FROM table_cursor_HIER INTO @tabel_navn
end

CLOSE table_cursor_HIER   
DEALLOCATE table_cursor_HIER

-- Indsæt i Key tabel
set @SQL_command = 
'INSERT INTO dbo.ABM_KEY_DimensionMember_UdenSort (Delmodel, DimRef, Reference, Name, ParentReference)
 SELECT Delmodel, DimRef, Reference, Name, ParentReference
 FROM dbo.ABM_DimensionMember_UdenSort
 WHERE Delmodel = ''' + @model + ''''
execute (@SQL_command)

SET @return_value = 0

END TRY


BEGIN CATCH
  -- Logging
  SET @Meddelelse = 'MS Fejl: ' + CONVERT(VARCHAR, ERROR_NUMBER()) + ', ' + ERROR_MESSAGE()
  EXEC etl.Log_Besked @Objekt_Type, @Objekt_Navn, 'E',  @Meddelelse

  IF CURSOR_STATUS('LOCAL','table_cursor_ATTHIER')>=-1
  BEGIN
    DEALLOCATE table_cursor
  END

  IF CURSOR_STATUS('LOCAL','table_cursor_UNIT')>=-1
  BEGIN
    DEALLOCATE table_cursor
  END

  IF CURSOR_STATUS('LOCAL','table_cursor_ACC')>=-1
  BEGIN
    DEALLOCATE table_cursor
  END

  IF CURSOR_STATUS('LOCAL','table_cursor_HIER')>=-1
  BEGIN
    DEALLOCATE table_cursor
  END

  SET @return_value = 1
END CATCH;


RETURN @return_value


END