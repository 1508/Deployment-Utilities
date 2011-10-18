@echo off

REM @echo off
REM
REM SET bin=\\QA\utilities\deployment
REM call "%bin%\SQL.backup.cmd" localhost sa passw0rd "vfa%%%%" "D:\Solutions\VFA 958\vfa.dk\Databases Backup\"
REM 

if "%~1"=="?" goto HELP
if "%~1"=="/?" goto HELP
if "%~1"=="" goto HELP 

if not DEFINED bin (
  set bin=%~dp0
)

if "%~1"=="" goto INVALIDPARAMETERS
if "%~2"=="" goto INVALIDPARAMETERS
if "%~3"=="" goto INVALIDPARAMETERS
if "%~4"=="" goto INVALIDPARAMETERS
if "%~5"=="" goto INVALIDPARAMETERS

echo   Saves backup of running databases with 
echo      name pattern like %4 
echo      to %5 
echo      with todays date
echo Remember that backup path must be a local path relative to the actual sql service, it cannot backup over the network.
echo.

REM SET yymmdd=%date:~8,2%%date:~3,2%%date:~0,2%

sqlcmd -S %1 -U %2 -P %3 -i "%bin%\BackupToDisk.sql" -v DatabaseName = %4 -v BackupPath = %5
GOTO:EOF

:INVALIDPARAMETERS
echo Script terminated: invalid parameters SQL.backup.bat %*
echo Example: call "\\QA\utilities\deployment\SQL.backup.bat" localhost sa password "selco%%" "D:\web\selco.com\Databases.Backups\"
echo Will backup all localhost databases matching "selco%%%%" where %%%% is % wildcard in sql job and save these to Databases.Backups 
echo Remember that backup path must be a local path relative to the actual sql service, it cannot backup over the network.
pause
GOTO:EOF

:HELP
echo  Backup running databases with to disk
echo.   
echo    SQL.backup.bat [server] [user] [password] [pattern] [path] 
GOTO:EOF