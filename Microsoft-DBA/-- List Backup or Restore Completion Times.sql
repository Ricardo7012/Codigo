-- List Backup or Restore Completion Times

SELECT 'Activity' = command
	, 'Start Time' = start_time
	, 'End Time' = dateadd(second, estimated_completion_time / 1000, getdate())	
	, 'Time Completion' = CAST((estimated_completion_time / 3600000) AS VARCHAR) + ' hour(s), ' + CAST((estimated_completion_time % 3600000) / 60000 AS VARCHAR) + ' min, ' + CAST((estimated_completion_time % 60000) / 1000 AS VARCHAR) + ' sec'
	, 'Time Running' = CAST(((DATEDIFF(s, start_time, GetDate())) / 3600) AS VARCHAR) + ' hour(s), ' + CAST((DATEDIFF(s, start_time, GetDate()) % 3600) / 60 AS VARCHAR) + 'min, ' + CAST((DATEDIFF(s, start_time, GetDate()) % 60) AS VARCHAR) + ' sec'
	, 'Completed (%)' = percent_complete	
FROM sys.dm_exec_requests r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) s
WHERE r.command IN (
		'RESTORE DATABASE'
		, 'BACKUP DATABASE'
		, 'RESTORE LOG'
		, 'BACKUP LOG'
		)
