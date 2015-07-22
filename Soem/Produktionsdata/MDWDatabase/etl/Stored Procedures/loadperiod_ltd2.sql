

	

CREATE proc [etl].[loadperiod_ltd2] @month datetime = null --default svarende til forrige måned --ellers angives specifik måned - x '2012-08-01'as 
as 
	begin
	if @month = '9999' 
	BEGIN
		select 'Nuværende værdier:' as [Ods.ctl_dataload],substring(Kilde_system,1,20) as Kilde, substring(Variable,1,20) as Variable, substring(Value,1,30) as Value 
		from ods.ctl_dataload where kilde_system like '%ltd2%' order by kilde_system, variable
		goto _end
	END

	declare @monthdate datetime
	declare @YYYYMM varchar(6)
	declare @DD_MM_YYYY varchar(10)
	

	if @month is null
	begin
		select @YYYYMM = value from ods.ctl_dataload  where kilde_system = 'alle' and variable = 'master_periode'
		if @yyyymm is null
		begin
				raiserror('Der blev ikke fundet en værdi for kilde_system = alle og variable = master_periode' ,1,16)
				return -1
		end
		else begin 
				set @monthdate = convert(datetime, @yyyymm+'01')
				set @DD_MM_YYYY = convert(varchar(10),@monthdate, 105)
			end
	end
	else 
	begin
		if 	@month =	dateadd(mm,datediff(mm,'1900', @month),'1900')-- tjekker om angivet dato er den første i en måned
		begin
			set @monthdate = @month
			set @DD_MM_YYYY = convert(varchar(10),@monthdate, 105)
			
		end
		else 
			begin
				set @monthdate = null
				raiserror('Den angivne dato er ikke den første i en måned. Loadperioden for ltd2 er derfor ikke opdateret.',1,16)
				return -1
			end
	end	
	--forberedelse af de mange forskellige formater
	
	select 'Førværdier:' as [ods.ctl_dataload ltd2],substring(Kilde_system,1,20) as Kilde, substring(Variable,1,20) as Variable, substring(Value,1,30) as Value, '' as Comment from ods.ctl_dataload where kilde_system like '%ltd2%' order by kilde_system, variable
	begin try 
	begin transaction
		update ods.ctl_dataload  set value = @DD_MM_YYYY where kilde_system = 'ltd2' and variable = 'Last_Period_Load'		
		select 'Efterværdier:' as [ods.ctl_dataload ltd2],substring(Kilde_system,1,20) as Kilde, substring(Variable,1,20) as Variable, substring(Value,1,30) as Value, case when @month is null and variable like '%Peri%' then 'Sat fra master_periode' else '' end as Comment from ods.ctl_dataload where kilde_system like '%ltd2%' order by kilde_system, variable
	commit transaction
	end try 
	begin catch 
		IF (XACT_STATE()) = -1
			rollback transaction
			raiserror('Fejl og rollback. Loadperioden for ltd2 er ikke opdateret.',1,16)
			
		IF  (XACT_STATE()) = 1
			commit transaction
	end catch
	_end:
	end