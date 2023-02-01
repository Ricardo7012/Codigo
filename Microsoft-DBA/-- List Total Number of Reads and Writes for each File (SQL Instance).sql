-- List Total Number of Reads and Writes for each File (SQL Instance)

SELECT d.NAME AS 'Database Name'
	, f.NAME AS 'Logical File Name'
	, f.physical_name AS 'File Path'
	, f.state_desc AS 'State Desc'
	, v.num_of_reads AS '# of Reads'
	, v.num_of_bytes_read AS '# of Bytes Read'
	, v.io_stall_read_ms AS 'IO Stall Read (ms)'
	, v.num_of_writes AS '# of Writes'
	, v.num_of_bytes_written AS '# of Bytes Written'
	, v.io_stall_write_ms AS 'IO Stall Write (ms)'
	, v.io_stall AS 'IO Stalls'
FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS v
INNER JOIN sys.master_files AS f
	ON v.database_id = f.database_id
		AND v.file_id = f.file_id
INNER JOIN sys.databases AS d
	ON d.database_id = v.database_id
