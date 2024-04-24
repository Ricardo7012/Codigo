USE DBAKit
/*
    To run this, you also need to install:
    - sp_whoisactive
    - sp_blitzfirst
    - sp_blitzlock
*/
-- Raises an error if you run the whole script in error
RAISERROR ('Dont run it all at once',20,-1) WITH LOG
-- sp_whoisactive with various parameters
EXEC sp_whoisactive @find_block_leaders = 1 --,@get_locks = 1
EXEC sp_whoisactive @sort_order = 'sql_text' -- Tells at a glance if you have a lot of the same query running. For the F5 report runner troublemakers
-- What has been hurting us in the last 5 seconds. Look for wait stats, and anything out of the ordinary, such as the plan cache has been recently erased.
EXEC dbo.sp_BlitzFirst @expertmode = 1
-- Are we experiencing deadlocks 
EXEC sp_BlitzLock
-- Deadlocks in last hour
DECLARE    @StartDateBlitz datetime = (SELECT DATEADD(HH,-1,GETDATE())), @EndDateBlitz DATETIME = (SELECT GETDATE())
EXEC sp_BlitzLock @EndDate = @EndDateBlitz, @StartDate = @StartDateBlitz
GO
/*  Some other things to consider
    Have the usual optimisation jobs run as expected. Stats/indexes etc
    If one proc has regressed badly, could it help to clear only that plan from the cache or to recompile it.
    EXEC sp_blitz -- Although not as handy as the others for real time issues. Better used as a health check
    EXEC sp_blitzcache -- More useful for helping you identify the resource hungry queries, allowing you 
    EXEC sp_readerrorlog 0,1, 'memory'
*/