-- https://social.msdn.microsoft.com/Forums/sqlserver/en-US/1fdb6d7e-0f1c-49f0-900d-005822515a80/alwayson-fails-every-hour?forum=sqldisasterrecovery
--1. Please check that if you are able to connect to the secondary replica 5022 port from primary replica via Telnet. And vice versa.
--2. Please run an nslookup form both servers and make sure the correct name and IP information was returned.
--3. Check  if there are any issues with networking and firewall rules.
--4. Check if there are any errors related to Windows cluster in the cluster log as AlwaysOn Availability Group is based on Windows Cluster.
--5. Sometimes the issue could be caused by that the system doesn't have enough workers to meet the demand of AlwaysOn Availability Group, which will require to change max_work_count value.
SELECT s.session_id,
       r.command,
       r.status,
       r.wait_type,
       r.scheduler_id,
       w.worker_address,
       w.is_preemptive,
       w.state,
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

-- https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/configure-the-max-worker-threads-server-configuration-option?view=sql-server-2017
USE HSP
GO
SELECT *
FROM sys.configurations
WHERE name = 'max worker threads'
ORDER BY name;
GO
EXEC sp_configure 'show advanced options', 1;  
GO  
RECONFIGURE ;  
GO  
EXEC sp_configure 'max worker threads', 960 ;  
GO  
RECONFIGURE;  
GO  
EXEC sp_configure 'show advanced options', 0;  
GO  
RECONFIGURE ;  
GO  
GO
SELECT *
FROM sys.configurations
WHERE name = 'max worker threads'
ORDER BY name;
