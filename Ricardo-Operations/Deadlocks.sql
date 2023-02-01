
-- https://docs.microsoft.com/en-us/previous-versions/sql/sql-server-2008-r2/ms178104(v=sql.105)
-- TRACE FLAGS 
-- https://docs.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-traceon-trace-flags-transact-sql?view=sql-server-2017
DBCC TRACESTATUS(-1);  
DBCC TRACESTATUS(1204,-1);  
DBCC TRACESTATUS(1222,-1);  
DBCC TRACESTATUS(1237,-1);  
GO 

-- https://blogs.msdn.microsoft.com/microsoft_dynamics_nav_sustained_engineering/2008/03/28/simple-query-to-check-the-recent-blocking-history/
USE HSP
go
SELECT DB_NAME(database_id) DB,
       OBJECT_NAME(object_id) Obj,
       row_lock_count, page_lock_count,
       row_lock_count + page_lock_count No_Of_Locks,
       row_lock_wait_count, page_lock_wait_count,
       row_lock_wait_count + page_lock_wait_count No_Of_Blocks,
       row_lock_wait_in_ms, page_lock_wait_in_ms,
       row_lock_wait_in_ms + page_lock_wait_in_ms Block_Wait_Time,
       index_id
FROM sys.dm_db_index_operational_stats(NULL, NULL, NULL, NULL)
--ORDER BY Block_Wait_Time DESC;
ORDER BY No_Of_Blocks DESC

--https://www.mssqltips.com/sqlservertip/2927/identify-the-cause-of-sql-server-blocking/
WITH [Blocking]
AS (SELECT w.[session_id]
   ,s.[original_login_name]
   ,s.[login_name]
   ,w.[wait_duration_ms]
   ,w.[wait_type]
   ,r.[status]
   ,r.[wait_resource]
   ,w.[resource_description]
   ,s.[program_name]
   ,w.[blocking_session_id]
   ,s.[host_name]
   ,r.[command]
   ,r.[percent_complete]
   ,r.[cpu_time]
   ,r.[total_elapsed_time]
   ,r.[reads]
   ,r.[writes]
   ,r.[logical_reads]
   ,r.[row_count]
   ,q.[text]
   ,q.[dbid]
   ,p.[query_plan]
   ,r.[plan_handle]
 FROM [sys].[dm_os_waiting_tasks] w
 INNER JOIN [sys].[dm_exec_sessions] s ON w.[session_id] = s.[session_id]
 INNER JOIN [sys].[dm_exec_requests] r ON s.[session_id] = r.[session_id]
 CROSS APPLY [sys].[dm_exec_sql_text](r.[plan_handle]) q
 CROSS APPLY [sys].[dm_exec_query_plan](r.[plan_handle]) p
 WHERE w.[session_id] > 50
  AND w.[wait_type] NOT IN ('DBMIRROR_DBM_EVENT'
      ,'ASYNC_NETWORK_IO'))
SELECT b.[session_id] AS [WaitingSessionID]
      ,b.[blocking_session_id] AS [BlockingSessionID]
      ,b.[login_name] AS [WaitingUserSessionLogin]
      ,s1.[login_name] AS [BlockingUserSessionLogin]
      ,b.[original_login_name] AS [WaitingUserConnectionLogin] 
      ,s1.[original_login_name] AS [BlockingSessionConnectionLogin]
      ,b.[wait_duration_ms] AS [WaitDuration]
      ,b.[wait_type] AS [WaitType]
      ,t.[request_mode] AS [WaitRequestMode]
      ,UPPER(b.[status]) AS [WaitingProcessStatus]
      ,UPPER(s1.[status]) AS [BlockingSessionStatus]
      ,b.[wait_resource] AS [WaitResource]
      ,t.[resource_type] AS [WaitResourceType]
      ,t.[resource_database_id] AS [WaitResourceDatabaseID]
      ,DB_NAME(t.[resource_database_id]) AS [WaitResourceDatabaseName]
      ,b.[resource_description] AS [WaitResourceDescription]
      ,b.[program_name] AS [WaitingSessionProgramName]
      ,s1.[program_name] AS [BlockingSessionProgramName]
      ,b.[host_name] AS [WaitingHost]
      ,s1.[host_name] AS [BlockingHost]
      ,b.[command] AS [WaitingCommandType]
      ,b.[text] AS [WaitingCommandText]
      ,b.[row_count] AS [WaitingCommandRowCount]
      ,b.[percent_complete] AS [WaitingCommandPercentComplete]
      ,b.[cpu_time] AS [WaitingCommandCPUTime]
      ,b.[total_elapsed_time] AS [WaitingCommandTotalElapsedTime]
      ,b.[reads] AS [WaitingCommandReads]
      ,b.[writes] AS [WaitingCommandWrites]
      ,b.[logical_reads] AS [WaitingCommandLogicalReads]
      ,b.[query_plan] AS [WaitingCommandQueryPlan]
      ,b.[plan_handle] AS [WaitingCommandPlanHandle]
FROM [Blocking] b
INNER JOIN [sys].[dm_exec_sessions] s1
ON b.[blocking_session_id] = s1.[session_id]
INNER JOIN [sys].[dm_tran_locks] t
ON t.[request_session_id] = b.[session_id]
WHERE t.[request_status] = 'WAIT'
GO

SELECT *
FROM sys.dm_exec_connections AS Blocking
    JOIN sys.dm_exec_requests AS Blocked
        ON Blocking.session_id = Blocked.blocking_session_id
    JOIN sys.dm_os_waiting_tasks AS Waits
        ON Blocked.session_id = Waits.session_id
    RIGHT OUTER JOIN sys.dm_exec_sessions Sess
        ON Blocking.session_id = Sess.session_id
    CROSS APPLY sys.dm_exec_sql_text(Blocking.most_recent_sql_handle) AS BlockingSQL
    CROSS APPLY sys.dm_exec_sql_text(Blocked.sql_handle) AS BlockedSQL;


	-- IDERA DEADLOCKS
SELECT [DeadlockID]
      ,[SQLServerID]
      ,[UTCCollectionDateTime]
      ,[XDLData]
  FROM [SQLdmRepository].[dbo].[Deadlocks]
  WHERE SQLServerID = 3 
  ORDER BY UTCCollectionDateTime DESC

  -- IDERA BLOCKS
SELECT [BlockID]
      ,[XActID]
      ,[SQLServerID]
      ,[UTCCollectionDateTime]
      ,[XDLData]
  FROM [SQLdmRepository].[dbo].[Blocks]
  WHERE SQLServerID = 3 
  ORDER BY UTCCollectionDateTime DESC

