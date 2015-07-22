

CREATE proc [etl].[loadperiod_master] @periode varchar(6) = null --default svarende til forrige måned --ellers angives specifik måned - x '2012-08-01'as 
as 
	begin
	
	set nocount on
	
	declare @variabel varchar(50)
	set @variabel = 'Master_periode'
		
	declare @kilde_system varchar(12)
	set @kilde_system = 'Alle'	
		
	declare @month datetime
	begin try
		set @month = convert(datetime, @periode+'01')
	end try
	begin catch
		
			raiserror('Den angivne periode ''%s'' kan ikke konverteres til en måned.', 1,16, @periode)
		
		goto _end
	end catch	
		
	if @month = '9999' 
	BEGIN
		--select 'Nuværende værdier:'  as [ods.ctl_dataload master], * from ods.ctl_dataload where kilde_system = @Kilde_system and variable = @variabel order by kilde_system, variable
		select 'Nuværende værdier:' as [Ods.ctl_dataload], [Kilde_System], [Variable], convert(char(10),[Value]) as Value
		from ods.ctl_dataload 
		where kilde_system = @Kilde_system and variable = @variabel 
		goto _end
	END
	--eksempel på kald i september måned, når data er modtaget for august: exec etl.loadperiod_master '2012-08-01' eller exec etl.loadperiod_master ----beregner automatisk forrige måned som loadperiode
	
	declare @monthdate datetime
	declare @today datetime
	set @today = getdate()
	if @month is null
	begin
		set @monthdate = dateadd(mm,datediff(mm,'1900', @today)-1,'1900')-- beregner forrige måned
		--select @monthdate
	end
	else 
	begin
		if 	@month =	dateadd(mm,datediff(mm,'1900', @month),'1900')-- tjekker om angivet dato er den første i en måned
			set @monthdate = @month
		else 
			begin
				set @monthdate = null
				raiserror('Den angivne dato er ikke den første i en måned. Master Loadperioden er derfor ikke opdateret.',1,16)
				return
			end
	end	
	
	declare @YYYYMM varchar(6)
	set @YYYYMM = convert(varchar(6),@monthdate, 112)

	select 'Førværdier:' as [Ods.ctl_dataload], [Kilde_System], [Variable], convert(char(10),[Value]) as Value
	from ods.ctl_dataload 
	where kilde_system = @Kilde_system and variable = @variabel 
	--select 'Førværdier:' as [ods.ctl_dataload master],* from ods.ctl_dataload where kilde_system = @Kilde_system and variable = @variabel order by kilde_system, variable
	select ''
	begin try 
	begin transaction
		update ods.ctl_dataload  set value = @YYYYMM where kilde_system = @Kilde_system and variable = @variabel
		if @@rowcount = 0 
			begin 
				Insert into ods.ctl_dataload (
					[Kilde_System],
					[Variable],
					[Value]
				)
				SELECT 
				 @Kilde_system,   ---Kilde_System
				 @variabel,   ---Variable
				 @YYYYMM ---Value
			end 
			select 'Efterværdier:' as [Ods.ctl_dataload], [Kilde_System], [Variable], convert(char(10),[Value]) as Value
			from ods.ctl_dataload 
			where kilde_system = @Kilde_system and variable = @variabel 
	commit transaction
	end try 
	begin catch 
		IF (XACT_STATE()) = -1
			rollback transaction
			raiserror('Fejl og rollback. Master Loadperioden er ikke opdateret.',1,16)
			
		IF  (XACT_STATE()) = 1
			commit transaction
	end catch
	_end:
	end