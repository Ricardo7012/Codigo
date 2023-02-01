--*********************************************************
-- PRIMARY NODE
--*********************************************************
ALTER AVAILABILITY GROUP QVHAHSP02 REMOVE DATABASE [HSP_MO]

--*********************************************************
-- CHANGE CONNECTION TO SECONDARY NODE
--*********************************************************
EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'HSP_MO'
GO
USE [master]
GO
DROP DATABASE [HSP_MO]
GO
--*********************************************************
-- CONNECT TO THE SERVER INSTANCE THAT HOSTS THE PRIMARY REPLICA.  
-- ADD AN EXISTING DATABASE TO THE AVAILABILITY GROUP.  
--*********************************************************
USE [master]
GO
ALTER DATABASE [HSP_MO] SET RECOVERY FULL WITH NO_WAIT
GO
--PERFORM A FULL BACKUP VIA QUEST LITESPEED
ALTER AVAILABILITY GROUP QVHAHSP02 ADD DATABASE [HSP_MO];  
GO  
