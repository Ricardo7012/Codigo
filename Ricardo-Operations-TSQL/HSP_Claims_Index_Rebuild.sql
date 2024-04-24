USE HSP_MO;   
GO  
ALTER INDEX ALL ON [dbo].[Claims] REBUILD; 
GO
ALTER INDEX ALL ON [dbo].[Claim_Details] REBUILD; 
GO
ALTER INDEX ALL ON [dbo].[Claim_Master] REBUILD;
GO
ALTER INDEX ALL ON [dbo].[Claim_Results] REBUILD; 
GO
ALTER INDEX ALL ON [dbo].[Claim_Master_Data] REBUILD; 
GO
ALTER INDEX ALL ON [dbo].[ClaimActionCodeMap] REBUILD; 
GO
ALTER INDEX ALL ON [dbo].[EDIXacts] REBUILD; 
GO
ALTER INDEX ALL ON [dbo].[ProviderPickingStatistics] REBUILD; 
GO
ALTER INDEX ALL ON [dbo].[PendedClaimExplanationMap] REBUILD; 
GO
