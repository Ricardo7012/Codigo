SELECT @@ServerName                                                                                                   AS [Server Name]
     , RIGHT(@@Version, LEN(@@Version) - 3 - CHARINDEX(' ON ', @@Version))                                            AS [OS Info]
     , LEFT(@@Version, CHARINDEX('-', @@Version) - 2) + ' ' + CAST(SERVERPROPERTY('ProductVersion') AS NVARCHAR(300)) AS [SQL Server Version]
     , service_account
     , instant_file_initialization_enabled
FROM sys.dm_server_services
WHERE servicename LIKE 'SQL Server (%';
go
exec xp_readerrorlog 4, 1, N'Database Instant File Initialization'
go

/*
-- https://www.brentozar.com/blitz/instant-file-initialization/
Instant File Initialization
Should we fill this with zeroes?
Should we fill this with zeroes?

Whenever SQL Server needs to allocate space for certain operations like creating/restoring a database or growing data/log files, SQL Server first fills the space it needs with zeros. In many cases, writing zeros across the disk space before using that space is unnecessary.

Instant file initialization (IFI) allows SQL Server to skip the zero-writing step and begin using the allocated space immediately for data files. It doesn’t impact growths of your transaction log files, those still need all the zeroes.

WHY INSTANT FILE INITIALIZATION IS A GOOD IDEA
The larger the growth operation, the more noticeable the performance improvement is with IFI enabled. For instance, a data file growing by 20 GB can take minutes to initialize without IFI. Read more about waits for file growths here. This can make a huge difference whenever you are proactively growing out data files.

Bonus: Enabling IFI can also make restoring databases considerably faster, too!

WHY INSTANT FILE INITIALIZATION MAY NOT BE A GOOD IDEA
By not writing zeros across newly allocated space, it leaves the possibility open that deleted files may still exist in that space and be somehow accessible. The deleted files could be accessed through the backup file or if the database is detached. However, this risk can be mitigated by making sure the detached data files and backup files have restrictive permissions.

Also, IFI will not happen if Transparent Data Encryption (TDE) is in use.

How to Fix It
SQL Server doesn’t have a setting or checkbox to enable IFI.

Instead, it detects whether or not the service account it’s running under has the Perform Volume Maintenance Tasks permission in the Windows Security Policy. You can find and edit this policy by running secpol.msc (Local Security Policy) in Windows. Then:

Expand the Local Policies Folder
Click on User Rights Assignment
Go down to the “Perform Volume Maintenance Tasks” option and double click it
Add your SQL Server Service account, and click OK out of the dialog.
IFI

After granting this policy to the service account, you’ll need to restart the SQL Server service in order for the policy to take effect and for SQL Server to start using IFI.
*/