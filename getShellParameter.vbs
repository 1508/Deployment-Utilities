
Const ForWriting = 2
Const ForAppending = 8

strParameterName = Wscript.Arguments(0)
strFileName = Wscript.Arguments(1)

strLine = WScript.StdIn.ReadLine()

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objParameterFile = objFSO.OpenTextFile(strFileName, ForAppending, TRUE)
objParameterFile.Write "SET " & strParameterName & "=" & strLine & VbCrLf
objParameterFile.Close 