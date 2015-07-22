
create function [dbo].[getEasterDate] (@eYear int) 
returns datetime
as
begin
/* Fischer Lexikon Astronomie, p. 50:     Algorithm of C.F. Gauá (1777-1855),     for 1583 <= eyear <= 2299  */  
declare @m int, @n int, @p int, @q int, @r int, @x int  
declare @y int, @a int, @b int, @c int, @d int, @e int  
declare @eDay int, @eMonth int
/* Kan tilføjes hvis MsSQL senere understøtter flere år  if[/b] (@eYear <= 1699) select @m=22, @n=2 else*/ 
 if (@eYear <= 1799) select @m=23, @n=3 else   if (@eYear <= 1899) select @m=23, @n=4 else   if (@eYear <= 2099) select @m=24, @n=5 else   if (@eYear <= 2199) select @m=24, @n=6 else   if (@eYear <= 2299) select @m=25, @n=0   select @a =  @eYear % 19, @b = @eYear % 4, @c = @eYear % 7  select @d = ( (19*@a)+@m ) % 30  select @e = ( (2*@b)+(4*@c)+(6*@d)+@n ) % 7  select @eDay = 22 + @d + @e  select @eMonth = 4  if @eDay <=31 set @eMonth=3 else  if ( (@d=28) and (@e=6) and (@a>10) ) set @eDay=18 else  if ( (@d=29) and (@e=6) ) set @eday = 19 else     select @eday = @d + @e - 9  
return convert(    datetime,    cast(@eYear as varchar)+'/'+    cast(@eMonth as varchar)+'/'+    cast(@eDay as varchar),    111)
end