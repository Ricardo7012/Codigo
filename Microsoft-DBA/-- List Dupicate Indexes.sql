-- List Dupicate Indexes

SET NOCOUNT ON;

DECLARE @First [smallint]
	, @Last [smallint]
	, @DBName [nvarchar] (128)
	, @SQLServer [nvarchar] (128)
	, @StringToExecuteP1 [nvarchar] (max)
	, @StringToExecuteP2 [nvarchar] (max)
	, @StringToExecuteP3 [nvarchar] (max)

IF NOT EXISTS (
		SELECT *
		FROM [tempdb].[sys].[objects]
		WHERE [name] = 'DUPLICATE_INDEXES_INFO'
			AND [type] IN (N'U')
		)
BEGIN
	CREATE TABLE [tempdb].[dbo].[DUPLICATE_INDEXES_INFO] (
		[Server] [nvarchar](128)
		, [Database] [nvarchar](128)
		, [TableName] [varchar](256)
		, [IndexName] [varchar](256)
		, [IndexType] [varchar](13)
		, [KeyColumns] [varchar](512)
		, [NonKeyColumns] [varchar](512)
		, [KeyColumnsOrder] [varchar](512)
		, [NonKeyColumnsOrder] [varchar](512)
		, [IsUnique] [char](1)
		, [HasNonKeyColumns] [char](1)
		, [CheckDate] [datetime]
		)
END
ELSE
BEGIN
	TRUNCATE TABLE [tempdb].[dbo].[DUPLICATE_INDEXES_INFO]
END

IF OBJECT_ID('Tempdb.dbo.#Indexes') IS NOT NULL
	DROP TABLE #Indexes

CREATE TABLE #Indexes (
	[RowNo] [smallint] IDENTITY(1, 1)
	, [TableName] [varchar](256)
	, [IndexName] [varchar](256)
	, [IsUnique] [smallint]
	, [IndexType] [varchar](13)
	)

IF OBJECT_ID('Tempdb.dbo.#AllIndexesInfo') IS NOT NULL
	DROP TABLE #AllIndexesInfo

CREATE TABLE #AllIndexesInfo (
	[ObjectID] [int] NOT NULL
	, [TableName] [nvarchar](128) NULL
	, [IndexID] [int] NOT NULL
	, [IndexName] [sysname] NULL
	, [IndexType] [varchar](13) NOT NULL
	, [ColumnID] [int] NOT NULL
	, [ColumnName] [sysname] NULL
	, [IncludedColumns] [bit] NULL
	, [IsUnique] [bit] NULL
	)

IF OBJECT_ID('Tempdb.dbo.#AllIndexesDetailedInfo') IS NOT NULL
	DROP TABLE #AllIndexesDetailedInfo

CREATE TABLE #AllIndexesDetailedInfo (
	[TableName] [varchar](256)
	, [IndexName] [varchar](256)
	, [IndexType] [varchar](13)
	, [KeyColumns] [varchar](512)
	, [NonKeyColumns] [varchar](512)
	, [KeyColumnsOrder] [varchar](512)
	, [NonKeyColumnsOrder] [varchar](512)
	, [IsUnique] [char](1)
	, [HasNonKeyColumns] [char](1)
	)

DECLARE @DatabaseList TABLE (
	[RowNo] [smallint] identity(1, 1)
	, [DBName] [varchar](200)
	)

SELECT @SQLServer = CAST(SERVERPROPERTY('ServerName') AS [nvarchar](128))

INSERT INTO @DatabaseList
SELECT [name]
FROM [master].[sys].[databases] WITH (NOLOCK)
WHERE [state_desc] = 'ONLINE'
	AND [source_database_id] IS NULL
	AND [database_id] > 4

SELECT @First = MIN([RowNo])
FROM @DatabaseList

SELECT @Last = MAX([RowNo])
FROM @DatabaseList

