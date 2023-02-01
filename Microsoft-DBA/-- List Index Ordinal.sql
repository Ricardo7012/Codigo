-- List Index Ordinal

SELECT obj.NAME AS 'Table Name'
	, idx.NAME AS 'Index Name'
	, idxcols.key_ordinal AS 'Key Ordinal'
	, cols.NAME AS 'Column Name'
FROM sys.objects obj
INNER JOIN sys.indexes idx
	ON obj.object_id = idx.object_id
INNER JOIN sys.index_columns idxcols
	ON idx.object_id = idxcols.object_id
		AND idx.index_id = idxcols.index_id
INNER JOIN sys.columns cols
	ON idxcols.object_id = cols.object_id
		AND idxcols.column_id = cols.column_id
WHERE obj.TYPE <> 'S'
ORDER BY 'Table Name'
	, 'Index Name'
	, 'Key Ordinal'