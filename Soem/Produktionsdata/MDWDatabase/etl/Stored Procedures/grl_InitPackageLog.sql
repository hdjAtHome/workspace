


-- Insert a record in the PackageLog table
CREATE PROCEDURE [etl].[grl_InitPackageLog]
  @PackageName NVARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO etl.Grl_PackageLog (
	  PackageName
	, StartTime
	)
	VALUES (
	  @PackageName
	, GetDate()
	)

	SELECT CAST(Scope_Identity() AS INT) PackageLogID
END


