-- List Show Plan for SQL Queries

SET SHOWPLAN_ALL ON
GO

EXEC Proc_PDISync_PlayerBalanceDelete 1, 1
GO

SET SHOWPLAN_ALL OFF
GO


