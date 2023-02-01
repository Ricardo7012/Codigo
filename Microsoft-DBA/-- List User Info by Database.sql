-- List User Info by Database

DECLARE @DB_Name VARCHAR(35)
DECLARE @Command NVARCHAR(2000)

DECLARE database_cursor CURSOR
FOR
SELECT NAME
FROM MASTER.sys.sysdatabases
WHERE NAME NOT IN (
		'Master'
		, 'Model'
		, 'MSDB'
		, 'TempDB'
		, 'ReportServer'
		, 'ReportServerTempDB'
		)

OPEN database_cursor

FETCH NEXT
FROM database_cursor
INTO @DB_Name

WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @Command = 'USE ' + @DB_NAME + 
		' SELECT DB_Name() AS ''Database''
	, PVT.TABLENAME AS ''Table Name''
	, PVT.INDEXNAME AS ''Index Name''
	, [1] AS ''Col1''
	, [2] AS ''Col2''
	, [3] AS ''Col3''
	, [4] AS ''Col4''
	, [5] AS ''Col5''
	, [6] AS ''Col6''
	, [7] AS ''Col7''
	, [8] AS ''Col8''
	, [9] AS ''Col9''
	, [10] AS ''Col10''
	, '' - - - - - > '' AS ''User Info''
	, B.USER_SEEKS AS ''Seeks''
	, B.USER_SCANS AS ''Scans''
	, B.USER_LOOKUPS AS ''Lookups''
	, B.last_user_update AS ''Updates''
FROM (
	SELECT A.NAME AS TABLENAME
		, A.OBJECT_ID
		, B.NAME AS INDEXNAME
		, B.INDEX_ID
		, D.NAME AS COLUMNNAME
		, C.KEY_ORDINAL
	FROM SYS.OBJECTS A
	INNER JOIN SYS.INDEXES B
		ON A.OBJECT_ID = B.OBJECT_ID
	INNER JOIN SYS.INDEX_COLUMNS C
		ON B.OBJECT_ID = C.OBJECT_ID
			AND B.INDEX_ID = C.INDEX_ID
	INNER JOIN SYS.COLUMNS D
		ON C.OBJECT_ID = D.OBJECT_ID
			AND C.COLUMN_ID = D.COLUMN_ID
	WHERE A.TYPE <> ''S''
	) P
PIVOT(MIN(COLUMNNAME) FOR KEY_ORDINAL IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10])) AS PVT
INNER JOIN SYS.DM_DB_INDEX_USAGE_STATS B
	ON PVT.OBJECT_ID = B.OBJECT_ID
		AND PVT.INDEX_ID = B.INDEX_ID
		AND B.DATABASE_ID = DB_ID()
ORDER BY TABLENAME
	, INDEXNAME;'

	EXEC sp_executesql @Command

	FETCH NEXT
	FROM database_cursor
	INTO @DB_Name
END

CLOSE database_cursor

DEALLOCATE database_cursor
