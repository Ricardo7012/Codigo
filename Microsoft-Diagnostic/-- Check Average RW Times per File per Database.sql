-- Check Average RW times per file per database
-- File ID 1 Data File
-- File ID 2 Log File

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT DB_NAME(database_id) AS 'DatabaseName'
	, 'File ID' = CASE file_id
		WHEN 1
			THEN 'Data'
		WHEN 2
			THEN 'Log'
		END
	, io_stall_read_ms / num_of_reads AS 'Average Read Time'
	, io_stall_write_ms / num_of_writes AS 'Average Write Time'
FROM sys.dm_io_virtual_file_stats(NULL, NULL)
WHERE num_of_reads > 0
	AND num_of_writes > 0
ORDER BY DatabaseName
