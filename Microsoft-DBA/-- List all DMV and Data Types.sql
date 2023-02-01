-- List all DMV and Data Types

--Listing all the DMV/DMF using sys.all_objects catalog view
SELECT *
FROM sys.all_objects
WHERE NAME LIKE 'dm_%'
ORDER BY NAME

--Listing all the DMV/DMF using sys.system_objects catalog view
SELECT *
FROM sys.system_objects
WHERE NAME LIKE 'dm_%'
ORDER BY NAME

--Listing all the DMV/DMF along with its columns, their
--data types and size
SELECT so.NAME AS [DMV/DMF]
	, sc.NAME AS [Column]
	, t.NAME AS [Data Type]
	, sc.column_id [Column Ordinal]
	, sc.max_length
	, sc.PRECISION
	, sc.scale
FROM sys.system_objects so
INNER JOIN sys.system_columns sc
	ON so.OBJECT_ID = sc.OBJECT_ID
INNER JOIN sys.types t
	ON sc.user_type_id = t.user_type_id
WHERE so.NAME LIKE 'dm_%'
ORDER BY so.NAME
	, sc.column_id
