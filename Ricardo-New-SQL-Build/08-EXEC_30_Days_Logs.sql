USE [master]
GO
-- ****************************************
-- KEEP 30 DAYS OF SQL ERROR LOGS
-- ****************************************
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'NumErrorLogs', REG_DWORD, 30
GO
