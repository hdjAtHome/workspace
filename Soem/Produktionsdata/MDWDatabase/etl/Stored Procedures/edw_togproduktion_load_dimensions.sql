
CREATE proc [etl].[edw_togproduktion_load_dimensions]
as
begin

/* Load edw.DI_Loebestrk */

insert into edw.DI_Loebestrk
select f.* 
from 
(select Loebestrk, Loebestrk ls
from edw.FT_Togproduktion_Tog
union
select Loebestrk, Loebestrk ls
from edw.ft_togproduktion_litra
)  f
EXCEPT
select Loebestrk, Loebestrk ls
from edw.DI_Loebestrk
group by Loebestrk, Loebestrk


/* Load edw.DI_Tognr */

declare @timestamp datetime
select @timestamp = getdate()

if object_id('tempdb..#tognr','u') is not null
drop table #tognr

if object_id('tempdb..#nyetognr','u') is not null
drop table #nyetognr

select tognr 
into #tognr 
from edw.ft_togproduktion_litra
union
select tognr 
from  edw.ft_togproduktion_tog
order by tognr

select distinct tognr 
into #nyetognr
from #tognr 
except select Tognr
from edw.DI_Tognummer

insert into edw.di_tognummer (tognr, tognrinterval, timestamp)
select distinct 
	tognr, 
	convert(varchar(10),tognr - (tognr %100))+'-'+convert(varchar(10),tognr - (tognr %100) +99), 
	@timestamp  
from #nyetognr


/* Load edw.DI_Operatoer */

declare @loadperiode varchar(6)
select @loadperiode=value from ods.ctl_dataload where kilde_system = 'protal' and variable = 'Load_Period'


insert into edw.DI_Operatoer 
(Operatoer)
select Operatoer from (
select Kontraktoperatoer as Operatoer
from 
	edw.FT_Togproduktion_Litra
where 
	substring(fk_di_tid, 1, 6) = @loadperiode
	and Kontraktoperatoer not in
	(select operatoer from edw.DI_Operatoer)
union all
select Tekniskoperatoer  as Operatoer
from 
	edw.FT_Togproduktion_Litra
where 
	substring(fk_di_tid, 1, 6) = @loadperiode
	and Tekniskoperatoer not in
	(select operatoer from edw.DI_Operatoer)) o
group by o.Operatoer


/* Load edw.DI_Togkategori */

select @loadperiode=value from ods.ctl_dataload where kilde_system = 'protal' and variable = 'Load_Period'
insert into edw.DI_Togkategori 
(Togkat, 
TogkatBeskrivelse,
TogkatEjer,
Division,
Kontraktoperatoer,
Tekniskoperatoer)
select 
	Togkategori, 
	max(Togkategoribeskrivelse),
	max(Togkategoriejer),
	max(Division),
	max(Kontraktoperatoer),
	max(Tekniskoperatoer)
from 
	edw.FT_Togproduktion_Litra
where 
	substring(fk_di_tid, 1, 6) = @loadperiode
	and togkategori not in
	(select Togkat from edw.DI_Togkategori)
group by 
	Togkategori
	
	
insert into edw.DI_Togkategori 
(Togkat, 
TogkatBeskrivelse,
TogkatEjer,
Division,
Kontraktoperatoer,
Tekniskoperatoer)
select 
	Togkategori, 
	max(Togkategoribeskrivelse),
	max(Togkategoriejer),
	max(Division),
	max(Kontraktoperatoer),
	max(Tekniskoperatoer)
from 
	edw.FT_Togproduktion_tog
where 
	substring(fk_di_tid, 1, 6) = @loadperiode
	and togkategori not in
	(select Togkat from edw.DI_Togkategori)
group by 
	Togkategori
	
	


/* Load edw.DI_Lokation */

-- Litra
insert into edw.di_lokation
select q.Frastation + '-' + q.Tilstation, q.Frastation + '-' + q.Tilstation,
q.Frastation, q.Tilstation, @timestamp
from (
select distinct Frastation, Tilstation
from edw.FT_Togproduktion_Litra
EXCEPT
select StartStation, SlutStation
from edw.DI_Lokation
) q

-- Tog
insert into edw.di_lokation
select q.Frastation + '-' + q.Tilstation, q.Frastation + '-' + q.Tilstation,
q.Frastation, q.Tilstation, @timestamp
from (
select distinct Frastation, Tilstation
from edw.FT_Togproduktion_tog
EXCEPT
select StartStation, SlutStation
from edw.DI_Lokation
) q

