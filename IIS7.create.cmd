@echo off

REM @echo off
REM
REM call "\\QA\utilities\deployment\IISx.create.bat" WEBROOT HOSTNAME WEBNAME APPNAME ASPNETFRAMEWORK_REGIIS_PATH
REM call "\\QA\utilities\deployment\IISx.create.bat"  "D:\SDU776.0507\WebSite" "" "SDU776 SDU Intranet" "SDU776 AppPool" "%WINDIR%\Microsoft.NET\Framework\v2.0.50727\aspnet_regiis.exe"
REM 

if "%~1"=="?" goto HELP
if "%~1"=="/?" goto HELP
if "%~1"=="" goto HELP 

SET WEBROOT=%~1
SET HOSTHEADER=%~2
SET WEBNAME=%~3
SET APPNAME=%~4
SET ASPNETFRAMEWORK_REGIIS_PATH=%~5
SET managedPipelineMode=%~6

REM Since this is run under SUDO the parameters need to be passed by command lined
if "%bin%"=="" SET bin=%~7
if "%bin%"=="" goto INVALIDPARAMETERS


call :HELP

if "%WEBROOT%"=="" goto INVALIDPARAMETERS
rem if "%HOSTHEADER%"=="" goto INVALIDPARAMETERS
if "%WEBNAME%"=="" goto INVALIDPARAMETERS
if "%APPNAME%"=="" goto INVALIDPARAMETERS
if "%ASPNETFRAMEWORK_REGIIS_PATH%"=="" goto INVALIDPARAMETERS

echo   IIS7.CREATE "%WEBROOT%" "%HOSTHEADER%" "%WEBNAME%" "%APPNAME%" "%ASPNETFRAMEWORK_REGIIS_PATH%" "%managedPipelineMode%" "%bin%"
echo. 

:Step1
echo Performing step 1
rem Vista and Windows 7 are using same deployment script for IIS7 setup.
cscript "%bin%\ValidateSystem.Windows7.vbs" //Nologo
if "%errorlevel%"=="99" goto Step1Continue
cscript "%bin%\ValidateSystem.Vista.vbs" //Nologo
if "%errorlevel%"=="1" goto ValidateSystemFailed
:Step1Continue
if not exist "%windir%\system32\inetsrv\appcmd.exe" goto IISScriptMissing
if not exist "%ASPNETFRAMEWORK_REGIIS_PATH%" goto FrameWorkFolderMissing


:Step2
echo Performing step 2
REM yymmdd will be the current date. For example June 18 2008 will be in the format 080618
SET yymmdd=%date:~8,2%%date:~3,2%%date:~0,2%
SET hhmmss=%time:~0,2%%time:~3,2%%time:~6,2%
REM Create Backup in IIS Back/Restore  (iisback /backup /b "%yymmdd%.metabase pre %WEBNAME%")
"%windir%\system32\inetsrv\appcmd.exe" add backup "%yymmdd%%hhmmss%"


:Step3
echo Performing step 3
if "%HOSTHEADER%"=="" goto Step3NoHostheader

:Step3WithHostheader

for /f "tokens=1,2,3,4,5,6,7,8,9,10,11,12,13 delims=, " %%a in ("%HOSTHEADER%") do set hostheader1=%%a&set hostheader2=%%b&set hostheader3=%%c&set hostheader4=%%d&set hostheader5=%%e&set hostheader6=%%f&set hostheader7=%%g&set hostheader8=%%h&set hostheader9=%%i&set hostheader10=%%j&set hostheader11=%%k&set hostheader12=%%l&set hostheader13=%%m

