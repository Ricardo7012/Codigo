
DBCC SQLPERF(LOGSPACE);

SELECT name, log_reuse_wait_desc, recovery_model_desc, 
	is_auto_shrink_on, is_auto_update_stats_on, 
	is_cdc_enabled, is_encrypted, is_broker_enabled
FROM sys.databases
WHERE [name] = 'HSP_MO'

-- DUMP TRANSACTION

--DBCC opentran 

DBCC opentran ('ReportServerTempDB') --get the spid and feed it into the next query

DECLARE @handle BINARY(20)
DECLARE @SPID INT
SET @SPID = 2804 -- the spid from the dbcc opentran

SELECT @handle = sql_handle
FROM MASTER..sysprocesses
WHERE spid = @SPID
SELECT [text] FROM ::fn_get_sql(@handle)
GO 

/*  Getting Log Space Usage without using DBCC SQLPERF

SELECT *, fileproperty(name, 'SpaceUsed') as Used FROM dbo.sysfiles

SELECT instance_name AS DatabaseName,
       [Data File(s) Size (KB)],
       [LOG File(s) Size (KB)],
       [Log File(s) Used Size (KB)],
       [Percent Log Used]
FROM
(
   SELECT *
   FROM sys.dm_os_performance_counters
   WHERE counter_name IN
   (
       'Data File(s) Size (KB)',
       'Log File(s) Size (KB)',
       'Log File(s) Used Size (KB)',
       'Percent Log Used'
   )
     AND instance_name != '_Total'
) AS Src
PIVOT
(
   MAX(cntr_value)
   FOR counter_name IN
   (
       [Data File(s) Size (KB)],
       [LOG File(s) Size (KB)],
       [Log File(s) Used Size (KB)],
       [Percent Log Used]
   )
) AS pvt 


SELECT instance_name AS 'Database Name',
   MAX(CASE
           WHEN counter_name = 'Data File(s) Size (KB)'
               THEN cntr_value
           ELSE 0
       END) AS 'Data File(s) Size (KB)',
   MAX(CASE
           WHEN counter_name = 'Log File(s) Size (KB)'
               THEN cntr_value
           ELSE 0
       END) AS 'Log File(s) Size (KB)',
   MAX(CASE
           WHEN counter_name = 'Log File(s) Used Size (KB)'
               THEN cntr_value
           ELSE 0
       END) AS 'Log File(s) Used Size (KB)',
   MAX(CASE
           WHEN counter_name = 'Percent Log Used'
               THEN cntr_value
           ELSE 0
       END) AS 'Percent Log Used'
FROM sysperfinfo
WHERE counter_name IN
   (
       'Data File(s) Size (KB)',
       'Log File(s) Size (KB)',
       'Log File(s) Used Size (KB)',
       'Percent Log Used'
   )
  AND instance_name != '_total'
GROUP BY instance_name 

*/

