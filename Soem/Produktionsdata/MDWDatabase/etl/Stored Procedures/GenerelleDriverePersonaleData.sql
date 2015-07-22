CREATE procedure [etl].[GenerelleDriverePersonaleData] @model Varchar(1) = 'R', @Periode Varchar(50)
as
begin

DECLARE @SQL_command varchar(4000)
DECLARE @SQL_Select varchar(4000)
DECLARE kriterie_cursor CURSOR FOR
select 'SELECT ''' + driverNavn + ''', '''
      + CASE WHEN substring(destination,1,1) = 'A' THEN 'Activity' 
             WHEN substring(destination,1,1) = 'C' THEN 'CostObject' 
             ELSE 'Resource' END + ''' As DestModuleType, ' 
      + CASE WHEN ISNULL(EvenlyAssigned, 'nej') = 'ja' THEN 'ISNULL(EvenlyAssigned, ''Jeppe'')'
             ELSE '''' + Destination + '''' END + ' As DestReference, '
      + 'ISNULL(SUM(Fuldtidsstillinger), 0), NULL as FixedValue '
      + 'FROM CD_R_ETL5_Ressourceportal_Personale '
      + 'WHERE ISNULL(Profitcenter, ''-'') LIKE ''' + ISNULL(Profitcenter, '%') + ''' '
      + 'AND ISNULL(OmkStedKont, ''-'') LIKE ''' + ISNULL(Omkostningssted, '%') + ''' '
      + 'AND ISNULL(Reference_ID, ''-'') LIKE ''' + ISNULL(RessourceKildeR1, '') + '%'' '
      + 'AND ISNULL(ATT_ResType, ''-'') LIKE ''' + ISNULL(ATT_ResType, '') + '%'' ' 
      + 'AND ISNULL(EvenlyAssigned, ''-'') LIKE ''' + ISNULL(RessouceDestinationR2, '') + '%'' '
      + 'AND PeriodeIndlæst = ''' + @Periode + ''' ' 
      + CASE WHEN ISNULL(EvenlyAssigned, 'nej') = 'ja' THEN 'group by EvenlyAssigned' ELSE '' END
  as SQL_Sring
from dbo.MD_G_KRIT_DriverSys_personaleData
where periode = @Periode

-- Fjern eksisterende
set @SQL_command = 'DELETE FROM dbo.ABC_' + @model + '_DR_PersonaleData WHERE Periode = ''' + @Periode + ''''
execute (@SQL_command)
set @SQL_command = 'TRUNCATE TABLE dbo.TD_' + @model + '_DR_PersonaleData'
execute (@SQL_command)


OPEN kriterie_cursor
FETCH NEXT FROM kriterie_cursor INTO @SQL_Select
while @@FETCH_STATUS = 0
begin
   
  set @SQL_command = 
  'INSERT INTO [dbo].[TD_' + @model + '_DR_PersonaleData](DriverName, DestModuleType, DestReference, ' 
  + 'DriverQuantityFixed, DriverWeightFixed) ' + @SQL_Select

  execute (@SQL_command)

  FETCH NEXT FROM kriterie_cursor INTO @SQL_Select
end

CLOSE kriterie_cursor   
DEALLOCATE kriterie_cursor

insert into  dbo.ABC_R_DR_PersonaleData 
    (DriverName, DestModuleType, DestReference, DriverWeightFixed, DriverQuantityFixed, Periode)
select DriverName, DestModuleType, DestReference, null as DriverWeightFixed, SUM(DriverQuantityFixed), @Periode 
from dbo.TD_R_DR_PersonaleData
group by DriverName, DestModuleType, DestReference

end