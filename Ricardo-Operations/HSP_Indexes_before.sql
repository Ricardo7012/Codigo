USE HSP;  
GO  
/***********************************************************************
NEW PK
-- 79 ROWS
************************************************************************/
--ALTER TABLE [dbo].[BenefitCategoriesHistory]   
--ADD CONSTRAINT PK_BenefitCategoriesHistory_HistoryID PRIMARY KEY CLUSTERED (HistoryID);  
--GO
/***********************************************************************
-- 85,946,554 ROWS
************************************************************************/
ALTER TABLE [dbo].[Claim_Codes] ADD  CONSTRAINT [PK_Claim_Codes] PRIMARY KEY NONCLUSTERED 
(
	[ClaimID] ASC,
	[AdjustmentVersion] ASC,
	[CodeType] ASC,
	[Sequence] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/***********************************************************************
-- 0 ROWS
************************************************************************/
ALTER TABLE [dbo].[Claim_Details_Rx] ADD  CONSTRAINT [PK_Claim_Details_Rx] PRIMARY KEY NONCLUSTERED 
(
	[ClaimID] ASC,
	[AdjustmentVersion] ASC,
	[LineNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/***********************************************************************
-- 29,597,444 ROWS
************************************************************************/
ALTER TABLE [dbo].[Claim_Master] ADD  CONSTRAINT [PK_Claim_Master] PRIMARY KEY NONCLUSTERED 
(
	[ClaimID] ASC,
	[AdjustmentVersion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/***********************************************************************
-- 40,445,853 ROWS 
************************************************************************/
ALTER TABLE [dbo].[Claim_Results] ADD  CONSTRAINT [PK_Claim_Results] PRIMARY KEY NONCLUSTERED 
(
	[ClaimId] ASC,
	[AdjustmentVersion] ASC,
	[LineNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/***********************************************************************
-- 4,855,861 ROWS 
************************************************************************/
ALTER TABLE [dbo].[ClaimCOBData] ADD  CONSTRAINT [PK_Claim_COB] PRIMARY KEY NONCLUSTERED 
(
	[ClaimID] ASC,
	[AdjustmentVersion] ASC,
	[COBIndicator] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/***********************************************************************
-- 6,279,319 ROWS 
************************************************************************/
ALTER TABLE [dbo].[ClaimCOBDataDetails] ADD  CONSTRAINT [PK_Claim_COB_Details] PRIMARY KEY NONCLUSTERED 
(
	[ClaimID] ASC,
	[AdjustmentVersion] ASC,
	[LineNumber] ASC,
	[COBIndicator] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/***********************************************************************
NEW PK 
-- 33,733,015 ROWS 
************************************************************************/
--ALTER TABLE [dbo].[RecordDetails]
--ADD CONSTRAINT PK_RecordDetails_RecordDetailID PRIMARY KEY CLUSTERED (RecordDetailID);  
--GO
/***********************************************************************
PRIMARY KEY NONCLUSTERED 
--12620 ROWS 
************************************************************************/
ALTER TABLE [dbo].[Vendors] ADD  CONSTRAINT [PK_Vendors] PRIMARY KEY NONCLUSTERED 
(
	[VendorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/***********************************************************************

************************************************************************/

