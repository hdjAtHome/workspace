


CREATE proc [etl].[loadperiod_GD] @month datetime = null --default svarende til at perioden hentes fra ods.ctl_dataload hvor kilde_system = alle og variable = master_periode
as 

	declare @kilde_system varchar(50)
	declare @variable varchar(50)
	set @kilde_system = 'Alle'
	set @variable = 'Model_Periode'

	begin
	if @month = '9999' 
	BEGIN
		select 'Nuværende værdier:' as [Ods.ctl_dataload],substring(Kilde_system,1,20) as Kilde, substring(Variable,1,20) as Variable, substring(Value,1,30) as Value 
		from ods.ctl_dataload where kilde_system = @kilde_system and variable = @variable order by kilde_system, variable
		goto _end
	END

	declare @monthdate datetime
	declare @YYYYMM varchar(6)
	if @month is null --Tag da samme værdi som master_periode sat for alle kildesystemer
	begin
		select @YYYYMM = value from ods.ctl_dataload  where kilde_system = 'alle' and variable = 'master_periode'
		if @yyyymm is null
		begin
				raiserror('Der blev ikke fundet en værdi for kilde_system = alle og variable = master_periode' ,1,16)
				return -1
			end
	end
	else 
	begin
		if @month =	dateadd(mm,datediff(mm,'1900', @month),'1900')-- tjekker om angivet dato er den første i en måned
		BEGIN
				set @monthdate = @month
				set @YYYYMM = convert(varchar(6),@monthdate, 112)
		END
		else 
			BEGIN
				set @monthdate = null
				raiserror('Den angivne dato er ikke den første i en måned. Loadperioden for GD er derfor ikke opdateret.',1,16)
				return -1
			END
	end	

	select 'Førværdier:' as [ods.ctl_dataload],substring(Kilde_system,1,20) as Kilde, substring(Variable,1,20) as Variable, substring(Value,1,30) as Value 
	from ods.ctl_dataload where kilde_system = @kilde_system and variable = @variable order by kilde_system, variable
	
	begin try 
	begin transaction
		update ods.ctl_dataload  set value = @YYYYMM where kilde_system = @kilde_system and variable = @variable
		select 'Efterværdier:' as [ods.ctl_dataload GD ],substring(Kilde_system,1,20) as Kilde, substring(Variable,1,20) as Variable, substring(Value,1,30) as Value, case when @month is null and variable = @variable then 'Sat fra master_periode' else '' end as Comment from ods.ctl_dataload where kilde_system = @kilde_system and variable = @variable order by kilde_system, variable
	commit transaction
	end try 
	begin catch 
		IF (XACT_STATE()) = -1
			rollback transaction
			raiserror('Fejl og rollback. Loadperioden for GD er ikke opdateret.',1,16)
			
		IF  (XACT_STATE()) = 1
			commit transaction
	end catch
	_end:
	end