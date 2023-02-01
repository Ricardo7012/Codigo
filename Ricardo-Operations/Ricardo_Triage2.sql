/**********************************************************
WHERE, WHO, WHAT!
**********************************************************/
SELECT @@SERVERNAME AS ServerName, SYSTEM_USER AS DBA, GETDATE() AS Date_Time
GO

/**********************************************************
MAKE SURE EVERYTHING IS ONLINE
**********************************************************/
SELECT name, user_access_desc, state_desc, log_reuse_wait_desc FROM sys.databases
GO

/**********************************************************
WHO''S DOING WHAT WHERE
**********************************************************/
----
EXEC sp_WhoIsActive @get_plans=0
go 
--
DECLARE @VersionDate DATETIME;
EXEC dbo.sp_BlitzWho @Help = 0,                         -- tinyint
                     @ShowSleepingSPIDs = 1,            -- tinyint
                     @ExpertMode = 1,                -- bit
                     @Debug = NULL,                     -- bit
                     @VersionDate = @VersionDate OUTPUT -- datetime
GO


/**********************************************************
Why is my SQL Server slow right now?
**********************************************************/
-- https://www.brentozar.com/askbrent/
-- https://sqlperformance.com/2018/10/sql-performance/top-wait-stats
EXEC sp_BlitzFirst @ExpertMode = 1, @Seconds = 60 -- DEFAULT = 5 SECONDS
GO 

/**********************************************************
Which queries have been using the most resources?
**********************************************************/
EXEC sp_BlitzCache @SortOrder='CPU', @ExpertMode = 1
GO 
/**********************************************************
Are my indexes designed for speed?
**********************************************************/
EXEC sp_BlitzIndex @DatabaseName ='HSP', @TableName='Claims'
GO
EXEC sp_BlitzIndex @DatabaseName ='HSP', @TableName='Claim_Master'
GO
EXEC sp_BlitzIndex @DatabaseName ='HSP', @TableName='Claim_Details'
GO
EXEC sp_BlitzIndex @DatabaseName ='HSP', @TableName='Claim_Results'
GO
EXEC sp_BlitzIndex @DatabaseName ='HSP', @TableName='InputBatches'
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
