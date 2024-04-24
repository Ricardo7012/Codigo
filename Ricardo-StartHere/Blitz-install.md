[[toc]]
# Create dbatools
[create_dbatools.sql](https://github.com/RicardoDSA/Codigo/blob/main/Ricardo-StartHere/create_dbatools.sql)

## https://ola.hallengren.com/
[Entire Solution](https://ola.hallengren.com/scripts/MaintenanceSolution.sql)

Download & install sp_Blitz in any database – it checks the health of the entire server no matter which database it’s installed in. (I usually use the master database just because if it’s installed in there, then you can call it from any database.)

# First Responders Kit
https://github.com/BrentOzarULTD/SQL-Server-First-Responder-Kit
[Ozar](https://github.com/RicardoDSA/Codigo/tree/main/Ozar-First-Responder-Kit)
[Install All](https://github.com/RicardoDSA/Codigo/blob/main/Ozar-First-Responder-Kit/Install-All-Scripts.sql)

## https://www.brentozar.com/blitz/

`EXEC sp_Blitz @CheckUserDatabaseObjects = 0;`

sp_BlitzCache®: Find Your Worst-Performing Queries
## https://www.brentozar.com/blitzcache/

```sql
sp_BlitzCache @Help = 1

sp_BlitzCache @Top = 10, @ExpertMode = 1

sp_BlitzCache @SortOrder= 'CPU', @ExpertMode = 1

-- Common sp_BlitzCache parameters
-- @SortOrder – find the worst queries sorted by reads, CPU, duration, executions, memory grant, or recent compilations. Just use sp_BlitzCache @SortOrder = ‘reads’ for example.
-- @Top – by default, we only look at the top 10 queries, but you can use a larger number here like @Top = 50. Just know that the more queries you analyze, the slower it goes.
-- @ExpertMode = 1 – turns on the more-detailed analysis of things like memory grants.
-- @ExportToExcel = 1 – excludes result set columns that would make Excel blow chunks when you copy/paste the results into Excel, like the execution plans. Good for sharing the plan cache metrics with other folks on your team.
-- @Help = 1 – explains the rest of sp_BlitzCache’s parameters, plus the output columns as well.
```

## https://www.brentozar.com/askbrent/

sp_BlitzFirst Helps You Troubleshoot Slow SQL Servers.
I kept getting emails and phone calls that said, “The SQL Server is running slow right now, and they told me to ask Brent.” Each time, I’d have to:

Look at sp_who or sp_who2 or sp_WhoIsActive for blocking or long-running queries
Review the SQL Server Agent jobs to see if a backup, DBCC, or index maintenance job was running
Query wait statistics to figure out SQL Server’s current bottleneck
Look at Perfmon counters for CPU use, slow drive response times, or low Page Life Expectancy
That’s too much manual work – so I wrote sp_BlitzFirst to do all that in ten seconds or less. Here’s a quick video explaining how it works:

```sql
EXEC sp_BlitzFirst @AsOf = '2024-01-01 08:00', @OutputDatabaseName = 'dbatools', @OutputSchemaName = 'dbo', @OutputTableName = 'BlitzFirstResults'

```
To grant permissions to non-SA users, check out Erland Sommarskog’s post on Giving Permissions through Stored Procedures – specifically, the section on certificates. The below example follows his examples to create a certificate, create a user based on that certificate, grant SA permissions to the user, and then sign the stored procedure and let the public run it: https://www.brentozar.com/askbrent/ 


## https://www.brentozar.com/blitzindex/
Your SQL Server indexes may be less sane than you think. Download sp_BlitzIndex® to find out– or scroll on down and watch a video to see how it help you find out:

Do you have duplicate indexes wasting your storage and memory?
Would you like help to find unused indexes that are bloating your backups?
Have wide clustering keys snuck into your schema, inflating your indexes?
Are there active heaps lurking in your database, causing strange fragmentation?
Is blocking creeping up behind you before you can realize it?
Common sp_BlitzIndex® Parameters
@GetAllDatabases = 1 – runs index tests across all of the databases on the server instead of just your current database context. If you’ve got more than 50 databases on the server, this only works if you also pass in @BringThePain = 1, because it’s gonna be slow. @DatabaseName, @SchemaName, @TableName – if you only want to examine indexes on a particular table, fill all three of these out. @SkipPartitions = 1 – goes faster on databases with large numbers of partitions, like over 500. @Mode – options are:

0 (default) – basic diagnostics of urgent issues
1 – summarize database metrics
2 – index usage detail only
3 – missing indexes only
4 – in-depth diagnostics, including low-priority issues and small objects
@Filter – only works in @Mode = 0. Options are:

0 (default) – no filter
1 – no low-usage warnings for objects with 0 reads
2 – only warn about objects over 500MB
@ThresholdMB = 250 – number of megabytes that an object must be before we display its data in @Mode = 0. @Help = 1 – explains the rest of sp_BlitzIndex’s parameters.

```sql
sp_BlitzIndex
go
sp_BlitzIndex @Mode = 2, @SortOrder = 'size"
go
```

## https://www.brentozar.com/first-aid/sp_blitzwho/
Forget sp_Who and Activity Monitor:
meet sp_BlitzWho.
When you’re trying to troubleshoot a slow query, sp_who and sp_who2 don’t cut it. You need something that shows:

Execution plans
Memory grants
Degrees of parallelism
And a lot more useful stuff for query performance tuners
`sp_BlitzWho`

## https://www.brentozar.com/pastetheplan/
