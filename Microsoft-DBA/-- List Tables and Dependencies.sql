-- List Tables and Dependencies

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
SELECT table_name AS 'Table Name'
	, proc_name AS 'Stored Procedure'
FROM stored_procedures
WHERE row = 1
ORDER BY table_name
