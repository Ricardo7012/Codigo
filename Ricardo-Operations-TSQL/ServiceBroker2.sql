USE master 
go
EXEC dbo.sp_IEHP_WhoIsActive
go


SELECT * FROM sys.dm_os_wait_stats ORDER BY wait_time_ms DESC
SELECT TOP 1000* FROM sys.dm_os_wait_stats ORDER BY max_wait_time_ms DESC

SELECT * FROM sys.dm_broker_activated_tasks
SELECT * FROM sys.dm_exec_requests ORDER BY cpu_time DESC

-- acquire sql_handle
SELECT sql_handle FROM sys.dm_exec_requests WHERE session_id = 107  -- modify this value with your actual spid

-- pass sql_handle to sys.dm_exec_sql_text
SELECT * FROM sys.dm_exec_sql_text(0x030008002B53231999540001A9A6000000000000000000000000000000000000000000000000000000000000) -- modify this value with your actual sql_handle

--DBCC SQLPERF ('sys.dm_os_wait_stats', CLEAR);  
--GO  

USE HSP_Prime
go
SELECT * FROM sys.dm_broker_activated_tasks 

SELECT * FROM sys.dm_broker_connections 

SELECT * FROM sys.dm_broker_forwarded_messages 

SELECT * FROM sys.dm_broker_queue_monitors 
