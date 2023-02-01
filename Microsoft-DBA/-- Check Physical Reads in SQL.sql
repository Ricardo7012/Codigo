-- Check Physical Reads in SQL

SELECT TOP (25) p.NAME AS 'SP Name'
	, qs.total_physical_reads AS 'Total Physical Reads'
	, qs.total_physical_reads / qs.execution_count AS 'Avg Physical Reads'
	, qs.execution_count AS 'Execution Count'
	, qs.total_logical_reads AS 'Total Logical Reads'
	, qs.total_elapsed_time AS 'Elapsed Time'
	, qs.total_elapsed_time / qs.execution_count AS 'Avg Elapsed Time'
	, qs.cached_time AS 'Cached Time'
FROM sys.procedures AS p
INNER JOIN sys.dm_exec_procedure_stats AS qs
	ON p.[object_id] = qs.object_id
WHERE qs.database_id = DB_ID()
ORDER BY qs.total_physical_reads
	, qs.total_logical_reads DESC;
	
SELECT TOP (100) p.NAME AS 'SP Name'
	, qs.total_logical_reads AS 'Total Logical Reads'
	, qs.total_logical_reads / qs.execution_count AS 'Avg Logical Reads'
	, qs.execution_count AS 'Execution Count'
	, ISNULL(qs.execution_count / DATEDIFF(Second, qs.cached_time, GETDATE()), 0) AS 'Calls / Second'
	, qs.total_elapsed_time AS 'Elapsed Time'
	, qs.total_elapsed_time / qs.execution_count AS 'Avg Elapsed Time'
	, qs.cached_time AS 'Cached Time'
FROM sys.procedures AS p
INNER JOIN sys.dm_exec_procedure_stats AS qs
	ON p.[object_id] = qs.[object_id]
WHERE qs.database_id = DB_ID()
ORDER BY qs.total_logical_reads DESC;

	
