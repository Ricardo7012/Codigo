SELECT * FROM sys.dm_tran_database_transactions

-- First you can try the sysprocesses to get SPID and Kill Them
DECLARE @DB SYSNAME -- Put the name of database here
DECLARE @SPID VARCHAR(4), @cmdSQL VARCHAR(10)

SET @DB = 'hsp_mo'

-- Looks for all spids that are connected in the databases
DECLARE cCursor CURSOR
FOR SELECT CAST(SPID AS VARCHAR(4)) FROM master.dbo.sysprocesses
WHERE SPID > 50 -- To not try to Kill SQL Server Process
AND SPID != @@SPID -- To not kill yourself
AND DBID = DB_ID(@DB) -- To filter only the users connected in specific database

OPEN cCursor

FETCH NEXT FROM cCursor INTO @SPID

-- For each user connected in the database
WHILE @@FETCH_STATUS = 0
BEGIN
 SET @cmdSQL = 'KILL ' + @SPID

 -- Kill the user
 EXEC (@cmdSQL)
 FETCH NEXT FROM cCursor INTO @SPID 
END

CLOSE cCURSOR

DEALLOCATE cCURSOR

SELECT * FROM sys.dm_tran_database_transactions

DBCC OPENTRAN()
