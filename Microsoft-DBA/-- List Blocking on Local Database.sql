-- List Blocking on Local Database

-- Some common lock types are:

--	RID – Single Row Lock
--  KEY – Range of Keys in an index
--	PAG – Data or Index page lock
--  EXT – Extent Lock
--  TAB – Table Lock
--  DB  – Database Lock

-- In addition to lock types that refer to resources or objects 
-- that can be locked, SQL Server has common lock modes:

--  S   – Shared lock
--  U   – Update Lock
--  X   – Exclusive lock
--  IS  – Intent shared
--  IU  – Intent Update
--  IX  – Intent Exclusive
--  BU  – Bulk update


SET NOCOUNT ON
GO

-- Count the locks
IF EXISTS (
		SELECT NAME
		FROM tempdb..sysobjects
		WHERE NAME LIKE '#Hold_sp_lock%'
		)
	--If So Drop it
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

SELECT COUNT(spid) AS 'Lock Count'
	, SPID
	, Type AS 'Type'
	, Cast(DB_NAME(DBID) AS VARCHAR(30)) AS 'DB Name'
	, Mode
FROM #Hold_sp_lock
GROUP BY SPID
	, Type
	, DB_NAME(DBID)
	, MODE
ORDER BY 'Lock Count' DESC
	, 'DB Name'
	, SPID
	, Mode

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
