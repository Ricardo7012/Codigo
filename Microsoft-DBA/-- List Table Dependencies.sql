-- List Table Dependencies

DECLARE @TableSchema VARCHAR(255) = 'dbo'
DECLARE @TableName VARCHAR(255) = 'Period'
DECLARE @nCnt1 INT
DECLARE @nCnt2 INT

DECLARE @Crsr CURSOR 
DECLARE @PKTable VARCHAR(255) 
DECLARE @Msg VARCHAR(255) 

DECLARE @Tab TABLE (
	[Owner] VARCHAR(255)
	, PKTable VARCHAR(255)
	, PKColumn VARCHAR(255)
	, FKOwner VARCHAR(255)
	, FKTable VARCHAR(255)
	, FKColumn VARCHAR(255)
	, Id INT identity
	, Priority INT
	) SET NOCOUNT
	ON SELECT @nCnt1 = 1 FROM INFORMATION_SCHEMA.TABLES WHERE table_name = @TableName
	AND table_schema = @TableSchema IF @@rowcount = 0
BEGIN
	SET @Msg = 'No table found ' + @TableName

	RAISERROR (
			@Msg
			, 16
			, 1
			)
	WITH NOWAIT
END
	DELETE @Tab INSERT INTO @Tab([Owner], PKTable, PKColumn) SELECT @TableSchema
	, @TableName
	, column_name FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS TC INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS KU
	ON TC.CONSTRAINT_TYPE = 'PRIMARY KEY'
		AND TC.CONSTRAINT_NAME = KU.CONSTRAINT_NAME
		AND ku.table_name = @TableName
		AND tc.table_schema = @TableSchema
		AND ku.table_schema = @TableSchema ORDER BY KU.TABLE_NAME
	, KU.ORDINAL_POSITION WHILE 1 = 1
BEGIN
	SELECT @nCnt1 = Count(*)
	FROM @Tab

	INSERT INTO @Tab (
		[Owner]
		, PKTable
		, PKColumn
		, FKOwner
		, FKTable
		, FKColumn
		)
	SELECT pk.table_schema AS pkowner
		, pk.table_name AS pktable
		, pk.column_name AS pkcolumn
		, fk.table_schema AS fkowner
		, fk.table_name AS fktable
		, fk.column_name AS fkcolumn
	FROM information_schema.REFERENTIAL_CONSTRAINTS c
		, information_schema.KEY_COLUMN_USAGE fk
		, information_schema.KEY_COLUMN_USAGE pk
	WHERE c.constraint_schema = fk.constraint_schema
		AND c.constraint_name = fk.constraint_name
		AND c.unique_constraint_schema = pk.constraint_schema
		AND c.unique_constraint_name = pk.constraint_name
		AND pk.ordinal_position = fk.ordinal_position
		AND pk.table_name IN (
			SELECT PKTable
			FROM @Tab
			
			UNION
			
			SELECT FKTable
			FROM @Tab
			)
		AND NOT EXISTS (
			SELECT 1
			FROM @Tab t
			WHERE t.[Owner] = pk.table_schema
				AND t.PKTable = pk.table_name
				AND t.PKColumn = pk.column_name
				AND t.FKOwner = fk.table_schema
				AND t.FKTable = fk.table_name
				AND t.FKColumn = fk.column_name
			)
		AND 1 = 1
	ORDER BY pk.table_schema
		, pk.table_name
		, pk.ordinal_position

	SELECT @nCnt2 = Count(*)
	FROM @Tab

	IF @nCnt1 = @nCnt2
		BREAK
END
	UPDATE @Tab SET [Priority] = [Id] UPDATE @Tab SET [Priority] = mx.[Id] FROM @Tab t INNER JOIN (
	SELECT x.FKTable
		, Max(x.Id) AS [Id]
	FROM @Tab x
	GROUP BY x.FKTable
	) mx
	ON mx.FKTable = t.FKTable SELECT PKTable
	, PKColumn
	, FKTable
	, FKColumn
	, [Priority] FROM @Tab ORDER BY [Priority]
	, [Id]
