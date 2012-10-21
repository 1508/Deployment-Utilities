@echo off

REM @echo off
REM
REM call "\\QA\utilities\deployment\VS2012.build.bat" "D:\web\selco.com\website\selco.sln"
REM 

if "%~1"=="?" goto HELP
if "%~1"=="/?" goto HELP
if "%~1"=="" goto HELP 

if not exist "%VS110COMNTOOLS%" goto MissingCOMNTOOLS
if "%~1"=="" goto MissingSOLUTION
if not exist %1 goto MissingSOLUTION

echo   Solution path %1
echo.

:BuildSolution
call "%VS110COMNTOOLS%vsvars32.bat"
MSBuild.exe %1
start "" "%VS110COMNTOOLS%..\IDE\devenv.exe" %1
GOTO:EOF

:MissingCOMNTOOLS
echo Visual studio default location was not found...
echo Script terminated: %VS110COMNTOOLS% does not exist
pause
GOTO:EOF

:MissingSOLUTION
echo Solution file is required for building...
echo Script terminated: %1 does not exist
echo Example: call "\\QA\utilities\deployment\VS2012.build.bat" "D:\web\selco.com\website\selco.sln"
pause
GOTO:EOF

:HELP
echo   Build solution and start developer environment
echo.   
echo    VS2012.build.cmd [solution filepath]
GOTO:EOF