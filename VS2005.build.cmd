@echo off

REM @echo off
REM
REM call "\\QA\utilities\deployment\VS80.build.bat" "D:\web\selco.com\website\selco.sln"
REM 

if "%~1"=="?" goto HELP
if "%~1"=="/?" goto HELP
if "%~1"=="" goto HELP 

if not exist "%VS80COMNTOOLS%" goto MissingVS80COMNTOOLS
if "%~1"=="" goto MissingSOLUTION
if not exist %1 goto MissingSOLUTION

echo   Solution path %1
echo.

:BuildSolution
call "%VS80COMNTOOLS%vsvars32.bat"
MSBuild.exe %1
start "" "%VS80COMNTOOLS%..\IDE\devenv.exe" %1
GOTO:EOF

:MissingVS80COMNTOOLS
echo Visual studio default location was not found...
echo Script terminated: %VS80COMNTOOLS% does not exist
pause
GOTO:EOF

:MissingSOLUTION
echo Solution file is required for building...
echo Script terminated: %1 does not exist
echo Example: call "\\QA\utilities\deployment\VS2005.build.cmd" "D:\web\selco.com\website\selco.sln"
pause
GOTO:EOF

:HELP
echo   Build solution and start developer environment
echo.   
echo    VS2005.build.cmd [solution filepath]
GOTO:EOF