-- Update Statistics on all the Tables in the Database

SET NOCOUNT ON

DECLARE @SQLcommand NVARCHAR(512)
DECLARE @Table SYSNAME

DECLARE curAllTables CURSOR
FOR
SELECT table_schema + '.' + table_name
FROM information_schema.tables
WHERE TABLE_TYPE = 'BASE TABLE'

OPEN curAllTables

FETCH NEXT
FROM curAllTables
INTO @Table

WHILE (@@FETCH_STATUS = 0)
BEGIN
	PRINT N'UPDATING STATISTICS FOR TABLE: ' + @Table

	SET @SQLcommand = 'UPDATE STATISTICS ' + @Table + ' WITH FULLSCAN'

	EXEC sp_executesql @SQLcommand

	FETCH NEXT
	FROM curAllTables
	INTO @Table
END

CLOSE curAllTables

DEALLOCATE curAllTables

SET NOCOUNT OFF
GO


