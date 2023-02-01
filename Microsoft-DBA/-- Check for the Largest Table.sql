-- Check for the Largest Table
DECLARE @id INT
DECLARE @type CHAR(2)
DECLARE @pages INT
DECLARE @dbname SYSNAME
DECLARE @dbsize DECIMAL(15, 0)
DECLARE @bytesperpage DECIMAL(15, 0)
DECLARE @pagesperMB DECIMAL(15, 0)

CREATE TABLE #spt_space (
	objid INT NULL
	, rows INT NULL
	, reserved DECIMAL(15) NULL
	, data DECIMAL(15) NULL
	, indexp DECIMAL(15) NULL
	, unused DECIMAL(15) NULL
	)

SET NOCOUNT ON

-- Create a cursor to loop through the user tables
DECLARE c_tables CURSOR
FOR
SELECT id
FROM sysobjects
WHERE xtype = 'U'

OPEN c_tables

FETCH NEXT
FROM c_tables
INTO @id

WHILE @@fetch_status = 0
BEGIN
	/* Code from sp_spaceused */
	INSERT INTO #spt_space (
		objid
		, reserved
		)
	SELECT objid = @id
		, sum(reserved)
	FROM sysindexes
	WHERE indid IN (
			0
			, 1
			, 255
			)
		AND id = @id

	SELECT @pages = sum(dpages)
	FROM sysindexes
	WHERE indid < 2
		AND id = @id

	SELECT @pages = @pages + isnull(sum(used), 0)
	FROM sysindexes
	WHERE indid = 255
		AND id = @id

	UPDATE #spt_space
	SET data = @pages
	WHERE objid = @id

	/* index: sum(used) where indid in (0, 1, 255) - data */
	UPDATE #spt_space
	SET indexp = (
			SELECT sum(used)
			FROM sysindexes
			WHERE indid IN (
					0
					, 1
					, 255
					)
				AND id = @id
			) - data
	WHERE objid = @id

	/* unused: sum(reserved) - sum(used) where indid in (0, 1, 255) */
	UPDATE #spt_space
	SET unused = reserved - (
			SELECT sum(used)
			FROM sysindexes
			WHERE indid IN (
					0
					, 1
					, 255
					)
				AND id = @id
			)
	WHERE objid = @id

	UPDATE #spt_space
	SET rows = i.rows
	FROM sysindexes i
	WHERE i.indid < 2
		AND i.id = @id
		AND objid = @id

	FETCH NEXT
	FROM c_tables
	INTO @id
END

SELECT TOP 50 (
		SELECT left(NAME, 25)
		FROM sysobjects
		WHERE id = objid
		) AS [Table Names]
	, convert(CHAR(11), rows) AS [Rows]
	, ltrim(str(reserved * d.low / 1024., 15, 0) + ' ' + 'KB') AS [Reserved KB]
	, ltrim(str(data * d.low / 1024., 15, 0) + ' ' + 'KB') AS [Data KB]
	, ltrim(str(indexp * d.low / 1024., 15, 0) + ' ' + 'KB') AS [Index Size KB]
	, ltrim(str(unused * d.low / 1024., 15, 0) + ' ' + 'KB') AS [Unused KB]
FROM #spt_space
	, master.dbo.spt_values d
WHERE d.number = 1
	AND d.type = 'E'
ORDER BY reserved DESC

DROP TABLE #spt_space

CLOSE c_tables

DEALLOCATE c_tables
