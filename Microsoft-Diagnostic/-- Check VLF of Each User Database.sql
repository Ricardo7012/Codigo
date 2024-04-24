-- Check VLF of Each User Database

CREATE TABLE #VLF_temp (
	FileID VARCHAR(3)
	, FileSize NUMERIC(20, 0)
	, StartOffset BIGINT
	, FSeqNo BIGINT
	, [STATUS] CHAR(1)
	, Parity VARCHAR(4)
	, CreateLSN NUMERIC(25, 0)
	)

CREATE TABLE #VLF_db_total_temp (
	NAME SYSNAME
	, vlf_count INT
	)

/*Declare a cursor to loop through all current databases*/
DECLARE db_cursor CURSOR READ_ONLY
FOR
SELECT NAME
FROM master.dbo.sysdatabases

DECLARE @name SYSNAME
	, @stmt VARCHAR(40)

OPEN db_cursor

FETCH NEXT
FROM db_cursor
INTO @name

WHILE (@@fetch_status <> - 1)
BEGIN
	IF (@@fetch_status <> - 2)
	BEGIN
		/*insert the results into the first temp table*/
		INSERT INTO #VLF_temp
		EXEC ('DBCC LOGINFO ([' + @name + ']) WITH NO_INFOMSGS')

		/*insert the db name and count into the second temp table*/
		INSERT INTO #VLF_db_total_temp
		SELECT @name
			, COUNT(*)
		FROM #VLF_temp

		/*truncate the first table so we can get the count for the next db*/
		TRUNCATE TABLE #VLF_temp
	END

	FETCH NEXT
	FROM db_cursor
	INTO @name
END

/*close and deallocate cursor*/
CLOSE db_cursor

DEALLOCATE db_cursor

/*we are only interested in the top ten rows because having more could look funky in an Excel graph*/
/*we are currently only interested in db's with more than 50 VLFs*/
SELECT TOP 10 @@servername AS 'Server Name'
	, [NAME] AS 'DB Name'
	, vlf_count AS 'VLF Count'
FROM #VLF_db_total_temp
WHERE vlf_count > 50
ORDER BY vlf_count DESC

--/*drop the tables*/
DROP TABLE [#VLF_temp]
DROP TABLE [#VLF_db_total_temp]
