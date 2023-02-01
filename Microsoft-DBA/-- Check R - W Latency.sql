-- Check R - W Latency

DECLARE @Reset BIT = 0;

IF NOT EXISTS (
		SELECT NULL
		FROM tempdb.sys.objects
		WHERE NAME LIKE '%#fileStats%'
		)
	SET @Reset = 1;-- force a reset

IF @Reset = 1
BEGIN
	IF EXISTS (
			SELECT NULL
			FROM tempdb.sys.objects
			WHERE NAME LIKE '%#fileStats%'
			)
		DROP TABLE #fileStats;

	SELECT database_id
		, file_id
		, num_of_reads
		, num_of_bytes_read
		, io_stall_read_ms
		, num_of_writes
		, num_of_bytes_written
		, io_stall_write_ms
		, io_stall
	INTO #fileStats
	FROM sys.dm_io_virtual_file_stats(NULL, NULL);
END

SELECT DB_NAME(vfs.database_id) AS 'Database Name'
	, vfs.FILE_ID AS 'File ID'
	, (vfs.io_stall_read_ms - history.io_stall_read_ms) / NULLIF((vfs.num_of_reads - history.num_of_reads), 0) AS 'Avg Read Latency'
	, (vfs.io_stall_write_ms - history.io_stall_write_ms) / NULLIF((vfs.num_of_writes - history.num_of_writes), 0) AS 'Avg Write Latency'
	, mf.physical_name
FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS vfs
INNER JOIN sys.master_files AS mf
	ON vfs.database_id = mf.database_id
		AND vfs.FILE_ID = mf.FILE_ID
RIGHT JOIN #fileStats history
	ON history.database_id = vfs.database_id
		AND history.file_id = vfs.file_id
ORDER BY 'Avg Write Latency' DESC;
