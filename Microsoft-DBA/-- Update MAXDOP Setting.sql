-- Update MAXDOP Setting

DECLARE @MaxDop INT

SET @MaxDop = 0

EXEC dbo.sp_configure 'max degree of parallelism', @MaxDop;
GO

RECONFIGURE;
GO


