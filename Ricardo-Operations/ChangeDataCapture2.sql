-- https://docs.microsoft.com/en-us/sql/relational-databases/track-changes/about-change-data-capture-sql-server?view=sql-server-2017
USE HSP_Supplemental
GO
SELECT * FROM cdc.change_tables
go
EXEC sys.sp_cdc_help_change_data_capture

SELECT name, log_reuse_wait, log_reuse_wait_desc FROM sys.databases WHERE is_cdc_enabled = 1
SELECT * FROM sys.dm_cdc_log_scan_sessions ORDER BY start_time DESC 
SELECT * FROM sys.dm_cdc_errors 
exec sys.sp_cdc_help_jobs;
select serverproperty('productversion')

-- Stop the capture job
--USE HSP_Supplemental;  
--GO  
--EXEC sys.sp_cdc_stop_job @job_type = N'capture';  
--GO  
---- EXECUTE 
--EXEC sp_repldone @xactid = NULL, @xact_segno = NULL, @numtrans = 0, @time = 0, @reset = 1; EXEC sp_replflush;
---- CLOSE WINDOW 
--USE HSP_Supplemental;  
--GO  
--EXEC sys.sp_cdc_start_job @job_type = N'capture'; 
--GO  
