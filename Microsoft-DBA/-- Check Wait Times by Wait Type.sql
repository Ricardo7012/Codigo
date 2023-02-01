-- Check Wait Times by Wait Type

SELECT TOP 10 dmosws.wait_type AS 'Wait Type'
	, dmosws.waiting_tasks_count AS 'Waiting Tasks Count'
	, CAST (dmosws.wait_time_ms / 1000.0 AS numeric (18, 2)) AS 'Wait Time Sec'
	, CASE 
		WHEN dmosws.waiting_tasks_count = 0
			THEN NULL
		ELSE CAST((dmosws.wait_time_ms / 1000.0) / dmosws.waiting_tasks_count AS numeric (18, 2))
		END AS 'Avg Wait Time'
	, CAST(dmosws.max_wait_time_ms / 1000.0 AS numeric (18, 2)) AS 'Max Wait Time Sec'
	, CAST((dmosws.wait_time_ms - dmosws.signal_wait_time_ms) / 1000.0 AS numeric (18, 2)) AS 'Resource Wait Time Sec'
FROM sys.dm_os_wait_stats dmosws
WHERE dmosws.wait_type NOT IN (
		'CLR_SEMAPHORE'
		, 'LAZYWRITER_SLEEP'
		, 'RESOURCE_QUEUE'
		, 'SLEEP_TASK'
		, 'SLEEP_SYSTEMTASK'
		, 'WAITFOR'
		)
ORDER BY 'Waiting Tasks Count' DESC
