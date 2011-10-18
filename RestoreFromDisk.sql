/* 

   RestoreFromDisk
 
   $(BackupPath)            -- backup sources, searches for *.YYYY.MM.DD.bak (todays date)
   $(BackupRestorePath)     -- restore target
   $(BackupExpectedCount)   -- validate the amount of backup files before restore
 
   Usage
      sqlcmd -S %1 -U %2 -P %3 -i "RestoreFromDisk.sql" -v BackupPath=%4 -v BackupRestorePath=%5 -v BackupExpectedCount=%6
 
   Requires
      The backup files are named with todays date YYYY.MM.DD.bak
      xp_cmdshell must be enabled to get access to disk 
 
   Notes
      Forces naming convention on physical and logical names and forces the user to use fresh backups.	  
   
   Date         Author                 Notes
   2008-12-10   jhe@1508.dk            Initial release
   2009-02-26   jhe@1508.dk            Tweaked error messages, date format for filename search and added if statement on Logical name
   2009-04-29   jhe@1508.dk            Added a CustomDate external parameter that allows wildcard * restore			
   2009-06-02   jhe@1508.dk            Added database switch to Offline if exists, to fix access problems on active databases found e.g. on umbraco env.
   2010-07-09	jhe@1508.dk	           Added support for Sql2008 with extra field TDEThumbprint nvarchar(128) NULL and split file in 2
*/
DECLARE @backupPath NVARCHAR(500)
DECLARE @backupRestorePath NVARCHAR(500)
DECLARE @backupExpectedCount int
DECLARE @backupFile NVARCHAR(500)
DECLARE @backupFilePath NVARCHAR(1000)
DECLARE @backupFileName NVARCHAR(500)
DECLARE @backupCustomDate NVARCHAR(500)
DECLARE @restoreFilePathData NVARCHAR(1000)
DECLARE @restoreFilePathLog NVARCHAR(1000)
DECLARE @cmd NVARCHAR(4000) 
DECLARE @fileList TABLE (backupFile NVARCHAR(255)) 
DECLARE @LogicalNameForData NVARCHAR(500)
DECLARE @LogicalNameForLog NVARCHAR(500)
DECLARE @dato nvarchar(255)

SET @backupPath = '$(BackupPath)'		-- e.g. 'D:\SDU776.0507\Databases.Backups\'
SET @backupRestorePath = '$(BackupRestorePath)' -- e.g. 'D:\SDU776.0507\Databases\'
SET @backupExpectedCount = $(BackupExpectedCount)
SET @backupCustomDate = '$(CustomDate)'		-- if set the date validation is overriden with this value, if * there is no date validation

/* if required set custom date by overriding @date */
SET @dato = '.' + CONVERT(VARCHAR(10), GETDATE(), 102) -- [YYYY.MM.DD]
--SET @dato = '.2008.12.11'

IF (len(@backupCustomDate) > 0)
BEGIN
	SET @dato = @backupCustomDate
END
IF (@backupCustomDate = '*')
BEGIN
	SET @dato = ''	
END 

DECLARE @RESTORE_FILELISTONLY_List TABLE (
 LogicalName nvarchar(128),
 PhysicalName nvarchar(260),
 [Type]  char(1),
 FileGroupName nvarchar(128),
 [Size]  numeric(20,0) NULL,
 [MaxSize] numeric(20,0) NULL,
 FileID bigint,
 CreateLSN numeric(25,0),
 DropLSN numeric(25,0) NULL,
 UniqueID uniqueidentifier,
 ReadOnlyLSN numeric(25,0) NULL,
 ReadWriteLSN numeric(25,0) NULL,
 BackupSizeInBytes bigint,
 SourceBlockSize int,
 FileGroupID int,
 LogGroupGUID uniqueidentifier NULL,
 DifferentialBaseLSN numeric(25,0) NULL,
 DifferentialBaseGUID uniqueidentifier,
 IsReadOnly bit,
 IsPresent bit
)
/*, TDEThumbprint nvarchar(128) NULL   -- SQL2008 kræver dette felt i ovenstående*/

PRINT 'Restoring Backup from ' + @dato

SET @cmd = 'DIR /b /o:N "' + @backupPath + '*'+@dato+'.bak"'

PRINT @cmd
--EXEC master.sys.xp_cmdshell @cmd

INSERT INTO @fileList(backupFile)
EXEC master.sys.xp_cmdshell @cmd

