-- Get Row Counts

SELECT sc.NAME + '.' + ta.NAME TableName
	, SUM(pa.rows) RowCnt
FROM sys.tables ta
INNER JOIN sys.partitions pa
	ON pa.OBJECT_ID = ta.OBJECT_ID
INNER JOIN sys.schemas sc
	ON ta.schema_id = sc.schema_id
WHERE ta.is_ms_shipped = 0
	AND pa.index_id IN (1, 0)
GROUP BY sc.NAME
	, ta.NAME
--ORDER BY SUM(pa.rows) DESC