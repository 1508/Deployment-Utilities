@echo off

IF "%1"=="" GOTO MISSINGPARAM
IF "%2"=="" GOTO MISSINGPARAM

SET sidlog="C:\VMware Utilities\SID.log"
SET dclog="C:\VMware Utilities\1508lan.log"

IF NOT EXIST %sidlog% GOTO NEWSID
IF NOT EXIST %dclog% GOTO JOINDOMAIN

echo.
echo.
echo.
echo.
echo. Virtual machine is ready 
echo.
echo. 
echo. Log files C:\VMware Utilities\*.log
echo.
echo.
@ping 127.0.0.1 -n 3 -w 1000 > nul

GOTO EXIT

:NEWSID
echo.
echo.
echo.
echo.
echo. %date% %time% 
echo. GENERATE NEW SID AND REBOOT
echo. Step 1 of 2
echo.
echo.
echo.

PAUSE

echo.%date% %time% Original SID >> %sidlog%
psgetsid.exe >> %sidlog%

net stop iisadmin /y

SET yymmdd=%date:~8,2%%date:~3,2%%date:~0,2%
SET hhmmss=%date:~0,2%%time:~3,2%%time:~6,2%

NewSid /a /n VM%yymmdd%%hhmmss% 

shutdown /r /t 2 /d p:2:4

GOTO EXIT

:JOINDOMAIN 
echo.
echo.
echo.
echo.
echo. %date% %time% 
echo. JOIN MACHINE TO 1508.LAN AND REBOOT
echo. Step 2 of 2
echo.
echo.
echo.

PAUSE

echo.%date% %time% Joining SID >> %sidlog%
psgetsid.exe >> %sidlog% 

echo.%date% %time% Joining SID >> %dclog%
psgetsid.exe >> %dclog%

netdom join %computername% /domain:1508.lan /ou:"ou=vm,ou=1508,dc=1508,dc=lan" /ud:%1 /pd:%2 /UserO:%computername%\Administrator /PasswordO:localAdminPassw0rd >> %dclog%

shutdown /r /t 2 /d p:2:4

GOTO EXIT

:MISSINGPARAM
Echo. 
Echo. 
Echo. ERROR: Invalid arguments
Echo. 
Echo. Use Join.1508LAN.bat to run
Echo. 
PAUSE

:EXIT
