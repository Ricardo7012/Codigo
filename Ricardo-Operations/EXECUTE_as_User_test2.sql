-- https://docs.microsoft.com/en-us/sql/t-sql/statements/execute-as-transact-sql

--USE [master]
--GO
--ALTER DATABASE master SET TRUSTWORTHY ON
--GO
--SELECT [name],is_trustworthy_on FROM sys.databases 
--GO


EXECUTE AS USER = 'IEHP\i3477'
SELECT SUSER_NAME(), USER_NAME()

--SELECT TOP(1) *  FROM HSP.[dbo].[Accounts]


SELECT DISTINCT
       MC.MemberID,
       REM.RowID,
       REM.EffectiveDate,
       REM.ExpirationDate,
       MC.MemberNumber,
       g.GroupNumber
FROM hsp_supplemental.syn.[ReimbursementEntityMap] AS REM WITH (NOLOCK)
    LEFT OUTER JOIN hsp_supplemental.syn.MemberCoverages AS MC WITH (NOLOCK)
        ON REM.EntityId = MC.MemberCoverageID
    LEFT OUTER JOIN hsp_supplemental.syn.SubscriberContracts AS sc WITH (NOLOCK)
        ON mc.SubscriberContractID = sc.SubscriberContractId
    LEFT OUTER JOIN hsp_supplemental.syn.Groups AS g WITH (NOLOCK)
        ON sc.groupid = g.groupid
WHERE EntityType = 'MCV';

REVERT;
GO
SELECT SUSER_NAME(), USER_NAME()
GO
REVERT;
GO
SELECT SUSER_NAME(), USER_NAME()
GO