IF (SELECT Count(backupFile) FROM @fileList) = 0 
BEGIN 
	PRINT ''
	PRINT ''
	PRINT '##############################################' 
	PRINT '  ERROR IN RESTORE  '
	PRINT '----------------------------------------------'
	PRINT ''
	PRINT '  No backups marked with ' + @dato + ''
	PRINT '  Ending script '
	PRINT ''
	PRINT '----------------------------------------------'
	PRINT '  ERROR IN RESTORE  '
	PRINT '##############################################'
	PRINT ''
	PRINT ''
	RETURN
END 

-- Check that there are 7 databases to restore... the case for any 5.x Sitecore Db Set.
IF (SELECT Count(backupFile) FROM @fileList) <> @BackupExpectedCount 
BEGIN 
	PRINT ''
	PRINT ''
	PRINT '##############################################' 
	PRINT '  ERROR IN RESTORE  '
	PRINT '----------------------------------------------'
	PRINT ''
	PRINT '  Invalid numbers of databases (<>'+Cast(@BackupExpectedCount as varchar(8))+')'
	PRINT '  Ending script '
	PRINT ''
	PRINT '  Database backups found:' 
	PRINT ''
	SELECT '  - '+ RTRIM(LTRIM(backupFile)) + '' FROM @fileList WHERE Len(RTRIM(LTRIM(ISNULL(backupFile,'')))) > 0
	PRINT ''
	PRINT '----------------------------------------------'
	PRINT '  ERROR IN RESTORE  '
	PRINT '##############################################'
	RETURN 
END 


DECLARE backupFiles CURSOR FOR
SELECT backupFile FROM @fileList 
OPEN backupFiles

-- Loop through all the files for the database 
FETCH NEXT FROM backupFiles INTO @backupFile 

WHILE @@FETCH_STATUS = 0 
BEGIN 
	SET @backupFilePath = @backupPath + @backupFile
	SET @backupFileName = REPLACE(@backupFile,'' + @dato+'.bak','')
	SET @restoreFilePathData = @backupRestorePath + @backupFileName + '.mdf'
	SET @restoreFilePathLog = @backupRestorePath + @backupFileName + '_Log.ldf'

	DELETE FROM @RESTORE_FILELISTONLY_List 
	
	SET @cmd = 'RESTORE FILELISTONLY FROM DISK = ''' + @backupFilePath + ''' '

	INSERT INTO @RESTORE_FILELISTONLY_List exec(@cmd) 

	SELECT TOP 1 @LogicalNameForData = LogicalName FROM @RESTORE_FILELISTONLY_List WHERE Type='D'
	SELECT TOP 1 @LogicalNameForLog = LogicalName FROM @RESTORE_FILELISTONLY_List WHERE Type='L'

	SET @cmd = 'IF  EXISTS (SELECT name FROM sys.databases WHERE name = N''' + @backupFileName + ''') ' + char(10)
	SET @cmd = @cmd + 'ALTER DATABASE [' + @backupFileName + ']  SET OFFLINE WITH ROLLBACK IMMEDIATE ' + char(10)
	
	SET @cmd = @cmd + char(10)
	SET @cmd = @cmd + 'RESTORE DATABASE [' + @backupFileName + '] FROM DISK = ''' + @backupFilePath + ''' WITH RECOVERY, '
		+ 'MOVE ''' + @LogicalNameForData + ''' TO ''' + @restoreFilePathData  + ''', '
		+ 'MOVE ''' + @LogicalNameForLog + ''' TO ''' + @restoreFilePathLog  + ''' ' + char(10)
	
	IF (@LogicalNameForData <> @backupFileName + '_Data')
	BEGIN
		SET @cmd = @cmd + 'ALTER DATABASE [' + @backupFileName + ']  MODIFY FILE  ( NAME = ''' + @LogicalNameForData + ''', NEWNAME = ''' + @backupFileName + '_Data'')' + char(10)
	END 
	
	IF (@LogicalNameForLog <> @backupFileName + '_Log')
	BEGIN
		SET @cmd = @cmd + 'ALTER DATABASE [' + @backupFileName + ']  MODIFY FILE  ( NAME = ''' + @LogicalNameForLog + ''', NEWNAME = ''' + @backupFileName + '_Log'')' + char(10)
	END

	SET @cmd = @cmd + 'ALTER DATABASE [' + @backupFileName + ']  SET ONLINE ' + char(10)
	
   PRINT @cmd
   EXECUTE(@cmd)

   FETCH NEXT FROM backupFiles INTO @backupFile 
END


CLOSE backupFiles 
DEALLOCATE backupFiles 

GO
