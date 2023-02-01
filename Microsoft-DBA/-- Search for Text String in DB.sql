-- Search for Text String in DB

DECLARE @Tablenames VARCHAR(500)
DECLARE @SearchStr NVARCHAR(60)
DECLARE @GenerateSQLOnly BIT = 0
DECLARE @MatchFound BIT

SET @Tablenames = ''
SET @SearchStr = '10858877'	-- Set String to Search For
SET @GenerateSQLOnly = 0	-- Create SQL Script and do not Search
SET NOCOUNT ON
SET @MatchFound = 0

DECLARE @CheckTableNames TABLE (Tablename SYSNAME)
DECLARE @SQLTbl TABLE (
	Tablename SYSNAME
	, WhereClause VARCHAR(MAX)
	, SQLStatement VARCHAR(MAX)
	, Execstatus BIT
	)
DECLARE @SQL VARCHAR(MAX)
DECLARE @tmpTblname SYSNAME
DECLARE @ErrMsg VARCHAR(100)

IF LTRIM(RTRIM(@Tablenames)) IN ('', '%')
BEGIN
	INSERT INTO @CheckTableNames
	SELECT NAME
	FROM sys.tables
	ORDER BY NAME
END
ELSE
BEGIN
	SELECT @SQL = 'SELECT ''' + REPLACE(@Tablenames, ',', ''' UNION SELECT ''') + ''''

	INSERT INTO @CheckTableNames
	EXEC (@SQL)
END

IF NOT EXISTS (
		SELECT 1
		FROM @CheckTableNames
		)
BEGIN
	SELECT @ErrMsg = 'No tables are found in this database ' + DB_NAME() + ' for the specified filter'

	PRINT @ErrMsg

	RETURN
END

INSERT INTO @SQLTbl (
	Tablename
	, WHEREClause
	)
SELECT QUOTENAME(SCh.NAME) + '.' + QUOTENAME(ST.NAME)
	, (
		SELECT '[' + SC.NAME + ']' + ' LIKE ''' + @SearchStr + ''' OR ' + CHAR(10)
		FROM SYS.columns SC
		INNER JOIN SYS.types STy
			ON STy.system_type_id = SC.system_type_id
				AND STy.user_type_id = SC.user_type_id
		WHERE STY.NAME IN (
				'varchar'
				, 'char'
				, 'nvarchar'
				, 'nchar'
				, 'text'
				, 'int'
				)
			AND SC.object_id = ST.object_id
		ORDER BY SC.NAME
		FOR XML PATH('')
		)
FROM SYS.tables ST
INNER JOIN @CheckTableNames chktbls
	ON chktbls.Tablename = ST.NAME
INNER JOIN SYS.schemas SCh
	ON ST.schema_id = SCh.schema_id
WHERE ST.NAME <> 'SearchTMP'
GROUP BY ST.object_id
	, QUOTENAME(SCh.NAME) + '.' + QUOTENAME(ST.NAME);

UPDATE @SQLTbl
SET SQLStatement = 'SELECT * INTO SearchTMP FROM ' + Tablename + ' WHERE ' + substring(WHEREClause, 1, len(WHEREClause) - 5)

DELETE
FROM @SQLTbl
WHERE WHEREClause IS NULL

WHILE EXISTS (
		SELECT 1
		FROM @SQLTbl
		WHERE ISNULL(Execstatus, 0) = 0
		)
BEGIN
	SELECT TOP 1 @tmpTblname = Tablename
		, @SQL = SQLStatement
	FROM @SQLTbl
	WHERE ISNULL(Execstatus, 0) = 0

	IF @GenerateSQLOnly = 0
	BEGIN
		IF OBJECT_ID('SearchTMP', 'U') IS NOT NULL
			DROP TABLE SearchTMP

		EXEC (@SQL)

		IF EXISTS (
				SELECT 1
				FROM SearchTMP
				)
		BEGIN
			SELECT Tablename = @tmpTblname
				, *
			FROM SearchTMP

			SELECT @MatchFound = 1
		END
	END
	ELSE
	BEGIN
		PRINT REPLICATE('-', 100)
		PRINT @tmpTblname
		PRINT REPLICATE('-', 100)
		PRINT replace(@SQL, 'INTO SearchTMP', '')
	END

	UPDATE @SQLTbl
	SET Execstatus = 1
	WHERE Tablename = @tmpTblname
END

IF @MatchFound = 0
BEGIN
	SELECT @ErrMsg = 'No Matches are found in this database ' + DB_NAME() + ' for the specified filter'

	PRINT @ErrMsg

	RETURN
END

SET NOCOUNT OFF
GO


