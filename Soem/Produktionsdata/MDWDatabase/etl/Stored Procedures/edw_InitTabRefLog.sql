


CREATE PROCEDURE [etl].[edw_InitTabRefLog]
  @PackageLogID  INT
, @TableName     VARCHAR(100)
, @TypeRefresh   VARCHAR(20)
, @Period        VARCHAR(12)
, @NumRowsDel    INT
, @NameCtlColDel VARCHAR(30)
, @TotCtlColDel  DECIMAL(24,6)
 
AS
BEGIN
	--DECLARE @LastExtractDateTime	DATETIME

	SET NOCOUNT ON;
	
--	SELECT @LastExtractDateTime = ISNULL(MAX(LastExtractDateTime), '1900-01-01')
--	FROM etl.Edw_TabRefLog
--	WHERE TableName = @TableName
		

	INSERT INTO etl.Edw_TabRefLog (
	  PackageLogID
	, TableName
    , TypeRefresh
	, Period
	, NumRowsDel
    , NameCtlColDel
    , TotCtlColDel
	, StartTime
	)
	VALUES (
	  @PackageLogID
	, @TableName
    , @TypeRefresh
	, @Period
	, @NumRowsDel
    , @NameCtlColDel
    , @TotCtlColDel
	, GetDate()
	)

	SELECT 
	  CAST(Scope_Identity() AS INT) TabRefLogID
--	, CONVERT(NVARCHAR(23), @LastExtractDateTime, 121) LastExtractDateTimeString
	
	SET NOCOUNT OFF;
END


