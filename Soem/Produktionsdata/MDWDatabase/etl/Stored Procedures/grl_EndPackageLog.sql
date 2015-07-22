

CREATE PROCEDURE [etl].[grl_EndPackageLog]
  @PackageLogID INT
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE etl.Grl_PackageLog SET
	  EndTime = GetDate()
	, Success = 1
	WHERE PackageLogID = @PackageLogID

	SET NOCOUNT OFF;
END

