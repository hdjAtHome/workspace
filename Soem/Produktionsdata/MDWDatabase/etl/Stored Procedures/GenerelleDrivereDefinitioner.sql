
/************************************************************

 Procedure som laver driver definitioner i ABC tabeller

************************************************************/
CREATE PROCEDURE [etl].[GenerelleDrivereDefinitioner] @model Varchar(1), @tabel Varchar(60), @Periode Varchar(50)
AS
BEGIN

    declare @SQL_command Varchar(1000)
    
    set @SQL_command =
    'insert into dbo.ABC_' + @model + '_DRDEF_DriverDefinitioner '
    + '(DriverName ,DriverType ,Formula ,SequenceNumber ,FixedDriverQuantityOverride ,UseWeightedQuantities, Periode) '
    + 'select d.DriverName, CASE WHEN k.DriverNavn IS NULL THEN ''Unique'' ELSE ''Sequenced'' END as DriverType, '
    + 'k.Formel AS Formula, k.Sekvens AS SequenceNumber, k.Værdi As FixedDriverQuantityOverride, '
    + 'k.Vægt AS UseWeightedQuantities, d.Periode '
    + 'from ( '
    + 'select DriverName, Periode from dbo.ABC_' + @model + '_DR_' +  @tabel
    + ' where Periode = ''' + @Periode + ''' ' 
    + 'group by DriverName, Periode) d '
    + 'left outer join dbo.MD_G_KRIT_DriverDefinitioner k on (k.driverNavn=d.DriverName
                                                          and k.periode=d.periode)'

    execute (@SQL_command)

END