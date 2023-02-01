--  https://www.brentozar.com/blitz/transaction-log-larger-than-data-file/

/* Use the database */
USE [HSP]
GO
 
/* Check the name and size of the transaction log file*/
/* The log is fileid=2, and usage says "log only" */
/* Bonus: make sure you do NOT have more than one log file, that does not help performance */
exec sp_helpfile;
GO
 
/* Shrink the log file */
/* The file size is stated in megabytes*/
DBCC SHRINKFILE (HSP_log, 307200);
GO
 
/* Check if it worked. It won't always do what you want if the database is active */
/* You may need to wait for a log backup or more activity to get the log to shrink */
exec sp_helpfile;
GO