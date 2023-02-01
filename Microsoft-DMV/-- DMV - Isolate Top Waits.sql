-- Isolate top waits for server instance since last restart or statistics clear

WITH Waits
AS (
	SELECT wait_type AS [Wait Type]
		, wait_time_ms / 1000. AS [Wait Time S]
		, 100. * wait_time_ms / SUM(wait_time_ms) OVER () AS pct
		, ROW_NUMBER() OVER (
			ORDER BY wait_time_ms DESC
			) AS rn
	FROM sys.dm_os_wait_stats
	WHERE wait_type NOT IN (
			'CLR_SEMAPHORE'
			, 'LAZYWRITER_SLEEP'
			, 'RESOURCE_QUEUE'
			, 'SLEEP_TASK'
			, 'SLEEP_SYSTEMTASK'
			, 'SQLTRACE_BUFFER_FLUSH'
			, 'WAITFOR'
			, 'LOGMGR_QUEUE'
			, 'CHECKPOINT_QUEUE'
			, 'REQUEST_FOR_DEADLOCK_SEARCH'
			, 'XE_TIMER_EVENT'
			, 'BROKER_TO_FLUSH'
			, 'BROKER_TASK_STOP'
			, 'CLR_MANUAL_EVENT'
			, 'CLR_AUTO_EVENT'
			, 'DISPATCHER_QUEUE_SEMAPHORE'
			, 'FT_IFTS_SCHEDULER_IDLE_WAIT'
			, 'XE_DISPATCHER_WAIT'
			, 'XE_DISPATCHER_JOIN'
			, 'SQLTRACE_INCREMENTAL_FLUSH_SLEEP'
			)
	)
SELECT W1.[Wait Type]
	, CAST(W1.[Wait Time S] AS DECIMAL(12, 2)) AS [Wait Time S]
	, CAST(W1.pct AS DECIMAL(12, 2)) AS [%]
	, CAST(SUM(W2.pct) AS DECIMAL(12, 2)) AS [Running PCT %]
FROM Waits AS W1
INNER JOIN Waits AS W2
	ON W2.rn <= W1.rn
GROUP BY W1.rn
	, W1.[Wait Type]
	, W1.[Wait Time S]
	, W1.pct
HAVING SUM(W2.pct) - W1.pct < 99
OPTION (RECOMPILE);-- percentage threshold
GO


