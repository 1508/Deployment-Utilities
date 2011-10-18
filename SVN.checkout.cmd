@echo off

REM @echo off
REM 
REM SET bin=\\QA\utilities\deployment
REM 
REM call "\\QA\utilities\deployment\SVN.checkout.bat" "http://svn/SEL1013.0201/trunk/src/website" "D:\solutions\SEL1013\website\"
REM 

if "%~1"=="?" goto HELP
if "%~1"=="/?" goto HELP
if "%~1"=="" goto HELP 

if "%~1"=="" goto INVALIDPARAMETERS
if "%~2"=="" goto INVALIDPARAMETERS
if exist "%~2\.svn" goto WARNING

"%bin%\svn.exe" checkout %1 %2 --quiet
GOTO:EOF

:WARNING
echo Script terminated: %2.svn exists
echo The folder has allready been bound to a SVN solution... no changes made.
pause
GOTO:EOF

:INVALIDPARAMETERS
echo Script terminated: invalid parameters SVN.checkout.bat %*
echo Example: call "\\QA\utilities\deployment\SVN.checkout.cmd" "http://svn/SEL1013.0201/trunk/src/website" "D:\solutions\SEL1013\website\"
pause
GOTO:EOF

:HELP
echo  Check out SVN archive
echo.   
echo    SVN.checkout.cmd [svn path] [path]
GOTO:EOF