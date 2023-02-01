USE HSP_QA1
GO
SELECT * FROM sys.databases
SELECT DB_NAME() AS DatabaseName, DATABASEPROPERTYEX('master','Status') as DBSTATUS
GO
DECLARE @status INT
SELECT @status = status FROM sys.sysdatabases WHERE name = DB_NAME()
PRINT DB_NAME() + ' - ' + convert(varchar(20),@status)
IF ( (1 & @status) = 1 ) PRINT 'autoclose' 
IF ( (2 & @status) = 2 ) PRINT '2 not sure' 
IF ( (4 & @status) = 4 ) PRINT 'select into/bulkcopy' 
IF ( (8 & @status) = 8 ) PRINT 'trunc. log on chkpt' 
IF ( (16 & @status) = 16 ) PRINT 'torn page detection' 
IF ( (32 & @status) = 32 ) PRINT 'loading' 
IF ( (64 & @status) = 64 ) PRINT 'pre recovery' 
IF ( (128 & @status) = 128 ) PRINT 'recovering' 
IF ( (256 & @status) = 256 ) PRINT 'not recovered' 
IF ( (512 & @status) = 512 ) PRINT 'offline' 
IF ( (1024 & @status) = 1024 ) PRINT 'read only' 
IF ( (2048 & @status) = 2048 ) PRINT 'dbo use only' 
IF ( (4096 & @status) = 4096 ) PRINT 'single user' 
IF ( (8192 & @status) = 8192 ) PRINT '8192 not sure' 
IF ( (16384 & @status) = 16384 ) PRINT '16384 not sure' 
IF ( (32768 & @status) = 32768 ) PRINT 'emergency mode' 
IF ( (65536 & @status) = 65536 ) PRINT 'online' 
IF ( (131072 & @status) = 131072 ) PRINT '131072 not sure' 
IF ( (262144 & @status) = 262144 ) PRINT '262144 not sure' 
IF ( (524288 & @status) = 524288 ) PRINT '524288 not sure' 
IF ( (1048576 & @status) = 1048576 ) PRINT '1048576 not sure' 
IF ( (2097152 & @status) = 2097152 ) PRINT '2097152 not sure' 
IF ( (4194304 & @status) = 4194304 ) PRINT 'autoshrink' 
IF ( (1073741824 & @status) = 1073741824 ) PRINT 'cleanly shutdown' 