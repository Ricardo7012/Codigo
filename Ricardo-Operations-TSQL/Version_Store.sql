/*
Fundamentals of TempDB: How the Version Store Uses TempDB
v1.0 - 2020-12-06
https://www.BrentOzar.com/go/tempdbfun


This demo requires:
* SQL Server 2016 or newer
* Any Stack Overflow database: https://www.BrentOzar.com/go/querystack

This first RAISERROR is just to make sure you don't accidentally hit F5 and
run the entire script. You don't need to run this:
*/
RAISERROR(N'Oops! No, don''t just hit F5. Run these demos one at a time.', 20, 1) WITH LOG;
GO


USE StackOverflow2013;
GO
ALTER DATABASE CURRENT 
	SET READ_COMMITTED_SNAPSHOT OFF WITH NO_WAIT
GO

/* Blocking has always been painful. */
BEGIN TRAN
	UPDATE dbo.Users
	SET Location = N'Iceland'
	WHERE DisplayName = N'Brent Ozar';
GO
/* ROLLBACK */


/* While that is open, run this in another window: */
SELECT Location
	FROM dbo.Users
	WHERE DisplayName = N'Brent Ozar';
GO



/* We had to resort to NOLOCK, which worked: */
SELECT Location
	FROM dbo.Users WITH (NOLOCK)
	WHERE DisplayName = N'Brent Ozar';
GO


/* But with NOLOCK:
* You can see rows twice
* You can skip rows
* Your query can fail with an error
* You can see data that was never committed
	(like what's about to happen here:
*/
ROLLBACK



/* Fortunately, there's a better way: RCSI or SI,
aka optimistic concurrency, aka MVCC.
https://BrentOzar.com/go/rcsi

You turn it on at the database level, but
you have to be the only active connection: */
ALTER DATABASE CURRENT 
	SET READ_COMMITTED_SNAPSHOT ON WITH NO_WAIT
GO

/* Now try our transaction again: */
BEGIN TRAN
	UPDATE dbo.Users
	SET Location = N'Iceland'
	WHERE DisplayName = N'Brent Ozar';
GO

/* Without NOLOCK, and without indexing or
changing the query at all, it works! It sees
a version of truth that's true before the
update transaction finishes.

Writers no longer block readers, and
readers no longer block writers either.

The magic happens because SQL Server stores
versions of rows during transactions. They
live in the "version store", which lives in
TempDB (until SQL 2019, which lets you move
the version store into the database - but
that's outside of the scope of this class.)

You can query to see how much space is used
by the version store.

SQL Server 2016 SP2 & newer: */
SELECT DB_NAME(database_id) AS database_name,
  reserved_space_kb / 1024.0 AS version_store_mb
FROM sys.dm_tran_version_store_space_usage
WHERE reserved_space_kb > 0
ORDER BY 2 DESC;

/* Previous versions of SQL don't break it out per database: */
SELECT SUM (version_store_reserved_page_count)*8/1024.0  as version_store_mb
FROM tempdb.sys.dm_db_file_space_usage

/* The bigger your transactions are,
the bigger the version store becomes.

Our transaction is still open - and let's
"modify" more data. */
UPDATE dbo.Users
	SET Reputation = Reputation;
GO


/* How much is used in the version store now? */
SELECT DB_NAME(database_id) AS database_name,
  reserved_space_kb / 1024.0 AS version_store_mb
FROM sys.dm_tran_version_store_space_usage
WHERE reserved_space_kb > 0
ORDER BY 2 DESC;


/* Uh oh.

Plus, if someone wants to run this query now,
which database has the data they want? */
SELECT COUNT(*) FROM dbo.Users;
GO


/* Inserts don't affect the size as long as
we don't need to log prior versions of rows: */
SELECT *
	INTO dbo.Badges_New
	FROM dbo.Badges;
GO

/* But deletes will: */
DELETE dbo.Badges;
GO

SELECT DB_NAME(database_id) AS database_name,
  reserved_space_kb / 1024.0 AS version_store_mb
FROM sys.dm_tran_version_store_space_usage
WHERE reserved_space_kb > 0
ORDER BY 2 DESC;


