
CREATE proc [ods].[TD_Togsystem_mapning_prc] @yyyymm varchar(6)
as
begin

set nocount on

if @yyyymm is null or len (@yyyymm) <> 6 return -1
declare @periodeSøgestreng varchar(7)
set @periodeSøgestreng = @yyyymm + '%'


delete from ods.TD_Togsystem_mapning where year(dato) = substring(@yyyymm,1,4) and month(dato) = substring(@yyyymm,5,2)

insert into ods.TD_Togsystem_mapning
	(Dato,
	Tognummer,
	Frastation,
	Tilstation,
	Fratidspunkt,
	Tiltidspunkt,
	Togsystem,
	Kilde)

select distinct 
	convert(datetime, fk_di_tid) as Dato,
	tognr,
	frastation,
	tilstation,
	[dbo].[LTDDatoOgTidspunktTilDatetime](convert(datetime, fk_di_tid),fratidspunkt,2),
	[dbo].[LTDDatoOgTidspunktTilDatetime](convert(datetime, fk_di_tid),tiltidspunkt,2),
	di.Togsystemnummer,
	'Direkte fra togproduktion facttabel'
from 
	edw.ft_togproduktion_tog ft
		left outer join 
	edw.di_togsystem di on ft.FK_DI_Togsystem = di.PK_DI_Togsystem
where 
	fk_di_tid like @periodeSøgestreng

/*Udfyld huller ved stop på stationer*/


declare @kilde varchar(50)
set @kilde = 'Etl - huller udfyldt'

if object_id('tempdb..#huller') is not null drop table #huller
create table #huller (
	dato datetime null
	,tognummer int null
	,frastation varchar(10) null
	,tilstation varchar(10) null
	,Fratidspunkt datetime null
	,Tiltidspunkt datetime null 
	,Togsystem int null
	)

declare c cursor fast_forward for 
	select dato, tognummer, frastation, tilstation, Fratidspunkt, Tiltidspunkt, togsystem 
	from ods.TD_Togsystem_mapning
	where year(dato) = substring(@yyyymm,1,4)
	order by dato, tognummer, Fratidspunkt, Tiltidspunkt

open c
declare 
	@dato varchar(20)
	,@tognummer int
	,@Fratidspunkt datetime
	,@Tiltidspunkt datetime
	,@frastation varchar(10)
	,@tilstation varchar(10)
	,@togsystem int

	,@old_dato varchar(20)
	,@old_tognummer int
	,@old_Fratidspunkt datetime
	,@old_Tiltidspunkt datetime
	,@old_frastation varchar(10)
	,@old_tilstation varchar(10)
	,@old_togsystem int

fetch next from c into @old_dato,@old_tognummer, @old_frastation, @old_tilstation, @old_Fratidspunkt, @old_Tiltidspunkt, @old_togsystem
while @@fetch_status = 0
begin
	fetch next from c into @dato,@tognummer, @frastation, @tilstation, @Fratidspunkt, @Tiltidspunkt, @togsystem
	if @old_dato <> @dato or @old_tognummer <> @tognummer goto _next
	else
	begin
		--print @old_Fratidspunkt + ' ' + @old_Tiltidspunkt
		--print @Fratidspunkt + ' ' + @Tiltidspunkt
		if @old_Tiltidspunkt < @Fratidspunkt
		insert into #huller 
		(
		dato
		,tognummer
		,frastation
		,tilstation
		,Fratidspunkt
		,Tiltidspunkt
		,Togsystem
		)
		values
		(@dato
		,@tognummer
		,@old_tilstation
		,@frastation
		,@old_Tiltidspunkt
		,@Fratidspunkt
		,@togsystem
		)
	end
	_next:
	set @old_dato =@dato
	set @old_tognummer = @tognummer
	set @old_frastation = @frastation
	set @old_tilstation = @tilstation
	set @old_Fratidspunkt = @Fratidspunkt
	set @old_Tiltidspunkt = @Tiltidspunkt
	set @old_togsystem = @togsystem
end
close c
deallocate c


--select dato,tognummer,frastation, tilstation,Fratidspunkt, Tiltidspunkt,  togsystem 
--from ods.TD_Togsystem_mapning where dato = '2012-02-01' order by dato, tognummer, frastation, tilstation, Fratidspunkt, Tiltidspunkt, togsystem 
insert into ods.TD_Togsystem_mapning
	(Dato,
	Tognummer,
	Frastation,
	Tilstation,
	Fratidspunkt,
	Tiltidspunkt,
	Togsystem,
	Kilde)
select 
	dato,
	tognummer,
	frastation, 
	tilstation,
	Fratidspunkt, 
	Tiltidspunkt,  
	Togsystem  , 
	@kilde
from #huller 


end

