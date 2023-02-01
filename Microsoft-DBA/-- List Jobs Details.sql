-- List Jobs Details

DECLARE @num_days INT
DECLARE @first_day DATETIME
	, @last_day DATETIME
DECLARE @first_num INT
DECLARE @job_id UNIQUEIDENTIFIER

IF @num_days IS NULL
	SET @num_days = 30
SET @last_day = getdate()
SET @first_day = dateadd(dd, - @num_days, @last_day)

SELECT @first_num = cast(year(@first_day) AS CHAR(4)) + replicate('0', 2 - len(month(@first_day))) + cast(month(@first_day) AS VARCHAR(2)) + replicate('0', 2 - len(day(@first_day))) + cast(day(@first_day) AS VARCHAR(2))
	--Basic Job Information  
	;

WITH cte
AS (
	SELECT A.job_id
		, B.NAME
		, B.enabled
		,
		/* -- Only for later version of SQL Server 2005 */
		msdb.dbo.SQLAGENT_SUSER_SNAME(b.owner_sid) 'Job Owner'
		, (
			SELECT TOP 1 next_scheduled_run_date
			FROM msdb.dbo.sysjobactivity
			WHERE job_id = A.job_id
			ORDER BY session_id DESC
			) AS 'NextRunDateTime'
		, msdb.dbo.agent_datetime(last_run_date, last_run_time) AS 'LastRunDateTime'
		, CASE last_run_outcome
			WHEN 0
				THEN 'Failed'
			WHEN 1
				THEN 'Succeeded'
			WHEN 2
				THEN 'Retry'
			WHEN 3
				THEN 'Cancelled'
			ELSE 'NA'
			END Last_Run_Status
		, last_run_duration
		, CASE 
			WHEN (len(cast(last_run_duration AS VARCHAR(20))) < 3)
				THEN cast(last_run_duration AS VARCHAR(6))
			WHEN (len(cast(last_run_duration AS VARCHAR(20))) = 3)
				THEN LEFT(cast(last_run_duration AS VARCHAR(6)), 1) * 60 + RIGHT(cast(last_run_duration AS VARCHAR(6)), 2)
			WHEN (len(cast(last_run_duration AS VARCHAR(20))) = 4)
				THEN LEFT(cast(last_run_duration AS VARCHAR(6)), 2) * 60 + RIGHT(cast(last_run_duration AS VARCHAR(6)), 2)
			WHEN (len(cast(last_run_duration AS VARCHAR(20))) >= 5)
				THEN (Left(cast(last_run_duration AS VARCHAR(20)), len(last_run_duration) - 4)) * 3600 + (substring(cast(last_run_duration AS VARCHAR(20)), len(last_run_duration) - 3, 2)) * 60 + Right(cast(last_run_duration AS VARCHAR(20)), 2)
			END AS 'Last_RunDuration'
		, CONVERT(DATETIME, RTRIM(last_run_date)) + ((last_run_time + last_run_duration) * 9 + (last_run_time + last_run_duration) % 10000 * 6 + (last_run_time + last_run_duration) % 100 * 10) / 216e4 AS Last_RunFinishDateTime
		, CASE last_run_outcome
			WHEN 1
				THEN Left(Replace(last_outcome_message, 'The job succeeded.  The Job was invoked by', ''), Charindex('.', Replace(last_outcome_message, 'The job succeeded.  The Job was invoked by', '')))
			WHEN 0
				THEN Left(Replace(last_outcome_message, 'The job failed.  The Job was invoked by', ''), Charindex('.', Replace(last_outcome_message, 'The job failed.  The Job was invoked by', '')))
			WHEN 3
				THEN Left(Replace(last_outcome_message, 'The job was stopped prior to completion by ', ''), Charindex('.', Replace(last_outcome_message, 'The job was stopped prior to completion by ', '')))
			END 'LastInvokedBy'
		, CASE last_run_outcome
			WHEN 3
				THEN Left(Replace(last_outcome_message, 'The job failed.  The Job was invoked by', ''), Charindex('.', Replace(last_outcome_message, 'The job failed.  The Job was invoked by', '')))
			ELSE ''
			END 'Cancelled/Stopped By'
		, last_outcome_message 'Message'
	FROM msdb.dbo.SysJobServers A
	INNER JOIN msdb.dbo.sysjobs B
		ON A.job_id = B.job_id
	LEFT JOIN msdb.dbo.sysjobschedules D
		ON A.job_id = D.job_id
	WHERE (
			(
				A.job_id = @job_id
				AND @Job_id IS NOT NULL
				)
			OR (
				1 = 1
				AND @Job_id IS NULL
				)
			)
		AND ISNULL(last_run_date, 0) <> 0
		AND ISNULL(next_run_date, 0) <> 0
	)
