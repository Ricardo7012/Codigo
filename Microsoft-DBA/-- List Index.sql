-- List Index

SELECT dbs.name AS 'Schema Name'
	, dbt.name AS 'Table Name'
	, dbi.name AS 'Index Name'
	, ips.index_type_desc AS 'Index type'
	, CONVERT(DECIMAL(10, 2), ips.avg_fragmentation_in_percent) AS 'Avg Frag %'
	, ips.page_count AS 'Page Count'
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS ips
INNER JOIN sys.tables dbt
	ON dbt.object_id = ips.object_id
INNER JOIN sys.schemas dbs
	ON dbt.schema_id = dbs.schema_id
INNER JOIN sys.indexes AS dbi
	ON dbi.object_id = ips.object_id
		AND ips.index_id = dbi.index_id
WHERE ips.database_id = DB_ID()
AND dbt.name NOT LIKE 'sys%'
AND ips.index_type_desc NOT LIKE ''
-- AND idxs.page_count > 10
ORDER BY ips.avg_fragmentation_in_percent DESC
