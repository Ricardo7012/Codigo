-- List SQL Jobs and Last Status

IF CONVERT(TINYINT, (SUBSTRING(CONVERT(CHAR(1), SERVERPROPERTY('productversion')), 1, 1))) <> 8
BEGIN
	---This is for SQL 2k5 and SQL2k8 servers
	SET NOCOUNT ON

	SELECT Convert(VARCHAR(20), SERVERPROPERTY('ServerName')) AS 'Server Name'
		, j.NAME AS 'Job Name'
--		, j.job_id
		, CASE j.enabled
			WHEN 1
				THEN 'Enabled'
			ELSE 'Disabled'
			END AS 'Job Status'
		, CASE jh.run_status
			WHEN 0
				THEN 'Error Failed'
			WHEN 1
				THEN 'Succeeded'
			WHEN 2
				THEN 'Retry'
			WHEN 3
				THEN 'Cancelled'
			WHEN 4
				THEN 'In Progress'
			ELSE 'Status Unknown'
			END AS 'Last Run Status'
		, ja.run_requested_date AS 'Last Run Date'
		, CONVERT(VARCHAR(10), CONVERT(DATETIME, RTRIM(19000101)) + (jh.run_duration * 9 + jh.run_duration % 10000 * 6 + jh.run_duration % 100 * 10) / 216e4, 108) AS 'Run Duration'
		, ja.next_scheduled_run_date AS 'Next Scheduled Run Date'
		, CONVERT(VARCHAR(500), jh.message) AS 'Step Description'
	FROM (
		msdb.dbo.sysjobactivity ja LEFT JOIN msdb.dbo.sysjobhistory jh
			ON ja.job_history_id = jh.instance_id
		)
	INNER JOIN msdb.dbo.sysjobs_view j
		ON ja.job_id = j.job_id
	WHERE ja.session_id = (
			SELECT MAX(session_id)
			FROM msdb.dbo.sysjobactivity
			)
	ORDER BY 2
		, 3
END
ELSE
BEGIN
	--This is for SQL2k servers
	SET NOCOUNT ON

	DECLARE @SQL VARCHAR(5000)

	--Getting information from sp_help_job to a temp table
	SET @SQL = 'SELECT job_id,name AS job_name,CASE enabled WHEN 1 THEN ''Enabled'' ELSE ''Disabled'' END AS job_status,
CASE last_run_outcome WHEN 0 THEN ''Error Failed''
                WHEN 1 THEN ''Succeeded''
                WHEN 2 THEN ''Retry''
                WHEN 3 THEN ''Cancelled''
                WHEN 4 THEN ''In Progress'' ELSE
                ''Status Unknown'' END AS  last_run_status,
CASE RTRIM(last_run_date) WHEN 0 THEN 19000101 ELSE last_run_date END last_run_date,
CASE RTRIM(last_run_time) WHEN 0 THEN 235959 ELSE last_run_time END last_run_time,
CASE RTRIM(next_run_date) WHEN 0 THEN 19000101 ELSE next_run_date END next_run_date,
CASE RTRIM(next_run_time) WHEN 0 THEN 235959 ELSE next_run_time END next_run_time,
last_run_date AS lrd, last_run_time AS lrt
INTO ##jobdetails
FROM OPENROWSET(''sqloledb'', ''server=(local);trusted_connection=yes'', ''set fmtonly off exec msdb.dbo.sp_help_job'')'

	EXEC (@SQL)

	--Merging run date & time format, adding run duration and adding step description
	SELECT Convert(VARCHAR(20), SERVERPROPERTY('ServerName')) AS ServerName
		, jd.job_name
		, jd.job_status
		, jd.last_run_status
		, CONVERT(DATETIME, RTRIM(jd.last_run_date)) + (jd.last_run_time * 9 + jd.last_run_time % 10000 * 6 + jd.last_run_time % 100 * 10) / 216e4 AS last_run_date
		, CONVERT(VARCHAR(10), CONVERT(DATETIME, RTRIM(19000101)) + (jh.run_duration * 9 + jh.run_duration % 10000 * 6 + jh.run_duration % 100 * 10) / 216e4, 108) AS run_duration
		, CONVERT(DATETIME, RTRIM(jd.next_run_date)) + (jd.next_run_time * 9 + jd.next_run_time % 10000 * 6 + jd.next_run_time % 100 * 10) / 216e4 AS next_scheduled_run_date
		, CONVERT(VARCHAR(500), jh.message) AS step_description
	FROM (
		##jobdetails jd LEFT JOIN msdb.dbo.sysjobhistory jh
			ON jd.job_id = jh.job_id
				AND jd.lrd = jh.run_date
				AND jd.lrt = jh.run_time
		)
	WHERE step_id = 0
		OR step_id IS NULL
	ORDER BY jd.job_name
		, jd.job_status

	--dropping the temp table
	DROP TABLE ###jobdetails
END
