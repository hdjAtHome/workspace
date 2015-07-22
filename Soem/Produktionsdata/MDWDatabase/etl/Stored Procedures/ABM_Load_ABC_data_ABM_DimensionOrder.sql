CREATE PROCEDURE [etl].[ABM_Load_ABC_data_ABM_DimensionOrder] 
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
SET @Objekt_Navn = 'etl.ABM_Load_ABC_data_ABM_DimensionOrder'

BEGIN TRY

  DECLARE @SQL_command VARCHAR(1000)

  
  SET @SQL_command = 
  'INSERT INTO dbo.ABM_DimensionOrder (Delmodel, ModuleType, SequenceNumber, Dimref)
   SELECT ''' + @model + ''', d.dimension, d.SequenceNumber, d.dimension 
   FROM dbo.ABC_Template_Dimension d 
   WHERE d.SequenceNumber > 0'
  EXECUTE (@SQL_command)
  

  -- Indsæt i Key tabel
  SET @SQL_command = 
  'INSERT INTO dbo.ABM_KEY_DimensionOrder (Delmodel, ModuleType, SequenceNumber, Dimref)
   SELECT Delmodel, ModuleType, SequenceNumber, Dimref
   FROM dbo.ABM_DimensionOrder
   WHERE Delmodel = ''' + @model + ''''
  EXECUTE (@SQL_command)

SET @return_value = 0

END TRY


BEGIN CATCH
  -- Logging
  SET @Meddelelse = 'MS Fejl: ' + CONVERT(VARCHAR, ERROR_NUMBER()) + ', ' + ERROR_MESSAGE()
  EXEC etl.Log_Besked @Objekt_Type, @Objekt_Navn, 'E',  @Meddelelse


  SET @return_value = 1
END CATCH;

RETURN @return_value


END