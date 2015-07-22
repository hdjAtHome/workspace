





CREATE PROCEDURE [etl].[ods_InitLoaderLog]
  @PackageLogID INT
, @TableName NVARCHAR(50)
, @SourceSystem NVARCHAR(50)

AS
BEGIN
	SET NOCOUNT ON;
	
		
	INSERT INTO etl.ods_LoaderLog (
	  PackageLogID
	, TableName
	, StartTime
    , SourceSystem
	)
	VALUES (
	  @PackageLogID
	, @TableName
	, GetDate()
    , @SourceSystem
	)

	SELECT 
	  CAST(Scope_Identity() AS INT) ExtractLogID 
	
	SET NOCOUNT OFF;
END





