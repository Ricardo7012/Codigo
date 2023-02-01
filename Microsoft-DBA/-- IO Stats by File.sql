-- IO Stats by File

SELECT DB_NAME(FS.database_id) AS 'DB Name'
	, DB_NAME(D.source_database_id) AS 'Is Snapshot Of'
	, MF.NAME AS 'Logical Name'
	, MF.physical_name AS 'File Path Name'
	, MF.type_desc AS 'Filetype'
	, MF.state_desc AS 'FileState'
	, FS.num_of_reads AS 'Number Of Reads'
	, FS.io_stall_read_ms AS 'ReadStall (ms)'
	, FS.num_of_writes AS 'Number Of Writes'
	, FS.io_stall_write_ms AS 'WriteStall (ms)'
	, FS.io_stall AS 'Total Stall'
	, CASE 
		WHEN FS.num_of_reads = 0
			THEN 0
		ELSE FS.io_stall_read_ms / FS.num_of_reads
		END AS 'Avg Read Transfer (ms)'
	, CASE 
		WHEN FS.num_of_writes = 0
			THEN 0
		ELSE FS.io_stall_write_ms / FS.num_of_writes
		END AS 'Avg Write Transfer (ms)'
	, CASE 
		WHEN FS.num_of_reads + FS.num_of_writes = 0
			THEN 0
		ELSE FS.io_stall / (FS.num_of_reads + FS.num_of_writes)
		END AS 'Avg Stall (ms)'
	, CASE 
		WHEN FS.num_of_reads = 0
			THEN 0
		ELSE FS.num_of_bytes_read / FS.num_of_reads
		END AS 'Bytes Per Read'
	, CASE 
		WHEN FS.num_of_writes = 0
			THEN 0
		ELSE FS.num_of_bytes_written / FS.num_of_writes
		END AS 'Bytes Per Write'
FROM sys.dm_io_virtual_file_stats(NULL, NULL) FS
INNER JOIN sys.master_files MF
	ON MF.database_id = FS.database_id
		AND MF.file_id = FS.file_id
LEFT JOIN sys.databases D
	ON D.database_id = FS.database_id