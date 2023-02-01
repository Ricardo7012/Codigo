--@SortOrder – find the worst queries sorted by reads, CPU, duration, executions, memory grant, or recent compilations. Just use sp_BlitzCache @SortOrder = ‘reads’ for example.
--@Top – by default, we only look at the top 10 queries, but you can use a larger number here like @Top = 50. Just know that the more queries you analyze, the slower it goes.
--@ExpertMode = 1 – turns on the more-detailed analysis of things like memory grants. (Some of this information is only available in current SP/CUs of SQL Server 2012/2014, 
--		and all 2016.) @ExportToExcel = 1 – excludes result set columns that would make Excel blow chunks when you copy/paste the results into Excel, like the execution plans. 
--		Good for sharing the plan cache metrics with other folks on your team.
--@Help = 1 – explains the rest of sp_BlitzCache’s parameters, plus the output columns as well.

USE master 
DECLARE @VersionDate DATETIME;
EXEC dbo.sp_BlitzCache @Help = NULL,                               -- bit
                       @Top = 50,                                   -- int
                       @SortOrder = 'CPU'--,                            -- varchar(50)
                       --@UseTriggersAnyway = NULL,                  -- bit
                       --@ExportToExcel = NULL,                      -- bit
                       --@ExpertMode = 1,                            -- tinyint
                       --@OutputServerName = N'',                    -- nvarchar(258)
                       --@OutputDatabaseName = N'',                  -- nvarchar(258)
                       --@OutputSchemaName = N'',                    -- nvarchar(258)
                       --@OutputTableName = N'',                     -- nvarchar(258)
                       --@ConfigurationDatabaseName = N'',           -- nvarchar(128)
                       --@ConfigurationSchemaName = N'',             -- nvarchar(258)
                       --@ConfigurationTableName = N'',              -- nvarchar(258)
                       --@DurationFilter = NULL,                     -- decimal(38, 4)
                       --@HideSummary = NULL,                        -- bit
                       --@IgnoreSystemDBs = NULL,                    -- bit
                       --@OnlyQueryHashes = '',                      -- varchar(max)
                       --@IgnoreQueryHashes = '',                    -- varchar(max)
                       --@OnlySqlHandles = '',                       -- varchar(max)
                       --@IgnoreSqlHandles = '',                     -- varchar(max)
                       --@QueryFilter = '',                          -- varchar(10)
                       --@DatabaseName = N'',                        -- nvarchar(128)
                       --@StoredProcName = N'',                      -- nvarchar(128)
                       --@Reanalyze = NULL,                          -- bit
                       --@SkipAnalysis = NULL,                       -- bit
                       --@BringThePain = NULL,                       -- bit
                       --@MinimumExecutionCount = 0,                 -- int
                       --@Debug = NULL,                              -- bit
                       --@CheckDateOverride = '2018-08-22 21:23:09', -- datetimeoffset(7)
                       --@MinutesBack = 0,                           -- int
                       --@VersionDate = @VersionDate OUTPUT          -- datetime
