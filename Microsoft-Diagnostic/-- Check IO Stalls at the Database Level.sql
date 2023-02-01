-- Check IO Stalls at the Database Level

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT DB_NAME(database_id) AS 'DatabaseName'
	, SUM(CAST(io_stall / 1000.0 AS DECIMAL(20, 2))) AS 'IO Stall (Secs)'
	, SUM(CAST(num_of_bytes_read / 1024.0 / 1024.0 AS DECIMAL(20, 2))) AS 'IO Read (MB)'
	, SUM(CAST(num_of_bytes_written / 1024.0 / 1024.0 AS DECIMAL(20, 2))) AS 'IO Written (MB)'
	, SUM(CAST((num_of_bytes_read + num_of_bytes_written) / 1024.0 / 1024.0 AS DECIMAL(20, 2))) AS 'IO Total (MB)'
FROM sys.dm_io_virtual_file_stats(NULL, NULL)
GROUP BY database_id
ORDER BY [IO Stall (Secs)] DESC