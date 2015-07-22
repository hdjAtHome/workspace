ECHO OFF
SET ValgIndtastNyPeriode=0
SET ValgMasterPeriode=0
set config_file_path=..\Konfiguration\
setlocal enabledelayedexpansion
set COUNTER=1
for /f "tokens=3 delims=><" %%a in ('type %config_file_path%\ServerOgDatabase.dtsConfig ^| find "<ConfiguredValue>"') do (
  IF !COUNTER!==1 (SET DB_NAVN=%%a)
  IF !COUNTER!==2 (SET DB_SERVER=%%a)
  REM /* hvis der er flere variabel indsµttes de her */
  SET /a COUNTER=!COUNTER!+1
  )
  
SET SOURCE_PATH=\\gbpoemprod\Data\Aktuel\
SET SOURCE_FILE1=protal_tabel1a
SET SOURCE_FILE2=protal_tabel1b
SET SOURCE_FILE3=protal_tabel5
SET SOURCE_FILE4=protal_litra_
SET SOURCE_FILE5=P:\70_BI\Manuelle_data\Materieldatabasen\Materieldatabasen2012Excel2003
SET SOURCE_FILE51=Materieldatabasen2012Excel2003
SET SOURCE_FILE6=protal_tog_
SET SOURCE_FILE7=protal_tabel4
SET DEST_PATH=\\%DB_SERVER%\files\%DB_NAVN%\Togproduktion_FR\Data\Aktuel\
SET DEST_LOG_PATH=\\%DB_SERVER%\files\%DB_NAVN%\Togproduktion_FR\
SET FILE_EXT=.csv

rem /* konfigurerer log */
md %cd%\Log
SET LOGFILE=%cd%\LOG\Log_%DATE:~6,4%%DATE:~3,2%%DATE:~0,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%.txt
SET LOGFILE=%LOGFILE: =0%
ECHO Folder:  %cd%  >> %LOGFILE%
ECHO. >> %LOGFILE%
:STARTEN
CLS

ECHO ******************************************************************************
ECHO *
ECHO *  Server: %DB_SERVER%
ECHO *  Database: %DB_NAVN%
ECHO *
SQLCMD -S %DB_SERVER% -d %DB_NAVN% -E -Q "declare @periode varchar(50); select @periode = Value from ods.CTL_Dataload where kilde_system = 'Alle' and Variable = 'Master_periode'; print '*  Master LoadPeriode:  ---> '+@periode + ' <--- Tjek periode her.'" 
SQLCMD -S %DB_SERVER% -d %DB_NAVN% -E -Q "declare @periode varchar(50); select @periode = Value from ods.CTL_Dataload where kilde_system = 'Protal' and Variable = 'Load_Period'; print '*  Protal LoadPeriode: '+@periode"
ECHO *
ECHO ******************************************************************************
ECHO.

CHOICE /C 123 /N /M "Tast 1: Start med master loadperiode, 2: Indtast Ny dato eller 3: Fortryd og afslut"

IF %errorlevel%==3 GOTO ExitChosen
IF %errorlevel%==2 SET ValgIndtastNyPeriode=1
IF %errorlevel%==1 SET ValgMasterPeriode=1
ECHO.
REM if Valgindtastnyperiode == 0 så sæt masterperioden som load periode for protal (gøres ved at kalde exec [etl].[loadperiod_protal] uden værdi for perioden

IF %ValgMasterPeriode%==1 SQLCMD -S %DB_SERVER% -d %DB_NAVN% -E -Q "SET NOCOUNT ON;exec [etl].[loadperiod_protal]" 
IF %ValgMasterPeriode%==1 GOTO Valgslut

:GenvalgPeriode
IF  %ValgIndtastNyPeriode%==1 SET /p NYPERIODE="Indtast ny loadperiode yyyymm for Protal :"
IF  %ValgIndtastNyPeriode%==1 SET QUERYTEXT=exec[etl].[loadperiod_protal]'%NYPERIODE%01'
IF  %ValgIndtastNyPeriode%==1 (ECHO. & SQLCMD -S %DB_SERVER% -d %DB_NAVN% -E -Q %QUERYTEXT%)
IF  %ValgIndtastNyPeriode%==1 CHOICE /C 123 /N /M "Tast 1: Start med valgt periode, 2: Indtast Ny dato eller 3: Fortryd og afslut"

IF %errorlevel%==3 GOTO ExitChosen
IF %errorlevel%==2 SET ValgIndtastNyPeriode=1 & GOTO GenvalgPeriode

:Valgslut
ECHO.
SQLCMD -S %DB_SERVER% -d %DB_NAVN% -E -Q "SET NOCOUNT ON;declare @periode varchar(50); select @periode = Value from ods.CTL_Dataload where kilde_system = 'Protal' and Variable = 'Load_Period'; print 'Starter job med Protal LoadPeriode: '+@periode"
ECHO.
for /f %%a in ('SQLCMD -S %DB_SERVER% -d %DB_NAVN% -E -Q "SET NOCOUNT ON;select substring(Value,1,6) from ods.CTL_Dataload where kilde_system = 'Protal' and Variable = 'Load_Period'" -h -1') do set PERIODE=%%a

pause
echo Overfører filer til sqlserver og afvikler pakker
ECHO f | xcopy /y %SOURCE_PATH%%SOURCE_FILE1%%PERIODE%%FILE_EXT% %DEST_PATH%%SOURCE_FILE1%%PERIODE%%FILE_EXT% >> %LOGFILE%
ECHO f | xcopy /y %SOURCE_PATH%%SOURCE_FILE2%%PERIODE%%FILE_EXT% %DEST_PATH%%SOURCE_FILE2%%PERIODE%%FILE_EXT% >> %LOGFILE%
ECHO f | xcopy /y %SOURCE_PATH%%SOURCE_FILE3%%PERIODE%%FILE_EXT% %DEST_PATH%%SOURCE_FILE3%%PERIODE%%FILE_EXT% >> %LOGFILE%
ECHO f | xcopy /y %SOURCE_PATH%%SOURCE_FILE4%%PERIODE%%FILE_EXT% %DEST_PATH%%SOURCE_FILE4%%PERIODE%%FILE_EXT% >> %LOGFILE%
ECHO f | xcopy /y %SOURCE_FILE5%%FILE_EXT% %DEST_PATH%%SOURCE_FILE51%%FILE_EXT% >> %LOGFILE%
ECHO f | xcopy /y %SOURCE_PATH%%SOURCE_FILE6%%PERIODE%%FILE_EXT% %DEST_PATH%%SOURCE_FILE6%%PERIODE%%FILE_EXT% >> %LOGFILE%
ECHO f | xcopy /y %SOURCE_PATH%%SOURCE_FILE7%%PERIODE%%FILE_EXT% %DEST_PATH%%SOURCE_FILE7%%PERIODE%%FILE_EXT% >> %LOGFILE%
echo til %DEST_PATH% >> %LOGFILE%
ECHO. >> %LOGFILE%
SQLCMD -S %DB_SERVER% -d %DB_NAVN% -E -Q "exec etl.run_etl_Togproduktion_Fjern_og_Regional ''" >> %LOGFILE%
%LOGFILE%
pause

%DEST_LOG_PATH%Log\logDiff.txt
%DEST_LOG_PATH%Log\logDiffDet.txt
%DEST_LOG_PATH%Log\CheckTabellerTogproduktion.txt

:ExitChosen

