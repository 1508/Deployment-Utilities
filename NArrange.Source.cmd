@echo off

rem Set as Pre-build event
rem   \\QA\utilities\Deployment\NArrange.Source.cmd "$(SolutionPath)"

if "%~1"=="?" goto HELP
if "%~1"=="/?" goto HELP
if "%~1"=="" goto HELP 

if not DEFINED bin (
  set bin=%~dp0
)

if "%~1"=="" goto INVALIDPARAMETERS

"%bin%\narrange\narrange-console.exe" "%~1"
GOTO:EOF

:INVALIDPARAMETERS
echo Script terminated: invalid parameters NArrange.Source.cmd %*
echo set as pre-build event:
echo     \\QA\utilities\Deployment\NArrange.Source.cmd "$(SolutionPath)"
pause
GOTO:EOF

:HELP
echo  Arrange source code based on a visual studio project file
echo.   
echo    Set as pre-build event:
echo    \\QA\utilities\Deployment\NArrange.Source.cmd "$(SolutionPath)"
echo.   
GOTO:EOF