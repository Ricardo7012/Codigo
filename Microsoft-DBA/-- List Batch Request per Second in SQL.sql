-- List Batch Request per Second in SQL

SELECT t1.cntr_value AS 'Batch Requests (s)'
	, t2.cntr_value AS 'SQL Compilations (s)'
	, CONVERT(DECIMAL(15, 2), (t1.cntr_value * 1.0 - t2.cntr_value * 1.0) / t1.cntr_value * 100) AS 'Plan Reuse'
FROM master.sys.dm_os_performance_counters t1
	, master.sys.dm_os_performance_counters t2
WHERE t1.counter_name = 'Batch Requests/sec'
	AND t2.counter_name = 'SQL Compilations/sec'
