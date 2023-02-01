-- Check Backup History in MSDB

DECLARE @mindate DATETIME
DECLARE @oldest_date DATETIME
DECLARE @sql VARCHAR(8000)
DECLARE @currdate DATETIME
DECLARE @oldestdate DATETIME -- Find out the oldest date from the Backup Set table

SELECT @mindate = min(backup_start_date)
FROM msdb..backupset

SET @currdate = @mindate + 7
SET @oldestdate = '2009-11-04 00:00:00.000' -- Modify this to the date till which you want your msdb history purged while

-- Begin a while loop to generate the commands to purge the MSDB entries
WHILE (@currdate <= @oldestdate)
BEGIN
	SET @sql = 'EXEC msdb..sp_delete_backuphistory ''' + cast(@currdate AS VARCHAR(20)) + ''''

	PRINT @sql

	SET @sql = 'EXEC msdb..sp_purge_jobhistory @oldest_date = ''' + cast(@currdate AS VARCHAR(20)) + ''''

	PRINT @sql
	PRINT CHAR(13)

	-- Optional if you are running out of space in MSDB
	--print 'use msdb' + char(13) + 'checkpoint'
	-- Increment value and move on to the next date
	SET @currdate = @currdate + 7 -- The time interval can be modified to suit your needs end
END

-- End of while loop
SET @sql = 'EXEC msdb..sp_delete_backuphistory ''' + cast(@oldestdate AS VARCHAR(20)) + ''''

PRINT @sql

SET @sql = 'EXEC msdb..sp_purge_jobhistory @oldest_date = ''' + cast(@oldestdate AS VARCHAR(20)) + ''''

PRINT @sql
