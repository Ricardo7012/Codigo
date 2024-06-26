-- Check Job Status

DECLARE @jobHistory TABLE (
	job_id UNIQUEIDENTIFIER
	, success INT
	, cancel INT
	, fail INT
	, retry INT
	, last_execution_id INT
	, last_duration CHAR(8)
	, last_execution_start DATETIME
	);

WITH lastExecution
AS (
	SELECT job_id
		, MAX(instance_id) AS last_instance_id
	FROM msdb.dbo.sysjobhistory
	WHERE step_id = 0
	GROUP BY job_id
	)
INSERT INTO @jobHistory
SELECT sjh.job_id
	, SUM(CASE 
			WHEN sjh.run_status = 1
				AND step_id = 0
				THEN 1
			ELSE 0
			END) AS success
	, SUM(CASE 
			WHEN sjh.run_status = 3
				AND step_id = 0
				THEN 1
			ELSE 0
			END) AS cancel
	, SUM(CASE 
			WHEN sjh.run_status = 0
				AND step_id = 0
				THEN 1
			ELSE 0
			END) AS fail
	, SUM(CASE 
			WHEN sjh.run_status = 2
				THEN 1
			ELSE 0
			END) AS retry
	, MAX(CASE 
			WHEN sjh.step_id = 0
				THEN instance_id
			ELSE NULL
			END) last_execution_id
	, SUBSTRING(CAST(MAX(CASE 
					WHEN le.job_id IS NOT NULL
						THEN sjh.run_duration
					ELSE NULL
					END) + 1000000 AS VARCHAR(7)), 2, 2) + ':' + SUBSTRING(CAST(MAX(CASE 
					WHEN le.job_id IS NOT NULL
						THEN sjh.run_duration
					ELSE NULL
					END) + 1000000 AS VARCHAR(7)), 4, 2) + ':' + SUBSTRING(CAST(MAX(CASE 
					WHEN le.job_id IS NOT NULL
						THEN sjh.run_duration
					ELSE NULL
					END) + 1000000 AS VARCHAR(7)), 6, 2) AS last_duration
	, MAX(CASE 
			WHEN le.last_instance_id IS NOT NULL
				THEN CONVERT(DATETIME, RTRIM(run_date)) + ((run_time / 10000 * 3600) + ((run_time % 10000) / 100 * 60) + (run_time % 10000) % 100) / (86399.9964)
			ELSE '1900-01-01'
			END) AS last_execution_start
FROM msdb.dbo.sysjobhistory AS sjh
LEFT JOIN lastExecution AS le
	ON sjh.job_id = le.job_id
		AND sjh.instance_id = le.last_instance_id
GROUP BY sjh.job_id;

/* We need to parse the schedule into something we can understand */
DECLARE @weekDay TABLE (
	mask INT
	, maskValue VARCHAR(32)
	);

INSERT INTO @weekDay
SELECT 1
	, 'Sunday'

UNION ALL

SELECT 2
	, 'Monday'

UNION ALL

SELECT 4
	, 'Tuesday'

UNION ALL

SELECT 8
	, 'Wednesday'

UNION ALL

SELECT 16
	, 'Thursday'

UNION ALL

SELECT 32
	, 'Friday'

UNION ALL

SELECT 64
	, 'Saturday';

