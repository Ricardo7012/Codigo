-- List Object Type

DECLARE @ObjectName VARCHAR(30)

SET @ObjectName = 'Proc_ReconstructPlayer'

SELECT usecounts AS 'Use Count'
	, cacheobjtype AS 'Cache Object Type'
	, objtype AS 'Object Type'
	, OBJECT_NAME(dest.objectid) AS 'Object Name'
FROM sys.dm_exec_cached_plans decp
CROSS APPLY sys.dm_exec_sql_text(decp.plan_handle) AS dest
WHERE dest.objectid = OBJECT_ID(@ObjectName)
	AND dest.dbid = DB_ID()
ORDER BY usecounts DESC;
