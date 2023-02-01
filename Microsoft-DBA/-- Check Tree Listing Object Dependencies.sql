-- Check Tree Listing Object Dependencies

DECLARE @object VARCHAR(255)

SET @object = 'Proc_Log_PlayerSessionChanges'

; WITH ObjectTree AS (
	SELECT
		o.[name] AS [Base Object]
		, o.[name] AS [Object]
		, o.[xtype] AS [Object Type]
		, o.[ID] AS [Object_ID]
		, CAST(o.[name] AS VARCHAR(MAX)) AS [Execution Path]
		, 0 AS [Level]
	FROM
		sys.sysObjects o
	WHERE
		o.xtype NOT IN ('U', 'V')
		AND (o.[name] = @object OR @object IS NULL)
	UNION ALL SELECT
		ot.[Base Object]
		, o.[name] AS [Object]
		, o.[xType] AS [Object Type]
		, o.[ID] AS [Object_ID]
		, ot.[Execution Path] + CAST(' -> ' + o.[name] AS VARCHAR(MAX)) AS [Execution Path]
		, ot.[level] + 1
	FROM
		ObjectTree ot
		JOIN sys.sysDepends sd ON sd.[ID] = ot.[object_ID]
		JOIN sys.sysObjects o ON o.[ID] = sd.[depID]
	WHERE
		o.xtype NOT IN ('U', 'V')
		AND ot.[Execution Path] NOT LIKE '%' + o.[name] + '%'
	)

SELECT
	[Base Object]
	, [Object]
	, [Execution Path]
	, [Level]
FROM
	ObjectTree 
ORDER BY
	[Base Object]
	, [Execution Path]

OPTION (MAXRECURSION 500);