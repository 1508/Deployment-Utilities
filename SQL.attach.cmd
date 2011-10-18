@echo off

REM @echo off
REM
REM SET bin=\\QA\utilities\deployment
REM SET dbCountChecksum=3
REM call "%bin%\SQL.attach.cmd" localhost sa passw0rd "D:\Solutions\VFA 958\vfa.dk\Databases\" %dbCountChecksum%
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

echo   Attach *.mdf and ldf for all databases 
echo      in local server path %4
echo      validate that expected backup count is %5
echo.
echo Remember that backup path must be a local path relative to the actual sql service, it cannot attach over the network.
echo.

sqlcmd -S %1 -U %2 -P %3 -i "%bin%\xp_cmdshell_Enable.sql" 
sqlcmd -S %1 -U %2 -P %3 -i "%bin%\AttachFromDisk.sql" -v AttachPath=%4 -v AttachExpectedCount=%5
if errorlevel 1 goto ATTACHFAILED
sqlcmd -S %1 -U %2 -P %3 -i "%bin%\xp_cmdshell_Disable.sql" 

GOTO:EOF

:INVALIDPARAMETERS
echo Script terminated: invalid parameters SQL.attach.bat %*
echo Example: call "\\QA\utilities\deployment\SQL.attach.bat" localhost sa password "D:\web\selco.com\Databases\" 7
echo Will attach all *.mdf and *.ldf files in \Databases - database name is set to the file name. Database file count must match 7.
echo Remember that paths must be local paths relative to the actual sql service.
pause
GOTO:EOF

:ATTACHFAILED
sqlcmd -S %1 -U %2 -P %3 -i "%bin%\xp_cmdshell_Disable.sql" 
echo Script terminated: Restore failed!
pause 
GOTO:EOF

:HELP
echo  Attach *.mdf and *.ldf files from disk
echo.   
echo    SQL.attach.bat [server] [user] [password] [path] [ExpectedCount]
GOTO:EOF