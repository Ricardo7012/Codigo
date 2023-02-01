-- Check TempDB who is Consuming Space

SELECT es.host_name AS 'Host Name'
	, es.login_name AS 'Login name'
	, es.program_name AS 'Prog. Name'
	, st.dbid AS 'Query Exec. Context DBID'
	, DB_NAME(st.dbid) AS 'Query Exec. Context DBNAME'
	, st.objectid AS 'Module ObjectId'
	, SUBSTRING(st.TEXT, er.statement_start_offset / 2 + 1, (
			CASE 
				WHEN er.statement_end_offset = - 1
					THEN LEN(CONVERT(NVARCHAR(max), st.TEXT)) * 2
				ELSE er.statement_end_offset
				END - er.statement_start_offset
			) / 2) AS 'Query Text'
	, tsu.session_id AS 'Session ID'
	, tsu.request_id AS 'Request ID'
	, tsu.exec_context_id AS 'Exec. Context'
	, (tsu.user_objects_alloc_page_count - tsu.user_objects_dealloc_page_count) AS 'Out Standing User Objects Page Counts'
	, (tsu.internal_objects_alloc_page_count - tsu.internal_objects_dealloc_page_count) AS 'Out Standing Internal Objects Page Counts'
	, er.start_time AS 'Start Time'
	, er.command AS 'Cmd'
	, er.open_transaction_count AS 'Open Tran. Count'
	, er.percent_complete AS '% Complete'
	, er.estimated_completion_time AS 'Est. Completion Time'
	, er.cpu_time AS 'CPU Time'
	, er.total_elapsed_time AS 'Total Elapsed Time'
	, er.reads AS 'Reads'
	, er.writes AS 'Writes'
	, er.logical_reads AS 'Logical Reads'
	, er.granted_query_memory AS 'Granted Query Memory'
FROM sys.dm_db_task_space_usage tsu
INNER JOIN sys.dm_exec_requests er
	ON (
			tsu.session_id = er.session_id
			AND tsu.request_id = er.request_id
			)
INNER JOIN sys.dm_exec_sessions es
	ON (tsu.session_id = es.session_id)
CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) st
WHERE (tsu.internal_objects_alloc_page_count + tsu.user_objects_alloc_page_count) > 0
ORDER BY (tsu.user_objects_alloc_page_count - tsu.user_objects_dealloc_page_count) + (tsu.internal_objects_alloc_page_count - tsu.internal_objects_dealloc_page_count) DESC
