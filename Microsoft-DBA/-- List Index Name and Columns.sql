-- List Index Name and Columns

SELECT TABLENAME AS 'Table Name'
	, INDEXNAME AS 'Index Name'
	, INDEXID AS 'Index ID'
	, [1] AS 'Col1'
	, [2] AS 'Col2'
	, [3] AS 'Col3'
	, [4] AS 'Col4'
	, [5] AS 'Col5'
	, [6] AS 'Col6'
	, [7] AS 'Col7'
FROM (
	SELECT A.Name AS TableName
		, B.NAME AS IndexName
		, B.INDEX_ID AS IndexID
		, D.NAME AS ColumnName
		, C.KEY_ORDINAL AS Key_Ordinal
	FROM SYS.OBJECTS A
	INNER JOIN SYS.INDEXES B
		ON A.OBJECT_ID = B.OBJECT_ID
	INNER JOIN SYS.INDEX_COLUMNS C
		ON B.OBJECT_ID = C.OBJECT_ID
			AND B.INDEX_ID = C.INDEX_ID
	INNER JOIN SYS.COLUMNS D
		ON C.OBJECT_ID = D.OBJECT_ID
			AND C.COLUMN_ID = D.COLUMN_ID
	WHERE A.TYPE <> 'S'
	) P
PIVOT(MIN(COLUMNNAME) FOR KEY_ORDINAL IN ([1], [2], [3], [4], [5], [6], [7])) AS PVT
ORDER BY TABLENAME
	, INDEXNAME;