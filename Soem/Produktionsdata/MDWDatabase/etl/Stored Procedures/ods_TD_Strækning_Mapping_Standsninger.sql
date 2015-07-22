



/********************************************************************
Author:		Thomas
Create date: 6/11-2013
Description:
Denne procedure tilføjer standsninger til togproduktion for S-tog
for den pågældende load periode 

Denne procedure skal på sigt laves som en SSIS pakke.

********************************************************************/
CREATE PROCEDURE [etl].[ods_TD_Strækning_Mapping_Standsninger] 

AS
BEGIN
  
  SET NOCOUNT ON;
  
  DELETE FROM ods.TD_Strækning_Mapping
  WHERE Kilde = 'Standsning';
  
  WITH stop_sql AS (
  select t.DI_Tid, t. tognr, t.DI_S_Straekning, t.DI_Tidsintervaller, t.DI_S_Doegn_Inddeling,
     t.Afgang, t.Ankomst, t.Frastation, t.tilstation, t.Aflyst, t.Kilde,
     ROW_NUMBER() OVER (ORDER BY t.DI_Tid, t.tognr, afgang) As rowno
  from ods.TD_Strækning_Mapping t
  where t.Kilde = 'Produktion'
  --and tognr = 23118
  )
  INSERT INTO ods.TD_Strækning_Mapping
  SELECT c.DI_Tid, c.DI_S_Straekning, c.DI_Tidsintervaller, DATEADD(ss, 1, p.Ankomst) AS Ankomst,
    DATEADD(ss, -1, c.Afgang) AS Afgang,  c.tognr, p.tilstation, c.Frastation, 'Standsning' AS Kilde, 
    Null AS Aflyst, c.DI_S_Doegn_Inddeling
  from stop_sql AS c
  LEFT OUTER JOIN stop_sql AS p ON (c.rowno-1 = p.rowno)
  WHERE p.tilstation = c.Frastation
  AND p.DI_Tid = c.DI_Tid
  and p.Tognr = c.Tognr;

    
  -- Tidsinterval update hvis ankomst og afgang har forskellig prioritet
  update ods.TD_Strækning_Mapping set DI_Tidsintervaller = Case WHEN pf.prioritet < pt.prioritet THEN pf.prioritet ElSE pt.prioritet END
  from ods.TD_Strækning_Mapping s
  join [edw].[MD_Tid_Konverter_Interval_Definitioner] pf on (pf.Dagugen_num = CASE when dbo.getIsDanishHolyDay(s.afgang) = 0 THEN dbo.UgedagNummer(s.afgang) ELSE 7 END
                                                         and pf.time = datepart(hh,s.afgang))
  join [edw].[MD_Tid_Konverter_Interval_Definitioner] pt on (pt.Dagugen_num = CASE when dbo.getIsDanishHolyDay(s.ankomst) = 0 THEN dbo.UgedagNummer(s.ankomst) ELSE 7 END
                                                     and pt.time = datepart(hh,s.ankomst))
  -- Indlæst Periode kun 
  where s.Kilde = 'Standsning'
  and pf.interval_header_id = 3
  and pt.interval_header_id = 3;

END