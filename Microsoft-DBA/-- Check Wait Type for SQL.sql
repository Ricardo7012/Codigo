-- Check Wait Type for SQL

SELECT TOP 10 wait_type AS 'Wait Type'
	, wait_time_ms AS 'Wait Time (MS)'
	, wait_time_ms / 1000 AS 'Wait Time (S)'
	, CONVERT(DECIMAL(12, 2), wait_time_ms * 100.0 / SUM(wait_time_ms) OVER ()) AS '% waiting'
FROM sys.dm_os_wait_stats
WHERE wait_type 
NOT LIKE '%SLEEP%'
ORDER BY wait_time_ms DESC;
