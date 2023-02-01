-- Check to see if Databases are Replicated

SELECT NAME AS [Database name]
	, CASE is_published
		WHEN 0
			THEN 'No'
		ELSE 'Yes'
		END AS [Is Published]
	, CASE is_merge_published
		WHEN 0
			THEN 'No'
		ELSE 'Yes'
		END AS [Is Merge Published]
	, CASE is_distributor
		WHEN 0
			THEN 'No'
		ELSE 'Yes'
		END AS [Is Distributor]
	, CASE is_subscribed
		WHEN 0
			THEN 'No'
		ELSE 'Yes'
		END AS [Is Subscribed]
FROM sys.databases 
WHERE database_id > 4
