SET STATISTICS TIME, IO ON


USE HSP
GO

IF not exists(select 1 from sys.indexes where object_id	= object_id('Members') and name = 'ByMBI')	
  begin
	create index ByMBI on Members(MBI)
  END
  

GO
------******************************************************************************
--SELECT 1
--FROM Records R2
--WHERE EXISTS
--(
--    SELECT 1
--    FROM Claims C WITH (INDEX = byMemberCoverageId)
--    WHERE C.MemberCoverageId = 40000016144800
--          AND R2.ReferenceNumber = C.ClaimId
--)
--      AND R2.RecordType IN ( 'MPD', 'CA', 'A', 'IP', 'AIP', 'AIA', 'RPC', 'RPA', 'ECA', 'RCA', 'INF' );

----******************************************************************************

--GO
IF (
select count(*) from sys.indexes i
			inner join sys.index_columns sic on sic.object_id = i.object_id and
					sic.index_id = i.index_id
			inner join  sys.columns sc on sc.object_id = sic.object_id and sc.column_id = sic.column_ID
		where
			i.object_id = object_ID('records') and
			i.name = 'ByReferenceNumber'
			and
			(
			(sic.is_included_column = 0 and sc.name ='ReferenceNumber' and sic.index_column_id = 1) or
			(sic.is_included_column = 1 and sc.name ='RecordType' and sic.index_column_id = 2) or
			(sic.is_included_column = 1 and sc.name ='RecordStatus' and sic.index_column_id = 3) or
			(sic.is_included_column = 1 and sc.name ='CheckId' and sic.index_column_id = 4) 
			)
			) != 4
begin
	drop index ByReferenceNumber on records
	create index ByReferenceNumber on Records(ReferenceNumber) include (RecordType, RecordStatus, CheckID)
end


/************** Emergency Rollback script
	drop index ByReferenceNumber on records
	create index ByReferenceNumber on Records(ReferenceNumber) 
******************************************************************************/
SET STATISTICS TIME, IO OFF


--USE [HSP_RPT]
--GO

--DECLARE @RC INT
--DECLARE @SessionID [dbo].[Id_t]
--DECLARE @Usage [dbo].[StringShort_t]
--DECLARE @SubscriberContractId [dbo].[Id_t]
--DECLARE @HouseHoldReferenceNumber [dbo].[REFNumber_t]
--DECLARE @ResponsiblePartyId [dbo].[Id_t]
--DECLARE @ReturnStatus [dbo].[YesNo_t]

---- TODO: Set parameter values here.

--EXECUTE @RC = [dbo].[ee_GetMemberCoveragesFlags] 
--   @SessionID
--  ,@Usage
--  ,@SubscriberContractId
--  ,@HouseHoldReferenceNumber
--  ,@ResponsiblePartyId
--  ,@ReturnStatus
--GO


--https://docs.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-show-statistics-transact-sql?view=sql-server-2017
-- Show the statistics for a given index
DBCC SHOW_STATISTICS ('dbo.Records', ByReferenceNumber)
GO