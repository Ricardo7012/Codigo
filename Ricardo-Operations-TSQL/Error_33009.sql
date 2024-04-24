USE HSP
GO
SELECT owner_sid FROM sys.databases WHERE database_id=DB_ID()
GO
SELECT sid FROM sys.database_principals WHERE name=N'dbo'
GO
--ALTER AUTHORIZATION ON DATABASE::HSP TO HSP_dbo
--GO

