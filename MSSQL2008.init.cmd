@echo off

REM @echo off
REM 
REM SET bin=\\QA\utilities\deployment
REM 
REM call "\\QA\utilities\deployment\MSSQL2008.init.bat" sa password
REM 

if "%~1"=="?" goto HELP
if "%~1"=="/?" goto HELP
if "%~1"=="" goto HELP 

call :HELP

if "%~1"=="" goto INVALIDPARAMETERS
if "%~2"=="" goto INVALIDPARAMETERS

echo   Sets %1 with password %2 Sql LoginMode and restarts MSSQLSERVER
echo.

sqlcmd -S localhost -i "%bin%\xp_instance_regwrite_Enable_SqlLoginMode.sql" 

net stop mssqlserver
net start mssqlserver

sqlcmd -S localhost -Q "ALTER LOGIN [%1] WITH password = '%2' " 
sqlcmd -S localhost -Q "ALTER LOGIN [%1] ENABLE " 

GOTO:EOF

:INVALIDPARAMETERS
echo Script terminated: invalid parameters MSSQL2008.init.bat %*
echo Example: call "\\QA\utilities\deployment\MSSQL2008.init.bat" sa password
echo Will set the password of the user sa to password, can only reset password on existing sql user accounts.
pause
GOTO:EOF

:HELP
echo  Enable Sql LoginMode and restarts MSSQLSERVER 
echo.   
echo    MSSQL2008.init.cmd [login] [password]
echo.   
GOTO:EOF