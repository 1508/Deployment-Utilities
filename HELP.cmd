if "%~1"=="?" goto HELP
if "%~1"=="/?" goto HELP

start "" "C:\Program Files\Internet Explorer\iexplore.exe" "%~dp0help.htm"
GOTO:EOF

:HELP
echo   Displays help.htm
echo.   
GOTO:EOF