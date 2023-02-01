-- List Used Space per Index

SELECT t.NAME AS 'Table Name'
	, i.NAME AS 'IndexName'
	, SUM(p.rows) AS 'Row Counts'
	, SUM(a.total_pages) AS 'Total Pages'
	, SUM(a.used_pages) AS 'Used Pages'
	, SUM(a.data_pages) AS 'Data Pages'
	, (SUM(a.total_pages) * 8) / 1024 AS 'Total Space (MB)'
	, (SUM(a.used_pages) * 8) / 1024 AS 'Used Space (MB)'
	, (SUM(a.data_pages) * 8) / 1024 AS 'Data Space (MB)'
FROM sys.tables t
INNER JOIN sys.indexes i
	ON t.OBJECT_ID = i.object_id
INNER JOIN sys.partitions p
	ON i.object_id = p.OBJECT_ID
		AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a
	ON p.partition_id = a.container_id
WHERE t.NAME NOT LIKE 'dt%'
	AND i.OBJECT_ID > 255
	AND i.index_id <= 1
	AND i.name IS NOT NULL
GROUP BY t.NAME
	, i.object_id
	, i.index_id
	, i.NAME
ORDER BY OBJECT_NAME(i.object_id)