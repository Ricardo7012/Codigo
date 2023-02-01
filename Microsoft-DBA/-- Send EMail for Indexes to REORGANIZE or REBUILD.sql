-- Send EMail for Indexes to REORGANIZE or REBUILD

/*
===========================================================
   Script: Server Fragmented Index Report
Sys Configs: Database Mail required
Description: Iterates through SQL Server collecting
    all database fragmentation using parameters
    of total page count and percent fragmented.
    Report is able to be emailed out from sql
    server database mail. Email variables will
    need to be updated per use. Rebuild or
    Reorganize logic built in with parameters
    that can be changed based on individual
    implementation. CSS is HTML email is inline
    due to Gmail issues with CSS.

Tested On: Sql Server 2008R2, 2012

===========================================================
*/
--=========================================================
-- Declare variables
--=========================================================
DECLARE @DB INT
	, @DB_name NVARCHAR(200)
	, @PageCntMin INT
	, @FragMin FLOAT
	, @Loop INT
	, @Count INT
	, @ReportServer NVARCHAR(200)

SET @PageCntMin = 5
SET @FragMin = 10
SET @reportServer = (
		SELECT @@SERVERNAME
		) + ' Index Report';

--=========================================================
-- Verify temp tables have not been created
--=========================================================
IF Object_id('tempdb..#TempIndex') IS NOT NULL
BEGIN
	DROP TABLE #tempindex;
END

IF Object_id('tempdb..#TDb') IS NOT NULL
BEGIN
	DROP TABLE #tdb;
END

--=========================================================
-- Create Tables
--=========================================================
BEGIN
	CREATE TABLE #tempindex (
		dbname NVARCHAR(300) NULL
		, [databaseid] INT NULL
		, [tablename] [SYSNAME] NOT NULL
		, [schemaname] NVARCHAR(200) NULL
		, [indexname] SYSNAME NULL
		, [percentfragmented] [FLOAT] NULL
		, [pagecount] [BIGINT] NULL
		, [maintenance] NVARCHAR(100) NULL
		);

	CREATE TABLE #tdb (
		id INT IDENTITY(1, 1) NOT NULL
		, databaseid INT NULL
		);
END

--=========================================================
-- Load Tables
--=========================================================
BEGIN
	INSERT INTO #tdb (databaseid)
	SELECT dbid
	FROM master..sysdatabases
END

--=========================================================
-- Set Loop Count
--=========================================================
SET @Count = (
		SELECT Count(databaseid)
		FROM #tdb
		)
SET @Loop = 1

--========================================================
--Begin Loop Execution
--========================================================
WHILE (@Loop <= @Count)
BEGIN
	SET @DB = (
			SELECT databaseid
			FROM #tdb
			WHERE id = @Loop
			)
	SET @DB_name = (
			SELECT NAME
			FROM master..sysdatabases
			WHERE dbid = @DB
			)

	DECLARE @sql NVARCHAR(max)
	DECLARE @UseDB NVARCHAR(max)

	SET @sql = N' INSERT INTO #TempIndex' + N'(DbName,DatabaseID, TableName, SchemaName, IndexName, ' + N'PercentFragmented,PageCount)' + N'SELECT ' + N'db_name(), DB_ID(), ' + N't.name, sc.name, i.name, ' + N'x.avg_fragmentation_in_percent, ' + N'x.page_count ' + N' FROM sys.dm_db_index_physical_stats (CONVERT(INT,' + CONVERT(NVARCHAR(5), @DB) + '), NULL, NULL , NULL, NULL) x ' + N' INNER JOIN [' + @DB_name + '].sys.tables t' + N' ON t.object_id = x.object_id' + N' INNER JOIN [' + @DB_name + '].sys.indexes i' + N' ON x.object_id = i.object_id AND x.index_id = i.index_id' + N' INNER JOIN [' + @DB_name + '].sys.schemas sc ON t.schema_id = sc.schema_id' + N' WHERE avg_fragmentation_in_percent > CONVERT(FLOAT,' + CONVERT(NVARCHAR(3), @FragMin) + ') ' + N' AND x.index_id > 0 ' + N' AND page_count > CONVERT(INT,' + CONVERT(NVARCHAR(3), @PageCntMin) + ') ' + N' AND alloc_unit_type_desc = ''''IN_ROW_DATA''''' + N' ORDER BY page_count DESC;'
	SET @UseDB = N'USE [' + @Db_Name + ']; EXEC sp_executesql N''' + @sql + '''';

	EXEC (@UseDB)

	SET @Loop = @Loop + 1
END --end loop

--========================================================
-- Update temp table with rebuild or reorganize logic
--========================================================
BEGIN
	UPDATE #tempindex
	SET maintenance = (
			CASE 
				WHEN percentfragmented >= 30
					THEN 'REBUILD'
				WHEN percentfragmented >= 10
					AND percentfragmented < 30
					THEN 'REORGANIZE'
				ELSE 'NA'
				END
			);
END

--========================================================
-- Create HTML report for email
--========================================================
DECLARE @tableHTML NVARCHAR(max)

BEGIN
	SET @tableHTML = N'<html><body>' + N'<fieldset><legend>Fragmented Index Report</legend>' + N'<h4 style="margin:0;">SQ03: Index Fragmentation Report</h4>' + N'<table style="width:450px;border:1px solid #000000;height:100%;margin:0px;padding:0px;">' + N'<tr style="background-color:#4c4c4c;color:#ffffff;font-size:14px;text-align:center;border:1px solid #000000;">' + N'<td>Database</td><td>PercentFragmented</td><td>Recommend Maintenance</td></tr>' + (
			SELECT Row_number() OVER (
					ORDER BY dbname
					) % 2 AS [TRRow]
				, dbname + '.' + schemaname + '.' + tablename AS [TD align=left]
				, CONVERT(DECIMAL(5, 2), percentfragmented) AS [TD align=center]
				, maintenance AS [TD align=center]
			FROM #tempindex
			ORDER BY dbname ASC
			FOR XML raw('tr')
				, elements
			) + N'</table></fieldset></body></html>'
	SET @tableHTML = Replace(@tableHTML, '_x0020_', Space(1))
	SET @tableHTML = Replace(@tableHTML, '_x003D_', '=')
	SET @tableHTML = Replace(@tableHTML, '<tr><TRRow>1</TRRow>', '<tr style="background-color:white;font-size:10px;">')
	SET @tableHTML = Replace(@tableHTML, '<TRRow>0</TRRow>', '<tr style="background-color:#e5e5e5;font-size:10px;">')
END

--========================================================
-- Set database mail variables and send email
--========================================================
BEGIN
	EXEC msdb.dbo.Sp_send_dbmail @profile_name = 'IGT Alert Profile'
		, @subject = @reportServer
		, @from_address = 'SQLAlert@test.com'
		, @recipients = 'test@test.com'
		, @body = @tableHTML
		, @body_format = 'HTML'
END

--========================================================
-- Clean up
--========================================================
BEGIN
	DROP TABLE #tdb;

	DROP TABLE #tempindex;
END
