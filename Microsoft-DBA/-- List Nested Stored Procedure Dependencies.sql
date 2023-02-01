-- List Nested Stored Procedure Dependencies

SELECT *
FROM (
	SELECT NAME AS 'Procedure Name'
		, SUBSTRING((
				SELECT ',  ' + objdep.NAME
				FROM sysdepends
				INNER JOIN sys.objects obj
					ON sysdepends.ID = obj.OBJECT_ID
				INNER JOIN sys.objects objdep
					ON sysdepends.DepID = objdep.OBJECT_ID
				WHERE obj.type = 'P'
					AND Objdep.type = 'P'
					AND sysdepends.id = procs.object_id
				ORDER BY obj.Name
				FOR XML PATH('')
				), 2, 8000) AS 'Nested Procedures'
	FROM sys.procedures procs
	) InnerTab
WHERE 'Nested Procedures' IS NOT NULL
ORDER BY 'Procedure Name'
