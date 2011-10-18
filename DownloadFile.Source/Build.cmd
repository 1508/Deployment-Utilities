@echo off
call "%VS90COMNTOOLS%vsvars32.bat"
MSBuild.exe DownloadFile.csproj /property:Configuration=Release;OutDir=.\
del .\DownloadFile.pdb /Q
rd .\obj /S /Q

pause

del .\ReplaceUtil.vshost.exe.manifest /Q
del .\ReplaceUtil.vshost.exe /Q
del .\*.suo /Q
