strComputer = "."
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
Set colItems = objWMIService.ExecQuery("Select * From Win32_OperatingSystem")
bProductTypeServer = false
szCaption = ""
For Each objItem in colItems
    szCaption = objItem.Caption
	'	Win32_OperatingSystem.ProductType	
	'	1-Work Station, 2-Domain Controller, 3-Server 
    if objItem.ProductType = 3 then 
		bProductTypeServer = true
	end if
Next

if (not bProductTypeServer) and (instr(szCaption, "Windows 7") > 0) then 
	wscript.Quit(99)
else
	rem Wscript.Echo "System is not Windows 7 (" & szCaption & ")"
	wscript.Quit(1)
end if 