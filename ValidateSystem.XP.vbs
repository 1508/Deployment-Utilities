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
' Validate XP system

if (not bProductTypeServer) and (instr(szCaption, "XP") > 0) then 
	dim answer
	answer=MsgBox("Overwrite default website homefolder? " & vbNewLine & Chr(149) & " Yes, homefolder on default website is updated" & vbNewLine & Chr(149) & " No, you set IIS information manually",4,"IIS default website homefolder")
	if (answer=6) then
		Wscript.Echo "Overwrite IIS root information"
		wscript.Quit(99)
	elseif (answer=7) then
		Wscript.Echo "Skipping IIS root information, must be set manually"
		wscript.Quit(1)
	end if
	wscript.Quit(99)
else
	rem Wscript.Echo "System is not Windows XP (" & szCaption & ")"
	wscript.Quit(1)
end if 
