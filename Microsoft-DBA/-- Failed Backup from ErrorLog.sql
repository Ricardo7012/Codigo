-- Failed Backup from ErrorLog

EXEC sp_readerrorlog 0, 1, 'BACKUP failed'; -- current
--EXEC sp_readerrorlog 1, 1, 'BACKUP failed'; -- .1 (previous)
--EXEC sp_readerrorlog 2, 1, 'BACKUP failed'; -- .2 (the one before that)