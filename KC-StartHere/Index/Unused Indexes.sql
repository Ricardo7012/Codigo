SET NOCOUNT ON 
PRINT @@SERVERNAME
PRINT db_name() 
PRINT getdate()
go
-- https://www.mssqltips.com/sqlservertutorial/256/discovering-unused-indexes/
-- https://www.mssqltips.com/sqlservertip/1545/deeper-insight-into-used-and-unused-indexes-for-sql-server/
--This DMV allows you to see insert, update and delete information for various aspects for an index.  
--Basically this shows how much effort was used in maintaining the index based on data changes.

select object_name(A.[object_id]) as [OBJECT NAME]
     , I.[name]                   as [INDEX NAME]
     , A.leaf_insert_count
     , A.leaf_update_count
     , A.leaf_delete_count
from sys.dm_db_index_operational_stats(db_id(), null, null, null) A
    inner join sys.indexes                                        as I
        on I.[object_id] = A.[object_id]
           and I.index_id = A.index_id
where objectproperty(A.[object_id], 'ISUSERTABLE') = 1;

--WE CAN SEE THE NUMBER OF INSERTS, UPDATES AND DELETES THAT OCCURRED FOR EACH INDEX, SO THIS SHOWS HOW MUCH WORK SQL SERVER HAD TO DO TO MAINTAIN THE INDEX. 
select object_name(S.[object_id]) as [OBJECT NAME]
     , I.[name]                   as [INDEX NAME]
     , user_seeks
     , user_scans
     , user_lookups
     , user_updates
from sys.dm_db_index_usage_stats as S
    inner join sys.indexes       as I
        on I.[object_id] = S.[object_id]
           and I.index_id = S.index_id
where objectproperty(S.[object_id], 'ISUSERTABLE') = 1
      and S.database_id = db_id();

--seeks, scans, lookups and updates

--The seeks refer to how many times an index seek occurred for that index.  A seek is the fastest way to access the data, so this is good.
--The scans refers to how many times an index scan occurred for that index.  A scan is when multiple rows of data had to be searched to find the data.  Scans are something you want to try to avoid.
--The lookups refer to how many times the query required data to be pulled from the clustered index or the heap (does not have a clustered index).  Lookups are also something you want to try to avoid.
--The updates refers to how many times the index was updated due to data changes which should correspond to the first query 

--SYS.DM_DB_INDEX_USAGE_STATS output
--Identifying Unused Indexes
--So based on the output above you should focus on the output from the second query.  If you see indexes where there are no seeks, scans or lookups, 
--but there are updates this means that SQL Server has not used the index to satisfy a query but still needs to maintain the index.  Remember that the 
--data from these DMVs is reset when SQL Server is restarted, so make sure you have collected data for a long enough period of time to determine which 
--indexes may be good candidates to be dropped.


SELECT dbschemas.[name] AS [Schema],
       dbtables.[name] AS [Table],
       dbindexes.[name] AS [Index],
       dbindexes.index_id AS [indexID],
       dbindexes.type_desc AS [Type],
       indexstats.avg_fragmentation_in_percent,
       indexstats.page_count,
       8 * SUM(indexstats.page_count) AS [Indexsize(KB)],
	   8 * SUM(indexstats.page_count)/1024 AS [Indexsize(MB)]
FROM sys.dm_db_index_physical_stats(DB_ID('Member'), NULL, NULL, NULL, NULL) AS indexstats
    INNER JOIN sys.tables dbtables
        ON dbtables.[object_id] = indexstats.[object_id]
    INNER JOIN sys.schemas dbschemas
        ON dbtables.[schema_id] = dbschemas.[schema_id]
    INNER JOIN sys.indexes AS dbindexes
        ON dbindexes.[object_id] = indexstats.[object_id]
           AND indexstats.index_id = dbindexes.index_id
WHERE dbindexes.name IS NOT NULL
   --   AND indexstats.page_count > 999
	  --AND indexstats.avg_fragmentation_in_percent > 30
GROUP BY dbschemas.name,
         dbtables.name,
         dbindexes.name,
         dbindexes.index_id,
         dbindexes.type_desc,
         indexstats.avg_fragmentation_in_percent,
         indexstats.page_count
ORDER BY indexstats.avg_fragmentation_in_percent DESC;

-- Unused Index Script
-- Original Author: Pinal Dave 
select top 25
       o.name                                                                                                          as ObjectName
     , i.name                                                                                                          as IndexName
     , i.index_id                                                                                                      as IndexID
     , dm_ius.user_seeks                                                                                               as UserSeek
     , dm_ius.user_scans                                                                                               as UserScans
     , dm_ius.user_lookups                                                                                             as UserLookups
     , dm_ius.user_updates                                                                                             as UserUpdates
     , p.TableRows
     , 'DROP INDEX ' + quotename(i.name) + ' ON ' + quotename(s.name) + '.' + quotename(object_name(dm_ius.object_id)) as 'drop statement'
from sys.dm_db_index_usage_stats dm_ius
    inner join sys.indexes       i
        on i.index_id = dm_ius.index_id
           and dm_ius.object_id = i.object_id
    inner join sys.objects       o
        on dm_ius.object_id = o.object_id
    inner join sys.schemas       s
        on o.schema_id = s.schema_id
    inner join
    (
        select sum(p.rows) TableRows
             , p.index_id
             , p.object_id
        from sys.partitions p
        group by p.index_id
               , p.object_id
    )                            p
        on p.index_id = dm_ius.index_id
           and dm_ius.object_id = p.object_id
where objectproperty(dm_ius.object_id, 'IsUserTable') = 1
      and dm_ius.database_id = db_id()
      and i.type_desc = 'nonclustered'
      and i.is_primary_key = 0
      and i.is_unique_constraint = 0
order by (dm_ius.user_seeks + dm_ius.user_scans + dm_ius.user_lookups) asc;
go