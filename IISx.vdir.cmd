@echo off

if "%~1"=="?" goto HELP
if "%~1"=="/?" goto HELP
if "%~1"=="" goto HELP 

SET WEBNAME=%~1
SET VDIRNAME=%~2
SET VDIRROOT=%~3

call :HELP

cscript "%bin%\ValidateSystem.WindowsServer2003.vbs" //Nologo
if errorlevel 99 goto IIS6

cscript "%bin%\ValidateSystem.Vista.vbs" //Nologo
if errorlevel 99 goto IIS7

rem cscript "%bin%\ValidateSystem.Windows7.vbs" //Nologo
rem if errorlevel 99 goto IIS75

cscript "%bin%\ValidateSystem.XP.vbs" //Nologo
if errorlevel 99 goto IIS5

goto ValidateSystemFailed

:IIS5
echo VDIR creation not support
echo Please create manually vdir "%VDIRNAME%" (path:"%VDIRROOT%") on web "%WEBNAME%" 
echo.
echo When this is done press any key...
pause 
GOTO:EOF


:IIS6
if exist %systemroot%\System32\iisvdir.vbs cscript %systemroot%\System32\iisvdir.vbs /create "%WEBNAME%" "%VDIRNAME%" "%VDIRROOT%" //nologo
echo.
echo NOTICE 
echo vdir is only created on primary website - if multiple hostnames are used you must setup vdirs manually (or aggregate hostnames onto primary website)
echo.
GOTO:EOF


:IIS7
"%bin%\sudo.cmd" cmd /c "%windir%\system32\inetsrv\appcmd.exe add vdir /app.name:"%WEBNAME%/" /path:"/%VDIRNAME%" /physicalPath:"%VDIRROOT%" " 
GOTO:EOF


:IIS75
rem "%bin%\sudo.cmd" cmd /c "%windir%\system32\inetsrv\appcmd.exe add vdir /app.name:"%WEBNAME%/" /path:"/%VDIRNAME%" /physicalPath:"%VDIRROOT%" " 
GOTO:EOF


:ValidateSystemFailed
echo System is not supported by IIS scripts.
echo.
echo VDIR creation not support
echo   WEBNAME="%WEBNAME%"
echo   VDIRNAME="%VDIRNAME%"
echo   VDIRROOT="%VDIRROOT%"
pause
GOTO:EOF


:HELP
echo  Creates a virtual directories 
echo.  
echo  IISX.VDIR "%WEBNAME%" "%VDIRNAME%" "%VDIRROOT%"
echo  IISX.VDIR webname vdirname vdirroot
echo.
echo    webname   Specifies the website name 
echo    vdirname  Specifies the name of the virtual directory
echo    vdirroot  Specifies the path of the virtual directory
echo.
GOTO:EOF
