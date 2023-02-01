-- List SQL Job Schedule

USE MSDB
GO

SELECT DISTINCT substring(a.NAME, 1, 100) AS 'Job Name'
	, 'Enabled' = CASE 
		WHEN a.enabled = 0
			THEN 'No'
		WHEN a.enabled = 1
			THEN 'Yes'
		END
	, substring(b.NAME, 1, 50) AS 'Name of the schedule'
	, 'Frequency of the Schedule Execution' = CASE 
		WHEN b.freq_type = 1
			THEN 'Once'
		WHEN b.freq_type = 4
			THEN 'Daily'
		WHEN b.freq_type = 8
			THEN 'Weekly'
		WHEN b.freq_type = 16
			THEN 'Monthly'
		WHEN b.freq_type = 32
			THEN 'Monthly relative'
		WHEN b.freq_type = 32
			THEN 'Execute when SQL Server Agent starts'
		END
	, 'Units for the Freq SubDay Interval' = CASE 
		WHEN b.freq_subday_type = 1
			THEN 'At the specified time'
		WHEN b.freq_subday_type = 2
			THEN 'Seconds'
		WHEN b.freq_subday_type = 4
			THEN 'Minutes'
		WHEN b.freq_subday_type = 8
			THEN 'Hours'
		END
	, cast(cast(b.active_start_date AS VARCHAR(15)) AS DATETIME) AS 'Active Start Date'
	, cast(cast(b.active_end_date AS VARCHAR(15)) AS DATETIME) AS 'Active End Date'
	, Stuff(Stuff(right('000000' + Cast(c.next_run_time AS VARCHAR), 6), 3, 0, ':'), 6, 0, ':') AS 'Run Time'
	, convert(VARCHAR(24), b.date_created) AS 'Created Date'
FROM msdb.dbo.sysjobs a
INNER JOIN msdb.dbo.sysJobschedules c
	ON a.job_id = c.job_id
INNER JOIN msdb.dbo.SysSchedules b
	ON b.Schedule_id = c.Schedule_id
GO


