
-- https://sqlsunday.com/2013/08/11/shrinking-tempdb-without-restarting-sql-server/

/****************************
It’s worth mentioning. If you’re not running a production-like environment, 
your best bet is to restart the SQL Server service. This will return tempdb 
to its default size, and you won’t have to worry about all the potential 
pitfalls of this article. But since you’re reading this, chances are you 
can’t just restart the server. So here goes:

Warning: These operations remove all kinds of caches, which will impact 
server performance to some degree until they’ve been rebuilt by the 
SQL Server. Don’t do this stuff unless absolutely neccessary.

******************************/

CHECKPOINT;
GO
DBCC DROPCLEANBUFFERS;
go
DBCC FREEPROCCACHE;
GO
DBCC FREESYSTEMCACHE ('ALL');
go
DBCC FREESESSIONCACHE;
go
