-- Disable Jobs By Job Name

DECLARE @JobName nvarchar(25)
DECLARE @Enabled bit

SET @JobName = 'IGT_%'
SET @Enabled = 0 

SELECT NAME AS 'Job Name'
	, enabled AS 'Enabled'
	, description AS 'Description'
FROM msdb.dbo.sysjobs job
INNER JOIN msdb.dbo.sysjobsteps steps
	ON job.job_id = steps.job_id
WHERE job.enabled = @Enabled
AND NAME LIKE @JobName -- 'IGT_%'

--UPDATE MSDB.dbo.sysjobs
--SET Enabled = @Enabled
--WHERE NAME LIKE 'IGT_%'
--GO

--UPDATE MSDB.dbo.sysjobs
--SET Enabled = @Enabled
--WHERE [Name] LIKE 'IGT_%'
--GO


