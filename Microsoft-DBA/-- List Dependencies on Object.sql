-- List Dependencies on Object

DECLARE @ObjName VARCHAR(50)

SET @ObjName = 'SiteGroup'

SELECT DISTINCT dobj.Name AS 'Object Name'
	, dobj.Type AS 'Object Type'
FROM sysobjects obj
INNER JOIN SysDepends d
	ON obj.id = d.depid
INNER JOIN sysobjects dobj
	ON d.id = dobj.id
WHERE obj.NAME = @ObjName
ORDER BY dobj.type
	, dobj.NAME
