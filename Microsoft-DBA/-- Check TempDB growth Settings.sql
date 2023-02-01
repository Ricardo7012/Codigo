-- Check TempDB growth Settings

SELECT NAME AS 'File Name'
	, CAST(size * 1.0 / 128 AS decimal(38, 2)) AS 'File Size (MB)'
	, CASE max_size
		WHEN 0
			THEN 'Autogrowth is off.'
		WHEN - 1
			THEN 'Autogrowth is on.'
		ELSE 'Log file will grow to a maximum size of 2 TB.'
		END AS 'Autogrowth Setting'
	, growth AS 'Growth Value'
	, CASE 
		WHEN growth = 0
			THEN 'Size is fixed and will not grow.'
		WHEN growth > 0
			AND is_percent_growth = 0
			THEN 'Growth value is in 8-KB pages.'
		ELSE 'Growth value is a percentage.'
		END AS 'Growth Increment'
FROM tempdb.sys.database_files
ORDER BY 'File Name'
