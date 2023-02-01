-- FIND TABLES WITHOUT AN INDEX
USE ReportServer
GO 
SELECT 
	SCHEMA_NAME(SCHEMA_ID) AS schemaname
	,[name] as tablename
FROM 
	sys.tables	
WHERE OBJECTPROPERTY(object_id, 'isindexed')=0
ORDER BY schemaname, tablename
go
