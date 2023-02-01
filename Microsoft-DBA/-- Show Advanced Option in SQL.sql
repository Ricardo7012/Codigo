-- Show Advanced Option in SQL

DECLARE @Configure Binary

SET @Configure = 1

EXEC sp_configure 'Show Advanced Options', @Configure
GO

RECONFIGURE
GO

EXEC sp_configure 