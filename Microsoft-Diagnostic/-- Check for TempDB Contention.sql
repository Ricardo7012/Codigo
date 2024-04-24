-- Check for TempDB Contention
-- https://www.sqlskills.com/help/waits/pageiolatch_sh/
SELECT session_id AS 'Session ID'
	, wait_type AS 'Wait Type'
	, wait_duration_ms AS 'Wait Duration (MS)'
	, blocking_session_id AS 'Blocking Session ID'
	, resource_description AS 'Resource Description'
	, ResourceType = CASE 
		WHEN Cast(Right(resource_description, Len(resource_description) - Charindex(':', resource_description, 3)) AS INT) - 1 % 8088 = 0
			THEN 'Is PFS Page'
		WHEN Cast(Right(resource_description, Len(resource_description) - Charindex(':', resource_description, 3)) AS INT) - 2 % 511232 = 0
			THEN 'Is GAM Page'
		WHEN Cast(Right(resource_description, Len(resource_description) - Charindex(':', resource_description, 3)) AS INT) - 3 % 511232 = 0
			THEN 'Is SGAM Page'
		ELSE 'Is Not PFS, GAM, or SGAM page'
		END
FROM sys.dm_os_waiting_tasks
WHERE wait_type LIKE 'PAGE%LATCH_%' AND resource_description LIKE '2:%'

