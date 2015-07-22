
CREATE proc [etl].[RD_RIM_Rejseindtaegter_togsystemer_beregn_for_loadperiode] @loadperiode varchar(6)
as 
begin
	declare @månedsnummer_loadperiode int
	declare @år_loadperiode int
	declare @seneste_periode varchar(6)
	declare @månedsnummer_senesteperiode int
	declare @år_senesteperiode int

	set @månedsnummer_loadperiode = month(convert(datetime, (@loadperiode+'01')))
	set @år_loadperiode = year(convert(datetime, (@loadperiode+'01')))
	select @seneste_periode = max(år) from ods.RD_RIM_Rejseindtaegter_togsystemer
	
	set @månedsnummer_senesteperiode = month(convert(datetime, (@seneste_periode+'01')))
	set @år_senesteperiode = year(convert(datetime, (@seneste_periode+'01')))
	
	if @loadperiode > @seneste_periode 
	
	begin 
		delete from ods.RD_RIM_Rejseindtaegter_togsystemer where år = @loadperiode
	
		insert into ods.RD_RIM_Rejseindtaegter_togsystemer
		select CostObjekt, Enhed, @loadperiode as År,  (Værdi/@månedsnummer_senesteperiode)*@månedsnummer_loadperiode  --del seneste måneds data med antal måneder og gang med månedsnummer for loadperioden at få en anslået værdi for år til dato for loadperioden
		from ods.RD_RIM_Rejseindtaegter_togsystemer
		where År = @seneste_periode
	end

end