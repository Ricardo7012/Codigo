-- Check SQL Last Restart

SELECT [ms_ticks] AS ms_since_restart
	, [ms_ticks] / 1000 AS seconds_since_restart
	, CAST([ms_ticks] / 1000 / 60.0 AS DECIMAL(15, 2)) AS minutes_since_restart
	, CAST([ms_ticks] / 1000 / 60 / 60.0 AS DECIMAL(15, 2)) AS hours_since_restart
	, CAST([ms_ticks] / 1000 / 60 / 60 / 24.0 AS DECIMAL(15, 2)) AS days_since_restart
	, DATEADD(s, ((- 1) * ([ms_ticks] / 1000)), GETDATE()) AS time_of_last_restart
FROM sys.[dm_os_sys_info]