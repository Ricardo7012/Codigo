-- List DB Performance Levels by Files

SELECT DB_NAME(database_id) AS 'DB Name'
	, CASE 
		WHEN file_id = 2
			THEN 'Log'
		ELSE 'Data'
		END AS 'File Type'
	, CAST((size_on_disk_bytes / 1024) / 1024.0 AS decimal(12, 2)) AS 'Size On Disk (MB)'
	, io_stall_read_ms / num_of_reads AS 'Avg Read Transfer (MS)'
	, CASE 
		WHEN file_id = 2
			THEN CASE 
					WHEN io_stall_read_ms / num_of_reads < 5
						THEN 'Good'
					WHEN io_stall_read_ms / num_of_reads < 15
						THEN 'Acceptable'
					ELSE 'Unacceptable'
					END
		ELSE CASE 
				WHEN io_stall_read_ms / num_of_reads < 10
					THEN 'Good'
				WHEN io_stall_read_ms / num_of_reads < 20
					THEN 'Acceptable'
				ELSE 'Unacceptable'
				END
		END AS 'Avg Read Performance'
	, io_stall_write_ms / num_of_writes AS 'Avg Write Transfer (MS)'
	, CASE 
		WHEN file_id = 2
			THEN CASE 
					WHEN io_stall_write_ms / num_of_writes < 5
						THEN 'Good'
					WHEN io_stall_write_ms / num_of_writes < 15
						THEN 'Acceptable'
					ELSE 'Unacceptable'
					END
		ELSE CASE 
				WHEN io_stall_write_ms / num_of_writes < 10
					THEN 'Good'
				WHEN io_stall_write_ms / num_of_writes < 20
					THEN 'Acceptable'
				ELSE 'Unacceptable'
				END
		END AS 'Avg Write Performance'
FROM sys.dm_io_virtual_file_stats(NULL, NULL)
WHERE num_of_reads > 0
	AND num_of_writes > 0
ORDER BY 'DB Name'
