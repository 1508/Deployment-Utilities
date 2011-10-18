/* 

   BackupToDisk
 
   $(BackupPath)            -- backup target, saves with databasename and *.YYYY.MM.DD.bak (todays date)
   $(DatabaseName)          -- patterne used to find databases to backup 
 
   Usage
      sqlcmd -S %1 -U %2 -P %3 -i "BackupToDisk.sql" -v DatabaseName = %4 -v BackupPath = %5
 
   Notes
      Forces naming convention on physical and logical names and forces the user to use fresh backups.	  
   
   Date         Author                 Notes
   2008-12-10   jhe@1508.dk            Initial release
   2009-02-26   jhe@1508.dk            Tweaked date format for filename 
   
*/
DECLARE @dbName nvarchar(255)
DECLARE @fileName nvarchar(255)
DECLARE @backupName nvarchar(255)
DECLARE @dato nvarchar(255)

DECLARE dbCursor1 CURSOR FOR
    SELECT [name] FROM sysdatabases WHERE [name] LIKE '$(DatabaseName)'	-- e.g. 'sduIntranet%'
    OPEN dbCursor1
        FETCH NEXT FROM dbCursor1
        INTO @dbName
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @dato = CONVERT(VARCHAR(10), GETDATE(), 102) -- [YYYY.MM.DD]
            --SET @fileName = 'D:\www\2008-02-12 - SDU Intranet\Databases.Backups\' + @dbName + '.' +  @dato +'.bak'
			--SET @fileName = 'D:\SDU776.0507\Databases.Backups\' + @dbName + '.' +  @dato +'.bak'
			SET @fileName = '$(BackupPath)' + @dbName + '.' +  @dato +'.bak'
            SET @backupName = @dbName + ' Backup'
			PRINT @backupName
            IF @dbName <> 'tempdb'
            BEGIN
				BACKUP DATABASE @dbName TO DISK = @FileName  WITH  COPY_ONLY, INIT ,  NOUNLOAD , NAME = @backupName,  NOSKIP ,  STATS = 10,  NOFORMAT
            END
            FETCH NEXT FROM dbCursor1
            INTO @dbName
        END
    CLOSE dbCursor1
DEALLOCATE dbCursor1

