--https://potomac9499.wordpress.com/2007/12/31/cleaning-up-tempdb/
-- CLEANING UP TEMPDB
IF EXISTS
(
    SELECT *
    FROM dbo.sysobjects
    WHERE id = OBJECT_ID(N'[dbo].[TempTableToKeep]')
          AND OBJECTPROPERTY(id, N'IsUserTable') = 1
)
    DROP TABLE [dbo].[TempTableToKeep];
GO
CREATE TABLE [dbo].[TempTableToKeep]
(
    [TempTable] [VARCHAR](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [DateToDelete] [DATETIME] NOT NULL
) ON [PRIMARY];
GO

IF EXISTS
(
    SELECT name
    FROM sysobjects
    WHERE name = N'sp_DropTempTables'
          AND type = 'P'
)
    DROP PROCEDURE sp_DropTempTables;
GO
CREATE PROCEDURE sp_DropTempTables
AS
DECLARE @Cursor AS CURSOR;
DECLARE @Name AS VARCHAR(100);
DECLARE @TableName AS sysname;
DECLARE @Owner AS VARCHAR(100);
DECLARE @SQL AS NVARCHAR(200);
SET @Cursor = CURSOR SCROLL FOR
SELECT tempdb.dbo.sysobjects.name,
       tempdb.dbo.sysobjects.*
FROM TempTableToKeep
    RIGHT OUTER JOIN tempdb.dbo.sysobjects
        ON TempTableToKeep.TempTable = tempdb.dbo.sysobjects.name
WHERE (
          (tempdb.dbo.sysobjects.crdate < DATEADD(hh, -12, GETDATE()))
          AND (tempdb.dbo.sysobjects.type = 'U')
          AND (TempTableToKeep.DateToDelete < GETDATE())
      )
      OR
      (
          (tempdb.dbo.sysobjects.crdate < DATEADD(hh, -12, GETDATE()))
          AND (tempdb.dbo.sysobjects.type = 'U')
          AND (TempTableToKeep.DateToDelete IS NULL)
      );
OPEN @Cursor;
FETCH FIRST FROM @Cursor
INTO @Name,
     @Owner;
WHILE (@@FETCH_STATUS = 0)
BEGIN
    IF (@@FETCH_STATUS = 0)
    BEGIN
        IF EXISTS
        (
            SELECT name
            FROM tempdb..sysobjects
            WHERE name = @Name
                  AND type = 'U'
        )
        BEGIN
            SET @SQL = 'DROP TABLE tempdb..' + @Name;
            PRINT @SQL;
            EXECUTE sp_executesql @SQL;
        END;
        FETCH NEXT FROM @Cursor
        INTO @Name;
    END;
END;
CLOSE @Cursor;
DEALLOCATE @Cursor;
GO

--https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-objects-transact-sql
SELECT name, type
FROM tempdb..sysobjects

--*******************************************************

--*******************************************************
DECLARE @table_counter_before_test BIGINT
SELECT @table_counter_before_test = cntr_value
FROM sys.dm_os_performance_counters
WHERE counter_name = 'Temp Tables Creation Rate'
PRINT @table_counter_before_test

DECLARE @i INT;
SELECT @i = 0;
WHILE (@i < 10)
BEGIN
    -- <execute your stored procedure>
    SELECT @i = @i + 1;
END;

DECLARE @table_counter_after_test BIGINT;
SELECT @table_counter_after_test = cntr_value
FROM sys.dm_os_performance_counters
WHERE counter_name = 'Temp Tables Creation Rate';

PRINT 'Temp tables created during the test: '
      + CONVERT(VARCHAR(100), @table_counter_after_test - @table_counter_before_test);

