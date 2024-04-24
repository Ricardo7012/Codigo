USE [PolybaseDev]
GO
-- CREATE AN EXTERNAL TABLE POINTING TO DATA STORED IN HADOOP WITH CREATE EXTERNAL TABLE. IN THIS EXAMPLE, THE EXTERNAL DATA CONTAINS CAR SENSOR DATA.
-- LOCATION: path to file or directory that contains the data (relative to HDFS root).  
CREATE EXTERNAL TABLE [dbo].[RicardoTest2]
(
	[DR Number] [nvarchar](50) NULL,
	[Area ID] [nvarchar](50) NULL,
	[Area Name] [nvarchar](500) NULL,
	[Reporting District] [nvarchar](50)  NULL,
	[Crime Code] [nvarchar](14)  NULL,
	[Crime Code Description] [nvarchar](500) NULL,
	[Victim Age] [nvarchar](14)  NULL,
	[Victim Sex] [nvarchar](14) NULL,
	[Victim Descent] [nvarchar](14) NULL,
	[Status Code] [nvarchar](20)  NULL,
	[Location] [nvarchar](50) NULL
)
WITH (
	DATA_SOURCE = [DVLAKAMB01]
	,LOCATION = N'/ricardo/'
	,FILE_FORMAT = TSV 
	,REJECT_TYPE = VALUE
	,REJECT_VALUE = 0
	)
GO
SELECT * FROM sys.external_tables -- https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/external-operations-catalog-views-transact-sql?view=sql-server-ver15
GO

--CREATE STATISTICS ON AN EXTERNAL TABLE.
CREATE STATISTICS StatsForCrime2 on RicardoTest2([DR Number], [Area ID])  
GO
PRINT 'STATS DONE'
GO


--USE [PolybaseDev]
--GO
--DROP EXTERNAL DATA SOURCE [DVLAKAMB01]
--GO
--DROP EXTERNAL TABLE [dbo].[RicardoTest2]
--GO
--DROP EXTERNAL FILE FORMAT [CSV]
--GO
