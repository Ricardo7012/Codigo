-- List Query Plan Reuse

SELECT t1.cntr_value AS 'Batch Requests (Sec)'
	, t2.cntr_value AS 'SQL Compilations (Sec)'
	, convert(DECIMAL(15, 2), (t1.cntr_value * 1.0 - t2.cntr_value * 1.0) / t1.cntr_value * 100) AS 'Plan Reuse'
FROM master.sys.dm_os_performance_counters t1
	, master.sys.dm_os_performance_counters t2
WHERE t1.counter_name = 'Batch Requests (Sec)'
	AND t2.counter_name = 'SQL Compilations (Sec)'