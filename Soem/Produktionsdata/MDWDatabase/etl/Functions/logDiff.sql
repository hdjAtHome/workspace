

CREATE function [etl].[logDiff](@Source_System varchar(50))
returns table
as
return (
	
    --Med forskelle
select d.Source_System, d.Source_Gruppe, d.Check_Element, d.Vaerdi_type, d.Attribute, d.Period, d.Load_Instans,
    d.værdi, s.gennemsnit, 
    CASE WHEN ROUND(d.værdi - s.gennemsnit,0) <> 0 THEN 'JA' ELSE 'NEJ' END AS Afvigelse, 
	d.værdi-s.gennemsnit AS AfvigelseVærdi, 
((d.værdi-s.gennemsnit)*100)/(s.gennemsnit) as AfvigelseProcent
from (
select c.id, c.Source_System, c.Source_Gruppe, e.Check_Element, e.Vaerdi_type, e.Attribute, v.Period, e.Load_Instans,
    SUM(v.Vaerdi) værdi
From etl.Grl_DataLoadCheck_Vaerdi v
join etl.Grl_DataLoadCheck_Element e on (e.id = v.CheckElement_Id)
join etl.Grl_DataLoadCheck c on (c.id = e.DataLoadCheck_Id)
group by c.id, c.Source_System, c.Source_Gruppe, e.Check_Element, e.Vaerdi_type, e.Attribute, v.Period, e.Load_Instans) d
join (
select v.id, v.Check_Element, v.Vaerdi_type, v.Attribute, v.Period, count(*) antal,
   SUM(v.samlet) samlet, SUM(v.samlet)/(count(*)) gennemsnit
from (
select c.id, e.Check_Element, e.Vaerdi_type, e.Attribute, v.Period, e.Load_Instans, 
    SUM(v.Vaerdi) samlet
From etl.Grl_DataLoadCheck_Vaerdi v
join etl.Grl_DataLoadCheck_Element e on (e.id = v.CheckElement_Id)
join etl.Grl_DataLoadCheck c on (c.id = e.DataLoadCheck_Id)
group by c.id, e.Check_Element, e.Vaerdi_type, e.Attribute, v.Period, e.Load_Instans) v
group by v.id, v.Check_Element, v.Vaerdi_type, v.Attribute, v.Period) s 
    on (d.id = s.id
    and d.Check_Element = s.Check_Element
    and d.Vaerdi_type = s.Vaerdi_type
    and d.Attribute = s.Attribute
    and d.Period = s.Period)
--where d.Period = 201212
--and d.source_gruppe = 'Litra'
where d.Source_System like @Source_System)