/* Commit our changes, and check the version store: */
COMMIT;
GO
SELECT DB_NAME(database_id) AS database_name,
  reserved_space_kb / 1024.0 AS version_store_mb
FROM sys.dm_tran_version_store_space_usage
WHERE reserved_space_kb > 0
ORDER BY 2 DESC;
GO


/* RCSI & SI aren't the only things that use the
version store, either. Triggers use it too! */
CREATE TRIGGER upd_Users_Waiter ON dbo.Users FOR UPDATE AS
BEGIN
	WAITFOR DELAY '00:00:30';
END
GO

UPDATE dbo.Users SET Reputation = Reputation;
GO
/* And while it runs, check the version store in
another window: */
SELECT DB_NAME(database_id) AS database_name,
  reserved_space_kb / 1024.0 AS version_store_mb
FROM sys.dm_tran_version_store_space_usage
WHERE reserved_space_kb > 0
ORDER BY 2 DESC;
GO

/* Why? Because triggers have virtual tables
called INSERTED and DELETED:
https://docs.microsoft.com/en-us/sql/relational-databases/triggers/use-the-inserted-and-deleted-tables?view=sql-server-ver15

Those have copies of the rows before & after
your change! Big updates = big version store.
(Inserts & deletes are only 1x the size.)
*/





/* What you learned in this session:

* Read Committed Snapshot Isolation (RCSI) and
	Snapshot Isolation (SI) reduce blocking by
	storing versions of rows in TempDB.

* Update & delete transactions basically copy their
	changes into TempDB.

* The more data a transaction changes,
	and the longer the transaction stays open,
	and the more queries need to read those versions,
	the bigger & slower TempDB is going to get.

* Triggers don't reduce blocking - but they do
	have virtual INSERTED & DELETED tables, and
	those use the version store too.

* Cleanup may not happen quickly enough for you,
	especially when any one database is holding
	transactions open: other databases' versions
	can't be cleaned up.

* There's no simple formula to calculate how big
	your TempDB will get, or how long transactions
	will stay open. It depends on your app code.

* This is why 3rd party monitoring tools warn about
	TempDB growths and large version store sizes.
	If someone leaves a transaction open, locks
	their workstation, and goes home, you're doomed.

Learning resources:

Open transactions in any database mean the version
store can't be cleaned out:
https://kohera.be/blog/sql-server/tempdb-the-ghost-of-version-store/
https://docs.microsoft.com/en-us/archive/blogs/sqlserverstorageengine/managing-tempdb-in-sql-server-tempdb-basics-version-store-growth-and-removing-stale-row-versions

Implicit transactions often cause problems with this:
https://www.brentozar.com/archive/2018/02/set-implicit_transactions-one-hell-bad-idea/
https://www.brentozar.com/archive/2019/07/using-implicit-transactions-you-really-need-rcsi/
https://thesurfingdba.weebly.com/my-version-store-is-huge.html


During the break, check your own servers to find
out which databases need the version store:
*/
SELECT db.name, db.is_read_committed_snapshot_on AS rcsi_on,
	db.snapshot_isolation_state_desc AS snapshot_isolation,
	COALESCE(vs.reserved_space_kb, 0) / 1024.0 AS version_store_mb
FROM sys.databases db
LEFT OUTER JOIN sys.dm_tran_version_store_space_usage vs ON db.database_id = vs.database_id
ORDER BY vs.reserved_space_kb DESC, db.name;


/*
License: Creative Commons Attribution-ShareAlike 4.0 Unported (CC BY-SA 4.0)
More info: https://creativecommons.org/licenses/by-sa/4.0/

You are free to:
* Share - copy and redistribute the material in any medium or format
* Adapt - remix, transform, and build upon the material for any purpose, even 
  commercially

Under the following terms:
* Attribution - You must give appropriate credit, provide a link to the license, 
  and indicate if changes were made. You may do so in any reasonable manner, 
  but not in any way that suggests the licensor endorses you or your use.
* ShareAlike - If you remix, transform, or build upon the material, you must
  distribute your contributions under the same license as the original.
* No additional restrictions — You may not apply legal terms or technological 
  measures that legally restrict others from doing anything the license permits.
*/