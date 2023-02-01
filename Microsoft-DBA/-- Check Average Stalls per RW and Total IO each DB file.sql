-- Check Average Stalls per RW and total IO each DB file

SELECT DB_NAME(fs.database_id) AS 'Database Name'
	, mf.physical_name AS 'Physical Name'
	, io_stall_read_ms AS 'IO Stall Read (ms)'
	, io_stall_read_ms / 1000 AS 'IO Stall Read (sec)'
	, num_of_reads AS '# of Reads'
	, CAST(io_stall_read_ms / (1.0 + num_of_reads) AS NUMERIC(10, 1)) AS 'Avg Read Stall (ms)'
	, io_stall_write_ms AS 'IO Stall Write (ms)'
	, io_stall_write_ms / 1000 AS 'IO Stall Write (sec)'
	, num_of_writes AS '# of Writes'
	, CAST(io_stall_write_ms / (1.0 + num_of_writes) AS NUMERIC(10, 1)) AS 'Avg Write Stall (ms)'
	, io_stall_read_ms + io_stall_write_ms AS 'IO Stalls'
	, num_of_reads + num_of_writes AS 'Total IO'
	, CAST((io_stall_read_ms + io_stall_write_ms) / (1.0 + num_of_reads + num_of_writes) AS NUMERIC(10, 1)) AS 'Avg IO Stall (ms)'
FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS fs
INNER JOIN sys.master_files AS mf
	ON fs.database_id = mf.database_id
		AND fs.[file_id] = mf.[file_id]
ORDER BY 13 DESC
OPTION (RECOMPILE);
