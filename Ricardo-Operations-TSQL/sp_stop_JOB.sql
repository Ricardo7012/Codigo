DECLARE @JOB_NAME SYSNAME = N'Load Medimart Tables.8pm'; 
 
IF NOT EXISTS(     
        select 1 
        from msdb.dbo.sysjobs_view job  
        inner join msdb.dbo.sysjobactivity activity on job.job_id = activity.job_id 
        where  
            activity.run_Requested_date is not null  
        and activity.stop_execution_date is null  
        and job.name = @JOB_NAME 
        ) 
BEGIN      
    PRINT 'Starting job ''' + @JOB_NAME + ''''; 
    --EXEC msdb.dbo.sp_start_job @JOB_NAME; 
END 
ELSE 
BEGIN 
    PRINT 'Job ''' + @JOB_NAME + ''' IS RUNNING AND WILL BE STOPPED!'; 
	EXEC msdb.dbo.sp_stop_job @JOB_NAME; 
	EXEC msdb.dbo.sp_send_dbmail @profile_name = 'HSP_DBMAIL',
                             @recipients = 'fernandez-r@iehp.org;Nakhoul-s@iehp.org;Choy-K@iehp.org; Manlapaz-O@iehp.org; Huang-E@iehp.org',
                             @subject = 'HSP LOAD MEDIMART JOB',
                             @body = '*** SQL JOB HSP1S1B.Load Medimart Tables.8pm HAS BEEN STOPPED AFTER 12 HOURS EXECUTION ***';
END 
