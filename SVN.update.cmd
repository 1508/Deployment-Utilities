@echo off

REM @echo off
REM 
REM call "\\QA\utilities\deployment\SVN.update.bat" "D:\web\selco.com\Website"
REM 

if "%~1"=="?" goto HELP
if "%~1"=="/?" goto HELP
if "%~1"=="" goto HELP 

if "%~1"=="" goto INVALIDPARAMETERS
if not exist "%~1\.svn" goto WARNING
if not exist "C:\Program Files\TortoiseSVN\bin\TortoiseProc.exe" goto MISSING

"C:\Program Files\TortoiseSVN\bin\TortoiseProc.exe" /command:update /path:%1 /closeonend:2
GOTO:EOF

:WARNING
echo Script terminated: "%~1.svn" does not exist
echo The project folder has not been bound to a SVN solution... no changes made.
pause
GOTO:EOF

:MISSING
echo Script terminated: "C:\Program Files\TortoiseSVN\bin\TortoiseProc.exe" does not exist
echo Required to perform update on svn folder.
pause
GOTO:EOF

:INVALIDPARAMETERS
echo Script terminated: invalid parameters SVN.update.bat %*
echo Example: call "\\QA\utilities\deployment\SVN.update.bat" "D:\web\selco.com\Website\"
pause
GOTO:EOF

:HELP
echo  Update SVN folder
echo.   
echo    SVN.update.cmd [path]
GOTO:EOF