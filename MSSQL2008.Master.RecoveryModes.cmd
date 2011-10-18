@echo off

if "%~1"=="?" goto HELP
if "%~1"=="/?" goto HELP
if "%~1"=="" goto HELP 

call :HELP

if "%~1"=="" goto INVALIDPARAMETERS
if "%~2"=="" goto INVALIDPARAMETERS
if "%~3"=="" goto INVALIDPARAMETERS

sqlcmd -S %1 -U %2 -P %3 -i "%~dp0sp_MSforeachdb_RecoveryModes.sql" 

GOTO:EOF

:INVALIDPARAMETERS
echo Script terminated: invalid parameters %*
goto HELP

:HELP
echo  Set recovery mode simple on all database on specified server (except system database)
echo.   
echo    MSSQL2008.Master.RecoveryModes.cmd [server] [login] [password]
echo.   
GOTO:EOF