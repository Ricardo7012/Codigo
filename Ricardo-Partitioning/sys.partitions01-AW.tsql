SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET STATISTICS IO, TIME ON;

USE AdventureWorks2019;
--GET ODJECT_ID
SELECT b.name,
       a.*
FROM sys.partitions a
    INNER JOIN sys.objects b
        ON a.object_id = b.object_id
WHERE b.name = 'SalesOrderHeader';
--TABLE PARTITIONS
SELECT b.name,
       a.partition_number,
       a.rows,
       a.*
FROM sys.partitions a
    INNER JOIN sys.objects b
        ON a.object_id = b.object_id
WHERE a.object_id = 1602104748;

--INDEXES
SELECT c.name,
       a.partition_number,
       a.rows,
       a.*,
       c.*
FROM sys.partitions a
    INNER JOIN sys.indexes c
        ON a.object_id = c.object_id
           AND a.index_id = c.index_id
WHERE a.object_id = 1602104748

SET STATISTICS IO, TIME OFF;

/*
-- https://learn.microsoft.com/en-us/sql/relational-databases/partitions/partitioned-tables-and-indexes?view=sql-server-ver16#benefits-of-partitioning
Background:
- Latency of your database query will be low if most of the operations happen in memory. Databases go to great lengths to do this automatically. They also offer tuning options to make sure your buffer cache/ buffer pool and other options can be set correctly.

Why partition the table?
- As we keep adding rows to the table, size of primary key index and any other indexes on the table also grows. Once they grow to a point where the entire index does not fit in the configured size of buffer (place where it stores pages that are frequently accessed), the database engine will have to go and fetch index pages from disk and thus slowing down the query.

Its not superior or inferior to indexes, its a different technique.

Before going the partitioning route
    1. Check the explain plan of the query (if there is a particular access pattern) and tune it to make sure right indexes are used and disk operations are limited.
    2. Check the size of the table and index in question and how it relates to the configured database memory (buffer pool).
    3. Check if the table can be defragmented. 
    4. Check if you can add memory to server.

Advantages of partitioning
- Smaller tables, smaller indexes, lower query latency.

Disadvantages
- intrusive as application needs changes to write to the correct partition. If the number of partitions is out-grown, you have the same issue with the partitions. 
-- https://learn.microsoft.com/en-us/sql/relational-databases/partitions/partitioned-tables-and-indexes?view=sql-server-ver15#performance-guidelines
The database engine supports up to 15,000 partitions per table or index. However, using more than 1,000 partitions has implications on memory, partitioned index operations, DBCC commands, and queries. This section describes the performance implications of using more than 1,000 partitions and provides workarounds as needed.

With up to 15,000 partitions allowed per partitioned table or index, you can store data for long durations in a single table. However, you should retain data only for as long as it is needed and maintain a balance between performance and the number of partitions.

*/