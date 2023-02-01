-- List Out Tables that Need FullScan

DECLARE @nID INT
DECLARE @vCommand VARCHAR(2048)

CREATE TABLE #Stats (
	ID INT IDENTITY(1, 1)
	, Command VARCHAR(2048)
	)

INSERT INTO #Stats (Command)
SELECT 'UPDATE STATISTICS ' + schema_name(c.schema_id) + '.' + c.NAME + ' ' + isnull(b.NAME, '') + ' WITH FULLSCAN'
FROM sysindexes b(NOLOCK)
INNER JOIN sys.objects AS c(NOLOCK)
	ON (b.id = c.object_id)
INNER JOIN sys.stats AS s(NOLOCK)
	ON (b.NAME = s.NAME)
WHERE OBJECTPROPERTY(c.object_id, N'IsUserTable') = 1
	AND c.NAME IN ('< Add Tables to Update Stats>')
ORDER BY c.NAME
	, b.NAME
	, b.RowModCtr DESC

SELECT @nID = MIN(ID)
FROM #Stats

WHILE @nID IS NOT NULL
BEGIN
	SELECT @vCommand = Command
	FROM #Stats
	WHERE ID = @nID

	PRINT @vCommand

	SELECT @nID = MIN(ID)
	FROM #Stats
	WHERE ID > @nID
END

DROP TABLE #Stats