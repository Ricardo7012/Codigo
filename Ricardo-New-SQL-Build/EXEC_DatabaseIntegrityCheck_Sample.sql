USE [master]
GO
EXEC [dbo].[sp_DatabaseIntegrityCheck] @Databases = 'ALL_DATABASES', @CheckCommands= 'CHECKDB'
GO