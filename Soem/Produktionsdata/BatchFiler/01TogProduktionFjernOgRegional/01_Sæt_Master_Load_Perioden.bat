ECHO OFF
SET GenstartMedForrigeMaanedSomPeriodeValgt=0
SET GenstartMedIndtastNyPriode=0
rem /* henter server og database konfiguration fra ekstern fil */ 
set config_file_path=..\Konfiguration\
setlocal enabledelayedexpansion
set COUNTER=1
for /f "tokens=3 delims=><" %%a in ('type %config_file_path%\ServerOgDatabase.dtsConfig ^| find "<ConfiguredValue>"') do (
  IF !COUNTER!==1 (SET DB_NAVN=%%a)
  IF !COUNTER!==2 (SET DB_SERVER=%%a)
  REM /* hvis der er flere variabel indsættes de her */
  SET /a COUNTER=!COUNTER!+1
  )

rem /* konfigurerer log */
md %cd%\Log
SET LOGFILE=%cd%\LOG\LogLoadPeriode_%DATE:~6,4%%DATE:~3,2%%DATE:~0,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%.txt
SET LOGFILE=%LOGFILE: =0%
:STARTEN
CLS

REM Hvis genstart med forrige maaned som periode er valgt udfør da exec [etl].[loadperiod_master], der uden parametre sætter loadperioden til forrige maaned
ECHO.
IF  %GenstartMedForrigeMaanedSomPeriodeValgt%==1 ECHO LoadPeriode saettes til forrige maaned:
IF  %GenstartMedForrigeMaanedSomPeriodeValgt%==1 (ECHO. & SQLCMD -S %DB_SERVER% -d %DB_NAVN% -E -Q "exec [etl].[loadperiod_master]" & ECHO.)
SET GenstartMedForrigeMaanedSomPeriodeValgt=0
IF  %GenstartMedIndtastNyPriode%==1 SET /p NYPERIODE="Indtast ny master loadperiode yyyymm :"
IF  %GenstartMedIndtastNyPriode%==1 SET QUERYTEXT=exec[etl].[loadperiod_master]'%NYPERIODE%01'
IF  %GenstartMedIndtastNyPriode%==1 (ECHO. & SQLCMD -S %DB_SERVER% -d %DB_NAVN% -E -Q %QUERYTEXT% & ECHO.) 

SET GenstartMedIndtastNyPriode=0

ECHO ******************************************************************************
ECHO *
ECHO *  Server: %DB_SERVER%
ECHO *  Database: %DB_NAVN%
ECHO *
SQLCMD -S %DB_SERVER% -d %DB_NAVN% -E -Q "declare @periode varchar(50); select @periode = Value from ods.CTL_Dataload where kilde_system = 'Alle' and Variable = 'Master_periode'; print '*  Master LoadPeriode eksisterende:  ---> '+@periode + ' <--- Tjek periode her.'" 
ECHO *
ECHO ******************************************************************************
ECHO.
CHOICE /C 123 /N /M "Tast 1:Accepter periode og afslut  2:Forrige maaned som loadperiode eller  3:Indtast ny loadperiode..."
IF %errorlevel%==1 GOTO ExitChosen
IF %errorlevel%==2 SET GenstartMedForrigeMaanedSomPeriodeValgt=1 & GOTO Starten
IF %errorlevel%==3 SET GenstartMedIndtastNyPriode=1 & GOTO Starten

pause

:ExitChosen

SQLCMD -S %DB_SERVER% -d %DB_NAVN% -E -Q "declare @periode varchar(50); select @periode = Value from ods.CTL_Dataload where kilde_system = 'Alle' and Variable = 'Master_periode'; print 'Aslutter med Master loadperiode sat til '+@periode + '.'" 
SQLCMD -S %DB_SERVER% -d %DB_NAVN% -E -Q "exec etl.run_load_period_all ''" >> %LOGFILE%
%LOGFILE%

ECHO ******************************************************************************
ECHO *
ECHO *  Alle loadperioder er sat som master periode 
ECHO *  Login p† server: %DB_SERVER% og naviger til database: %DB_NAVN%
ECHO *  Naviger til og eksekver SSIS pakke: 001_KOER_LOAD_FRA_DWMART_APS placeret i 
ECHO *  Integration Services Catalog i projekt: 001-Load_Af_Proddata_Fra_DWMART_APS
ECHO *  Data vedr. PDS F og R og S-tog overf›res til database: %DB_NAVN%  
ECHO *
ECHO ******************************************************************************
PAUSE
