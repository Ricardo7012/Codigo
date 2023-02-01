-- creates a local job category named AdminJobs   
-- https://docs.microsoft.com/en-us/sql/ssms/agent/create-a-job-category
USE msdb ;  
GO  
EXEC dbo.sp_add_category  
    @class=N'JOB',  
    @type=N'LOCAL',  
    @name=N'DBAJobs' ;  
GO  

USE msdb ;  
GO  

EXEC dbo.sp_help_category  
    @type = N'LOCAL' ;  
GO  
