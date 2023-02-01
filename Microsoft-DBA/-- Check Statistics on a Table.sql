-- Check Statistics on a Table

DECLARE @TableName sysname

SET @TableName = 'ack_lu'

SELECT o.NAME AS 'Table Name'
	, i.NAME AS 'Index Name'
	, STATS_DATE(i.[object_id], i.index_id) AS 'Statistics Date'
	, s.auto_created AS 'Auto Created'
	, s.no_recompute AS 'NO Recompute'
	, s.user_created AS 'User Created'
FROM sys.objects AS o WITH (NOLOCK)
INNER JOIN sys.indexes AS i WITH (NOLOCK)
	ON o.[object_id] = i.[object_id]
INNER JOIN sys.stats AS s WITH (NOLOCK)
	ON i.[object_id] = s.[object_id]
		AND i.index_id = s.stats_id
WHERE o.[type] = 'U'
AND o.name = @TableName
ORDER BY STATS_DATE(i.[object_id], i.index_id) ASC;
