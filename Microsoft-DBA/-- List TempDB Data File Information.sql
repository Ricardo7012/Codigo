-- List TempDB data File Information

SELECT DB_NAME(mf.database_id) AS 'Database Name'
	, mf.NAME AS 'Logical Name'
	, mf.file_id AS 'File ID'
	, CONVERT(DECIMAL(20, 2), (CONVERT(DECIMAL, size) / 128)) AS 'File Size MB'
	, CASE mf.is_percent_growth
		WHEN 1
			THEN 'Yes'
		ELSE 'No'
		END AS '% Growth'
	, CASE mf.is_percent_growth
		WHEN 1
			THEN CONVERT(VARCHAR, mf.growth) + '%'
		WHEN 0
			THEN CONVERT(VARCHAR, mf.growth / 128) + ' MB'
		END AS 'Growth Increments'
	, CASE mf.is_percent_growth
		WHEN 1
			THEN CONVERT(DECIMAL(20, 2), (((CONVERT(DECIMAL, size) * growth) / 100) * 8) / 1024)
		WHEN 0
			THEN CONVERT(DECIMAL(20, 2), (CONVERT(DECIMAL, growth) / 128))
		END AS 'Next Growth Size MB'
	, physical_name AS 'Physical Name'
FROM sys.master_files mf
WHERE database_id = 2
	AND type_desc = 'rows'
