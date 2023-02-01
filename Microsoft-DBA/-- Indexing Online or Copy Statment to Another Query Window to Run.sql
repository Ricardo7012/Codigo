-- Indexing Online or Copy Statment to Another Query Window to Run

--/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--	Arguments           Data Type               Description
--------------          ------------            ------------
--	@FillFactor         [int]                   Specifies a percentage that indicates how full the Database Engine should make the leaf level
--                                              of each index page during index creation or alteration. The valid inputs for this parameter
--                                              must be an integer value from 1 to 100 The default is 0.
--                                              For more information, see http://technet.microsoft.com/en-us/library/ms177459.aspx.
--	@PadIndex           [varchar](3)            Specifies index padding. The PAD_INDEX option is useful only when FILLFACTOR is specified,
--                                              because PAD_INDEX uses the percentage specified by FILLFACTOR. If the percentage specified
--                                              for FILLFACTOR is not large enough to allow for one row, the Database Engine internally
--                                              overrides the percentage to allow for the minimum. The number of rows on an intermediate
--                                              index page is never less than two, regardless of how low the value of fillfactor. The valid
--                                              inputs for this parameter are ON or OFF. The default is OFF.
--                                              For more information, see http://technet.microsoft.com/en-us/library/ms188783.aspx.
--	@SortInTempDB       [varchar](3)            Specifies whether to store temporary sort results in tempdb. The valid inputs for this
--                                              parameter are ON or OFF. The default is OFF.
--                                              For more information, see http://technet.microsoft.com/en-us/library/ms188281.aspx.
--	@OnlineRebuild      [varchar](3)            Specifies whether underlying tables and associated indexes are available for queries and data
--                                              modification during the index operation. The valid inputs for this parameter are ON or OFF.
--                                              The default is OFF.
--                                              Note: Online index operations are only available in Enterprise edition of Microsoft
--                                                      SQL Server 2005 and above.
--                                              For more information, see http://technet.microsoft.com/en-us/library/ms191261.aspx.
--	@DataCompression    [varchar](4)            Specifies the data compression option for the specified index, partition number, or range of
--                                              partitions. The options  for this parameter are as follows:
--                                                  > NONE - Index or specified partitions are not compressed.
--                                                  > ROW  - Index or specified partitions are compressed by using row compression.
--                                                  > PAGE - Index or specified partitions are compressed by using page compression.
--                                              The default is NONE.
--                                              Note: Data compression feature is only available in Enterprise edition of Microsoft
--                                                      SQL Server 2005 and above.
--                                              For more information about compression, see http://technet.microsoft.com/en-us/library/cc280449.aspx.
--	@MaxDOP             [int]                   Overrides the max degree of parallelism configuration option for the duration of the index
--                                              operation. The valid input for this parameter can be between 0 and 64, but should not exceed
--                                              number of processors available to SQL Server.
--                                              For more information, see http://technet.microsoft.com/en-us/library/ms189094.aspx.
--- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
-- Ensure a USE <databasename> statement has been executed first.

SET NOCOUNT ON;

DECLARE @Version [numeric] (18, 10)
	, @EnableExecute					[bit]			= 0			-- Change if needed
	, @SQLStatementID					[int]
	, @CurrentTSQLToExecute				[nvarchar] (max)
	, @FillFactor						[int]			= 90		-- Change if needed
	, @PadIndex							[varchar](3)	= N'OFF'	-- Change if needed
	, @SortInTempDB						[varchar](3)	= N'OFF'	-- Change if needed
	, @OnlineRebuild					[varchar](3)	= N'OFF'	-- Change if needed
	, @LOBCompaction					[varchar](3)	= N'ON'		-- Change if needed
	, @DataCompression					[varchar](4)	= N'NONE'	-- Change if needed
	, @MaxDOP							[int]			= NULL		-- Change if needed
	, @IncludeDataCompressionArgument	[char](1)


IF OBJECT_ID(N'TempDb.dbo.#Work_To_Do') IS NOT NULL
	DROP TABLE #Work_To_Do

CREATE TABLE #Work_To_Do (
	[sql_id] [int] IDENTITY(1, 1) PRIMARY KEY
	, [tsql_text] [varchar](1024)
	, [completed] [bit]
	)

SET @Version = CAST(LEFT(CAST(SERVERPROPERTY(N'ProductVersion') AS [nvarchar](128)), CHARINDEX('.', CAST(SERVERPROPERTY(N'ProductVersion') AS [nvarchar](128))) - 1) + N'.' + REPLACE(RIGHT(CAST(SERVERPROPERTY(N'ProductVersion') AS [nvarchar](128)), LEN(CAST(SERVERPROPERTY(N'ProductVersion') AS [nvarchar](128))) - CHARINDEX('.', CAST(SERVERPROPERTY(N'ProductVersion') AS [nvarchar](128)))), N'.', N'') AS [numeric](18, 10))

