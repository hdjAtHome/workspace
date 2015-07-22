CREATE procedure [etl].[GenerelleDrivereRejserIndtægterTogsystemFR] @model Varchar(1) = 'R', @Periode Varchar(50)
as
begin

/***********************************************************************************************
Denne procedure generere driver fordelinger.

***********************************************************************************************/
DECLARE @SQL_command varchar(4000)
DECLARE @SQL_Select varchar(4000)
--DECLARE @År Varchar(50)
--SET @År = SUBSTRING(@Periode, 1,4)
DECLARE kriterie_cursor CURSOR FOR
select case when togsystemer = 'ja' then
'SELECT ''' + drivernavn + ''', ''CostObject'' as DestModuleTypt, Costobjekt as DestReference, '
   + 'SUM(Værdi) AS DriverQuantityFixed, NULL as DriverWeightFixed, ''' + @Periode + ''' '
   + 'from dbo.GD_' + @model + '_RejseIndtægter_Togsystem_FR '
   + 'where Enhed = ''' + Enhed + ''' '
   + 'AND PeriodeIndlæst = ''' + @Periode + ''' '
   + ' GROUP BY Costobjekt'
    else
'SELECT ''' + drivernavn + ''', ''' + CASE WHEN substring(destination,1,1) = 'A' THEN 'Activity' ELSE 'CostObject' END + ''' ' 
   + 'as DestModuleTypt, ''' + destination + ''' as DestReference, '
   + 'SUM(Værdi) AS DriverQuantityFixed, NULL as DriverWeightFixed, ''' + @Periode + ''' '
   + 'from dbo.GD_' + @model + '_RejseIndtægter_Togsystem_FR '
   + 'where Enhed = ''' + Enhed + ''' '
   + 'AND ISNULL(Costobjekt, ''-'') LIKE ''' + ISNULL(CO, '%') + ''' '
   + 'AND PeriodeIndlæst = ''' + @Periode + ''' '
    end
from dbo.MD_G_KRIT_DriverSys_RejserIndtægter_Togsystem_FR
where periode = @Periode

-- Fjern eksisterende
set @SQL_command = 'DELETE FROM dbo.ABC_' + @model + '_DR_RejserIndtægter_Togsystem_FR WHERE Periode = ''' + @Periode + ''''
execute (@SQL_command)


OPEN kriterie_cursor
FETCH NEXT FROM kriterie_cursor INTO @SQL_Select
while @@FETCH_STATUS = 0
begin
  set @SQL_command = 
  'INSERT INTO dbo.ABC_' + @model + '_DR_RejserIndtægter_Togsystem_FR (DriverName, DestModuleType, DestReference, '
  + 'DriverQuantityFixed, DriverWeightFixed, Periode) ' + @SQL_Select

  execute (@SQL_command)

  FETCH NEXT FROM kriterie_cursor INTO @SQL_Select
end

CLOSE kriterie_cursor   
DEALLOCATE kriterie_cursor

end