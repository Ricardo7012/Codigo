-- List Search for word In all Object

DECLARE @SearchString varchar(50)

SET @SearchString = '%PlayerID%'

SELECT DISTINCT o.NAME AS ObjectName
	, CASE o.xtype
		WHEN 'C'
			THEN 'CHECK constraint'
		WHEN 'D'
			THEN 'Default or DEFAULT constraint'
		WHEN 'F'
			THEN 'FOREIGN KEY constraint'
		WHEN 'FN'
			THEN 'Scalar function'
		WHEN 'IF'
			THEN 'In-lined table-function'
		WHEN 'K'
			THEN 'PRIMARY KEY or UNIQUE constraint'
		WHEN 'L'
			THEN 'Log'
		WHEN 'P'
			THEN 'Stored procedure'
		WHEN 'R'
			THEN 'Rule'
		WHEN 'RF'
			THEN 'Replication filter stored procedure'
		WHEN 'S'
			THEN 'System table'
		WHEN 'TF'
			THEN 'Table function'
		WHEN 'TR'
			THEN 'Trigger'
		WHEN 'U'
			THEN 'User table'
		WHEN 'V'
			THEN 'View'
		WHEN 'X'
			THEN 'Extended stored procedure'
		ELSE o.xtype
		END AS ObjectType
	, ISNULL(p.NAME, '[db]') AS Location
FROM syscomments c
INNER JOIN sysobjects o
	ON c.id = o.id
LEFT JOIN sysobjects p
	ON o.Parent_obj = p.id
WHERE c.TEXT LIKE @SearchString
ORDER BY Location
	, ObjectName
