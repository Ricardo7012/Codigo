-- Search through Database Tables for a String

DECLARE @TableSearch VARCHAR(50)
DECLARE @TotalRows INT
DECLARE @Counter INT
DECLARE @TableName VARCHAR(50)
DECLARE @ColumnName VARCHAR(50)
DECLARE @FieldValue VARCHAR(250)
DECLARE @SQLCommand NVARCHAR(2000)
DECLARE @StringtoFind VARCHAR(100)

-->
SET @TableSearch = 'B%'
SET @StringtoFind = '8163947'

-->
DECLARE @MyTable TABLE (
	RowID INT IDENTITY
	, TableName VARCHAR(50)
	, ColumnName VARCHAR(50)
	)

CREATE TABLE #FoundTable (
	RowID INT IDENTITY
	, Tablename VARCHAR(50)
	)

INSERT INTO @MyTable
SELECT Table_Name
	, Column_Name
FROM INFORMATION_SCHEMA.COLUMNS
WHERE Data_Type IN (
		'char'
		, 'varchar'
		, 'nchar'
		, 'nvarchar'
		, 'text'
		, 'ntext'
		, 'smallint'
		, 'int'
		, 'bigint'
		)
	AND Table_Name LIKE @TableSearch
ORDER BY Table_Name ASC

SELECT @TotalRows = @@ROWCOUNT
	, @Counter = 1

WHILE (@Counter <= @TotalRows)
BEGIN
	SELECT @TableName = TableName
		, @ColumnName = ColumnName
	FROM @MyTable
	WHERE RowID = @Counter

	SET @SQLCommand = 'IF EXISTS ( ' + 'SELECT 1 FROM [' + @TableName + '] WHERE [' + @ColumnName + '] LIKE ''%' + @StringtoFind + '%'' ' + ' )' + 'INSERT INTO #FoundTable ' + '   SELECT ''' + @TableName + '(' + @ColumnName + ')'''

	EXECUTE sp_executesql @SQLCommand

	SET @Counter = (@Counter + 1)
END

SELECT *
FROM #FoundTable

DROP TABLE #FoundTable
