@echo off

if "%~1"=="?" goto HELP
if "%~1"=="/?" goto HELP
if "%~1"=="" goto HELP 

SET SOLUTIONROOT=%~1
SET LOGFILE=%SOLUTIONROOT%\Clean.QA.Solution.Projects.%Date%.log


echo Looping through client projects, progress is logged to %LOGFILE%
pushd "%SOLUTIONROOT%"
for /f "tokens=*" %%d in ('"dir /a:D /B"') do ( 
	pushd "%%d"
	for /f "tokens=*" %%f in ('"dir /a:D /B"') do ( 
		echo. >> %LOGFILE%
		echo Project %%d/%%f  >> %LOGFILE%
		echo. >> %LOGFILE%
		pushd "%%f"
			call Clean.QA.Solution.cmd "%SOLUTIONROOT%\%%d\%%f" >> %LOGFILE%
		popd
	)
	popd
)
popd

goto EXIT

:HELP
echo  Finds all project folders on QA solution drive and call CLEAN.QA.SOLUTION utility for each
echo. 
echo    CLEAN.QA.SOLUTION.PROJECTS [path to qa solution root] 
echo. 
echo    ex. clean.qa.solution.projects.cmd "s:"
echo.
echo    For each subfolder/Project removes/Cleans
echo    - MediaCache, Viewstate under ./Website/App_Data/
echo    - Sitecore ./Data/Serialized ./Data/Dump and log files under ./Data/
echo    - Backups located in root of ./Databases Backup (any backup subfolders are not touched)
echo    - Svn folders 
echo    - Code files not located under ./Website/App_Code, ./Website/Sitecore or ./Website/Umbraco
echo    - Empty folders under ./Website/Applicationcode

:EXIT