-- List Usage of Data Files

WITH mf
AS (
	SELECT *
		, CAST(max_size AS FLOAT) * 8 AS MaxKB
		, CAST(size AS FLOAT) * 8 AS SizeKB
		, CAST(growth AS FLOAT) * 8 AS GrowthKB
		, fileproperty(NAME, 'SpaceUsed') * 8 AS UsedKB
	FROM sys.database_files
	)
SELECT DB_NAME(DB_ID()) AS DatabaseName
	, NAME AS LogicalName
	, type_desc
	, FILEGROUP_NAME(data_space_id) AS [file_group]
	, physical_name
	, CASE 
		WHEN UsedKB < POWER(1024, 2)
			THEN CAST(ROUND(UsedKB / POWER(1024, 1), 2) AS VARCHAR(MAX)) + ' MB'
		WHEN UsedKB < POWER(1024, 3)
			THEN CAST(ROUND(UsedKB / POWER(1024, 2), 2) AS VARCHAR(MAX)) + ' GB'
		ELSE CAST(ROUND(UsedKB / POWER(1024, 3), 2) AS VARCHAR(MAX)) + ' TB'
		END AS Used
	, CASE 
		WHEN SizeKB < POWER(1024, 2)
			THEN CAST(ROUND(SizeKB / POWER(1024, 1), 2) AS VARCHAR(MAX)) + ' MB'
		WHEN SizeKB < POWER(1024, 3)
			THEN CAST(ROUND(SizeKB / POWER(1024, 2), 2) AS VARCHAR(MAX)) + ' GB'
		ELSE CAST(ROUND(SizeKB / POWER(1024, 3), 2) AS VARCHAR(MAX)) + ' TB'
		END AS Size
	, ROUND((UsedKB / SizeKB) * 100, 2) AS PercentageUsed
	, CASE 
		WHEN max_size = - 1
			THEN 'UNLIMITED'
		WHEN MaxKB < POWER(1024, 2)
			THEN CAST(ROUND(MaxKB / POWER(1024, 1), 2) AS VARCHAR(MAX)) + ' MB'
		WHEN MaxKB < POWER(1024, 3)
			THEN CAST(ROUND(MaxKB / POWER(1024, 2), 2) AS VARCHAR(MAX)) + ' GB'
		ELSE CAST(ROUND(MaxKB / POWER(1024, 3), 2) AS VARCHAR(MAX)) + ' TB'
		END AS MaxSize
	, CASE 
		WHEN is_percent_growth = 1
			THEN CAST(growth AS VARCHAR(3)) + '%'
		WHEN is_percent_growth = 0
			AND GrowthKB = 0
			THEN 'NONE'
		ELSE CASE 
				WHEN GrowthKB < POWER(1024, 2)
					THEN CAST(ROUND(GrowthKB / POWER(1024, 1), 2) AS VARCHAR(MAX)) + ' MB'
				WHEN GrowthKB < POWER(1024, 3)
					THEN CAST(ROUND(GrowthKB / POWER(1024, 2), 2) AS VARCHAR(MAX)) + ' GB'
				ELSE CAST(ROUND(GrowthKB / POWER(1024, 3), 2) AS VARCHAR(MAX)) + ' TB'
				END
		END AS Growth
FROM mf