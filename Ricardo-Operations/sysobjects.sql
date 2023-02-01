SELECT 
	dp.name
	, so.* 
FROM sysobjects so
	LEFT JOIN sys.database_principals dp on 
	dp.principal_id = so.uid 
WHERE 
	so.type = 'p' 
ORDER BY 
	crdate desc 

--SELECT * FROM sys.database_principals
 