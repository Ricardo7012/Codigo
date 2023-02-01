USE [msdb]
GO

/****** Object:  Job [HSP_Post_ClaimLoad.Triage.1030pm]    Script Date: 10/2/2018 10:26:50 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Database Maintenance]    Script Date: 10/2/2018 10:26:50 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Database Maintenance' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Database Maintenance'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'HSP_Post_ClaimLoad.Triage.1030pm', 
		@enabled=0, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'USE HSP
ALTER INDEX ALL ON [dbo].[Claims]  REBUILD WITH (ONLINE = ON);
ALTER INDEX ALL ON [dbo].[Claim_Utilizations]  REBUILD WITH (ONLINE = ON);
ALTER INDEX ALL ON [dbo].[ClaimCOBDataDetails]  REBUILD WITH (ONLINE = ON);
--ALTER INDEX ALL ON [dbo].[EDIXacts]  REBUILD WITH (ONLINE = ON); 
ALTER INDEX ALL ON [dbo].[Claim_Master]  REBUILD WITH (ONLINE = ON);
ALTER INDEX ALL ON [dbo].[ClaimSubmissions]  REBUILD WITH (ONLINE = ON);
ALTER INDEX ALL ON [dbo].[Claim_Results]  REBUILD WITH (ONLINE = ON); 
A', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'_system_admin', 
		@notify_email_operator_name=N'DatabaseDeveloper', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Claim Index Rebuild]    Script Date: 10/2/2018 10:26:50 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Claim Index Rebuild', 
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
ALTER INDEX ALL ON [dbo].[Authorizations] REBUILD WITH (MAXDOP=8, ONLINE = ON);
ALTER INDEX ALL ON [dbo].[Claim_Details] REBUILD WITH (MAXDOP=8, ONLINE = ON); 
ALTER INDEX ALL ON [dbo].[Claim_Master] REBUILD WITH (MAXDOP=8, ONLINE = ON);
ALTER INDEX ALL ON [dbo].[Claim_Master_Data] REBUILD WITH (MAXDOP=8, ONLINE = ON); 
ALTER INDEX ALL ON [dbo].[Claim_Overrides] REBUILD WITH (MAXDOP=8, ONLINE = ON); 
ALTER INDEX ALL ON [dbo].[Claim_Overrides_Transform] REBUILD WITH (MAXDOP=8, ONLINE = ON); 
ALTER INDEX ALL ON [dbo].[Claim_Results] REBUILD WITH (MAXDOP=8, ONLINE = ON); 
ALTER INDEX ALL ON [dbo].[Claim_Utilizations] REBUILD WITH (MAXDOP=8, ONLINE = ON);
ALTER INDEX ALL ON [dbo].[ClaimActionCodeMap] REBUILD WITH (MAXDOP=8, ONLINE = ON); 
ALTER INDEX ALL ON [dbo].[ClaimCOBData] REBUILD WITH (MAXDOP=8, ONLINE = ON); 
ALTER INDEX ALL ON [dbo].[Claims] REBUILD WITH (MAXDOP=8, ONLINE = ON);
ALTER INDEX ALL ON [dbo].[Documents] REBUILD WITH (MAXDOP=8, ONLINE = ON);
ALTER INDEX ALL ON [dbo].[Files] REBUILD WITH (MAXDOP=8, ONLINE = ON);
ALTER INDEX ALL ON [dbo].[EDIXacts] REBUILD WITH (ONLINE = OFF); 

--ALTER INDEX ALL ON [dbo].[ClaimCOBDataDetails]  REBUILD WITH (MAXDOP=8, ONLINE = ON);
--ALTER INDEX ALL ON [dbo].[ClaimSubmissions]  REBUILD WITH (MAXDOP=8, ONLINE = ON);
--ALTER INDEX ALL ON [dbo].[ProviderPickingStatistics]  REBUILD WITH (MAXDOP=8, ONLINE = ON); 
--ALTER INDEX ALL ON [dbo].[PendedClaimExplanationMap]  REBUILD WITH (MAXDOP=8, ONLINE = ON); 
--ALTER INDEX ALL ON [dbo].[Claim_Codes]  REBUILD WITH (MAXDOP=8, ONLINE = ON); 
--ALTER INDEX ALL ON [dbo].[ClaimExplanationMap]  REBUILD WITH (MAXDOP=8, ONLINE = ON); 
--ALTER INDEX ALL ON [dbo].[ClaimReimbursementSelectionLog]  REBUILD WITH (MAXDOP=8, ONLINE = ON);', 
		@database_name=N'HSP', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'HSP_Post_ClaimLoad.Triage.1030pm', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=62, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20180507, 
		@active_end_date=99991231, 
		@active_start_time=223000, 
		@active_end_time=235959, 
		@schedule_uid=N'a5e2c8f7-c210-4ccf-b29e-2e2bc29be42d'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


