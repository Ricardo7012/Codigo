-- List Signal Waits for SQL Instance

SELECT CAST(100.0 * SUM(signal_wait_time_ms) / SUM(wait_time_ms) AS NUMERIC(20, 2)) AS [% Signal (CPU) Waits]
	, CAST(100.0 * SUM(wait_time_ms - signal_wait_time_ms) / SUM(wait_time_ms) AS NUMERIC(20, 2)) AS [% Resource Waits]
FROM sys.dm_os_wait_stats
OPTION (RECOMPILE);
