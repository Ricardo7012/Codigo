USE [msdb]
GO

/****** Object:  Job [Red-Gate SQL Backup full backup: All_Databases_Encrypted]    Script Date: 8/28/2019 4:14:11 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Database Maintenance]    Script Date: 8/28/2019 4:14:11 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Database Maintenance' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Database Maintenance'
IF (@@Error <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Red-Gate SQL Backup full backup: All_Databases_Encrypted', 
		@enabled=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Red-Gate backups', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'_system_admin', @job_id = @jobId OUTPUT
IF (@@Error <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [execute master..sqlbackup]    Script Date: 8/28/2019 4:14:11 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'execute master..sqlbackup', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DECLARE @exitcode int
DECLARE @sqlerrorcode int
EXECUTE master..sqlbackup ''-SQL "BACKUP DATABASES [*] TO DISK = ''''\\dtsqlbkups\qvsqllit01backups\Red-Gate\NonProduction\<SERVER>\<AUTO>.sqb'''' WITH PASSWORD = ''''<OBFUSCATEDPASSWORD>YmY8UdS0Q2ruTa5xsYSnSoRUTXc=</OBFUSCATEDPASSWORD>'''', CHECKSUM, DISKRETRYINTERVAL = 30, DISKRETRYCOUNT = 3, COMPRESSION = 2, INIT, KEYSIZE = 256, THREADCOUNT = 10"'', @exitcode OUT, @sqlerrorcode OUT
IF (@exitcode >= 500) OR (@sqlerrorcode <> 0)
BEGIN
RAISERROR (''SQL Backup failed with exit code: %d  SQL error code: %d'', 16, 1, @exitcode, @sqlerrorcode)
END', 
		@database_name=N'master', 
		@flags=0
IF (@@Error <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@Error <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Red-Gate SQL Backup full backup: All_Databases_Encrypted.Weekdays1am', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=62, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20190828, 
		@active_end_date=99991231, 
		@active_start_time=10000, 
		@active_end_time=235959
IF (@@Error <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@Error <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TranCount > 0) ROLLBACK TRANSACTION
EndSave:
GO


