-- List Indexes on Database

SELECT OBJECT_SCHEMA_NAME(ind.object_id) AS 'Schema Name'
	, OBJECT_NAME(ind.object_id) AS 'Object Name'
	, ind.NAME AS 'Index Name'
	, ind.is_primary_key AS 'Is Primary Key'
	, ind.is_unique AS 'Is Unique Index'
	, col.NAME AS 'Column Name'
	, ic.is_included_column AS 'Is Included Column'
	, ic.key_ordinal AS 'Column Order'
FROM sys.indexes ind
INNER JOIN sys.index_columns ic
	ON ind.object_id = ic.object_id
		AND ind.index_id = ic.index_id
INNER JOIN sys.columns col
	ON ic.object_id = col.object_id
		AND ic.column_id = col.column_id
INNER JOIN sys.tables t
	ON ind.object_id = t.object_id
WHERE t.is_ms_shipped = 0
ORDER BY OBJECT_SCHEMA_NAME(ind.object_id) --SchemaName
	, OBJECT_NAME(ind.object_id) --ObjectName
	, ind.is_primary_key DESC
	, ind.is_unique DESC
	, ind.NAME --IndexName
	, ic.key_ordinal
