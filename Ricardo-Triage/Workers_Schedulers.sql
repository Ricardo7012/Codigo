/**************************************************************************************************
-- VISIBLE CPU CHECK
-- GET CPUs SOCKETS NUMA SCHEDULERS WORKERS
-- ALL WORKERS - CHECK IF CLOSE TO MAX_WORKERS_COUNT
-- WORKERS PER CPU
-- DM_OS_WAITING_TASKS
-- SYS.DM_OS_SCHEDULERS - UNCOMMENT IF NEEDED
-- SYS.DM_OS_WORKERS - UNCOMMENT IF NEEDED
****************************************************************************************************/
/**************************************************************************************************
-- VISIBLE CPU CHECK
****************************************************************************************************/
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
GO
/**************************************************************************************************
-- GET CPUs SOCKETS NUMA SCHEDULERS WORKERS
****************************************************************************************************/
SELECT @@ServerName                     AS servername
     , cpu_count                        AS [Logical CPU Count]
     , hyperthread_ratio                AS Hyperthread_Ratio
     , cpu_count / hyperthread_ratio    AS Physical_CPU_Count
     , physical_memory_kb / 1024 / 1024 AS Physical_Memory_GB
     , socket_count
     , cores_per_socket
     , numa_node_count
     , scheduler_count
     , max_workers_count
     , virtual_machine_type_desc
     , sqlserver_start_time
--affinity_type_desc -- (affinity_type_desc is only in 2008 R2)
FROM sys.dm_os_sys_info;
GO

/**************************************************************************************************
-- ALL WORKERS
****************************************************************************************************/
SELECT COUNT(*) AS WORKERS
FROM sys.dm_os_workers            
GO
/**************************************************************************************************
-- WORKERS PER CPU
****************************************************************************************************/
SELECT s.cpu_id
     , w.scheduler_address
     , COUNT(*) AS workers
FROM sys.dm_os_workers              w
    INNER JOIN sys.dm_os_schedulers s
        ON w.scheduler_address = s.scheduler_address
--WHERE s.status = 'VISIBLE ONLINE'
--AND w.state = 'RUNNING'
GROUP BY s.cpu_id
       , w.scheduler_address
ORDER BY s.cpu_id
       , w.scheduler_address
GO


/**************************************************************************************************
-- DM_OS_WAITING_TASKS
****************************************************************************************************/
SELECT * FROM sys.dm_os_waiting_tasks
GO

/**************************************************************************************************
-- SYS.DM_OS_SCHEDULERS;
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-os-schedulers-transact-sql?view=sql-server-ver15
--
****************************************************************************************************/
--SELECT [status]
--     , parent_node_id
--     , scheduler_id
--     , cpu_id
--     , is_online
--     , is_idle
--     , current_tasks_count
--     , current_workers_count
--     , active_workers_count
--     , total_cpu_usage_ms
--     , total_scheduler_delay_ms
--FROM sys.dm_os_schedulers;
--GO
--SELECT * FROM sys.dm_os_schedulers

       
/**************************************************************************************************
-- SYS.DM_OS_WORKERS;
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-os-workers-transact-sql?view=sql-server-ver15
-- THREAD – THIS IS THE OS THREAD SYS.DM_OS_THREADS THAT IS CREATED VIA CALLS LIKE CREATETHREAD() / _BEGINTHREADEX() . A WORKER IS MAPPED 1-TO-1 TO A THREAD.
****************************************************************************************************/
--SELECT * FROM sys.dm_os_workers
--GO
--SELECT s.cpu_id
--     , s.status
--     , DB_NAME(r.database_id) AS [databaseName]
--     , w.last_wait_type
--     , w.return_code
--     , t.task_state
--     , t.pending_io_count
--     , t.session_id
--     , r.sql_handle
--     , te.text
--FROM sys.dm_os_schedulers                          s
--    JOIN sys.dm_os_workers                         w
--        ON w.scheduler_address = s.scheduler_address
--    JOIN sys.dm_os_tasks                           t
--        ON t.task_address = w.task_address
--    JOIN sys.dm_exec_requests                      r
--        ON r.scheduler_id = s.scheduler_id
--    CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) te
--ORDER BY 1
--       , 3;
--GO



