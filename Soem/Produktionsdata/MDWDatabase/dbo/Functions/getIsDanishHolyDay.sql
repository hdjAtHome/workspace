
create function [dbo].[getIsDanishHolyDay] (@date datetime) 
returns tinyint
as 
begin  
declare @d int, @m int, @y int, @r int, @e 
datetime  select @d=day(@date), @m=month(@date), @y=year(@date), @r=0  
-- faste helligdage  
if (@d= 1 and @m= 1) or	-- Nytårsdag     
(@d= 5 and @m= 6) or	-- Grundlovsdag    
(@d=24 and @m=12) or	-- Juleaftensdag     
(@d=25 and @m=12) or	-- 1. juledag     /* yderliger datoer kan indsættes her      */  
(@d=26 and @m=12)	--2. juledag
      set @r = 1  else begin    -- Skæve helligdage, beregnes udfra Påske   
 set @date = floor(cast(@date as float))    
set @e = dbo.getEasterDate(@y)    
if (@date=@e- 7) or -- Palmesøndag     
  (@date=@e- 3) or -- Skærtorsdag       
(@date=@e- 2) or -- Langfredag       
(@date=@e+ 0) or -- Påske       
(@date=@e+ 1) or -- 2. Påskedag       
(@date=@e+26) or -- St. Bededag       
(@date=@e+39) or -- Kristi Himmelfart       
(@date=@e+49) or -- Pinse       
(@date=@e+50)    -- 2. Pinsedag      
set @r = 1  end  
return @r
end