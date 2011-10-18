@echo off 

if "%~1"=="?" goto HELP
if "%~1"=="/?" goto HELP
if "%~1"=="" goto HELP 

ping -n %1 127.0.0.1 >NUL
GOTO:EOF

:HELP
echo   Wait the amount of seconds before continuing
echo. 
echo.    WAIT [seconds]
GOTO:EOF

