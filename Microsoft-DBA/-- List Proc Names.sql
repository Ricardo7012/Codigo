-- List Proc Names

WITH stored_procedures
AS (
	SELECT o.NAME AS proc_name
		, oo.NAME AS table_name
		, ROW_NUMBER() OVER (
			PARTITION BY o.NAME
			, oo.NAME ORDER BY o.NAME
				, oo.NAME
			) AS row
	FROM sysdepends d
	INNER JOIN sysobjects o
		ON o.id = d.id
	INNER JOIN sysobjects oo
		ON oo.id = d.depid
	WHERE o.xtype = 'P'
	)
SELECT proc_name AS 'Procedure Name'
	, table_name AS 'Table Referance'
FROM stored_procedures
WHERE row = 1
	AND proc_name = 'Proc_AbsUserMaskDelete'
ORDER BY proc_name
	, table_name
