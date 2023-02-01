USE msdb ;  
GO  

EXEC dbo.sp_help_category  
    @type = N'LOCAL' ;  
GO  

USE msdb ;  
GO   
EXEC dbo.sp_delete_category  
    @name = N'IEHP_CycleErrorLogsDaily.12am',  
    @class = N'JOB' ;  
GO  