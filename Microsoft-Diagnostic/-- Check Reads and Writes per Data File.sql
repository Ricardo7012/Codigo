-- Check Reads and Writes per Data File

SELECT DB_NAME(mf.database_id) AS 'Database Name'
	, Mf.Type_desc AS 'File Type'
	, LEFT(Mf.Physical_name, 1) AS 'Drive Letter'
	, Mf.Physical_name AS 'Physical Name'
	, num_of_reads AS 'Reads'
	, num_of_writes AS 'Writes'
	, num_of_bytes_read AS 'Bytes Read'
	, num_of_bytes_written AS 'Bytes Written'
FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS fs
INNER JOIN sys.master_files AS mf
	ON mf.database_id = fs.database_id
		AND mf.FILE_ID = fs.FILE_ID
ORDER BY 'Database Name'
	, 'File Type'