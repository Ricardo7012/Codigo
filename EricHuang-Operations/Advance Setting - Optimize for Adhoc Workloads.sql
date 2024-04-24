--SQL Server Advance Settings - Optimize for Adhoc Workload
--Turn ON if adhoc plan % compare to total is between 20% to 30%
--It is turned OFF after service is restarted, wait few days and evaluate before changing it

SELECT AdHoc_Plan_MB, Total_Cache_MB,
        AdHoc_Plan_MB*100.0 / Total_Cache_MB AS 'AdHoc %'
FROM (
		SELECT SUM(CASE
					WHEN objtype = 'adhoc'
					THEN size_in_bytes
					ELSE 0 END) / 1048576.0 AdHoc_Plan_MB,
				SUM(CAST(size_in_bytes AS FLOAT))  / 1048576.0 Total_Cache_MB
		FROM sys.dm_exec_cached_plans
	) T
