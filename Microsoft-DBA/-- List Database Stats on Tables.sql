-- List Database Stats on Tables

SELECT TableName = OBJECT_NAME(i.OBJECT_ID)
	, ObjectType = o.type_desc
	, StatisticsName = i.[name]
	, statisticsUpdateDate = STATS_DATE(i.OBJECT_ID, i.index_id)
	, RecordModified = si.rowmodctr
	, NumberofRecords = si.rowcnt
FROM sys.indexes i
INNER JOIN sys.objects o
	ON i.OBJECT_ID = o.OBJECT_ID
INNER JOIN sys.sysindexes si
	ON i.OBJECT_ID = si.id
		AND i.index_id = si.indid
WHERE o.TYPE <> 'S'
	AND STATS_DATE(i.OBJECT_ID, i.index_id) IS NOT NULL

UNION ALL

SELECT TableName = OBJECT_NAME(o.OBJECT_ID)
	, ObjectType = o.type_desc
	, StatisticsName = s.NAME
	, statisticsUpdateDate = STATS_DATE(o.OBJECT_ID, s.stats_id)
	, RecordModified = si.rowmodctr
	, NumberofRecords = ir.rowcnt
FROM sys.stats s
INNER JOIN sys.objects o
	ON s.OBJECT_ID = o.OBJECT_ID
INNER JOIN sys.sysindexes si
	ON s.OBJECT_ID = si.id
		AND s.stats_id = si.indid
INNER JOIN (
	SELECT id
		, rowcnt
	FROM sys.sysindexes
	WHERE indid IN (
			0
			, 1
			)
	) IR
	ON IR.id = o.OBJECT_ID
WHERE o.TYPE <> 'S'
	AND (
		s.auto_created = 1
		OR s.user_created = 1
		)
	AND STATS_DATE(o.OBJECT_ID, s.stats_id) IS NOT NULL
