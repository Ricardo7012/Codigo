-- Select PLE from SQL Instance

SELECT @@SERVERNAME AS 'INSTANCE'
	, [object_name]
	, [counter_name]
	, CASE 
		WHEN [counter_name] = 'Page life expectancy'
			THEN (
					SELECT DATEDIFF(MI, MAX([login_time]), GETDATE())
					FROM sys.dm_exec_sessions DMES
					INNER JOIN sys.dm_exec_requests DMER
						ON [DMES].[session_id] = [DMER].[session_id]
					WHERE [command] = 'LAZY WRITER'
					)
		ELSE ''
		END AS 'UPTIME_MIN'
	, [cntr_value] AS 'PLE_SECS'
	, [cntr_value] / 60 AS 'PLE_MINS'
	, [cntr_value] / 3600 AS 'PLE_HOURS'
	, [cntr_value] / 86400 AS 'PLE_DAYS'
FROM sys.dm_os_performance_counters
WHERE [object_name] LIKE '%Manager%'
	AND [counter_name] = 'Page life expectancy';
