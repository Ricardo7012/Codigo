-- https://blog.sqlauthority.com/2015/08/31/sql-server-spid-is-killedrollback-state-what-to-do-next/

kill 56 with statusonly 
go
kill 82 with statusonly 
GO

SELECT spid
     , kpid
     , cmd
     , waittype
     , waittime
     , waitresource
     , lastwaittype
FROM sys.sysprocesses
WHERE cmd = 'KILLED/ROLLBACK';
GO 5

SELECT spid
     , kpid
     , login_time
     , last_batch
     , status
     , hostname
     , nt_username
     , loginame
     , hostprocess
     , cpu
     , memusage
     , physical_io
FROM sys.sysprocesses
WHERE cmd = 'KILLED/ROLLBACK';
GO 5

SET NOCOUNT ON

