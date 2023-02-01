-- List DMV's for Current Version

SELECT NAME
	, xtype
FROM master.dbo.sysobjects
WHERE NAME LIKE 'dm%'
ORDER BY NAME
