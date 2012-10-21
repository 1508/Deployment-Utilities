@echo off
cls

SET bin=\\QA\utilities\Deployment
SET source=\\QA\Solutions\FIN 516\fm.dk
SET target=D:\Solutions\FIN 516\fm.dk

@echo off

SET bin=\\dev6\Utilities\Deployment
SET source=\\dev3\Solutions\DLG 1134\kongskilde.com
SET sourcelocalpath=D:\Solutions\DLG 1134\kongskilde.com
SET target=D:\Solutions\DLG 1134\kongskilde.com

echo.
echo   Deploy Developer Environment [Version 100128] 
echo   Source    %source%
echo   Target    %target%
echo.
echo Press control+c to cancel
pause 

rem ECHO. 
rem ECHO. CLEAN QA SOLUTION
rem ECHO. 

rem call "%bin%\Clean.QA.Solution.cmd" "%source%"

ECHO. 
ECHO. PREPARE LOCAL FOLDER STRUCTURE
ECHO. 

md "D:\Solutions"
md "D:\Solutions\DLG 1134"
md "%target%"
md "%target%\Databases"
md "%target%\Databases Backup"

ECHO. 
ECHO. SVN CHECKOUT
ECHO. 

call "%bin%\SVN.checkout.cmd" "http://svn/DLG1134.0502/trunk/" "%target%"

ECHO. 
ECHO. SVN UPDATE
ECHO. 

call "%bin%\SVN.update.cmd" "%target%"

ECHO. 
ECHO. SET FILE PERMISSIONS
ECHO. 

call "%bin%\FILE.permission.cmd" "%target%\src"

ECHO. 
ECHO. PREPARE LOCAL SQL INSTALLATION
ECHO. 

call "%bin%\MSSQL2008.init.cmd" sa passw0rd

ECHO. 
ECHO. COPY SQL DATABASES FROM QA
ECHO. 

del "%source%\Databases Backup\*.bak" /Q
call "%bin%\SQL.backup.cmd" dev3 sa passw0rd "DLG1134%%%%" "%sourcelocalpath%\Databases Backup\"
call "%bin%\robocopy" "%source%\Databases Backup" "%target%\Databases Backup" /E /NC /NJH /ETA
call "%bin%\SQL.restore.cmd" localhost sa passw0rd "%target%\Databases Backup\" "%target%\Databases\" 6

ECHO. 
ECHO. SETUP HOST FILE
ECHO. 

"%bin%\sudo.cmd" cmd /c "echo.>> C:\WINDOWS\system32\drivers\etc\hosts"
"%bin%\sudo.cmd" cmd /c "echo 127.0.0.1	kongskilde.dev	#D:\Solutions\DLG 1134\kongkilde.com >> C:\WINDOWS\system32\drivers\etc\hosts"
"%bin%\sudo.cmd" cmd /c "call "nbtstat" -R

ECHO. 
ECHO. SETUP IIS 
ECHO. 

call "%bin%\IISx.create.cmd" "%target%\src\Kongskilde.Web" "Kongskilde.dev" "DLG 1134 kongskilde.com" "DLG 1134 kongskilde AppPool" "%WINDIR%\Microsoft.NET\Framework\v4.0.30319\aspnet_regiis.exe" "Integrated"

ECHO. 
ECHO. BUILD
ECHO. 

call "%bin%\VS2012.build.cmd" "%target%\src\Kongskilde.sln"
call "%bin%\wait.cmd" 5

ECHO. 
ECHO. DONE!
ECHO.

pause