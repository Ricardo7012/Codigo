-- Check Elapsed Time on Queries

SELECT qs.execution_count AS 'Execution Count'
	, qs.total_elapsed_time AS 'Total Elapsed Time'
	, qs.last_elapsed_time AS 'Last Elapsed Time'
	, qs.min_elapsed_time AS 'Min Elapsed Time'
	, qs.max_elapsed_time AS 'Max Elapsed Time'
	, substring(st.TEXT, (qs.statement_start_offset / 2) + 1, (
			(
				CASE qs.statement_end_offset
					WHEN - 1
						THEN datalength(st.TEXT)
					ELSE qs.statement_end_offset
					END - qs.statement_start_offset
				) / 2
			) + 1) AS 'Statement Text'
	, qp.query_plan AS 'Query Plan'
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) AS qp
ORDER BY 'Execution Count' DESC
