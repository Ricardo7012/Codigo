USE AdventureWorks2019;
GO
SELECT T.TABLE_CATALOG DATABASE_NAME,
       T.TABLE_SCHEMA AS SCHEMA_NAME,
       T.TABLE_NAME,
       C.COLUMN_NAME,
       C.DATA_TYPE DATA_TYPE,
       C.CHARACTER_MAXIMUM_LENGTH MAXIMUM_LENGTH,
       C.COLLATION_NAME
FROM INFORMATION_SCHEMA.COLUMNS C
    INNER JOIN INFORMATION_SCHEMA.TABLES T
        ON C.TABLE_SCHEMA = T.TABLE_SCHEMA
           AND C.TABLE_NAME = T.TABLE_NAME
WHERE T.TABLE_TYPE = 'BASE TABLE'
      AND
      (
          (
              C.DATA_TYPE IN ( 'VARCHAR', 'NVARCHAR' )
              AND C.CHARACTER_MAXIMUM_LENGTH = -1
          )
          OR DATA_TYPE IN ( 'TEXT', 'NTEXT', 'IMAGE', 'VARBINARY', 'XML', 'FILESTREAM' )
      )
      AND T.TABLE_SCHEMA NOT IN ( 'CDC' ) -- EXCEPTION LIST
ORDER BY T.TABLE_SCHEMA,
         T.TABLE_NAME;
GO
/*
In SQL Server, **LOB** stands for **Large Object**¹. LOB data types are used to store large and unstructured data such as text, image, video, and spatial data¹. 

In relational databases, data are typically stored in blocks of a fixed size to allow efficient interaction with storage. If a value comes close to the size of a block or exceeds it, there is an obvious problem storing it in a table column. Such values are typically called LOBs¹.

In SQL Server, LOB data types include `xml`, `varbinary (max)`, and `varchar (max)`¹. The main distinguishing factor is that the values may be stored separately from the row in LOB pages (also known as blocks)¹.

It's important to note that handling LOB data can be complex due to its size and the need for special storage and retrieval mechanisms¹. Therefore, understanding how to work with LOB data is crucial when designing and managing databases³.

Source: Conversation with Bing, 4/22/2024
(1) sql server - What is a "LOB" - Database Administrators Stack Exchange. https://dba.stackexchange.com/questions/247247/what-is-a-lob.
(2) Understanding LOB data (2008/2008R2 & 2012) - SQLskills. https://www.sqlskills.com/blogs/kimberly/understanding-lob-data-20082008r2-2012/.
(3) What is the difference between LOB and binary data in SQL Server?. https://dba.stackexchange.com/questions/186888/what-is-the-difference-between-lob-and-binary-data-in-sql-server.
*/