SELECT Job_id
	, NAME AS 'Job_Name'
	, Enabled
	, [Job Owner]
	, LastRunDateTime
	, Last_Run_Status
	, Right('00' + cast(Last_RunDuration / 3600 AS VARCHAR(10)), 2) + ':' + replicate('0', 2 - len((Last_RunDuration % 3600) / 60)) + cast((Last_RunDuration % 3600) / 60 AS VARCHAR(2)) + ':' + replicate('0', 2 - len((Last_RunDuration % 3600) % 60)) + cast((Last_RunDuration % 3600) % 60 AS VARCHAR(2)) 'Last_RunDuration'
	, Last_RunFinishDateTime
	, NextRunDateTime
	, LastInvokedBy
	, [Cancelled/Stopped By]
	, Message
FROM cte
ORDER BY NAME
	-- Job Hitstory Analysis
	;

WITH Cte
AS (
	SELECT jobhist.job_id
		, jobs.NAME
		, jobhist.step_id
		, run_dur_Casted = CASE 
			WHEN (len(cast(jobhist.run_duration AS VARCHAR(20))) < 3)
				THEN cast(jobhist.run_duration AS VARCHAR(6))
			WHEN (len(cast(jobhist.run_duration AS VARCHAR(20))) = 3)
				THEN LEFT(cast(jobhist.run_duration AS VARCHAR(6)), 1) * 60 + RIGHT(cast(jobhist.run_duration AS VARCHAR(6)), 2)
			WHEN (len(cast(jobhist.run_duration AS VARCHAR(20))) = 4)
				THEN LEFT(cast(jobhist.run_duration AS VARCHAR(6)), 2) * 60 + RIGHT(cast(jobhist.run_duration AS VARCHAR(6)), 2)
			WHEN (len(cast(jobhist.run_duration AS VARCHAR(20))) >= 5)
				THEN (Left(cast(jobhist.run_duration AS VARCHAR(20)), len(jobhist.run_duration) - 4)) * 3600 + (substring(cast(jobhist.run_duration AS VARCHAR(20)), len(jobhist.run_duration) - 3, 2)) * 60 + Right(cast(jobhist.run_duration AS VARCHAR(20)), 2)
			END
	FROM msdb.dbo.sysjobhistory jobhist
	INNER JOIN msdb.dbo.sysjobs jobs
		ON jobhist.job_id = jobs.job_id
	WHERE jobhist.job_id = jobs.job_id
		AND jobhist.run_date >= @first_num
		AND jobhist.step_id = 0
		AND (
			(
				jobs.job_id = @job_id
				AND @Job_id IS NOT NULL
				)
			OR (
				1 = 1
				AND @Job_id IS NULL
				)
			)
	)
	, cte1
