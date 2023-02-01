-- Check for Worst Performing Query

USE master;
GO

SELECT TOP 20 GETDATE() AS 'Collection Date'
	, qs.execution_count AS 'Execution Count'
	, SUBSTRING(qt.TEXT, qs.statement_start_offset / 2 + 1, (
			CASE 
				WHEN qs.statement_end_offset = - 1
					THEN LEN(CONVERT(NVARCHAR(max), qt.TEXT)) * 2
				ELSE qs.statement_end_offset
				END - qs.statement_start_offset
			) / 2) AS 'Query Text'
	, DB_NAME(qt.dbid) AS 'DB Name'
	, qs.total_worker_time AS 'Total CPU Time'
	, qs.total_worker_time / qs.execution_count AS 'Avg CPU Time (ms)'
	, qs.total_physical_reads AS 'Total Physical Reads'
	, qs.total_physical_reads / qs.execution_count AS 'Avg Physical Reads'
	, qs.total_logical_reads AS 'Total Logical Reads'
	, qs.total_logical_reads / qs.execution_count AS 'Avg Logical Reads'
	, qs.total_logical_writes AS 'Total Logical Writes'
	, qs.total_logical_writes / qs.execution_count AS 'Avg Logical Writes'
	, qs.total_elapsed_time AS 'Total Duration'
	, qs.total_elapsed_time / qs.execution_count AS 'Avg Duration (ms)'
	, qp.query_plan AS 'Plan'
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) AS qp
WHERE qs.execution_count > 50
	OR qs.total_worker_time / qs.execution_count > 100
	OR qs.total_physical_reads / qs.execution_count > 1000
	OR qs.total_logical_reads / qs.execution_count > 1000
	OR qs.total_logical_writes / qs.execution_count > 1000
	OR qs.total_elapsed_time / qs.execution_count > 1000
ORDER BY qs.execution_count DESC
	, qs.total_elapsed_time / qs.execution_count DESC
	, qs.total_worker_time / qs.execution_count DESC
	, qs.total_physical_reads / qs.execution_count DESC
	, qs.total_logical_reads / qs.execution_count DESC
	, qs.total_logical_writes / qs.execution_count DESC




	-- DMV - Slowest Query Not DB SPECIFIC

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT TOP 20
CAST(qs.total_elapsed_time / 1000000.0 AS DECIMAL(28, 2))
								AS [Total Elapsed Duration (s)]
, qs.execution_count
, SUBSTRING (qt.text,(qs.statement_start_offset/2) + 1,
((CASE WHEN qs.statement_end_offset = -1
	THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
	ELSE
		qs.statement_end_offset
	END - qs.statement_start_offset)/2) + 1) AS [Individual Query]
, qt.text AS [Parent Query]
, DB_NAME(qt.dbid) AS DatabaseName
, qp.query_plan
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
INNER JOIN sys.dm_exec_cached_plans cp
	ON qs.plan_handle=cp.plan_handle
ORDER BY total_elapsed_time DESC


