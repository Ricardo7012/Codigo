-- List Tables with Triggers and Count

SELECT p.NAME AS [Qualified_Name]
	, COUNT(*) AS 'How Many'
FROM sys.objects s
INNER JOIN sys.objects p
	ON s.parent_Object_ID = p.[object_ID]
WHERE OBJECTPROPERTY(s.object_ID, 'IsTrigger') <> 0
	AND OBJECTPROPERTY(p.object_ID, 'IsTable') <> 0
GROUP BY p.NAME
