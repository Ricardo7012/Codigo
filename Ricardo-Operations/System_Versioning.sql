USE [HSP_Supplemental]
GO

ALTER TABLE [Member].[Qualifiers] SET (SYSTEM_VERSIONING = OFF )
GO

ALTER TABLE [Member].[Qualifiers] DROP PERIOD FOR SYSTEM_TIME
GO

DROP TABLE	[Member].[Qualifiers]
GO

DROP TABLE	[Member].[QualifiersHistory]
GO
