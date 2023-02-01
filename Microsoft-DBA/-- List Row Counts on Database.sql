-- List Row Counts on Database

SELECT tbl.NAME AS 'TableName'
	, sch.NAME AS 'TableSchema'
	, prt.rows AS 'RowCount'
FROM sys.tables tbl
INNER JOIN sys.schemas sch
	ON tbl.schema_id = sch.schema_id
INNER JOIN sys.indexes idx
	ON tbl.OBJECT_ID = idx.object_id
INNER JOIN sys.partitions prt
	ON idx.object_id = prt.OBJECT_ID
		AND idx.index_id = prt.index_id
WHERE tbl.is_ms_shipped = 0
GROUP BY tbl.NAME
	, sch.NAME
	, prt.Rows
ORDER BY sch.NAME
	, tbl.NAME