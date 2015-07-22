ECHO OFF
SET ValgIndtastNyPeriode=0
SET ValgMasterPeriode=0
rem /* henter server og database konfiguration fra ekstern fil */ 
set config_file_path=..\Konfiguration\
setlocal enabledelayedexpansion
set COUNTER=1
for /f "tokens=3 delims=><" %%a in ('type %config_file_path%\ServerOgDatabase.dtsConfig ^| find "<ConfiguredValue>"') do (
  IF !COUNTER!==1 (SET DB_NAVN=%%a)
  IF !COUNTER!==2 (SET DB_SERVER=%%a)
  REM /* hvis der er flere variabel indsµttes de her */
  SET /a COUNTER=!COUNTER!+1
  )
  
SET SOURCE_DRIVE=P:
SET SOURCE_PATH=\\gbpoemprod\Data\Aktuel\
SET SOURCE_FILE1=lokofoerer_md_v2
SET SOURCE_FILE2=lokofravaer_md_v2

SET DEST_PATH=\\%DB_SERVER%\files\%DB_NAVN%\LTD\Data\Aktuel\
SET FILE_EXT=.csv

:: /* konfigurerer log */
md %cd%\Log
SET LOGFILE=%cd%\LOG\Log_%DATE:~6,4%%DATE:~3,2%%DATE:~0,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%.txt
SET LOGFILE=%LOGFILE: =0%
ECHO Folder:  %cd%  >> %LOGFILE%
ECHO. >> %LOGFILE%

:STARTEN
CLS
ECHO Script startet klokken: %time% 

ECHO ******************************************************************************
ECHO *
ECHO *  Server: %DB_SERVER%
ECHO *  Database: %DB_NAVN%
ECHO *
SQLCMD -S %DB_SERVER% -d %DB_NAVN% -E -Q "declare @periode varchar(50); select @periode = Value from ods.CTL_Dataload where kilde_system = 'Alle' and Variable = 'Master_periode'; print '*  Master LoadPeriode:  ---> '+@periode + ' <--- Tjek periode her.'" 
SQLCMD -S %DB_SERVER% -d %DB_NAVN% -E -Q "declare @periode varchar(50); select @periode = substring(value,1,10) from ods.CTL_Dataload where kilde_system = 'LTD2' and Variable = 'Last_Period_Load'; print '*  LTD2 LoadPeriode: '+@periode"
ECHO *
ECHO ******************************************************************************
ECHO.

CHOICE /C 123 /N /M "Tast 1: Start med master loadperiode, 2: Indtast Ny dato eller 3: Fortryd og afslut"

IF %errorlevel%==3 GOTO ExitChosen
IF %errorlevel%==2 SET ValgIndtastNyPeriode=1
IF %errorlevel%==1 SET ValgMasterPeriode=1
ECHO.

IF %ValgMasterPeriode%==1 SQLCMD -S %DB_SERVER% -d %DB_NAVN% -E -Q "SET NOCOUNT ON;exec [etl].[loadperiod_LTD2]" 
IF %ValgMasterPeriode%==1 GOTO Valgslut

:GenvalgPeriode
IF  %ValgIndtastNyPeriode%==1 SET /p NYPERIODE="Indtast ny loadperiode yyyymm for LTD2 :"
IF  %ValgIndtastNyPeriode%==1 SET QUERYTEXT=exec[etl].[loadperiod_LTD2]'%NYPERIODE%01'
IF  %ValgIndtastNyPeriode%==1 (ECHO. & SQLCMD -S %DB_SERVER% -d %DB_NAVN% -E -Q %QUERYTEXT%)
IF  %ValgIndtastNyPeriode%==1 CHOICE /C 123 /N /M "Tast 1: Start med valgt periode, 2: Indtast Ny dato eller 3: Fortryd og afslut"

IF %errorlevel%==3 GOTO ExitChosen
IF %errorlevel%==2 SET ValgIndtastNyPeriode=1 & GOTO GenvalgPeriode

:Valgslut

SQLCMD -S %DB_SERVER% -d %DB_NAVN% -E -Q "declare @periode varchar(50); select @periode = substring(value,1,10) from ods.CTL_Dataload where kilde_system = 'LTD2' and Variable = 'Last_Period_Load'; print 'Starter med LoadPeriode: '+@periode"
ECHO.
for /f %%a in ('SQLCMD -S %DB_SERVER% -d %DB_NAVN% -E -Q "SET NOCOUNT ON;select substring(Value,1,10) from ods.CTL_Dataload where kilde_system = 'LTD2' and Variable = 'Last_Period_Load'" -h -1') do set PERIODE=%%a
SET tmp1=%PERIODE:~6,4%
SET tmp2=%PERIODE:~3,2%
SET PERIODE=%tmp1%%tmp2%

pause
echo Overfører filer til sqlserver og afvikler pakker
ECHO f | xcopy /y %SOURCE_PATH%%SOURCE_FILE1%%PERIODE%%FILE_EXT% %DEST_PATH%%SOURCE_FILE1%%PERIODE%%FILE_EXT% >> %LOGFILE%
ECHO f | xcopy /y %SOURCE_PATH%%SOURCE_FILE2%%PERIODE%%FILE_EXT% %DEST_PATH%%SOURCE_FILE2%%PERIODE%%FILE_EXT% >> %LOGFILE%
echo til %DEST_PATH% >> %LOGFILE%
ECHO. >> %LOGFILE%
SQLCMD -S %DB_SERVER% -d %DB_NAVN% -E -Q "exec etl.run_etl_LTD2 ''" >> %LOGFILE%
ECHO ******************************************************************************
ECHO.
%LOGFILE%
pause

:ExitChosen

