-- List Cross Database Dependencies

DECLARE @DatabaseName VARCHAR(50)

SELECT @DatabaseName = 'ADI_PM_82'

CREATE TABLE #databases (
	database_id INT
	, database_name SYSNAME
	)

-- Ignore systems databases
INSERT INTO #databases (
	database_id
	, database_name
	)
SELECT database_id
	, NAME
FROM sys.databases
WHERE NAME = @DatabaseName

DECLARE @database_id INT
	, @database_name SYSNAME
	, @sql VARCHAR(max)

CREATE TABLE #dependencies (
	referencing_database VARCHAR(max)
	, referencing_schema VARCHAR(max)
	, referencing_object_name VARCHAR(max)
	, referenced_server VARCHAR(max)
	, referenced_database VARCHAR(max)
	, referenced_schema VARCHAR(max)
	, referenced_object_name VARCHAR(max)
	);

WHILE (
		SELECT COUNT(*)
		FROM #databases
		) > 0
BEGIN
	SELECT TOP 1 @database_id = database_id
		, @database_name = database_name
	FROM #databases

	SET @sql = 'INSERT INTO #dependencies select 
        DB_NAME(' + convert(VARCHAR, @database_id) + '), 
        OBJECT_SCHEMA_NAME(referencing_id,' + convert(VARCHAR, @database_id) + '), 
        OBJECT_NAME(referencing_id,' + convert(VARCHAR, @database_id) + '), 
        referenced_server_name,
        ISNULL(referenced_database_name, db_name(' + convert(VARCHAR, @database_id) + ')),
        referenced_schema_name,
        referenced_entity_name
    FROM ' + quotename(@database_name) + '.sys.sql_expression_dependencies';

	EXEC (@sql)

	DELETE
	FROM #databases
	WHERE database_id = @database_id
END

SET NOCOUNT OFF

SELECT *
FROM #dependencies
ORDER BY referencing_object_name

DROP TABLE #databases

DROP TABLE #dependencies
