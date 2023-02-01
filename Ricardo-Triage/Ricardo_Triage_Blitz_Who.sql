-- https://www.brentozar.com/first-aid/sp_blitzwho/

DECLARE @VersionDate DATETIME;
EXEC master.dbo.sp_BlitzWho @Help = 0,                         -- tinyint
                            @ShowSleepingSPIDs = 0,            -- tinyint
                            @ExpertMode = 1,                -- bit
                            @Debug = NULL,                     -- bit
                            @VersionDate = @VersionDate OUTPUT -- datetime
