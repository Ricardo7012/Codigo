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