if not "%hostheader2%"=="" set "hostheader1=%hostheader1%,http/*:80:%hostheader2%" 
if not "%hostheader3%"=="" set "hostheader1=%hostheader1%,http/*:80:%hostheader3%" 
if not "%hostheader4%"=="" set "hostheader1=%hostheader1%,http/*:80:%hostheader4%" 
if not "%hostheader5%"=="" set "hostheader1=%hostheader1%,http/*:80:%hostheader5%" 
if not "%hostheader6%"=="" set "hostheader1=%hostheader1%,http/*:80:%hostheader6%" 
if not "%hostheader7%"=="" set "hostheader1=%hostheader1%,http/*:80:%hostheader7%" 
if not "%hostheader8%"=="" set "hostheader1=%hostheader1%,http/*:80:%hostheader8%" 
if not "%hostheader9%"=="" set "hostheader1=%hostheader1%,http/*:80:%hostheader9%" 
if not "%hostheader10%"=="" set "hostheader1=%hostheader1%,http/*:80:%hostheader10%" 
if not "%hostheader11%"=="" set "hostheader1=%hostheader1%,http/*:80:%hostheader11%" 
if not "%hostheader12%"=="" set "hostheader1=%hostheader1%,http/*:80:%hostheader12%" 

if not "%hostheader13%"=="" ( 
	echo Script is currently limited to a maximum of 12 hostheaders - the rest will not be added 
	pause
)