--opdater edw.di_straekning
	Insert into edw.di_straekning (
		Straekningskode,
		Frastation,
		Frastation_Tekst,
		Tilstation,
		Tilstation_Tekst,
		Retningsbestemt_Straekning,
		Ikke_retningsbestemt_Straekning
	)
	SELECT  distinct
		Frastation+'-'+Tilstation, ---Straekningskode
		Frastation, ---Frastation
		substring(RetningsbestemtStrk,1,charindex('-',RetningsbestemtStrk)-1), --Tekst før bindestreg  ---Frastation_Tekst
		Tilstation,   ---Tilstation
		substring(RetningsbestemtStrk,charindex('-',RetningsbestemtStrk)+1,len(RetningsbestemtStrk)), --Tekst efter bindestreg  ---Tilstation_Tekst
		RetningsbestemtStrk,   ---Retningsbestemt_Straekning
		IkkeretningsbestemtStrk   ---Ikke_retningsbestemt_Straekning
	From
		edw.ft_togproduktion_litra
	Where 
		Frastation+'-'+Tilstation not in (select straekningskode from edw.di_straekning)
	
	Insert into edw.di_straekning (
		Straekningskode,
		Frastation,
		Frastation_Tekst,
		Tilstation,
		Tilstation_Tekst,
		Retningsbestemt_Straekning,
		Ikke_retningsbestemt_Straekning
	)
	SELECT  distinct
		Frastation+'-'+Tilstation, ---Straekningskode
		Frastation, ---Frastation
		substring(RetningsbestemtStrk,1,charindex('-',RetningsbestemtStrk)-1), --Tekst før bindestreg  ---Frastation_Tekst
		Tilstation,   ---Tilstation
		substring(RetningsbestemtStrk,charindex('-',RetningsbestemtStrk)+1,len(RetningsbestemtStrk)), --Tekst efter bindestreg  ---Tilstation_Tekst
		RetningsbestemtStrk,   ---Retningsbestemt_Straekning
		IkkeretningsbestemtStrk   ---Ikke_retningsbestemt_Straekning
	From
		edw.ft_togproduktion_tog
	Where 
		Frastation+'-'+Tilstation not in (select straekningskode from edw.di_straekning)
	


/* Load edw.DI_TogOmraade */

insert into edw.DI_TogOmraade
select Distinct Omraade, Omraadeland
from edw.FT_Togproduktion_Litra
group by Omraadeland, Omraade
EXCEPT
select Omraade, Omraadeland
from edw.DI_TogOmraade

/* Load edw.DI_Litra */



insert into 
edw.DI_Litra
	(Kode,
	Navn,
	MaterielTypel,
	Data_kilde,
	Timestamp)

select q.Litra, q.Litra, null,'PROTAL', @timestamp
from (
select Distinct Litra 
from edw.FT_Togproduktion_Litra
EXCEPT
select kode
from edw.di_litra
) q


update d 
set d.materieltypel = f.materieltype 
from 
	(select litra, 
		max(materieltype) as materieltype, 
		count(distinct materieltype) as unik 
		from edw.FT_Togproduktion_Litra 
		group by litra 
		having count(distinct materieltype) = 1  --materieltype kan kun updates når værdien er unik, set i forhold til litra
	) f
inner join 
	edw.di_litra d on f.litra = d.kode
where d.materieltypel is null


--update edw.di_litra
--set data_kilde = 'LTD'

/* Load edw.DI_Litra */

/*insert into edw.DI_Litra
select litra
from edw.FT_Togproduktion_litra
group by litra
EXCEPT
select Kode
from edw.DI_Litra
group by Kode*/

-- det mangler query til at tilføje litra attributes

/* Load edw.DI_Litra */

insert into edw.di_traekkraft
select distinct Traekkraft
from edw.FT_Togproduktion_Tog
EXCEPT
select Traekkraft
from edw.di_traekkraft

/* Load edw.DI_materiale */

-- Insæt rækker i DI_MATERIALE for manglende kombinationer af litra og loebenr. 
-- Der indsættes default værdier for litra'en taget fra tabellen  [mdw].[edw].[MD_Materiale_sidepladser_default]

if object_id('tempdb..#temp') is not null drop table #temp
select distinct Litra, loebenr 
into #temp 
from edw.FT_Togproduktion_Litra 
where CONVERT(varchar, loebenr) + '-' + Litra not in 
	(SELECT CONVERT(varchar, loebenr) + '-' + Litra AS MAT_ID FROM edw.DI_Materiale)
	
declare @loadperiod varchar(10) 
select @loadperiod = value+'01' from ods.CTL_Dataload where kilde_system = 'protal' and variable = 'load_period'

Insert into edw.di_materiale (
	[loebenr],
	[Nummer],
	[Antal],
	[Litra],
	[Type],
	[Variant],
	[Kaldenavn],
	[Egenavn],
	[AntalVogne],
	[Hastighed],
	[FasteSiddepladser],
	[Klapsæder],
	[SiddepladserTotal], 
	[Traktionssystem],
	[Ejerforhold],
	[BistroOgPantry],
	[Salgsautomater],
	[Greenspeed],
	[GodkendtTilTunnelkørsel],
	[Source],
	[Aktiv_fra],
	[Aktiv_til]
)

SELECT 
	 t.Loebenr,   ---loebenr
	 '-',   ---Nummer
	 -1,   ---Antal
	 t.[Litra],   ---Litra
	 d.[Litra_type],   ---Type
	 '-',   ---Variant
	 '-',   ---Kaldenavn
	 '-',   ---Egenavn
	 -1,   ---AntalVogne
	 -1,   ---Hastighed
	 -1,   ---FasteSiddepladser
	 -1,   ---Klapsæder
	 d.[antal pladser],   ---SiddepladserTotal
	 '-',   ---Traktionssystem
	 '-',   ---Ejerforhold
	 '-',   ---BistroOgPantry
	 '-',   ---Salgsautomater
	 '-',   ---Greenspeed
	 '-',   ---GodkendtTilTunnelkørsel
	 'Default værdier',   ---Source
	 convert(datetime, @loadperiod),   ---Aktiv_fra
	 null   ---Aktiv_til
From
	 [edw].[MD_Materiale_sidepladser_default] d
		inner join 
	#temp  t on d.litra = t.litra
	




end

