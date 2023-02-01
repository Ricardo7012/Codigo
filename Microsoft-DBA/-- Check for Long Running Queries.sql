-- Check for Long Running Queries

SELECT HOST_NAME AS 'System Name'
	, program_name AS 'Application Name'
	, DB_NAME(database_id) AS 'DB Name'
	, USER_NAME(USER_ID) AS 'User Name'
	, connection_id AS 'Connection ID'
	, sys.dm_exec_requests.session_id AS 'Current Sess ID'
	, blocking_session_id AS 'Blocking Sess ID'
	, start_time AS 'Request Start Time'
	, sys.dm_exec_requests.STATUS AS 'Status'
	, command AS 'Command Type'
	, (
		SELECT TEXT
		FROM sys.dm_exec_sql_text(sql_handle)
		) AS 'Query Text'
	, wait_type AS 'Waiting Type'
	, wait_time AS 'Waiting Duration'
	, wait_resource AS 'Waiting For Resource'
	, sys.dm_exec_requests.transaction_id AS 'Trans ID'
	, percent_complete AS '% Complete'
	, estimated_completion_time AS 'Estimated Completion TIME (MS)'
	, sys.dm_exec_requests.cpu_time AS 'CPU Time Used (MS)'
	, (memory_usage * 8) AS 'Memory Usage (KB)'
	, sys.dm_exec_requests.total_elapsed_time AS 'Elapsed Time (MS)'
FROM sys.dm_exec_requests
INNER JOIN sys.dm_exec_sessions
	ON sys.dm_exec_requests.session_id = sys.dm_exec_sessions.session_id
WHERE DB_NAME(database_id) = 'tempdb'
