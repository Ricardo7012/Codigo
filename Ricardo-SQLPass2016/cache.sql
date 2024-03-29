/*
http://www.sqlskills.com/BLOGS/KIMBERLY/post/Plan-cache-adhoc-workloads-and-clearing-the-single-use-plan-cache-bloat.aspx
To clear just the "SQL Plans" from the plan cache, use:
http://msdn.microsoft.com/en-us/library/ms181055.aspx
*/

DBCC FREESYSTEMCACHE('SQL Plans') 
--If you want to clear all of the cache, you can use: 
DBCC FREEPROCCACHE 

/*
1. Clearing *JUST* the 'SQL Plans' based on *just* the amount of Adhoc/Prepared single-use plans (2005/2008):
*/ 

DECLARE @MB decimal(19,3)
        , @Count bigint
        , @StrMB nvarchar(20)
 
SELECT @MB = sum(cast((CASE WHEN usecounts = 1 AND objtype IN ('Adhoc', 'Prepared') THEN size_in_bytes ELSE 0 END)as decimal(12,2)))/1024/1024 
        , @Count = sum(CASE WHEN usecounts = 1 AND objtype IN('Adhoc', 'Prepared')THEN 1 ELSE 0 END)
        , @StrMB = convert(nvarchar(20), @MB)
FROM sys.dm_exec_cached_plans
 
IF @MB > 10
        BEGIN
                DBCC FREESYSTEMCACHE('SQL Plans') 
                RAISERROR ('%s MB was allocated to single-use plan cache. Single-use plans have been cleared.', 10, 1, @StrMB)
         END
 ELSE
        BEGIN
                RAISERROR ('Only %s MB is allocated to single-use plan cache - no need to clear cache now.', 10, 1, @StrMB)
                 -- Note: this is only a warning message and not an actual error.
        END
 go
/* 
2. Clearing *ALL* of your cache based on the total amount of wasted by single-use plans (2005/2008):
*/ 

DECLARE @MB decimal(19,3)
        , @Count bigint
        , @StrMB nvarchar(20)
 
SELECT @MB = sum(cast((CASE WHEN usecounts = 1 THEN size_in_bytes ELSE 0 END)as decimal(12,2)))/1024/1024 
        , @Count = sum(CASE WHEN usecounts = 1 THEN 1 ELSE 0 END)
        , @StrMB = convert(nvarchar(20), @MB)
FROM sys.dm_exec_cached_plans
 
IF @MB > 1000
        DBCC FREEPROCCACHE
ELSE
        RAISERROR ('Only %s MB is allocated to single-use plan cache - no need to clear cache now.', 10, 1, @StrMB)
go

/*
3. Stored Procedure to report/track + logic to go into a job based on percentage OR MB of wasted cache (2008 only):
*/
/*============================================================================
  File:     sp_SQLskills_CheckPlanCache

  Summary:  This procedure looks at cache and totals the single-use plans
			to report the percentage of memory consumed (and therefore wasted)
			from single-use plans.
			
  Date:     April 2010

  Version:	2008.
------------------------------------------------------------------------------
  Written by Kimberly L. Tripp, SQLskills.com

  For more scripts and sample code, check out 
    http://www.SQLskills.com

  This script is intended only as a supplement to demos and lectures
  given by SQLskills instructors.  
  
  THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
  ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
  TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
  PARTICULAR PURPOSE.
============================================================================*/

USE master
go

if OBJECTPROPERTY(OBJECT_ID('sp_SQLskills_CheckPlanCache'), 'IsProcedure') = 1
	DROP PROCEDURE sp_SQLskills_CheckPlanCache
go

CREATE PROCEDURE sp_SQLskills_CheckPlanCache
	(@Percent	decimal(6,3) OUTPUT,
	 @WastedMB	decimal(19,3) OUTPUT)
AS
SET NOCOUNT ON

DECLARE @ConfiguredMemory	decimal(19,3)
	, @PhysicalMemory		decimal(19,3)
	, @MemoryInUse			decimal(19,3)
	, @SingleUsePlanCount	bigint

CREATE TABLE #ConfigurationOptions
(
	[name]				nvarchar(35)
	, [minimum]			int
	, [maximum]			int
	, [config_value]	int				-- in bytes
	, [run_value]		int				-- in bytes
);
INSERT #ConfigurationOptions EXEC ('sp_configure ''max server memory''');

SELECT @ConfiguredMemory = run_value/1024/1024 
FROM #ConfigurationOptions 
WHERE name = 'max server memory (MB)'

SELECT @PhysicalMemory = total_physical_memory_kb/1024 
FROM sys.dm_os_sys_memory

SELECT @MemoryInUse = physical_memory_in_use_kb/1024 
FROM sys.dm_os_process_memory

SELECT @WastedMB = sum(cast((CASE WHEN usecounts = 1 AND objtype IN ('Adhoc', 'Prepared') 
								THEN size_in_bytes ELSE 0 END) AS DECIMAL(12,2)))/1024/1024 
	, @SingleUsePlanCount = sum(CASE WHEN usecounts = 1 AND objtype IN ('Adhoc', 'Prepared') 
								THEN 1 ELSE 0 END)
	, @Percent = @WastedMB/@MemoryInUse * 100
FROM sys.dm_exec_cached_plans

SELECT	[TotalPhysicalMemory (MB)] = @PhysicalMemory
	, [TotalConfiguredMemory (MB)] = @ConfiguredMemory
	, [MaxMemoryAvailableToSQLServer (%)] = @ConfiguredMemory/@PhysicalMemory * 100
	, [MemoryInUseBySQLServer (MB)] = @MemoryInUse
	, [TotalSingleUsePlanCache (MB)] = @WastedMB
	, TotalNumberOfSingleUsePlans = @SingleUsePlanCount
	, [PercentOfConfiguredCacheWastedForSingleUsePlans (%)] = @Percent
GO

EXEC sys.sp_MS_marksystemobject 'sp_SQLskills_CheckPlanCache'
go

-----------------------------------------------------------------
-- Logic (in a job?) to decide whether or not to clear - using sproc...
-----------------------------------------------------------------

DECLARE @Percent		decimal(6, 3)
		, @WastedMB		decimal(19,3)
		, @StrMB		nvarchar(20)
		, @StrPercent	nvarchar(20)
EXEC sp_SQLskills_CheckPlanCache @Percent output, @WastedMB output

SELECT @StrMB = CONVERT(nvarchar(20), @WastedMB)
		, @StrPercent = CONVERT(nvarchar(20), @Percent)

IF @Percent > 10 OR @WastedMB > 10
	BEGIN
		DBCC FREESYSTEMCACHE('SQL Plans') 
		RAISERROR ('%s MB (%s percent) was allocated to single-use plan cache. Single-use plans have been cleared.', 10, 1, @StrMB, @StrPercent)
	END
ELSE
	BEGIN
		RAISERROR ('Only %s MB (%s percent) is allocated to single-use plan cache - no need to clear cache now.', 10, 1, @StrMB, @StrPercent)
			-- Note: this is only a warning message and not an actual error.
	END
go