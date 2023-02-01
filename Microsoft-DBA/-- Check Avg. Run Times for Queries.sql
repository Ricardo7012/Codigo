-- Check Avg. Run Times for Queries

SELECT TOP 10 total_worker_time / execution_count AS 'Avg CPU Time'
	, execution_count AS 'Execution Count'
	, total_elapsed_time / execution_count AS 'AVG Run Time'
	, (
		SELECT SUBSTRING(TEXT, statement_start_offset / 2, (
					CASE 
						WHEN statement_end_offset = - 1
							THEN LEN(CONVERT(NVARCHAR(max), TEXT)) * 2
						ELSE statement_end_offset
						END - statement_start_offset
					) / 2)
		FROM sys.dm_exec_sql_text(sql_handle)
		) AS 'Query Text'
FROM sys.dm_exec_query_stats
--pick your criteria
ORDER BY 'Avg CPU Time' DESC
	--ORDER BY 'AVG Run Time' DESC
	--ORDER BY 'Execution Count' DESC
