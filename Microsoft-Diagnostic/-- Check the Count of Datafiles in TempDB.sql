-- Check the Count of Datafiles in TempDB 

DECLARE @tempdbfilecount AS INT;

SELECT @tempdbfilecount = (
		SELECT count(*)
		FROM sys.master_files
		WHERE database_id = 2 AND type = 0
		);

WITH Processor_CTE (
	[cpu_count]
	, [hyperthread_ratio]
	)
AS (
	SELECT cpu_count
		, hyperthread_ratio
	FROM sys.dm_os_sys_info sysinfo
	)
SELECT Processor_CTE.cpu_count AS '# of Logical Processors'
	, @tempdbfilecount AS 'TempDB Data File Count'
	, (
		CASE 
			WHEN (cpu_count < 8 AND @tempdbfilecount = cpu_count)
				THEN 'No'
			WHEN (cpu_count < 8 AND @tempdbfilecount <> cpu_count AND @tempdbfilecount < cpu_count)
				THEN 'Yes'
			WHEN (cpu_count < 8 AND @tempdbfilecount <> cpu_count AND @tempdbfilecount > cpu_count)
				THEN 'No'
			WHEN (cpu_count >= 8 AND @tempdbfilecount = cpu_count)
				THEN 'No (Depends on continued Contention)'
			WHEN (cpu_count >= 8 AND @tempdbfilecount <> cpu_count AND @tempdbfilecount < cpu_count)
				THEN 'Yes'
			WHEN (cpu_count >= 8 AND @tempdbfilecount <> cpu_count AND @tempdbfilecount > cpu_count)
				THEN 'No (Depends on continued Contention)'
			END
		) AS 'Add additional Data Files to TempDB'
FROM Processor_CTE;
