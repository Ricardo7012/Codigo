EXEC sp_configure 'xp_cmdshell', 1
GO

RECONFIGURE
GO

DECLARE @svrName VARCHAR(255)
DECLARE @sql VARCHAR(400)

--by default it will take the current server name, we can the set the server name as well
SET @svrName = @@SERVERNAME
SET @sql = 'Powershell.exe -c "Get-WmiObject -ComputerName ' + QUOTENAME(@svrName, '''') + ' -Class Win32_Volume -Filter ''DriveType = 3'' | select name,capacity,freespace | foreach{$_.name+''|''+$_.capacity/1048576+''%''+$_.freespace/1048576+''*''}"'

--creating a temporary table
CREATE TABLE #output (line VARCHAR(255))

--inserting disk name, total space and free space value in to temporary table
INSERT #output
EXEC xp_cmdshell @sql

--script to retrieve the values in MB from PS Script output
SELECT @svrName AS [ServerName]
	, convert(DATETIME, convert(DATE, getdate())) AS 'Time Collected
	, rtrim(ltrim(SUBSTRING(line, 1, CHARINDEX('|', line) - 1))) AS drivename
	, round(cast(rtrim(ltrim(SUBSTRING(line, CHARINDEX('|', line) + 1, (CHARINDEX('%', line) - 1) - CHARINDEX('|', line)))) AS FLOAT), 0) AS 'capacity(MB)'
	, round(cast(rtrim(ltrim(SUBSTRING(line, CHARINDEX('%', line) + 1, (CHARINDEX('*', line) - 1) - CHARINDEX('%', line)))) AS FLOAT), 0) AS 'freespace(MB)'
FROM #output
WHERE line LIKE '[A-Z][:]%'
ORDER BY drivename

DROP TABLE #output
GO

sp_configure 'xp_cmdshell'
	, 0
GO

RECONFIGURE
GO