-- List Sql Buffer Cache Efficiency Low

SELECT object_name
	, counter_name
	, cntr_value
FROM sys.dm_os_performance_counters
WHERE object_name LIKE '%Buffer Manager%'
	AND counter_name = 'Buffer cache hit ratio'