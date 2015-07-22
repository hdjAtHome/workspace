
create function [dbo].[getDanishHolyDayName] (@date datetime) 
returns varchar(20)
as 
begin  
declare @d int, @m int, @y int, @r varchar(20), @e 
datetime  select @d=day(@date), @m=month(@date), @y=year(@date) 
-- faste helligdage  
set @r =
	case 
	when (@d= 1 and @m= 1) then 'Nytårsdag'     
	when (@d= 5 and @m= 6) then 'Grundlovsdag'    
	when (@d=24 and @m=12) then 'Juleaftensdag'     
	when (@d=25 and @m=12) then '1. juledag'     /* yderliger datoer kan indsættes her      */  
	when (@d=26 and @m=12) then '2. juledag'
	else null 
	end      
if @r is null 
begin --skæve helligdage beregnes ud fra påskedag
	set @date = floor(cast(@date as float))    
	set @e = dbo.getEasterDate(@y)    
	set @r =
	case when (@date=@e- 7) then 'Palmesøndag'     
		when (@date=@e- 3)then 'Skærtorsdag'       
		when (@date=@e- 2) then 'Langfredag'       
		when (@date=@e+ 0) then 'Påskedag'       
		when (@date=@e+ 1) then '2. Påskedag'       
		when (@date=@e+26) then 'St. Bededag'       
		when (@date=@e+39) then 'Kristi Himmelfart'       
		when (@date=@e+49) then 'Pinsedag'       
		when (@date=@e+50) then '2. Pinsedag'      
		else null
	end
end

return @r
end