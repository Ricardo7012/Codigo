-- Force Ghost Cleanup

DBCC FORCEGHOSTCLEANUP

-- If dbname or dbid is not specified, FORCEGHOSTCLEANUP assumes the current database 
-- context. This command bypasses the standard rules that the background task follows. 
-- Runs the cleanup in a single transaction (background task sweeps 10 PFS pages per 
-- transaction) and can cause blocking, and does not yield like the background task. 
-- If this command is cancelled/killed, it may roll back all the reclaimed space.

DBCC FORCEGHOSTCLEANUP(id)

or

DBCC FORCEGHOSTCLEANUP('dbname')
