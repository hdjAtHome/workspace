ECHO OFF
CLS
set config_file_path=..\Konfiguration\
setlocal enabledelayedexpansion
set COUNTER=1
for /f "tokens=3 delims=><" %%a in ('type %config_file_path%\ServerOgDatabase.dtsConfig ^| find "<ConfiguredValue>"') do (
  IF !COUNTER!==1 (SET DB_NAVN=%%a)
  IF !COUNTER!==2 (SET DB_SERVER=%%a)
  REM /* hvis der er flere variabel indsættes de her */
  SET /a COUNTER=!COUNTER!+1
  )

SET SOURCE_DRIVE=P:
SET SOURCE_PATH=\70_BI\Projects\Files\StamData\
SET SOURCE_FILE1=EX_MD_G_STAM_Depoter.xlsx
SET SOURCE_FILE2=EX_MD_G_STAM_Ejendomme_Kategori.xlsx
SET SOURCE_FILE3=EX_MD_G_STAM_Ejendomme.xlsx
SET SOURCE_FILE4=EX_MD_G_STAM_Litra.xlsx
SET SOURCE_FILE5=EX_MD_G_STAM_Stationer.xlsx
SET SOURCE_FILE6=EX_MD_G_STAM_Timer_.xlsx
SET SOURCE_FILE7=EX_MD_G_STAM_Togsystem.xls
SET DEST_PATH=\\%DB_SERVER%\files\%DB_NAVN%\StamData\

rem /* konfigurerer log */
md %cd%\Log
SET LOGFILE=%cd%\LOG\Log_%DATE:~6,4%%DATE:~3,2%%DATE:~0,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%.txt
SET LOGFILE=%LOGFILE: =0%
ECHO Folder:  %cd%  >> %LOGFILE%
ECHO. >> %LOGFILE%

ECHO ******************************************************************************
ECHO *  Server: %DB_SERVER%
ECHO *  Database: %DB_NAVN% 
ECHO *  Følgende filer kopieres til %DB_SERVER%: 
ECHO *  %SOURCE_FILE1% 
ECHO *  %SOURCE_FILE2%
ECHO *  %SOURCE_FILE3%
ECHO *  %SOURCE_FILE4%
ECHO *  %SOURCE_FILE5%
ECHO *  %SOURCE_FILE6%
ECHO *  %SOURCE_FILE7%
ECHO *
ECHO ******************************************************************************
ECHO f | xcopy /y %SOURCE_DRIVE%%SOURCE_PATH%%SOURCE_FILE1% %DEST_PATH%%SOURCE_FILE1% >> %LOGFILE%
ECHO f | xcopy /y %SOURCE_DRIVE%%SOURCE_PATH%%SOURCE_FILE2% %DEST_PATH%%SOURCE_FILE2% >> %LOGFILE%
ECHO f | xcopy /y %SOURCE_DRIVE%%SOURCE_PATH%%SOURCE_FILE3% %DEST_PATH%%SOURCE_FILE3% >> %LOGFILE%
ECHO f | xcopy /y %SOURCE_DRIVE%%SOURCE_PATH%%SOURCE_FILE4% %DEST_PATH%%SOURCE_FILE4% >> %LOGFILE%
ECHO f | xcopy /y %SOURCE_DRIVE%%SOURCE_PATH%%SOURCE_FILE5% %DEST_PATH%%SOURCE_FILE5% >> %LOGFILE%
ECHO f | xcopy /y %SOURCE_DRIVE%%SOURCE_PATH%%SOURCE_FILE6% %DEST_PATH%%SOURCE_FILE6% >> %LOGFILE%
ECHO f | xcopy /y %SOURCE_DRIVE%%SOURCE_PATH%%SOURCE_FILE7% %DEST_PATH%%SOURCE_FILE7% >> %LOGFILE%
echo til %DEST_PATH% >> %LOGFILE%
ECHO. >> %LOGFILE%

SQLCMD -S %DB_SERVER% -d %DB_NAVN% -E -Q "exec etl.run_etl_stamdata_mdw ''" >> %LOGFILE%
%LOGFILE%
pause