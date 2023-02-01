-- Clustered Index Checker

DECLARE @NonClusteredSeekPct FLOAT
DECLARE @ClusteredLookupFromNCPct FLOAT

-- Define percentage of usage the non clustered should 
-- receive over the clustered index
SET @NonClusteredSeekPct = 1.50 -- 150%
-- Define the percentage of all lookups on the clustered index 
-- should be executed by this non clustered index
SET @ClusteredLookupFromNCPct = .75 -- 75%

SELECT TableName = object_name(idx.object_id)
	, NonUsefulClusteredIndex = idx.NAME
	, ShouldBeClustered = nc.NonClusteredName
	, Clustered_User_Seeks = c.user_seeks
	, NonClustered_User_Seeks = nc.user_seeks
	, Clustered_User_Lookups = c.user_lookups
	, DatabaseName = db_name(c.database_id)
FROM sys.indexes idx
LEFT JOIN sys.dm_db_index_usage_stats c
	ON idx.object_id = c.object_id
		AND idx.index_id = c.index_id
--AND c.database_id = @DBID
INNER JOIN (
	SELECT idx.object_id
		, nonclusteredname = idx.NAME
		, ius.user_seeks
	FROM sys.indexes idx
	INNER JOIN sys.dm_db_index_usage_stats ius
		ON idx.object_id = ius.object_id
			AND idx.index_id = ius.index_id
	WHERE idx.type_desc = 'nonclustered'
		AND ius.user_seeks = (
			SELECT MAX(user_seeks)
			FROM sys.dm_db_index_usage_stats
			WHERE object_id = ius.object_id
				AND type_desc = 'nonclustered'
			)
	GROUP BY idx.object_id
		, idx.NAME
		, ius.user_seeks
	) nc
	ON nc.object_id = idx.object_id
WHERE idx.type_desc IN (
		'clustered'
		, 'heap'
		)
	-- non clustered user seeks outweigh clustered by 150%
	AND nc.user_seeks > (c.user_seeks * @NonClusteredSeekPct)
	-- nc index usage is primary cause of clustered lookups 80%
	AND nc.user_seeks >= (c.user_lookups * @ClusteredLookupFromNCPct)
ORDER BY nc.user_seeks DESC
