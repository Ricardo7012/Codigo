--Exploring ring buffers to get historical data
SELECT @@SERVERNAME

DECLARE @ms_ticks_now BIGINT

SELECT @ms_ticks_now = ms_ticks
FROM sys.dm_os_sys_info;

SELECT record_id
	,dateadd(ms, - 1 * (@ms_ticks_now - [timestamp]), GetDate()) AS EventTime
	,SQLProcessUtilization
	,CASE WHEN (100 - SystemIdle - SQLProcessUtilization) < 0 THEN 0
		ELSE 100 - SystemIdle - SQLProcessUtilization
		END AS OtherProcessUtilization
	,CASE WHEN (SystemIdle + y.SQLProcessUtilization) > 100
			THEN y.SQLProcessUtilization
		ELSE 100 - y.SystemIdle
		END AS TotalCPU
	--,SystemIdle
FROM (
	SELECT record.value('(./Record/@id)[1]', 'int') AS record_id
		,record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int') AS SystemIdle
		,record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 'int') AS SQLProcessUtilization
		,TIMESTAMP
	FROM (
		SELECT TIMESTAMP
			,convert(XML, record) AS record
		FROM sys.dm_os_ring_buffers
		WHERE ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR'
			AND record LIKE '%<SystemHealth>%'
		) AS x
	) AS y
ORDER BY record_id DESC

