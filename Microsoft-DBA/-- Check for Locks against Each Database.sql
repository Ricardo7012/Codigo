-- Check for Locks against Each Database

-- Count the locks
IF EXISTS (
		SELECT NAME
		FROM tempdb..sysobjects
		WHERE NAME LIKE '#Hold_sp_lock%'
		)
	DROP TABLE #Hold_sp_lock
GO

CREATE TABLE #Hold_sp_lock (
	spid INT
	, dbid INT
	, ObjId INT
	, IndId SMALLINT
	, Type VARCHAR(20)
	, Resource VARCHAR(50)
	, Mode VARCHAR(20)
	, STATUS VARCHAR(20)
	)

INSERT INTO #Hold_sp_lock
EXEC sp_lock

SELECT Cast(DB_NAME(DBID) AS VARCHAR(30)) AS 'DB Name'
	, SPID AS 'SPID'
	, COUNT(spid) AS 'Lock Count'
	, Type AS 'Lock Type'
	, mode AS 'Mode'
FROM #Hold_sp_lock
GROUP BY SPID
	, Type
	, DB_NAME(DBID)
	, MODE
ORDER BY 'Lock Count' DESC
	, 'DB Name'
	, 'SPID'
	, 'Mode'

--Show any blocked or blocking processes
IF EXISTS (
		SELECT NAME
		FROM tempdb..sysobjects
		WHERE NAME LIKE '#Catch_SPID%'
		)
	--If So Drop it
	DROP TABLE #Catch_SPID
GO

CREATE TABLE #Catch_SPID (
	bSPID INT
	, BLK_Status CHAR(10)
	)
GO

INSERT INTO #Catch_SPID
SELECT DISTINCT SPID
	, 'BLOCKED'
FROM master..sysprocesses
WHERE blocked <> 0

UNION

SELECT DISTINCT blocked
	, 'BLOCKING'
FROM master..sysprocesses
WHERE blocked <> 0

DECLARE @tSPID INT
DECLARE @blkst CHAR(10)

SELECT TOP 1 @tSPID = bSPID
	, @blkst = BLK_Status
FROM #Catch_SPID

WHILE (@@ROWCOUNT > 0)
BEGIN
	PRINT 'DBCC Results for SPID ' + Cast(@tSPID AS VARCHAR(5)) + '( ' + rtrim(@blkst) + ' )'
	PRINT '-----------------------------------'
	PRINT ''

	DBCC INPUTBUFFER (@tSPID)

	SELECT TOP 1 @tSPID = bSPID
		, @blkst = BLK_Status
	FROM #Catch_SPID
	WHERE bSPID > @tSPID
	ORDER BY bSPID
END
