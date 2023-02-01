-- Run DBCC on Database

DECLARE @DBName varchar(40)

SET @DBName = 'PlayerManagement'

DBCC CHECKDB(@DBName)
GO