
USE [master]
GO
ALTER DATABASE WSS_Content_Main SET EMERGENCY;   
GO
ALTER DATABASE WSS_Content_Main SET SINGLE_USER;  
GO
RESTORE DATABASE [WSS_Content_Main] FROM  DISK = N'E:\MSSQLData\Backup\SPDB1\WSS_Content_Main\FULL\SPDB1_WSS_Content_Main_FULL_20161102_165405.bak' 
WITH  FILE = 1,  
MOVE N'WSS_Content_8090_log' 
TO N'L:\MSSQL\Data\WSS_Content_Main_log.ldf',  
NOUNLOAD,  REPLACE,  STATS = 5
GO

ALTER DATABASE WSS_Content_Main SET MULTI_USER;  
GO

SELECT name, physical_name AS CurrentLocation, state_desc  
FROM sys.master_files 

--DBCC CHECKDB (WSS_Content_Main, REPAIR_ALLOW_DATA_LOSS) 
--WITH NO_INFOMSGS, ALL_ERRORMSGS;