/* Now let's get our schedule information */
WITH myCTE
AS (
	SELECT sched.NAME AS 'scheduleName'
		, sched.schedule_id
		, jobsched.job_id
		, CASE 
			WHEN sched.freq_type = 1
				THEN 'Once'
			WHEN sched.freq_type = 4
				AND sched.freq_interval = 1
				THEN 'Daily'
			WHEN sched.freq_type = 4
				THEN 'Every ' + CAST(sched.freq_interval AS VARCHAR(5)) + ' days'
			WHEN sched.freq_type = 8
				THEN REPLACE(REPLACE(REPLACE((
									SELECT maskValue
									FROM @weekDay AS x
									WHERE sched.freq_interval & x.mask <> 0
									ORDER BY mask
									FOR XML RAW
									), '"/><row maskValue="', ', '), '<row maskValue="', ''), '"/>', '') + CASE 
						WHEN sched.freq_recurrence_factor <> 0
							AND sched.freq_recurrence_factor = 1
							THEN '; weekly'
						WHEN sched.freq_recurrence_factor <> 0
							THEN '; every ' + CAST(sched.freq_recurrence_factor AS VARCHAR(10)) + ' weeks'
						END
			WHEN sched.freq_type = 16
				THEN 'On day ' + CAST(sched.freq_interval AS VARCHAR(10)) + ' of every ' + CAST(sched.freq_recurrence_factor AS VARCHAR(10)) + ' months'
			WHEN sched.freq_type = 32
				THEN CASE 
						WHEN sched.freq_relative_interval = 1
							THEN 'First'
						WHEN sched.freq_relative_interval = 2
							THEN 'Second'
						WHEN sched.freq_relative_interval = 4
							THEN 'Third'
						WHEN sched.freq_relative_interval = 8
							THEN 'Fourth'
						WHEN sched.freq_relative_interval = 16
							THEN 'Last'
						END + CASE 
						WHEN sched.freq_interval = 1
							THEN ' Sunday'
						WHEN sched.freq_interval = 2
							THEN ' Monday'
						WHEN sched.freq_interval = 3
							THEN ' Tuesday'
						WHEN sched.freq_interval = 4
							THEN ' Wednesday'
						WHEN sched.freq_interval = 5
							THEN ' Thursday'
						WHEN sched.freq_interval = 6
							THEN ' Friday'
						WHEN sched.freq_interval = 7
							THEN ' Saturday'
						WHEN sched.freq_interval = 8
							THEN ' Day'
						WHEN sched.freq_interval = 9
							THEN ' Weekday'
						WHEN sched.freq_interval = 10
							THEN ' Weekend'
						END + CASE 
						WHEN sched.freq_recurrence_factor <> 0
							AND sched.freq_recurrence_factor = 1
							THEN '; monthly'
						WHEN sched.freq_recurrence_factor <> 0
							THEN '; every ' + CAST(sched.freq_recurrence_factor AS VARCHAR(10)) + ' months'
						END
			WHEN sched.freq_type = 64
				THEN 'StartUp'
			WHEN sched.freq_type = 128
				THEN 'Idle'
			END AS 'frequency'
		, ISNULL('Every ' + CAST(sched.freq_subday_interval AS VARCHAR(10)) + CASE 
				WHEN sched.freq_subday_type = 2
					THEN ' seconds'
				WHEN sched.freq_subday_type = 4
					THEN ' minutes'
				WHEN sched.freq_subday_type = 8
					THEN ' hours'
				END, 'Once') AS 'subFrequency'
		, REPLICATE('0', 6 - LEN(sched.active_start_time)) + CAST(sched.active_start_time AS VARCHAR(6)) AS 'startTime'
		, REPLICATE('0', 6 - LEN(sched.active_end_time)) + CAST(sched.active_end_time AS VARCHAR(6)) AS 'endTime'
		, REPLICATE('0', 6 - LEN(jobsched.next_run_time)) + CAST(jobsched.next_run_time AS VARCHAR(6)) AS 'nextRunTime'
		, CAST(jobsched.next_run_date AS CHAR(8)) AS 'nextRunDate'
	FROM msdb.dbo.sysschedules AS sched
	INNER JOIN msdb.dbo.sysjobschedules AS jobsched
		ON sched.schedule_id = jobsched.schedule_id
	WHERE sched.enabled = 1
	)
/* Finally, let's look at our actual jobs and tie it all together */
SELECT CONVERT(NVARCHAR(128), SERVERPROPERTY('Servername')) AS 'Server Name'
	, job.job_id AS 'Job ID'
	, job.NAME AS 'Job Name'
	, CASE 
		WHEN job.enabled = 1
			THEN 'Enabled'
		ELSE 'Disabled'
		END AS 'Job Status'
	, COALESCE(sched.scheduleName, '(unscheduled)') AS 'Schedule Name'
	, COALESCE(sched.frequency, '') AS 'Frequency'
	, COALESCE(sched.subFrequency, '') AS 'sub Frequency'
	, COALESCE(SUBSTRING(sched.startTime, 1, 2) + ':' + SUBSTRING(sched.startTime, 3, 2) + ' - ' + SUBSTRING(sched.endTime, 1, 2) + ':' + SUBSTRING(sched.endTime, 3, 2), '') AS 'Schedule Time'
	, COALESCE(SUBSTRING(sched.nextRunDate, 1, 4) + '/' + SUBSTRING(sched.nextRunDate, 5, 2) + '/' + SUBSTRING(sched.nextRunDate, 7, 2) + ' ' + SUBSTRING(sched.nextRunTime, 1, 2) + ':' + SUBSTRING(sched.nextRunTime, 3, 2), '') AS 'Next Run Date'
	/* Note: the sysjobschedules table refreshes every 20 min, so nextRunDate may be out of date */
	, COALESCE(jh.success, 0) AS 'Success'
	, COALESCE(jh.cancel, 0) AS 'Cancel'
	, COALESCE(jh.fail, 0) AS 'Fail'
	, COALESCE(jh.retry, 0) AS 'Retry'
	, COALESCE(jh.last_execution_id, 0) AS 'Last Execution ID'
	, jh.last_execution_start AS 'Last Execution Start'
	, COALESCE(jh.last_duration, '00:00:01') AS 'Last Duration'
	, 'EXECUTE msdb.dbo.sp_update_job @job_id = ''' + CAST(job.job_id AS CHAR(36)) + ''', @enabled = 0;' AS 'Disable SQL Script'
FROM msdb.dbo.sysjobs AS job
LEFT JOIN myCTE AS sched
	ON job.job_id = sched.job_id
LEFT JOIN @jobHistory AS jh
	ON job.job_id = jh.job_id
WHERE job.enabled = 0 -- do not display disabled jobs
	AND jh.last_execution_start >= DATEADD(day, - 730, GETDATE()) /* Pull just the last 24 hours */
ORDER BY nextRunDate
