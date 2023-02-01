-- List Top Down Hierarchy Dependencies

WITH Fkeys
AS (
	SELECT DISTINCT OnTable = OnTable.Name
		, AgainstTable = AgainstTable.Name
	FROM sysforeignkeys fk
	INNER JOIN sysobjects onTable
		ON fk.fkeyid = onTable.id
	INNER JOIN sysobjects againstTable
		ON fk.rkeyid = againstTable.id
	WHERE 1 = 1
		AND AgainstTable.TYPE = 'U'
		AND OnTable.TYPE = 'U'
		-- ignore self joins; they cause an infinite recursion
		AND OnTable.Name <> AgainstTable.Name
	)
	, MyData
AS (
	SELECT OnTable = o.Name
		, AgainstTable = FKeys.againstTable
	FROM sys.objects o
	LEFT JOIN FKeys
		ON o.Name = FKeys.onTable
	WHERE 1 = 1
		AND o.type = 'U'
		AND o.Name NOT LIKE 'sys%'
	)
	, MyRecursion
AS (
	-- base case
	SELECT TableName = OnTable
		, Lvl = 1
		, DepPath = convert(VARCHAR(max), OnTable)
	FROM MyData
	WHERE 1 = 1
		AND AgainstTable IS NULL
	-- recursive case
	
	UNION ALL
	
	SELECT TableName = OnTable
		, Lvl = r.Lvl + 1
		, DepPath = convert(VARCHAR(max), r.DepPath + '  - - ->   ' + OnTable)
	FROM MyData d
	INNER JOIN MyRecursion r
		ON d.AgainstTable = r.TableName
	)
SELECT Level = replicate(' .... ', Lvl) + convert(VARCHAR(3), Lvl)
	, TableName AS 'Table Name'
	, DepPath AS 'DepPath'
FROM MyRecursion
ORDER BY DepPath
