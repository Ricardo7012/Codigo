
SELECT *
FROM dbo.vw_job_and_schedules
WHERE [job name] LIKE 'HSP1S1A_HSP_Prime_BatchExtracts_%'
ORDER BY [next run time] DESC

USE msdb
GO


CREATE VIEW dbo.vw_job_and_schedules

AS

SELECT
   [Job ID] =            job.job_id
   ,[Job Name] =         job.Name
   ,[Job Enabled] =      
               CASE job.Enabled
                  WHEN 1 THEN 'Yes'
                  WHEN 0 THEN 'No'
               END
   ,[Sched ID] =         sched.schedule_id
   ,[Sched Enabled] =      
                  CASE sched.enabled
                     WHEN 1 THEN 'Yes'
                     WHEN 0 THEN 'No'
                  END
   ,[Sched Frequency] =   
                  CASE sched.freq_type
                     WHEN 1 THEN 'Once'
                     WHEN 4 THEN 'Daily'
                     WHEN 8 THEN 'Weekly'
                     WHEN 16 THEN 'Monthly'
                     WHEN 32 THEN 'Monthly relative'
                     WHEN 64 THEN 'When SQLServer Agent starts'
                  END
   ,[Next Run Date] =      
                  CASE next_run_date
                     WHEN 0 THEN NULL
                     ELSE SUBSTRING(CONVERT(VARCHAR(15), next_run_date), 1, 4) + '/' +
                        SUBSTRING(CONVERT(VARCHAR(15), next_run_date), 5, 2) + '/' +
                        SUBSTRING(CONVERT(VARCHAR(15), next_run_date), 7, 2)
                  END
   ,[Next Run Time] =      
                  CASE LEN(next_run_time)
                     WHEN 1 THEN CAST('00:00:0' + RIGHT(next_run_time, 2) AS CHAR(8))
                     WHEN 2 THEN CAST('00:00:' + RIGHT(next_run_time, 2) AS CHAR(8))
                     WHEN 3 THEN CAST('00:0'
                        + LEFT(RIGHT(next_run_time, 3), 1)
                        + ':' + RIGHT(next_run_time, 2) AS CHAR(8))
                     WHEN 4 THEN CAST('00:'
                        + LEFT(RIGHT(next_run_time, 4), 2)
                        + ':' + RIGHT(next_run_time, 2) AS CHAR(8))
                     WHEN 5 THEN CAST('0'
                        + LEFT(RIGHT(next_run_time, 5), 1)
                        + ':' + LEFT(RIGHT(next_run_time, 4), 2)
                        + ':' + RIGHT(next_run_time, 2) AS CHAR(8))
                     WHEN 6 THEN CAST(LEFT(RIGHT(next_run_time, 6), 2)
                        + ':' + LEFT(RIGHT(next_run_time, 4), 2)
                        + ':' + RIGHT(next_run_time, 2) AS CHAR(8))
                  END
   ,[Max Duration] =      
                  CASE LEN(run_duration)
                     WHEN 1 THEN CAST('00:00:0'
                        + CAST(run_duration AS CHAR) AS CHAR(8))
                     WHEN 2 THEN CAST('00:00:'
                        + CAST(run_duration AS CHAR) AS CHAR(8))
                     WHEN 3 THEN CAST('00:0'
                        + LEFT(RIGHT(run_duration, 3), 1)
                        + ':' + RIGHT(run_duration, 2) AS CHAR(8))
                     WHEN 4 THEN CAST('00:'
                        + LEFT(RIGHT(run_duration, 4), 2)
                        + ':' + RIGHT(run_duration, 2) AS CHAR(8))
                     WHEN 5 THEN CAST('0'
                        + LEFT(RIGHT(run_duration, 5), 1)
                        + ':' + LEFT(RIGHT(run_duration, 4), 2)
                        + ':' + RIGHT(run_duration, 2) AS CHAR(8))
                     WHEN 6 THEN CAST(LEFT(RIGHT(run_duration, 6), 2)
                        + ':' + LEFT(RIGHT(run_duration, 4), 2)
                        + ':' + RIGHT(run_duration, 2) AS CHAR(8))
                  END
   ,[Subday Frequency] =   
                     CASE (sched.freq_subday_interval)
                        WHEN 0 THEN 'Once'
                        ELSE CAST('Every '
                           + RIGHT(sched.freq_subday_interval, 2)
                           + ' '
                           + CASE (sched.freq_subday_type)
                              WHEN 1 THEN 'Once'
                              WHEN 4 THEN 'Minutes'
                              WHEN 8 THEN 'Hours'
                           END AS CHAR(16))
                     END
   ,[Sched End Date] =      sched.active_end_date
   ,[Sched End Time] =      sched.active_end_time
   ,[Fail Notify Name] =   
                     CASE
                        WHEN oper.enabled = 0 THEN 'Disabled: '
                        ELSE ''
                     END + oper.name
   ,[Fail Notify Email] =   oper.email_address

FROM dbo.sysjobs job
LEFT JOIN (SELECT

      job_schd.job_id
      ,sys_schd.enabled
      ,sys_schd.schedule_id
      ,sys_schd.freq_type
      ,sys_schd.freq_subday_type
      ,sys_schd.freq_subday_interval
      ,next_run_date =   
                  CASE
                     WHEN job_schd.next_run_date = 0 THEN sys_schd.active_start_date
                     ELSE job_schd.next_run_date
                  END
      ,next_run_time =   
                  CASE
                     WHEN job_schd.next_run_date = 0 THEN sys_schd.active_start_time
                     ELSE job_schd.next_run_time
                  END
      ,active_end_date =   NULLIF(sys_schd.active_end_date, '99991231')
      ,active_end_time =   NULLIF(sys_schd.active_end_time, '235959')

   FROM dbo.sysjobschedules job_schd

   LEFT JOIN dbo.sysschedules sys_schd
      ON job_schd.schedule_id = sys_schd.schedule_id) sched

   ON job.job_id = sched.job_id
LEFT OUTER JOIN (SELECT
      job_id
      ,MAX(job_his.run_duration)   AS run_duration
   FROM dbo.sysjobhistory job_his
   GROUP BY job_id) Q1
   ON job.job_id = Q1.job_id

LEFT JOIN sysoperators oper
   ON job.notify_email_operator_id = oper.id

