/* 

   AttachFromDisk
 
   $(AttachPath)            -- mdf source, searches for *.mdf
   $(AttachExpectedCount)   -- validate the amount of *.mdf files before restore
 
   Usage
      sqlcmd -S %1 -U %2 -P %3 -i "AttachToDisk.sql" -v AttachPath=%4 -v AttachExpectedCount=%5
 
   Requires
      Matching '*.mdf' and '*_Log.ldf' files
      xp_cmdshell must be enabled to get access to disk 
 
   Notes
      Forces naming convention on physical and logical names.
   
   Date         Author                 Notes
   2009-04-27   jhe@1508.dk            Initial release
   2009-07-08   jhe@1508.dk            Fixed documentation
   2009-11-12   cpa@1508.dk            Tilføjet @fileList) = 1 AND (@attachExpectedCount > 1))
*/
DECLARE @attachPath NVARCHAR(500)
DECLARE @attachRestorePath NVARCHAR(500)
DECLARE @attachExpectedCount int
DECLARE @attachFile NVARCHAR(500)
DECLARE @attachFilePath NVARCHAR(1000)
DECLARE @attachFileName NVARCHAR(500)
DECLARE @restoreFilePathData NVARCHAR(1000)
DECLARE @restoreFilePathLog NVARCHAR(1000)
DECLARE @cmd NVARCHAR(4000) 
DECLARE @fileList TABLE (backupFile NVARCHAR(255)) 
DECLARE @LogicalNameForData NVARCHAR(500)
DECLARE @LogicalNameForLog NVARCHAR(500)
DECLARE @dato nvarchar(255)

SET @attachPath = '$(AttachPath)'		-- e.g. 'D:\SDU776.0507\Databases.Backups\'
SET @attachExpectedCount = $(AttachExpectedCount)

/* if required set custom date by overriding @date */
SET @dato = CONVERT(VARCHAR(10), GETDATE(), 102) -- [YYYY.MM.DD]
--SET @dato = '2008.12.11'

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


PRINT 'Attaching files'

SET @cmd = 'DIR /b /o:N "' + @attachPath + '*.mdf"'

--PRINT @cmd
--EXEC master.sys.xp_cmdshell @cmd

INSERT INTO @fileList(backupFile)
EXEC master.sys.xp_cmdshell @cmd

IF ((SELECT Count(backupFile) FROM @fileList) = 1 AND (@attachExpectedCount > 1))
BEGIN 
	PRINT ''
	PRINT ''
	PRINT '##############################################' 
	PRINT '  ERROR IN ATTACH  '
	PRINT '----------------------------------------------'
	PRINT ''
	PRINT '  No database files in path ' + @attachPath
	PRINT '  Ending script '
	PRINT ''
	PRINT '----------------------------------------------'
	PRINT '  ERROR IN ATTACH  '
	PRINT '##############################################'
	PRINT ''
	PRINT ''
	RETURN
END 

-- Check that there are 7 databases to restore... the case for any 5.x Sitecore Db Set.
IF (SELECT Count(backupFile) FROM @fileList) <> @attachExpectedCount 
BEGIN 
	PRINT ''
	PRINT ''
	PRINT '##############################################' 
	PRINT '  ERROR IN ATTACH  '
	PRINT '----------------------------------------------'
	PRINT ''
	PRINT '  Invalid numbers of databases (<>'+Cast(@attachExpectedCount as varchar(8))+')'
	PRINT '  Ending script '
	PRINT ''
	PRINT '  Database *.mdf found:' 
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
FETCH NEXT FROM backupFiles INTO @attachFile 

WHILE @@FETCH_STATUS = 0 
BEGIN 
	SET @attachFilePath = @attachPath 
	SET @attachFileName = REPLACE(@attachFile,'.mdf','')
	SET @restoreFilePathData = @attachFilePath + @attachFileName + '.mdf'
	SET @restoreFilePathLog = @attachFilePath + @attachFileName + '_Log.ldf'

	SET @cmd = 'CREATE DATABASE [' + @attachFileName + '] ON '
		+ ' (FILENAME = ''' + @restoreFilePathData + '''), '
		+ ' (FILENAME = ''' + @restoreFilePathLog + ''') '
		+ ' FOR ATTACH;' + char(10)
	
   PRINT @cmd
   EXECUTE(@cmd)

   FETCH NEXT FROM backupFiles INTO @attachFile 
END


CLOSE backupFiles 
DEALLOCATE backupFiles 

GO
