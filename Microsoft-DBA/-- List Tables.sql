-- List Tables

DECLARE @text NVARCHAR(max)

SET @text = 'Proc_GetNextID'

SELECT object_name(id) AS [Object]
	, count(*) AS [Count]
FROM syscomments
WHERE TEXT LIKE '%' + @text + '%'
GROUP BY object_name(id)
ORDER BY OBJECT
