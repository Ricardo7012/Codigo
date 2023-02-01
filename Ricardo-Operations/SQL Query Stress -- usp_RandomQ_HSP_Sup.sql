-- https://www.brentozar.com/archive/2015/05/how-to-fake-load-tests-with-sqlquerystress/
-- How to Fake Load Tests with SQLQueryStress
-- RICARDO
CREATE PROCEDURE [dbo].[usp_RandomQ_HSP_Sup] WITH RECOMPILE
AS
SET NOCOUNT ON
DECLARE @Id INT
SELECT @Id = CAST(RAND() * 10000000 AS INT)
IF @Id % 7 = 0
    Exec [HSP_Supplemental].[Batch].[usp_SelectHMSProvider]
ELSE IF @Id % 6 = 0
    Exec [HSP_Supplemental].[Batch].[usp_GetTransUnionElig] @DayOfMonth = 1
ELSE IF @Id % 5 = 0
    Exec  [HSP_Supplemental].[Batch].[usp_TransunionProviderMapMerge]
ELSE IF @Id % 4 = 0
    Exec [HSP_Supplemental].[Batch].[CreateProductCodeNDC]
ELSE IF @Id % 3 = 0
    Exec [HSP_Supplemental].[Batch].[usp_SelectAHCTEligibilityData]
ELSE IF @Id % 2 = 0 AND @@SPID % 2 = 0
    Exec [HSP_Supplemental].[MediTrac].[usp_GetClaimsExternalEdit] @EntryDate = '4/1/2018', @ProcessingStatus = N'CLS', @RecordStatus = N'U'
ELSE
    Exec [HSP_Supplemental].[MediTrac].[usp_GetClaimsByStatus]  @StartDate = '8/1/2018', @EndDate = '9/8/2018', @ProcessingStatus = N'CLS', @RecordStatus = N'U'
GO
