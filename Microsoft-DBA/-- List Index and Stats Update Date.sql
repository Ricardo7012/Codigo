-- List Index and Stats Update Date

DECLARE @tbl NVARCHAR(265)

SET @tbl = 'PlayerTrip0'

SELECT o.NAME AS 'Table Name'
	, i.index_id AS 'Index ID'
	, i.NAME AS 'Index Name'
	, i.type_desc AS 'Index Type'
	, substring(ikey.cols, 3, len(ikey.cols)) AS 'Key Cols'
	, substring(inc.cols, 3, len(inc.cols)) AS 'Included Cols'
	, stats_date(o.object_id, i.index_id) AS 'Stats Date'
FROM sys.objects o
INNER JOIN sys.indexes i
	ON i.object_id = o.object_id
CROSS APPLY (
	SELECT ', ' + c.NAME + CASE ic.is_descending_key
			WHEN 1
				THEN ' DESC'
			ELSE ''
			END
	FROM sys.index_columns ic
	INNER JOIN sys.columns c
		ON ic.object_id = c.object_id
			AND ic.column_id = c.column_id
	WHERE ic.object_id = i.object_id
		AND ic.index_id = i.index_id
		AND ic.is_included_column = 0
	ORDER BY ic.key_ordinal
	FOR XML PATH('')
	) AS ikey(cols)
OUTER APPLY (
	SELECT ', ' + c.NAME
	FROM sys.index_columns ic
	INNER JOIN sys.columns c
		ON ic.object_id = c.object_id
			AND ic.column_id = c.column_id
	WHERE ic.object_id = i.object_id
		AND ic.index_id = i.index_id
		AND ic.is_included_column = 1
	ORDER BY ic.index_column_id
	FOR XML PATH('')
	) AS inc(cols)
WHERE o.NAME = @tbl
	AND i.type IN (
		1
		, 2
		)
ORDER BY 'Table Name'
	, 'Index Id'
