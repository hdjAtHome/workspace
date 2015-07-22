


CREATE PROCEDURE [etl].[ods_EndLoaderLog]
  @LoaderLogID INT
, @Period VARCHAR(50)
, @CtlColRows INT
, @CtlColName_1 VARCHAR(50)
, @CtlColTot_1 DECIMAL(24,6)
, @CtlColName_2 VARCHAR(50)
, @CtlColTot_2 DECIMAL(24,6)
, @CtlColName_3 VARCHAR(50)
, @CtlColTot_3 DECIMAL(24,6)
, @CtlColName_4 VARCHAR(50)
, @CtlColTot_4 DECIMAL(24,6)

AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE etl.ods_LoaderLog
	SET
	  EndTime = GetDate()
    , MaxPeriod = @Period
	, NumRows = @CtlColRows
	, CtlColName_1 = @CtlColName_1	
	, CtlColTot_1 = @CtlColTot_1
    , CtlColName_2 = @CtlColName_2
    , CtlColTot_2 = @CtlColTot_2
    , CtlColName_3 = @CtlColName_3
    , CtlColTot_3 = @CtlColTot_3
    , CtlColName_4 = @CtlColName_4
    , CtlColTot_4 = @CtlColTot_4
	, Success = 1
	WHERE LoaderLogID = @LoaderLogID

	SET NOCOUNT OFF;
END


