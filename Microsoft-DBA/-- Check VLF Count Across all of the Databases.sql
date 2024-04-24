-- Check VLF Count Across all of the Databases
 
DECLARE @query VARCHAR(100)
DECLARE @dbname SYSNAME
DECLARE @vlfs INT
--table variable used to 'loop' over databases  
DECLARE @databases TABLE (dbname SYSNAME)

INSERT INTO @databases
--only choose online databases  
SELECT NAME
FROM sys.databases
WHERE STATE = 0

--table variable to hold results  
DECLARE @vlfcounts TABLE (
	dbname SYSNAME
	, vlfcount INT
	)
--table variable to capture DBCC loginfo output  
--changes in the output of DBCC loginfo from SQL2012 mean we have to determine the version 
DECLARE @MajorVersion TINYINT

SET @MajorVersion = LEFT(CAST(SERVERPROPERTY('ProductVersion') AS NVARCHAR(max)), CHARINDEX('.', CAST(SERVERPROPERTY('ProductVersion') AS NVARCHAR(max))) - 1)

IF @MajorVersion < 11 -- pre-SQL2012 
BEGIN
	DECLARE @dbccloginfo TABLE (
		fileid SMALLINT
		, file_size BIGINT
		, start_offset BIGINT
		, fseqno INT
		, [status] TINYINT
		, parity TINYINT
		, create_lsn NUMERIC(25, 0)
		)

	WHILE EXISTS (
			SELECT TOP 1 dbname
			FROM @databases
			)
	BEGIN
		SET @dbname = (
				SELECT TOP 1 dbname
				FROM @databases
				)
		SET @query = 'dbcc loginfo (' + '''' + @dbname + ''') '

		INSERT INTO @dbccloginfo
		EXEC (@query)

		SET @vlfs = @@rowcount

		INSERT @vlfcounts
		VALUES (
			@dbname
			, @vlfs
			)

		DELETE
		FROM @databases
		WHERE dbname = @dbname
	END --while 
END
ELSE
BEGIN
	DECLARE @dbccloginfo2012 TABLE (
		RecoveryUnitId INT
		, fileid SMALLINT
		, file_size BIGINT
		, start_offset BIGINT
		, fseqno INT
		, [status] TINYINT
		, parity TINYINT
		, create_lsn NUMERIC(25, 0)
		)

	WHILE EXISTS (
			SELECT TOP 1 dbname
			FROM @databases
			)
	BEGIN
		SET @dbname = (
				SELECT TOP 1 dbname
				FROM @databases
				)
		SET @query = 'dbcc loginfo (' + '''' + @dbname + ''') '

		INSERT INTO @dbccloginfo2012
		EXEC (@query)

		SET @vlfs = @@rowcount

		INSERT @vlfcounts
		VALUES (
			@dbname
			, @vlfs
			)

		DELETE
		FROM @databases
		WHERE dbname = @dbname
	END --while 
END

--output the full list  
SELECT dbname
	, vlfcount
FROM @vlfcounts
ORDER BY dbname

/*
In SQL Server, Virtual Log Files (VLFs) are smaller segments within a transaction log file where log records are written¹. Having a large number of VLFs can lead to performance issues¹. Here's why it's beneficial to maintain a low number of VLFs:

1. **Efficiency**: The SQL Server Engine can process a smaller number of VLFs more efficiently, especially during crash and recovery conditions¹. 

2. **Performance**: High VLF counts can slow down database startup, restore, and backup operations¹. This is because these operations must parse through all VLFs, which takes longer when there are many VLFs¹.

3. **Transaction Log Management**: A high number of VLFs can make transaction log management more complex and can lead to increased transaction log fragmentation².

The optimal number of VLFs can vary based on your specific requirements and log size, but a general recommendation is to have between 4 and 50 VLFs, with a maximum size of 500MB². It's important to monitor and manage the number of VLFs to ensure optimal SQL Server performance¹².

Source: Conversation with Bing, 4/22/2024
(1) What are SQL Virtual Log Files aka SQL Server VLFs? - SQL Shack. https://www.sqlshack.com/what-are-sql-virtual-log-files-aka-sql-server-vlfs/.
(2) sql server - Too many VLFs - How do I truncate them? - Database .... https://dba.stackexchange.com/questions/152933/too-many-vlfs-how-do-i-truncate-them.
(3) High VLF Counts Got You Down? Here's How to Keep Them Low and .... https://www.madeiradata.com/post/high-vlf-counts-got-you-down-here-s-how-to-keep-them-low-and-performance-high.
*/