AS (
	SELECT jobs.job_id
		, jobs.NAME
		, 'Sampling' = (
			SELECT count(*)
			FROM cte jobhist
			WHERE jobhist.job_id = jobs.job_id
			)
		, 'run_dur_max' = (
			SELECT max(run_dur_Casted)
			FROM cte jobhist
			WHERE jobhist.job_id = jobs.job_id
			)
		, 'run_dur_min' = (
			SELECT min(run_dur_Casted)
			FROM cte jobhist
			WHERE jobhist.job_id = jobs.job_id
			)
		, 'run_dur_avg' = (
			SELECT avg(run_dur_Casted)
			FROM cte jobhist
			WHERE jobhist.job_id = jobs.job_id
			)
	FROM msdb..sysjobs jobs
	WHERE (
			(
				jobs.job_id = @job_id
				AND @Job_id IS NOT NULL
				)
			OR (
				1 = 1
				AND @Job_id IS NULL
				)
			)
	)
SELECT job_id
	, NAME
	, 'Avg Duration (hh:mm:ss)' = cast(run_dur_avg / 3600 AS VARCHAR(10)) + ':' + replicate('0', 2 - len((run_dur_avg % 3600) / 60)) + cast((run_dur_avg % 3600) / 60 AS VARCHAR(2)) + ':' + replicate('0', 2 - len((run_dur_avg % 3600) % 60)) + cast((run_dur_avg % 3600) % 60 AS VARCHAR(2))
	, 'Max Duration (hh:mm:ss)' = cast(run_dur_max / 3600 AS VARCHAR(10)) + ':' + replicate('0', 2 - len((run_dur_max % 3600) / 60)) + cast((run_dur_max % 3600) / 60 AS VARCHAR(2)) + ':' + replicate('0', 2 - len((run_dur_max % 3600) % 60)) + cast((run_dur_max % 3600) % 60 AS VARCHAR(2))
	, 'Min Duration (hh:mm:ss)' = cast(run_dur_min / 3600 AS VARCHAR(10)) + ':' + replicate('0', 2 - len((run_dur_min % 3600) / 60)) + cast((run_dur_min % 3600) / 60 AS VARCHAR(2)) + ':' + replicate('0', 2 - len((run_dur_min % 3600) % 60)) + cast((run_dur_min % 3600) % 60 AS VARCHAR(2))
	, Sampling
FROM cte1
ORDER BY NAME
	--Step wise info 
	;

WITH cteJobStep
AS (
	SELECT B.NAME 'Parent Job Name'
		, step_id
		, step_name
		, subsystem
		, msdb.dbo.agent_datetime(last_run_date, last_run_time) AS 'RunDateTime'
		, CASE 
			WHEN (len(cast(last_run_duration AS VARCHAR(20))) < 3)
				THEN cast(last_run_duration AS VARCHAR(6))
			WHEN (len(cast(last_run_duration AS VARCHAR(20))) = 3)
				THEN LEFT(cast(last_run_duration AS VARCHAR(6)), 1) * 60 + RIGHT(cast(last_run_duration AS VARCHAR(6)), 2)
			WHEN (len(cast(last_run_duration AS VARCHAR(20))) = 4)
				THEN LEFT(cast(last_run_duration AS VARCHAR(6)), 2) * 60 + RIGHT(cast(last_run_duration AS VARCHAR(6)), 2)
			WHEN (len(cast(last_run_duration AS VARCHAR(20))) >= 5)
				THEN (Left(cast(last_run_duration AS VARCHAR(20)), len(last_run_duration) - 4)) * 3600 + (substring(cast(last_run_duration AS VARCHAR(20)), len(last_run_duration) - 3, 2)) * 60 + Right(cast(last_run_duration AS VARCHAR(20)), 2)
			END AS 'Last_RunDuration'
		, CONVERT(DATETIME, RTRIM(last_run_date)) + ((last_run_time + last_run_duration) * 9 + (last_run_time + last_run_duration) % 10000 * 6 + (last_run_time + last_run_duration) % 100 * 10) / 216e4 AS Last_RunFinishDateTime
	FROM msdb.dbo.sysjobsteps A
	INNER JOIN msdb.dbo.sysjobs B
		ON A.job_id = B.job_id
	WHERE (
			(
				A.job_id = @job_id
				AND @Job_id IS NOT NULL
				)
			OR (
				1 = 1
				AND @Job_id IS NULL
				)
			)
		AND ISNULL(last_run_date, 0) <> 0
	)
