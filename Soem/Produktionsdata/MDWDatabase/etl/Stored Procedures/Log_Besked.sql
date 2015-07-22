CREATE PROCEDURE [etl].[Log_Besked] 
	@Objekt_Type CHAR(1),
    @Objekt_Navn VARCHAR(50),
    @Log_type CHAR(1),
    @Meddelelse VARCHAR(500)
AS
BEGIN
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    INSERT INTO dbo.LOG_Logging (Tidstempel, Objekt_Type, Objekt_Navn, Log_type, Meddelelse, Job_ID,
      Periode, DataSerie)
    SELECT getDate(), @Objekt_Type, @Objekt_Navn, @Log_type, @Meddelelse, Job_id, Periode, DataSerie 
    FROM dbo.MD_Kontrol_ModelLoadInfo
    
END