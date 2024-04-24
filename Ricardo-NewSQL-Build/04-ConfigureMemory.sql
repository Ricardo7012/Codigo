EXEC sys.sp_configure N'show advanced options', N'1'  RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'min server memory (MB)', N'4096' --CHANGE TO YOUR CHOICE
GO
EXEC sys.sp_configure N'max server memory (MB)', N'122880' --CHANGE TO YOUR CHOICE
GO
RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'show advanced options', N'0'  RECONFIGURE WITH OVERRIDE
GO
