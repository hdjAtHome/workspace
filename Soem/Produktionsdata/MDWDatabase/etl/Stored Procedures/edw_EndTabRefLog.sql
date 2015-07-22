

CREATE PROCEDURE [etl].[edw_EndTabRefLog]
  @TabRefLogID INT
, @NumRows INT
, @RefColName_1  NVARCHAR(50)
, @RefColTot_1 DECIMAL(18,2)
, @RefColName_2  NVARCHAR(50)
, @RefColTot_2 DECIMAL(18,2)
, @RefColName_3  NVARCHAR(50)
, @RefColTot_3 DECIMAL(18,2)
, @RefColName_4  NVARCHAR(50)
, @RefColTot_4 DECIMAL(18,2)
, @RefColName_5  NVARCHAR(50)
, @RefColTot_5 DECIMAL(18,2)

AS
BEGIN
	SET NOCOUNT ON;

--	DECLARE @LastExtractDateTime DATETIME, @SQL NVARCHAR(255)
--	SELECT @SQL = N'SELECT @LastExtractDateTime = ISNULL(MAX(Timestamp), ''1900-01-01'') FROM ' + TableName FROM etl.edw_TabRefLog WHERE TabRefLogID = @TabRefLogID
--	EXEC sp_executeSQL @SQL, N'@LastExtractDateTime DATETIME OUTPUT', @LastExtractDateTime OUTPUT
	
	UPDATE etl.Edw_TabRefLog
	SET
	  EndTime = GetDate()
	, NumRows = @NumRows
    , RefColName_1 = @RefColName_1
    , RefColTot_1 = @RefColTot_1
    , RefColName_2 = @RefColName_2
    , RefColTot_2 = @RefColTot_2
    , RefColName_3 = @RefColName_3
    , RefColTot_3 = @RefColTot_3
    , RefColName_4 = @RefColName_4
    , RefColTot_4 = @RefColTot_4
    , RefColName_5 = @RefColName_5
    , RefColTot_5 = @RefColTot_5
--	, LastExtractDateTime = @LastExtractDateTime
	, Success = 1
	WHERE TabRefLogID = @TabRefLogID

	SET NOCOUNT OFF;
END

