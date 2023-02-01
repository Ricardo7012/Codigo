-- List Bottom up Hierarchy Dependencies

WITH Fkeys
AS (
	SELECT DISTINCT OnTable = OnTable.NAME
		, AgainstTable = AgainstTable.NAME
	FROM sysforeignkeys fk
	INNER JOIN sysobjects onTable
		ON fk.fkeyid = onTable.id
	INNER JOIN sysobjects againstTable
		ON fk.rkeyid = againstTable.id
	WHERE 1 = 1
		AND AgainstTable.TYPE = 'U'
		AND OnTable.TYPE = 'U'
		-- ignore self joins; they cause an infinite recursion
		AND OnTable.NAME <> AgainstTable.NAME
	)
	, MyData
AS (
	SELECT OnTable = FKeys.onTable
		, AgainstTable = o.NAME
	FROM sys.objects o
	LEFT JOIN FKeys
		ON o.NAME = FKeys.againstTable
	WHERE 1 = 1
		AND o.type = 'U'
		AND o.NAME NOT LIKE 'sys%'
	)
	, MyRecursion
AS (
	-- base case
	SELECT TableName = AgainstTable
		, Lvl = 1
		, DepPath = convert(VARCHAR(max), AgainstTable)
	FROM MyData
	WHERE 1 = 1
		AND OnTable IS NULL
	-- recursive case
	
	UNION ALL
	
	SELECT TableName = AgainstTable
		, Lvl = r.Lvl + 1
		, DepPath = convert(VARCHAR(max), r.DepPath + '  - - ->   ' + AgainstTable)
	FROM MyData d
	INNER JOIN MyRecursion r
		ON d.OnTable = r.TableName
	)
SELECT Level = replicate(' .... ', Lvl) + convert(VARCHAR(3), Lvl)
	, TableName AS 'Table Name'
	, DepPath AS 'Dep Path'
FROM MyRecursion
ORDER BY DepPath
