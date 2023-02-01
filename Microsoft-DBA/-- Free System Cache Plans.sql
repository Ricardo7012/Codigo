-- Free System Cache Plans

-- Select the Database your running this in
SELECT objtype AS 'Object Type'
	, count(*) AS '# of Plans'
	, sum(cast(size_in_bytes AS BIGINT)) / 1024 / 1024 AS 'Memory Cost'
	, avg(usecounts) AS 'Avg USE Count'
FROM sys.dm_exec_cached_plans
GROUP BY objtype

DBCC FREESYSTEMCACHE ('SQL Plans')