-- Search for Text String

DECLARE @SEARCHSTRING VARCHAR(255)
DECLARE @notcontain VARCHAR(255)

SELECT @SEARCHSTRING = 'RebuildPlayer'
	, @notcontain = ''

SELECT DISTINCT sysobjects.NAME AS [Object Name]
	, CASE 
		WHEN sysobjects.xtype = 'P'
			THEN 'Stored Proc'
--		WHEN sysobjects.xtype = 'TF'
--			THEN 'Function'
--		WHEN sysobjects.xtype = 'TR'
--			THEN 'Trigger'
--		WHEN sysobjects.xtype = 'V'
--			THEN 'View'
		END AS [Object Type]
FROM sysobjects
	, syscomments
WHERE sysobjects.id = syscomments.id AND sysobjects.type IN (
		'P'
		, 'TF'
		, 'TR'
		, 'V'
		) AND sysobjects.category = 0 AND CHARINDEX(@SEARCHSTRING, syscomments.TEXT) > 0 
		AND ((CHARINDEX(@notcontain, syscomments.TEXT) = 0 
		OR CHARINDEX(@notcontain, syscomments.TEXT) <> 0))