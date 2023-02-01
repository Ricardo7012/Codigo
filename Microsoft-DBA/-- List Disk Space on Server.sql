-- List Disk Space on Server

DECLARE @svrName VARCHAR(255)
DECLARE @sql VARCHAR(400)

--by default it will take the current server name, we can the set the server name as well
SET @svrName = @@SERVERNAME
SET @sql = 'powershell.exe -c "Get-WmiObject -ComputerName ' + QUOTENAME(@svrName, '''') + ' -Class Win32_Volume -Filter ''DriveType = 3'' | select name,capacity,freespace | foreach{$_.name+''|''+$_.capacity/1048576+''%''+$_.freespace/1048576+''*''}"'

--creating a temporary table
CREATE TABLE #output (line VARCHAR(255))

--inserting disk name, total space and free space value in to temporary table
INSERT #output
EXEC xp_cmdshell @sql

--script to retrieve the values in MB from PS Script output
SELECT rtrim(ltrim(SUBSTRING(line, 1, CHARINDEX('|', line) - 1))) AS drivename
	,round(cast(rtrim(ltrim(SUBSTRING(line, CHARINDEX('|', line) + 1, (CHARINDEX('%', line) - 1) - CHARINDEX('|', line)))) AS FLOAT), 0) AS 'capacity(MB)'
	,round(cast(rtrim(ltrim(SUBSTRING(line, CHARINDEX('%', line) + 1, (CHARINDEX('*', line) - 1) - CHARINDEX('%', line)))) AS FLOAT), 0) AS 'freespace(MB)'
FROM #output
WHERE line LIKE '[A-Z][:]%'
ORDER BY drivename

--script to retrieve the values in GB from PS Script output
SELECT rtrim(ltrim(SUBSTRING(line, 1, CHARINDEX('|', line) - 1))) AS drivename
	,round(cast(rtrim(ltrim(SUBSTRING(line, CHARINDEX('|', line) + 1, (CHARINDEX('%', line) - 1) - CHARINDEX('|', line)))) AS FLOAT) / 1024, 0) AS 'capacity(GB)'
	,round(cast(rtrim(ltrim(SUBSTRING(line, CHARINDEX('%', line) + 1, (CHARINDEX('*', line) - 1) - CHARINDEX('%', line)))) AS FLOAT) / 1024, 0) AS 'freespace(GB)'
FROM #output
WHERE line LIKE '[A-Z][:]%'
ORDER BY drivename

--script to drop the temporary table
DROP TABLE #output
