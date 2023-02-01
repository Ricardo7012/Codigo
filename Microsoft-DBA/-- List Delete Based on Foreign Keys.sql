-- List Delete Based on Foreign Keys

SELECT 'DELETE ' + detail.NAME + ' WHERE ' + dcolumn.NAME + ' = @' + mcolumn.NAME AS stmt
	, 'DELETE ' + detail.NAME + ' FROM ' + detail.NAME + 
	' INNER JOIN DELETED ON ' + detail.NAME + '.' + dcolumn.NAME + ' = deleted.' + mcolumn.NAME AS trg
FROM sys.columns AS mcolumn
INNER JOIN sys.foreign_key_columns
	ON mcolumn.object_id = sys.foreign_key_columns.referenced_object_id
		AND mcolumn.column_id = sys.foreign_key_columns.referenced_column_id
INNER JOIN sys.tables AS master
	ON mcolumn.object_id = master.object_id
INNER JOIN sys.columns AS dcolumn
	ON sys.foreign_key_columns.parent_object_id = dcolumn.object_id
		AND sys.foreign_key_columns.parent_column_id = dcolumn.column_id
INNER JOIN sys.tables AS detail
	ON dcolumn.object_id = detail.object_id
WHERE (master.NAME = N'Period')
