SELECT schemas.NAME AS 'Table Schema'
	, tbls.NAME AS 'Table Name'
	, i.NAME AS 'Index Name'
	, i.rowmodctr AS 'Modified Rows'
	, (
		SELECT max(rowcnt)
		FROM sysindexes i2
		WHERE i.id = i2.id
			AND i2.indid < 2
		) AS 'Row Cnt'
	, convert(DECIMAL(18, 8), convert(DECIMAL(18, 8), i.rowmodctr) / convert(DECIMAL(18, 8), (
				SELECT max(rowcnt)
				FROM sysindexes i2
				WHERE i.id = i2.id
					AND i2.indid < 2
				))) AS 'Modified Percent'
	, stats_date(i.id, i.indid) AS 'Last Stats Update'
FROM sysindexes i
INNER JOIN sysobjects tbls
	ON i.id = tbls.id
INNER JOIN sysusers schemas
	ON tbls.uid = schemas.uid
INNER JOIN information_schema.tables tl
	ON tbls.NAME = tl.table_name
		AND schemas.NAME = tl.table_schema
		AND tl.table_type = 'BASE TABLE'
WHERE 0 < i.indid
	AND i.indid < 255
	AND table_schema <> 'sys'
	AND i.rowmodctr <> 0
	AND i.STATUS NOT IN (
		8388704
		, 8388672
		)
	AND (
		SELECT max(rowcnt)
		FROM sysindexes i2
		WHERE i.id = i2.id
			AND i2.indid < 2
		) > 0
ORDER BY 'Modified Percent' DESC
