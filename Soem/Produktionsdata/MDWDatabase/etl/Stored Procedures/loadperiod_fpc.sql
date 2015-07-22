
CREATE proc [etl].[loadperiod_fpc] @month datetime = null --default svarende til forrige måned --ellers angives specifik måned - x '2012-08-01'as 
as 
	begin
	if @month = '9999' 
	BEGIN
		select 'Nuværende værdier:' as [Ods.ctl_dataload],substring(Kilde_system,1,20) as Kilde, substring(Variable,1,20) as Variable, substring(Value,1,30) as Value 
		from ods.ctl_dataload where kilde_system like '%fpc%' order by kilde_system, variable
		goto _end
	END

	declare @monthdate datetime
	declare @YYYYMM varchar(6)
	declare @M varchar(2)

	if @month is null
	begin
		select @YYYYMM = value from ods.ctl_dataload  where kilde_system = 'alle' and variable = 'master_periode'
		if @yyyymm is null
		begin
				raiserror('Der blev ikke fundet en værdi for kilde_system = alle og variable = master_periode' ,1,16)
				return -1
		end
		else set @monthdate = convert(datetime, @yyyymm+'01')
	end
	else 
	begin
		if 	@month =	dateadd(mm,datediff(mm,'1900', @month),'1900')-- tjekker om angivet dato er den første i en måned
		begin
			set @monthdate = @month
			set @YYYYMM = convert(varchar(6),@monthdate, 112)
		end
		else 
			begin
				set @monthdate = null
				raiserror('Den angivne dato er ikke den første i en måned. Loadperioden for fpc (HR_FTE) er derfor ikke opdateret.',1,16)
				return -1
			end
	end	
	--forberedelse af de mange forskellige formater
	set @M = convert(varchar(2),month(@monthdate))
	select 'Førværdier:' as [ods.ctl_dataload FPC (HR_FTE)],substring(Kilde_system,1,20) as Kilde, substring(Variable,1,20) as Variable, substring(Value,1,30) as Value, '' as Comment from ods.ctl_dataload where kilde_system like '%FPC%' order by kilde_system, variable
	begin try 
	begin transaction
		update ods.ctl_dataload  set value = @YYYYMM where kilde_system = 'FPC' and variable = 'Last_Period_Load'		
		update ods.ctl_dataload  set value = @M where kilde_system = 'FPC' and variable = 'Maaned_Calc_FPC'		
			select 'Efterværdier:' as [ods.ctl_dataload fpc (HR_FTE)],substring(Kilde_system,1,20) as Kilde, substring(Variable,1,20) as Variable, substring(Value,1,30) as Value, case when @month is null and variable like '%Peri%' then 'Sat fra master_periode' else '' end as Comment from ods.ctl_dataload where kilde_system like '%FPC%' order by kilde_system, variable
	commit transaction
	end try 
	begin catch 
		IF (XACT_STATE()) = -1
			rollback transaction
			raiserror('Fejl og rollback. Loadperioden for fpc er ikke opdateret.',1,16)
			
		IF  (XACT_STATE()) = 1
			commit transaction
	end catch
	_end:
	end