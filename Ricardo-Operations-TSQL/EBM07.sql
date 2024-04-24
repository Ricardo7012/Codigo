-- EBM07 TEST EVERYTHING
USE [HSP_Supplemental]
GO
EXECUTE [EBM].[ResetExportConfiguration]
EXECUTE [EBM].[TypeLookupReset] 

--IMPORT ALTERNATE ADDRESS TO HSP4S1A.HSP.?
EXECUTE [EBM].[ExportMediTracAidCodes]
EXECUTE [EBM].[ExportMeditracChecks]
EXECUTE [EBM].[ExportMeditracClaims]
EXECUTE [EBM].[ExportMediTracContracts]
EXECUTE [EBM].[ExportMediTracCorporations]
EXECUTE [EBM].[ExportMediTracDiagnosisCodes]
EXECUTE [EBM].[ExportMediTracGroups]
EXECUTE [EBM].[ExportMediTracHospitals]
EXECUTE [EBM].[ExportMediTracMembers]
EXECUTE [EBM].[ExportMediTracProcedureCodes]
EXECUTE [EBM].[ExportMediTracProviders]
EXECUTE [EBM].[ExportMediTracRiskGroups]
EXECUTE [EBM].[ExportMediTracVendors]


--RUN AFTER ALL EXPORTS ARE DONE 
EXECUTE [EBM].[ResetExportConfiguration] 
   @OverrideInUseFlag =1
  ,@ValidateOverrideFlag = 1

