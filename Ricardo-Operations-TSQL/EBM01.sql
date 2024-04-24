-- 01 DROP EBM OBJECTS
USE [HSP_Supplemental]
DROP TABLE [EBM].[ExportConfiguration]
DROP TABLE [EBM].[EnrolledMembers_Languages]
DROP TABLE [EBM].[AidCodes]
DROP TABLE [EBM].[Checks]
DROP TABLE [EBM].[Claims]
DROP TABLE [EBM].[ClaimsDetail]
DROP TABLE [EBM].[Contracts]
DROP TABLE [EBM].[Corporations]
DROP TABLE [EBM].[DiagnosisCodes]
DROP TABLE [EBM].[EnrolledMembers]
DROP TABLE [EBM].[EnrolledMembers_AidCodes]
DROP TABLE [EBM].[EnrolledMembers_AssignedProviders]
DROP TABLE [EBM].[EnrolledMembers_COBCustomAttributes]
DROP TABLE [EBM].[Vendors]
DROP TABLE [EBM].[RiskGroups_HospitalMappings]
DROP TABLE [EBM].[EnrolledMembers_MemberCoverageDetails]
DROP TABLE [EBM].[EnrolledMembers_MemberCustomAttributes]
DROP TABLE [EBM].[EnrolledMembers_Reimbursements]
DROP TABLE [EBM].[EnrolledMembers_ResponsibleParties]
DROP TABLE [EBM].[Groups]
DROP TABLE [EBM].[Hospitals]
DROP TABLE [EBM].[Hospitals_EntityMap]
DROP TABLE [EBM].[ProcedureCodes]
DROP TABLE [EBM].[ProcedureCodes_Modifier]
DROP TABLE [EBM].[Providers]
DROP TABLE [EBM].[Providers_OfficeMapCustomAttributes]
DROP TABLE [EBM].[RiskGroups]
DROP TABLE [EBM].[RiskGroups_AlternateAddress]
DROP TABLE [EBM].[EnrolledMembers_MemberCOBs]
GO

