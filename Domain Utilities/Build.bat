@echo off

IF "%1"=="" GOTO MISSINGPARAM
IF "%2"=="" GOTO MISSINGPARAM

echo.
echo. %date% %time% 
echo. GENERATING JOB FILES AND REFRESH CLIENT TOOLS BIN 
echo.
@ping 127.0.0.1 -n 3 -w 1000 > nul

Utilities\CPAU.exe -u administrator -p localAdminPassw0rd -ex "Join.1508LAN.runtime.bat %1 %2" -enc -file "Join.1508LAN.cpj" -crc "Join.1508LAN.runtime.bat"
Utilities\CPAU.exe -u administrator -p localAdminPassw0rd -ex "Reset.Clone.runtime.bat %1 %2" -enc -file "Reset.Clone.cpj" -crc "Reset.Clone.runtime.bat"

del "Client tools\bin\*.*" /Q
xcopy "Utilities\*.*" "Client tools\bin" /y
xcopy Join.1508LAN* "Client tools\bin" /y
xcopy Reset.Clone* "Client tools\bin" /y

echo. 
echo. DONE
echo. 

GOTO EXIT

:MISSINGPARAM
Echo. 
Echo. 
Echo. ERROR: Invalid arguments
Echo. 
Echo. Missing credentials for domain admin account e.g.  
Echo.   Build.bat 1508lan\vmware xxxxx
Echo. 
Echo. Readme.txt for further information
Echo. 
PAUSE

:EXIT