"%windir%\System32\inetsrv\appcmd.exe" list site /bindings:http/*:80:%hostheader1% /state:Started  /xml | "%windir%\System32\inetsrv\appcmd.exe" stop site /in 
goto Step4

:Step3NoHostheader
"%windir%\System32\inetsrv\appcmd.exe" list site /bindings:http/*:80: /state:Started  /xml | "%windir%\System32\inetsrv\appcmd.exe" stop site /in 


:Step4
echo Performing step 4
"%windir%\system32\inetsrv\appcmd.exe" add apppool /name:"%APPNAME%" /enable32BitAppOnWin64:true
"%windir%\system32\inetsrv\appcmd.exe" set config /section:applicationPools /[name='"%APPNAME%"'].processModel.identityType:NetworkService  
if "Integrated"=="%managedPipelineMode%" (
  "%windir%\System32\inetsrv\appcmd.exe" set apppool "%APPNAME%" /enable32BitAppOnWin64:true /managedPipelineMode:Integrated 
) else ( 
  "%windir%\System32\inetsrv\appcmd.exe" set apppool "%APPNAME%" /enable32BitAppOnWin64:true /managedPipelineMode:Classic
)
REM http://weblogs.asp.net/steveschofield/archive/2006/11/12/IIS7-_2D00_-post-_2300_14-_2D00_-Misc-appcmd-commands_2E00_.aspx

:Step5
echo Performing step 5
if "%HOSTHEADER%"=="" goto Step5NoHostheader

:Step5WithHostheader 
"%windir%\system32\inetsrv\appcmd.exe" add site /name:"%WEBNAME%" /bindings:http/*:80:%hostheader1%  /physicalPath:"%WEBROOT%" -applicationDefaults.applicationPool:"%APPNAME%" 
REM multiple hostheaders can be bound by using /bindings:http/*:80:abtfonden.fm.localhost,http/*:80:abtfonden.fm.localhost
goto Step6

:Step5NoHostheader
"%windir%\system32\inetsrv\appcmd.exe" add site /name:"%WEBNAME%" /bindings:http:/*:80: /physicalPath:"%WEBROOT%" -applicationDefaults.applicationPool:"%APPNAME%" 
REM http://weblogs.asp.net/steveschofield/archive/2006/11/12/IIS7-_2D00_-post-_2300_14-_2D00_-Misc-appcmd-commands_2E00_.aspx


:Step6
echo Performing step 6
REM SET ASP.Net Version to 2.0 on ALL sites on IIS (regardless of existing sites...!) // REM "%ASPNETFRAMEWORK_REGIIS_PATH%" -s w3svc
REM http://msdn.microsoft.com/en-us/library/ms689467.aspx
if "%ASPNETFRAMEWORK_REGIIS_PATH%"=="%WINDIR%\Microsoft.NET\Framework\v1.1.4322\aspnet_regiis.exe" goto Step6ASP11
if "%ASPNETFRAMEWORK_REGIIS_PATH%"=="%WINDIR%\Microsoft.NET\Framework\v2.0.50727\aspnet_regiis.exe" goto Step6ASP20
if "%ASPNETFRAMEWORK_REGIIS_PATH%"=="%WINDIR%\Microsoft.NET\Framework64\v2.0.50727\aspnet_regiis.exe" goto Step6ASP20
if "%ASPNETFRAMEWORK_REGIIS_PATH%"=="%WINDIR%\Microsoft.NET\Framework\v4.0.30319\aspnet_regiis.exe" goto Step6ASP40
if "%ASPNETFRAMEWORK_REGIIS_PATH%"=="%WINDIR%\Microsoft.NET\Framework64\v4.0.30319\aspnet_regiis.exe" goto Step6ASP40
goto Step6ASP20

:Step6ASP11
"%windir%\System32\inetsrv\appcmd.exe" set apppool "%APPNAME%" /managedRuntimeVersion:v1.1
GOTO:EOF

:Step6ASP20
"%windir%\System32\inetsrv\appcmd.exe" set apppool "%APPNAME%" /managedRuntimeVersion:v2.0
GOTO:EOF

:Step6ASP40
REM Default setup on  IIS7 is a Framework 4.0 setup... 
"%windir%\System32\inetsrv\appcmd.exe" set apppool "%APPNAME%" /managedRuntimeVersion:v4.0
GOTO:EOF

:INVALIDPARAMETERS
echo SCRIPT TERMINATED: invalid parameters 
echo    IISx.create.bat %*
echo.
echo Example: 
echo    call ".\IISx.create.bat" WEBROOT HOSTHEADER WEBNAME APPNAME ASPNETFRAMEWORK_REGIIS_PATH
echo    call ".\IISx.create.bat" "D:\SDU776.0507\WebSite" "" "SDU776 SDU Intranet" "SDU776 AppPool" "%WINDIR%\Microsoft.NET\Framework\v2.0.50727\aspnet_regiis.exe"
echo    call ".\IISx.create.bat" "D:\SDU776.0507\WebSite" "localhost.sdu.dk,localhost.sdunet.sdu.dk" "SDU776 SDU Intranet" "SDU776 AppPool" "%WINDIR%\Microsoft.NET\Framework\v2.0.50727\aspnet_regiis.exe"
echo.
pause
GOTO:EOF

:IISScriptMissing
echo SCRIPT TERMINATED: "%windir%\system32\inetsrv\appcmd.exe" is missing
pause
GOTO:EOF

:FrameWorkFolderMissing
echo SCRIPT TERMINATED: "%ASPNETFRAMEWORK_REGIIS_PATH%" is missing
echo The asp.net framework version is either not installed or deprecated
pause
GOTO:EOF

:ValidateSystemFailed
echo SCRIPT TERMINATED: System not supported
pause
GOTO:EOF

:HELP
echo.
echo   Creates IIS7 Website and App Pool
echo.
echo   IIS7.CREATE webroot hostheader webname appname aspnetframework_regiis_path managedPipelineMode bin
echo.
echo   webroot     Specifies the site path 
echo   hostheader  Specifies the hostheader names (will always bind to :80)
echo               Can be set empty and can set multiple by separating with comma
echo   webname     Specifies the site name 
echo   appname     Specifies the name of the application pool to bind to
echo   aspnetframework_regiis_path
echo               Specifies the path to the framework regiis file
echo   managedPipelineMode 
echo               Classic or Integrated (default is Classic)
echo   bin         Specifies the folder for the global script utilities
echo.
echo   Step 1:   Validate System
echo   Step 2:   Create Configuration Backup 
echo   Step 3:   If hostheader not provided Stops all other websites (W3SVC/x)
echo   Step 4:   Create ApplicationPool %APPNAME% 
echo   Step 5:   Create Website %WEBNAME% (%WEBROOT%) 
echo   Step 6:   Set Framework version on Application Pool Site

GOTO:EOF

