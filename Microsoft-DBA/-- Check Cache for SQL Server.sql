-- Check Cache for SQL Server

SELECT domcc.type AS 'Type'
	, domcc.NAME AS 'Name'
	, sum(domcc.single_pages_kb + domcc.multi_pages_kb) AS 'Pages (KB)'
	, sum(domcc.single_pages_in_use_kb + domcc.multi_pages_in_use_kb) AS 'Pages In Use (KB)'
	, sum(domcc.entries_count)AS 'Entries Count'
	, sum(domcc.entries_in_use_count) AS 'Entries In Use Count'
FROM sys.dm_os_memory_cache_counters domcc
WHERE domcc.type LIKE 'Cache%'
GROUP BY domcc.name, domcc.type
ORDER BY 'Pages (KB)' DESC