DROP PROCEDURE [EBM].[TypeLookupReset]
DROP PROCEDURE [EBM].[TypeLookupDelete]
DROP PROCEDURE [EBM].[ResetExportConfiguration]
DROP PROCEDURE [EBM].[ReadMediTracVendors]
DROP PROCEDURE [EBM].[ReadMediTracVendorAlternateAddress]
DROP PROCEDURE [EBM].[ReadMediTracRiskGroups]
DROP PROCEDURE [EBM].[ReadMediTracRiskGroupHospitalMapping]
DROP PROCEDURE [EBM].[ReadMediTracRiskGroupAlternateAddress]
DROP PROCEDURE [EBM].[ReadMediTracProvidersOfficeMapCustomAttributes]
DROP PROCEDURE [EBM].[ReadMediTracProviders]
DROP PROCEDURE [EBM].[ReadMediTracProcedureCodesModifiers]
DROP PROCEDURE [EBM].[ReadMediTracProcedureCodes]
DROP PROCEDURE [EBM].[ReadMediTracMemberResponsibleParties]
DROP PROCEDURE [EBM].[ReadMediTracMemberReimbursements]
DROP PROCEDURE [EBM].[ReadMediTracMemberMain]
DROP PROCEDURE [EBM].[ReadMediTracMemberLanguages]
DROP PROCEDURE [EBM].[ReadMediTracMemberCustomAttributes]
DROP PROCEDURE [EBM].[ReadMediTracMemberCoverageDetails]
DROP PROCEDURE [EBM].[ReadMediTracMemberCobs]
DROP PROCEDURE [EBM].[ReadMediTracMemberCobCustomAttributes]
DROP PROCEDURE [EBM].[ReadMediTracMemberAssignedProviders]
DROP PROCEDURE [EBM].[ReadMediTracMemberAlternateAddress]
DROP PROCEDURE [EBM].[ReadMediTracMemberAidCodes]
DROP PROCEDURE [EBM].[ReadMediTracHospitals]
DROP PROCEDURE [EBM].[ReadMediTracHospitalEntityMap]
DROP PROCEDURE [EBM].[ReadMediTracGroups]
DROP PROCEDURE [EBM].[ReadMediTracDiagnosisCodes]
DROP PROCEDURE [EBM].[ReadMediTracCorporations]
DROP PROCEDURE [EBM].[ReadMediTracContracts]
DROP PROCEDURE [EBM].[ReadMediTracClaims]
DROP PROCEDURE [EBM].[ReadMediTracAidCodes]
--DROP PROCEDURE [EBM].[ProviderMapRead]
DROP PROCEDURE [EBM].[GetMediTracTables]
--DROP PROCEDURE [EBM].[GenerateSchemaStructure]
DROP PROCEDURE [EBM].[ExportMediTracVendors]
DROP PROCEDURE [EBM].[ExportMediTracRiskGroups]
DROP PROCEDURE [EBM].[ExportMediTracProviders]
DROP PROCEDURE [EBM].[ExportMediTracProcedureCodes]
DROP PROCEDURE [EBM].[ExportMediTracMembers]
DROP PROCEDURE [EBM].[ExportMediTracHospitals]
DROP PROCEDURE [EBM].[ExportMediTracGroups]
DROP PROCEDURE [EBM].[ExportMediTracDiagnosisCodes]
DROP PROCEDURE [EBM].[ExportMediTracCorporations]
DROP PROCEDURE [EBM].[ExportMediTracContracts]
DROP PROCEDURE [EBM].[ExportMeditracClaims]
DROP PROCEDURE [EBM].[ExportMeditracChecks]
DROP PROCEDURE [EBM].[ExportMediTracAidCodes]
DROP PROCEDURE [EBM].[DropProcedureCodesModifier]
DROP PROCEDURE [EBM].[BuildRiskGroupIndexes]
DROP PROCEDURE [EBM].[BuildProviderIndexes]
DROP PROCEDURE [EBM].[BuildMemberIndexes]
DROP PROCEDURE [EBM].[BuildHospitalIndexes]
GO
--DROP TYPE [dbo].[ZipPlus4_t]
--
--DROP TYPE [dbo].[Zip_t]
--
--DROP TYPE [dbo].[YesNo_t]
--
--DROP TYPE [dbo].[Type_t]
--
--DROP TYPE [dbo].[Suffix_t]
--
--DROP TYPE [dbo].[StringShort_t]
--
--DROP TYPE [dbo].[StringMedium_t]
--
--DROP TYPE [dbo].[StringLong_t]
--
--DROP TYPE [dbo].[State_t]
--
--DROP TYPE [dbo].[REFNumber_t]
--
--DROP TYPE [dbo].[Real_t]
--
--DROP TYPE [dbo].[ProcedureCode_t]
--
--DROP TYPE [dbo].[Prefix_t]
--
--DROP TYPE [dbo].[PostalCode_t]
--
--DROP TYPE [dbo].[PhoneExt_t]
--
--DROP TYPE [dbo].[Phone_t]
--
--DROP TYPE [dbo].[Number_t]
--
--DROP TYPE [dbo].[Name_t]
--
--DROP TYPE [dbo].[Money_t]
--
--DROP TYPE [dbo].[Money_Extended_t]
--
--DROP TYPE [dbo].[Modifier_t]
--
--DROP TYPE [dbo].[MiddleName_t]
--
--DROP TYPE [dbo].[MiddleInitial_t]
--
--DROP TYPE [dbo].[LastName_t]
--
--DROP TYPE [dbo].[IDNumber_t]
--
--DROP TYPE [dbo].[Id_t]
--
--DROP TYPE [dbo].[HealthCareCode_t]
--
--DROP TYPE [dbo].[Gender_t]
--
--DROP TYPE [dbo].[FullName_t]
--
--DROP TYPE [dbo].[FirstName_t]
--
--DROP TYPE [dbo].[ErrorMsg_t]
--
--DROP TYPE [dbo].[Email_t]
--
--DROP TYPE [dbo].[Description_t]
--
--DROP TYPE [dbo].[Date_t]
--
--DROP TYPE [dbo].[Data_t]
--
--DROP TYPE [dbo].[County_t]
--
--DROP TYPE [dbo].[Code_t]
--
--DROP TYPE [dbo].[ClaimNumber_t]
--
--DROP TYPE [dbo].[City_t]
--
--DROP TYPE [dbo].[Address_t]
--
--DROP TYPE [dbo].[AccountNumber_t]
--GO

