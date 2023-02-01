/*
	Purpose:			To Enable CDC on specific tables
	Author:				Sheetal Soni
	Reviewed by :		Leo 
	Date :				3/21/2017
	Version :			1.0 

*/
/****************************************************************/



--Enable CDC
use Network_Development
GO
EXEC sys.sp_cdc_enable_db
GO


/************************PROVIDER *************************************/
/* Setup Column-Specific Table-level CDC */
use Network_Development
EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name   = N'Tbl_Provider_ProviderInfo',
@role_name     = Null,
@captured_column_list = 
					  '
						[PPI_ID],
						[PPI_FirstName],
						[PPI_LastName],
						[PPI_MiddleName],
						[PPI_Group], 
						[PPI_UPIN],
						[PPI_Degree],
						[PPI_Ethnicity],
						[PPI_DOB],
						[PPI_Gender],
						[PPI_Type],
						[PPI_Salutation],
						[PPI_CCS],
						[PPI_Specialty1],
						[PPI_Specialty2],
						[PPI_Specialty3],
						[PPI_RosterSuppression],
						[PPI_SPDOptOut],
						[PPI_SPDOptOutDate],
						[PPI_License],
						[PPI_MediCalID],
						[PPI_MedicareID],
						[PPI_Specialty1Cert],
						[PPI_Specialty2Cert],
						[PPI_Specialty3Cert],
						[PPI_Specialty1Direct],
						[PPI_Specialty2Direct],
						[PPI_Specialty3Direct],
						[PPI_ProviderStatus]
					 '

/************************************************************************************************************/


/************************OFFICES *************************************/


use Network_Development
EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name   = N'Tbl_Contract_locations',
@role_name     = Null,
@captured_column_list = '
						[CL_ID],
						[CL_State],
						[CL_Zip],
						[CL_BusStop],
						[CL_ApptOnly],
						[CL_ExamRoom],
						[CL_ExamTable],
						[CL_ExtBuilding],
						[CL_IntBuilding],
						[CL_LevelofAccess],
						[CL_UCComments],
						[CL_StaffLanguage],
						[CL_ClinicalLanguage],
						[CL_OfficeHours],
						[CL_Parking],
						[CL_Restroom],
						[CL_RosterSuppression],
						[CL_UrgentCare],
						[CL_UCHours],
						[CL_Signage],
						[CL_Walkin],
						[CL_SafetyNet],
						[CL_ReferralFax],
						[CL_MedicalGroup],
						[CL_Email],
						[CL_FC],
						[CL_FO],
						[CL_HC],
						[CL_HO],
						[CL_MC],
						[CL_MO],
						[CL_WC],
						[CL_WO],
						[CL_SC],
						[CL_SO],
						[CL_TC],
						[CL_TO],
						[CL_UC],
						[CL_UO],
						[CL_FC_UC],
						[CL_FO_UC],
						[CL_HC_UC],
						[CL_HO_UC],
						[CL_MC_UC],
						[CL_MO_UC],
						[CL_WC_UC],
						[CL_WO_UC],
						[CL_SC_UC],
						[CL_SO_UC],
						[CL_TC_UC],
						[CL_TO_UC],
						[CL_UC_UC],
						[CL_UO_UC]'

/************************************************************************************************************/

/**********************************PROVIDER CONTRACT************************************************************************/
use Network_Development
EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name   = N'Tbl_Provider_ProviderAffiliation',
@role_name     = Null,
@captured_column_list = '[PPA_ID],
					     [PPA_ProviderID],
						 [PPA_EffDate],
						 [PPA_TermDate],
						 [PPA_PanelStatus],
						 [PPA_AffiliationType],
						 [PPA_IPAID],
						 [PPA_HospitalID],
						 [PPA_PCPID]
						 					 '



/************************************************************************************************************/
use Network_Development
EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name   = N'Tbl_Provider_ProviderAffiliationIPA',
@role_name     = Null,
@captured_column_list = '[PPAI_ID],
					     [PPAI_ProviderID],
						 [PPAI_TermDate],
						 [PPAI_IPAID],
						 [PPAI_AgeLimit],
						 [PPAI_IPAStatus]
						 					 '



/************************************************************************************************************/



