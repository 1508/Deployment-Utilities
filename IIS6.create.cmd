@echo off

REM @echo off
REM
REM call "\\QA\utilities\deployment\IIS6.create.bat" WEBROOT HOSTHEADER WEBNAME APPNAME ASPNETFRAMEWORK_REGIIS_PATH
REM call "\\QA\utilities\deployment\IIS6.create.bat"  "D:\SDU776.0507\WebSite" "" "SDU776 SDU Intranet" "SDU776 AppPool" "%WINDIR%\Microsoft.NET\Framework\v2.0.50727\aspnet_regiis.exe"
REM 

if "%~1"=="?" goto HELP
if "%~1"=="/?" goto HELP
if "%~1"=="" goto HELP 

SET WEBROOT=%~1
SET HOSTHEADER=%~2
SET WEBNAME=%~3
SET APPNAME=%~4
SET ASPNETFRAMEWORK_REGIIS_PATH=%~5

call :HELP

if "%~1"=="" goto INVALIDPARAMETERS
rem if "%~2"=="" goto INVALIDPARAMETERS
if "%~3"=="" goto INVALIDPARAMETERS
if "%~4"=="" goto INVALIDPARAMETERS
if "%~5"=="" goto INVALIDPARAMETERS

echo   IIS6.CREATE "%WEBROOT%" "%HOSTHEADER%" "%WEBNAME%" "%APPNAME%" "%ASPNETFRAMEWORK_REGIIS_PATH%"
echo. 

:Step1
echo Performing step 1
cscript "%bin%\ValidateSystem.WindowsServer2003.vbs" //Nologo
if not errorlevel 99 goto ValidateSystemFailed

if not exist "%systemdrive%\inetpub\adminscripts\adsutil.vbs" goto IISScriptMissing
if not exist "%ASPNETFRAMEWORK_REGIIS_PATH%" goto FrameWorkFolderMissing


:Step2
echo Performing step 2
REM yymmdd will be the current date.
REM For example June 18 2008 will be in the format 080618
SET yymmdd=%date:~8,2%%date:~3,2%%date:~0,2%
SET hhmmss=%time:~0,2%%time:~3,2%%time:~6,2%
REM Create Backup in IIS Back/Restore  (iisback /backup /b "%yymmdd%.metabase pre %WEBNAME%")
cscript %windir%\System32\iisback.vbs /backup /b "%yymmdd% %hhmmss% metabase pre deploy" //nologo

:Step3
echo Performing step 3
REM stop "Default Web Site"
cscript.exe "%systemdrive%\Inetpub\AdminScripts\adsutil.vbs" STOP_SERVER W3SVC/1 //Nologo
REM stop "SharePoint Administration"
cscript.exe "%systemdrive%\Inetpub\AdminScripts\adsutil.vbs" STOP_SERVER W3SVC/2 //Nologo

:Step4
echo Performing step 4
REM Create AppPool %APPNAME%
REM Cscript.exe "C:\Inetpub\AdminScripts\adsutil.vbs" ENUM /P W3SVC/AppPools //Nologo
REM Cscript.exe "C:\Inetpub\AdminScripts\adsutil.vbs" ENUM /P W3SVC/AppPools/%APPNAME% //Nologo
REM if errorlevel 1 goto 

REM if AppPool allready exists the first line will fail but the remainder will work.
CSCRIPT %SYSTEMDRIVE%\Inetpub\AdminScripts\adsutil.vbs CREATE "w3svc/AppPools/%APPNAME%" IIsApplicationPool //Nologo
CSCRIPT %SYSTEMDRIVE%\Inetpub\AdminScripts\adsutil.vbs SET "w3svc/AppPools/%APPNAME%/PeriodicRestartTime" 0 //Nologo
CSCRIPT %SYSTEMDRIVE%\Inetpub\AdminScripts\adsutil.vbs SET "w3svc/AppPools/%APPNAME%/IdleTimeout" 0 //Nologo
CSCRIPT %SYSTEMDRIVE%\Inetpub\AdminScripts\adsutil.vbs SET "w3svc/AppPools/%APPNAME%/AppPoolState" 2 //Nologo
CSCRIPT %SYSTEMDRIVE%\Inetpub\AdminScripts\adsutil.vbs SET "w3svc/AppPools/%APPNAME%/AppPoolAutoStart" True //Nologo
CSCRIPT %SYSTEMDRIVE%\Inetpub\AdminScripts\adsutil.vbs SET "w3svc/AppPools/%APPNAME%/PeriodicRestartSchedule" "00:07" //Nologo

:Step5
echo Performing step 5
REM Create Website %WEBNAME%
if "%HOSTHEADER%"=="" goto Step5WithHostheader
goto Step5NoHostheader

:Step5WithHostheader

for /f "tokens=1,2,3,4,5,6,7,8,9,10,11,12,13 delims=, " %%a in ("%HOSTHEADER%") do set hostheader1=%%a&set hostheader2=%%b&set hostheader3=%%c&set hostheader4=%%d&set hostheader5=%%e&set hostheader6=%%f&set hostheader7=%%g&set hostheader8=%%h&set hostheader9=%%i&set hostheader10=%%j&set hostheader11=%%k&set hostheader12=%%l&set hostheader13=%%m

