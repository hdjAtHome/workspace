
CREATE proc [etl].[get_loadinfo_pds] --default svarende til forrige måned --ellers angives specifik måned - x '2012-08-01'as 
as 
	begin
	
		declare @kilde_system varchar(50)
		set @kilde_system = 'pds'

		declare @email_to varchar(8000)
		declare @loadperiodYYYYMM varchar(10)

		select @loadperiodYYYYMM = value from ods.ctl_dataload where kilde_system = @kilde_system and variable = 'Last_Period_Load' 
		select @email_to = value from ods.ctl_dataload where kilde_system  = @kilde_system and variable = 'Email_To'

		select @loadperiodYYYYMM as Loadperiod, @email_to as Email_to,  getdate() as Timestamp
			
	end
	
	
	
	

