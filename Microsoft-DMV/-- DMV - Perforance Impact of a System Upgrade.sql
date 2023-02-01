SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT
	total_elapsed_time, total_worker_time, total_logical_reads
	, total_logical_writes, total_clr_time, execution_count
	, statement_start_offset, statement_end_offset, sql_handle, plan_handle
INTO #prework
FROM sys.dm_exec_query_stats

-- EXEC PutYourWorkloadHere

SELECT
	total_elapsed_time, total_worker_time, total_logical_reads
	, total_logical_writes, total_clr_time, execution_count
	, statement_start_offset, statement_end_offset, sql_handle, plan_handle
INTO #postwork
FROM sys.dm_exec_query_stats

SELECT
	SUM(p2.total_elapsed_time - ISNULL(p1.total_elapsed_time, 0)) AS [TotalDuration]
	, SUM(p2.total_worker_time - ISNULL(p1.total_worker_time, 0)) AS [Total Time on CPU]
	, SUM((p2.total_elapsed_time - ISNULL(p1.total_elapsed_time, 0)) -
				(p2.total_worker_time - ISNULL(p1.total_worker_time, 0))) AS [Total Time Waiting]
	, SUM(p2.total_logical_reads - ISNULL(p1.total_logical_reads, 0)) AS [TotalReads]
	, SUM(p2.total_logical_writes - ISNULL(p1.total_logical_writes, 0)) AS [TotalWrites]
	, SUM(p2.total_clr_time - ISNULL(p1.total_clr_time, 0)) AS [Total CLR time]
	, SUM(p2.execution_count - ISNULL(p1.execution_count, 0)) AS [Total Executions]
	, DB_NAME(qt.dbid) AS DatabaseName
FROM #prework p1
RIGHT OUTER JOIN
#postwork p2 ON p2.sql_handle = ISNULL(p1.sql_handle, p2.sql_handle)
	AND p2.plan_handle = ISNULL(p1.plan_handle, p2.plan_handle)
	AND p2.statement_start_offset =ISNULL(p1.statement_start_offset, p2.statement_start_offset)
	AND p2.statement_end_offset =ISNULL(p1.statement_end_offset, p2.statement_end_offset)
CROSS APPLY sys.dm_exec_sql_text(p2.sql_handle) as qt
WHERE p2.execution_count != ISNULL(p1.execution_count, 0)
GROUP BY DB_NAME(qt.dbid)

SELECT
	SUM(p2.total_elapsed_time - ISNULL(p1.total_elapsed_time, 0)) AS [TotalDuration]
	, SUM(p2.total_worker_time - ISNULL(p1.total_worker_time, 0)) AS [Total Time on CPU]
	, SUM((p2.total_elapsed_time - ISNULL(p1.total_elapsed_time, 0))
			- (p2.total_worker_time - ISNULL(p1.total_worker_time, 0))) AS [Total Time Waiting]
	, SUM(p2.total_logical_reads - ISNULL(p1.total_logical_reads, 0)) AS [TotalReads]
	, SUM(p2.total_logical_writes - ISNULL(p1.total_logical_writes, 0)) AS [TotalWrites]
	, SUM(p2.total_clr_time - ISNULL(p1.total_clr_time, 0)) AS [Total CLR time]
	, SUM(p2.execution_count - ISNULL(p1.execution_count, 0)) AS [Total Executions]
	, DB_NAME(qt.dbid) AS DatabaseName
	, qt.text AS [Parent Query]
FROM #prework p1
RIGHT OUTER JOIN
#postwork p2 ON p2.sql_handle = ISNULL(p1.sql_handle, p2.sql_handle)
	AND p2.plan_handle = ISNULL(p1.plan_handle, p2.plan_handle)
	AND p2.statement_start_offset =ISNULL(p1.statement_start_offset, p2.statement_start_offset)
	AND p2.statement_end_offset =ISNULL(p1.statement_end_offset, p2.statement_end_offset)
CROSS APPLY sys.dm_exec_sql_text(p2.sql_handle) as qt
WHERE p2.execution_count != ISNULL(p1.execution_count, 0)
GROUP BY DB_NAME(qt.dbid), qt.text
ORDER BY [TotalDuration] DESC

SELECT
	p2.total_elapsed_time - ISNULL(p1.total_elapsed_time, 0) AS [TotalDuration]
	, p2.total_worker_time - ISNULL(p1.total_worker_time, 0) AS [Total Time on CPU]
	, (p2.total_elapsed_time - ISNULL(p1.total_elapsed_time, 0))
		- (p2.total_worker_time - ISNULL(p1.total_worker_time, 0)) AS [Total Time Waiting]
	, p2.total_logical_reads - ISNULL(p1.total_logical_reads, 0) AS [TotalReads]
	, p2.total_logical_writes - ISNULL(p1.total_logical_writes, 0) AS [TotalWrites]
	, p2.total_clr_time - ISNULL(p1.total_clr_time, 0) AS [Total CLR time]
	, p2.execution_count - ISNULL(p1.execution_count, 0) AS [Total Executions]
	, SUBSTRING (qt.text,p2.statement_start_offset/2 + 1,
	((CASE WHEN p2.statement_end_offset = -1
		THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
		ELSE p2.statement_end_offset
	END - p2.statement_start_offset)/2) + 1) AS [Individual Query]
	, qt.text AS [Parent Query]
	, DB_NAME(qt.dbid) AS DatabaseName
FROM #prework p1
RIGHT OUTER JOIN
#postwork p2 ON p2.sql_handle = ISNULL(p1.sql_handle, p2.sql_handle)
	AND p2.plan_handle = ISNULL(p1.plan_handle, p2.plan_handle)
	AND p2.statement_start_offset = ISNULL(p1.statement_start_offset, p2.statement_start_offset)
	AND p2.statement_end_offset = ISNULL(p1.statement_end_offset, p2.statement_end_offset)
CROSS APPLY sys.dm_exec_sql_text(p2.sql_handle) as qt
WHERE p2.execution_count != ISNULL(p1.execution_count, 0)
ORDER BY [TotalDuration] DESC

DROP TABLE #prework
DROP TABLE #postwork