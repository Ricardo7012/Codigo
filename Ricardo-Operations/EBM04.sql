-- 04 CREATE TABLES


USE HSP_Supplemental
GO
CREATE TABLE [EBM].[ExportConfiguration]
(
[ExportConfigurationId] [int] NOT NULL IDENTITY(1, 1),
[ComponentName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StoredProcedureReadName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TableName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PreviousExecution] [datetime] NULL,
[LastExecution] [datetime] NULL,
[IsWriteLocked] [bit] NOT NULL,
[IsReadLocked] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [EBM].[ExportConfiguration] ADD CONSTRAINT [PK_ExportConfiguration_1] PRIMARY KEY CLUSTERED  ([ExportConfigurationId]) ON [PRIMARY]
GO
