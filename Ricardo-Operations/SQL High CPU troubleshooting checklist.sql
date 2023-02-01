/******************************************************************************
SUMMARY:	CPU FIRST RESPONDER 
CONTACT:	RICARDO FERNANDEZ

CHANGELOG:
DATE		USER		DESCRIPTION
2018-08-07	RICARDO		
******************************************************************************/
SELECT @@SERVERNAME
SELECT * from sys.dm_os_process_memory

-- SQL High CPU troubleshooting checklist
-- https://blogs.msdn.microsoft.com/docast/2017/07/30/sql-high-cpu-troubleshooting-checklist/

--10. Get the top 10 queries consuming High CPU using below query:
SELECT s.session_id,
       r.status,
       r.blocking_session_id 'Blk by',
       r.wait_type,
       wait_resource,
       r.wait_time / (1000 * 60) 'Wait M',
       r.cpu_time,
       r.logical_reads,
       r.reads,
       r.writes,
       r.total_elapsed_time / (1000 * 60) 'Elaps M',
       SUBSTRING(   st.text,
                    (r.statement_start_offset / 2) + 1,
                    ((CASE r.statement_end_offset
                          WHEN -1 THEN
                              DATALENGTH(st.text)
                          ELSE
                              r.statement_end_offset
                      END - r.statement_start_offset
                     ) / 2
                    ) + 1
                ) AS statement_text,
       COALESCE(
                   QUOTENAME(DB_NAME(st.dbid)) + N'.' + QUOTENAME(OBJECT_SCHEMA_NAME(st.objectid, st.dbid)) + N'.'
                   + QUOTENAME(OBJECT_NAME(st.objectid, st.dbid)),
                   ''
               ) AS command_text,
       r.command,
       s.login_name,
       s.host_name,
       s.program_name,
       s.last_request_end_time,
       s.login_time,
       r.open_transaction_count
FROM sys.dm_exec_sessions AS s
    JOIN sys.dm_exec_requests AS r
        ON r.session_id = s.session_id
    CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS st
WHERE r.session_id != @@SPID
ORDER BY r.cpu_time DESC;
--Collect the Plan handle and SQL handle information from below query:

SELECT session_id,
       sql_handle,
       plan_handle
FROM sys.dm_exec_requests
WHERE session_id = 123;

--Get the text of the query:

--replace the SQL Handle with the value obtained from above query.

SELECT *
FROM sys.dm_exec_sql_text(0x03000600BD297A4E420A830021A9000001000000000000000000000000000000000000000000000000000000);

--Get the estimated execution plan of the query:

--replace the Plan handle with the value obtained from above query.

SELECT *
FROM sys.dm_exec_query_plan(0x05000600BD297A4E40A01404CC00000001000000000000000000000000000000000000000000000000000000);

--21. Check if SQL System threads are consuming high CPU:
--Ghost cleanup thread >>>> Check if the user deleted large number of rows
--Lazy Writer thread >>>>>>> Check if any memory pressure on the server
--Resource Monitor thread >> Check if any memory pressure on the server
SELECT *
FROM sys.sysprocesses
WHERE cmd LIKE 'LAZY WRITER'
      OR cmd LIKE '%Ghost%'
      OR cmd LIKE 'RESOURCE MONITOR';

--22.  If the Top CPU consuming queries has the wait type: SQLTRACE_LOCK, check there are any traces running on the server using:

--Detecting recompilations using sys.dm_os_performance_counters
-- https://www.sqlshack.com/frequent-query-recompilations-sql-query-performance-killer-detection/
GO
SELECT *
  FROM sys.dm_os_performance_counters
  WHERE counter_name IN('Batch Requests/sec', 'SQL Compilations/sec', 'SQL Re-Compilations/sec')
GO
/********************************************************************************/
DECLARE @Batch BIGINT;
 
SELECT @Batch = cntr_value
FROM sys.dm_os_performance_counters
WHERE counter_name = 'Batch Requests/sec';
 
WAITFOR DELAY '00:00:10';
 
SELECT (cntr_value - @Batch) / 10 AS 'Batch Requests/sec'
FROM sys.dm_os_performance_counters
WHERE counter_name = 'Batch Requests/sec';
GO
/********************************************************************************/
DECLARE @Compilations BIGINT;
 
SELECT @Compilations = cntr_value
FROM sys.dm_os_performance_counters
WHERE counter_name = 'SQL Compilations/sec';
 
WAITFOR DELAY '00:00:10';
 
SELECT (cntr_value - @Compilations) / 10 AS 'SQL Compilations/sec'
FROM sys.dm_os_performance_counters
WHERE counter_name = 'SQL Compilations/sec';
GO

/********************************************************************************/
go
DECLARE @ReCompiles BIGINT;
 
SELECT @ReCompiles = cntr_value
FROM sys.dm_os_performance_counters
WHERE counter_name = 'SQL Re-Compilations/sec';
 
WAITFOR DELAY '00:00:10';
 
SELECT (cntr_value - @ReCompiles) / 10 AS 'SQL Re-Compilations/sec'
FROM sys.dm_os_performance_counters
WHERE counter_name = 'SQL Re-Compilations/sec';
GO
/********************************************************************************/

SELECT *
  FROM sys.dm_os_performance_counters
  WHERE counter_name IN('Batch Requests/sec', 'SQL Compilations/sec', 'SQL Re-Comp')
  go
SELECT *
FROM sys.traces;

--23. Collect the PSSDIAG during the Top CPU issue time. Refer KB 830232. Load and Analyze the data in SQL Nexus tool.
-- https://support.microsoft.com/en-us/help/830232/pssdiag-data-collection-utility
--24. Even after implementing above action plans, if the SQL CPU utilization is high, then increase the CPU on the server.

-- Warnings in Execution Plans
-- https://www.brentozar.com/blitzcache/query-plan-warnings/
SELECT  st.text,
        qp.query_plan
FROM    (
    SELECT  TOP 50 *
    FROM    sys.dm_exec_query_stats
    ORDER BY total_worker_time DESC
) AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) AS qp
WHERE qp.query_plan.value('declare namespace p="http://schemas.microsoft.com/sqlserver/2004/07/showplan";count(//p:Warnings)', 'int') > 0

SELECT *
FROM sys.dm_os_loaded_modules
WHERE company IS NULL
--WHERE company <> 'Microsoft Corporation'
--      OR company IS NULL;

--https://www.mssqltips.com/sqlservertip/4185/tracking-query-statistics-on-memory-grants-and-parallelism-in-sql-server-2016/
SELECT TOP( 10 )
	qs.execution_count AS [Execution Count]
,	t.[text] AS [Query Text]
,	qs.[last_grant_kb]
,	qs.[last_ideal_grant_kb]
,	qs.[last_used_grant_kb]
,	qs.[total_grant_kb]
,	qs.[last_dop]
,	qs.[last_used_threads]
FROM 
	sys.dm_exec_query_stats AS qs WITH (NOLOCK)
CROSS APPLY 
	sys.dm_exec_sql_text(plan_handle) AS t 
WHERE 
	DB_NAME(t.[dbid]) = 'HSP_Supplemental'
	AND qs.[total_grant_kb] > 0
ORDER BY 
	qs.[total_grant_kb] DESC 
OPTION (RECOMPILE);
