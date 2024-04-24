use master
go

---select count(1) from sys.sysprocesses  where dbid = 50 and status = 'sleeping'
--select count(1) from sys.sysprocesses  where dbid <> 50 and status = 'sleeping'

select 
	getdate() as [current_time],
	@@SERVERNAME as sql_instance

select 
	DB_NAME(dbid) as [db],
	[program_name], 
	count(1) as total_sleeping,
	sum(cpu) as total_cpu,
	sum(memusage) as total_memusage,
	sum(open_tran) as total_open_tran,
	sum(physical_io) as total_phyio
from sys.sysprocesses
where status = 'sleeping'
	and loginame <> 'sa'
	--and cmd = 'Awaiting Command'
	--and hostname = 'IEHP-40567'
group by DB_NAME(dbid), [program_name]
order by 3 desc


select spid, hostname,program_name, login_time, last_batch, status, loginame, cmd, open_tran
from sys.sysprocesses 
where [status] = 'sleeping'
	and loginame <> 'sa'
	and loginame <> '_system_admin'
	--and open_tran <> 0
	--and [program_name] = 'Node.js'
	--and [program_name] = '                                                                                                                                ' 
	--and cmd = 'Awaiting Command'
	--and hostname = 'IEHP-40567'
order by last_batch


/*

DECLARE @sql NVARCHAR(max) = ''

SELECT @sql = CONCAT(@sql, 'KILL ' , sp.spid, + ';' + CHAR(13))
FROM sys.sysprocesses AS sp 
LEFT OUTER JOIN sys.dm_exec_requests AS er ON sp.spid = er.session_id
LEFT OUTER JOIN sys.dm_exec_sessions AS ses ON sp.spid = ses.session_id
LEFT OUTER JOIN sys.dm_exec_connections AS con ON ses.session_id = con.session_id
WHERE 
	sp.spid <> @@SPID
	AND sp.[status] IN ('sleeping')
	AND sp.hostname = 'PVWEBOPS01'
	AND dbid = 50 --HedisDispatch
	AND (CONVERT(INT, DATEDIFF(MINUTE, ISNULL(er.start_time, sp.last_batch), GETDATE()))) >= 5 --IN MINUTES

--PRINT @sql
EXEC (@sql)


--sp_whoisactive @sort_order = '[CPU] DESC'

*/