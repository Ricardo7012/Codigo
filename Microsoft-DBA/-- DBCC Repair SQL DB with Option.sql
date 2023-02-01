-- DBCC Repair SQL DB with Option

USE [master]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[isp_RepairDB] @SearchDBName SYSNAME
	, @DBCCOption SYSNAME
AS
BEGIN
	DECLARE @SPID INT
		, @DBName NVARCHAR(255)

	CREATE TABLE #SPIDS (
		SPID INT
		, ecid INT
		, STATUS VARCHAR(255)
		, loginame VARCHAR(255)
		, hostname VARCHAR(255)
		, blk INT
		, dbname NVARCHAR(255)
		, cmd VARCHAR(255)
		, request_id INT
		)

	INSERT INTO #SPIDS
	EXEC ('sp_who')

	PRINT 'Killing Connections'

	DECLARE curWho CURSOR
	FOR
	SELECT dbname
		, spid
	FROM #SPIDS

	OPEN curWho

	FETCH NEXT
	FROM curWho
	INTO @DBName
		, @SPID

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @DBName = cast(@SearchDBName AS VARCHAR(255))
		BEGIN
			DECLARE @SQL VARCHAR(255)

			SET @SQL = 'Kill ' + cast(@SPID AS VARCHAR(5)) + ''

			PRINT @SQL
			PRINT @SearchDBName

			EXEC (@SQL)
		END

		FETCH NEXT
		FROM curWho
		INTO @DBName
			, @SPID
	END

	CLOSE curWho

	DEALLOCATE curWho

	DROP TABLE #SPIDS

	PRINT 'Connections Dead'

	EXEC sp_dboption @dbname = @SearchDBName
		, @optname = 'single user'
		, @optvalue = 'true'

	PRINT 'SINGLE USER MODE SET'

	DECLARE @DBCCSQL AS VARCHAR(255)

	SET @DBCCSQL = 'DBCC CHECKDB(' + @SearchDBName + ',' + @DBCCOption + ')'

	PRINT @DBCCSQL

	EXEC (@DBCCSQL)

	EXEC sp_dboption @dbname = @SearchDBName
		, @optname = 'single user'
		, @optvalue = 'false'

	PRINT 'SINGLE USER MODE UNSET'
END

GO