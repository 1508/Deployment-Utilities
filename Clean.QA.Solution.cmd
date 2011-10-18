@echo off

if "%~1"=="?" goto HELP
if "%~1"=="/?" goto HELP
if "%~1"=="" goto HELP 

SET SOLUTIONROOT=%~1

rem Der skal være en website folder for at vi kan anse folderen for at være en valid solution folder i QA
if not exist "%SOLUTIONROOT%\Website" ( 
  echo ERROR: No \Website folder found.
  echo        "%SOLUTIONROOT%\Website"
  echo. 
  goto HELP
)

rem Override working directory
pushd "%SOLUTIONROOT%"

if exist "Website\App_Data\MediaCache" ( 
  echo Removing App_Data\MediaCache
  RD /S /Q "Website\App_Data\MediaCache" >NUL
)

if exist "Website\Dump" ( 
  echo Removing Website\Dump
  RD /S /Q "Website\Dump" >NUL
  MD "Website\Dump"
)

if exist "Data\Dump" ( 
  echo Removing Data\Dump
  RD /S /Q "Data\Dump" >NUL
  MD "Data\Dump"
)

if exist "Data\serialization" ( 
  echo Removing Data\serialization
  RD /S /Q "Data\serialization" >NUL
  MD "Data\serialization"
)

if exist "Data\viewstate" ( 
  echo Cleaning Data\viewstate
  RD /S /Q "Data\viewstate" >NUL
  MD "Data\viewstate"
)

if exist "Data\logs\log*.txt" ( 
  echo Cleaning Data\logs
  DEL /Q "Data\logs\log*.txt" >NUL
)

if exist "Data\diagnostics\counters*.txt" ( 
  echo Cleaning Data\diagnostics
  DEL /Q "Data\diagnostics\counters*.txt" >NUL
)

if exist "Data\xpaclogs\log*.txt" ( 
  echo Cleaning Data\xpaclogs
  DEL /Q "Data\xpaclogs\log*.txt" >NUL
)

if exist "Databases Backup\*.bak" ( 
  echo Cleaning *.bak from \Databases Backup
  DEL /Q "Databases Backup\*.bak" >NUL
)

echo Removing any .svn folders
for /f "tokens=*" %%d in ('"dir .svn /a:D /B /S"') do (
  rd /s /q "%%d" >NUL
)

echo Removing .cs files (excluding App_Code, app_code, sitecore and umbraco folders)
for /f "tokens=*" %%d in ('"dir Website /a:D /B"') do (
  if not "%%d" == "App_Code" (
    if not "%%d" == "app_code" (
      if not "%%d" == "sitecore" (
	    if not "%%d" == "umbraco" (
		  echo Scanning "%%d" for code files
		  pushd "website\%%d"
		  for /f "tokens=*" %%f in ('"dir *.cs /B /S"') do (
		    echo Deleting .\Website\%%d\\%%f
			del /q "%%f" 
          ) 
		  popd
        ) 
	  )
    )
  )
)

if exist "Website\Applicationcode" ( 
  echo Removing Empty folders under Website\Applicationcode
  for /F "tokens=*" %%i in ('"dir Website\Applicationcode\* /AD/B/S | SORT /R"') do rmdir /q "%%i" >NUL
  rem if empty remove application code too
  rmdir /q "Website\Applicationcode" >NUL
)

rem Reset to working directory
popd

goto EXIT

:HELP
echo  Removes any files that are unnessesary for the solutions on a QA environment
echo. 
echo    CLEAN.QA.SOLUTION [path to qa solution] 
echo.
echo    Removes/Cleans
echo    - MediaCache, Viewstate under ./Website/App_Data/
echo    - Sitecore ./Data/Serialized ./Data/Dump and log files under ./Data/
echo    - Backups located in root of ./Databases Backup (any backup subfolders are not touched)
echo    - Svn folders 
echo    - Code files not located under ./Website/App_Code, ./Website/Sitecore or ./Website/Umbraco
echo    - Empty folders under ./Website/Applicationcode

:EXIT