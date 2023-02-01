-- https://www.brentozar.com/archive/2017/12/introducing-sp_blitzlock-troubleshooting-sql-server-deadlocks/
--@Top: Use if you want to limit the number of deadlocks to return. This is ordered by event date ascending
--@DatabaseName: If you want to filter to a specific database
--@StartDate: The date you want to start searching on.
--@EndDate: The date you want to stop searching on.
--@ObjectName: If you want to filter to a specific able. The object name has to be fully qualified ‘Database.Schema.Table’
--@StoredProcName: If you want to search for a single stored proc. The proc name has to be fully qualified ‘Database.Schema.Sproc’
--@AppName: If you want to filter to a specific application.
--@HostName: If you want to filter to a specific host.
--@LoginName: If you want to filter to a specific login.
--@EventSessionPath: If you want to point this at an XE session rather than the system health session.

DECLARE @VersionDate DATETIME;
EXEC master.dbo.sp_BlitzLock @Top = 50,                           -- int
                             @DatabaseName = N'HSP_RPT',                -- nvarchar(256)
                             @StartDate = '2018-08-01 00:00:00', -- datetime
                             @EndDate = '2018-09-30 00:00:00',   -- datetime
                             --@ObjectName = N'',                  -- nvarchar(1000)
                             --@StoredProcName = N'',              -- nvarchar(1000)
                             --@AppName = N'',                     -- nvarchar(256)
                             --@HostName = N'',                    -- nvarchar(256)
                             --@LoginName = N'',                   -- nvarchar(256)
                             --@EventSessionPath = '',             -- varchar(256)
                             --@Debug = NULL,                      -- bit
                             --@Help = NULL,                       -- bit
                             @VersionDate = @VersionDate OUTPUT  -- datetime
