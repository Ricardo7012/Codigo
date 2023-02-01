-- Find Nested (P, FN) in Stored Procedure

DECLARE @ProcName nvarchar(25)

SET @ProcName = 'Proc_FindPlayer'

SELECT *
FROM (
	SELECT Name AS 'Procedure Name'
		, SUBSTRING((
				SELECT ', ' + OBJDEP.NAME
				FROM sysdepends
				INNER JOIN sys.objects OBJ
					ON sysdepends.ID = OBJ.OBJECT_ID
				INNER JOIN sys.objects OBJDEP
					ON sysdepends.DEPID = OBJDEP.OBJECT_ID
				WHERE obj.type IN ('P', 'FN')
					AND Objdep.type IN ('P', 'FN')
					AND sysdepends.id = procs.object_id
					AND OBJ.name = @ProcName
				ORDER BY OBJ.NAME
				FOR XML PATH('')
				), 2, 8000) AS NestedProcedures
	FROM sys.procedures procs
	) InnerTab
WHERE NestedProcedures IS NOT NULL
ORDER BY 'Procedure Name'
