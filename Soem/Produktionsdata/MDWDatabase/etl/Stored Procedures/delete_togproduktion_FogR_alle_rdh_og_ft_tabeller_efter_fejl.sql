create proc [etl].[delete_togproduktion_FogR_alle_rdh_og_ft_tabeller_efter_fejl] @periode varchar(6)
as 
begin

	if @periode is null or len(@periode) <> 6 return --hvis @periode er tom eller for kort vil deletes med where fk_di_tid like @periode + '%' kunne slette hele facttabellen
	declare @periodeDatetime datetime
	select @periodeDatetime = convert(datetime, @periode+'01')
	select @periode
	select @periodeDatetime

	delete from ODS.RDH_Baneafgifter where maaned = @periode
	delete from ods.RDH_Broafgifter where maaned = @periode
	delete from ods.RDH_Strkafgifter where maaned = @periode
	delete from ods.RDH_Togproduktion_Litra where year(@periodeDatetime) = year(dato) and month(@periodeDatetime) = month(dato)
	delete from ods.RDH_Togproduktion_Tog where AarMaaned = @periode
	delete from ods.RDH_Togstandsninger where maaned = @periode
	
	delete from edw.ft_togproduktion_afgifter where fk_di_tid like @periode+'%'
	delete from edw.ft_togproduktion_litra where fk_di_tid like @periode + '%'
	delete from edw.FT_Togproduktion_Tog where fk_di_tid like @periode + '%'
	delete from edw.FT_Togproduktion_Togstandsninger where fk_di_tid like @periode + '%'
	
	
end

