-- 2012-03-08 Pedro Lopes (Microsoft) pedro.lopes@microsoft.com (http://blogs.msdn.com/b/blogdoezequiel/)
--
-- Checks the cumulative IO per database file and related information
--
SELECT f.database_id, DB_NAME(f.database_id) AS database_name, f.name AS logical_file_name, f.[file_id], f.type_desc, 
	CAST (CASE 
		-- Handle UNC paths (e.g. '\\fileserver\readonlydbs\dept_dw.ndf')
		WHEN LEFT (LTRIM (f.physical_name), 2) = '\\' 
			THEN LEFT (LTRIM (f.physical_name),CHARINDEX('\',LTRIM(f.physical_name),CHARINDEX('\',LTRIM(f.physical_name), 3) + 1) - 1)
			-- Handle local paths (e.g. 'C:\Program Files\...\master.mdf') 
			WHEN CHARINDEX('\', LTRIM(f.physical_name), 3) > 0 
			THEN UPPER(LEFT(LTRIM(f.physical_name), CHARINDEX ('\', LTRIM(f.physical_name), 3) - 1))
		ELSE f.physical_name
	END AS NVARCHAR(255)) AS logical_disk,
	fs.size_on_disk_bytes/1024/1024 AS size_on_disk_Mbytes,
	fs.num_of_reads, fs.num_of_writes,
	fs.num_of_bytes_read/1024/1024 AS num_of_Mbytes_read,
	fs.num_of_bytes_written/1024/1024 AS num_of_Mbytes_written,
	fs.io_stall/1000/60 AS io_stall_min, 
	fs.io_stall_read_ms/1000/60 AS io_stall_read_min, 
	fs.io_stall_write_ms/1000/60 AS io_stall_write_min,
	((fs.io_stall_read_ms/1000/60)*100)/(CASE WHEN fs.io_stall/1000/60 = 0 THEN 1 ELSE fs.io_stall/1000/60 END) AS io_stall_read_pct, 
	((fs.io_stall_write_ms/1000/60)*100)/(CASE WHEN fs.io_stall/1000/60 = 0 THEN 1 ELSE fs.io_stall/1000/60 END) AS io_stall_write_pct,
	ABS((sample_ms/1000)/60/60) AS 'sample_HH', 
	((fs.io_stall/1000/60)*100)/(ABS((sample_ms/1000)/60))AS 'io_stall_pct_of_overall_sample'
FROM sys.dm_io_virtual_file_stats (default, default) AS fs
INNER JOIN sys.master_files AS f ON fs.database_id = f.database_id AND fs.[file_id] = f.[file_id]
ORDER BY 18 DESC
GO
