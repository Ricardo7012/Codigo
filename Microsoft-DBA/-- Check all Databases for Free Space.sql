-- Check all Databases for Free Space

-- Data File Size

IF EXISTS (
		SELECT *
		FROM tempdb.sys.all_objects
		WHERE NAME LIKE '%#dbsize%'
		)
	DROP TABLE #dbsize

CREATE TABLE #dbsize (
	Dbname SYSNAME
	, dbstatus VARCHAR(50)
	, Recovery_Model VARCHAR(40) DEFAULT('NA')
	, file_Size_MB DECIMAL(30, 2) DEFAULT(0)
	, Space_Used_MB DECIMAL(30, 2) DEFAULT(0)
	, Free_Space_MB DECIMAL(30, 2) DEFAULT(0)
	)
GO

INSERT INTO #dbsize (
	Dbname
	, dbstatus
	, Recovery_Model
	, file_Size_MB
	, Space_Used_MB
	, Free_Space_MB
	)
EXEC sp_msforeachdb 'use [?]; 
  select DB_NAME() AS DbName, 
    CONVERT(varchar(20),DatabasePropertyEx(''?'',''Status'')) ,  
    CONVERT(varchar(20),DatabasePropertyEx(''?'',''Recovery'')),  
sum(size)/128.0 AS File_Size_MB, 
sum(CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT))/128.0 as Space_Used_MB, 
SUM( size)/128.0 - sum(CAST(FILEPROPERTY(name,''SpaceUsed'') AS INT))/128.0 AS Free_Space_MB  
from sys.database_files  where type=0 group by type'
GO

-- Log Size

IF EXISTS (
		SELECT *
		FROM tempdb.sys.all_objects
		WHERE NAME LIKE '#logsize%'
		)
	DROP TABLE #logsize

CREATE TABLE #logsize (
	Dbname SYSNAME
	, Log_File_Size_MB DECIMAL(38, 2) DEFAULT(0)
	, log_Space_Used_MB DECIMAL(30, 2) DEFAULT(0)
	, log_Free_Space_MB DECIMAL(30, 2) DEFAULT(0)
	)
GO

INSERT INTO #logsize (
	Dbname
	, Log_File_Size_MB
	, log_Space_Used_MB
	, log_Free_Space_MB
	)
EXEC sp_msforeachdb 'use [?]; 
  select DB_NAME() AS DbName, 
sum(size)/128.0 AS Log_File_Size_MB, 
sum(CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT))/128.0 as log_Space_Used_MB, 
SUM( size)/128.0 - sum(CAST(FILEPROPERTY(name,''SpaceUsed'') AS INT))/128.0 AS log_Free_Space_MB  
from sys.database_files  where type=1 group by type'
GO

-- Database Free Size

IF EXISTS (
		SELECT *
		FROM tempdb.sys.all_objects
		WHERE NAME LIKE '%#dbfreesize%'
		)
	DROP TABLE #dbfreesize

CREATE TABLE #dbfreesize (
	NAME SYSNAME
	, database_size VARCHAR(50)
	, Freespace VARCHAR(50) DEFAULT(0.00)
	)

INSERT INTO #dbfreesize (
	NAME
	, database_size
	, Freespace
	)
EXEC sp_msforeachdb 
	'USE [?];

SELECT database_name = db_name()
	, database_size = ltrim(str((convert(DECIMAL(15, 2), dbsize) + convert(DECIMAL(15, 2), logsize)) * 8192 / 1048576, 15, 2) + '' MB '')
	, '' unallocated space '' = ltrim(str((
				CASE 
					WHEN dbsize >= reservedpages
						THEN (convert(DECIMAL(15, 2), dbsize) - convert(DECIMAL(15, 2), reservedpages)) * 8192 / 1048576
					ELSE 0
					END
				), 15, 2) + '' MB '')
FROM (
	SELECT dbsize = sum(convert(BIGINT, CASE 
					WHEN type = 0
						THEN size
					ELSE 0
					END))
		, logsize = sum(convert(BIGINT, CASE 
					WHEN type <> 0
						THEN size
					ELSE 0
					END))
	FROM sys.database_files
	) AS files
	, (
		SELECT reservedpages = sum(a.total_pages)
			, usedpages = sum(a.used_pages)
			, pages = sum(CASE 
					WHEN it.internal_type IN (
							202
							, 204
							, 211
							, 212
							, 213
							, 214
							, 215
							, 216
							)
						THEN 0
					WHEN a.type <> 1
						THEN a.used_pages
					WHEN p.index_id < 2
						THEN a.data_pages
					ELSE 0
					END)
		FROM sys.partitions p
		INNER JOIN sys.allocation_units a
			ON p.partition_id = a.container_id
		LEFT JOIN sys.internal_tables it
			ON p.object_id = it.object_id
		) AS partitions
'

IF EXISTS (
		SELECT *
		FROM tempdb.sys.all_objects
		WHERE NAME LIKE '%#alldbstate%'
		)
	DROP TABLE #alldbstate

CREATE TABLE #alldbstate (
	dbname SYSNAME
	, DBstatus VARCHAR(55)
	, R_model VARCHAR(30)
	)

INSERT INTO #alldbstate (
	dbname
	, DBstatus
	, R_model
	)
SELECT NAME
	, CONVERT(VARCHAR(20), DATABASEPROPERTYEX(NAME, 'status'))
	, recovery_model_desc
FROM sys.databases

INSERT INTO #dbsize (
	Dbname
	, dbstatus
	, Recovery_Model
	)
SELECT dbname
	, dbstatus
	, R_model
FROM #alldbstate
WHERE DBstatus <> 'online'

INSERT INTO #logsize (Dbname)
SELECT dbname
FROM #alldbstate
WHERE DBstatus <> 'online'

INSERT INTO #dbfreesize (NAME)
SELECT dbname
FROM #alldbstate
WHERE DBstatus <> 'online'

SELECT d.Dbname
	, d.dbstatus AS 'Status'
	, d.Recovery_Model AS 'Recovery Model'
	, (file_size_mb + log_file_size_mb) AS 'DB Size'
	, fs.Freespace AS 'DB Free Space'
	, '-' AS '- -'
	, d.file_Size_MB AS 'Data File (MB)'
	, d.Space_Used_MB AS 'Data Space Used (MB)'
	, d.Free_Space_MB AS 'Data Space Free (MB)'
	, '-' AS '- -'
	, l.Log_File_Size_MB AS 'Log File (MB)'
	, log_Space_Used_MB AS 'Log Space Used (MB)'
	, l.log_Free_Space_MB AS 'Log Space Free (MB)'
FROM #dbsize d
INNER JOIN #logsize l
	ON d.Dbname = l.Dbname
INNER JOIN #dbfreesize fs
	ON d.Dbname = fs.NAME
ORDER BY Dbname
