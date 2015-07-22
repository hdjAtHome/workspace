





/********************************************************************
Author:		Thomas
Create date: 6/11-2013
Description:
Denne procedure laver en mapningstabel til at opsplitte togproduktionsrækker for 
S-tog til litra rækker 

********************************************************************/
CREATE PROCEDURE [etl].[edw_TD_S_materiale_til_Litra_mapping] 

AS
BEGIN
  TRUNCATE TABLE [etl].[TD_S_materiale_til_Litra_mapping]
  
  SET NOCOUNT ON;
  -- Cursor Variables
  DECLARE @litra_type Varchar(50)
  DECLARE @antal_litra_type_SA int
  DECLARE @antal_litra_type_SE int
  DECLARE @Materielkategori Varchar(50)
  
  -- Variables
  DECLARE @Sequence int
  DECLARE @Pladser_SE int
  DECLARE @Pladser_SA int
  
  
  --Antal sæder for SE
  SELECT @Pladser_SE = Siddepladser from ods.MD_Stog_litra_typer
  WHERE Antal_litra_type_SE = 1
  AND Antal_litra_type_SA = 0
  
  --Antal sæder for SA
  SELECT @Pladser_SA = Siddepladser from ods.MD_Stog_litra_typer
  WHERE Antal_litra_type_SE = 0
  AND Antal_litra_type_SA = 1
  
  
  -- Detajle curser
  DECLARE det_cur CURSOR fast_forward FOR
  select CASE WHEN Antal_litra_type_SA > 0 THEN CONVERT(VARCHAR, Antal_litra_type_SA) + 'xSA'
       ELSE '' END + 
     CASE WHEN Antal_litra_type_SE > 0 and Antal_litra_type_SA > 0 THEN '+' + CONVERT(VARCHAR, Antal_litra_type_SE) + 'xSE'
       WHEN Antal_litra_type_SE > 0 and Antal_litra_type_SA = 0 THEN CONVERT(VARCHAR, Antal_litra_type_SE) + 'xSE'
     ELSE '' END as litra_type, antal_litra_type_SA, antal_litra_type_SE, 'Tog' Materielkategori
  from ods.MD_Stog_litra_typer;

  
  OPEN det_cur
  FETCH NEXT FROM det_cur INTO @litra_type, @antal_litra_type_SA, @antal_litra_type_SE, @Materielkategori;
    
  WHILE @@FETCH_STATUS = 0
  BEGIN
    SET @Sequence = 1
    --SELECT @litra_type, @antal_litra_type_SA, @antal_litra_type_SE, @Materielkategori;
    WHILE @antal_litra_type_SA > 0
    BEGIN
      insert into [etl].[TD_S_materiale_til_Litra_mapping] (litra_type, litra_sekvens, Pladser, Materielkategori)
      values (@litra_type, @Sequence, @Pladser_SA, @Materielkategori)
      
      SET @antal_litra_type_SA = @antal_litra_type_SA-1;
      SET @Sequence = @Sequence + 1;
      
    END
    
    WHILE @antal_litra_type_SE > 0
    BEGIN
      insert into [etl].[TD_S_materiale_til_Litra_mapping] (litra_type, litra_sekvens, Pladser, Materielkategori)
      values (@litra_type, @Sequence, @Pladser_SE, @Materielkategori)
      
      SET @antal_litra_type_SE = @antal_litra_type_SE-1;
      SET @Sequence = @Sequence + 1;
      
    END
    
    FETCH NEXT FROM det_cur INTO @litra_type, @antal_litra_type_SA, @antal_litra_type_SE, @Materielkategori;    
    
  END

  CLOSE det_cur
  DEALLOCATE det_cur
  
  --Husk Bussen
  insert into [etl].[TD_S_materiale_til_Litra_mapping] (litra_type, litra_sekvens, Pladser, Materielkategori)
  values ('Bus', 1, 0, 'Bus')
  
  -- Husk ingen
  insert into [etl].[TD_S_materiale_til_Litra_mapping] (litra_type, litra_sekvens, Pladser, Materielkategori)
  values ('Ingen', 1, 0, 'Tog')
    
END