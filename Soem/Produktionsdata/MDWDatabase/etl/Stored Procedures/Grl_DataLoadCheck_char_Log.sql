
create procedure [etl].[Grl_DataLoadCheck_char_Log](
    @DataLoadCheck_Element int,
    @Period_char varchar(8),
    @Vaerdi decimal(24,6))
AS

BEGIN
  SET NOCOUNT ON;
  DECLARE @Period int
  SELECT  @Period = convert(int, @Period_char)

  exec etl.Grl_DataLoadCheck_Log @DataLoadCheck_Element, @Period, @Vaerdi

  SET NOCOUNT OFF;
END

