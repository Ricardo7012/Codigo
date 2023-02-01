USE [msdb]
GO

/****** Object:  Job [HSP_Post_MemberLoad.Triage.10pm]    Script Date: 10/2/2018 10:26:56 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Database Maintenance]    Script Date: 10/2/2018 10:26:56 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Database Maintenance' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Database Maintenance'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'HSP_Post_MemberLoad.Triage.10pm', 
		@enabled=0, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'USE HSP
ALTER INDEX ALL ON [dbo].[AlternateAddress] REBUILD 
ALTER INDEX ALL ON [dbo].[AlternateAddressHistory] REBUILD 
ALTER INDEX ALL ON [dbo].[BenefitCoveragesHistory] REBUILD 
ALTER INDEX ALL ON [dbo].[EntityAttributesHistory] REBUILD 
ALTER INDEX ALL ON [dbo].[IDCardRequestHistory] REBUILD 
ALTER INDEX ALL ON [dbo].[IDCardRequests] REBUILD 
ALTER INDEX ALL ON [dbo].[MemberAidCodes] REBUILD 
ALTER INDEX ALL ON [dbo].[MemberAidCodesHistory] REBUILD 
ALTER INDEX ALL ON [dbo].[MemberCarrierMap] R', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'IEHP\sqladmin9', 
		@notify_email_operator_name=N'DatabaseDeveloper', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Member Index Rebuild]    Script Date: 10/2/2018 10:26:56 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Member Index Rebuild', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'USE HSP

ALTER INDEX ALL ON [dbo].[AlternateAddress] REBUILD WITH (MAXDOP=8, ONLINE = ON); 
ALTER INDEX ALL ON [dbo].[AlternateAddressHistory] REBUILD WITH (MAXDOP=8, ONLINE = ON); 
ALTER INDEX ALL ON [dbo].[BenefitCoveragesHistory] REBUILD WITH (MAXDOP=8, ONLINE = ON); 
ALTER INDEX ALL ON [dbo].[EntityAttributesHistory] REBUILD WITH (MAXDOP=8, ONLINE = ON); 
ALTER INDEX ALL ON [dbo].[IDCardRequestHistory] REBUILD WITH (MAXDOP=8, ONLINE = ON); 
ALTER INDEX ALL ON [dbo].[IDCardRequests] REBUILD WITH (MAXDOP=8, ONLINE = ON); 
ALTER INDEX ALL ON [dbo].[MemberAidCodes] REBUILD WITH (MAXDOP=8, ONLINE = ON); 
ALTER INDEX ALL ON [dbo].[MemberAidCodesHistory] REBUILD WITH (MAXDOP=8, ONLINE = ON); 
ALTER INDEX ALL ON [dbo].[MemberCarrierMap] REBUILD WITH (MAXDOP=8, ONLINE = ON); 
ALTER INDEX ALL ON [dbo].[MemberCoverageDetails] REBUILD WITH (MAXDOP=8, ONLINE = ON); 
ALTER INDEX ALL ON [dbo].[MemberCoverageDetailsHistory] REBUILD WITH (MAXDOP=8, ONLINE = ON); 
ALTER INDEX ALL ON [dbo].[MemberCoverages] REBUILD WITH (MAXDOP=8, ONLINE = ON); 
ALTER INDEX ALL ON [dbo].[MemberProviderMap] REBUILD WITH (MAXDOP=8, ONLINE = ON); 
ALTER INDEX ALL ON [dbo].[MemberProviderMapHistory] REBUILD WITH (MAXDOP=8, ONLINE = ON); 
ALTER INDEX ALL ON [dbo].[Members] REBUILD WITH (MAXDOP=8, ONLINE = ON); 
ALTER INDEX ALL ON [dbo].[Members_History] REBUILD WITH (MAXDOP=8, ONLINE = ON); 
ALTER INDEX ALL ON [dbo].[MembershipMemberDetailsHistory] REBUILD WITH (MAXDOP=8, ONLINE = ON); 
ALTER INDEX ALL ON [dbo].[ResponsiblePartyCoverageMap] REBUILD WITH (MAXDOP=8, ONLINE = ON); 
ALTER INDEX ALL ON [dbo].[SubscriberContracts] REBUILD WITH (MAXDOP=8, ONLINE = ON);', 
		@database_name=N'HSP', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'HSP_Post_MemberLoad.Triage.10pm', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=62, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20180507, 
		@active_end_date=99991231, 
		@active_start_time=220000, 
		@active_end_time=235959, 
		@schedule_uid=N'dbfaf45e-7672-4bb0-b649-0783505a93f6'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


