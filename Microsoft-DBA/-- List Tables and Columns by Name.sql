-- List Tables and Columns by Name

DECLARE @TableName varchar(50)
DECLARE @ColumnName varchar(50)

SET @TableName = 'absuser'
SET @ColumnName = 'userid'

SELECT TABLE_CATALOG AS 'Table Catalog'
	, TABLE_SCHEMA AS 'Table Schema'
	, TABLE_NAME AS 'Table Name'
	, TABLE_TYPE AS 'Table Type'
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE @TableName

SELECT TABLE_CATALOG AS 'Table Catalog'
	, TABLE_SCHEMA AS 'Table Schema'
	, TABLE_NAME AS 'Table Name'
	, COLUMN_NAME AS 'Column Name'
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME LIKE @ColumnName
