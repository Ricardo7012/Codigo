-- https://msdn.microsoft.com/en-us/library/ms174397.aspx 

DECLARE @command varchar(1000) 
SELECT @command = 'USE ? SELECT * FROM sys.database_files' 
EXEC sp_MSforeachdb @command 
GO

--File state:
-- 0 = ONLINE
-- 1 = RESTORING
-- 2 = RECOVERING
-- 3 = RECOVERY_PENDING
-- 4 = SUSPECT
-- 5 = Identified for informational purposes only. Not supported. Future compatibility is not guaranteed.
-- 6 = OFFLINE
-- 7 = DEFUNCT
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-master-files-transact-sql?view=sql-server-2017
SELECT
    D.name,
	F.state_desc AS OnlineStatus,
    F.Name AS FileType,
    F.physical_name AS PhysicalFile,
	F.max_size, -- -1 = File will grow until the disk is full.
	CAST((F.size*8)/1024/1024 AS VARCHAR(26)) + ' GB' AS FileSizeGB,
    CAST((F.size*8)/1024 AS VARCHAR(26)) + ' MB' AS FileSizeMB,
    CAST(F.size*8 AS VARCHAR(32)) + ' Bytes' as SizeInBytes
FROM 
    sys.master_files F
    INNER JOIN sys.databases D ON D.database_id = F.database_id
WHERE D.name LIKE 'HSP%'
ORDER BY
    D.name

--SPACE
SELECT DISTINCT
	@@ServerName AS SERVERNAME
      , (volume_mount_point)
	 , (total_bytes / 1099511627776) AS  Size_in_TB
	 , total_bytes / 1073741824  AS Size_in_GB
     , total_bytes / 1048576     AS Size_in_MB
     , available_bytes / 1048576 AS Free_in_MB
     , (
           SELECT ((available_bytes / 1048576 * 1.0) / (total_bytes / 1048576 * 1.0) * 100)
       )                         AS FreePercentage
FROM sys.master_files AS f
    CROSS APPLY sys.dm_os_volume_stats(f.database_id, f.file_id)
GROUP BY volume_mount_point
	   , total_bytes / 1099511627776
	   , total_bytes / 1073741824
       , total_bytes / 1048576
       , available_bytes / 1048576
ORDER BY 1;
