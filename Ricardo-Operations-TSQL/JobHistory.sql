USE msdb
go
SELECT j.name AS 'JobName',
       --run_date,
       --run_time,
	   msdb.dbo.agent_datetime(run_date, run_time) AS 'RunDateTime',
       run_duration,
       ((run_duration / 10000 * 3600 + (run_duration / 100) % 100 * 60 + run_duration % 100 + 31) / 60) AS 'RunDurationMinutes',
	   h.message, 
	   h.*
FROM msdb.dbo.sysjobs j
    INNER JOIN msdb.dbo.sysjobhistory h
        ON j.job_id = h.job_id
WHERE j.enabled = 1 --Only Enabled Jobs
AND j.name = 'Extracts - CMC Enrollments'
ORDER BY JobName,
         RunDateTime DESC;
