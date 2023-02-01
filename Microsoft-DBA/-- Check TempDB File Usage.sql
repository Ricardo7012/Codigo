-- Check TempDB File Usage

SELECT sys.dm_exec_sessions.session_id AS 'SID'
	, DB_NAME(database_id) AS 'DB Name'
	, HOST_NAME AS 'System Name'
	, program_name AS 'Program Name'
	, login_name AS 'User Name'
	, STATUS AS 'Status'
	, cpu_time AS 'CPU TIME (MS)'
	, total_scheduled_time AS 'Total Scheduled TIME (MS)'
	, total_elapsed_time AS 'Elapsed TIME (MS)'
	, (memory_usage * 8) AS 'Memory USAGE (KB)'
	, (user_objects_alloc_page_count * 8) AS 'SPACE Allocated FOR USER Objects (KB)'
	, (user_objects_dealloc_page_count * 8) AS 'SPACE Deallocated FOR USER Objects (KB)'
	, (internal_objects_alloc_page_count * 8) AS 'SPACE Allocated FOR Internal Objects (KB)'
	, (internal_objects_dealloc_page_count * 8) AS 'SPACE Deallocated FOR Internal Objects (KB)'
	, CASE is_user_process
		WHEN 1
			THEN 'user session'
		WHEN 0
			THEN 'system session'
		END AS [SESSION Type]
	, row_count AS [ROW COUNT]
FROM sys.dm_db_session_space_usage
INNER JOIN sys.dm_exec_sessions
	ON sys.dm_db_session_space_usage.session_id = sys.dm_exec_sessions.session_id
