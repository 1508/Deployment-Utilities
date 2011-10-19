@echo off

REM @echo off
REM 
REM SET bin=\\QA\utilities\deployment
REM 
REM call "\\QA\utilities\deployment\SVN.export.cmd" "http://svn/HLA1090.0501/Corporate website/Website" "\\QA\Solutions\HLA 1090\Corporate website\Website"
REM 

if "%~1"=="?" goto HELP
if "%~1"=="/?" goto HELP
if "%~1"=="" goto HELP 

if "%~1"=="" goto INVALIDPARAMETERS
if "%~2"=="" goto INVALIDPARAMETERS

"%bin%\Subversion Client\svn.exe" export %1 %2 --force
GOTO:EOF

:INVALIDPARAMETERS
echo Script terminated: invalid parameters SVN.export.cmd %*
echo Example: call "\\QA\utilities\deployment\SVN.export.cmd" "http://svn/HLA1090.0501/Corporate website/Website" "\\QA\Solutions\HLA 1090\Corporate website\Website"
pause
GOTO:EOF

:HELP
echo  Export SVN archive
echo.   
echo    SVN.export.cmd [svn path] [path]
GOTO:EOF