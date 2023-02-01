-- List out Table Dependancies

DECLARE @Search VARCHAR(255)

SET @Search = 'Proc_ReconstructPlayer'

SELECT DISTINCT o.Name AS 'Proc Name'
	, o.type_desc AS 'Type Desc'
FROM sys.sql_modules sm
INNER JOIN sys.objects o
	ON sm.object_id = o.object_id
WHERE sm.DEFINITION LIKE '%' + @Search + '%'
ORDER BY o.Name
