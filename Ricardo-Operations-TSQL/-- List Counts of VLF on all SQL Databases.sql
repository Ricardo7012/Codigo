-- List Counts of VLF on all SQL Databases

DECLARE @query VARCHAR(100)
DECLARE @dbname SYSNAME
DECLARE @vlfs INT
DECLARE @databases TABLE (dbname SYSNAME)

INSERT INTO @databases
SELECT NAME
FROM sys.databases
WHERE STATE = 0

DECLARE @vlfcounts TABLE (
	dbname SYSNAME
	, vlfcount INT
	)
DECLARE @MajorVersion TINYINT

SET @MajorVersion = LEFT(CAST(SERVERPROPERTY('ProductVersion') AS NVARCHAR(max)), CHARINDEX('.', CAST(SERVERPROPERTY('ProductVersion') AS NVARCHAR(max))) - 1)

IF @MajorVersion < 11 -- pre-SQL2012 
BEGIN
	DECLARE @dbccloginfo TABLE (
		fileid TINYINT
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
	END
END
ELSE
BEGIN
	DECLARE @dbccloginfo2012 TABLE (
		RecoveryUnitId INT
		, fileid TINYINT
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
	END
END

SELECT dbname AS 'DB Name'
	, vlfcount AS 'VLF Count'
FROM @vlfcounts
ORDER BY vlfcount DESC
