-- Check Index Differences

SELECT sch.NAME + '.' + t.NAME AS 'Table Name'
	, i.NAME AS 'Index Name'
	, i.type_desc AS 'Index Type'
	, ISNULL(user_updates, 0) AS 'Total Writes'
	, ISNULL(user_seeks + user_scans + user_lookups, 0) AS 'Total Reads'
	, s.last_user_seek AS 'Last User Seek'
	, s.last_user_scan AS 'Last User Scan'
	, s.last_user_lookup AS 'Last User Lookup'
	, ISNULL(user_updates, 0) - ISNULL((user_seeks + user_scans + user_lookups), 0) AS 'Difference'
	, p.reserved_page_count * 8.0 / 1024 AS 'Space In (mb)'
FROM sys.indexes AS i WITH (NOLOCK)
LEFT JOIN sys.dm_db_index_usage_stats AS s WITH (NOLOCK)
	ON s.object_id = i.object_id
		AND i.index_id = s.index_id
		AND s.database_id = db_id()
		AND objectproperty(s.object_id, 'IsUserTable') = 1
INNER JOIN sys.tables AS t WITH (NOLOCK)
	ON i.object_id = t.object_id
INNER JOIN sys.schemas AS sch WITH (NOLOCK)
	ON t.schema_id = sch.schema_id
LEFT JOIN sys.dm_db_partition_stats AS p WITH (NOLOCK)
	ON i.index_id = p.index_id
		AND i.object_id = p.object_id
WHERE (1 = 1)
-- AND ISNULL(user_updates,0) >= ISNULL((user_seeks + user_scans + user_lookups),0) -- shows all indexes including those that have not been used  
-- AND ISNULL(user_updates,0) - ISNULL((user_seeks + user_scans + user_lookups),0)>0 -- only shows those indexes which have been used  
-- AND i.index_id > 1			-- Only non-first indexes (I.E. non-primary key)
-- AND i.is_primary_key<>1		-- Only those that are not defined as a Primary Key)
-- AND i.is_unique_constraint<>1 -- Only those that are not classed as "UniqueConstraints".  
ORDER BY [Table Name]
	, [index name]
