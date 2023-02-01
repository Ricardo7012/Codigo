-- http://technet.microsoft.com/en-us/library/ms188755.aspx
SELECT 
	 OBJECT_NAME(OBJECT_ID) AS TABLE_NAME
	,LAST_USER_UPDATE
	,*
FROM 
	sys.dm_db_index_usage_stats
WHERE 
	database_id = DB_ID('reportserver')
 AND 
	OBJECT_ID=OBJECT_ID('ModelItemPolicy')
GO

SELECT
	 t.name
	 ,user_seeks
	 ,user_scans
	 ,user_lookups
	 ,user_updates
	 ,last_user_seek
	 ,last_user_scan
	 ,last_user_lookup
	 ,last_user_update
 FROM
	 sys.dm_db_index_usage_stats i JOIN
	 sys.tables t ON (t.object_id = i.object_id)
 WHERE
	database_id = db_id()
 AND 
	i.OBJECT_ID=OBJECT_ID('ModelItemPolicy')
 GO
