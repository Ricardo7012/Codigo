-- List Tables to Dependent Tables

-- Declare Variables
DECLARE @MasterTable VARCHAR(100)
DECLARE @TableCompleteName VARCHAR(100)
DECLARE @TablesName VARCHAR(1000)

-- Declare temp table which is used for storing table name and dependent table list
CREATE TABLE #temptable (
	tablecompletename VARCHAR(100)
	, tablename VARCHAR(1000)
	)

-- Get all table name from sys objects 
DECLARE tmp_cur CURSOR STATIC
FOR
SELECT s.NAME + '.' + o.NAME
	, o.NAME
FROM sys.objects o
INNER JOIN sys.schemas s
	ON o.schema_id = s.schema_id
WHERE type = 'U'
ORDER BY s.NAME
	, o.NAME

-- Fetch all table name    
OPEN tmp_cur

-- Get fetch one by one table name and it's dependent table name     
FETCH FIRST
FROM tmp_cur
INTO @TableCompleteName
	, @mastertable

WHILE @@FETCH_STATUS = 0
BEGIN
	--
	SELECT @tablesname = COALESCE(@tablesname + ',' + '    ', '') + s.NAME + '.' + OBJECT_NAME(FKEYID)
	FROM SYSFOREIGNKEYS
	INNER JOIN sys.objects o
		ON o.object_id = SYSFOREIGNKEYS.fkeyid
	INNER JOIN sys.schemas s
		ON s.schema_id = o.schema_id
	WHERE OBJECT_NAME(RKEYID) = @mastertable

	INSERT INTO #temptable (
		tablecompletename
		, tablename
		)
	SELECT @TableCompleteName
		, COALESCE(@tablesname, '')

	SELECT @tablesname = NULL

	FETCH NEXT
	FROM tmp_cur
	INTO @TableCompleteName
		, @mastertable
END

SELECT tablecompletename AS TableName
	, tablename AS DependentTables
FROM #temptable

DROP TABLE #temptable

CLOSE tmp_cur

DEALLOCATE tmp_cur
