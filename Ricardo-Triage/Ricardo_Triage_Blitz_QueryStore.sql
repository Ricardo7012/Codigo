-- https://www.brentozar.com/first-aid/sp_blitzquerystore/
--@DatabaseName NVARCHAR(128) — Database you want to look at Query Store for
--@Top INT — How many plans per metric you want to bring back
--@StartDate DATETIME2 — Start range of data to examine (if NULL, will go back seven days
--@EndDate DATETIME2 — End range of data to examine (if NULL, will default to today’s date, though this changes if @StartDate isn’t NULL)
--@MinimumExecutionCount INT — Minimum number of executions a query must have before being analyzed
--@DurationFilter DECIMAL(38,4) — Minimum length in seconds a query has to run for before being analyzed
--@StoredProcName NVARCHAR(128) — If you want to look for a particular stored procedure
--@Failed BIT — If you want to look for only failed queries
--@ExportToExcel BIT — Backwards compatibility, skips the generalized warnings, doesn’t display query plan xml, and cleans/truncates query text
--@HideSummary BIT — Hides the general warnings table
--@SkipXML BIT — Skips XML analysis entirely, just returns unanalyzed plans
--@Debug BIT — Prints out any dynamic SQL used for debugging

--Ways to run this thing


--Debug
EXEC sp_BlitzQueryStore @DatabaseName = 'HSP_Supplemental', @Debug = 1

--Get the top 1
EXEC sp_BlitzQueryStore @DatabaseName = 'HSP_Supplemental', @Top = 1, @Debug = 1

--Use a StartDate												 
EXEC sp_BlitzQueryStore @DatabaseName = 'HSP_Supplemental', @Top = 1, @StartDate = '20180801'
				
--Use an EndDate												 
EXEC sp_BlitzQueryStore @DatabaseName = 'HSP_Supplemental', @Top = 1, @EndDate = '20170527'
				
--Use Both												 
EXEC sp_BlitzQueryStore @DatabaseName = 'HSP_Supplemental', @Top = 1, @StartDate = '20170526', @EndDate = '20170527'

--Set a minimum execution count												 
EXEC sp_BlitzQueryStore @DatabaseName = 'HSP_Supplemental', @Top = 1, @MinimumExecutionCount = 10

--Set a duration minimum
EXEC sp_BlitzQueryStore @DatabaseName = 'HSP_Supplemental', @Top = 1, @DurationFilter = 5

--Look for a stored procedure name (that doesn't exist!)
EXEC sp_BlitzQueryStore @DatabaseName = 'HSP_Supplemental', @Top = 1, @StoredProcName = 'blah'

--Look for a stored procedure name that does (at least On My Computer®)
EXEC sp_BlitzQueryStore @DatabaseName = 'HSP_Supplemental', @Top = 1, @StoredProcName = 'UserReportExtended'

--Look for failed queries
EXEC sp_BlitzQueryStore @DatabaseName = 'HSP_Supplemental', @Top = 1, @Failed = 1

--Filter by plan_id
EXEC sp_BlitzQueryStore @DatabaseName = 'HSP_Supplemental', @PlanIdFilter = 3356

--Filter by query_id
EXEC sp_BlitzQueryStore @DatabaseName = 'HSP_Supplemental', @QueryIdFilter = 2958
