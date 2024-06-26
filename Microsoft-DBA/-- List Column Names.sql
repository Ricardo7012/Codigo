-- List Column Names

SELECT 'Table Name' = t.Name
	, 'Schema Name' = SCHEMA_NAME(schema_id)
	, 'Column Name' = c.Name
FROM sys.tables AS t
INNER JOIN sys.columns c
	ON t.OBJECT_ID = c.OBJECT_ID
WHERE c.NAME LIKE '%UserID%'
ORDER BY 2, 1
