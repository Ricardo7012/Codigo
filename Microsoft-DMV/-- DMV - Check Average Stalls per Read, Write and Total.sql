-- Check Average Stalls per Read, Write and Total

SELECT DB_NAME(vfs.database_id) AS 'DB Name'
	, vfs.database_id
	, vfs.file_id
	, CASE 
		WHEN vfs.file_id = 2
			THEN 'Log'
		ELSE 'Data'
		END AS 'File Type'
	, '' AS '-'
	, vfs.num_of_reads AS 'Number of Reads'
	, vfs.io_stall_read_ms AS 'IO Stall Read (ms)'
	, CAST(vfs.io_stall_read_ms / (1.0 + vfs.num_of_reads) AS NUMERIC(10, 1)) AS 'Avg Read Stall (ms)'
	, '' AS '-'
	, vfs.num_of_writes AS 'Num of Writes'
	, vfs.io_stall_write_ms AS 'IO Stall Write (ms)'
	, CAST(vfs.io_stall_write_ms / (1.0 + vfs.num_of_writes) AS NUMERIC(10, 1)) AS 'Avg Write Stall (ms)'
	, '' AS '-'
	, vfs.io_stall_read_ms + vfs.io_stall_write_ms AS 'IO Stalls'
	, vfs.num_of_reads + vfs.num_of_writes AS 'Total IO'
	, CAST((vfs.io_stall_read_ms + vfs.io_stall_write_ms) / (1.0 + vfs.num_of_reads + vfs.num_of_writes) AS NUMERIC(10, 1)) AS 'Avg IO Stall (ms)'
FROM sys.dm_io_virtual_file_stats(NULL, NULL) vfs
ORDER BY 'DB Name'
