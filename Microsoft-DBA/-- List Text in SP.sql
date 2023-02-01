-- List Text in SP

DECLARE @StringToFind nvarchar(100)

SET @StringToFind = 'Rebuild Player'

SELECT DB_NAME() AS 'DB Name'
	, SCHEMA_NAME(o.schema_id) AS 'Schema'
	, o.name AS 'Proc Name'
	, convert(nvarchar(20), CASE
		WHEN o.type IN ('P','PC')
		THEN 'PROCEDURE'
		ELSE 'FUNCTION' END) AS 'Proc Type'
	, convert(sysname, CASE
		WHEN o.type IN ('TF', 'IF', 'FT') THEN N'TABLE'
		ELSE ISNULL(type_name(c.system_type_id),
			type_name(c.user_type_id)) END)	AS 'Data Type'
	, convert(nvarchar(30), CASE
		WHEN o.type IN ('P ', 'FN', 'TF', 'IF') THEN 'SQL'
		ELSE 'EXTERNAL' END) AS 'Proc Body'
	, convert(nvarchar(4000), object_definition(o.object_id)) AS 'Proc Text'
	, o.create_date	AS 'Created'
	, o.modify_date AS 'Last Altered'
FROM
	sys.objects o LEFT JOIN sys.parameters c 
	ON (c.object_id = o.object_id AND c.parameter_id = 0)
WHERE
	o.type IN ('P', 'FN', 'TF', 'IF', 'AF', 'FT', 'IS', 'PC', 'FS')
	and object_definition(o.object_id) like '%' + @StringToFind + '%'