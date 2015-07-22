

CREATE view [edw].[ft_togproduktion_tog_IssueId42] as
select d.tognr, d.FK_DI_Tidsintervaller, d.division, d.erTrafikkontraktProduktion, 
  CASE WHEN d.FK_DI_Togsystem = 6 THEN 29 ELSE d.FK_DI_Togsystem END As FK_DI_Togsystem, 
  d.FK_DI_Tid, d.togkm, d.togminutter
from edw.ft_togproduktion_tog d
join edw.DI_Tid t on (t.reference = d.FK_DI_Tid)
join -- Periode
(Select SUBSTRING(value,1,4) as År, CONVERT(Int, SUBSTRING(value,5,2)) as Måned , SUBSTRING(value,1,50) as Periode
 from ods.ctl_dataload
 Where kilde_system = 'Alle'
 and variable = 'Model_Periode') p on (t.Aar = p.År
                                      and t.MaanedNum <= p.måned)
where not (fk_di_togsystem = 5 and tognrinterval in ('3700-3799', '83700-83799'))