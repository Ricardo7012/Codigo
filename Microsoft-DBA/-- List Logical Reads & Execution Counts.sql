-- List Logical Reads & Execution Counts

SELECT TOP 10 SUM(total_logical_reads) AS 'Total Logical Reads'
	, COUNT(*) AS 'Num Queries'
	, --number of individual queries in batch
	--not all usages need be equivalent, in the case of looping
	--or branching code
	MAX(execution_count) AS 'Execution Count'
	, MAX(execText.TEXT) AS 'Query Text'
FROM sys.dm_exec_query_stats deqs
CROSS APPLY sys.dm_exec_sql_text(deqs.sql_handle) AS execText
GROUP BY deqs.sql_handle
HAVING AVG(total_logical_reads / execution_count) <> SUM(total_logical_reads) / SUM(execution_count)
ORDER BY 1 DESC
