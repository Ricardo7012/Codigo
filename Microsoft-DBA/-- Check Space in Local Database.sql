-- Check Space in Local Database

SELECT RTRIM(NAME) AS 'Segment Name'
--	, groupid AS 'Group Id'
--	, filename AS 'File Name'
	, CAST(size / 128.0 AS DECIMAL(10, 2)) AS 'Size in MB'
	, CAST(FILEPROPERTY(NAME, 'SpaceUsed') / 128.0 AS DECIMAL(10, 2)) AS 'Space Used'
	, CAST(size / 128.0 - (FILEPROPERTY(NAME, 'SpaceUsed') / 128.0) AS DECIMAL(10, 2)) AS 'Available Space'
	, CAST((CAST(FILEPROPERTY(NAME, 'SpaceUsed') / 128.0 AS DECIMAL(10, 2)) / CAST(size / 128.0 AS DECIMAL(10, 2))) * 100 AS DECIMAL(10, 2)) AS 'Percent Used'
FROM sysfiles
ORDER BY groupid DESC