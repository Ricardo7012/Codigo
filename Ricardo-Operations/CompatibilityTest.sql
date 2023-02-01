USE [HSP_MO]
GO
-- 120
SET STATISTICS IO ON
GO
ALTER DATABASE HSP_MO
SET COMPATIBILITY_LEVEL = 120
GO
USE [HSP_MO]
GO
SELECT [AuditID]
      ,[ProductName]
      ,[ProcedureName]
      ,[UserID]
      ,[DateLogged]
      ,[SQLString]
      ,[SessionId]
  FROM [dbo].[AuditTrail]
GO
SET STATISTICS IO OFF
GO

-- 130
SET STATISTICS IO ON
GO
ALTER DATABASE HSP_MO
SET COMPATIBILITY_LEVEL = 130
GO
SELECT [AuditID]
      ,[ProductName]
      ,[ProcedureName]
      ,[UserID]
      ,[DateLogged]
      ,[SQLString]
      ,[SessionId]
  FROM [dbo].[AuditTrail]
GO
SET STATISTICS IO OFF
GO


