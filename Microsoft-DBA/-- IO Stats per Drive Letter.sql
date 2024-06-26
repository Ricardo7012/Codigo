-- IO Stats per Drive Letter

SELECT Left(MF.physical_name, 1) AS 'Drive Letter'
	, SUM(FS.num_of_reads) AS 'Number Of Reads'
	, SUM(FS.io_stall_read_ms) AS 'Read Stall (ms)'
	, SUM(FS.num_of_writes) AS 'Number Of Writes'
	, SUM(FS.io_stall_write_ms) AS 'WriteStall (ms)'
	, SUM(FS.io_stall) AS 'Total Stall'
	, CASE 
		WHEN SUM(FS.num_of_reads) = 0
			THEN 0
		ELSE SUM(FS.io_stall_read_ms) / SUM(FS.num_of_reads)
		END AS 'Avg Read Transfer (ms)'
	, CASE 
		WHEN SUM(FS.num_of_writes) = 0
			THEN 0
		ELSE SUM(FS.io_stall_write_ms) / SUM(FS.num_of_writes)
		END AS 'Avg Write Transfer (ms)'
	, CASE 
		WHEN SUM(FS.num_of_reads + FS.num_of_writes) = 0
			THEN 0
		ELSE SUM(FS.io_stall) / SUM(FS.num_of_reads + FS.num_of_writes)
		END AS 'Avg Stall (ms)'
	, CASE 
		WHEN SUM(FS.num_of_reads) = 0
			THEN 0
		ELSE SUM(FS.num_of_bytes_read) / SUM(FS.num_of_reads)
		END AS 'Bytes Per Read'
	, CASE 
		WHEN SUM(FS.num_of_writes) = 0
			THEN 0
		ELSE SUM(FS.num_of_bytes_written) / SUM(FS.num_of_writes)
		END AS 'Bytes Per Write'
FROM sys.dm_io_virtual_file_stats(NULL, NULL) FS
INNER JOIN sys.master_files MF
	ON MF.database_id = FS.database_id
		AND MF.file_id = FS.file_id
GROUP BY Left(MF.physical_name, 1)