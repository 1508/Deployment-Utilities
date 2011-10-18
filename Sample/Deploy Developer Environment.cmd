@echo off
cls

SET bin=\\QA\utilities\Deployment
SET source=\\QA\Solutions\FIN 516\fm.dk
SET target=D:\Solutions\FIN 516\fm.dk

echo.
echo   Deploy Developer Environment [Version 090922] 
echo   Source    %source%
echo   Target    %target%
echo.
echo Press control+c to cancel
pause 

ECHO. 
ECHO. PREPARE LOCAL FOLDER STRUCTURE
ECHO. 

md "D:\Solutions"
md "D:\Solutions\FIN 516"
md "%target%"
md "%target%\Data"
md "%target%\Website"
md "%target%\Databases"
md "%target%\Databases Backup"
rem md "%target%\Utilities"

ECHO. 
ECHO. SVN CHECKOUT
ECHO. 

REM Check out must be done before files are copied, check out does not function with existing files... 
call "%bin%\SVN.checkout.cmd" "http://svn/FIN516.0523/trunk/ftp/www" "%target%\Website"
call "%bin%\SVN.checkout.cmd" "http://svn/FIN516.0523/trunk/ftp/data" "%target%\Data"

REM Checked out files must be moved away and then back to not get overwritten.
call "%bin%\robocopy" "%target%\Website" "%target%\WebsiteSVN" /E /NC /NJH /NDL /NFL  
call "%bin%\robocopy" "%target%\Data" "%target%\DataSVN" /E /NC /NJH /NDL /NFL  

ECHO. 
ECHO. COPYING MAIN WEBSITE FILES 
ECHO. Please wait...

call "%bin%\robocopy" "%source%\Website" "%target%\Website" /E /NC /NJH /NFL
call "%bin%\robocopy" "%target%\WebsiteSVN" "%target%\Website" /E /NC /NJH /NDL /NFL 
rd "%target%\WebsiteSVN\" /S /Q

call "%bin%\robocopy" "%source%\Data" "%target%\Data" /E /NC /NJH /NFL
call "%bin%\robocopy" "%target%\DataSVN" "%target%\Data" /E /NC /NJH /NDL /NFL 
rd "%target%\DataSVN\" /S /Q

ECHO. 
ECHO. SVN UPDATE
ECHO. 

call "%bin%\SVN.update.cmd" "%target%\Website\"
call "%bin%\SVN.update.cmd" "%target%\Data\"

ECHO. 
ECHO. SET FILE PERMISSIONS
ECHO. 

call "%bin%\FILE.permission.cmd" "%target%\Website"
call "%bin%\FILE.permission.cmd" "%target%\Data"

ECHO. 
ECHO. PREPARE LOCAL SQL INSTALLATION
ECHO. 

call "%bin%\MSSQL2008.init.cmd" sa passw0rd

ECHO. 
ECHO. COPY SQL DATABASES FROM QA
ECHO. 

del "%source%\Databases Backup\*.bak" /Q

call "%bin%\SQL.backup.cmd" dev6 sa passw0rd "fm.dk%%%%" "D:\Solutions\FIN 516\fm.dk\Databases Backup\"
rem NB! This D:\Solutions\FIN 516\fm.dk\Databases.Backups\ is the local path on dev6 not localhost!

call "%bin%\robocopy" "%source%\Databases Backup" "%target%\Databases Backup" /E /NC /NJH /ETA
rem xcopy "%source%\Databases Backup\*.bak" "%target%\Databases Backup\" /Y

call "%bin%\SQL.restore.cmd" localhost sa passw0rd "%target%\Databases Backup\" "%target%\Databases\" 3

ECHO. 
ECHO. SETUP IIS 
ECHO. 

call "%bin%\IISx.create.cmd" "%target%\Website" "fin.dev" "FIN 516 fm.dk" "FIN 516 AppPool" "%WINDIR%\Microsoft.NET\Framework\v2.0.50727\aspnet_regiis.exe"

ECHO. 
ECHO. BUILD
ECHO. 

call "%bin%\VS2008.build.cmd" "%target%\Website\Finansministeriet.Web.sln"

call "%bin%\wait.cmd" 5

ECHO. 
ECHO. OPEN WEBSITES
ECHO. 

start "" "C:\Program Files\Internet Explorer\iexplore.exe" "http://fin.dev"

ECHO. 
ECHO. DONE!
ECHO.

pause