WHILE @First <= @Last
BEGIN
	SELECT @DBName = [DBName]
	FROM @DatabaseList
	WHERE [RowNo] = @First

	SET @StringToExecuteP1 = 'USE [' + @DBName + '];
		INSERT INTO #AllIndexesInfo
				   ([ObjectID]
				   ,[TableName]
				   ,[IndexID]
				   ,[IndexName]
				   ,[IndexType]
				   ,[ColumnID]
				   ,[ColumnName]
				   ,[IncludedColumns]
				   ,[IsUnique])
		SELECT o.[object_id] AS [ObjectID]
			  ,OBJECT_NAME(o.[object_id]) AS [TableName]
			  ,i.[index_id] AS [IndexID]
			  ,i.[name] AS [IndexName]
			  ,CASE i.[type]
				WHEN 0
					THEN ''Heap''
				WHEN 1
					THEN ''Clustered''
				WHEN 2
					THEN ''Non-Clustered''
				WHEN 3
					THEN ''XML''
				ELSE ''Unknown''
				END AS [IndexType]
			,ic.[column_id] AS [ColumnID]
			,c.[name] AS [ColumnName]
			,ic.[is_included_column] [IncludedColumns]
			,i.[is_unique] AS [IsUnique]
		FROM [' + @DBName + '].[sys].[indexes] i
		INNER JOIN [' + @DBName + '].[sys].[objects] o 
			ON i.[object_id] = o.[object_id]
				AND o.[type] = ''U''
				AND i.[index_id] > 0
		INNER JOIN [' + @DBName + 
		'].[sys].[index_columns] ic 
			ON i.[index_id] = ic.[index_id]
				AND i.[object_id] = ic.[object_id]
		INNER JOIN [' + @DBName + '].[sys].[columns] c 
			ON c.[column_id] = ic.[column_id]
				AND c.[object_id] = ic.[object_id]
			
		INSERT INTO #Indexes
		SELECT DISTINCT [TableName]
			,[IndexName]
			,[IsUnique]
			,[IndexType]
		FROM #AllIndexesInfo'

	EXEC (@StringToExecuteP1)

	SET @StringToExecuteP2 = 'USE [' + @DBName + 
		'];
		DECLARE @First				[smallint]
			   ,@Last				[smallint]
			   ,@IsUnique			[smallint]
			   ,@HasNonKeyCols		[char] (1)
			   ,@TableName			[varchar] (256)
			   ,@IndexName			[varchar] (256)
			   ,@IndexType			[varchar] (13)
			   ,@IndexColumns		[varchar] (1000)
			   ,@IncludedColumns	[varchar] (1000)
			   ,@IndexColsOrder		[varchar] (1000)
			   ,@IncludedColsOrder  [varchar] (1000)

		SELECT @First = MIN([RowNo])
		FROM #Indexes

		SELECT @Last = MAX([RowNo])
		FROM #Indexes

		WHILE @First <= @Last
		BEGIN
			SET @IndexColumns = NULL
			SET @IncludedColumns = NULL
			SET @IncludedColsOrder = NULL
			SET @IndexColsOrder = NULL

			SELECT @TableName = [TableName]
				  ,@IndexName = [IndexName]
				  ,@IsUnique  = [IsUnique]
				  ,@IndexType = [IndexType]
			FROM #Indexes
			WHERE [RowNo] = @First

			SELECT @IndexColumns = COALESCE(@IndexColumns + '', '', '''') 
										+ [ColumnName]
			FROM #AllIndexesInfo
			WHERE [TableName] = @TableName
				AND [IndexName] = @IndexName
				AND [IncludedColumns] = 0
			ORDER BY [IndexName]
					,[ColumnName]

			SELECT @IncludedColumns = COALESCE(@IncludedColumns + '', '', '''') 
										+ [ColumnName]
			FROM #AllIndexesInfo
			WHERE [TableName] = @TableName
				AND [IndexName] = @IndexName
				AND [IncludedColumns] = 1
			ORDER BY [IndexName]
					,[ColumnName]

			SELECT @IndexColsOrder = COALESCE(@IndexColsOrder + '', '', '''') 
										+ [ColumnName]
			FROM #AllIndexesInfo
			WHERE [TableName] = @TableName
				AND [IndexName] = @IndexName
				AND [IncludedColumns] = 0

			SELECT @IncludedColsOrder = COALESCE(@IncludedColsOrder + '', '', '''') 
										+ [ColumnName]
			FROM #AllIndexesInfo
			WHERE [TableName] = @TableName
				AND [IndexName] = @IndexName
				AND [IncludedColumns] = 1

			SET @HasNonKeyCols = ''N''

			IF @IncludedColumns IS NOT NULL
			BEGIN
				SET @HasNonKeyCols = ''Y''
			END

			INSERT INTO #AllIndexesDetailedInfo (
				[TableName]
				,[IndexName]
				,[IndexType]
				,[IsUnique]
				,[KeyColumns]
				,[KeyColumnsOrder]
				,[HasNonKeyColumns]
				,[NonKeyColumns]
				,[NonKeyColumnsOrder]
				) SELECT @TableName
				,@IndexName
				,@IndexType
				,CASE @IsUnique
					WHEN 1
						THEN ''Y''
					WHEN 0
						THEN ''N''
					END
				,@IndexColumns
				,@IndexColsOrder
				,@HasNonKeyCols
				,@IncludedColumns
				,@IncludedColsOrder

			SET @First = @First + 1
		END'

	EXEC (@StringToExecuteP2)

	SET @StringToExecuteP3 = 'USE [' + @DBName + '];
	  INSERT INTO [tempdb].[dbo].[DUPLICATE_INDEXES_INFO]
			   ([Server]
			   ,[Database]
			   ,[TableName]
			   ,[IndexName]
			   ,[IndexType]
	   		   ,[KeyColumns]
			   ,[HasNonKeyColumns]
			   ,[NonKeyColumns]
			   ,[KeyColumnsOrder]
			   ,[NonKeyColumnsOrder]
			   ,[IsUnique]
			   ,[CheckDate])
		SELECT  ''' + @SQLServer + '''
			   ,''' + @DBName + '''
			   ,[TableName]
			   ,[IndexName]
			   ,[IndexType]
	   		   ,[KeyColumns]
			   ,[HasNonKeyColumns]
			   ,[NonKeyColumns]
			   ,[KeyColumnsOrder]
			   ,[NonKeyColumnsOrder]
			   ,[IsUnique]
			   ,CURRENT_TIMESTAMP
		FROM
		(
		  SELECT DISTINCT 
			 a1.[TableName]
			,a1.[IndexName]
			,a1.[IndexType]
			,a1.[KeyColumns]
			,a1.[HasNonKeyColumns]
			,a1.[NonKeyColumns]
			,a1.[KeyColumnsOrder]
			,a1.[NonKeyColumnsOrder]
			,a1.[IsUnique]
		  FROM #AllIndexesDetailedInfo a1
		  INNER JOIN #AllIndexesDetailedInfo a2 
			ON a1.[TableName] = a2.TableName
			 AND a1.[IndexName] <> a2.[IndexName]
			 AND a1.[KeyColumns] = a2.[KeyColumns]
			 AND ISNULL(a1.[NonKeyColumns], '''') = ISNULL(a2.[NonKeyColumns], '''')
		  WHERE a1.[IndexType] <> ''XML''
		 ) a '

	EXEC (@StringToExecuteP3)

	TRUNCATE TABLE #Indexes

	TRUNCATE TABLE #AllIndexesInfo

	TRUNCATE TABLE #AllIndexesDetailedInfo

	SET @First = @First + 1
END

SELECT [Server]
	, [Database]
	, [TableName]
	, [IndexName]
	, [IndexType]
	, [KeyColumns]
	, [NonKeyColumns]
	, [KeyColumnsOrder]
	, [NonKeyColumnsOrder]
	, [IsUnique]
	, [HasNonKeyColumns]
	, [CheckDate]
FROM [tempdb].[dbo].[DUPLICATE_INDEXES_INFO]

SET NOCOUNT OFF;
