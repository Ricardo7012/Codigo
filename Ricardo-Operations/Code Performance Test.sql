-- Code Performance Test
SET STATISTICS TIME ON
SET STATISTICS IO ON 
CHECKPOINT --TO CLEAN DIRTY PAGES
--DBCC FREEPROCCACHE -- IN TEST ENVIRONMENT ONLY | FLUSHPROCINDB(DBID) | FREESYSTEMCACHE
--DBCC DROPCLEANBUFFERS --**DO NOT DO THIS IS PRODUCTION!! **
USE HSP_MO
GO
SELECT  OBJECT_NAME(object_id) AS OBJECTID
       ,index_id
       ,index_type_desc
       ,index_level
       ,avg_fragmentation_in_percent
       ,avg_page_space_used_in_percent
       ,page_count
FROM    sys.dm_db_index_physical_stats(DB_ID(N'HSP_MO'), NULL, NULL, NULL,'SAMPLED')
WHERE   page_count > 999 
	AND avg_fragmentation_in_percent > 30 
ORDER BY avg_fragmentation_in_percent DESC;

SET STATISTICS IO OFF 
SET STATISTICS TIME OFF
