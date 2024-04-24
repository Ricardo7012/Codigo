USE Ricardo
GO
SELECT *
FROM sys.dm_os_windows_info;  

SELECT *
FROM sys.dm_os_sys_info

SELECT @@servername as SERVERNAME, cpu_count, scheduler_count, max_workers_count, physical_memory_kb, virtual_machine_type_desc FROM sys.dm_os_sys_info
go

-- https://www.brentozar.com/archive/2017/10/free-sql-server-performance-check/
EXEC sp_BlitzFirst @SinceStartup = 1;

EXEC sp_BlitzFirst @CheckProcedureCache = 1 

EXEC sp_BlitzCache @SortOrder = 'cpu';

EXEC sp_BlitzCache @Help = 1;

-- https://www.brentozar.com/pastetheplan/

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
EXEC sp_BlitzCache @SortOrder='CPU', @ExpertMode = 1
GO 
/**********************************************************
Are my indexes designed for speed?
**********************************************************/
EXEC sp_BlitzIndex @DatabaseName ='x', @TableName='x'
GO

/**********************************************************
Is my SQL Server healthy, or sick?
**********************************************************/
EXEC sp_Blitz
GO 
