USE [msdb]
GO

/****** Object:  Job [KILL_ACCESS_JOB]    Script Date: 6/4/2019 10:43:06 AM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 6/4/2019 10:43:06 AM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'KILL_ACCESS_JOB', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Author: Steven Balderrama Description: Kill Access database connections to sql server if over 4 hours, first record session id and details in master.dbo.session_Log table, kill it, then clean table up, only keeping 10 days of history only.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', 
		@notify_email_operator_name=N'DBA Notification', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Record_Session_ID]    Script Date: 6/4/2019 10:43:06 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Record_Session_ID', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=2, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N';with results
as
(
	select  @@SERVERNAME SERVERNAME,
		s.session_id, db_name(r.database_id) [Database], r.command, SUBSTRING(st.text, (r.statement_start_offset/2)+1, 
		((CASE r.statement_end_offset
		WHEN -1 THEN DATALENGTH(st.text)
		ELSE r.statement_end_offset
		END - r.statement_start_offset)/2) + 1) as statement_text, datediff(ss,r.start_time,getdate()) [Running_Time (Seconds)], s.login_name
		, sp.blocked, sp.physical_io, sp.cpu, sp.[status], s.host_name, s.program_name, s.last_request_end_time
		, r.start_time, coalesce(QUOTENAME(DB_NAME(st.dbid)) + N''.''
		+ QUOTENAME(OBJECT_SCHEMA_NAME(st.objectid, st.dbid)) + N''.''
		+ QUOTENAME(OBJECT_NAME(st.objectid, st.dbid))

		, ''<Adhoc Batch>'') as command_text
	from sys.dm_exec_sessions as s
		join sys.dm_exec_requests as r
			on r.session_id = s.session_id
		join sys.sysprocesses sp
			on s.session_id = sp.spid
		cross apply sys.dm_exec_sql_text(r.sql_handle) as st
	where s.session_id <> @@spid
)
insert into master.dbo.Session_Logs([session_id],[ServerName],[Database],[command],[statement_text],[Running_Time (Seconds)],[login_name],[blocked],[physical_io],[cpu],[status],[host_name],[program_name],[last_request_end_time],[start_time],[command_text],[SessionDate])
select [session_id]
,[ServerName]
,[Database]
,[command]
,[statement_text]
,[Running_Time (Seconds)]
,[login_name]
,[blocked]
,[physical_io]
,[cpu]
,[status]
,[host_name]
,[program_name]
,[last_request_end_time]
,[start_time]
,[command_text],GETDATE() SessionDate
--into master.dbo.Session_Logs
from results
where 
(
	[program_name] like ''%Access%''
	OR
	[program_name] like ''%Microsoft Office system%''
	OR
	login_name like ''%i%''
)
and login_name not like ''%ProcessPC%''
and login_name not like ''%sqladmin%''
and login_name not like ''%PSQLAGENTSVC%''
and login_name not like ''%4756%''
and [host_name] not like ''%IEHP-6286%''
and [host_name] not like ''%PPC1%''
and login_name not like ''%adminsql%''
and login_name not like ''%PSQLSVC%''
and [host_name] not like ''%PPC2%''
and [host_name] not like ''%IEHP-3009%''
and [host_name] not like ''%IEHP-2769%''
and login_name not like ''%i7571%''
and login_name not like ''%C1051%''
AND Login_name NOT LIKE ''%i2522%''
and [Running_Time (Seconds)] > 10800
order by last_request_end_time;


', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Kill_Session_ID]    Script Date: 6/4/2019 10:43:06 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Kill_Session_ID', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=2, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'IF OBJECT_ID(''tempdb..#Results'') IS NOT NULL DROP TABLE #Results
GO

;with results
as
(
	select  @@SERVERNAME ServerName,
		s.session_id, db_name(r.database_id) [Database], r.command, SUBSTRING(st.text, (r.statement_start_offset/2)+1, 
		((CASE r.statement_end_offset
		WHEN -1 THEN DATALENGTH(st.text)
		ELSE r.statement_end_offset
		END - r.statement_start_offset)/2) + 1) as statement_text, datediff(ss,r.start_time,getdate()) [Running_Time (Seconds)], s.login_name
		, sp.blocked, sp.physical_io, sp.cpu, sp.[status], s.host_name, s.program_name, s.last_request_end_time
		, r.start_time, coalesce(QUOTENAME(DB_NAME(st.dbid)) + N''.''
		+ QUOTENAME(OBJECT_SCHEMA_NAME(st.objectid, st.dbid)) + N''.''
		+ QUOTENAME(OBJECT_NAME(st.objectid, st.dbid))

		, ''<Adhoc Batch>'') as command_text
	from sys.dm_exec_sessions as s
		join sys.dm_exec_requests as r
			on r.session_id = s.session_id
		join sys.sysprocesses sp
			on s.session_id = sp.spid
		cross apply sys.dm_exec_sql_text(r.sql_handle) as st
	where s.session_id <> @@spid
)
select ROW_NUMBER() over(order by Session_ID) ID,''Kill ''+Convert(varchar(8),session_id) Session_ID
into #Results
from results
where 
(
	[program_name] like ''%Access%''
	OR
	[program_name] like ''%Microsoft Office system%''
	OR
	login_name like ''%i%''
)
and login_name not like ''%ProcessPC%''
and [host_name] not like ''%IEHP-6286%''
and login_name not like ''%PSQLAGENTSVC%''
and [host_name] not like ''%PPC1%''
and login_name not like ''%sqladmin%''
and login_name not like ''%adminsql%''
and login_name not like ''%4756%''
and [host_name] not like ''%adminsql%''
and [host_name] not like ''%IEHP-3009%''
and login_name not like ''%i7571%''
and [host_name] not like ''%IEHP-2769%''
and [login_name] not like ''%C1051%''
AND Login_name NOT LIKE ''%i2522%''
and [Running_Time (Seconds)] > 10800
order by last_request_end_time;

declare @sql nvarchar(256),@counter int = 1, @max int

select @max = MAX(ID)
from #Results

while @counter <= @max
	BEGIN

		select @sql = Session_ID
		from #Results
		where ID = @counter

		exec sp_executesql @sql;

		set @counter = @counter + 1

	END

IF OBJECT_ID(''tempdb..#Results'') IS NOT NULL DROP TABLE #Results
GO

', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Clean_Session_Log_History]    Script Date: 6/4/2019 10:43:06 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Clean_Session_Log_History', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=2, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'---- retention of 10 days only



delete from master.dbo.Session_Logs
where SessionDate < DATEADD(day, -30, GETDATE()) 


', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Runs Every Hour', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=15, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20180407, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'f283e081-2431-4c09-a0e3-d4ba7e2d005e'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


