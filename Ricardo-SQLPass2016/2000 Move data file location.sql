/************************************************
BLAH BLAH BLAH
************************************************/

USE RedESoft
go
sp_helpfile
go

USE MASTER
GO

-- Set database to single user mode
ALTER DATABASE RedESoft
SET SINGLE_USER
GO 

-- Detach the database
sp_detach_db 'RedESoft'
GO

-- Now Attach the database    
sp_attach_DB 'RedESoft', 
'D:\MSSQL\Data\RedESoft_Data.mdf',
'L:\RedESoft\RedESoft_log.ldf'
GO

--CHECK IT
USE RedESoft
GO
sp_helpfile
GO

ALTER DATABASE RedESoft
SET MULTI_USER
GO 