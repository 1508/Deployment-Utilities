@echo off

REM @echo off
REM
REM SET bin=\\QA\utilities\deployment
REM SET dbCountChecksum=3
REM call "%bin%\SQL.restore.cmd" localhost sa passw0rd "D:\Solutions\VFA 958\vfa.dk\Databases Backup\" "D:\Solutions\VFA 958\vfa.dk\Databases\" %dbCountChecksum%
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
if "%~6"=="" goto INVALIDPARAMETERS

echo   Restores backups *.bak to all databases with 
echo      todays backup date *.YYYY.MM.DD.bak (e.g. *.2009.01.13.bak)
echo      in path %5 
echo      validate that expected backup count is %6
echo.
echo Remember that backup path must be a local path relative to the actual sql service, it cannot backup over the network.
echo.

sqlcmd -S %1 -U %2 -P %3 -i "%bin%\xp_cmdshell_Enable.sql" 

cscript "%bin%\ValidateSystem.Windows7.vbs" //Nologo
if exist "C:\Program Files\Microsoft SQL Server\100" goto SQL2008
sqlcmd -S %1 -U %2 -P %3 -i "%bin%\RestoreFromDisk.sql" -v BackupPath=%4 -v BackupRestorePath=%5 -v BackupExpectedCount=%6 -v CustomDate="%~7"
goto SKIP
:SQL2008
sqlcmd -S %1 -U %2 -P %3 -i "%bin%\RestoreFromDisk.sql2008.sql" -v BackupPath=%4 -v BackupRestorePath=%5 -v BackupExpectedCount=%6 -v CustomDate="%~7"
:SKIP
if errorlevel 1 goto RESTOREFAILED
sqlcmd -S %1 -U %2 -P %3 -i "%bin%\xp_cmdshell_Disable.sql" 
GOTO:EOF

:INVALIDPARAMETERS
echo Script terminated: invalid parameters SQL.restore.bat %*
echo Example: call "\\QA\utilities\deployment\SQL.restore.bat" localhost sa password "D:\web\selco.com\Databases.Backups\" "D:\web\selco.com\Databases\" 7
echo Will restore all *.bak files matching todays date (e.g. ".2009.01.05.bak") and restore to \Databases database name is set to the file name.
echo Remember that paths must be local paths relative to the actual sql service.
pause
GOTO:EOF

:RESTOREFAILED
sqlcmd -S %1 -U %2 -P %3 -i "%bin%\xp_cmdshell_Disable.sql" 
echo Script terminated: Restore failed!
pause 
GOTO:EOF

:HELP
echo  Restore databases from disk
echo.   
echo    SQL.restore.bat [server] [user] [password] [path from] [path to] [ExpectedCount] ([Custom date format or *])
GOTO:EOF