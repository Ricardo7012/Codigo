SELECT DISTINCT
        DB_NAME(dovs.database_id) DBName
       ,mf.physical_name PhysicalFileLocation
       ,dovs.logical_volume_name AS LogicalName
       ,dovs.volume_mount_point AS Drive
       ,CONVERT(INT, dovs.available_bytes / 1048576.0) AS FreeSpaceInMB
	   ,CONVERT(INT, CONVERT(INT, dovs.available_bytes / 1048576.0) / 1024) AS FreeSpaceInGB
FROM    sys.master_files mf
        CROSS APPLY sys.dm_os_volume_stats(mf.database_id, mf.file_id) dovs
ORDER BY FreeSpaceInMB ASC;
GO
