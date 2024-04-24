/* Using system DMVs to quickly list high CPU time SQL processes */
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT @@SERVERNAME AS SQLInstance, GETDATE() AS CurrentDateTime, @@VERSION AS VersionInfo, 
	'Quick Activities Report' AS ReportingCategory


SELECT  er.session_id, er.status, er.command,
	er.wait_type, er.wait_time, er.wait_resource,
	er.open_transaction_count, er.percent_complete,
	er.cpu_time, er.reads, er.writes, er.logical_reads, 
	sp.hostname, sp.loginame
FROM sys.dm_exec_requests AS er
	INNER JOIN sys.sysprocesses AS sp ON er.session_id = sp.spid
WHERE er.status IN ('suspended', 'running', 'runnable', 'sleeping')
ORDER BY er.cpu_time DESC

/*
Sessions by hostname with a summary count of total sessions and total CPU time
with highest total cpu time consumption on top
*/
SELECT  sp.hostname, sp.nt_username, sp.program_name, sp.loginame, 
	COUNT(1) AS TotalSessions, SUM(cpu_time) AS SUM_cpu_time
FROM sys.dm_exec_requests AS er
	INNER JOIN sys.sysprocesses AS sp ON er.session_id = sp.spid
WHERE er.status IN ('suspended', 'running', 'runnable', 'sleeping')
	--AND dbid IN (db_id('SuperSearch'), db_id('Network_Development'))
	AND sp.program_name not IN ('Microsoft Office', 'Microsoft Data Access Components')
GROUP BY sp.hostname, nt_username, sp.program_name, sp.loginame
ORDER BY SUM(cpu_time) desc


SELECT loginame, program_name, last_batch, hostname, DB_NAME(dbid) AS DBName, dbid, 
	status, cpu, waittype, waitresource, waittime, spid
FROM sys.sysprocesses
WHERE status IN ('suspended', 'running', 'runnable', 'sleeping')
	AND cpu > 0
	ANd DBID <> 148
	--AND spid IN (67)
	AND program_name IN ('Microsoft Office', 'Microsoft Data Access Components')
ORDER BY dbid DESC
