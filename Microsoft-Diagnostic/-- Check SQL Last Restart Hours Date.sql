-- Check SQL Last Restart Hours & Date

SELECT CAST([ms_ticks] / 1000 / 60 / 60.0 AS DECIMAL(15, 2)) AS 'Hours Since Restart'
	, DATEADD(s, ((- 1) * ([ms_ticks] / 1000)), GETDATE()) AS 'Date of Last Restart'
FROM sys.[dm_os_sys_info]