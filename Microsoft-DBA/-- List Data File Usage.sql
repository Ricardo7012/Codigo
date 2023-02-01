-- List Data File Usage

SET NOCOUNT ON

SELECT convert(NUMERIC(10, 2), sum(round(a.size / 128., 2))) AS 'File Size (MB)'
	, convert(NUMERIC(10, 2), sum(round(fileproperty(a.NAME, 'SpaceUsed') / 128., 2))) AS 'Used Space (MB)'
	, convert(NUMERIC(10, 2), sum(round((a.size - fileproperty(a.NAME, 'SpaceUsed')) / 128., 2))) AS 'Unused Space (MB)'
	, CASE 
		WHEN a.groupid IS NULL
			THEN ''
		WHEN a.groupid = 0
			THEN 'Log'
		ELSE 'Data'
		END AS 'Type'
	, isnull(a.NAME, '*** Total for all files ***') AS 'DB File Name'
FROM sysfiles a
GROUP BY groupid
	, a.NAME
WITH rollup
HAVING a.groupid IS NULL
	OR a.NAME IS NOT NULL
ORDER BY CASE 
		WHEN a.groupid IS NULL
			THEN 99
		WHEN a.groupid = 0
			THEN 0
		ELSE 1
		END
	, a.groupid
	, CASE 
		WHEN a.NAME IS NULL
			THEN 99
		ELSE 0
		END
	, a.NAME
