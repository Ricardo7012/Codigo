-- 	https://www.brentozar.com/archive/2017/05/announcing-sp_blitzbackups-check-wreck/
--	This script checks your backups to see how much data you might lose when
--	this server fails, and how long it might take to recover.

--	To learn more, visit http://FirstResponderKit.org where you can download new
--	versions for free, watch training videos on how it works, get more info on
--	the findings, contribute your own code, and more.

--	Known limitations of this version:
--	 - Only Microsoft-supported versions of SQL Server. Sorry, 2005 and 2000.

--	Unknown limitations of this version:
--	 - None.  (If we knew them, they would be known. Duh.)

--     Changes - for the full list of improvements and fixes in this version, see:
--     https://github.com/BrentOzarULTD/SQL-Server-First-Responder-Kit/


--	Parameter explanations:

--	@HoursBack INT = 168		How many hours of history to examine, back from now.
--								You can check just the last 24 hours of backups, for example.
--	@MSDBName NVARCHAR(255) 	You can restore MSDB from different servers and check them
--								centrally. Also useful if you create a DBA utility database
--								and merge data from several servers in an AG into one DB.
--	@RestoreSpeedFullMBps INT	By default, we use the backup speed from MSDB to guesstimate
--								how fast your restores will go. If you have done performance
--								tuning and testing of your backups (or if they horribly go even
--								slower in your DR environment, and you want to account for
--								that), then you can pass in different numbers here.
--	@RestoreSpeedDiffMBps INT	See above.
--	@RestoreSpeedLogMBps INT	See above.

DECLARE @VersionDate DATE;
EXEC dbo.sp_BlitzBackups @Help = 0,                           -- tinyint
                         @HoursBack = 168,                      -- int
                         --@MSDBName = N'',                     -- nvarchar(256)
                         --@AGName = N'',                       -- nvarchar(256)
                         @RestoreSpeedFullMBps = 0,           -- int
                         @RestoreSpeedDiffMBps = 0,           -- int
                         @RestoreSpeedLogMBps = 0,            -- int
                         @Debug = 0,                          -- tinyint
                         @PushBackupHistoryToListener = NULL, -- bit
                         --@WriteBackupsToListenerName = N'',   -- nvarchar(256)
                         --@WriteBackupsToDatabaseName = N'',   -- nvarchar(256)
                         @WriteBackupsLastHours = 0,          -- int
                         @VersionDate = @VersionDate OUTPUT   -- date
