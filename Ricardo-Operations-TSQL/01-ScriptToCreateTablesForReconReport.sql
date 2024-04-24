USE [HSP_Supplemental]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EDI_SubmitterSummaryRecon](
	[EDI_SubmitterSummaryReconId] [int] IDENTITY(1,1) NOT NULL,
	[Submitter] [varchar](100) NULL,
	[RecCountSFTP] [int] NULL,
	[NeverLoadedToHSP] [int] NULL,
	[InvalidOpenNeverValid] [int] NULL,
	[Valid] [int] NULL,
	[CreatedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EDI_SummaryRecon](
	[EDI_SummaryReconId] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NULL,
	[FileCount] [int] NULL,
	[ClaimCount] [int] NULL,
	[CreatedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EDI_FilesInSFTPNotInHSP](
	[EDI_FilesInSFTPNotInHSPId] [int] IDENTITY(1,1) NOT NULL,
	[OrigFileName] [varchar](255) NULL,
	[FileName] [varchar](255) NULL,
	[SFTPLogTime] [datetime] NULL,
	[Folder] [varchar](255) NULL,
	[Submitter] [varchar](100) NULL,
	[RawFileClaimCount] [int] NULL,
	[CreatedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EDI_InvalidOpenFilesInHSP](
	[EDI_InvalidOpenFilesInHSPId] [int] IDENTITY(1,1) NOT NULL,
	[OrigFileName] [varchar](255) NULL,
	[FileName] [varchar](255) NULL,
	[SFTPLogTime] [datetime] NULL,
	[Folder] [varchar](255) NULL,
	[Submitter] [varchar](100) NULL,
	[FileStatus] [varchar](25) NULL,
	[HSPProcessedDate] [datetime] NULL,
	[HSPLogClaimCount] [int] NULL,
	[RawFileClaimCount] [int] NULL,
	[CreatedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EDI_ValidFilesInHSP](
	[EDI_ValidFilesInHSPId] [int] IDENTITY(1,1) NOT NULL,
	[SFTPLogTime] [datetime] NULL,
	[SFTPSubmitter] [varchar](100) NULL,
	[SFTPFileName] [varchar](255) NULL,
	[SFTPFolder] [varchar](255) NULL,
	[HSPFileName] [varchar](255) NULL,
	[HSPProcessedDate] [datetime] NULL,
	[HSPLogClaimCount] [int] NULL,
	[HSPLoadClaimCount] [int] NULL,
	[HSPEmptyDCNClaimCount] [int] NULL,
	[DiamondClaimCount] [int] NULL,
	[RawFileClaimCount] [int] NULL,
	[CreatedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[EDI_SubmitterSummaryRecon] ADD  CONSTRAINT [DF_Rpt_SubmitterSummaryReconCreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[EDI_SummaryRecon] ADD  CONSTRAINT [DF_Rpt_SummaryReconCreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[EDI_FilesInSFTPNotInHSP] ADD  CONSTRAINT [DF_Rpt_FilesInSFTPNotInHSPCreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[EDI_InvalidOpenFilesInHSP] ADD  CONSTRAINT [DF_Rpt_InvalidOpenFilesInHSPCreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[EDI_ValidFilesInHSP] ADD  CONSTRAINT [DF_Rpt_ValidFilesInHSPCreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO




--DROP TABLE [dbo].[EDI_SubmitterSummaryRecon]
--DROP TABLE [dbo].[EDI_SummaryRecon]
--DROP TABLE [dbo].[EDI_FilesInSFTPNotInHSP]
--DROP TABLE [dbo].[EDI_InvalidOpenFilesInHSP]
--DROP TABLE [dbo].[EDI_ValidFilesInHSP]
