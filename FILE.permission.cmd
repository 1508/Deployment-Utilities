@echo off

REM @echo off
REM
REM SET bin=\\QA\utilities\deployment
REM 
REM call "\\QA\utilities\deployment\FILE.permission.cmd" "D:\web\selco.com\Website"
REM call "\\QA\utilities\deployment\FILE.permission.cmd" "D:\web\selco.com\Data"
REM 

if "%~1"=="?" goto HELP
if "%~1"=="/?" goto HELP
if "%~1"=="" goto HELP 

CALL :HELP

if "%~1"=="" goto INVALIDPARAMETERS

echo   "Network Service" gets ACL change access on
echo      %1

"%bin%\SetACL.exe" -on "%~1" -ot file -actn ace -ace "n:Network Service;p:change" -ace "n:ASPNET;p:change"

GOTO:EOF

:INVALIDPARAMETERS
echo Script terminated: invalid parameters FILE.permission.cmd %*
echo Example: call "\\QA\utilities\deployment\FILE.permission.cmd" "D:\web\selco.com\Website"
pause
GOTO:EOF

:HELP
echo  Set ACL change access to the Network Service on the specified path
echo.   
echo    FILE.permission.cmd [path]
echo.   
GOTO:EOF