/**************************************************************************************************
-- https://docs.microsoft.com/en-us/sql/relational-databases/thread-and-task-architecture-guide?view=sql-server-ver15

--THE SCHEDULER IS THE PHYSICAL OR LOGICAL PROCESSOR THAT IS RESPONSIBLE FOR SCHEDULING THE EXECUTION OF THE SQL SERVER THREADS.
--THE WORKER IS THE THREAD THAT IS BOUND TO A SCHEDULER TO PERFORM A SPECIFIC TASK.
--THE DEGREE OF PARALLELISM IS THE NUMBER OF WORKERS, OR THE NUMBER OF PROCESSORS, THAT ARE ASSIGNED FOR THE PARALLEL PLAN TO ACCOMPLISH THE WORKER TASK.
--THE MAXIMUM DEGREE OF PARALLELISM (MAXDOP) IS A SERVER, DATABASE OR QUERY LEVEL OPTION THAT IS USED TO LIMIT THE NUMBER OF PROCESSORS THAT THE PARALLEL PLAN CAN USE. THE DEFAULT VALUE OF MAXDOP IS 0, IN WHICH THE SQL SERVER ENGINE CAN USE ALL AVAILABLE PROCESSORS, UP TO 64, IN THE QUERY PARALLEL EXECUTION. SETTING THE MAXDOP OPTION TO 1 WILL PREVENT USING MORE THAN ONE PROCESSOR IN EXECUTING THE QUERY, WHICH MEANS THAT THE SQL SERVER ENGINE WILL USE A SERIAL PLAN TO EXECUTE THE QUERY. THE MAXDOP OPTION CAN TAKE VALUE UP TO 32767, WHERE THE SQL SERVER ENGINE WILL USE ALL AVAILABLE SERVER PROCESSORS IN THE PARALLEL PLAN EXECUTION IF THE MAXDOP VALUE EXCEEDS THE NUMBER OF PROCESSORS AVAILABLE IN THE SERVER. IF THE SQL SERVER IS INSTALLED ON A SINGLE PROCESSOR SERVER, THE VALUE OF MAXDOP WILL BE IGNORED.
--THE TASK IS A SMALL PIECE OF WORK THAT IS ASSIGNED TO A SPECIFIC WORKER.
--THE EXECUTION CONTEXT IS THE BOUNDARY IN WHICH EACH SINGLE TASK RUN INSIDE.
--THE PARALLEL PAGE SUPPLIER IS A PART OF THE SQL SERVER STORAGE ENGINE THAT DISTRIBUTES THE DATA SETS REQUESTED BY THE QUERY WITHIN THE PARTICIPATED WORKERS.
--THE EXCHANGE IS THE COMPONENT THAT WILL CONNECT THE DIFFERENT EXECUTION CONTEXTS INVOLVED IN THE QUERY PARALLEL PLAN TOGETHER, TO GET THE FINAL RESULT.
--THE DECISION OF USING A PARALLEL PLAN TO EXECUTE THE QUERY OR NOT DEPENDS ON MULTIPLE FACTORS. FOR EXAMPLE, SQL SERVER SHOULD BE INSTALLED ON A MULTI-PROCESSOR SERVER, THE REQUESTED NUMBER OF THREADS SHOULD BE AVAILABLE TO BE SATISFIED, THE MAXIMUM DEGREE OF PARALLELISM OPTION IS NOT SET TO 1 AND THE COST OF THE QUERY EXCEEDS THE PREVIOUSLY CONFIGURED COST THRESHOLD FOR PARALLELISM VALUE.
****************************************************************************************************/
