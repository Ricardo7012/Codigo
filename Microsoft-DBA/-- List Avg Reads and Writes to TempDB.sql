-- List Avg Reads and Writes to TempDB

SELECT f.physical_name AS 'Physical Name'
	, f.NAME AS 'Name'
	, s.num_of_writes AS '# Writes'
	, CAST((1.0 * s.io_stall_write_ms / s.num_of_writes) AS NUMERIC(36, 2)) AS 'Avg Write Stall (ms)'
	, s.num_of_reads AS '# Reads'
	, CAST((1.0 * s.io_stall_read_ms / s.num_of_reads) AS NUMERIC(36, 2)) AS 'Avg Read Stall (ms)'
FROM sys.dm_io_virtual_file_stats(2, NULL) AS s
INNER JOIN master.sys.master_files AS f
	ON s.database_id = f.database_id
		AND s.file_id = f.file_id
WHERE f.type_desc = 'ROWS'