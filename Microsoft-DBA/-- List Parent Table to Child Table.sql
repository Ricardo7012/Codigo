-- List Parent Table to Child Table

SELECT tp.NAME AS 'Parent Table'
	, cp.NAME AS 'PTC Name'
	, cp.column_id AS 'Column ID'
	, tr.NAME AS 'Child Table'
	, cr.NAME AS 'CTC Name'
	, cr.column_id AS 'Column ID'
FROM sys.foreign_keys fk
INNER JOIN sys.tables tp
	ON fk.parent_object_id = tp.object_id
INNER JOIN sys.tables tr
	ON fk.referenced_object_id = tr.object_id
INNER JOIN sys.foreign_key_columns fkc
	ON fkc.constraint_object_id = fk.object_id
INNER JOIN sys.columns cp
	ON fkc.parent_column_id = cp.column_id
		AND fkc.parent_object_id = cp.object_id
INNER JOIN sys.columns cr
	ON fkc.referenced_column_id = cr.column_id
		AND fkc.referenced_object_id = cr.object_id
ORDER BY tp.NAME
	, cp.column_id