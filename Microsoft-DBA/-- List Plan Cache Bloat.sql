-- List Plan Cache Bloat

WITH CACHE_ALLOC
AS (
	SELECT objtype AS [CacheType]
		, COUNT_BIG(objtype) AS [Total Plans]
		, sum(cast(size_in_bytes AS DECIMAL(18, 2))) / 1024 / 1024 AS [Total MBs]
		, avg(usecounts) AS [Avg Use Count]
		, sum(cast((
					CASE 
						WHEN usecounts = 1
							THEN size_in_bytes
						ELSE 0
						END
					) AS DECIMAL(18, 2))) / 1024 / 1024 AS [Total MBs - USE Count 1]
		, CASE 
			WHEN (Grouping(objtype) = 1)
				THEN count_big(objtype)
			ELSE 0
			END AS GTOTAL
	FROM sys.dm_exec_cached_plans
	GROUP BY objtype
	)
SELECT [CacheType] AS 'Cache Type'
	, [Total Plans] AS 'Total Plans'
	, [Total MBs] AS 'Total (MB)'
	, [Avg Use Count] AS 'Avg Use Count'
	, [Total MBs - USE Count 1] AS 'Total MBs - USE Count 1'
	, Cast([Total Plans] * 1.0 / Sum([Total Plans]) OVER () * 100.0 AS DECIMAL(5, 2)) AS 'Cache Alloc %'
FROM CACHE_ALLOC
ORDER BY [Total Plans] DESC
