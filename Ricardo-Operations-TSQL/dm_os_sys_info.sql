
--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT compatibility_level
FROM sys.databases
WHERE name = 'HSP';

SELECT @@servername as SERVERNAME, sqlserver_start_time FROM sys.dm_os_sys_info

-- https://en.wikipedia.org/wiki/Windows_NT
SELECT *
FROM sys.dm_os_windows_info;  

----
SELECT *, @@servername AS servername
FROM sys.dm_os_sys_info;

SELECT * 
FROM sys.configurations
WHERE [Name] = 'max degree of parallelism'
GO

SELECT @@ServerName AS servername,
       cpu_count AS [Logical CPU Count],
       hyperthread_ratio AS Hyperthread_Ratio,
       cpu_count / hyperthread_ratio AS Physical_CPU_Count,
       physical_memory_kb / 1024 / 1024 AS Physical_Memory_GB,
	   --physical_memory_in_bytes /(1024*1024*1024) AS Physical_Memory_GB,  -- 2008R2
	   --socket_count,
	   --cores_per_socket,
	   numa_node_count,
	   max_workers_count,
	   scheduler_count,
	   virtual_machine_type_desc
       --sqlserver_start_time,
       --affinity_type_desc -- (affinity_type_desc is only in 2008 R2)
FROM sys.dm_os_sys_info

----------------------------------------------------------------------------------------------------------------
-- CPU VISIABLE ONLINE CHECK
----------------------------------------------------------------------------------------------------------------
DECLARE @OnlineCpuCount int
DECLARE @LogicalCpuCount INT
DECLARE @numa INT

SELECT @OnlineCpuCount = COUNT(*) FROM sys.dm_os_schedulers WHERE status = 'VISIBLE ONLINE'
SELECT @LogicalCpuCount = cpu_count FROM sys.dm_os_sys_info 
SELECT @numa = numa_node_count FROM sys.dm_os_sys_info 

SELECT @@ServerName AS SERVERNAME
, @numa AS 'NUMA NODE COUNT'
, @LogicalCpuCount AS 'ASSIGNED ONLINE CPU #'
, @OnlineCpuCount AS 'VISIBLE ONLINE CPU #',
   CASE 
     WHEN @OnlineCpuCount < @LogicalCpuCount 
     THEN 'You are not using all CPU assigned to O/S! If it is VM, review your VM configuration to make sure you are not maxout Socket'
     ELSE 'You are using all CPUs assigned to O/S. GOOD!' 
   END as 'CPU Usage Desc'
,@@Version AS SYSTEMVERSION
----------------------------------------------------------------------------------------------------------------
GO

--SELECT @@Version AS SYSTEMVERSION
--GO

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