SELECT [Parent Job Name]
	, step_id
	, step_name
	, subsystem
	, RundateTime
	, Right('00' + cast(Last_RunDuration / 3600 AS VARCHAR(10)), 2) + ':' + replicate('0', 2 - len((Last_RunDuration % 3600) / 60)) + cast((Last_RunDuration % 3600) / 60 AS VARCHAR(2)) + ':' + replicate('0', 2 - len((Last_RunDuration % 3600) % 60)) + cast((Last_RunDuration % 3600) % 60 AS VARCHAR(2)) 'Last_RunDuration'
	, Last_RunFinishDateTime
FROM cteJobStep
ORDER BY [Parent Job Name]

--As per few suggestions from my collegues, I added History details for a job if the job id is passed.
IF (@job_id IS NOT NULL)
BEGIN
		;

	WITH CteJobHistory
	AS (
		SELECT jobs.job_id
			, NAME
			, CASE 
				WHEN run_status = 0
					THEN (
							SELECT TOP 1 message
							FROM msdb.dbo.sysjobhistory A
							WHERE A.job_id = jobs.job_id
								AND A.run_date = jobhist.run_date
								AND A.run_time = jobhist.run_time
								AND step_id = 1
							)
				ELSE jobhist.Message
				END Message
			, msdb.dbo.agent_datetime(run_date, run_time) run_datetime
			, CASE 
				WHEN (len(cast(run_duration AS VARCHAR(20))) < 3)
					THEN cast(run_duration AS VARCHAR(6))
				WHEN (len(cast(run_duration AS VARCHAR(20))) = 3)
					THEN LEFT(cast(run_duration AS VARCHAR(6)), 1) * 60 + RIGHT(cast(run_duration AS VARCHAR(6)), 2)
				WHEN (len(cast(run_duration AS VARCHAR(20))) = 4)
					THEN LEFT(cast(run_duration AS VARCHAR(6)), 2) * 60 + RIGHT(cast(run_duration AS VARCHAR(6)), 2)
				WHEN (len(cast(run_duration AS VARCHAR(20))) >= 5)
					THEN (Left(cast(run_duration AS VARCHAR(20)), len(run_duration) - 4)) * 3600 + (substring(cast(run_duration AS VARCHAR(20)), len(run_duration) - 3, 2)) * 60 + Right(cast(run_duration AS VARCHAR(20)), 2)
				END AS 'RunDuration'
			, CONVERT(DATETIME, RTRIM(run_date)) + ((run_time + run_duration) * 9 + (run_time + run_duration) % 10000 * 6 + (run_time + run_duration) % 100 * 10) / 216e4 AS RunFinishDateTime
			, CASE run_status
				WHEN 0
					THEN 'Failed'
				WHEN 1
					THEN 'Succeeded'
				WHEN 2
					THEN 'Retry'
				WHEN 3
					THEN 'Cancelled'
				ELSE 'NA'
				END Last_Run_Status
		FROM msdb.dbo.sysjobhistory jobhist
		INNER JOIN msdb.dbo.sysjobs jobs
			ON jobhist.job_id = jobs.job_id
		WHERE jobs.job_id = @job_id
			AND step_id = 0
		)
	SELECT job_id
		, NAME
		, message
		, run_datetime
		, Right('00' + cast(RunDuration / 3600 AS VARCHAR(10)), 2) + ':' + replicate('0', 2 - len((RunDuration % 3600) / 60)) + cast((RunDuration % 3600) / 60 AS VARCHAR(2)) + ':' + replicate('0', 2 - len((RunDuration % 3600) % 60)) + cast((RunDuration % 3600) % 60 AS VARCHAR(2)) 'RunDuration'
		, RunFinishDateTime Last_Run_Status
	FROM CteJobHistory
	ORDER BY run_datetime DESC
END