/*
Factors That Can Delay Log Truncation
https://msdn.microsoft.com/en-us/library/ms345414%28v=sql.105%29.aspx

In SQL Server 2005 Enterprise Edition and later versions, a corrupted transaction can become 
deferred if data required by rollback (undo) is offline during database startup. A deferred 
transaction is a transaction that is uncommitted when the roll forward phase finishes and 
that has encountered an error that prevents it from being rolled back. Because the 
transaction cannot be rolled back, it is deferred. 

0 - NOTHING - Currently there are one or more reusable virtual log files.

1 - CHECKPOINT - No checkpoint has occurred since the last log truncation, or the head of the 
	log has not yet moved beyond a virtual log file (all recovery models).

	This is a routine reason for delaying log truncation. For more information, see Checkpoints 
	and the Active Portion of the Log.

2 - LOG_BACKUP - A log backup is required to move the head of the log forward (full or bulk-logged recovery models only).
	Note: Log backups do not prevent truncation.
	When the log backup is completed, the head of the log is moved forward, and some log space might become reusable.

3 - ACTIVE_BACKUP_OR_RESTORE - A data backup or a restore is in progress (all recovery models).
	A data backup works like an active transaction, and, when running, the backup prevents truncation. 
	For more information, see "Data Backup Operations and Restore Operations," later in this topic.

4 - ACTIVE_TRANSACTION - A transaction is active (all recovery models).
    A long-running transaction might exist at the start of the log backup. In this case, freeing the space might require 
	another log backup. For more information, see "Long-Running Active Transactions," later in this topic.
    A transaction is deferred (SQL Server 2005 Enterprise Edition and later versions only). A deferred transaction is 
	effectively an active transaction whose rollback is blocked because of some unavailable resource. For information 
	about the causes of deferred transactions and how to move them out of the deferred state, see Deferred Transactions. 

5 - DATABASE_MIRRORING - Database mirroring is paused, or under high-performance mode, the mirror database is 
	significantly behind the principal database (full recovery model only).
	For more information, see "Database Mirroring and the Transaction Log," later in this topic.

6 - REPLICATION - During transactional replications, transactions relevant to the publications are still undelivered 
	to the distribution database (full recovery model only).
	For more information, see "Transactional Replication and the Transaction Log," later in this topic.

7 - DATABASE_SNAPSHOT_CREATION - A database snapshot is being created (all recovery models).
	This is a routine, and typically brief, cause of delayed log truncation.

8 - LOG_SCAN - A log scan is occurring (all recovery models).
	This is a routine, and typically brief, cause of delayed log truncation.

9 - OTHER_TRANSIENT - This value is currently not used.


==============================================================================================
Log Reuse Waits Explained: CHECKPOINT
==============================================================================================
There are eight reasons SQL Server might report when it cannot truncate the transaction log. 
Any one of these reasons results in a growing log file. This short series is looking at each 
of them in detail, explaining what is causing it and what you can do to resolve it. Today's 
log reuse wait reason is: CHECKPOINT
Buffer Pool

The SQL Server query engine never directly interacts with the data files on disk. Instead 
it requests the data pages it needs to process a query from the buffer pool manager. The 
buffer pool manager checks if that page is already in the buffer pool and if so returns a 
memory pointer back to the query engine.

If the page however is not yet in the buffer pool, the buffer pool manager requests it from 
the storage engine. The storage engine then proceeds to locate the page on disk and once found 
reads it into the buffer pool. After the pages is completely loaded, the buffer pool manager 
wakes the query engine back up and presents the new page location.
Dirty Pages

If a data changing query is executed, the changes are applied to the pages in memory and not 
directly written to disk. If the page that needs to be changed is not currently in memory, the 
same process to load it that was described above is executed first. Once the page is in memory, 
the changes are applied and the page is marked as having changed or as "dirty".
Checkpoint

In regular intervals a background process runs to write those dirty pages back to disk. Once 
all currently dirty pages are saved safely on disk, a special mark is written to the log. 
This allows SQL Server to process recovery after a crash starting at the most recent mark in 
the log, as all prior changes have already been written to disk.

This special mark is called "Checkpoint". The background process runs automatically often enough 
so that the estimated crash recovery time is lower than the recovery interval server setting. 
This setting is by default set to 0 which is interpreted by SQL Server as one minute. That means 
that on a fairly busy system you will have a checkpoint about every minute, but on a system that 
is not well utilized, the time between checkpoints can be significantly larger.

Besides of the scheduled automatic checkpoint, you can trigger a manual checkpoint by executing 
the CHECKPOINT command.

The checkpoint allows SQL Server to start the recovery process at that point in the log. All log 
records prior to the checkpoint can be ignored. All log records that were written after the 
checkpoint, have to be processed. This includes records of transactions that started before the 
checkpoint and were committed or rolled back after the checkpoint.
The Checkpoint Wait

This means, that a log record of a committed transaction is still required for crash recovery 
until the next checkpoint has been executed. In this situation the virtual log files containing 
these log records cannot be reused and SQL Server reports CHECKPOINT in the log_reuse_wait_desc column.

This wait type is usually short lived. SQL Server will automatically create a checkpoint in 
regular intervals. If this wait type persists, you can execute a checkpoint manually by using 
the CHECKPOINT statement. You can also adjust the interval between checkpoints, even if only 
indirectly, by changing the recovery interval server setting.
Summary

Transaction log records of transactions that have been committed or rolled back after the most 
recent checkpoint prevent log truncation. If this is causing SQL Server to run out of transaction 
log space, the log_reuse_wait_desc column in sys.databases will return the value CHECKPOINT. 
This is usually short lived and not necessarily indicative of a problem. 

==============================================================================================
Log Reuse Waits Explained: LOG_BACKUP
==============================================================================================
There are eight reasons SQL Server might report when it cannot truncate the transaction log. 
Any one of these reasons results in a growing log file. This short series is looking at each 
of them in detail, explaining what is causing it and what you can do to resolve it. Today's 
log reuse wait reason is: LOG_BACKUP
Recovery Model

SQL Server knows three recovery models: Simple, full and bulk-logged. The main purpose is to 
influence how much data would be lost during a disaster. The recovery model it is a database 
wide setting.
Simple

If your database recovery model is set to simple, you can take full and differential backups. 
When disaster strikes your only option is to restore the last backup you had taken. Everything 
that happened in your database since then will be lost.

You can alleviate that by taking backups more frequent, but that can cause a higher strain 
on your resources.
Full

If you have set your database to recovery model full and you have taken at least one full or 
differential backup since, you have one more option. If the disaster for example affected the 
drive with the data files, but the log files are still readable, you can take a tail-log 
backup to capture all changes that happened after the last backup. With that you can restore 
right up to the point when the disaster started and you are not losing any committed data.

However, this flexibility comes at a price. To be able to offer that backup restore capability 
SQL Server will not reuse any part of the transaction log, until you have taken a log backup of 
that part. So, to be able to reuse your virtual log files you need to regularly execute a log 
backup. A full or differential backup does not have any effect on log reuse.

There is an additional advantage to having this log backup chain. Because the log is written 
sequentially, you can now tell SQL Server to stop a restore process at any given point in time. 
With that you can restore your database to just before the accidental delete without where 
clause was executed.

You also have two independent backup channels. While you have to start every restore with a 
full backup, is does not need to be the most recent one if you still have a complete log backup 
chain since that backup. The restore will take longer this way, but if the most recent full 
backup was damaged this can get your data back.
Bulk Logged

For the purposes of this discussion the bulk logged recovery model is very similar to the full 
recovery model. The only difference is, that in this recovery model actual bulk operations 
like the BCP command prevent point in time restores to any time that is covered by a log backup 
containing the bulk operation fully or partially. Also, log backups might execute slower with 
this recovery model depending on the size of your database and the operations performed.
Waiting for the Log Backup

As I already mentioned above, if the database is in full recovery model, the virtual log files 
cannot be reused if they have not been backed up yet. If this is currently the case in a 
database, the log_reuse_wait_desc column will report a value of LOG_BACKUP.

Solving this problem is simple: Take a log backup.

If the business does not require the point in time restore capability and can afford losing 
(depending on your backup schedule) a day's worth of data you can also switch the database to 
the simple recovery model. This might be appropriate for example for development databases 
that can be recreated.
Summary

If your database recovery model is "full" SQL Server cannot reuse virtual log files unless all 
contained transaction log records have been backed up with a log backup. If a log backup is 
outstanding the log has to grow to accommodate new data changes. During this time you will see 
a log_reuse_wait_desc of LOG_BACKUP. Full or differential backups do not backup all transaction 
log records, so you need to run an actual log backup to allow for virtual log file reuse. 

==============================================================================================
Log Reuse Waits Explained: ACTIVE_BACKUP_OR_RESTORE
==============================================================================================
There are eight reasons SQL Server might report when it cannot truncate the transaction log. 
Any one of these reasons results in a growing log file. This short series is looking at each of 
them in detail, explaining what is causing it and what you can do to resolve it. Today's log 
reuse wait reason is: ACTIVE_BACKUP_OR_RESTORE
Backup and Restore Consistency

SQL Server is first and foremost an ACID compliant database management system. That means that 
the rules dictated by this set of properties are adhered to under all circumstances. The ACID 
acronym stands for Atomicity, Consistency, Isolation and Durability. Without going into any detail, 
they guarantee among other things that a transaction that was committed does not suddenly disappear 
or worse partially disappear. In the context of backups and restores that means that after I restore 
from a backup all the data within that database must also be transactionally consistent.

One way to achieve backup consistency is to take the database offline before each backup and bring 
it online afterwards. That way no concurrent changes to the data can happen that would only be 
partially captured by the backup. However that is clearly not a desirable solution as, depending on 
the size of the database, a backup might take a considerable amount of time.

Another way is to record all transactions that are happening during the backup and then run a 
standard crash recovery using this data after every restore. This is the approach SQL Server 
takes. All transaction log records of transactions that were active at any time during the backup 
operation are included in the backup at the end of its run. That way SQL Server has enough 
information to undo the changes of transactions that were still active at the end of the backup 
and redo the changes of transactions that were committed during the backup.
Backup Wait

Because the log records are captured at the end of the backup operation, the virtual log files 
containing transaction log records of transactions that were active at any time during the backup 
cannot be reused until that last phase of the backup process has finished.
Restore Wait

At the end of any restore, SQL Server has to run crash recovery on the restored data. That means 
that during that time log reuse has to be prevented too. In most cases a database won't be online 
during its restore and this will therefore not be a problem. However, if you did a partial restore 
of only the active file groups of your database, you can bring those online before starting the 
restore of that large file group with the archive data. During that restore you will also not be 
able to reuse your log.
Resolving the ACTIVE_BACKUP_OR_RESTORE Wait

If SQL Server runs out of transaction log space during a backup or restore operation, the 
log_reuse_wait_desc column for that database will return a value of ACTIVE_BACKUP_OR_RESTORE.

In either case you have to wait for the operation to finish. That means if your backup strategy 
involves taking full or differential backups during a busy time, you have to give the transaction 
log enough room to grow. This is particularly important if the database is large, causing backup 
operations to potentially run for a long time.

You also have to account for transaction log growth if your restore strategy includes partial 
restores while other parts of the database are online.
Summary

At the end of each backup SQL Server captures the piece of the transaction log that covers all 
transactions that were active at any time during the backup. Because of that the virtual log 
files containing those transaction log records can't be reused during a backup. SQL Server 
will return a log_reuse_wait_desc value of ACTIVE_BACKUP_OR_RESTORE if it runs out of virtual 
log files during that time. During a restore operation the log cannot be reused either as the 
log records are required for the crash recovery process that is part of each restore operation. 
This is true too for database that are partially online during a restore operation. 

==============================================================================================
Log Reuse Waits Explained: ACTIVE_TRANSACTION
==============================================================================================
There are eight reasons SQL Server might report when it cannot truncate the transaction log. 
Any one of these reasons results in a growing log file. This short series is looking at each 
of them in detail, explaining what is causing it and what you can do to resolve it. Today's 
log reuse wait reason is: ACTIVE_TRANSACTION
Transaction Log

SQL Server uses the transaction log for two purposes. First the transaction log is used for 
SQL Server to be able to guaranty the durability requirement of the ACID properties. For that 
it makes sure that at least the portion of the log containing the active transaction has been 
written to disk successfully before that transaction can be committed.

The second use of the transaction log affects rollbacks. During a transaction that changes a 
particular page, another transaction might change and commit another change on the same page. 
Because of that, SQL Server cannot just declare pages that were changed by a transaction as 
unusable and reload them from disk the next time they are needed. Instead all the changes 
applied by a transaction need to be undone step by step in reverse order when the transaction 
is rolled back.
Waiting for a Transaction

For this rollback process SQL Server uses the information captured in the transaction log. 
Therefore it cannot reuse a virtual log file that contains transaction log records of a 
transaction that is still active. SQL Server will return a log_reuse_wait_desc value of 
ACTIVE_TRANSACTION if it runs out of virtual log because of that.

To resolve this wait, you have to commit or rollback all transactions. The safest strategy is 
to just wait until the transactions finish themselves. Well-designed transactions are usually 
short lived, but there are many reasons that can turn a normal transaction into a log running 
one. If you cannot afford to wait for an extra-long running transaction to finish, you might 
have to kill its session. However, that will cause that transaction to be rolled back. Keep 
this in mind when designing your application and try to keep all transactions as short as 
possible.

One common design mistake that can lead to very long running transactions is to require user 
interaction while the transaction is open. If the person that started the transaction went to 
lunch while the system is waiting for a response, this transaction can turn into a very-long-running 
transaction. During this time other transactions, if they are not blocked by this one, will 
eventually fill up the log and cause the log file to grow.
Summary

SQL Server will return a log_reuse_wait_desc value of ACTIVE_ TRANSACTION if it runs out of 
virtual log files because of an open transaction. Open transactions prevent virtual log file 
reuse, because the information in the log records for that transaction might be required to 
execute a rollback operation.

To prevent this log reuse wait type, make sure you design you transactions to be as short lived 
as possible and never require end user interaction while a transaction is open. 

==============================================================================================
Log Reuse Waits Explained: DATABASE_MIRRORING
==============================================================================================
There are eight reasons SQL Server might report when it cannot truncate the transaction log. 
Any one of these reasons results in a growing log file. This short series is looking at each 
of them in detail, explaining what is causing it and what you can do to resolve it. Today's 
log reuse wait reason is: DATABASE_MIRRORING
Database Mirroring

Database mirroring is deprecated since SQL Server 2012. So this wait type will go away at some 
point. But for now there are still quite a few installations out there. Therefore I decided to 
cover it anyway.

Database mirroring allows you to have a second exact copy of your database on a different server. 
There are two operating modes: high performance and high-safety. In high-safety mode a transaction 
can only be committed if it has been applied to both databases. This can cause higher transaction 
latency but you will not lose any data if one of the two servers suddenly dies.

In high-performance mode on the other hand, transactions are committed on the primary server 
first and then transferred over to the secondary server. That reduces the latency impact on the 
primary server, but you might run the risk of some data loss if the secondary is behind at the 
time the primary server goes down.
Waiting for the Secondary

If you set database mirroring up in high-performance mode, a background process reads records 
for committed transaction from the transaction log and then sends enough information over to the 
secondary to repeat the action that transaction executed.

If the secondary falls behind, for example because of an interrupted network connection, the log 
reading process will wait until it can continue to transmit transaction information. During that 
time, transactions in the log that have not been processed by the mirroring agent cannot be purged 
and the virtual log files containing these records can't be reused. SQL Server will return a 
log_reuse_wait_desc value of DATABASE MIRRORING if it runs out of virtual log files because of this.

To solve this issue make sure the server housing the database mirror is adequately sized to keep 
up with the transaction load and the network connection between the two is stable. Also make sure 
there is enough room for the transaction log of the source database to grow in case of a mirror delay.
Summary

SQL Server database mirroring is a deprecated high availability solution. It allows us to have 
copy of a database on a secondary server that is automatically kept in synch, either synchronously 
or asynchronously. In high-performance mode, the transaction log information of committed 
transactions is used to apply the changes asynchronously to the secondary. A log_reuse_wait_desc 
value of DATABASE MIRRORING indicates that this process is falling behind and can't process log 
records quickly enough.

The high-safety mode on the other hand applies all changes synchronously and therefore has no 
impact on transaction log reuse. 

==============================================================================================
Log Reuse Waits Explained: REPLICATION
==============================================================================================
There are eight reasons SQL Server might report when it cannot truncate the transaction log. 
Any one of these reasons results in a growing log file. This short series is looking at each 
of them in detail, explaining what is causing it and what you can do to resolve it. Today's 
log reuse wait reason is: REPLICATION
Replication

Transactional replication works similar to mirroring in high-performance mode. Changes applied 
and committed in one database can be replicated (hence the name) in another database. The main 
difference to mirroring is that transactional replication is a lot more flexible. Mirroring 
always copies the entire database and allows only for one secondary. In transactional 
replication on the other hand, you can have many subscribers (receivers of changes) and you 
do not have to send the entire database. You can for example send only a subset of the tables 
or even a subset of the columns of one table.

Under the covers transactional replication uses the same base technology as mirroring. The 
Log Reader Agent scans the transaction log of the publication database (the source database) 
and sends all committed changes that affected published objects over to the subscribers.

The data is actually not directly sent to the subscribers but instead to a distributor. 
The distributor then distributes the changes to the subscribers. Under-sizing the distributor 
often is a cause for bottlenecks.

There are two other forms of replication: Snapshot replication and merge replication. 
Both do not use the transaction log, so they are not relevant for this discussion. For more 
details on the inner workings of replication and the different replication types see my book 
Fundamentals of SQL Server 2012 Replication.
Waiting for the Log Reader Agent

The Log Reader Agent is responsible for scanning the transaction log and sending the data on. 
If that agent cannot keep up with the load, log truncation cannot occur. In this case SQL Server
will return a log_reuse_wait_desc value of REPLICATION .

To resolve the REPLICATION wait type, make sure the network connection to the distributor is 
working and the distributor can handle the current work load. If the publisher and the 
distributor are on the same SQL Server instance or on the same physical machine, consider 
moving the distributor to dedicated hardware.
Change Data Capture

Change Data Capture or CDC is a technology designed to record all changes that were applied to 
a monitored table or set of tables. This information can for example be used in an audit report 
providing the before and after values for every change as well as who executed the change and 
when it was applied.

This very powerful technology makes use of the replication technology. That means if CDC gets 
behind for some reason, e.g. because of a degrading raid array causing slow performance of the 
drive it is writing to, and if this is preventing log truncation a log_reuse_wait_desc value 
of REPLICATION is reported. So if you see this value and do not use replication or can't find 
anything wrong with it, check your CDC setup.
Summary

Transactional replication uses a log reader agent to read and process all committed transactions 
in the publication database. Virtual log files containing log records that have not been 
processed yet cannot be reused. If the log reader agent falls behind, SQL Server will eventually 
run out of virtual log files. In this case it will return a log_reuse_wait_desc value of 
REPLICATION. Problems with change data capture can also lead to this wait type as CDC is using
the replication technology stack. 

==============================================================================================
Log Reuse Waits Explained: DATABASE_SNAPSHOT_CREATION
==============================================================================================
There are eight reasons SQL Server might report when it cannot truncate the transaction log. 
Any one of these reasons results in a growing log file. This short series is looking at each 
of them in detail, explaining what is causing it and what you can do to resolve it. Today's 
log reuse wait reason is: DATABASE_SNAPSHOT_CREATION
Database Snapshot

A database snapshot is a point in time image of a database. It is implemented as a shadow file. 
That means that only the pages that have changed since that snapshot was created are actually 
stored in the snapshot file; the original unchanged version of those pages that is. All the 
other pages are read directly from the database files. From the creation on, every time a page 
in the database changes the original version is first moved over to the snapshot. That way SQL 
Server can provide that point in time image of the database.

The creation of the snapshot is a not very resource intensive and usually takes only a few seconds. 
However, during this time SQL Server needs to keep an eye on concurrent changes. Not surprising, it 
uses the transaction log for that.
Waiting for the Snapshot

Because SQL Server must ensure that the snapshot in itself is transactionally consistent, it uses 
the database transaction log at the end of the snapshot creation process to apply changes that 
were committed since and undo changes that happened during the snapshot creation but where not 
committed at the time the snapshot creation finished. (All those actions are only applied to the 
snapshot file; the transactions in the actual database are not affected.)

During the creation process, SQL Server can therefore not truncate the log. If it runs out of log 
space because of that it will return a log_reuse_wait_desc value of DATABASE_SNAPSHOT_CREATION.

The process of creating a snapshot is usually very quick and you should not see this wait for a 
long time. If you are not using snapshots yourself however you should be aware that SQL Server 
is making use of this technology for internal purposes. A prominent example is the DBCC CHECKDB 
command. It will create a database snapshot to run its checks against. So you might see the 
above mentioned wait when executing your database consistency checks. But again, the actual wait 
time should always be fairly short.
Summary

SQL Server will return a log_reuse_wait_desc value of DATABASE_SNAPSHOT_CREATION if it runs out of 
virtual log files during the creation of a database snapshot. As that is usually a quick process 
you should not see this wait for a long time. Be aware, that SQL Server is using this feature 
internally, so you might see this log reuse wait type even if you are not using database 
snapshots yourself. 

==============================================================================================
Log Reuse Waits Explained: LOG_SCAN
==============================================================================================
There are eight reasons SQL Server might report when it cannot truncate the transaction log. 
Any one of these reasons results in a growing log file. This short series is looking at each 
of them in detail, explaining what is causing it and what you can do to resolve it. Today's 
log reuse wait reason is: LOG_SCAN
LOG_SCAN

This one is shy. You will rarely see one on your servers.

A log_reuse_wait_desc value of LOG_SCAN indicates exactly what it sounds like. For some reason 
SQL Server is executing a scan of the transaction log. While that scan is going on, log 
truncation cannot happen, potentially leading to this wait type.

So what will cause a log scan? There are a few situations in which SQL Server has to scan the 
transaction log. The use of the undocumented fn_dblog function will for example cause a log scan. 
Another example is a checkpoint operation: During a checkpoint SQL Server does a log scan to 
synchronize log sequence numbers.

A log scan is usually a very brief operation. Therefore this log reuse wait is very transient. 
If you encounter this wait on you system it will probably be gone by the next time you look.
Summary

SQL Server will return a log_reuse_wait_desc value of LOG_SCAN if it runs out of virtual log 
files during an active scan of the transaction log. Those scans are usually short and 
therefore you should not see this wait type for an extended period of time, if ever. 

*/
