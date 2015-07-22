
CREATE proc [etl].[RD_RIM_Rejseindtaegter_beregn_for_loadperiode] @loadperiode varchar(6)
as 
begin
	
	declare @seneste_periode varchar(6)
	
	select @seneste_periode = max([PeriodeIndlæst]) from ods.[RD_RIM_Rejseindtaegter]
	
	if @seneste_periode < @loadperiode	
	begin 
	
		insert into [ods].[RD_RIM_Rejseindtaegter]
		SELECT @loadperiode as [PeriodeIndlæst]
		      ,[Stationsnr]
		      ,[Stationsnavn]
		      ,[Stationstype]
		      ,[Landsdel]
		      ,[Togsystem]
		      ,[TogsystemNavn]
		      ,[CostObjekt]
		      ,[Produkt]
		      ,[TidsintervalNavn]
		      ,[Enhed]
		      ,[Værdi] As Værdi
		   FROM [ods].[RD_RIM_Rejseindtaegter]
		   where PeriodeIndlæst = @seneste_periode
			
	end

end