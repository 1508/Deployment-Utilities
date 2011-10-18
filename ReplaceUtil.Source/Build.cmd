@echo off
call "%VS90COMNTOOLS%vsvars32.bat"
MSBuild.exe ReplaceUtil.csproj /property:Configuration=Release;OutDir=.\
del .\ReplaceUtil.pdb /Q
rd .\obj /S /Q

pause

del .\ReplaceUtil.vshost.exe.manifest /Q
del .\ReplaceUtil.vshost.exe /Q
del .\*.sln /Q
del .\*.suo /Q
