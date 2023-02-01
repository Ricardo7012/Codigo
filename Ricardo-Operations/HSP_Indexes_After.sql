-- https://blogs.msdn.microsoft.com/sql_pfe_blog/2009/12/22/how-and-why-to-enable-instant-file-initialization/
-- https://www.sqlskills.com/blogs/kimberly/instant-initialization-what-why-and-how/
DBCC TRACEON (3004, 3605, -1);
GO

USE HSP;  
GO  
SET STATISTICS IO, TIME ON 
/***********************************************************************
NEW PRIMARY KEY CLUSTERED (HistoryID);
-- 17,454,907 ROWS
--QVSQLHSP01
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.
Table 'BenefitCoveragesHistory'. Scan count 9, logical reads 348939, physical reads 0, read-ahead reads 348946, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 32969 ms,  elapsed time = 11447 ms.

--QVSQLHSP02
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.
Table 'BenefitCoveragesHistory'. Scan count 9, logical reads 348939, physical reads 0, read-ahead reads 348939, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 37562 ms,  elapsed time = 117588 ms.
************************************************************************/
ALTER TABLE [dbo].[BenefitCoveragesHistory]   
ADD CONSTRAINT PK_BenefitCoveragesHistory_HistoryID PRIMARY KEY CLUSTERED (HistoryID);  
GO

/***********************************************************************
-- 85,946,554 ROWS
************************************************************************/
USE [HSP]
GO
/****** Object:  Index [PK_Claim_Codes]    Script Date: 3/27/2019 9:49:55 AM ******/
ALTER TABLE [dbo].[Claim_Codes] DROP CONSTRAINT [PK_Claim_Codes]
GO

ALTER TABLE [dbo].[Claim_Codes] ADD  CONSTRAINT [PK_Claim_Codes] PRIMARY KEY CLUSTERED 
(
	[ClaimID] ASC,
	[AdjustmentVersion] ASC,
	[CodeType] ASC,
	[Sequence] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/***********************************************************************
-- NEW 
************************************************************************/
-- 90,445,128 rows 
ALTER TABLE [dbo].[Claim_Details] DROP CONSTRAINT [PK_Claim_Details]
GO
ALTER TABLE [dbo].[Claim_Details] ADD  CONSTRAINT [PK_Claim_Details] PRIMARY KEY CLUSTERED 
(
	[ClaimID] ASC,
	[AdjustmentVersion] ASC,
	[LineNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


/***********************************************************************
-- 0 ROWS
************************************************************************/
USE [HSP]
GO
/****** Object:  Index [PK_Claim_Details_Rx]    Script Date: 3/27/2019 9:51:16 AM ******/
ALTER TABLE [dbo].[Claim_Details_Rx] DROP CONSTRAINT [PK_Claim_Details_Rx]
GO
ALTER TABLE [dbo].[Claim_Details_Rx] ADD  CONSTRAINT [PK_Claim_Details_Rx] PRIMARY KEY CLUSTERED 
(
	[ClaimID] ASC,
	[AdjustmentVersion] ASC,
	[LineNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/***********************************************************************
-- 29,597,444 ROWS
************************************************************************/
-- 29,597,444
USE [HSP]
GO
ALTER TABLE [dbo].[Claim_Master] DROP CONSTRAINT [PK_Claim_Master]
GO
--17MS 
USE [HSP]
GO
ALTER TABLE [dbo].[Claim_Master] ADD  CONSTRAINT [PK_Claim_Master] PRIMARY KEY CLUSTERED 
(
	[ClaimID] ASC,
	[AdjustmentVersion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
-- elapsed time = 2274556 ms. 37:54

/***********************************************************************
-- 40,445,853 ROWS 
************************************************************************/
-- 40,445,853
USE [HSP]
GO
ALTER TABLE [dbo].[Claim_Results] DROP CONSTRAINT [PK_Claim_Results] --elapsed time = 1531 ms.
GO
ALTER TABLE [dbo].[Claim_Results] ADD  CONSTRAINT [PK_Claim_Results] PRIMARY KEY CLUSTERED 
(
	[ClaimId] ASC,
	[AdjustmentVersion] ASC,
	[LineNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
-- elapsed time = 1324863 ms. 22:04

/***********************************************************************
-- 4,855,861 ROWS 
************************************************************************/
USE [HSP]
GO
/****** Object:  Index [PK_Claim_COB]    Script Date: 3/27/2019 9:52:02 AM ******/
ALTER TABLE [dbo].[ClaimCOBData] DROP CONSTRAINT [PK_Claim_COB]
GO
ALTER TABLE [dbo].[ClaimCOBData] ADD  CONSTRAINT [PK_Claim_COB] PRIMARY KEY CLUSTERED 
(
	[ClaimID] ASC,
	[AdjustmentVersion] ASC,
	[COBIndicator] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/***********************************************************************
-- 6,279,319 ROWS 
************************************************************************/
USE [HSP]
GO
/****** Object:  Index [PK_Claim_COB_Details]    Script Date: 3/27/2019 9:52:27 AM ******/
ALTER TABLE [dbo].[ClaimCOBDataDetails] DROP CONSTRAINT [PK_Claim_COB_Details]
GO
ALTER TABLE [dbo].[ClaimCOBDataDetails] ADD  CONSTRAINT [PK_Claim_COB_Details] PRIMARY KEY CLUSTERED 
(
	[ClaimID] ASC,
	[AdjustmentVersion] ASC,
	[LineNumber] ASC,
	[COBIndicator] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/***********************************************************************
NEW PRIMARY KEY CLUSTERED (RecordDetailID); 
-- 33,733,015 ROWS 

SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.
Table 'RecordDetails'. Scan count 9, logical reads 375979, physical reads 0, read-ahead reads 375979, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 45952 ms,  elapsed time = 103165 ms.
************************************************************************/
ALTER TABLE [dbo].[RecordDetails]
ADD CONSTRAINT PK_RecordDetails_RecordDetailID PRIMARY KEY CLUSTERED (RecordDetailID);  
GO
/***********************************************************************
OLD PRIMARY KEY NONCLUSTERED 
NEW PRIMARY KEY CLUSTERED (VendorId)
--12,620 ROWS 
************************************************************************/
--DROP --15 MS
ALTER TABLE [dbo].[Vendors] DROP CONSTRAINT [PK_Vendors]
GO

--ADD -- 79 MS
ALTER TABLE [dbo].[Vendors] 
ADD  CONSTRAINT [PK_Vendors] PRIMARY KEY CLUSTERED (VendorId)
GO


/***********************************************************************
-- 
************************************************************************/
/*
Missing Index Details from SQLQuery8.sql - QVSQLHSP02.HSP (IEHP\sqladmin9 (70))
The Query Processor estimates that implementing the following index could improve the query cost by 32.459%.
*/
USE [HSP]
GO
CREATE NONCLUSTERED INDEX [IX_LastUpdatedAt]
ON [dbo].[Claim_Master] ([LastUpdatedAt])
GO

/***********************************************************************
---- BLITZ MISSING 
************************************************************************/
USE HSP;
GO
CREATE INDEX [ix_Claims_InputBatchID_includes]
ON [HSP].[dbo].[Claims] ([InputBatchID])
INCLUDE (
            [AdjustmentVersion]
          , [ClaimNumber]
          , [FormType]
          , [ClaimType]
          , [FormSubtype]
        )
WITH (FILLFACTOR = 100, ONLINE = OFF, SORT_IN_TEMPDB = OFF, DATA_COMPRESSION = NONE);


SET STATISTICS IO, TIME OFF

