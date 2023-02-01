--LOCATION OF SQL SERVER ERROR LOG FILE 
USE master
GO
SELECT @@ServerName AS SN
GO

xp_readerrorlog 0, 1, N'Logging SQL Server messages in file', NULL, NULL, NULL 
GO
