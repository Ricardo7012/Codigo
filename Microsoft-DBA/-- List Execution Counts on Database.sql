-- List Execution Counts on Database

DECLARE @total_worker_time BIGINT
DECLARE @total_physical_reads BIGINT
DECLARE @total_logical_reads BIGINT
DECLARE @total_logical_writes BIGINT
DECLARE @total_elapsed_time BIGINT

SET @total_worker_time = 100
SET @total_physical_reads = 1000
SET @total_logical_reads = 1000
SET @total_logical_writes = 1000
SET @total_elapsed_time = 1000

SELECT TOP 20 GETDATE() AS 'Collection Date'
	, qs.execution_count AS 'Execution Count'
	, SUBSTRING(qt.TEXT, qs.statement_start_offset / 2 + 1, (
			CASE 
				WHEN qs.statement_end_offset = - 1
					THEN LEN(CONVERT(NVARCHAR(MAX), qt.TEXT)) * 2
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
	OR qs.total_worker_time / qs.execution_count > @total_worker_time
	OR qs.total_physical_reads / qs.execution_count > @total_physical_reads
	OR qs.total_logical_reads / qs.execution_count > @total_logical_reads
	OR qs.total_logical_writes / qs.execution_count > @total_logical_writes
	OR qs.total_elapsed_time / qs.execution_count > @total_elapsed_time
ORDER BY qs.execution_count DESC
	, qs.total_elapsed_time / qs.execution_count DESC
	, qs.total_worker_time / qs.execution_count DESC
	, qs.total_physical_reads / qs.execution_count DESC
	, qs.total_logical_reads / qs.execution_count DESC
	, qs.total_logical_writes / qs.execution_count DESC
