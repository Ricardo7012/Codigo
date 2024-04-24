-- Check Statistics on Tables
Use AdventureWorks2019
go
SELECT STATS_DATE(i.object_id, i.index_id) AS 'Last Statistics Date'
	, o.NAME AS 'Table Name'
	, i.NAME AS 'Index Name'
FROM sys.objects o
INNER JOIN sys.indexes i
	ON o.object_id = i.object_id
WHERE o.is_ms_shipped = 0
ORDER BY 'Table Name'
