-- List Stats that Need Updating

SET NOCOUNT ON
GO

DECLARE updatestats CURSOR
FOR
SELECT table_schema
	, table_name
FROM information_schema.tables
WHERE TABLE_TYPE = 'BASE TABLE'

OPEN updatestats

DECLARE @tableSchema NVARCHAR(128)
DECLARE @tableName NVARCHAR(128)
DECLARE @Statement NVARCHAR(300)

FETCH NEXT
FROM updatestats
INTO @tableSchema
	, @tableName

WHILE (@@FETCH_STATUS = 0)
BEGIN
	PRINT N'-- UPDATING STATISTICS ' + '[' + @tableSchema + ']' + '.' + '[' + @tableName + ']'

	SET @Statement = 'UPDATE STATISTICS ' + '[' + @tableSchema + ']' + '.' + '[' + @tableName + ']' + '  WITH FULLSCAN'

	PRINT @Statement
	--EXEC sp_executesql @Statement

	FETCH NEXT
	FROM updatestats
	INTO @tableSchema
		, @tableName
END

CLOSE updatestats

DEALLOCATE updatestats
GO

SET NOCOUNT OFF
GO


