-- List Tables that use a Column

DECLARE @Column_Name NVARCHAR(384) = NULL

SET @Column_Name = 'UserID'

SELECT 'Table Name' = object_name(syscolumns.id)
	, 'Field Name' = rtrim(syscolumns.NAME)
	,  'Object Type' = CASE sysobjects.xtype
		WHEN 'u'
			THEN 'User Table'
		WHEN 'v'
			THEN 'View'
		END
FROM syscolumns
INNER JOIN sysobjects
	ON syscolumns.id = sysobjects.id
WHERE syscolumns.NAME LIKE @Column_Name
	AND sysobjects.xtype IN (
		'u'
		, 'v'
		)
ORDER BY 'Table Name'		
