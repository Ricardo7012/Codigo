-- https://www.brentozar.com/blitzindex/
--@GetAllDatabases = 1 – runs index tests across all of the databases on the server instead of just your current database context. If you’ve got more than 50 databases on the server, this only works if you also pass in @BringThePain = 1, because it’s gonna be slow. @DatabaseName, @SchemaName, @TableName – if you only want to examine indexes on a particular table, fill all three of these out. @SkipPartitions = 1 – goes faster on databases with large numbers of partitions, like over 500. @Mode – options are:

--0 (default) – basic diagnostics of urgent issues
--1 – summarize database metrics
--2 – index usage detail only
--3 – missing indexes only
--4 – in-depth diagnostics, including low-priority issues and small objects
--@Filter – only works in @Mode = 0. Options are:

--0 (default) – no filter
--1 – no low-usage warnings for objects with 0 reads
--2 – only warn about objects over 500MB
--@ThresholdMB = 250 – number of megabytes that an object must be before we display its data in @Mode = 0. @Help = 1 – explains the rest of sp_BlitzIndex’s parameters.

DECLARE @VersionDate DATETIME;
EXEC master.dbo.sp_BlitzIndex @DatabaseName = N'HSP_RPT',               -- nvarchar(128)
                              @SchemaName = N'dbo',                 -- nvarchar(128)
                              @TableName = N'Claim_Master',                  -- nvarchar(128)
                              @Mode = 0,                         -- tinyint
                              @Filter = 0,                       -- tinyint
                              @SkipPartitions = NULL,            -- bit
                              @SkipStatistics = NULL,            -- bit
                              @GetAllDatabases = 0,           -- bit
                              @BringThePain = NULL,              -- bit
                              @ThresholdMB = 0,                  -- int
                              @OutputServerName = N'',           -- nvarchar(256)
                              @OutputDatabaseName = N'',         -- nvarchar(256)
                              @OutputSchemaName = N'',           -- nvarchar(256)
                              @OutputTableName = N'',            -- nvarchar(256)
                              @Help = 0,                         -- tinyint
                              @VersionDate = @VersionDate OUTPUT -- datetime

