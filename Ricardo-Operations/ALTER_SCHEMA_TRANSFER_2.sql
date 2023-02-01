
USE [HSP_QA1]
GO
ALTER AUTHORIZATION ON SCHEMA::[IEHP\e1003] TO [dbo]
GO


SELECT 'ALTER SCHEMA dbo TRANSFER ' + s.Name + '.' + o.Name
FROM sys.Objects o
INNER JOIN sys.Schemas s on o.schema_id = s.schema_id
WHERE s.Name = 'iehp\e1003'
And (o.Type = 'U' Or o.Type = 'P' Or o.Type = 'V')

USE HSP_QA1
ALTER SCHEMA dbo TRANSFER [iehp\e1003].ee_TriageClaimTest
ALTER SCHEMA dbo TRANSFER [iehp\e1003].ii_TriageClaimTest

