-- Delete Statements for FK Tables

DECLARE @RootTableExt NVARCHAR(1000)
	, @RootColumn NVARCHAR(1000)
	, @FilterClause NVARCHAR(1000)

SELECT @RootTableExt = '[dbo].[Period]'
	, @RootColumn = 'Date'
	, @FilterClause = ' < ''03/04/2016''';

WITH MyData
AS (
	SELECT ForeignKey = fk.NAME
		, OnTableExt = convert(NVARCHAR(1000), '[' + ots.NAME + '].[' + OnTable.NAME + ']')
		, OnColumn = OnColumn.NAME
		, AgainstTableExt = convert(NVARCHAR(1000), '[' + ats.NAME + '].[' + AgainstTable.NAME + ']')
		, AgainstColumn = AgainstColumn.NAME
	FROM sys.foreign_keys fk
	INNER JOIN sys.foreign_key_columns fkcols
		ON fk.object_id = fkcols.constraint_object_id
	INNER JOIN sys.objects OnTable
		ON fk.parent_object_id = OnTable.object_id
	INNER JOIN sys.schemas ots
		ON OnTable.schema_id = ots.schema_id
	INNER JOIN sys.objects AgainstTable
		ON fk.referenced_object_id = AgainstTable.object_id
	INNER JOIN sys.schemas ats
		ON AgainstTable.schema_id = ats.schema_id
	INNER JOIN sys.columns OnColumn
		ON fkcols.parent_column_id = OnColumn.column_id
			AND fkcols.parent_object_id = OnColumn.object_id
	INNER JOIN sys.columns AgainstColumn
		ON fkcols.referenced_column_id = AgainstColumn.column_id
			AND fkcols.referenced_object_id = AgainstColumn.object_id
	WHERE 1 = 1
		AND AgainstTable.TYPE = 'U'
		AND OnTable.TYPE = 'U'
		AND OnTable.NAME NOT LIKE 'sys%'
		-- ignore self joins; they cause infinite recursion
		AND OnTable.NAME <> AgainstTable.NAME
	)
	, MyRecursion
AS (
	-- base case
	SELECT TableName = OnTableExt
		, Lvl = 1
		, WhereClause = CONVERT(NVARCHAR(4000), ' WHERE [' + @RootColumn + '] ' + @FilterClause)
		, ParentTable = CONVERT(NVARCHAR(1000), NULL)
	FROM MyData
	WHERE 1 = 1
		AND OnTableExt = @RootTableExt
	-- recursive case
	
	UNION ALL
	
	SELECT TableName = OnTableExt
		, Lvl = r.Lvl + 1
		, WhereClause = CONVERT(NVARCHAR(4000), CASE r.Lvl
				WHEN 1
					THEN ' WHERE [' + OnColumn + '] ' + @FilterClause
				ELSE ' WHERE [' + OnColumn + '] IN (SELECT [' + AgainstColumn + '] FROM ' + AgainstTableExt + ' ' + r.WhereClause + ')'
				END)
		, ParentTable = AgainstTableExt
	FROM MyData d
	INNER JOIN MyRecursion r
		ON d.AgainstTableExt = r.TableName
	)
	, MySql
AS (
	SELECT Lvl = max(Lvl)
		, Sort2 = 30
		, TableName
		, ParentTable
		, WhereClause
		, SqlCode = 'DELETE FROM ' + tablename + WhereClause
	FROM MyRecursion
	GROUP BY TableName
		, WhereClause
		, ParentTable
		, WhereClause
	)
SELECT Sort0 = 10
	, Lvl = 0
	, Sort2 = 0
	, TableName = ''
	, SqlCode = '/*================================================================================================='

UNION

SELECT Sort0 = 11
	, Lvl = 0
	, Sort2 = 0
	, TableName = ''
	, SqlCode = '    USAGE NOTE: Uncomment DELETE statements as needed to address errors.                           '

UNION

SELECT Sort0 = 12
	, Lvl = 0
	, Sort2 = 0
	, TableName = ''
	, SqlCode = '=================================================================================================*/'

UNION

SELECT Sort0 = 13
	, Lvl = 0
	, Sort2 = 0
	, TableName = ''
	, SqlCode = 'BEGIN TRAN'

UNION

SELECT DISTINCT Sort0 = 20
	, Lvl
	, Sort2 = 10
	, TableName = ''
	, SqlCode = ''
FROM MySql

UNION

SELECT DISTINCT Sort0 = 20
	, Lvl
	, Sort2 = 20
	, TableName = ''
	, SqlCode = '/*--- Level ' + CONVERT(VARCHAR(10), Lvl) + ' ---*/'
FROM MySql

UNION

SELECT Sort0 = 20
	, Lvl
	, Sort2
	, TableName
	, SqlCode = CASE 
		WHEN Lvl >= 2
			THEN '--'
		ELSE ''
		END + SqlCode
FROM MySql

UNION

SELECT Sort0 = 30
	, Lvl = 0
	, Sort2 = 0
	, TableName = ''
	, SqlCode = ''

UNION

SELECT Sort0 = 31
	, Lvl = 0
	, Sort2 = 0
	, TableName = ''
	, SqlCode = 'ROLLBACK TRAN'
ORDER BY Sort0
	, Lvl DESC
	, Sort2
	, TableName DESC
