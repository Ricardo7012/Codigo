-- https://blog.sqlauthority.com/2011/02/18/sql-server-logbuffer-wait-type-day-18-of-28/
-- SQL SERVER – Find Most Active Database in SQL Server – DMV dm_io_virtual_file_stats
SELECT DB_NAME(mf.database_id)                 AS databaseName
     , name                                    AS File_LogicalName
     , CASE
           WHEN type_desc = 'LOG'
               THEN
               'Log File'
           WHEN type_desc = 'ROWS'
               THEN
               'Data File'
           ELSE
               type_desc
       END                                     AS File_type_desc
     , mf.physical_name
     , num_of_reads
     , num_of_bytes_read
     , io_stall_read_ms
     , num_of_writes
     , num_of_bytes_written
     , io_stall_write_ms
     , io_stall
     , size_on_disk_bytes
     , size_on_disk_bytes / 1024               AS size_on_disk_KB
     , size_on_disk_bytes / 1024 / 1024        AS size_on_disk_MB
     , size_on_disk_bytes / 1024 / 1024 / 1024 AS size_on_disk_GB
FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS divfs
    JOIN sys.master_files                     AS mf
        ON mf.database_id = divfs.database_id
           AND mf.file_id = divfs.file_id
ORDER BY num_of_reads DESC;

-- SQL SERVER – Get File Statistics Using fn_virtualfilestats 
-- https://blog.sqlauthority.com/2011/01/08/sql-server-get-file-statistics-using-fn_virtualfilestats/
SELECT DB_NAME(vfs.DbId) DatabaseName
     , mf.name
     , mf.physical_name
     , vfs.BytesRead
     , vfs.BytesWritten
     , vfs.IoStallMS
     , vfs.IoStallReadMS
     , vfs.IoStallWriteMS
     , vfs.NumberReads
     , vfs.NumberWrites
     , (size * 8) / 1024 Size_MB
FROM::fn_virtualfilestats(NULL, NULL) vfs
    INNER JOIN sys.master_files       mf
        ON mf.database_id = vfs.DbId
           AND mf.file_id = vfs.FileId;
GO

-- SQL SERVER – Introduction to Three Important Performance Counters
-- https://blog.sqlauthority.com/2008/02/13/sql-server-introduction-to-three-important-performance-counters/

SELECT cpu_time
     , reads
     , writes
     , logical_reads
     , text_size
     , wait_type
     , wait_time
     , wait_resource
     , last_wait_type
     , open_transaction_count
FROM sys.dm_exec_requests
WHERE database_id = 5;
GO 