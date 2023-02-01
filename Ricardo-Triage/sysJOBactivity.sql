SELECT
    @@SERVERNAME AS servername,
	ja.session_id,                
    ja.job_id,
    j.name AS job_name,
	--j.owner_sid,
    ja.run_requested_date,        
    ja.run_requested_source,      
    ja.queued_date,               
    ja.start_execution_date,      
    ja.last_executed_step_id,     
    ja.last_executed_step_date,   
    ja.stop_execution_date,       
    ja.next_scheduled_run_date,
    ja.job_history_id,            
    jh.message,
    jh.run_status,
    jh.operator_id_emailed,
    jh.operator_id_netsent,
    jh.operator_id_paged
  FROM
    (msdb.dbo.sysjobactivity ja LEFT JOIN msdb.dbo.sysjobhistory jh ON ja.job_history_id = jh.instance_id)
    join msdb.dbo.sysjobs_view j on ja.job_id = j.job_id
  --WHERE
  --  (@job_id IS NULL OR ja.job_id = @job_id) AND
  --   ja.session_id = @session_id
ORDER BY 
	session_id DESC

