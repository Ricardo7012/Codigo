--1. Use the following query to find out all the deleted test suite directly(You could run the query in the database directly, do not need to run the query in the backup databases):
SELECT [SuiteId]
      ,[PlanId]
      ,[ParentSuiteId]
      ,[Title]
      ,[Description]
      ,[Revision]
      ,[SuiteType]
      ,[Status]
      ,[InheritConfigs]
      ,[DeletionDate]
  FROM [Tfs_IEHP Projects].[dbo].[tbl_Suite] where DeletionDate is not null

  --2. Run the following query to find out the test case connected to the test suite:
  SELECT [SuiteId]
      ,[TestCaseId]
  FROM [Tfs_IEHP Projects].[dbo].[tbl_SuiteEntry] where SuiteId in(2185,2186,2187,2188,2189,2190)



-- https://blogs.msdn.microsoft.com/nipun-jain/2013/07/07/restore-deleted-test-suite-from-backup-database/
-- https://social.msdn.microsoft.com/Forums/vstudio/en-US/a59f196e-b2ed-4b0f-aa2a-5aeb31b24070/restoring-deleted-test-suite-in-tfsmtm?forum=vsmantest 
-- ******************************************************************
-- EXECUTE ON PRIMARY
-- ******************************************************************
USE [Tfs_IEHP Projects]
GO
--SELECT * FROM [Tfs_IEHP Projects].[dbo].tbl_AuditLog WHERE ObjectType = 11 ORDER BY DateModified DESC --OBJECTid1 REPRESENTS THE DELETED TEST SUITID -- NOTE: DEPRECATED USE TSQL BELOW 

SELECT * FROM [Tfs_IEHP Projects].[dbo].[tbl_Suite] WHERE IsDeleted = 1  ORDER BY LastUpdated DESC --AND  SuiteId IN (7164, 4886, 7162, 7141, 7138)

USE Tfs_TFSDBConfiguration
GO
--FIND IDENTITY
--SELECT * FROM [Tfs_TFSDBConfiguration].[dbo].[tbl_Identity] WHERE Id = '1134AB04-2825-48D7-AF43-798E4DE3B0C3'
--SELECT * FROM [Tfs_TFSDBConfiguration].[dbo].[tbl_Identity] WHERE Id = '3E185B4F-4A93-4DDC-A23D-0246CD8405C0'
--SELECT * FROM [Tfs_TFSDBConfiguration].[dbo].[tbl_Identity] WHERE Id = '0C4632D4-DAA6-4AA9-9152-EF45E64775F9'
--SELECT * FROM [Tfs_TFSDBConfiguration].[dbo].[tbl_Identity]

-- ******************************************************************
-- EXECUTE ON BACKUP RESTORED DB
-- ******************************************************************
USE [Tfs_IEHP Projects]
GO
DECLARE @deletedSuiteId as int = '2182'
--select p.ProjectName, s.*
--from tbl_suite s
--join  tbl_Project p
--on s.ProjectId = p.ProjectId
--where s.SuiteId = @deletedSuiteId 

--select inheritConfigs  from tbl_suite --where SuiteId = @deletedSuiteId -- -- NOTE! NOW IN SAME TBL_SUITE --DEPRECATE

select c.* from tbl_SuiteConfiguration s
join tbl_Configuration c
on s.ConfigurationId = c.ConfigurationId
where s.SuiteId = @deletedSuiteId

select e.TestCaseId
from tbl_SuiteEntry e
where e.SuiteId = @deletedSuiteId
and e.TestCaseId <> 0

select c.Name, r.*
from tbl_TestResult r
join tbl_Point p
on r.TestPointId = p.PointId
 and r.TestRunId = p.LastTestRunId
 and r.TestResultId = p.LastTestResultId
join tbl_configuration c
on c.ConfigurationId = r.ConfigurationId
where p.SuiteId = @deletedSuiteId