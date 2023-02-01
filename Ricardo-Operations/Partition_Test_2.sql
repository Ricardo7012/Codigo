USE [HSP];
GO
SET STATISTICS IO ON;

SELECT  [HistoryId]
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
FROM    [dbo].[MemberAidCodesHistory]
WHERE   Effectivedate BETWEEN '2016-10-01'
                      AND     '2016-12-31';
GO


SELECT  [HistoryId]
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
FROM    [dbo].[MemberAidCodesHistory_NOPARTITION]
WHERE   Effectivedate BETWEEN '2016-10-01'
                      AND     '2016-12-31';
GO

SET STATISTICS IO OFF;
