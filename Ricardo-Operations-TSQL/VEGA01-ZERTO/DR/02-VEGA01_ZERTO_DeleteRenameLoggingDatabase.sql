/***********************************************************************
DROP AVAILABILITY GROUP  ONLY IF NOT FAILING BACK TO RIVERSIDE
************************************************************************/
DROP AVAILABILITY GROUP [AGVEGA01]
GO
/***********************************************************************
DROP AVAILABILITY GROUP  ONLY IF NOT FAILING BACK TO RIVERSIDE
************************************************************************/


/***********************************************************************
DELETE LOGGING DATABASE
************************************************************************/
--EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'Logging'
--GO
USE [master]
GO
ALTER DATABASE [Logging] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
DROP DATABASE [Logging]
GO

/***********************************************************************
RENAME LOGGING_DR DATABASE TO LOGGING
************************************************************************/
USE master 
GO
ALTER DATABASE [Logging_DR] MODIFY NAME = [Logging]
GO

ALTER DATABASE [Logging] SET  MULTI_USER 
GO