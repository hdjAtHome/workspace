CREATE view dbo.vKalender
as 
select År, Måned, HverdagImåneden, HverdageIMånedHertil, Dag, Dato, Ugedagnavn  from dbo.kalender ('20150101', '20170101')