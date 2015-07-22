CREATE proc test1 as 
begin 
select name from sysobjects where id = @@procid
end