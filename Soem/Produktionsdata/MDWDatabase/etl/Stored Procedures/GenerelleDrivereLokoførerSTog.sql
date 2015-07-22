CREATE procedure [etl].[GenerelleDrivereLokoførerSTog] @model Varchar(1) = 'R', @Periode Varchar(50)
as
begin

DECLARE @SQL_command varchar(4000)
DECLARE @SQL_Select varchar(4000)
DECLARE kriterie_cursor CURSOR FOR
select case when togsystemer = 'ja' then
'SELECT ''' + DriverNavn + ''', ''CostObject'' As DestModuleType, ' 
   + 'ISNULL(costobjekt, ''NULL'') As DestReference, '
   + 'ISNULL(SUM(Timer), 0), NULL as FixedValue, ''' + @Periode + ''' FROM dbo.GD_' + @model + '_Lokoførertid_STog '
   + 'WHERE ISNULL(Turdepot, ''-'') LIKE ''' + ISNULL(turdepot, '%') + ''' '
   + 'AND ISNULL(OpgaveGruppe, ''-'') LIKE ''' + ISNULL(opgaveGruppe, '%') + ''' '
   + 'AND ISNULL(OpgaveType, ''-'') LIKE ''' + ISNULL(opgaveType, '%') + ''' '
   + 'AND costobjekt != ''-1'' '
   + 'AND PeriodeIndlæst = ''' + @Periode + ''' '
   + 'GROUP BY costobjekt'
  else
'SELECT ''' + driverNavn + ''', '''
   + CASE WHEN substring(destination,1,1) = 'A' THEN 'Activity' 
             WHEN substring(destination,1,1) = 'C' THEN 'CostObject' 
          ELSE 'Resource' END + ''' As DestModuleType, '
   + '''' + destination + ''' As DestReference, '
   + 'ISNULL(SUM(Timer), 0), NULL as FixedValue, ''' + @Periode + ''' FROM dbo.GD_' + @model + '_Lokoførertid_Stog '
   + 'WHERE ISNULL(Turdepot, ''-'') LIKE ''' + ISNULL(turdepot, '%') + ''' '
   + 'AND ISNULL(OpgaveGruppe, ''-'') LIKE ''' + ISNULL(opgaveGruppe, '%') + ''' '
   + 'AND ISNULL(OpgaveType, ''-'') LIKE ''' + ISNULL(opgaveType, '%') + ''' '
   + 'AND PeriodeIndlæst = ''' + @Periode + ''' '
  end as SQL_Sring
from dbo.MD_G_KRIT_DriverSys_Lokoførertid_STog
where periode = @Periode

-- Fjern eksisterende
set @SQL_command = 'DELETE FROM dbo.ABC_' + @model + '_DR_Lokoførertid_STog WHERE Periode = ''' + @Periode + ''''
execute (@SQL_command)


OPEN kriterie_cursor
FETCH NEXT FROM kriterie_cursor INTO @SQL_Select
while @@FETCH_STATUS = 0
begin
   
  set @SQL_command = 
  'INSERT INTO [dbo].[ABC_' + @model + '_DR_Lokoførertid_Stog](DriverName, DestModuleType, DestReference, 
  DriverQuantityFixed, DriverWeightFixed, Periode)' + @SQL_Select

  execute (@SQL_command)

  FETCH NEXT FROM kriterie_cursor INTO @SQL_Select
end

CLOSE kriterie_cursor   
DEALLOCATE kriterie_cursor

end