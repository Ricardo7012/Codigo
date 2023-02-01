-- List Wait Types in SQL

WITH Waits
AS (
	SELECT wait_type AS 'Wait_type'
		, wait_time_ms / 1000.0 AS 'Wait_time_seconds'
		, 100.0 * wait_time_ms / SUM(wait_time_ms) OVER () AS 'Percent_of_results'
		, ROW_NUMBER() OVER (
			ORDER BY wait_time_ms DESC
			) AS 'Row_number'
	FROM sys.dm_os_wait_stats WITH (NOLOCK)
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
			, 'ONDEMAND_TASK_QUEUE'
			, 'BROKER_EVENTHANDLER'
			, 'SLEEP_BPOOL_FLUSH'
			)
	)
SELECT W1.wait_type AS 'Wait Type'
	, CAST(W1.Wait_time_seconds AS DECIMAL(12, 2)) AS 'Wait Time (Sec)'
	, CAST(W1.Percent_of_results AS DECIMAL(12, 2)) AS '% Results'
	, CAST(SUM(W2.Percent_of_results) AS DECIMAL(12, 2)) AS '% Running'
FROM Waits AS W1
INNER JOIN Waits AS W2
	ON W2.[Row_number] <= W1.[Row_number]
GROUP BY W1.[Row_number]
	, W1.wait_type
	, W1.wait_time_seconds
	, W1.Percent_of_results
HAVING SUM(W2.percent_of_results) - W1.Percent_of_results < 99.9
