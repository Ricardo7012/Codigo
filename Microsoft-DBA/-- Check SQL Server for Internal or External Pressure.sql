-- Check SQL Server for Internal or External Pressure

SELECT type AS 'Memory Type'
	, SUM(single_pages_kb) AS 'Internal Pressure'
	, SUM(multi_pages_kb) AS 'Extermal Pressure'
FROM sys.dm_os_memory_clerks
GROUP BY TYPE
ORDER BY SUM(single_pages_kb) DESC
	, SUM(multi_pages_kb) DESC
GO


