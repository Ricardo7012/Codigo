-- Check Reads & Writes to TempDB also Stalls

SELECT f.physical_name AS 'Physical Name'
	, f.NAME AS 'DB Name'
	, s.num_of_writes AS '# of Writes'
	, CONVERT(DECIMAL(5, 2), (1.0 * s.io_stall_write_ms / s.num_of_writes)) AS 'Avg Write Stall (ms)'
	, s.num_of_reads AS '# of Reads'
	, CONVERT(DECIMAL(5, 2), (1.0 * s.io_stall_read_ms / s.num_of_reads)) AS 'Avg Read Stall (ms)'
FROM sys.dm_io_virtual_file_stats(2, NULL) s
INNER JOIN master.sys.master_files f
	ON s.database_id = f.database_id
		AND s.file_id = f.file_id
WHERE f.type_desc = 'ROWS'
