SET STATISTICS IO, TIME ON;
USE [AdventureWorks2019-NP]
go
SELECT *
FROM Sales.SalesOrderHeader a
    LEFT OUTER JOIN Sales.SalesOrderDetail b
        ON a.SalesOrderID = b.SalesOrderID
WHERE a.orderdate between '2014-01-02T00:00:00' and '2014-06-21T00:00:00'
go
-- P = PARTITIONED 
USE [AdventureWorks2019-P]
go
SELECT *
FROM Sales.SalesOrderHeader a
    LEFT OUTER JOIN Sales.SalesOrderDetail b
        ON a.SalesOrderID = b.SalesOrderID
WHERE a.orderdate between '2014-01-02T00:00:00' and '2014-06-21T00:00:00'
go
SET STATISTICS IO, TIME OFF;