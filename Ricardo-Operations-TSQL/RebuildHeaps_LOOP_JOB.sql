USE [msdb]
GO

/****** Object:  Job [IEHP_RebuildHeaps_HSP_MO]    Script Date: 2/1/2019 11:50:43 AM ******/
EXEC msdb.dbo.sp_delete_job @job_id=N'b292c42f-e3e1-4cff-bf0a-9acfa7a80bc1', @delete_unused_schedule=1
GO

/****** Object:  Job [IEHP_RebuildHeaps_HSP_MO]    Script Date: 2/1/2019 11:50:43 AM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Database Maintenance]    Script Date: 2/1/2019 11:50:43 AM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Database Maintenance' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Database Maintenance'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'IEHP_RebuildHeaps_HSP', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'RICARDO AND DBA TEAM', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'_system_admin', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [IEHP_RebuildHeaps_HSP_MO]    Script Date: 2/1/2019 11:50:43 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'IEHP_RebuildHeaps_HSP', 
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
		IF OBJECT_ID('tempdb..#RebuildHeaps') IS NOT NULL
		DROP TABLE #RebuildHeaps

		SET NOCOUNT ON
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

		DECLARE @i int
		DECLARE @numrows int

		CREATE TABLE #RebuildHeaps
		(
			  idx smallint Primary Key IDENTITY(1,1)
			, HEAPSQL Varchar(max)
		);

		INSERT INTO #RebuildHeaps
		SELECT 'ALTER TABLE ' + SCH.[name] + '.' + TBL.[name] + ' REBUILD;' 
		FROM sys.tables AS TBL
			 INNER JOIN sys.schemas AS SCH
				 ON TBL.schema_id = SCH.schema_id
			 INNER JOIN sys.indexes AS IDX
				 ON TBL.object_id = IDX.object_id
					AND IDX.type = 0 -- = Heap

		DECLARE @HEAPSQL NVARCHAR(MAX);

		--SELECT * FROM #RebuildHeaps ORDER BY idx ASC

		SET @i = 1
		SET @numrows = (SELECT COUNT(*) FROM #RebuildHeaps);

		if @numrows > 0
			WHILE (@i <=(SELECT MAX(idx) FROM #RebuildHeaps))
			BEGIN 
				SET @HEAPSQL = (SELECT HEAPSQL FROM #RebuildHeaps WHERE idx = @i)
				EXECUTE sp_executesql @HEAPSQL
				PRINT convert(varchar(4),@i) + ' - ' + @HEAPSQL + ' COMPLETED'
				SET @i = @i + 1
			END 
		DROP TABLE #RebuildHeaps;
		', 
		@database_name=N'HSP', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