IF @DataCompression IN (
		N'PAGE'
		, N'ROW'
		, N'NONE'
		)
	AND (
		@Version >= 10.0
		AND SERVERPROPERTY(N'EngineEdition') = 3
		)
BEGIN
	SET @IncludeDataCompressionArgument = N'Y'
END

IF @IncludeDataCompressionArgument IS NULL
BEGIN
	SET @IncludeDataCompressionArgument = N'N'
END

INSERT INTO #Work_To_Do (
	[tsql_text]
	, [completed]
	)
SELECT 'ALTER INDEX [' + i.[name] + '] ON' + SPACE(1) + QUOTENAME(t2.[TABLE_CATALOG]) + '.' + QUOTENAME(t2.[TABLE_SCHEMA]) + '.' + QUOTENAME(t2.[TABLE_NAME]) + SPACE(1) + 'REBUILD WITH (' + SPACE(1) + + CASE 
		WHEN @PadIndex IS NULL
			THEN 'PAD_INDEX =' + SPACE(1) + CASE i.[is_padded]
					WHEN 1
						THEN 'ON'
					WHEN 0
						THEN 'OFF'
					END
		ELSE 'PAD_INDEX =' + SPACE(1) + @PadIndex
		END + CASE 
		WHEN @FillFactor IS NULL
			THEN ', FILLFACTOR =' + SPACE(1) + CONVERT([varchar](3), REPLACE(i.[fill_factor], 0, 100))
		ELSE ', FILLFACTOR =' + SPACE(1) + CONVERT([varchar](3), @FillFactor)
		END + CASE 
		WHEN @SortInTempDB IS NULL
			THEN ''
		ELSE ', SORT_IN_TEMPDB =' + SPACE(1) + @SortInTempDB
		END + CASE 
		WHEN @OnlineRebuild IS NULL
			THEN ''
		ELSE ', ONLINE =' + SPACE(1) + @OnlineRebuild
		END + ', STATISTICS_NORECOMPUTE =' + SPACE(1) + CASE st.[no_recompute]
		WHEN 0
			THEN 'OFF'
		WHEN 1
			THEN 'ON'
		END + ', ALLOW_ROW_LOCKS =' + SPACE(1) + CASE i.[allow_row_locks]
		WHEN 0
			THEN 'OFF'
		WHEN 1
			THEN 'ON'
		END + ', ALLOW_PAGE_LOCKS =' + SPACE(1) + CASE i.[allow_page_locks]
		WHEN 0
			THEN 'OFF'
		WHEN 1
			THEN 'ON'
		END + CASE 
		WHEN @IncludeDataCompressionArgument = N'Y'
			THEN CASE 
					WHEN @DataCompression IS NULL
						THEN ''
					ELSE ', DATA_COMPRESSION =' + SPACE(1) + @DataCompression
					END
		ELSE ''
		END + CASE 
		WHEN @MaxDop IS NULL
			THEN ''
		ELSE ', MAXDOP =' + SPACE(1) + CONVERT([varchar](2), @MaxDOP)
		END + SPACE(1) + ')'
	, 0
FROM [sys].[tables] t1
INNER JOIN [sys].[indexes] i
	ON t1.[object_id] = i.[object_id]
		AND i.[index_id] > 0
		AND i.[type] IN (
			1
			, 2
			)
INNER JOIN [INFORMATION_SCHEMA].[TABLES] t2
	ON t1.[name] = t2.[TABLE_NAME]
		AND t2.[TABLE_TYPE] = 'BASE TABLE'
INNER JOIN [sys].[stats] AS st WITH (NOLOCK)
	ON st.[object_id] = t1.[object_id]
		AND st.[name] = i.[name]

SELECT @SQLStatementID = MIN([sql_id])
FROM #Work_To_Do
WHERE [completed] = 0

WHILE @SQLStatementID IS NOT NULL
BEGIN
	SELECT @CurrentTSQLToExecute = [tsql_text]
	FROM #Work_To_Do
	WHERE [sql_id] = @SQLStatementID

	IF @EnableExecute = 0
	
	BEGIN

    	PRINT '-- You diabled run against all tables'
		PRINT '-- Copy Messages below into another query window and run one at a time'
		PRINT '-- Any time you reindex make sure to monitor the log DBCC SQLPERF(LOGSPACE)'
		PRINT ''
		PRINT @CurrentTSQLToExecute
		PRINT ''
		
	END
		
		ELSE
	
	BEGIN
    
		PRINT '-- You enabled run against all tables'
		PRINT '-- Any time you reindex make sure to monitor the log DBCC SQLPERF(LOGSPACE)'
		EXEC [sys].[sp_executesql] @CurrentTSQLToExecute

	END

	UPDATE #Work_To_Do
	SET [completed] = 1
	WHERE [sql_id] = @SQLStatementID

	SELECT @SQLStatementID = MIN([sql_id])
	FROM #Work_To_Do
	WHERE [completed] = 0

END
