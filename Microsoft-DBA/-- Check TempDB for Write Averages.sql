-- Check TempDB for Write Averages

SELECT files.physical_name
	, files.NAME
	, stats.num_of_writes
	, (1.0 * stats.io_stall_write_ms / stats.num_of_writes) AS avg_write_stall_ms
	, stats.num_of_reads
	, (1.0 * stats.io_stall_read_ms / stats.num_of_reads) AS avg_read_stall_ms
FROM sys.dm_io_virtual_file_stats(2, NULL) AS stats
INNER JOIN master.sys.master_files AS files
	ON stats.database_id = files.database_id
		AND stats.file_id = files.file_id
WHERE files.type_desc = 'ROWS'
