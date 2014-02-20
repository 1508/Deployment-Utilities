SET NOCOUNT ON
SELECT '$(ServerName)' AS ServerName
			,CAST( DB_NAME(mf.database_id) AS varchar) AS databaseName
            ,CONVERT(varchar(20),REPLACE(CONVERT(varchar(20), CAST(size_on_disk_bytes AS Money), 1),'.00','')) as size_on_disk
            ,CAST(num_of_bytes_read AS varchar(15)) as num_of_bytes_read
            ,CAST(num_of_bytes_written AS varchar(15)) as num_of_bytes_written
            FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS divfs
            JOIN sys.master_files AS mf ON mf.database_id = divfs.database_id
			JOIN sys.databases AS dbs ON dbs.database_id = mf.database_id 
			JOIN sys.server_principals AS dbusers ON dbusers.sid = dbs.owner_sid
            AND mf.file_id = divfs.file_id
			WHERE size_on_disk_bytes > 1000000000
            ORDER BY size_on_disk_bytes DESC
