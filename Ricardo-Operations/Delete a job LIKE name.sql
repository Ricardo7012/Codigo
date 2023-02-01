SELECT @@servername 

DECLARE @jobId binary(16)  

WHILE (1=1)
BEGIN
    SET @jobId = NULL
    SELECT TOP 1 @jobId = job_id FROM msdb.dbo.sysjobs WHERE (name like N'IEHP_Database%') 

    IF @@ROWCOUNT = 0
        BREAK

    IF (@jobId IS NOT NULL) 
    BEGIN     
        EXEC msdb.dbo.sp_delete_job @jobId 
    END 
END