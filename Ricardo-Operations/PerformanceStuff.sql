--https://blogs.msdn.microsoft.com/sqlsakthi/2011/02/09/troubleshooting-sql-server-io-requests-taking-longer-than-15-seconds-io-stalls-disk-latency/

SELECT SUM(pending_disk_io_count) AS [Number of pending I/Os]
FROM sys.dm_os_schedulers;

SELECT *
FROM sys.dm_io_pending_io_requests;

SELECT DB_NAME(database_id) AS [Database],
       [file_id],
       [io_stall_read_ms],
       [io_stall_write_ms],
       [io_stall]
FROM sys.dm_io_virtual_file_stats(NULL, NULL);


--DBCC MEMORYSTATUS
PRINT @@SERVERNAME
PRINT GETDATE()

SELECT type,
       SUM(pages_kb) /1024 as pages_mb
FROM sys.dm_os_memory_clerks
WHERE pages_kb <> 0
GROUP BY type
ORDER BY SUM(pages_kb) DESC;

SELECT * FROM sys.dm_os_virtual_address_dump
SELECT * FROM sys.dm_exec_cached_plans
SELECT * FROM sys.dm_exec_query_memory_grants
SELECT * FROM sys.dm_exec_query_resource_semaphores
SELECT * FROM sys.dm_exec_requests
SELECT * FROM sys.dm_exec_sessions
SELECT * FROM sys.dm_os_memory_cache_entries
