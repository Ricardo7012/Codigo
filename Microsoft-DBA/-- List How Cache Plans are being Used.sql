-- List How Cache Plans are being Used

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
SELECT [CacheType]
	, [Total Plans]
	, [Total MBs]
	, [Avg Use Count]
	, [Total MBs - USE Count 1]
	, Cast([Total Plans] * 1.0 / Sum([Total Plans]) OVER () * 100.0 AS DECIMAL(5, 2)) AS Cache_Alloc_Pct
FROM CACHE_ALLOC
ORDER BY [Total Plans] DESC
