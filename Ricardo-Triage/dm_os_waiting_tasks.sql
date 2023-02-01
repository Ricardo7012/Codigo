-- cores and hyperthreading
SELECT cpu_count
     , hyperthread_ratio
FROM sys.dm_os_sys_info;
GO
-- numa nodes and schedulers
SELECT node_id
     , online_scheduler_count
FROM sys.dm_os_nodes
ORDER BY node_id;
GO

-- see if anything is waiting on tempdb
SELECT *
FROM sys.dm_os_waiting_tasks
WHERE resource_description LIKE '2:%';
GO

-- see everything that is waiting 
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-os-wait-stats-transact-sql?view=sql-server-ver15
-- https://www.sqlskills.com/
SELECT *
FROM sys.dm_os_waiting_tasks
WHERE wait_type NOT IN ( 'CXCONSUMER', 'CXPACKET' )
      AND session_id IS NOT NULL
ORDER BY wait_duration_ms DESC;
GO
