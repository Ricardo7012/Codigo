-- List SP and Table

-- Option 1
SELECT DISTINCT so.NAME
FROM syscomments sc
INNER JOIN sysobjects so
	ON sc.id = so.id
WHERE sc.TEXT LIKE '%AbsUser%'

-- Option 
SELECT DISTINCT o.NAME
	, o.xtype
FROM syscomments c
INNER JOIN sysobjects o
	ON c.id = o.id
WHERE c.TEXT LIKE '%AbsUser%'
