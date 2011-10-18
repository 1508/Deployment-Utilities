@echo off

IF "%1"=="" GOTO MISSINGPARAM
IF "%2"=="" GOTO MISSINGPARAM

echo.
echo.
echo.
echo.
echo. %date% %time% 
echo. UNJOIN DOMAIN AND REBOOT
echo.
echo.
echo.

PAUSE

@ping 127.0.0.1 -n 3 -w 1000 > nul

SET sidlog="C:\VMware Utilities\SID.log"
SET dclog="C:\VMware Utilities\1508lan.log"

DEL %sidlog%
DEL %dclog%

netdom remove %computername% /Domain:1508.lan /ud:%1 /pd:%2 /UserO:%computername%\Administrator /PasswordO:localAdminPassw0rd 

shutdown /r /t 2 /d p:2:4

GOTO EXIT

:MISSINGPARAM
Echo. 
Echo. 
Echo. ERROR: Invalid arguments
Echo. 
Echo. Use Reset.Clone.bat to run
Echo. 
PAUSE

:EXIT
