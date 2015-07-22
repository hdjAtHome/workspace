-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[kalender]
(
	-- Add the parameters for the function here
	@frayyyymm varchar(6),
	@tilyyyymm varchar(6)
)
RETURNS 
@datesReturn TABLE 
(
						Dato varchar(10), 
						År smallint, 
						Måned tinyint, 
						Dag tinyint, 
						Helligdag bit, 
						Helligdagnavn varchar(20), 
						Hverdag bit, 
						Ugedagnummer tinyint, 
						Ugedagnavn varchar(20),
						HverdagImåneden tinyint,
						HverdageiMånedHertil tinyint
)
AS
BEGIN
	declare @dates table (
						dato varchar(10), 
						år smallint, 
						måned tinyint, 
						dag tinyint, 
						helligdag bit, 
						helligdagnavn varchar(20), 
						hverdag bit, 
						ugedagnummer tinyint, 
						ugedagnavn varchar(20)
						)
declare @date datetime
select  @date = @frayyyymm+'01'
declare @tildato datetime
select @tildato = @tilyyyymm+'01'
while @date < @tildato
begin
	insert into @dates(
						dato, 
						år, 
						måned,	
						dag, 
						helligdag, 
						helligdagnavn, 
						hverdag,	
						ugedagnummer, 
						ugedagnavn
						)

	select				convert(varchar(10),@date,120) as dato ,
						year(@date) as år,  
						month(@date) as måned, 
						day(@date) as dag, 
						dbo.getIsDanishHolyDay(@date) as helligdag, 
						dbo.getDanishHolyDayName(@date) as helligdagnavn, 
						dbo.hverdag(@date) as hverdag, 
						dbo.ugedagnummer(@date) as ugedagnummer, 
						dbo.ugedag(@date) as ugedagnavn

	set @date = dateadd(day, 1, @date)
end;	

insert into @datesReturn (
						dato, 
						år, 
						måned,	
						dag, 
						helligdag, 
						helligdagnavn, 
						hverdag,	
						ugedagnummer, 
						ugedagnavn,
						hverdagimåneden,
						HverdageiMånedHertil)

select 					dato, 
						år, 
						måned,	
						dag, 
						helligdag, 
						helligdagnavn, 
						hverdag,	
						ugedagnummer, 
						ugedagnavn,	
					    case when hverdag*sum(convert(int,hverdag)) over (partition by år, måned order by dag ) = 0 then null else sum(convert(int,hverdag)) over (partition by år, måned order by dag ) end as hverdagimåneden ,
						sum(convert(int,hverdag)) over (partition by år, måned order by dag ) as hverdageimånedenHertil 
						from @dates 
						order by dato


	RETURN 
END