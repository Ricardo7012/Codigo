-- List Space of Each Table

SELECT t.NAME AS 'Table Name'
	, s.NAME AS 'Schema Name'
	, p.rows AS 'Row Count'
	, SUM(a.total_pages) * 8 AS 'Total Space (kb)'
	, CAST(ROUND(((SUM(a.total_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS 'Total Space (mb)'
	, SUM(a.used_pages) * 8 AS 'Used Space (kb)'
	, CAST(ROUND(((SUM(a.used_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS 'Used Space (mb)'
	, (SUM(a.total_pages) - SUM(a.used_pages)) * 8 AS 'Unused Space (kb)'
	, CAST(ROUND(((SUM(a.total_pages) - SUM(a.used_pages)) * 8) / 1024.00, 2) AS NUMERIC(36, 2)) AS 'Unused Space (mb)'
FROM sys.tables t
INNER JOIN sys.indexes i
	ON t.OBJECT_ID = i.object_id
INNER JOIN sys.partitions p
	ON i.object_id = p.OBJECT_ID
		AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a
	ON p.partition_id = a.container_id
LEFT JOIN sys.schemas s
	ON t.schema_id = s.schema_id
WHERE t.NAME NOT LIKE 'dt%'
	AND t.is_ms_shipped = 0
	AND i.OBJECT_ID > 255
GROUP BY t.NAME
	, s.NAME
	, p.Rows
ORDER BY t.NAME
