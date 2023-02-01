-- Drop & Create FK Keys on Table

SELECT 'ALTER TABLE ' + s.NAME + '.' + OBJECT_NAME(fk.parent_object_id) + ' DROP CONSTRAINT ' + fk.NAME + ' ;' AS DropStatement
	, 'ALTER TABLE ' + s.NAME + '.' + OBJECT_NAME(fk.parent_object_id) + ' ADD CONSTRAINT ' + fk.NAME + ' FOREIGN KEY (' + COL_NAME(fk.parent_object_id, fkc.parent_column_id) + ') REFERENCES ' + ss.NAME + '.' + OBJECT_NAME(fk.referenced_object_id) + '(' + COL_NAME(fk.referenced_object_id, fkc.referenced_column_id) + ');' AS CreateStatement
FROM sys.foreign_keys fk
INNER JOIN sys.foreign_key_columns fkc
	ON fk.object_id = fkc.constraint_object_id
INNER JOIN sys.schemas s
	ON fk.schema_id = s.schema_id
INNER JOIN sys.tables t
	ON fkc.referenced_object_id = t.object_id
INNER JOIN sys.schemas ss
	ON t.schema_id = ss.schema_id
WHERE OBJECT_NAME(fk.referenced_object_id) = 'Player'
	AND ss.NAME = 'dbo';
