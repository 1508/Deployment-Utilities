SET NOCOUNT ON
SELECT '$(ServerName)' AS ServerName
			,CAST( DB_NAME(mf.database_id) AS varchar) AS databaseName
            ,CAST(size_on_disk_bytes AS varchar(15)) as size_on_disk
			,CAST(dbs.state_desc AS varchar(10)) as [state]
			,CAST(dbs.recovery_model_desc AS varchar(10)) as rec_model
			,CAST(dbusers.name AS varchar(10)) as [Owner]
            ,CAST(num_of_reads AS varchar(15)) as num_of_reads
            ,CAST(num_of_bytes_read AS varchar(15)) as num_of_bytes_read
            ,CAST(io_stall_read_ms AS varchar(15)) as io_stall_read_ms
            ,CAST(num_of_writes AS varchar(15)) as num_of_writes
            ,CAST(num_of_bytes_written AS varchar(15)) as num_of_bytes_written
            ,CAST(io_stall_write_ms AS varchar(15)) as io_stall_write_ms
            ,CAST(io_stall AS varchar(15)) as io_stall
			,CAST(dbs.compatibility_level AS varchar(15)) as compa_level
			,CAST(dbs.page_verify_option_desc AS varchar(15)) as page_verify
			,CAST(mf.physical_name AS varchar(100)) AS physical_name
            FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS divfs
            JOIN sys.master_files AS mf ON mf.database_id = divfs.database_id
			JOIN sys.databases AS dbs ON dbs.database_id = mf.database_id 
			JOIN sys.server_principals AS dbusers ON dbusers.sid = dbs.owner_sid
            AND mf.file_id = divfs.file_id
            --ORDER BY num_of_reads DESC 
            ORDER BY size_on_disk_bytes DESC