-- List Nested Stored Procedures

SELECT  * FROM (SELECT  NAME AS ProcedureName, SUBSTRING(( SELECT  ', ' + OBJDEP.NAME
FROM    sysdepends
        INNER JOIN sys.objects OBJ ON sysdepends.ID = OBJ.OBJECT_ID
        INNER JOIN sys.objects OBJDEP ON sysdepends.DEPID = OBJDEP.OBJECT_ID
WHERE obj.type = 'P'
AND Objdep.type = 'P'
AND sysdepends.id = procs.object_id
ORDER BY OBJ.name

FOR
XML PATH('')
), 2, 8000) AS NestedProcedures
FROM sys.procedures  procs )InnerTab
WHERE NestedProcedures IS NOT NULL
ORDER BY InnerTab.ProcedureName