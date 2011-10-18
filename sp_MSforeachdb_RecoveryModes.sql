USE [master]
DECLARE @command varchar(1000)
SELECT @command = 'IF (''?'' NOT IN(''master'', ''model'', ''msdb'', ''tempdb'')) AND (''?'' IN (SELECT name FROM sys.databases where recovery_model_desc <> ''SIMPLE'')) BEGIN ALTER DATABASE [?] SET RECOVERY SIMPLE END '
EXEC sp_MSforeachdb @command 

--SELECT name FROM sys.databases where recovery_model_desc <> 'SIMPLE'