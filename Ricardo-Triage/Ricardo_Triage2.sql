USE Ricardo
GO
SET TRAN ISOLATION LEVEL READ UNCOMMITTED;

/**********************************************************
WHERE, WHO, WHAT!
**********************************************************/
SELECT @@SERVERNAME AS ServerName, SYSTEM_USER AS DBA, GETDATE() AS Date_Time
GO

SELECT @@servername AS servername,
       *
FROM sys.dm_os_sys_info;

/**********************************************************
MAKE SURE EVERYTHING IS ONLINE
**********************************************************/
SELECT name, user_access_desc, state_desc, log_reuse_wait_desc FROM sys.databases
GO

/**********************************************************
WHO'S DOING WHAT WHERE
**********************************************************/
DECLARE @VersionDate DATETIME;
EXEC Ricardo.dbo.sp_BlitzWho @Help = 0,                         -- tinyint
						--@@Spid = 
                     @ShowSleepingSPIDs = 1,            -- tinyint
                     @ExpertMode = 1,                -- bit
                     @Debug = NULL,                     -- bit
                     @VersionDate = @VersionDate OUTPUT -- datetime
GO

--JOB DURATION HISTORY 
SELECT @@ServerName                                                                                     AS SERVERNAME
     , j.name                                                                                           AS 'JobName'
     , s.step_id                                                                                        AS 'Step'
     , s.step_name                                                                                      AS 'StepName'
     , msdb.dbo.agent_datetime(run_date, run_time)                                                      AS 'RunDateTime'
     , ((run_duration / 10000 * 3600 + (run_duration / 100) % 100 * 60 + run_duration % 100 + 31) / 60) AS 'RunDurationMinutes'
FROM msdb.dbo.sysjobs                 j
    INNER JOIN msdb.dbo.sysjobsteps   s
        ON j.job_id = s.job_id
    INNER JOIN msdb.dbo.sysjobhistory h
        ON s.job_id = h.job_id
           AND s.step_id = h.step_id
           AND h.step_id <> 0
WHERE j.enabled = 1 --Only Enabled Jobs
      AND ((run_duration / 10000 * 3600 + (run_duration / 100) % 100 * 60 + run_duration % 100 + 31) / 60) > 0
      AND j.name <> 'syspolicy_purge_history' --Uncomment to search for a single job
      --AND msdb.dbo.agent_datetime(run_date, run_time)
      --BETWEEN '04/01/2021' AND '04/31/2021' --Uncomment for date range queries
ORDER BY RunDateTime DESC;


/**********************************************************
Why is my SQL Server slow right now?
**********************************************************/
-- https://www.brentozar.com/askbrent/
-- https://sqlperformance.com/2018/10/sql-performance/top-wait-stats
EXEC sp_BlitzFirst @ExpertMode = 1, @Seconds = 25 -- DEFAULT = 5 SECONDS
GO 

/**********************************************************
Which queries have been using the most resources?
**********************************************************/
EXEC Ricardo.dbo.sp_BlitzCache @SortOrder='CPU', @ExpertMode = 1
GO 
/**********************************************************
Are my indexes designed for speed?
**********************************************************/
EXEC Ricardo.dbo.sp_BlitzIndex @DatabaseName ='x', @TableName='x'
GO

-- THIS IS ONLY IF YOU NEED TO SEE ALL SERVER CONFIGURATION 
/**********************************************************
Is my SQL Server healthy, or sick?
**********************************************************/
EXEC sp_Blitz
GO 
----T-LOGS SPACE
--DBCC SQLPERF(LOGSPACE)
--GO 

SELECT cplan.usecounts
     , cplan.objtype
     , qtext.text
     , qplan.query_plan
FROM sys.dm_exec_cached_plans                     AS cplan
    CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS qtext
    CROSS APPLY sys.dm_exec_query_plan(plan_handle) AS qplan
ORDER BY cplan.usecounts DESC;

/**********************************************************
-- https://www.brentozar.com/archive/2018/07/tsql2sday-how-much-plan-cache-history-do-you-have/ 
--Before I run sp_BlitzCache to analyze which queries have been the most resource-intensive,  
--I want to know, “How much query plan history does SQL Server have available?” Looking at the top 10 plans in the cache doesn’t do me much good if: 
--Someone restarted the server recently 
--Someone ran DBCC FREEPROCCACHE 
--Somebody’s addicted to rebuilding indexes and updating stats (which invalidates plans for all affected objects) 
--The server’s under extreme memory pressure 
--The developers aren’t parameterizing their queries 
--The app has an old version of NHibernate with the parameterization bug 
--The .NET app calls. Parameters.Add without setting the parameter size 
-- many things that give SQL Server amnesia.  
**********************************************************/
SELECT TOP 50
       creation_date = CAST(creation_time AS DATE)
     , creation_hour = CASE
                           WHEN CAST(creation_time AS DATE) <> CAST(GETDATE() AS DATE)
                               THEN
                               0
                           ELSE
                               DATEPART(hh, creation_time)
                       END
     , SUM(1)        AS plans
FROM sys.dm_exec_query_stats
GROUP BY CAST(creation_time AS DATE)
       , CASE
             WHEN CAST(creation_time AS DATE) <> CAST(GETDATE() AS DATE)
                 THEN
                 0
             ELSE
                 DATEPART(hh, creation_time)
         END
ORDER BY 1 DESC
       , 2 DESC;

