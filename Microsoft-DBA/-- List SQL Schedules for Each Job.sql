-- List SQL Schedules for Each Job

USE msdb
GO

SELECT j.NAME AS 'Job Name'
	, SUSER_SNAME(j.owner_sid) AS 'Job Owner'
	, (
		SELECT COUNT(step_id)
		FROM dbo.sysjobsteps
		WHERE job_id = j.job_id
		) AS 'Number of Steps'
	, (
		SELECT COUNT(step_id)
		FROM dbo.sysjobsteps
		WHERE job_id = j.job_id
			AND command LIKE '%xp_cmdshell%'
		) AS 'Has XPCMDShell'
	, (
		SELECT COUNT(step_id)
		FROM dbo.sysjobsteps
		WHERE job_id = j.job_id
			AND command LIKE '%msdb%job%'
		) AS 'Has JobStartStopUpdate'
	, (
		SELECT COUNT(step_id)
		FROM dbo.sysjobsteps
		WHERE job_id = j.job_id
			AND command LIKE '%ftp%'
		) AS 'Has FTP'
	, 'Job Enabled' = CASE j.Enabled
		WHEN 1
			THEN 'Yes'
		WHEN 0
			THEN 'No'
		END
	, 'Frequency' = CASE s.freq_type
		WHEN 1
			THEN 'Once'
		WHEN 4
			THEN 'Daily'
		WHEN 8
			THEN 'Weekly'
		WHEN 16
			THEN 'Monthly'
		WHEN 32
			THEN 'Monthly relative'
		WHEN 64
			THEN 'When SQLServer Agent starts'
		END
	, CASE (s.freq_subday_interval)
		WHEN 0
			THEN 'Once'
		ELSE cast('Every ' + right(s.freq_subday_interval, 2) + ' ' + CASE (s.freq_subday_type)
					WHEN 1
						THEN 'Once'
					WHEN 4
						THEN 'Minutes'
					WHEN 8
						THEN 'Hours'
					END AS CHAR(16))
		END AS 'Subday Frequency'
	, 'Next Start Date' = CONVERT(DATETIME, RTRIM(NULLIF(js.next_run_date, 0)) + ' ' + STUFF(STUFF(REPLACE(STR(RTRIM(js.next_run_time), 6, 0), ' ', '0'), 3, 0, ':'), 6, 0, ':'))
	, 'Max Duration' = STUFF(STUFF(REPLACE(STR(maxdur.run_duration, 7, 0), ' ', '0'), 4, 0, ':'), 7, 0, ':')
	, 'Last Run Duration' = STUFF(STUFF(REPLACE(STR(lastrun.run_duration, 7, 0), ' ', '0'), 4, 0, ':'), 7, 0, ':')
	, 'Last Start Date' = CONVERT(DATETIME, RTRIM(lastrun.run_date) + ' ' + STUFF(STUFF(REPLACE(STR(RTRIM(lastrun.run_time), 6, 0), ' ', '0'), 3, 0, ':'), 6, 0, ':'))
	, 'Last Run Message' = lastrun.message
FROM dbo.sysjobs j
LEFT JOIN dbo.sysjobschedules js
	ON j.job_id = js.job_id
LEFT JOIN dbo.sysschedules s
	ON js.schedule_id = s.schedule_id
LEFT JOIN (
	SELECT job_id
		, max(run_duration) AS run_duration
	FROM dbo.sysjobhistory
	GROUP BY job_id
	) maxdur
	ON j.job_id = maxdur.job_id
INNER JOIN (
	SELECT j1.job_id
		, j1.run_duration
		, j1.run_date
		, j1.run_time
		, j1.message
	FROM dbo.sysjobhistory j1
	WHERE instance_id = (
			SELECT MAX(instance_id)
			FROM dbo.sysjobhistory j2
			WHERE j2.job_id = j1.job_id
			)
	) lastrun
	ON j.job_id = lastrun.job_id
ORDER BY [Job Name]
