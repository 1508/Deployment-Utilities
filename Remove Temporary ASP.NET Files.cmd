@echo off

SET TEMPROOT=%~1

if "%~1"=="?" goto HELP
if "%~1"=="/?" goto HELP
if "%~1"=="" SET TEMPROOT=%systemroot%\Microsoft.NET\Framework\v2.0.50727\Temporary ASP.NET Files

echo 1) Resetting IIS for releasing file locks

IISRESET

echo 2) Removing temp files 

DEL /f /s /q "%TEMPROOT%\*.*"

echo 3) Removing empty folders

pushd "%TEMPROOT%"
for /d %%d in (*) do rd /q "%%d"
popd

pause

goto EXIT

:HELP
echo Removes temporary ASP.NET files
echo.

:EXIT