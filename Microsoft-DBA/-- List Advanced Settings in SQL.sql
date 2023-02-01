-- List Advanced Settings in SQL

EXEC dbo.sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO

EXEC dbo.sp_configure
GO