
/********************************************************************
Author:		Thomas
Create date: 6/-2013
Description:
Denne procedure tilføjer tidsintervaller til togproduktion_s_tog	

Denne procedure skal på sigt laves som en SSIS pakke.

********************************************************************/
CREATE PROCEDURE [etl].[edw_togproduktion_s_tog_set_tidsinterval] 

AS
BEGIN
  SET NOCOUNT ON;

  -- Tidsinterval update
  update edw.FT_Togproduktion_S_Tog set DI_Tidsintervaller = Case WHEN pf.prioritet < pt.prioritet THEN pf.prioritet ElSE pt.prioritet END
  from edw.FT_Togproduktion_S_Tog s
  join [edw].[MD_Tid_Konverter_Interval_Definitioner] pf on (pf.Dagugen_num = CASE when dbo.getIsDanishHolyDay(s.afgang) = 0 THEN dbo.UgedagNummer(s.afgang) ELSE 7 END
                                                         and pf.time = datepart(hh,s.afgang))
  join [edw].[MD_Tid_Konverter_Interval_Definitioner] pt on (pt.Dagugen_num = CASE when dbo.getIsDanishHolyDay(s.ankomst) = 0 THEN dbo.UgedagNummer(s.ankomst) ELSE 7 END
                                                     and pt.time = datepart(hh,s.ankomst))
  -- Indlæst Periode kun 
  where s.di_tid in (select reference from edw.di_tid
  where parentreference in (
    Select value from ods.ctl_dataload
    Where kilde_system = 'S-tog'))
  and pf.interval_header_id = 3
  and pt.interval_header_id = 3
END