-- List Frag % on Index

SELECT d.NAME AS 'Database Name'
	, d.database_id AS 'Database ID'
	, t.NAME AS 'Table Name'
	, ddips.index_type_desc AS 'Index Type'
	, i.NAME AS 'Index Name'
	, ddips.alloc_unit_type_desc AS 'Alloc Unit'
	, '--' AS '--'
	, ROUND(ddips.avg_fragmentation_in_percent, 2) AS 'Avg Frag %'
	, ddips.page_count AS 'Page Count'
	, ddips.fragment_count AS 'Frag Count'
	, ROUND(ddips.avg_fragment_size_in_pages, 2) AS 'Frag Size in Pages'
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'SAMPLED') ddips
INNER JOIN sys.indexes i
	ON ddips.object_id = i.object_id
		AND ddips.index_id = i.index_id
INNER JOIN sys.databases d
	ON ddips.database_id = d.database_id
INNER JOIN sys.tables t
	ON i.object_id = t.object_id
ORDER BY 'Avg Frag %'
	, 'Page Count' DESC
	---------------------------------------------------------------------------------
	-- FRAGMENTATION		|   RECOMMENDED ACTION	   								|
	---------------------------------------------------------------------------------
	-- < 5 percent 	    	|   Do Nothing											|
	--   5 to 30 percent    |   Reorganize with ALTER INDEX REORGANIZE				|
	-- > 30 percent 	    |   Rebuild with ALTER INDEX REBUILD WITH (ONLINE = ON)	|
	--				    	|     or												|
	--				    	|   CREATE INDEX with DROP_EXISTING=ON					|
	---------------------------------------------------------------------------------
