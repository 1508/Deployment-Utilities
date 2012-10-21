@echo off

if "%~1"=="?" goto HELP
if "%~1"=="/?" goto HELP
if "%~1"=="" goto HELP 

if not DEFINED bin (
  set bin=%~dp0
)

SET WEBROOT=%~1
SET HOSTHEADER=%~2
SET WEBNAME=%~3
SET APPNAME=%~4
SET ASPNETFRAMEWORK_REGIIS_PATH=%~5
SET managedPipelineMode=%~6
call :HELP

cscript "%bin%\ValidateSystem.Windows8.vbs" //Nologo
if errorlevel 99 goto IIS8

cscript "%bin%\ValidateSystem.WindowsServer2012.vbs" //Nologo
if errorlevel 99 goto IIS8

cscript "%bin%\ValidateSystem.Windows7.vbs" //Nologo
if errorlevel 99 goto IIS75

cscript "%bin%\ValidateSystem.WindowsServer2003.vbs" //Nologo
if errorlevel 99 goto IIS6

cscript "%bin%\ValidateSystem.Vista.vbs" //Nologo
if errorlevel 99 goto IIS7

cscript "%bin%\ValidateSystem.XP.vbs" //Nologo
if errorlevel 99 goto IIS5

goto ValidateSystemFailed

:IIS5
call "%bin%\IIS5.create.cmd" "%WEBROOT%" "%ASPNETFRAMEWORK_REGIIS_PATH%"
GOTO:EOF

:IIS6
call "%bin%\IIS6.create.cmd" "%WEBROOT%" "%HOSTHEADER%" "%WEBNAME%" "%APPNAME%" "%ASPNETFRAMEWORK_REGIIS_PATH%"
GOTO:EOF

:IIS7
"%bin%\sudo.cmd" cmd /c "%bin%\IIS7.create.cmd "%WEBROOT%" "%HOSTHEADER%" "%WEBNAME%" "%APPNAME%" "%ASPNETFRAMEWORK_REGIIS_PATH%" "%managedPipelineMode%" "%bin%" " 
GOTO:EOF

:IIS75
call %bin%\IIS7.create.cmd "%WEBROOT%" "%HOSTHEADER%" "%WEBNAME%" "%APPNAME%" "%ASPNETFRAMEWORK_REGIIS_PATH%"
GOTO:EOF

:IIS8
"%bin%\sudo.cmd" cmd /c "%bin%\IIS8.create.cmd "%WEBROOT%" "%HOSTHEADER%" "%WEBNAME%" "%APPNAME%" "%ASPNETFRAMEWORK_REGIIS_PATH%" "%managedPipelineMode%" "%bin%" " 
GOTO:EOF

:ValidateSystemFailed
echo System is not supported by IIS scripts.
echo.
echo IIS must be set manually
echo WEBROOT="%WEBROOT%"
echo HOSTHEADER="%HOSTHEADER%"
echo WEBNAME="%WEBNAME%"
echo APPNAME="%APPNAME%"
echo ASPNETFRAMEWORK_REGIIS_PATH="%ASPNETFRAMEWORK_REGIIS_PATH%"
echo managedPipelineMode="%managedPipelineMode%"
pause
GOTO:EOF


:HELP
echo  Choose system and redirect parameters to valid IIS system.
echo.
echo    IISx.create WEBROOT HOSTHEADER WEBNAME APPNAME ASPNETFRAMEWORK_REGIIS_PATH (managedPipelineMode)
echo.
echo    HOSTHEADER           Can be comma separated but only IIS7 and IIS8 will interpret this. IIS6 will create separate websites for each hostheader
echo    managedPipelineMode  Used by IIS7 and IIS8, default is classic but "Integrated" can be set for the website app pool.
echo.
echo  Example:
echo  .\IISx.create.bat"  "D:\SDU776.0507\WebSite" "sdu.local,sdunet.local" "SDU776 SDU Intranet" "SDU776 AppPool" "%WINDIR%\Microsoft.NET\Framework\v2.0.50727\aspnet_regiis.exe"
echo.
GOTO:EOF