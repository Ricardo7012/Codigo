USE [msdb]
GO

IF EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = N'IEHP_DatabaseIntegrityCheck.7pm')
EXEC msdb.dbo.sp_delete_job @job_name=N'IEHP_DatabaseIntegrityCheck.7pm', @delete_unused_schedule=1
GO
IF EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = N'IEHP_DatabaseIntegrityCheck.3amSat')
EXEC msdb.dbo.sp_delete_job @job_name=N'IEHP_DatabaseIntegrityCheck.3amSat', @delete_unused_schedule=1
GO

IF EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = N'DatabaseIntegrityCheck.3amSat')
EXEC msdb.dbo.sp_delete_job @job_name=N'DatabaseIntegrityCheck.3amSat', @delete_unused_schedule=1
GO


/****** Object:  Job [DatabaseIntegrityCheck.7pm]    Script Date: 12/16/2016 11:11:00 AM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Database Maintenance]    Script Date: 12/16/2016 11:11:00 AM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Database Maintenance' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Database Maintenance'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'DatabaseIntegrityCheck.3amSat', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'CHECKDB', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'_system_admin', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [DatabaseIntegrityCheck.7pm]    Script Date: 12/16/2016 11:11:00 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'DatabaseIntegrityCheck.3amSat', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'USE [master]
GO
EXEC [dbo].[sp_DatabaseIntegrityCheck] @Databases = ''ALL_DATABASES'', @CheckCommands= ''CHECKDB''
GO', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'DatabaseIntegrityCheck.3amSat', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20161018, 
		@active_end_date=99991231, 
		@active_start_time=50000, 
		@active_end_time=235959
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


