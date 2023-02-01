-- Check Percent when Backup is Complete

-- Get spid running backup
sp_who2 active

SELECT start_time
		, percent_complete
FROM sys.dm_exec_requests 
WHERE session_id = 58 -- Add spid here who's doing the backup