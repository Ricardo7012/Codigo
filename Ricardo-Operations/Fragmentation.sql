SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
--USE HSP_IT_SB4
--GO
--SELECT  OBJECT_NAME(object_id) AS OBJECTID
--       ,index_id
--       ,index_type_desc
--       ,index_level
--       ,avg_fragmentation_in_percent
--       ,avg_page_space_used_in_percent
--       ,page_count
--FROM    sys.dm_db_index_physical_stats(DB_ID(N'HSP_IT_SB4'), NULL, NULL, NULL,'SAMPLED')
--WHERE   page_count > 999 
--	AND avg_fragmentation_in_percent > 30 
--ORDER BY avg_fragmentation_in_percent DESC;
--PRINT GETDATE()
--:CONNECT DVSQLEM
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
SET STATISTICS TIME, IO ON;
GO
use gbdrepo
go
SELECT dbtables.[name]                       AS [Table]
     , dbschemas.[name]                      AS [Schema]
     , dbindexes.[name]                      AS [Index]
     , dbindexes.index_id                    AS [indexID]
     , dbindexes.type_desc                   AS [Type]
     , indexstats.avg_fragmentation_in_percent
     , indexstats.page_count
     , 8 * SUM(indexstats.page_count)        AS [Indexsize(KB)]
     , 8 * SUM(indexstats.page_count) / 1024 AS [Indexsize(MB)]
FROM sys.dm_db_index_physical_stats(DB_ID('gbdrepo'), NULL, NULL, NULL, NULL) AS indexstats
    INNER JOIN sys.tables                                                 dbtables
        ON dbtables.[object_id] = indexstats.[object_id]
    INNER JOIN sys.schemas                                                dbschemas
        ON dbtables.[schema_id] = dbschemas.[schema_id]
    INNER JOIN sys.indexes                                                AS dbindexes
        ON dbindexes.[object_id] = indexstats.[object_id]
           AND indexstats.index_id = dbindexes.index_id
WHERE dbindexes.name IS NOT NULL
      AND indexstats.page_count > 999
      AND indexstats.avg_fragmentation_in_percent > 30
GROUP BY dbschemas.name
       , dbtables.name
       , dbindexes.name
       , dbindexes.index_id
       , dbindexes.type_desc
       , indexstats.avg_fragmentation_in_percent
       , indexstats.page_count
ORDER BY indexstats.avg_fragmentation_in_percent DESC;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
SET STATISTICS TIME, IO ON;
GO
use gbdrepo
go
SELECT OBJECT_NAME(object_id)
     , index_id
     , index_type_desc
     , index_level
     , avg_fragmentation_in_percent
     , avg_page_space_used_in_percent
     , page_count
FROM sys.dm_db_index_physical_stats(DB_ID(N'gbdrepo'), NULL, NULL, NULL, NULL) -- SEE ALL
--WHERE page_count > 999
--AND avg_fragmentation_in_percent > 30 
ORDER BY avg_fragmentation_in_percent DESC;
GO

SELECT dbschemas.[name] AS 'Schema'
     , dbtables.[name]  AS 'Table'
     , dbindexes.[name] AS 'Index'
     , indexstats.index_type_desc
     , indexstats.alloc_unit_type_desc
     , indexstats.avg_fragmentation_in_percent
     , indexstats.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) AS indexstats
    INNER JOIN sys.tables                                            dbtables
        ON dbtables.[object_id] = indexstats.[object_id]
    INNER JOIN sys.schemas                                           dbschemas
        ON dbtables.[schema_id] = dbschemas.[schema_id]
    INNER JOIN sys.indexes                                           AS dbindexes
        ON dbindexes.[object_id] = indexstats.[object_id]
           AND indexstats.index_id = dbindexes.index_id
WHERE indexstats.database_id = DB_ID()
--      AND indexstats.page_count > 1000
--AND indexstats.avg_fragmentation_in_percent > 30
--AND indexstats.index_type_desc <> 'HEAP'
ORDER BY indexstats.avg_fragmentation_in_percent DESC;
GO
/********************************************************************
	SIZES
********************************************************************/
USE HSP;
GO
SELECT tn.[name]                     AS [Table name]
     , ix.[name]                     AS [Index name]
     , SUM(sz.[used_page_count]) * 8 AS [Index size (KB)]
FROM sys.dm_db_partition_stats AS sz
    INNER JOIN sys.indexes     AS ix
        ON sz.[object_id] = ix.[object_id]
           AND sz.[index_id] = ix.[index_id]
    INNER JOIN sys.tables      tn
        ON tn.object_id = ix.object_id
GROUP BY tn.[name]
       , ix.[name]
ORDER BY [Index size (KB)] DESC;
