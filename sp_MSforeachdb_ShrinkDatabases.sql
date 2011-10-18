USE [master]
DECLARE @command varchar(1000)
SELECT @command = 'IF ''?'' NOT IN(''master'', ''model'', ''msdb'', ''tempdb'') BEGIN DBCC SHRINKDATABASE(N''?'' ) END '
EXEC sp_MSforeachdb @command
