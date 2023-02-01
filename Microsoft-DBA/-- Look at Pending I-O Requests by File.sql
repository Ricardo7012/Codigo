-- Look at Pending I-O Requests by File

SELECT DB_NAME(mf.database_id) AS 'Database'
	, mf.physical_name AS 'Physical Name'
	, r.io_pending AS 'IO Pending'
	, r.io_pending_ms_ticks AS 'IO Pending MS ticks'
	, r.io_type AS 'IO Type'
	, fs.num_of_reads AS '# of Reads'
	, fs.num_of_writes AS '# of Writes'
FROM sys.dm_io_pending_io_requests AS r
INNER JOIN sys.dm_io_virtual_file_stats(NULL, NULL) AS fs
	ON r.io_handle = fs.file_handle
INNER JOIN sys.master_files AS mf
	ON fs.database_id = mf.database_id
		AND fs.file_id = mf.file_id
ORDER BY r.io_pending
	, r.io_pending_ms_ticks DESC;
