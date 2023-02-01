--BACKUP DATABASE [HSP]
--TO  DISK = N'\\dtsqlbkups\qvsqllit01backups\NonProduction\HSP2S1A\HSP_Indexes.bak'
--WITH NOFORMAT
--   , INIT
--   , NAME = N'HSP-Full Database Backup'
--   , SKIP
--   , NOREWIND
--   , NOUNLOAD
--   , COMPRESSION
--   , STATS = 10;
--GO

USE HSP;
SET NOCOUNT ON;
/*DROP ALL INDEXES*/
/***************************************************************************************************
CHECK BEFORE
***************************************************************************************************/
SELECT sysindexes.[name] AS [Index]
     , sysobjects.[name] AS [Table]
FROM sysindexes
    INNER JOIN sysobjects
        ON sysindexes.[id] = sysobjects.[id]
WHERE sysindexes.[name] IS NOT NULL
      AND sysobjects.[type] = 'U'
      AND sysindexes.[indid] > 1
      AND sysindexes.[name] NOT LIKE '_WA%'
	  AND sysindexes.[name] NOT LIKE 'PK_%'
	  AND sysindexes.[name] NOT LIKE 'UQ_%';


/***************************************************************************************************
DELETE EM
***************************************************************************************************/
USE HSP;
GO
SET NOCOUNT ON;

/***************************************************************************************************
DELETE EM
 https://docs.microsoft.com/en-us/sql/relational-databases/system-compatibility-views/sys-sysindexes-transact-sql?view=sql-server-2017 
 https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-objects-transact-sql?view=sql-server-2017
***************************************************************************************************/

DECLARE @indexName VARCHAR(128);
DECLARE @tableName VARCHAR(128);

DECLARE [indexes] CURSOR FOR
SELECT sysindexes.[name] AS [Index]
     , sysobjects.[name] AS [Table]
FROM sysindexes
    INNER JOIN sysobjects
        ON sysindexes.[id] = sysobjects.[id]
WHERE sysindexes.[name] IS NOT NULL
      AND sysobjects.[type] = 'U'
      AND sysindexes.[indid] > 1
      AND sysindexes.[name] NOT LIKE '_WA%'
	  AND sysindexes.[name] NOT LIKE 'PK_%'
	  AND sysindexes.[name] NOT LIKE 'UQ_%';

OPEN [indexes];

FETCH NEXT FROM [indexes]
INTO @indexName
   , @tableName;

WHILE @@Fetch_Status = 0
    BEGIN
        PRINT 'DROP INDEX [' + @indexName + '] ON [' + @tableName + ']';
        EXEC ('DROP INDEX [' + @indexName + '] ON [' + @tableName + ']');

        FETCH NEXT FROM [indexes]
        INTO @indexName
           , @tableName;
    END;

CLOSE [indexes];
DEALLOCATE [indexes];

GO

/***************************************************************************************************
CHECK AFTER
***************************************************************************************************/
SELECT name            AS INDEXNAME
     , OBJECT_NAME(id) AS TABLENAME
     , ix.rowcnt       AS [ROWCNT]
FROM sysindexes ix
WHERE ix.name IS NOT NULL
      AND ix.name NOT LIKE 'PK%'
      AND ix.name NOT LIKE '_WA%'
      AND OBJECT_NAME(id) NOT LIKE 'sys%'
ORDER BY OBJECT_NAME(ix.id) ASC;
