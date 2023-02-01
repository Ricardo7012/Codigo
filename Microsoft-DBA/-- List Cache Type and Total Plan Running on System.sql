-- List Cache Type and Total Plan Running on System

WITH CACHE_ALLOC
AS (
	SELECT objtype AS [CacheType]
		, COUNT_BIG(objtype) AS [Total Plans]
		, SUM(CAST(size_in_bytes AS DECIMAL(18, 2))) / 1024 / 1024 AS [Total MBs]
		, AVG(usecounts) AS [Avg Use Count]
		, SUM(CAST((
					CASE 
						WHEN usecounts = 1
							THEN size_in_bytes
						ELSE 0
						END
					) AS DECIMAL(18, 2))) / 1024 / 1024 AS [Total MBs - USE Count 1]
		, CASE 
			WHEN (GROUPING(objtype) = 1)
				THEN COUNT_BIG(objtype)
			ELSE 0
			END AS GTOTAL
	FROM sys.dm_exec_cached_plans
	GROUP BY objtype
	)
SELECT [CacheType] AS 'Cache Type'
	, [Total Plans] AS 'Total Plans'
	, [Total MBs] AS 'Total MBs'
	, [Avg Use Count] AS 'Avg Use Count'
	, [Total MBs - USE Count 1] AS 'Total MBs - USE Count 1'
	, CAST([Total Plans] * 1.0 / SUM([Total Plans]) OVER () * 100.0 AS DECIMAL(5, 2)) AS 'Cache Alloc Pct'
FROM CACHE_ALLOC
ORDER BY 'Total Plans' DESC