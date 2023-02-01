-- List Sql Disk Space

SELECT DISTINCT volume_mount_point AS 'Disk Mount Point'
	, file_system_type AS 'File System Type'
	, logical_volume_name AS 'Logical Drive Name'
	, CONVERT(DECIMAL(18, 2), total_bytes / 1073741824.0) AS 'Total Size in (GB)'
	, CONVERT(DECIMAL(18, 2), available_bytes / 1073741824.0) AS 'Available Size in (GB)'
	, CAST(CAST(available_bytes AS FLOAT) / CAST(total_bytes AS FLOAT) AS DECIMAL(18, 2)) * 100 AS 'Space Free (%)'
FROM sys.master_files
CROSS APPLY sys.dm_os_volume_stats(database_id, file_id) 
