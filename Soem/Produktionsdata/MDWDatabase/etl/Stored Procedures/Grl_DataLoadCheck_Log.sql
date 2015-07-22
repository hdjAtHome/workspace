
create procedure [etl].[Grl_DataLoadCheck_Log](
    @DataLoadCheck_Element int,
    @Period int,
    @Vaerdi decimal(24,6))
AS

BEGIN
  SET NOCOUNT ON;
  DECLARE @id int

  select @id = ISNULL(MAX(id), -1) from etl.Grl_DataLoadCheck_Vaerdi
  where period = @Period
  and CheckElement_Id = @DataLoadCheck_Element

  IF @id = -1 
   INSERT INTO etl.Grl_DataLoadCheck_Vaerdi (
      CheckElement_Id, Period, Vaerdi, Tidsstempel)
   VALUES ( 
      @DataLoadCheck_Element, @Period, @Vaerdi, GETDATE())
  ELSE
   UPDATE etl.Grl_DataLoadCheck_Vaerdi SET Vaerdi = @Vaerdi, Tidsstempel = GETDATE()
   WHERE id = @id

  SET NOCOUNT OFF;
END

