--RENAME A SQL SERVER INSTANCE
sp_helpserver
select @@servername

--sp_dropserver 'QVSQLHSP01'
--go
--sp_dropserver 'QVSQLHSP01\sql1'
--go

--sp_addserver 'QVSQLHSP01\sql1','local'
--go

--SHUTDOWN WITH NOWAIT; 
--go

sp_helpserver
select @@servername
