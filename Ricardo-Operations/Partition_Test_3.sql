/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (100) [HistoryId]
      ,[ChangedBy]
      ,[ChangedAt]
      ,[ChangeType]
      ,[ProcedureName]
      ,[MemberAidCodeId]
      ,[MemberId]
      ,[SubscriberContractId]
      ,[AidCodeId]
      ,[AidCodeType]
      ,[EligibilityStatus]
      ,[EffectiveDate]
      ,[ExpirationDate]
      ,[LastUpdatedBy]
      ,[LastUpdatedAt]
  FROM [HSP].[dbo].[MemberAidCodesHistory]
  ORDER BY effectivedate asc


  SELECT COUNT(*) FROM Sales.SalesOrderHeader
  
USE HSP
GO
  
--TABLE
SELECT b.name, a.partition_number, a.rows, a.*
FROM sys.partitions a WITH (NOLOCK)
INNER JOIN sys.objects b ON a.object_id = b.object_id
WHERE a.OBJECT_ID = 574625090

--INDEXES
SELECT c.name, a.partition_number, a.rows, a.*, c.*
FROM sys.partitions a WITH (NOLOCK)
INNER JOIN sys.indexes c ON a.object_id = c.object_id AND a.index_id = c.Index_id
WHERE a.OBJECT_ID = 574625090
