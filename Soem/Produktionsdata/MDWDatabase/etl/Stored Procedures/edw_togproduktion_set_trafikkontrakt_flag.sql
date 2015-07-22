
/********************************************************************
Author:		Thomas
Create date: 25/9-2013
Description:	
Denne procedure skal på sigt laves som en SSIS pakke.

Flaget erTrafikkontraktProduktion sættes hvis mindst ét af følgende kriterier er opfyldt

1. Kontrakt operatør er DSB og område er indland.
2. Togkategori er BH
3. Ikke retningsbestemt strækning er "Flensborg-Padborg Grænse", område er udland og 
   produkt er InterCity

********************************************************************/
CREATE PROCEDURE [etl].[edw_togproduktion_set_trafikkontrakt_flag] 

AS
BEGIN
	SET NOCOUNT ON;

    declare @periode varchar(6)

    Select @periode = Value
    from ods.ctl_dataload
    Where kilde_system = 'protal'
    and variable = 'Load_Period'
    
    update edw.FT_Togproduktion_Litra set erTrafikkontraktProduktion = 1
    where fk_di_tid in (
      select reference from edw.di_tid
      where parentReference = @periode)
    and Kontraktoperatoer = 'DSB'
    and Omraadeland = 'Indland'

    update edw.FT_Togproduktion_Litra set erTrafikkontraktProduktion = 1
    where fk_di_tid in (
      select reference from edw.di_tid
      where parentReference = @periode)
    and togkategori = 'BH'
    
    update edw.FT_Togproduktion_Litra set erTrafikkontraktProduktion = 1
    where fk_di_tid in (
      select reference from edw.di_tid
      where parentReference = @periode)
    and FK_DI_Togsystem in (
      select PK_DI_Togsystem from edw.di_togsystem
      where Produkt = 'InterCity')
    and ikkeRetningsbestemtStrk Like 'Flensborg-Padborg Grænse'
    and Omraadeland = 'Udland'




    update edw.FT_Togproduktion_Tog set erTrafikkontraktProduktion = 1
    where fk_di_tid in (
      select reference from edw.di_tid
      where parentReference = @periode)
    and Kontraktoperatoer = 'DSB'
    and Omraadeland = 'Indland'

    update edw.FT_Togproduktion_Tog set erTrafikkontraktProduktion = 1
    where fk_di_tid in (
      select reference from edw.di_tid
      where parentReference = @periode)
    and togkategori = 'BH'
    
    update edw.FT_Togproduktion_Tog set erTrafikkontraktProduktion = 1
    where fk_di_tid in (
      select reference from edw.di_tid
      where parentReference = @periode)
    and FK_DI_Togsystem in (
      select PK_DI_Togsystem from edw.di_togsystem
      where Produkt = 'InterCity')
    and ikkeRetningsbestemtStrk Like 'Flensborg-Padborg Grænse'
    and Omraadeland = 'Udland'

    select @periode + ' Done'

END

