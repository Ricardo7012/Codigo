-- List SQL DB Information

DECLARE @sql NVARCHAR(4000)

CREATE TABLE #HelpDB (
	NAME SYSNAME
	, DB_Size NVARCHAR(13)
	, OWNER SYSNAME
	, DBID SMALLINT
	, Created NVARCHAR(11)
	, STATUS NVARCHAR(600)
	, Compatibility TINYINT
	)

SET @sql = 'EXEC ' + 'SP_HelpDB'

INSERT INTO #HelpDB (
	NAME
	, db_size
	, OWNER
	, dbid
	, created
	, STATUS
	, compatibility
	)
EXEC sp_executesql @sql

SELECT #HelpDB.NAME AS 'DB Name'
	, #HelpDB.DB_Size AS 'DB Size'
	, #HelpDB.OWNER AS 'Owner'
	, #HelpDB.DBID  AS 'DB Id'
	, #HelpDB.Created AS 'DB Create Date'
	, #HelpDB.Compatibility AS 'DB Compatibility'
FROM #HelpDB

DROP TABLE #HelpDB
