
SET STATISTICS TIME ON
SET STATISTICS IO ON;

SELECT scheduler_id, cpu_id, status, is_online FROM sys.dm_os_schedulers 
GO

--============================================================================================
-- CPU Workers
--============================================================================================
SELECT @@ServerName AS servername,
       cpu_count AS [Logical CPU Count],
       hyperthread_ratio AS Hyperthread_Ratio,
       cpu_count / hyperthread_ratio AS Physical_CPU_Count,
       physical_memory_kb / 1024 / 1024 AS Physical_Memory_GB,
                   socket_count,
                   cores_per_socket,
                   numa_node_count,
                   max_workers_count,
                   scheduler_count,
                   virtual_machine_type_desc
       --sqlserver_start_time,
       --affinity_type_desc -- (affinity_type_desc is only in 2008 R2)
FROM sys.dm_os_sys_info

SELECT SUM(x.workers)
FROM
(
SELECT s.cpu_id, w.scheduler_address, COUNT(*) AS workers
FROM sys.dm_os_workers w
    INNER JOIN sys.dm_os_schedulers s
        ON w.scheduler_address = s.scheduler_address
WHERE s.status = 'VISIBLE ONLINE'
--AND w.state = 'RUNNING'
GROUP BY s.cpu_id,
         w.scheduler_address
) X

SELECT s.cpu_id, w.scheduler_address, COUNT(*) AS workers
FROM sys.dm_os_workers w
    INNER JOIN sys.dm_os_schedulers s
        ON w.scheduler_address = s.scheduler_address
WHERE s.status = 'VISIBLE ONLINE'
--AND w.state = 'RUNNING'
GROUP BY s.cpu_id,
         w.scheduler_address
ORDER BY s.cpu_id,
         w.scheduler_address;

--============================================================================================



SELECT s.session_id,
       r.command,
       r.[status],
       r.wait_type,
       r.scheduler_id,
       w.worker_address,
       w.is_preemptive,
       w.[state],
       t.task_state,
       t.session_id,
       t.exec_context_id,
       t.request_id
FROM sys.dm_exec_sessions AS s
    INNER JOIN sys.dm_exec_requests AS r
        ON s.session_id = r.session_id
    INNER JOIN sys.dm_os_tasks AS t
        ON r.task_address = t.task_address
    INNER JOIN sys.dm_os_workers AS w
        ON t.worker_address = w.worker_address
WHERE s.is_user_process = 0;

SELECT s.session_id,
       r.command,
       r.[status],
       r.wait_type,
       r.scheduler_id,
       w.worker_address,
       w.is_preemptive,
       w.[state],
       t.task_state,
       t.session_id,
       t.exec_context_id,
       t.request_id
FROM sys.dm_exec_sessions AS s
    INNER JOIN sys.dm_exec_requests AS r
        ON s.session_id = r.session_id
    INNER JOIN sys.dm_os_tasks AS t
        ON r.task_address = t.task_address
    INNER JOIN sys.dm_os_workers AS w
        ON t.worker_address = w.worker_address
WHERE s.is_user_process = 1;


--SELECT * FROM sys.dm_os_schedulers
--SELECT * FROM sys.dm_os_workers

SELECT s.cpu_id, w.scheduler_address, COUNT(*) AS workers
FROM sys.dm_os_workers w
    INNER JOIN sys.dm_os_schedulers s
        ON w.scheduler_address = s.scheduler_address
WHERE s.status = 'VISIBLE ONLINE'
--AND w.state = 'RUNNING'
GROUP BY s.cpu_id,
         w.scheduler_address
ORDER BY s.cpu_id,
         w.scheduler_address;


SET STATISTICS TIME OFF
SET STATISTICS IO OFF;

--USE master
--GO
---- #1 
--SELECT name, user_access_desc, state_desc, log_reuse_wait_desc FROM sys.databases

----EXEC sp_WhoIsActive @get_plans=1
----GO 
--DECLARE @VersionDate DATETIME;
--EXEC dbo.sp_BlitzWho @Help = 0,                         -- tinyint
--                     @ShowSleepingSPIDs = 0,            -- tinyint
--                     @ExpertMode = 1,                -- bit
--                     @Debug = NULL,                     -- bit
--                     @VersionDate = @VersionDate OUTPUT -- datetime
--GO
--EXEC sp_BlitzFirst @ExpertMode = 1, @Seconds = 60 -- DEFAULT=5 SECONDS
--GO 
--EXEC sp_BlitzCache @SortOrder='CPU'
--GO 
--EXEC sp_BlitzIndex @DatabaseName ='member', @TableName='RecordDetails'
--GO 
--EXEC sp_Blitz
--GO 
--DBCC SQLPERF(LOGSPACE)
--GO 

----------------------------------------------------------------------------------------------------------------
-- CPU VISIABLE ONLINE CHECK
----------------------------------------------------------------------------------------------------------------
DECLARE @OnlineCpuCount int
DECLARE @LogicalCpuCount int

SELECT @OnlineCpuCount = COUNT(*) FROM sys.dm_os_schedulers WHERE status = 'VISIBLE ONLINE'
SELECT @LogicalCpuCount = cpu_count FROM sys.dm_os_sys_info 

SELECT @@ServerName AS SERVERNAME, @LogicalCpuCount AS 'ASSIGNED ONLINE CPU #', @OnlineCpuCount AS 'VISIBLE ONLINE CPU #',
   CASE 
     WHEN @OnlineCpuCount < @LogicalCpuCount 
     THEN 'You are not using all CPU assigned to O/S! If it is VM, review your VM configuration to make sure you are not maxout Socket'
     ELSE 'You are using all CPUs assigned to O/S. GOOD!' 
   END as 'CPU Usage Desc'
----------------------------------------------------------------------------------------------------------------
GO


SELECT @@ServerName AS servername,
       cpu_count AS [Logical CPU Count],
       hyperthread_ratio AS Hyperthread_Ratio,
       cpu_count / hyperthread_ratio AS Physical_CPU_Count,
       physical_memory_kb / 1024 / 1024 AS Physical_Memory_GB,
                   socket_count,
                   cores_per_socket,
                   numa_node_count,
                   max_workers_count,
                   scheduler_count,
                   virtual_machine_type_desc
       --sqlserver_start_time,
       --affinity_type_desc -- (affinity_type_desc is only in 2008 R2)
FROM sys.dm_os_sys_info
GO


SELECT
    mn.processor_group
    , mn.memory_node_id
    , n.node_id AS cpu_node_id
	,n.cpu_count
    , n.online_scheduler_count
    , n.cpu_affinity_mask
    , n.online_scheduler_mask
FROM sys.dm_os_memory_nodes AS mn
INNER JOIN sys.dm_os_nodes AS n
    ON mn.memory_node_id = n.memory_node_id;
GO

