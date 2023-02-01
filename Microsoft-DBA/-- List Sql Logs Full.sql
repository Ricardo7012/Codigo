-- List Sql Logs Full

SELECT instance_name AS [DBName]
	, cntr_value AS "LogFullPercentage"
FROM sys.dm_os_performance_counters
WHERE counter_name LIKE 'Percent Log Used%'
	AND instance_name NOT IN (
		'_Total'
		, 'mssqlsystemresource'
		)