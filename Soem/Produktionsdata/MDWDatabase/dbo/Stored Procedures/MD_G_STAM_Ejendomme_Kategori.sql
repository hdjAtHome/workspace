


-- =============================================
-- Author:		Thomas B
-- Create date: 20141029
-- Description:	Returnere kategorien for en ejendom
-- =============================================
CREATE PROCEDURE [dbo].[MD_G_STAM_Ejendomme_Kategori] 
	@Alternativ Varchar(50),
	@Fredning Varchar(50),
	@Omkostningssted Varchar(50),
	@Branche Varchar(50),
	@Ejendom  Varchar(50),
	@BGV_Nr_Anlæg Varchar(50),
	@Benyttelsesart_UE Varchar(50),
	@Firmakode Varchar(50),
	@Status Varchar(50),
	@Kategori Varchar(50) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
    
    SET @Kategori=
      CASE 
        WHEN @Alternativ='Station' and @Fredning='X' THEN 'Station SL'
        WHEN @Alternativ='Station' THEN 'Station'
        WHEN SUBSTRING(@Omkostningssted, 1,3) = '711' THEN 'Kort&Godt'
        WHEN SUBSTRING(@Omkostningssted, 1,3) = '715' THEN 'DSB Ejendomsudvikling'
        WHEN SUBSTRING(@Omkostningssted, 1,3) = '718' THEN 'DSB S-tog'
        WHEN SUBSTRING(@Omkostningssted, 1,3) = '721' THEN 'DSB Vedligehold'
        WHEN SUBSTRING(@Branche, 1,6) = 'Museum' THEN 'Jernbanemuseum'
        WHEN SUBSTRING(@Omkostningssted, 1,3) = '706' THEN 'Koncernens lejemål'
        WHEN SUBSTRING(@Omkostningssted, 1,4) = '7761' THEN 'Koncernens lejemål'
        WHEN @Ejendom = 'GDT' THEN 'Koncernens lejemål'
        WHEN @BGV_Nr_Anlæg = 'GB_012' THEN 'Koncernens lejemål'
        WHEN SUBSTRING(@Omkostningssted, 1,4) = '7756' THEN 'F&R Klargøring'
        WHEN SUBSTRING(@Omkostningssted, 1,4) = '7758' THEN 'F&R Fremføring'
        WHEN SUBSTRING(@Omkostningssted, 1,4) = '7266' THEN 'F&R OBS'
        WHEN SUBSTRING(@Omkostningssted, 1,4) = '7227' THEN 'S&T'
        WHEN @Branche = 'Standsningsafgift' THEN 'Station'
        WHEN @Branche = 'Billet' THEN 'Station'
        WHEN SUBSTRING(@Firmakode, 1,2) = '18' THEN 'DSB S-tog'
        WHEN SUBSTRING(@Omkostningssted, 1,1) = '7' THEN 'Øvrige interne lejemål'
        WHEN @Status = 'Ekstern' THEN 'Øvrige eksterne lejemål'
        WHEN @Benyttelsesart_UE = 'Havelod' THEN 'Øvrige eksterne lejemål'
        ELSE 'Ikke Station'
      END
    
	
END



