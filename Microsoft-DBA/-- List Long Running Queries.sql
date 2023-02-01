-- List Long Running Queries

DECLARE @HistoryStartDate DATETIME
DECLARE @HistoryEndDate DATETIME
DECLARE @MinHistExecutions INT
DECLARE @MinAvgSecsDuration INT

SET @HistoryStartDate = '19000101'
SET @HistoryEndDate = GETDATE()
SET @MinHistExecutions = 1.0
SET @MinAvgSecsDuration = 1.0

DECLARE @currently_running_jobs TABLE (
	job_id UNIQUEIDENTIFIER NOT NULL
	,last_run_date INT NOT NULL
	,last_run_time INT NOT NULL
	,next_run_date INT NOT NULL
	,next_run_time INT NOT NULL
	,next_run_schedule_id INT NOT NULL
	,requested_to_run INT NOT NULL
	,request_source INT NOT NULL
	,request_source_id SYSNAME NULL
	,running INT NOT NULL
	,current_step INT NOT NULL
	,current_retry_attempt INT NOT NULL
	,job_state INT NOT NULL
	)

-- Capture Details on Jobs
INSERT INTO @currently_running_jobs
EXECUTE master.dbo.xp_sqlagent_enum_jobs 1
	,'';

WITH JobHistData
AS (
	SELECT job_id
		,date_executed = msdb.dbo.agent_datetime(run_date, run_time)
		,secs_duration = run_duration / 10000 * 3600 + run_duration % 10000 / 100 * 60 + run_duration % 100
	FROM msdb.dbo.sysjobhistory
	WHERE step_id = 0		  -- Job Outcome
		AND run_status = 1	  -- Succeeded
	)
	,JobHistStats
AS (
	SELECT job_id
		,AvgDuration = AVG(secs_duration * 1.)
		,AvgPlus2StDev = AVG(secs_duration * 1.) + 2 * stdevp(secs_duration)
	FROM JobHistData
	WHERE date_executed >= DATEADD(day, DATEDIFF(day, '19000101', @HistoryStartDate), '19000101') AND date_executed < DATEADD(day, 1 + DATEDIFF(day, '19000101', @HistoryEndDate), '19000101')
	GROUP BY job_id
	HAVING COUNT(*) >= @MinHistExecutions AND AVG(secs_duration * 1.) >= @MinAvgSecsDuration
	)
SELECT jd.job_id AS 'Job ID'
	,j.NAME AS 'Job Name'
	,MAX(act.start_execution_date) AS 'Execution Date'
	,AvgDuration AS 'Historical Avg Duration (Sec)'
	,AvgPlus2StDev AS 'Min Threshhold (Sec)'
FROM JobHistData jd
INNER JOIN JobHistStats jhs
	ON jd.job_id = jhs.job_id
INNER JOIN msdb..sysjobs j
	ON jd.job_id = j.job_id
INNER JOIN @currently_running_jobs crj
	ON crj.job_id = jd.job_id
INNER JOIN msdb..sysjobactivity AS act
	ON act.job_id = jd.job_id AND act.stop_execution_date IS NULL AND act.start_execution_date IS NOT NULL
WHERE secs_duration > AvgPlus2StDev AND DATEDIFF(SS, act.start_execution_date, GETDATE()) > AvgPlus2StDev AND crj.job_state = 1
GROUP BY jd.job_id
	,j.NAME
	,AvgDuration
	,AvgPlus2StDev
