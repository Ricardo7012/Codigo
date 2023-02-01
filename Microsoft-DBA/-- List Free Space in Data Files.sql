-- List Free space in Data Files

SELECT a.FILEID AS 'DB File ID'
	, CONVERT(DECIMAL(12, 2), ROUND(a.size / 128.000, 2)) AS 'File Size (MB)'
	, CONVERT(DECIMAL(12, 2), ROUND(FILEPROPERTY(a.NAME, 'SpaceUsed') / 128.000, 2)) AS 'Space Used (MB)'
	, CONVERT(DECIMAL(12, 2), ROUND((a.size - FILEPROPERTY(a.NAME, 'SpaceUsed')) / 128.000, 2)) AS 'Free Space (MB)'
	, LEFT(a.NAME, 15) AS 'DB Name'
	, LEFT(a.FILENAME, 30) AS 'FileName Location'
FROM dbo.sysfiles a
