-- List Table with Triggers
SELECT Object_Schema_name(s.[object_ID]) + '.' + p.NAME AS [Qualified_Name]
	, COUNT(*) AS [how many]
FROM sys.objects S --to get the objects
INNER JOIN sys.objects p
	--to get the parent object so as to get the name of the table
	ON s.parent_Object_ID = p.[object_ID]
WHERE OBJECTPROPERTY(s.object_ID, 'IsTrigger') <> 0 AND OBJECTPROPERTY(p.object_ID, 'IsTable') <> 0
GROUP BY Object_Schema_name(s.[object_ID]) + '.' + p.NAME
