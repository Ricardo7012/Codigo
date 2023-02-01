-- List Data Dictionary from SQL Server

SELECT a.NAME AS [Table]
	, b.NAME AS [Attribute]
	, c.NAME AS [DataType]
	, b.isnullable AS [Allow Nulls?]
	, CASE 
		WHEN d.NAME IS NULL
			THEN 0
		ELSE 1
		END [PKey?]
	, CASE 
		WHEN e.parent_object_id IS NULL
			THEN 0
		ELSE 1
		END [FKey?]
	, CASE 
		WHEN e.parent_object_id IS NULL
			THEN '-'
		ELSE g.NAME
		END [Ref Table]
	, CASE 
		WHEN h.value IS NULL
			THEN '-'
		ELSE h.value
		END [Description]
FROM sysobjects AS a
INNER JOIN syscolumns AS b
	ON a.id = b.id
INNER JOIN systypes AS c
	ON b.xtype = c.xtype
LEFT JOIN (
	SELECT so.id
		, sc.colid
		, sc.NAME
	FROM syscolumns sc
	INNER JOIN sysobjects so
		ON so.id = sc.id
	INNER JOIN sysindexkeys si
		ON so.id = si.id AND sc.colid = si.colid
	WHERE si.indid = 1
	) d
	ON a.id = d.id AND b.colid = d.colid
LEFT JOIN sys.foreign_key_columns AS e
	ON a.id = e.parent_object_id AND b.colid = e.parent_column_id
LEFT JOIN sys.objects AS g
	ON e.referenced_object_id = g.object_id
LEFT JOIN sys.extended_properties AS h
	ON a.id = h.major_id AND b.colid = h.minor_id
WHERE a.type = 'U'
ORDER BY a.NAME