cscript %windir%\System32\iisweb.vbs /create "%WEBROOT%" "%WEBNAME%" /d "%hostheader1%" /ap "%APPNAME%" 

if not "%hostheader2%"=="" cscript %windir%\System32\iisweb.vbs /create "%WEBROOT%" "%WEBNAME% (2)" /d "%hostheader2%" /ap "%APPNAME%" 
if not "%hostheader3%"=="" cscript %windir%\System32\iisweb.vbs /create "%WEBROOT%" "%WEBNAME% (3)" /d "%hostheader3%" /ap "%APPNAME%" 
if not "%hostheader4%"=="" cscript %windir%\System32\iisweb.vbs /create "%WEBROOT%" "%WEBNAME% (4)" /d "%hostheader4%" /ap "%APPNAME%" 
if not "%hostheader5%"=="" cscript %windir%\System32\iisweb.vbs /create "%WEBROOT%" "%WEBNAME% (5)" /d "%hostheader5%" /ap "%APPNAME%" 
if not "%hostheader6%"=="" cscript %windir%\System32\iisweb.vbs /create "%WEBROOT%" "%WEBNAME% (6)" /d "%hostheader6%" /ap "%APPNAME%" 
if not "%hostheader7%"=="" cscript %windir%\System32\iisweb.vbs /create "%WEBROOT%" "%WEBNAME% (7)" /d "%hostheader7%" /ap "%APPNAME%" 
if not "%hostheader8%"=="" cscript %windir%\System32\iisweb.vbs /create "%WEBROOT%" "%WEBNAME% (8)" /d "%hostheader8%" /ap "%APPNAME%" 
if not "%hostheader9%"=="" cscript %windir%\System32\iisweb.vbs /create "%WEBROOT%" "%WEBNAME% (9)" /d "%hostheader9%" /ap "%APPNAME%" 
if not "%hostheader10%"=="" cscript %windir%\System32\iisweb.vbs /create "%WEBROOT%" "%WEBNAME% (10)" /d "%hostheader10%" /ap "%APPNAME%" 
if not "%hostheader11%"=="" cscript %windir%\System32\iisweb.vbs /create "%WEBROOT%" "%WEBNAME% (11)" /d "%hostheader11%" /ap "%APPNAME%" 
if not "%hostheader12%"=="" cscript %windir%\System32\iisweb.vbs /create "%WEBROOT%" "%WEBNAME% (12)" /d "%hostheader12%" /ap "%APPNAME%" 

if not "%hostheader13%"=="" ( 
	echo Script is currently limited to a maximum of 12 hostheaders - the rest will not be added 
	pause
)

:Step5NoHostheader
REM Cscript.exe "C:\Inetpub\AdminScripts\adsutil.vbs" ENUM /P W3SVC //Nologo
cscript %windir%\System32\iisweb.vbs /create "%WEBROOT%" "%WEBNAME%" /d "%HOSTHEADER%" /ap "%APPNAME%" 


echo Performing step 6
REM SET ASP.Net Version to 2.0 on ALL sites on IIS (regardless of existing sites...!)
"%ASPNETFRAMEWORK_REGIIS_PATH%" -s w3svc
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
echo SCRIPT TERMINATED: "%systemdrive%\Inetpub\AdminScripts\adsutil.vbs" is missing
echo The localhost is not setup up so a default solution can function... no changes made.
pause
GOTO:EOF

:FrameWorkFolderMissing
echo SCRIPT TERMINATED: "%ASPNETFRAMEWORK_REGIIS_PATH%" is missing
echo The asp.net framework version is either not installed or deprecated
pause
GOTO:EOF

:ValidateSystemFailed
echo SCRIPT TERMINATED
echo System not supported.
echo.
GOTO:EOF

:HELP
echo   Creates IIS6 Website and App Pool
echo.
echo   IIS6.CREATE webroot hostheader webname appname aspnetframework_regiis_path
echo.
echo   webroot     Specifies the site path 
echo   hostheader  Specifies the hostheader names (will always bind to :80)
echo               Can be set empty and can set multiple by separating with comma
echo               (Will create a website with each hostheader)
echo   webname     Specifies the site name 
echo   appname     Specifies the name of the application pool to bind to
echo   aspnetframework_regiis_path
echo               Specifies the path to the framework regiis file
echo.
echo.
echo   Step 1:   Validate System
echo   Step 2:   Create Backup of IIS (can be restored in IIS Backup/Restore)
echo   Step 3:   Stop default website and sharepoint admin website (W3SVC/1 and /2) 
echo             Default webs are unsuitable for development and hosting.
echo   Step 4:   Create ApplicationPool %APPNAME%
echo   Step 5:   Create Website %WEBNAME% (%WEBROOT%) 
echo   Step 6:   Register Asp.Net with "aspnet_regiis -s w3svc" on all Sites,
echo             this overrides any custom asp.net site settings
echo. 
GOTO:EOF
