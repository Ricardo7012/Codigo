-- List User info and Waits

SELECT HOST_NAME AS 'Sys Name'
	, program_name AS 'App Name'
	, DB_NAME(database_id) AS 'DB Name'
	, USER_NAME(USER_ID) AS 'User Name'
	, connection_id AS 'Conn ID'
	, sys.dm_exec_requests.session_id AS 'Current Session ID'
	, blocking_session_id AS 'Blocking Session ID'
	, start_time AS 'Req Start Time'
	, sys.dm_exec_requests.STATUS AS 'Status'
	, command AS 'Command Type'
	, (
		SELECT TEXT
		FROM sys.dm_exec_sql_text(sql_handle)
		) AS 'Query Txt'
	, wait_type AS 'Wait Type'
	, wait_time AS 'Wait Duration'
	, wait_resource AS 'Waiting For Resource'
	, sys.dm_exec_requests.transaction_id AS 'Trans ID'
	, percent_complete AS '% Completed'
	, estimated_completion_time AS 'Est Completion Time (ms)'
	, sys.dm_exec_requests.cpu_time AS 'CPU Time used (ms)'
	, (memory_usage * 8) AS 'Memory USAGE (KB)'
	, sys.dm_exec_requests.total_elapsed_time AS 'Elapsed TIME (ms)'
FROM sys.dm_exec_requests
INNER JOIN sys.dm_exec_sessions
	ON sys.dm_exec_requests.session_id = sys.dm_exec_sessions.session_id
WHERE DB_NAME(database_id) = 'tempdb'
