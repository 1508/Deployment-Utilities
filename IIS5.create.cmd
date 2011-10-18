@echo off

REM @echo off
REM
REM call "\\QA\utilities\deployment\IIS.create.bat" WEBROOT ASPNETFRAMEWORK_REGIIS_PATH
REM call "\\QA\utilities\deployment\IIS6.create.bat" "D:\SDU776.0507\WebSite" "%WINDIR%\Microsoft.NET\Framework\v2.0.50727\aspnet_regiis.exe"
REM 

if "%~1"=="?" goto HELP
if "%~1"=="/?" goto HELP
if "%~1"=="" goto HELP 

SET WEBROOT=%~1
SET ASPNETFRAMEWORK_REGIIS_PATH=%~2

call :HELP

if "%~1"=="" goto INVALIDPARAMETERS
if "%~2"=="" goto INVALIDPARAMETERS

echo.
echo   WebSite %WEBNAME% (%WEBROOT%) 
echo   AppPool %APPNAME% (not used)
echo.
    
echo Performing step 1
cscript "%bin%\ValidateSystem.XP.vbs" //Nologo
if errorlevel 1 goto ValidateSystemFailed
if not exist "%systemdrive%\inetpub" goto IISMissing
if not exist "%ASPNETFRAMEWORK_REGIIS_PATH%" goto FrameWorkFolderMissing

echo Performing step 2
cscript "%bin%\iisroot.vbs" "%WEBROOT%" 

echo Performing step 3
REM SET ASP.Net Version to 2.0 on ALL sites on IIS (regardless of existing sites...!)
"%ASPNETFRAMEWORK_REGIIS_PATH%" -s w3svc

GOTO:EOF

:INVALIDPARAMETERS
echo Script terminated: invalid parameters IIS.create.bat %*
echo Example: call "\\QA\utilities\deployment\IIS.create.bat" WEBROOT ASPNETFRAMEWORK_REGIIS_PATH
echo Example: call "\\QA\utilities\deployment\IIS.create.bat" "D:\SDU776.0507\WebSite" "%WINDIR%\Microsoft.NET\Framework\v2.0.50727\aspnet_regiis.exe"
pause
GOTO:EOF

:IISMissing
echo Script terminated: "%systemdrive%\Inetpub" is missing
echo The localhost does not have IIS installed... no changes made.
pause
GOTO:EOF

:FrameWorkFolderMissing
echo Script terminated: "%ASPNETFRAMEWORK_REGIIS_PATH%" is missing
echo The asp.net framework version is either not installed or deprecated
pause
GOTO:EOF

:ValidateSystemFailed
echo IIS Script terminated.
pause
GOTO:EOF

:HELP
echo  Setup XP IIS 5.1 default root to Website and run aspnetregiis
echo.
echo  IIS5.CREATE webroot aspnetframework_regiis_path
echo.
echo  webroot     Specifies the site path 
echo  aspnetframework_regiis_path
echo              Specifies the path to the framework regiis file
echo.
echo   Step 1:   Validate System
echo   Step 2:   Override Website Root
echo   Step 3:   Register Asp.Net with "aspnet_regiis -s w3svc" on all Sites,
echo             this overrides any custom asp.net site settings
echo.
GOTO:EOF
