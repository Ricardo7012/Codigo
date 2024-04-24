USE [master];
GO
ALTER DATABASE [AdventureWorks2019] ADD FILEGROUP [SECONDARY];
GO
ALTER DATABASE [AdventureWorks2019]
ADD FILE
    (
        NAME = N'AdventureWorks2019_2',
        FILENAME = N'E:\Data\AdventureWorks2019_2.ndf',
        SIZE = 270336KB,
        FILEGROWTH = 65536KB
    )
TO FILEGROUP [SECONDARY];
GO

USE [AdventureWorks2019];
GO
BEGIN TRANSACTION;
CREATE PARTITION FUNCTION [pf_PartitionByYear] (DATETIME)
AS RANGE RIGHT FOR VALUES
(   N'2011-01-01T00:00:00',
    N'2012-01-01T00:00:00',
    N'2013-01-01T00:00:00',
    N'2014-01-01T00:00:00',
    N'2015-01-01T00:00:00',
    N'2016-01-01T00:00:00',
    N'2017-01-01T00:00:00',
    N'2018-01-01T00:00:00',
    N'2019-01-01T00:00:00',
    N'2020-01-01T00:00:00',
    N'2021-01-01T00:00:00',
    N'2022-01-01T00:00:00',
    N'2023-01-01T00:00:00',
    N'2024-01-01T00:00:00'
);


CREATE PARTITION SCHEME [ps_PartitionByYear]
AS PARTITION [pf_PartitionByYear]
TO
(
    [PRIMARY],
    [SECONDARY],
    [PRIMARY],
    [SECONDARY],
    [PRIMARY],
    [SECONDARY],
    [PRIMARY],
    [SECONDARY],
    [PRIMARY],
    [SECONDARY],
    [PRIMARY],
    [SECONDARY],
    [PRIMARY],
    [PRIMARY],
    [PRIMARY]
);


ALTER TABLE [Sales].[SalesOrderDetail]
DROP CONSTRAINT [FK_SalesOrderDetail_SalesOrderHeader_SalesOrderID];


ALTER TABLE [Sales].[SalesOrderHeaderSalesReason]
DROP CONSTRAINT [FK_SalesOrderHeaderSalesReason_SalesOrderHeader_SalesOrderID];

ALTER TABLE [Sales].[SalesOrderHeader]
DROP CONSTRAINT [PK_SalesOrderHeader_SalesOrderID]
WITH
(ONLINE = OFF);


ALTER TABLE [Sales].[SalesOrderHeader]
ADD CONSTRAINT [PK_SalesOrderHeader_SalesOrderID]
    PRIMARY KEY NONCLUSTERED ([SalesOrderID] ASC)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF,
          ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
         ) ON [PRIMARY];


CREATE CLUSTERED INDEX [ClusteredIndex_on_ps_PartitionByYear_638285604851490561]
ON [Sales].[SalesOrderHeader] ([OrderDate])
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF)
ON [ps_PartitionByYear]([OrderDate]);


DROP INDEX [ClusteredIndex_on_ps_PartitionByYear_638285604851490561]
ON [Sales].[SalesOrderHeader];

ALTER TABLE [Sales].[SalesOrderDetail] WITH CHECK
ADD CONSTRAINT [FK_SalesOrderDetail_SalesOrderHeader_SalesOrderID]
    FOREIGN KEY ([SalesOrderID])
    REFERENCES [Sales].[SalesOrderHeader] ([SalesOrderID]) ON DELETE CASCADE;
ALTER TABLE [Sales].[SalesOrderDetail] CHECK CONSTRAINT [FK_SalesOrderDetail_SalesOrderHeader_SalesOrderID];


ALTER TABLE [Sales].[SalesOrderHeaderSalesReason] WITH CHECK
ADD CONSTRAINT [FK_SalesOrderHeaderSalesReason_SalesOrderHeader_SalesOrderID]
    FOREIGN KEY ([SalesOrderID])
    REFERENCES [Sales].[SalesOrderHeader] ([SalesOrderID]) ON DELETE CASCADE;
ALTER TABLE [Sales].[SalesOrderHeaderSalesReason] CHECK CONSTRAINT [FK_SalesOrderHeaderSalesReason_SalesOrderHeader_SalesOrderID];

COMMIT TRANSACTION;


--MAKE SURE TO CREATE A NEW INDEX
USE [AdventureWorks2019-P];
GO
CREATE CLUSTERED INDEX [ClusteredIndex-20230825-123605]
ON [Sales].[SalesOrderHeader] ([SalesOrderID] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF,
      ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
     )
ON [ps_PartitionByYear]([OrderDate]);
GO

