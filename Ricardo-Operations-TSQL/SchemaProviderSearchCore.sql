USE [ProviderSearchCore]
GO
/****** Object:  User [IEHP\ITDevelopment]    Script Date: 3/14/2018 4:20:41 PM ******/
CREATE USER [IEHP\ITDevelopment] FOR LOGIN [IEHP\ITDevelopment] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [ProviderSearchUser]    Script Date: 3/14/2018 4:20:41 PM ******/
CREATE USER [ProviderSearchUser] FOR LOGIN [ProviderSearchUser] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  DatabaseRole [db_developer]    Script Date: 3/14/2018 4:20:41 PM ******/
CREATE ROLE [db_developer]
GO
/****** Object:  DatabaseRole [db_executor]    Script Date: 3/14/2018 4:20:41 PM ******/
CREATE ROLE [db_executor]
GO
ALTER ROLE [db_developer] ADD MEMBER [IEHP\ITDevelopment]
GO
ALTER ROLE [db_owner] ADD MEMBER [IEHP\ITDevelopment]
GO
ALTER ROLE [db_executor] ADD MEMBER [ProviderSearchUser]
GO
/****** Object:  Schema [changed]    Script Date: 3/14/2018 4:20:41 PM ******/
CREATE SCHEMA [changed]
GO
/****** Object:  Schema [GeoCode]    Script Date: 3/14/2018 4:20:41 PM ******/
CREATE SCHEMA [GeoCode]
GO
/****** Object:  Schema [Import]    Script Date: 3/14/2018 4:20:41 PM ******/
CREATE SCHEMA [Import]
GO
/****** Object:  Schema [Search]    Script Date: 3/14/2018 4:20:41 PM ******/
CREATE SCHEMA [Search]
GO
/****** Object:  UserDefinedTableType [changed].[DataLogList]    Script Date: 3/14/2018 4:20:41 PM ******/
CREATE TYPE [changed].[DataLogList] AS TABLE(
	[TableName] [varchar](100) NULL,
	[TablePKFiedName] [varchar](100) NULL,
	[TablePKFieldValue] [varchar](50) NULL,
	[ChangedFieldName] [varchar](100) NULL,
	[ChangedOldValue] [varchar](500) NULL,
	[ChangedNewValue] [varchar](500) NULL,
	[LogType] [varchar](100) NULL
)
GO
/****** Object:  UserDefinedTableType [changed].[DataLogObjectList]    Script Date: 3/14/2018 4:20:41 PM ******/
CREATE TYPE [changed].[DataLogObjectList] AS TABLE(
	[TableName] [varchar](100) NULL,
	[TablePKFiedName] [varchar](100) NULL,
	[TablePKFieldValue] [varchar](50) NULL,
	[DataObject] [xml] NULL,
	[LogType] [varchar](100) NULL
)
GO
/****** Object:  UserDefinedTableType [changed].[UpdatedDataLogRecord]    Script Date: 3/14/2018 4:20:41 PM ******/
CREATE TYPE [changed].[UpdatedDataLogRecord] AS TABLE(
	[DataLogRecordId] [int] NULL,
	[Value1] [varchar](50) NULL,
	[Value2] [varchar](20) NULL,
	[Value3] [varchar](20) NULL
)
GO
/****** Object:  UserDefinedTableType [GeoCode].[AllProviderAddresses]    Script Date: 3/14/2018 4:20:41 PM ******/
CREATE TYPE [GeoCode].[AllProviderAddresses] AS TABLE(
	[ProviderId] [varchar](12) NOT NULL,
	[ProviderType] [varchar](12) NOT NULL,
	[SeqNo] [varchar](5) NOT NULL,
	[Address] [varchar](100) NULL,
	[Address2] [varchar](61) NULL,
	[City] [varchar](30) NULL,
	[State] [varchar](2) NULL,
	[Zip] [varchar](9) NULL,
	[County] [varchar](40) NULL,
	[RowHash] [varbinary](16) NULL
)
GO
/****** Object:  UserDefinedTableType [GeoCode].[ProviderGeoAddresses]    Script Date: 3/14/2018 4:20:41 PM ******/
CREATE TYPE [GeoCode].[ProviderGeoAddresses] AS TABLE(
	[AddressId] [int] NULL,
	[Address] [varchar](61) NULL,
	[Address2] [varchar](61) NULL,
	[City] [varchar](30) NULL,
	[State] [varchar](15) NULL,
	[Zip] [varchar](9) NULL,
	[County] [varchar](30) NULL,
	[GeocodedStreetNumber] [varchar](100) NULL,
	[GeocodedRoute] [varchar](100) NULL,
	[GeocodedCity] [varchar](30) NULL,
	[GeocodedState] [varchar](15) NULL,
	[GeocodedZip] [varchar](9) NULL,
	[GeocodedCounty] [varchar](30) NULL,
	[Lat] [float] NULL,
	[Lng] [float] NULL,
	[Accuracy] [int] NULL,
	[GeoCodeResult] [xml] NULL
)
GO
/****** Object:  UserDefinedTableType [Search].[AddressIdList]    Script Date: 3/14/2018 4:20:41 PM ******/
CREATE TYPE [Search].[AddressIdList] AS TABLE(
	[AddressId] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [Search].[AffiliationLobList]    Script Date: 3/14/2018 4:20:41 PM ******/
CREATE TYPE [Search].[AffiliationLobList] AS TABLE(
	[Lob] [varchar](50) NULL
)
GO
/****** Object:  UserDefinedTableType [Search].[AffiliationPanelList]    Script Date: 3/14/2018 4:20:41 PM ******/
CREATE TYPE [Search].[AffiliationPanelList] AS TABLE(
	[PanelId] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [Search].[DoctorTypes]    Script Date: 3/14/2018 4:20:41 PM ******/
CREATE TYPE [Search].[DoctorTypes] AS TABLE(
	[type] [varchar](25) NULL
)
GO
/****** Object:  UserDefinedTableType [Search].[PanelLobList]    Script Date: 3/14/2018 4:20:41 PM ******/
CREATE TYPE [Search].[PanelLobList] AS TABLE(
	[PanelId] [varchar](15) NULL,
	[Lob] [varchar](50) NULL
)
GO
/****** Object:  UserDefinedTableType [Search].[ProviderIdList]    Script Date: 3/14/2018 4:20:41 PM ******/
CREATE TYPE [Search].[ProviderIdList] AS TABLE(
	[ProviderId] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [Search].[ProviderTypes]    Script Date: 3/14/2018 4:20:41 PM ******/
CREATE TYPE [Search].[ProviderTypes] AS TABLE(
	[ProviderTypes] [varchar](40) NULL
)
GO
/****** Object:  UserDefinedFunction [Search].[Split]    Script Date: 3/14/2018 4:20:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create function [Search].[Split]
	(
	 @InputString varchar(8000)
	,@Delimiter varchar(50)
	)
returns @Items table (Item varchar(8000))
as
	begin
		if @Delimiter = ' '
			begin
				set @Delimiter = ','
				set @InputString = replace(@InputString, ' ', @Delimiter)
			end

		if (
			@Delimiter is null
			or @Delimiter = ''
		   )
			set @Delimiter = ','

--INSERT INTO @Items VALUES (@Delimiter) -- Diagnostic
--INSERT INTO @Items VALUES (@InputString) -- Diagnostic

		declare @Item varchar(8000)
		declare @ItemList varchar(8000)
		declare @DelimIndex int

		set @ItemList = @InputString
		set @DelimIndex = charindex(@Delimiter, @ItemList, 0)
		while (@DelimIndex != 0)
			begin
				set @Item = substring(@ItemList, 0, @DelimIndex)
				insert into @Items
					values (@Item)

            -- Set @ItemList = @ItemList minus one less item
				set @ItemList = substring(@ItemList, @DelimIndex + 1, len(@ItemList) - @DelimIndex)
				set @DelimIndex = charindex(@Delimiter, @ItemList, 0)
			end -- End WHILE

		if @Item is not null -- At least one delimiter was encountered in @InputString
			begin
				set @Item = @ItemList
				insert into @Items
					values (@Item)
			end

      -- No delimiters were encountered in @InputString, so just return @InputString
		else
			insert into @Items
				values (@InputString)

		return

	end
 -- End Function


GO
/****** Object:  UserDefinedFunction [Search].[udf_TitleCase]    Script Date: 3/14/2018 4:20:41 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

create   function [Search].[udf_TitleCase]
	(
	 @InputString varchar(4000)
	)
returns varchar(4000)
as
	begin
		declare @Index int
		declare @Char char(1)
		declare @OutputString varchar(255)
		set @OutputString = lower(@InputString)
		set @Index = 2
		set @OutputString = stuff(@OutputString, 1, 1, upper(substring(@InputString, 1, 1)))
		while @Index <= len(@InputString)
			begin
				set @Char = substring(@InputString, @Index, 1)
				if @Char in (' ', ';', ':', '!', '?', ',', '.', '_', '-', '/', '&', '''', '(')
					if @Index + 1 <= len(@InputString)
						begin
							if @Char != ''''
								or upper(substring(@InputString, @Index + 1, 1)) != 'S'
								set @OutputString = stuff(@OutputString, @Index + 1, 1, upper(substring(@InputString, @Index + 1, 1)))
						end
				set @Index = @Index + 1
			end
		return isnull(@OutputString,null)
	end


GO
/****** Object:  Table [Search].[Address]    Script Date: 3/14/2018 4:20:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search].[Address](
	[AddressID] [int] IDENTITY(1,1) NOT NULL,
	[ProviderID] [int] NOT NULL,
	[Street] [varchar](100) NULL,
	[City] [varchar](150) NULL,
	[Zip] [varchar](9) NULL,
	[County] [varchar](100) NULL,
	[CountyCode] [int] NULL,
	[Phone] [varchar](20) NULL,
	[AfterHoursPhone] [varchar](10) NULL,
	[Fax] [varchar](20) NULL,
	[Email] [varchar](100) NULL,
	[WebSite] [varchar](100) NULL,
	[BusStop] [int] NULL,
	[BusRoute] [varchar](30) NULL,
	[Accessibility] [varchar](50) NULL,
	[Walkin] [bit] NULL,
	[BuildingSign] [varchar](100) NULL,
	[AppointmentNeeded] [bit] NULL,
	[Hours] [varchar](150) NULL,
	[Latitude] [float] NULL,
	[Longitude] [float] NULL,
	[LocationID] [varchar](6) NULL,
	[MedicalGroup] [varchar](100) NULL,
	[ContractID] [int] NULL,
	[FederallyQualifiedHC] [bit] NULL,
	[State] [varchar](20) NULL,
	[IsInternalOnly] [bit] NULL,
	[IsEnabled] [bit] NOT NULL,
	[Street2] [varchar](55) NULL,
 CONSTRAINT [PK_Address] PRIMARY KEY CLUSTERED 
(
	[AddressID] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Search].[Languages]    Script Date: 3/14/2018 4:20:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search].[Languages](
	[LanguageID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](75) NULL,
	[ISOCode] [varchar](10) NULL,
 CONSTRAINT [PK_Languages] PRIMARY KEY CLUSTERED 
(
	[LanguageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Search].[Provider]    Script Date: 3/14/2018 4:20:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search].[Provider](
	[ProviderID] [int] IDENTITY(1,1) NOT NULL,
	[DiamProvID] [varchar](12) NOT NULL,
	[FirstName] [varchar](100) NULL,
	[LastName] [varchar](60) NULL,
	[Gender] [varchar](6) NULL,
	[OrganizationName] [varchar](200) NULL,
	[License] [varchar](50) NULL,
	[NPI] [varchar](10) NULL,
	[ProviderType] [varchar](12) NULL,
	[NetDevProvID] [varchar](12) NULL,
	[IsInternalOnly] [bit] NULL,
	[IsEnabled] [bit] NOT NULL,
	[MembershipStatus] [varchar](75) NULL,
	[PreferredFirstName] [varchar](100) NULL,
 CONSTRAINT [PK_Provider] PRIMARY KEY CLUSTERED 
(
	[ProviderID] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Search].[Specialty]    Script Date: 3/14/2018 4:20:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search].[Specialty](
	[SpecialtyID] [int] IDENTITY(1,1) NOT NULL,
	[SpecialtyCode] [varchar](50) NULL,
	[SpecialtyDesc] [varchar](100) NULL,
	[ServiceIdentifier] [bit] NULL,
	[Category] [varchar](82) NULL,
	[SpanishTranslation] [varchar](100) NULL,
	[NddbSpecialtyId] [int] NULL,
 CONSTRAINT [PK_Specialty] PRIMARY KEY CLUSTERED 
(
	[SpecialtyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [changed].[DataLogRecord]    Script Date: 3/14/2018 4:20:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [changed].[DataLogRecord](
	[DataLogRecordId] [int] IDENTITY(1,1) NOT NULL,
	[TableName] [varchar](100) NULL,
	[TablePKFieldName] [varchar](50) NULL,
	[TablePKFieldValue] [varchar](50) NULL,
	[OldXmlObject] [xml] NOT NULL,
	[NewXmlObject] [xml] NOT NULL,
	[ModifiedBy] [varchar](100) NULL,
	[ChangedDataSource] [varchar](500) NULL,
	[CreationTimestamp] [datetime] NULL,
	[CrossReferenceSystemName] [varchar](100) NULL,
	[CrossReferenceSystemValue] [varchar](50) NULL,
	[AutoUpdateCompletedTimestamp] [datetime] NULL,
	[AutoUpdateStatus] [varchar](50) NULL,
	[ManualUpdateCompletedTimestamp] [datetime] NULL,
	[ManualUpdateCrossReferenceId] [varchar](50) NULL,
	[ManualUpdateCrossReferenceStatus] [varchar](50) NULL,
	[SupportedDocumentId] [int] NULL,
	[SupportedDocumentSystemName] [varchar](100) NULL,
	[ChangeStatus] [varchar](20) NULL,
	[UserComment] [varchar](500) NULL,
 CONSTRAINT [PK_DataLogRecord] PRIMARY KEY CLUSTERED 
(
	[DataLogRecordId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [changed].[DataLog]    Script Date: 3/14/2018 4:20:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [changed].[DataLog](
	[DataLogId] [int] IDENTITY(1,1) NOT NULL,
	[DataLogRecordId] [int] NOT NULL,
	[TableName] [varchar](100) NULL,
	[TablePKFiedName] [varchar](100) NULL,
	[TablePKFieldValue] [varchar](50) NULL,
	[ChangedFieldName] [varchar](100) NULL,
	[ChangedOldValue] [varchar](500) NULL,
	[ChangedNewValue] [varchar](500) NULL,
	[ModifiedBy] [varchar](100) NULL,
	[LogType] [varchar](100) NULL,
	[ChangedDataSource] [varchar](500) NULL,
	[CreationTimestamp] [datetime] NULL,
 CONSTRAINT [PK_DataLog] PRIMARY KEY CLUSTERED 
(
	[DataLogId] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [changed].[DirectoryUpdateReport]    Script Date: 3/14/2018 4:20:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [changed].[DirectoryUpdateReport]
AS
SELECT DISTINCT 
                         TOP (100) PERCENT dlr.DataLogRecordId, dl.DataLogId, dlr.CrossReferenceSystemValue AS WorkFrontNumber, dl.LogType, 
                         CASE WHEN dl.TableName LIKE '%search.Provider%' AND dl.TablePKFiedName = 'ProviderId' THEN p.NetDevProvID END AS PPI_ID, 
                         CASE WHEN dl.TableName LIKE '%search.Provider%' AND dl.TablePKFiedName = 'ProviderId' THEN p.DiamProvID END AS DiamondID, 
                         CASE WHEN dl.TableName LIKE '%search.address%' AND dl.TablePKFiedName = 'AddressID' THEN A.LocationID END AS LocationID, 
                         CASE WHEN dl.TableName LIKE '%search.Provider%' AND dl.ChangedFieldName NOT IN ('Eprescribe', 'Software') 
                         THEN 'tbl_Provider_ProviderInfo' WHEN dl.TableName LIKE '%search.Provider%' AND dl.ChangedFieldName IN ('Eprescribe', 'Software') 
                         THEN 'tbl_Provider_DrugRegistrationInfo' WHEN dl.TableName LIKE '%search.Address%' AND dl.ChangedFieldName IN ('phone', 'Fax') 
                         THEN 'tbl_contract_CPl' WHEN dl.TableName LIKE '%search.Address%' AND dl.ChangedFieldName IN ('phone', 'Fax') 
                         THEN 'tbl_contract_LocationsNumbers' WHEN dl.TableName LIKE '%search.Address%' AND dl.ChangedFieldName NOT IN ('phone', 'Fax') 
                         THEN 'tbl_contract_Locations' END AS Network_dev_UpdateTable, CASE WHEN dl.ChangedFieldName LIKE '%Language%' AND 
                         dl.TableName LIKE '%Search.provider%' THEN 'PPI_Language' WHEN dl.ChangedFieldName = 'Clinical Staff Language' THEN 'Cl_Clinicallanguage' WHEN dl.ChangedFieldName
                          LIKE 'Non-Clinical Staff Language' THEN 'Cl_Stafflanguage' WHEN dl.ChangedFieldName = 'street' THEN 'CL_Address' WHEN dl.ChangedFieldName = 'City' THEN 'CL_City'
                          WHEN dl.ChangedFieldName = 'Zip' THEN 'CL_Zip' WHEN dl.ChangedFieldName = 'Walkin' THEN 'CL_Walkin' WHEN dl.ChangedFieldName = 'State' THEN 'CL_State'
                          WHEN dl.ChangedFieldName = 'Address' THEN 'CL_Address' WHEN dl.ChangedFieldName = 'Email' AND 
                         dl.TableName LIKE '%Search.address%' THEN 'CL_Email' WHEN dl.ChangedFieldName = 'FederallyQualifiedHc' THEN 'CL_Safetynet' WHEN dl.ChangedFieldName =
                          'ReferralFax' THEN 'Cl_ReferralFax' WHEN dl.ChangedFieldName = 'Hours' THEN 'CL_OfficeHours' WHEN dl.ChangedFieldName IN ('IsEmr', 'EMR') 
                         THEN 'CL_EMR' WHEN dl.ChangedFieldName = 'EmrSystem' THEN 'CL_EMRSystem' WHEN dl.ChangedFieldName = 'LocationName' THEN 'CL_MedicalGroup' WHEN
                          dl.ChangedFieldName = 'OfficeManager' THEN 'CL_OfficeManager' WHEN dl.ChangedFieldName = 'Gender' THEN 'PPI_Gender' WHEN dl.ChangedFieldName = 'FirstName'
                          THEN 'PPI_FirstName' WHEN dl.ChangedFieldName = 'Lastname' THEN 'PPI_LastName' WHEN dl.ChangedFieldName = 'organizationName' THEN 'PPI_lastName' WHEN
                          dl.ChangedFieldName = 'mediCareId' THEN 'PPI_MedicareID' WHEN dl.ChangedFieldName = 'license' THEN 'PPI_License' WHEN dl.ChangedFieldName = 'MediCalId'
                          THEN 'PPI_MediCalId' WHEN dl.ChangedFieldName = 'nationalProviderId' THEN 'PPI_UPIN' WHEN dl.ChangedFieldName = 'Ethnicity' THEN 'PPI_Ethnicity' WHEN dl.ChangedFieldName
                          = 'IsCcs' THEN 'PPI_CCS' WHEN dl.ChangedFieldName = 'IsEprescribe' THEN 'PDRI_Eprescribe' WHEN dl.ChangedFieldName = 'Software' THEN 'PDRI_Software' WHEN
                          dl.ChangedFieldName = 'ProviderEmail' THEN 'PPI_Email' WHEN dl.ChangedFieldName = 'specialityDesc' THEN 'PPI_Specialty' ELSE dl.ChangedFieldName END AS
                          Network_Dev_ChangedFieldName, CASE WHEN dl.ChangedFieldName = 'LanguageDesc' THEN CAST(L.LXCode AS VARCHAR(255)) 
                         WHEN dl.ChangedFieldName LIKE 'Clinical Staff Language' THEN CAST(CL.CL_ClinicalLanguage AS VARCHAR(255)) 
                         WHEN dl.ChangedFieldName LIKE 'Non-Clinical Staff Language' THEN CAST(CL.CL_StaffLanguage AS VARCHAR(255)) 
                         WHEN dl.ChangedFieldName LIKE 'street' THEN CAST(CL.CL_Address AS VARCHAR(255)) 
                         WHEN dl.ChangedFieldName LIKE 'City' THEN CAST(CL.CL_City AS VARCHAR(255)) WHEN dl.ChangedFieldName LIKE 'Zip' THEN CAST(CL.CL_Zip AS VARCHAR(255))
                          WHEN dl.ChangedFieldName LIKE 'Walkin' THEN CAST(CL.CL_WalkIn AS VARCHAR(255)) 
                         WHEN dl.ChangedFieldName LIKE 'State' THEN CAST(CL.CL_State AS VARCHAR(255)) WHEN dl.ChangedFieldName = 'Email' AND 
                         dl.TableName LIKE '%Search.address%' THEN CAST(CL.CL_Email AS VARCHAR(100)) 
                         WHEN dl.ChangedFieldName LIKE 'FederallyQualifiedHc' THEN CAST(CL.CL_SafetyNet AS VARCHAR(255)) 
                         WHEN dl.ChangedFieldName LIKE 'ReferralFax' THEN CAST(CL.CL_ReferralFax AS VARCHAR(255)) 
                         WHEN dl.ChangedFieldName LIKE 'Hours' THEN CAST(CL.CL_OfficeHours AS VARCHAR(255)) WHEN dl.ChangedFieldName IN ('IsEmr', 'EMR') 
                         THEN CAST(CL.CL_EMR AS VARCHAR(255)) WHEN dl.ChangedFieldName LIKE 'EmrSystem' THEN CAST(CL.CL_EMRSystem AS VARCHAR(255)) 
                         WHEN dl.ChangedFieldName LIKE 'LocationName' THEN CAST(CL.CL_MedicalGroup AS VARCHAR(255)) 
                         WHEN dl.ChangedFieldName LIKE 'OfficeManager' THEN CAST(CL.CL_OfficeManager AS VARCHAR(255)) 
                         WHEN dl.ChangedFieldName LIKE 'Gender' THEN CAST(PPI.PPI_Gender AS VARCHAR(255)) 
                         WHEN dl.ChangedFieldName LIKE 'FirstName' THEN CAST(PPI.PPI_FirstName AS VARCHAR(255)) 
                         WHEN dl.ChangedFieldName LIKE 'Lastname' THEN CAST(PPI.PPI_LastName AS VARCHAR(255)) 
                         WHEN dl.ChangedFieldName = 'organizationName' THEN CAST(PPI.PPI_LastName AS VARCHAR(255)) 
                         WHEN dl.ChangedFieldName = 'mediCareId' THEN CAST(PPI_MedicareID AS VARCHAR(255)) 
                         WHEN dl.ChangedFieldName = 'license' THEN CAST(PPI_License AS VARCHAR(255)) 
                         WHEN dl.ChangedFieldName = 'MediCalId' THEN CAST(PPI_MediCalID AS VARCHAR(255)) 
                         WHEN dl.ChangedFieldName = 'nationalProviderId' THEN CAST(PPI_UPIN AS VARCHAR(255)) 
                         WHEN dl.ChangedFieldName = 'Ethnicity' THEN CAST(PPI_Ethnicity AS VARCHAR(255)) 
                         WHEN dl.ChangedFieldName = 'IsCcs' THEN CAST(PPI_CCS AS VARCHAR(255)) 
                         WHEN dl.ChangedFieldName = 'IsEprescribe' THEN CAST(PDRI_Eprescribe AS VARCHAR(255)) 
                         WHEN dl.ChangedFieldName = 'Software' THEN CAST(PDRI_Software AS VARCHAR(255)) 
                         WHEN dl.ChangedFieldName = 'ProviderEmail' THEN CAST(PPI_Email AS VARCHAR(255)) 
                         WHEN dl.ChangedFieldName = 'specialityDesc' THEN CAST(PSP.PSP_ID AS VARCHAR(255)) ELSE CAST(dl.ChangedOldValue AS VARCHAR(500)) 
                         END AS NetWorkDev_value_BeforeUpdate, dl.ChangedOldValue AS DataLogOldValue, 
                         CASE WHEN dl.ChangedFieldName = 'LanguageDesc' THEN L1.LXCode WHEN dl.ChangedFieldName = 'specialityDesc' THEN CAST(PSP1.PSP_ID AS VARCHAR(4)) 
                         WHEN dl.ChangedFieldName = 'Clinical Staff Language' AND LV1.DBLV_Value = dl.ChangedNewValue THEN CAST(LV1.DBLV_ID AS VARCHAR(3)) 
                         WHEN dl.ChangedFieldName LIKE 'Non-Clinical Staff Language' AND LV.DBLV_Value = dl.ChangedNewValue THEN CAST(LV.DBLV_ID AS VARCHAR(3)) 
                         WHEN dl.ChangedFieldName = 'Ethnicity' AND LV3.DBLV_Value = dl.ChangedNewValue THEN CAST(LV3.DBLV_Abbreviation AS VARCHAR(3)) 
                         WHEN dl.ChangedFieldName = 'EmrSystem' AND LV4.DBLV_Value = dl.ChangedNewValue THEN CAST(LV4.DBLV_ID AS VARCHAR(3)) 
                         WHEN Dl.ChangedFieldName = 'Gender' AND PG.PPG_Gender = dl.ChangedNewValue THEN CAST(PG.PPG_ID AS VARCHAR(2)) 
                         WHEN Dl.ChangedFieldName IN ('IsEmr', 'EMR') AND dl.ChangedNewValue = 'True' THEN '-1' WHEN Dl.ChangedFieldName IN ('IsEmr', 'EMR') AND 
                         dl.ChangedNewValue = 'False' THEN '0' ELSE CAST(dl.ChangedNewValue AS VARCHAR(500)) END AS NetWorkDev_value_AfterUpdate, 
                         dl.ChangedNewValue AS DataLogNewValue, dlr.CreationTimestamp AS DataLogRecordCreationTime, dlr.ChangeStatus
FROM            search.Provider AS p WITH (NOLOCK) LEFT OUTER JOIN
                         search.Address AS A WITH (NOLOCK) ON A.ProviderID = p.ProviderID LEFT OUTER JOIN
                         changed.DataLogRecord AS dlr WITH (NOLOCK) ON dlr.TablePKFieldValue = p.ProviderID AND dlr.TableName LIKE '%Provider%' OR 
                         dlr.TablePKFieldValue = A.AddressID AND dlr.TableName LIKE '%address%' LEFT OUTER JOIN
                         changed.DataLog AS dl WITH (NOLOCK) ON dlr.DataLogRecordId = dl.DataLogRecordId LEFT OUTER JOIN
                         Network_Development.dbo.Tbl_Provider_ProviderInfo AS PPI WITH (NOLOCK) ON PPI.PPI_ID = p.NetDevProvID LEFT OUTER JOIN
                         Network_Development.dbo.Tbl_Contract_Locations AS CL WITH (NOLOCK) ON CL.CL_ID = A.LocationID LEFT OUTER JOIN
                         Network_Development.dbo.Tbl_Provider_DrugRegistrationInfo AS PDRI WITH (NOLOCK) ON PDRI.PDRI_ProviderID = p.NetDevProvID LEFT OUTER JOIN
                         search.Languages AS PL WITH (NOLOCK) ON PL.Description = dl.ChangedOldValue AND dl.ChangedFieldName = 'LanguageDesc' LEFT OUTER JOIN
                         search.Languages AS PL1 WITH (NOLOCK) ON PL1.Description = dl.ChangedNewValue AND dl.ChangedFieldName = 'LanguageDesc' LEFT OUTER JOIN
                         Network_Development.dbo.Tbl_Codes_Languages AS L WITH (NOLOCK) ON L.LXISOCODE = PL.ISOCode LEFT OUTER JOIN
                         Network_Development.dbo.Tbl_Codes_Languages AS L1 WITH (NOLOCK) ON L1.LXISOCODE = PL1.ISOCode LEFT OUTER JOIN
                         search.Specialty AS S WITH (NOLOCK) ON S.SpecialtyDesc = dl.ChangedOldValue LEFT OUTER JOIN
                         search.Specialty AS S1 WITH (NOLOCK) ON S1.SpecialtyDesc = dl.ChangedNewValue LEFT OUTER JOIN
                         Network_Development.dbo.Tbl_Provider_ProviderSpecialties AS PSP WITH (NOLOCK) ON PSP.PSP_ProviderDirectory = S.SpecialtyDesc LEFT OUTER JOIN
                         Network_Development.dbo.Tbl_Provider_ProviderSpecialties AS PSP1 WITH (NOLOCK) ON PSP1.PSP_ProviderDirectory = S1.SpecialtyDesc LEFT OUTER JOIN
                         Network_Development.dbo.Tbl_Database_ListValues AS LV WITH (NOLOCK) ON LV.DBLV_List = 95 AND LV.DBLV_Value = dl.ChangedNewValue AND 
                         dl.ChangedFieldName LIKE 'Non-Clinical Staff Language' LEFT OUTER JOIN
                         Network_Development.dbo.Tbl_Database_ListValues AS LV1 WITH (NOLOCK) ON LV1.DBLV_List = 95 AND LV1.DBLV_Value = dl.ChangedNewValue AND 
                         dl.ChangedFieldName = 'Clinical Staff Language' LEFT OUTER JOIN
                         Network_Development.dbo.Tbl_Database_ListValues AS LV3 WITH (NOLOCK) ON LV3.DBLV_List = 73 AND LV3.DBLV_Value = dl.ChangedNewValue AND 
                         dl.ChangedFieldName = 'Ethnicity' LEFT OUTER JOIN
                         Network_Development.dbo.Tbl_Database_ListValues AS LV4 WITH (NOLOCK) ON LV4.DBLV_List = 71 AND LV4.DBLV_Value = dl.ChangedNewValue AND 
                         dl.ChangedFieldName = 'EmrSystem' LEFT OUTER JOIN
                         Network_Development.dbo.Tbl_Provider_ProviderGender AS PG WITH (NOLOCK) ON PG.PPG_Gender = dl.ChangedNewValue AND 
                         dl.ChangedFieldName = 'Gender'
WHERE        (dl.DataLogRecordId IS NOT NULL)
GO
/****** Object:  Table [changed].[DataLogColumnConditionSetting]    Script Date: 3/14/2018 4:20:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [changed].[DataLogColumnConditionSetting](
	[DataLogColumnConditionSettingId] [int] IDENTITY(1,1) NOT NULL,
	[DataLogTableSettingId] [int] NULL,
	[FieldName] [varchar](50) NULL,
	[MatchedValue] [varchar](50) NULL,
	[IsActive] [bit] NULL,
	[CreationTimestamp] [datetime] NULL,
 CONSTRAINT [PK_DataLogColumnConditionSetting] PRIMARY KEY CLUSTERED 
(
	[DataLogColumnConditionSettingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [changed].[DataLogColumnSetting]    Script Date: 3/14/2018 4:20:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [changed].[DataLogColumnSetting](
	[DataLogColumnSettingId] [int] IDENTITY(1,1) NOT NULL,
	[DataLogTableSettingId] [int] NULL,
	[FieldName] [varchar](50) NULL,
	[IsManualUpdate] [bit] NULL,
	[IsActive] [bit] NULL,
	[CreationTimestamp] [datetime] NULL,
	[DatabaseFieldName] [varchar](50) NULL,
 CONSTRAINT [PK_DataLogColumnSetting] PRIMARY KEY CLUSTERED 
(
	[DataLogColumnSettingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [changed].[DataLogObject]    Script Date: 3/14/2018 4:20:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [changed].[DataLogObject](
	[DataLogObjectId] [int] IDENTITY(1,1) NOT NULL,
	[DataLogRecordId] [int] NULL,
	[TableName] [varchar](100) NULL,
	[TablePKFieldName] [varchar](100) NULL,
	[TablePKFieldValue] [varchar](50) NULL,
	[DataObject] [xml] NULL,
	[LogType] [varchar](100) NULL,
	[ChangedDataSource] [varchar](500) NULL,
	[ModifiedBy] [varchar](100) NULL,
	[CreationTimestamp] [datetime] NULL,
 CONSTRAINT [PK_DataLogObject] PRIMARY KEY CLUSTERED 
(
	[DataLogObjectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [changed].[DataLogTableSetting]    Script Date: 3/14/2018 4:20:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [changed].[DataLogTableSetting](
	[DataLogTableSettingId] [int] NOT NULL,
	[TableName] [varchar](100) NULL,
	[TablePkFieldName] [varchar](100) NULL,
	[IsActive] [bit] NULL,
	[CreationTimestamp] [datetime] NULL,
 CONSTRAINT [PK_DataLogTableSetting] PRIMARY KEY CLUSTERED 
(
	[DataLogTableSettingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [changed].[DataLogUser]    Script Date: 3/14/2018 4:20:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [changed].[DataLogUser](
	[DataLogUserId] [int] IDENTITY(1,1) NOT NULL,
	[DataLogRecordId] [int] NULL,
	[UserName] [varchar](100) NULL,
	[EmailAddress] [varchar](100) NULL,
	[IpAddress] [varchar](50) NULL,
	[ChangedDataSource] [nchar](500) NULL,
	[DataObject] [xml] NULL,
	[CreationTimestamp] [datetime] NULL,
 CONSTRAINT [PK_DataLogUser] PRIMARY KEY CLUSTERED 
(
	[DataLogUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [changed].[DirectoryUpdateLog]    Script Date: 3/14/2018 4:20:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [changed].[DirectoryUpdateLog](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[DataLogRecordID] [int] NULL,
	[UpdatedTable] [varchar](100) NULL,
	[UpdatedField] [varchar](50) NULL,
	[UpdatedTime] [datetime] NULL,
	[Status] [varchar](20) NULL,
	[SystemError] [nvarchar](4000) NULL,
	[ErrorLine] [int] NULL,
	[ManualError] [varchar](50) NULL,
 CONSTRAINT [PK__DirectoryUpdateLog__LogID] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [GeoCode].[Addresses]    Script Date: 3/14/2018 4:20:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GeoCode].[Addresses](
	[AddressID] [int] IDENTITY(1,1) NOT NULL,
	[Address] [varchar](61) NOT NULL,
	[Address2] [varchar](61) NULL,
	[City] [varchar](30) NULL,
	[County] [varchar](30) NULL,
	[State] [varchar](15) NULL,
	[Zipcode] [varchar](15) NULL,
	[RowHash] [varbinary](16) NULL,
	[GeoAddressID] [int] NULL,
	[IsAddressNew] [bit] NULL,
	[GeocodeInput] [int] NULL,
	[GeocodeResult] [xml] NULL,
	[IsResultSame] [bit] NULL,
 CONSTRAINT [PK__Addresses] PRIMARY KEY CLUSTERED 
(
	[AddressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [GeoCode].[GeocodeCountAudit]    Script Date: 3/14/2018 4:20:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GeoCode].[GeocodeCountAudit](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GeocodeDateTime] [datetime] NULL,
	[GeocodedRecordsCount] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [GeoCode].[GeocodedAddresses]    Script Date: 3/14/2018 4:20:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GeoCode].[GeocodedAddresses](
	[GeoAddressID] [int] IDENTITY(1,1) NOT NULL,
	[GeoAddress] [varchar](max) NULL,
	[GeoCity] [varchar](30) NULL,
	[GeoCounty] [varchar](30) NULL,
	[GeoState] [varchar](15) NULL,
	[GeoZipcode] [varchar](9) NULL,
	[Latitude] [float] NULL,
	[Longitude] [float] NULL,
	[Accuracy] [int] NULL,
	[GeocodedDateTime] [datetime] NULL,
 CONSTRAINT [PK_GeocodedAddresses] PRIMARY KEY CLUSTERED 
(
	[GeoAddressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [GeoCode].[Providers]    Script Date: 3/14/2018 4:20:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GeoCode].[Providers](
	[AddressID] [int] NOT NULL,
	[ProviderId] [varchar](12) NULL,
	[ProviderType] [varchar](12) NULL,
	[SeqNo] [varchar](5) NOT NULL,
	[Active] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Search].[AcceptingNewMemberCodes]    Script Date: 3/14/2018 4:20:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search].[AcceptingNewMemberCodes](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[StatusCode] [varchar](3) NOT NULL,
	[CodeLabel] [varchar](25) NOT NULL,
	[CodeDescription] [varchar](255) NULL,
	[Comment] [varchar](255) NULL,
 CONSTRAINT [PK__Acceptin__3214EC273004F00B] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Search].[AddressExtendedProperties]    Script Date: 3/14/2018 4:20:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search].[AddressExtendedProperties](
	[AddressID] [int] NOT NULL,
	[PropertyName] [varchar](30) NOT NULL,
	[PropertyValue] [varchar](50) NULL,
 CONSTRAINT [PK_AddressExtendedProperties] PRIMARY KEY CLUSTERED 
(
	[AddressID] ASC,
	[PropertyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Search].[AddressLanguage]    Script Date: 3/14/2018 4:20:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search].[AddressLanguage](
	[LanguageID] [int] NOT NULL,
	[AddressID] [int] NOT NULL,
	[Type] [varchar](30) NULL,
	[IsEnabled] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Search].[Affiliation]    Script Date: 3/14/2018 4:20:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search].[Affiliation](
	[AffiliationID] [int] IDENTITY(1,1) NOT NULL,
	[ProviderID] [int] NOT NULL,
	[DirectoryID] [varchar](20) NULL,
	[LOB] [varchar](50) NULL,
	[Panel] [varchar](15) NULL,
	[IPAName] [varchar](50) NULL,
	[IPAGroup] [varchar](30) NULL,
	[IPACode] [varchar](3) NULL,
	[IPAParentCode] [varchar](3) NULL,
	[IPADesc] [varchar](50) NULL,
	[HospitalName] [varchar](100) NULL,
	[ProviderType] [varchar](15) NULL,
	[AffiliationType] [varchar](50) NULL,
	[AgeLimit] [varchar](30) NULL,
	[AcceptingNewMbr] [bit] NULL,
	[EffectiveDate] [date] NULL,
	[TerminationDate] [date] NULL,
	[HospitalID] [varchar](12) NULL,
	[IsHospitalAdmitter] [bit] NULL,
	[AcceptingNewMemberCode] [varchar](3) NULL,
	[AddressID] [int] NULL,
	[IsInternalOnly] [bit] NULL,
	[IsEnabled] [bit] NOT NULL,
 CONSTRAINT [PK_Affilation] PRIMARY KEY CLUSTERED 
(
	[AffiliationID] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Search].[AffiliationExtendedProperties]    Script Date: 3/14/2018 4:20:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search].[AffiliationExtendedProperties](
	[AffilationID] [int] NOT NULL,
	[PropertyName] [varchar](30) NOT NULL,
	[PropertyValue] [varchar](50) NULL,
	[IsEnabled] [bit] NOT NULL,
 CONSTRAINT [PK_AffiliationExtendedProperties] PRIMARY KEY CLUSTERED 
(
	[AffilationID] ASC,
	[PropertyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Search].[AgeLimits]    Script Date: 3/14/2018 4:20:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search].[AgeLimits](
	[AgeLimitID] [int] IDENTITY(1,1) NOT NULL,
	[AgeLimit] [varchar](11) NULL,
	[AgeLimitDescription] [varchar](50) NULL,
	[AgeLimitSortOrder] [int] NULL,
	[LimitCategory] [tinyint] NULL,
	[AgeLimitMin] [numeric](4, 2) NULL,
	[AgeLimitMax] [numeric](5, 2) NULL,
 CONSTRAINT [PK_Tbl_Provider_AgeLimits] PRIMARY KEY CLUSTERED 
(
	[AgeLimitID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Search].[BusInfo]    Script Date: 3/14/2018 4:20:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search].[BusInfo](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CompanyStopID] [int] NOT NULL,
	[BusAgency] [varchar](255) NULL,
	[RouteShortName] [varchar](255) NULL,
	[RouteLongName] [varchar](600) NULL,
	[StopId] [int] NULL,
	[StopName] [varchar](255) NULL,
	[StopArea] [varchar](255) NULL,
	[Direction] [varchar](255) NULL,
 CONSTRAINT [PK__BusInfo__3214EC2776619304] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Search].[DataIntegrationAudit]    Script Date: 3/14/2018 4:20:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search].[DataIntegrationAudit](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
 CONSTRAINT [PK_DataIntegrationAudit] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Search].[ExcludedAddresses]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search].[ExcludedAddresses](
	[AddressID] [int] NOT NULL,
	[ExcludedBy] [varchar](5) NULL,
	[ExlusionReason] [varchar](200) NULL,
	[ExcludedFromDate] [date] NULL,
	[ExcludedToDate] [date] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Search].[ExcludedAffiliations]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search].[ExcludedAffiliations](
	[AffiliationID] [int] NOT NULL,
	[ExcludedBy] [varchar](5) NULL,
	[ExlusionReason] [varchar](200) NULL,
	[ExcludedFromDate] [date] NULL,
	[ExcludedToDate] [date] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Search].[ExcludedProviders]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search].[ExcludedProviders](
	[ProviderId] [int] NOT NULL,
	[ExcludedBy] [varchar](5) NULL,
	[ExlusionReason] [varchar](200) NULL,
	[ExcludedFromDate] [date] NULL,
	[ExcludedToDate] [date] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Search].[ProviderAffiliationAddress]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search].[ProviderAffiliationAddress](
	[AddressID] [int] NOT NULL,
	[ProviderID] [int] NULL,
	[AffiliationID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Search].[ProviderExtendedProperties]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search].[ProviderExtendedProperties](
	[ProviderID] [int] NOT NULL,
	[PropertyName] [varchar](30) NOT NULL,
	[PropertyValue] [varchar](255) NULL,
	[IsEnabled] [bit] NULL,
 CONSTRAINT [PK_ProviderExtendedProperties] PRIMARY KEY CLUSTERED 
(
	[ProviderID] ASC,
	[PropertyName] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Search].[ProviderLanguage]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search].[ProviderLanguage](
	[LanguageID] [int] NULL,
	[ProviderID] [int] NULL,
	[IsEnabled] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Search].[ProviderSpecialty]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search].[ProviderSpecialty](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SpecialtyID] [int] NOT NULL,
	[ProviderID] [int] NOT NULL,
	[AffiliationID] [int] NULL,
	[BoardCertified] [bit] NOT NULL,
	[IsEnabled] [bit] NULL,
 CONSTRAINT [PK_ProviderSpecialty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Search].[ProviderTypeCount]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search].[ProviderTypeCount](
	[RowId] [int] NOT NULL,
	[ProviderType] [varchar](30) NOT NULL,
	[Total] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IDX_TableName]    Script Date: 3/14/2018 4:20:43 PM ******/
CREATE NONCLUSTERED INDEX [IDX_TableName] ON [changed].[DataLogRecord]
(
	[TableName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [NCLIXRowHash]    Script Date: 3/14/2018 4:20:43 PM ******/
CREATE NONCLUSTERED INDEX [NCLIXRowHash] ON [GeoCode].[Addresses]
(
	[RowHash] ASC
)
INCLUDE ( 	[AddressID]) WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [NCLIXProviderInfo]    Script Date: 3/14/2018 4:20:43 PM ******/
CREATE NONCLUSTERED INDEX [NCLIXProviderInfo] ON [GeoCode].[Providers]
(
	[ProviderId] ASC,
	[ProviderType] ASC,
	[SeqNo] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95) ON [PRIMARY]
GO
/****** Object:  Index [IDX_ProviderID]    Script Date: 3/14/2018 4:20:43 PM ******/
CREATE NONCLUSTERED INDEX [IDX_ProviderID] ON [Search].[Address]
(
	[ProviderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IDX_ProviderId_SearchFields]    Script Date: 3/14/2018 4:20:43 PM ******/
CREATE NONCLUSTERED INDEX [IDX_ProviderId_SearchFields] ON [Search].[Affiliation]
(
	[ProviderID] ASC
)
INCLUDE ( 	[DirectoryID],
	[HospitalName],
	[IPACode],
	[IPAParentCode],
	[LOB],
	[Panel]) WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95) ON [PRIMARY]
GO
/****** Object:  Index [IDX_ProviderIdSpecialtyId]    Script Date: 3/14/2018 4:20:43 PM ******/
CREATE NONCLUSTERED INDEX [IDX_ProviderIdSpecialtyId] ON [Search].[ProviderSpecialty]
(
	[ProviderID] ASC
)
INCLUDE ( 	[SpecialtyID]) WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95) ON [PRIMARY]
GO
ALTER TABLE [changed].[DataLogColumnConditionSetting] ADD  CONSTRAINT [DF_DataLogColumnConditionSetting_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [changed].[DataLogColumnConditionSetting] ADD  CONSTRAINT [DF_DataLogColumnConditionSetting_CreationTimestamp]  DEFAULT (getdate()) FOR [CreationTimestamp]
GO
ALTER TABLE [changed].[DataLogColumnSetting] ADD  CONSTRAINT [DF_DataLogColumnSetting_IsManualUpdate]  DEFAULT ((1)) FOR [IsManualUpdate]
GO
ALTER TABLE [changed].[DataLogColumnSetting] ADD  CONSTRAINT [DF_DataLogColumnSetting_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [changed].[DataLogColumnSetting] ADD  CONSTRAINT [DF_DataLogColumnSetting_CreationTimestamp]  DEFAULT (getdate()) FOR [CreationTimestamp]
GO
ALTER TABLE [changed].[DataLogObject] ADD  CONSTRAINT [DF_DataLogObject_CreationTimestamp]  DEFAULT (getdate()) FOR [CreationTimestamp]
GO
ALTER TABLE [changed].[DataLogTableSetting] ADD  CONSTRAINT [DF_DataLogTableSetting_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [changed].[DataLogTableSetting] ADD  CONSTRAINT [DF_DataLogTableSetting_CreationTimestamp]  DEFAULT (getdate()) FOR [CreationTimestamp]
GO
ALTER TABLE [changed].[DataLogUser] ADD  CONSTRAINT [DF_DataLogUser_CreationTimestamp]  DEFAULT (getdate()) FOR [CreationTimestamp]
GO
ALTER TABLE [GeoCode].[Providers] ADD  CONSTRAINT [DF__Providers__Activ__4A6E022D]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [Search].[Address] ADD  DEFAULT ((0)) FOR [IsInternalOnly]
GO
ALTER TABLE [Search].[Address] ADD  CONSTRAINT [DF_Address_IsActive]  DEFAULT ((1)) FOR [IsEnabled]
GO
ALTER TABLE [Search].[AddressLanguage] ADD  CONSTRAINT [DF__AddressLa__IsEna__42E2BA55]  DEFAULT ((1)) FOR [IsEnabled]
GO
ALTER TABLE [Search].[Affiliation] ADD  DEFAULT ((0)) FOR [IsInternalOnly]
GO
ALTER TABLE [Search].[Affiliation] ADD  CONSTRAINT [DF_Affiliation_IsActive]  DEFAULT ((1)) FOR [IsEnabled]
GO
ALTER TABLE [Search].[AffiliationExtendedProperties] ADD  CONSTRAINT [DF__Affiliati__IsEna__0C50D423]  DEFAULT ((1)) FOR [IsEnabled]
GO
ALTER TABLE [Search].[AgeLimits] ADD  DEFAULT ((1)) FOR [LimitCategory]
GO
ALTER TABLE [Search].[Provider] ADD  DEFAULT ((0)) FOR [IsInternalOnly]
GO
ALTER TABLE [Search].[Provider] ADD  CONSTRAINT [DF_Provider_IsActive]  DEFAULT ((1)) FOR [IsEnabled]
GO
ALTER TABLE [Search].[ProviderExtendedProperties] ADD  CONSTRAINT [DF__ProviderE__IsEna__2FCFE5E1]  DEFAULT ((0)) FOR [IsEnabled]
GO
ALTER TABLE [Search].[ProviderLanguage] ADD  CONSTRAINT [DF__ProviderL__IsEna__30C40A1A]  DEFAULT ((0)) FOR [IsEnabled]
GO
ALTER TABLE [Search].[ProviderSpecialty] ADD  CONSTRAINT [DF__ProviderS__IsEna__2EDBC1A8]  DEFAULT ((1)) FOR [IsEnabled]
GO
ALTER TABLE [changed].[DataLog]  WITH CHECK ADD  CONSTRAINT [FK_DataLog_DataLogRecord] FOREIGN KEY([DataLogRecordId])
REFERENCES [changed].[DataLogRecord] ([DataLogRecordId])
GO
ALTER TABLE [changed].[DataLog] CHECK CONSTRAINT [FK_DataLog_DataLogRecord]
GO
ALTER TABLE [changed].[DataLogColumnConditionSetting]  WITH CHECK ADD  CONSTRAINT [FK_DataLogColumnConditionSetting_DataLogTableSetting] FOREIGN KEY([DataLogTableSettingId])
REFERENCES [changed].[DataLogTableSetting] ([DataLogTableSettingId])
GO
ALTER TABLE [changed].[DataLogColumnConditionSetting] CHECK CONSTRAINT [FK_DataLogColumnConditionSetting_DataLogTableSetting]
GO
ALTER TABLE [changed].[DataLogColumnSetting]  WITH CHECK ADD  CONSTRAINT [FK_DataLogColumnSetting_DataLogTableSetting] FOREIGN KEY([DataLogTableSettingId])
REFERENCES [changed].[DataLogTableSetting] ([DataLogTableSettingId])
GO
ALTER TABLE [changed].[DataLogColumnSetting] CHECK CONSTRAINT [FK_DataLogColumnSetting_DataLogTableSetting]
GO
ALTER TABLE [changed].[DataLogObject]  WITH CHECK ADD  CONSTRAINT [FK_DataLogObject_DataLogRecord] FOREIGN KEY([DataLogRecordId])
REFERENCES [changed].[DataLogRecord] ([DataLogRecordId])
GO
ALTER TABLE [changed].[DataLogObject] CHECK CONSTRAINT [FK_DataLogObject_DataLogRecord]
GO
ALTER TABLE [changed].[DataLogUser]  WITH CHECK ADD  CONSTRAINT [FK_DataLogUser_DataLogRecord] FOREIGN KEY([DataLogRecordId])
REFERENCES [changed].[DataLogRecord] ([DataLogRecordId])
GO
ALTER TABLE [changed].[DataLogUser] CHECK CONSTRAINT [FK_DataLogUser_DataLogRecord]
GO
ALTER TABLE [changed].[DirectoryUpdateLog]  WITH CHECK ADD  CONSTRAINT [FK__DirectoryUpdateLog__DataLogRecordId] FOREIGN KEY([DataLogRecordID])
REFERENCES [changed].[DataLogRecord] ([DataLogRecordId])
GO
ALTER TABLE [changed].[DirectoryUpdateLog] CHECK CONSTRAINT [FK__DirectoryUpdateLog__DataLogRecordId]
GO
ALTER TABLE [GeoCode].[Addresses]  WITH CHECK ADD  CONSTRAINT [FK__Addresses__GeoAd__3D14070F] FOREIGN KEY([GeoAddressID])
REFERENCES [GeoCode].[GeocodedAddresses] ([GeoAddressID])
GO
ALTER TABLE [GeoCode].[Addresses] CHECK CONSTRAINT [FK__Addresses__GeoAd__3D14070F]
GO
ALTER TABLE [GeoCode].[Providers]  WITH CHECK ADD  CONSTRAINT [FK__Providers__Addre__172E5549] FOREIGN KEY([AddressID])
REFERENCES [GeoCode].[Addresses] ([AddressID])
GO
ALTER TABLE [GeoCode].[Providers] CHECK CONSTRAINT [FK__Providers__Addre__172E5549]
GO
ALTER TABLE [Search].[Address]  WITH CHECK ADD  CONSTRAINT [FK_Search_Address_Provider] FOREIGN KEY([ProviderID])
REFERENCES [Search].[Provider] ([ProviderID])
GO
ALTER TABLE [Search].[Address] CHECK CONSTRAINT [FK_Search_Address_Provider]
GO
ALTER TABLE [Search].[AddressExtendedProperties]  WITH CHECK ADD  CONSTRAINT [FK_Search_AddressExtendedProperties_Address] FOREIGN KEY([AddressID])
REFERENCES [Search].[Address] ([AddressID])
GO
ALTER TABLE [Search].[AddressExtendedProperties] CHECK CONSTRAINT [FK_Search_AddressExtendedProperties_Address]
GO
ALTER TABLE [Search].[AddressLanguage]  WITH CHECK ADD  CONSTRAINT [FK_Search_AddressLanguage_Address] FOREIGN KEY([AddressID])
REFERENCES [Search].[Address] ([AddressID])
GO
ALTER TABLE [Search].[AddressLanguage] CHECK CONSTRAINT [FK_Search_AddressLanguage_Address]
GO
ALTER TABLE [Search].[AddressLanguage]  WITH CHECK ADD  CONSTRAINT [FK_Search_AddressLanguage_Languages] FOREIGN KEY([LanguageID])
REFERENCES [Search].[Languages] ([LanguageID])
GO
ALTER TABLE [Search].[AddressLanguage] CHECK CONSTRAINT [FK_Search_AddressLanguage_Languages]
GO
ALTER TABLE [Search].[Affiliation]  WITH CHECK ADD  CONSTRAINT [FK_Search_Affiliation_Provider] FOREIGN KEY([ProviderID])
REFERENCES [Search].[Provider] ([ProviderID])
GO
ALTER TABLE [Search].[Affiliation] CHECK CONSTRAINT [FK_Search_Affiliation_Provider]
GO
ALTER TABLE [Search].[AffiliationExtendedProperties]  WITH CHECK ADD  CONSTRAINT [FK_Search_AffiliationExtendedProperties_Affilation] FOREIGN KEY([AffilationID])
REFERENCES [Search].[Affiliation] ([AffiliationID])
GO
ALTER TABLE [Search].[AffiliationExtendedProperties] CHECK CONSTRAINT [FK_Search_AffiliationExtendedProperties_Affilation]
GO
ALTER TABLE [Search].[ExcludedAddresses]  WITH CHECK ADD FOREIGN KEY([AddressID])
REFERENCES [Search].[Address] ([AddressID])
GO
ALTER TABLE [Search].[ExcludedAffiliations]  WITH CHECK ADD FOREIGN KEY([AffiliationID])
REFERENCES [Search].[Affiliation] ([AffiliationID])
GO
ALTER TABLE [Search].[ExcludedProviders]  WITH CHECK ADD FOREIGN KEY([ProviderId])
REFERENCES [Search].[Provider] ([ProviderID])
GO
ALTER TABLE [Search].[ProviderAffiliationAddress]  WITH CHECK ADD  CONSTRAINT [FK_Search_ProviderAffilationAddress_Address] FOREIGN KEY([AddressID])
REFERENCES [Search].[Address] ([AddressID])
GO
ALTER TABLE [Search].[ProviderAffiliationAddress] CHECK CONSTRAINT [FK_Search_ProviderAffilationAddress_Address]
GO
ALTER TABLE [Search].[ProviderAffiliationAddress]  WITH CHECK ADD  CONSTRAINT [FK_Search_ProviderAffilationAddress_Affiliation] FOREIGN KEY([AffiliationID])
REFERENCES [Search].[Affiliation] ([AffiliationID])
GO
ALTER TABLE [Search].[ProviderAffiliationAddress] CHECK CONSTRAINT [FK_Search_ProviderAffilationAddress_Affiliation]
GO
ALTER TABLE [Search].[ProviderAffiliationAddress]  WITH CHECK ADD  CONSTRAINT [FK_Search_ProviderAffilationAddress_Provider] FOREIGN KEY([ProviderID])
REFERENCES [Search].[Provider] ([ProviderID])
GO
ALTER TABLE [Search].[ProviderAffiliationAddress] CHECK CONSTRAINT [FK_Search_ProviderAffilationAddress_Provider]
GO
ALTER TABLE [Search].[ProviderExtendedProperties]  WITH CHECK ADD  CONSTRAINT [FK_Search_ProviderExtendedProperties_Provider] FOREIGN KEY([ProviderID])
REFERENCES [Search].[Provider] ([ProviderID])
GO
ALTER TABLE [Search].[ProviderExtendedProperties] CHECK CONSTRAINT [FK_Search_ProviderExtendedProperties_Provider]
GO
ALTER TABLE [Search].[ProviderLanguage]  WITH CHECK ADD  CONSTRAINT [FK_Search_ProviderLanguage_Languages] FOREIGN KEY([LanguageID])
REFERENCES [Search].[Languages] ([LanguageID])
GO
ALTER TABLE [Search].[ProviderLanguage] CHECK CONSTRAINT [FK_Search_ProviderLanguage_Languages]
GO
ALTER TABLE [Search].[ProviderLanguage]  WITH CHECK ADD  CONSTRAINT [FK_Search_ProviderLanguage_Provider] FOREIGN KEY([ProviderID])
REFERENCES [Search].[Provider] ([ProviderID])
GO
ALTER TABLE [Search].[ProviderLanguage] CHECK CONSTRAINT [FK_Search_ProviderLanguage_Provider]
GO
ALTER TABLE [Search].[ProviderSpecialty]  WITH CHECK ADD  CONSTRAINT [FK_Search_ProviderSpecialty_Affiliation] FOREIGN KEY([AffiliationID])
REFERENCES [Search].[Affiliation] ([AffiliationID])
GO
ALTER TABLE [Search].[ProviderSpecialty] CHECK CONSTRAINT [FK_Search_ProviderSpecialty_Affiliation]
GO
ALTER TABLE [Search].[ProviderSpecialty]  WITH CHECK ADD  CONSTRAINT [FK_Search_ProviderSpecialty_Provider] FOREIGN KEY([ProviderID])
REFERENCES [Search].[Provider] ([ProviderID])
GO
ALTER TABLE [Search].[ProviderSpecialty] CHECK CONSTRAINT [FK_Search_ProviderSpecialty_Provider]
GO
ALTER TABLE [Search].[ProviderSpecialty]  WITH CHECK ADD  CONSTRAINT [FK_Search_ProviderSpecialty_Specialty] FOREIGN KEY([SpecialtyID])
REFERENCES [Search].[Specialty] ([SpecialtyID])
GO
ALTER TABLE [Search].[ProviderSpecialty] CHECK CONSTRAINT [FK_Search_ProviderSpecialty_Specialty]
GO
/****** Object:  StoredProcedure [changed].[DataLogRecordCrossReferenceUpdate]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [changed].[DataLogRecordCrossReferenceUpdate]
     @DataLogRecordId int	
	,@CrossReferenceSystemName varchar (100) = null
	,@CrossReferenceSystemValue varchar (50) = null	
	,@ChangeStatus varchar(20) = 'Pending'
	,@DocumentSystemName varchar (50) = null
	,@DocumentId int = 0
AS
BEGIN
	
	SET NOCOUNT ON
	
	-- Data Log Record Table
	UPDATE [changed].[DataLogRecord] 
		SET [CrossReferenceSystemName]=@CrossReferenceSystemName,[CrossReferenceSystemValue]=@CrossReferenceSystemValue		
			,[ChangeStatus]=@ChangeStatus,[SupportedDocumentSystemName]=@DocumentSystemName, [SupportedDocumentId]=@DocumentId
	WHERE DataLogRecordId = @DataLogRecordId

	-- Return affected Record count
    SELECT @@TRANCOUNT As affectedRecords

END





GO
/****** Object:  StoredProcedure [changed].[DataLogRecordSave]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [changed].[DataLogRecordSave]
     @UserName varchar (100)
	,@EmailAddress varchar (100)
	,@IpAddress varchar(50)
	,@UserDataObject Xml
	,@TableName varchar (100)
	,@TablePKFieldName varchar (50)
	,@TablePKFieldValue varchar (50)
	,@OldXmlObject Xml
	,@NewXmlObject Xml
	,@ModifiedBy varchar(100) = null
	,@ChangedDataSource varchar(500) = null	
	,@CrossReferenceSystemName varchar (100) = null
	,@CrossReferenceSystemValue varchar (50) = null
	,@CreationTimestamp datetime = now
	,@DataLogList [changed].[DataLogList] readonly
	,@DataLogObjectList [changed].[DataLogObjectList] readonly
	,@Comment varchar(500) = null
AS
BEGIN
	
	SET NOCOUNT ON
	DECLARE @DataLogRecordId int
	
	-- Data Log Record Table
	INSERT INTO [changed].[DataLogRecord] 
			( [TableName],[TablePKFieldName],[TablePKFieldValue],[OldXmlObject],[NewXmlObject],[ModifiedBy],[ChangedDataSource],[CrossReferenceSystemName],[CrossReferenceSystemValue],[CreationTimestamp],[UserComment])
	VALUES	( @TableName,@TablePKFieldName,@TablePKFieldValue,@OldXmlObject,@NewXmlObject,@ModifiedBy,@ChangedDataSource,@CrossReferenceSystemName,@CrossReferenceSystemValue,@CreationTimestamp,@Comment)

    SET  @DataLogRecordId = SCOPE_IDENTITY()
	
	-- Data Log User
	INSERT INTO [changed].[DataLogUser]	
			( [DataLogRecordId], [CreationTimestamp],[UserName],[EmailAddress], [IpAddress],[ChangedDataSource],[DataObject]  )
	VALUES (@DataLogRecordId,@CreationTimestamp,@UserName,@EmailAddress,@IpAddress,@ChangedDataSource,@UserDataObject )

	-- Data Log Table
	INSERT INTO [changed].[DataLog]
			( [DataLogRecordId],[ModifiedBy],[ChangedDataSource],[CreationTimestamp],[TableName],[TablePKFiedName],[TablePKFieldValue],[ChangedFieldName],[ChangedOldValue],[ChangedNewValue],[LogType])
	SELECT	@DataLogRecordId,@ModifiedBy,@ChangedDataSource,@CreationTimestamp
		   ,TableName,TablePKFiedName,TablePKFieldValue,ChangedFieldName,ChangedOldValue,ChangedNewValue,LogType 
	FROM @DataLogList

	-- Data Log Object Table
	INSERT INTO [changed].[DataLogObject]
			( [DataLogRecordId], [ModifiedBy],[ChangedDataSource],[CreationTimestamp],[TableName],[TablePKFieldName],[TablePKFieldValue], [DataObject],[LogType])
	SELECT	@DataLogRecordId,@ModifiedBy,@ChangedDataSource,@CreationTimestamp
		   ,TableName,TablePKFiedName,TablePKFieldValue,DataObject,LogType 
	FROM @DataLogObjectList

	-- Return Newly inserted Data Log Record Id
    SELECT @DataLogRecordId As DataLogRecordId

END




GO
/****** Object:  StoredProcedure [changed].[GetAddressByTaxID]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [changed].[GetAddressByTaxID]
    @TaxID VARCHAR(9) = NULL ,
    @AddressID INT = NULL ,
    @ExpirationMonths INT = 3
AS
    BEGIN 
        SET NOCOUNT ON; 

	  	  /*
			Modification Log:
				12/9/2016		SS		Added LocationID in result set.
				12/9/2016		SS		Added SupportedDocumentID in result set
				12/13/2016		SS		Added CrossReferenceSystemValue in Result Set
				12/13/2016		SS		Filtered providerTypes provided by QA (Bindu)
				12/13/2016		SS		Added filter to check TermDate of address/Contract
				12/15/2016		SS		Added GroupNPI in Result Set
				1/3/2017		SS		Added script to get locationID from given list only
		*/
/**************************************************************************************************/
	  /***	Declare Local Table Variables to hold data	***/

        DECLARE @now DATE = GETDATE();
        DECLARE @LocationTaxID TABLE
            (
              Locationid INT ,
              taxid VARCHAR(9)
            ); 

        DECLARE @LocationIDs TABLE ( LocationID INT ); 

		DECLARE @GiveLocationIds TABLE(LocationID int);


        IF OBJECT_ID('tempdb..#Address') IS NOT NULL
            DROP TABLE #Address;

        IF OBJECT_ID('tempdb..#tempAddressObject') IS NOT NULL
            DROP TABLE #tempAddressObject;

		

/**************************************************************************************************/
												--Inlclude Locations only
		
        DECLARE @providersDirectory TABLE
            (
              DiamondID VARCHAR(12) ,
              DirectoryID VARCHAR(12) NULL
            );
        INSERT  INTO @providersDirectory
                ( DiamondID, DirectoryID )
        VALUES  ( '000000000133', '08519-1633' ),
                ( '000000000140', '00056-6828' ),
                ( '000000000149', '03177-9940' ),
                ( '000000000150', '01471-2734' ),
                ( '000000000160', '00832-4042' ),
                ( '000000000168', '01510-4763' ),
                ( '000000000173', '01557-2508' ),
                ( '000000000196', '08052-0000' ),
                ( '000000000204', '00476-9365' ),
                ( '000000000209', '07336-1299' ),
                ( '000000000230', '08285-1172' ),
                ( '000000000252', '07536-6231' ),
                ( '000000000302', '05647-4241' ),
                ( '000000000303', '00694-5087' ),
                ( '000000000306', '01835-0433' ),
                ( '000000000312', '07796-4485' ),
                ( '000000000320', '00552-5250' ),
                ( '000000000325', '00348-1155' ),
                ( '000000000329', '05784-8589' ),
                ( '000000000336', '00565-1098' ),
                ( '000000000360', '01625-2527' ),
                ( '000000000362', '00489-3123' ),
                ( '000000000368', '00816-4038' ),
                ( '000000000369', '02106-8101' ),
                ( '000000000376', '00346-5948' ),
                ( '000000000383', '01759-6122' ),
                ( '000000000397', '00046-2886' ),
                ( '000000000399', '01643-7828' ),
                ( '000000000403', '04236-5713' ),
                ( '000000000407', '01045-7379' ),
                ( '000000000420', '01745-6699' ),
                ( '000000000424', '01767-0393' ),
                ( '000000000427', '01746-9795' ),
                ( '000000000450', '00655-0445' ),
                ( '000000000459', '00383-2749' ),
                ( '000000000481', '05356-0918' ),
                ( '000000000483', '00578-2495' ),
                ( '000000000484', '00347-6383' ),
                ( '000000000488', '05751-5905' ),
                ( '000000000489', '01170-8050' ),
                ( '000000000493', '01874-0305' ),
                ( '000000000508', '00654-7430' ),
                ( '000000000520', '00924-1892' ),
                ( '000000000525', '01991-6228' ),
                ( '000000000527', '01830-2289' ),
                ( '000000000529', '06860-3339' ),
                ( '000000000532', '01296-3358' ),
                ( '000000000553', '00234-8894' ),
                ( '000000000565', '06802-5495' ),
                ( '000000000572', '04574-1372' ),
                ( '000000000576', '00233-9115' ),
                ( '000000000583', '00693-3009' ),
                ( '000000000597', '01970-3315' ),
                ( '000000000625', '09529-3377' ),
                ( '000000000628', '00517-1696' ),
                ( '000000000632', '00356-1514' ),
                ( '000000000637', '01885-5282' ),
                ( '000000000653', '01810-5930' ),
                ( '000000000657', '00411-3163' ),
                ( '000000000659', '01012-7562' ),
                ( '000000000666', '04281-8709' ),
                ( '000000000667', '09583-2509' ),
                ( '000000000669', '08102-2035' ),
                ( '000000000718', '01669-8656' ),
                ( '000000000736', '03861-2916' ),
                ( '000000000742', '04687-0011' ),
                ( '000000000746', '05633-0143' ),
                ( '000000000754', '04250-1403' ),
                ( '000000000755', '00025-0501' ),
                ( '000000000773', '01867-0287' ),
                ( '000000000775', '07726-7297' ),
                ( '000000000787', '00023-9107' ),
                ( '000000000800', '00274-2792' ),
                ( '000000000824', '04815-7688' ),
                ( '000000000829', '04815-7688' ),
                ( '000000000834', '00794-6167' ),
                ( '000000000837', '00764-3911' ),
                ( '000000000838', '00773-0958' ),
                ( '000000000865', '01133-0422' ),
                ( '000000000872', '03738-6220' ),
                ( '000000000879', '04725-2480' ),
                ( '000000000881', '00723-0067' ),
                ( '000000000883', '06753-5800' ),
                ( '000000000886', '04449-1201' ),
                ( '000000000892', '01975-3396' ),
                ( '000000000893', '04767-4155' ),
                ( '000000000894', '06777-9707' ),
                ( '000000000906', '01528-5226' ),
                ( '000000000907', '09107-5781' ),
                ( '000000000910', '05784-8589' ),
                ( '000000000914', '00004-4491' ),
                ( '000000000928', '00505-1069' ),
                ( '000000000956', '00339-9644' ),
                ( '000000000971', '01176-7844' ),
                ( '000000000979', '00332-1227' ),
                ( '000000000984', '01795-0125' ),
                ( '000000000992', '00404-6319' ),
                ( '000000000994', '06899-7785' ),
                ( '000000001019', '00329-3300' ),
                ( '000000001024', '00304-5158' ),
                ( '000000001034', '01993-5499' ),
                ( '000000001038', '01601-5736' ),
                ( '000000001047', '07365-4828' ),
                ( '000000001051', '08442-2906' ),
                ( '000000001065', '01973-9483' ),
                ( '000000001082', '01738-7330' ),
                ( '000000001086', '02858-1598' ),
                ( '000000001091', '02862-0995' ),
                ( '000000001103', '02108-1873' ),
                ( '000000001115', '09332-9788' ),
                ( '000000001126', '01657-6789' ),
                ( '000000001142', '06549-6192' ),
                ( '000000001149', '08790-2782' ),
                ( '000000001152', '04425-7773' ),
                ( '000000001158', '02826-9057' ),
                ( '000000001165', '05708-5387' ),
                ( '000000001167', '01548-9544' ),
                ( '000000001176', '08930-5595' ),
                ( '000000001177', '00887-8451' ),
                ( '000000001178', '08083-9888' ),
                ( '000000001202', '01886-9520' ),
                ( '000000001208', '03805-3872' ),
                ( '000000001218', '07758-1580' ),
                ( '000000001248', '01515-0187' ),
                ( '000000001305', '07919-3920' ),
                ( '000000001648', '00413-8262' ),
                ( '000000001651', '01754-9154' ),
                ( '000000001653', '05205-9002' ),
                ( '000000001669', '05214-6789' ),
                ( '000000001670', '00966-5652' ),
                ( '000000001674', '00835-1024' ),
                ( '000000001698', '00608-7050' ),
                ( '000000001703', '01175-2727' ),
                ( '000000001708', '05416-5002' ),
                ( '000000001759', '01093-0310' ),
                ( '000000001768', '00236-5771' ),
                ( '000000001937', '07696-0897' ),
                ( '000000002052', '01239-2202' ),
                ( '000000002226', '00010-0907' ),
                ( '000000002554', '00361-2056' ),
                ( '000000002614', '01738-7330' ),
                ( '000000002810', '01334-3289' ),
                ( '000000003119', '08103-3336' ),
                ( '000000003153', '10180-4705' ),
                ( '000000003725', '01318-1438' ),
                ( '000000003752', '04414-3288' ),
                ( '000000003763', '01146-6991' ),
                ( '000000003870', '07588-2053' ),
                ( '000000003920', '07675-3980' ),
                ( '000000003938', '00856-3825' ),
                ( '000000003944', '04158-1510' ),
                ( '000000004010', '01477-8440' ),
                ( '000000004046', '03786-3387' ),
                ( '000000004104', '00832-4042' ),
                ( '000000004201', '05962-9620' ),
                ( '000000004242', '08760-8103' ),
                ( '000000004278', '03809-1166' ),
                ( '000000004286', '04454-2030' ),
                ( '000000004380', '00228-5134' ),
                ( '000000004480', '01260-6462' ),
                ( '000000004482', '08098-5103' ),
                ( '000000004530', '01318-1438' ),
                ( '000000005085', '02825-3387' ),
                ( '000000005174', '07534-1220' ),
                ( '000000005260', '01642-3330' ),
                ( '000000005319', '00728-0826' ),
                ( '000000005589', '07103-8649' ),
                ( '000000005850', '02051-2394' ),
                ( '000000005907', '01455-5006' ),
                ( '000000005909', '01833-1600' ),
                ( '000000006065', '09192-3785' ),
                ( '000000006400', '00230-1558' ),
                ( '000000006709', '00050-7905' ),
                ( '000000006814', '09219-0080' ),
                ( '000000006834', '00373-9003' ),
                ( '000000006860', '01994-0308' ),
                ( '000000007060', '00728-0826' ),
                ( '000000007273', '00363-1499' ),
                ( '000000007277', '02030-0144' ),
                ( '000000007338', '07280-3766' ),
                ( '000000007405', '05207-0388' ),
                ( '000000007529', '00444-5565' ),
                ( '000000007937', '07252-4441' ),
                ( '000000007938', '01755-8096' ),
                ( '000000008676', '00365-8803' ),
                ( '000000008709', '01818-0430' ),
                ( '000000008787', '05805-2296' ),
                ( '000000009111', '07676-8969' ),
                ( '000000009176', '07173-9478' ),
                ( '000000009177', '00919-4435' ),
                ( '000000009179', '07666-6812' ),
                ( '000000009274', '09113-1960' ),
                ( '000000009305', '09805-2277' ),
                ( '000000009705', '00030-1389' ),
                ( '000000009851', '06752-9761' ),
                ( '000000009889', '08402-0907' ),
                ( '000000010142', '01818-0430' ),
                ( '000000010278', '07810-4098' ),
                ( '000000010394', '07689-8406' ),
                ( '000000010442', '00790-3470' ),
                ( '000000010485', '00878-7851' ),
                ( '000000010554', '00002-4657' ),
                ( '000000010561', '00036-8943' ),
                ( '000000010706', '00452-2154' ),
                ( '000000010878', '00267-8675' ),
                ( '000000010898', '07701-2315' ),
                ( '000000011263', '08985-7290' ),
                ( '000000011409', '07764-0255' ),
                ( '000000011565', '01160-9439' ),
                ( '000000011736', '01689-8760' ),
                ( '000000011741', '01992-4577' ),
                ( '000000011799', '04083-3833' ),
                ( '000000011869', '00030-1389' ),
                ( '000000012166', '02609-7218' ),
                ( '000000012168', '02104-5801' ),
                ( '000000012169', '01807-9194' ),
                ( '000000012171', '03832-8558' ),
                ( '000000012265', '06199-0920' ),
                ( '000000012382', '08400-6846' ),
                ( '000000012428', '07919-3920' ),
                ( '000000012464', '01038-8589' ),
                ( '000000012669', '06255-2547' ),
                ( '000000012748', '03647-0522' ),
                ( '000000012988', '09132-6019' ),
                ( '000000013264', '08790-2782' ),
                ( '000000013867', '04179-4514' ),
                ( '000000013921', '06248-8240' ),
                ( '000000013923', '04264-8573' ),
                ( '000000013924', '05156-0237' ),
                ( '000000013925', '00107-2443' ),
                ( '000000013939', '04209-4897' ),
                ( '000000013973', '04111-2361' ),
                ( '000000014463', '05442-1880' ),
                ( '000000014465', '06159-5878' ),
                ( '000000014845', '05371-7831' ),
                ( '000000014902', '09911-9025' ),
                ( '000000014907', '01689-8760' ),
                ( '000000014922', '05468-0616' ),
                ( '000000014957', '04815-7688' ),
                ( '000000014959', '08930-5595' ),
                ( '000000014961', '06225-6132' ),
                ( '000000014970', '02563-4563' ),
                ( '000000014991', '04622-3611' ),
                ( '000000015122', '04510-7765' ),
                ( '000000015171', '09437-7780' ),
                ( '000000015173', '02300-5295' ),
                ( '000000015174', '01071-3570' ),
                ( '000000015354', '00044-9966' ),
                ( '000000015408', '07745-2105' ),
                ( '000000015432', '02479-9998' ),
                ( '000000015448', '04635-7409' ),
                ( '000000015522', '07782-0760' ),
                ( '000000015549', '06668-8640' ),
                ( '000000015602', '01689-8760' ),
                ( '000000015716', '01428-2962' ),
                ( '000000015885', '06188-5147' ),
                ( '000000016094', '01899-1087' ),
                ( '000000016863', '00730-0606' ),
                ( '000000016919', '01689-8760' ),
                ( '000000016935', '07745-2105' ),
                ( '000000017226', '07457-1132' ),
                ( '000000017318', '00833-0459' ),
                ( '000000017393', '06633-9988' ),
                ( '000000017427', '06685-2066' ),
                ( '000000017476', '05312-3785' ),
                ( '000000017519', '06751-7980' ),
                ( '000000017555', '07175-6626' ),
                ( '000000017889', '05967-0523' ),
                ( '000000017960', '05986-0563' ),
                ( '000000017961', '06945-9394' ),
                ( '000000017962', '00021-9400' ),
                ( '000000018272', '00617-1029' ),
                ( '000000018808', '07539-9922' ),
                ( '000000018847', '07434-2343' ),
                ( '000000018891', '09218-3016' ),
                ( '000000019152', '07720-9119' ),
                ( '000000019220', '03813-8150' ),
                ( '000000019278', '01917-8012' ),
                ( '000000019358', '08696-0365' ),
                ( '000000019752', '07672-5840' ),
                ( '000000019904', '07745-2105' ),
                ( '000000020198', '04772-5686' ),
                ( '000000020337', '07919-3920' ),
                ( '000000020809', '05976-2756' ),
                ( '000000022500', '01738-7330' ),
                ( '000000030046', '08602-2544' ),
                ( '000000030061', '01849-0199' ),
                ( '000000030078', '02131-2008' ),
                ( '000000030194', '04634-5687' ),
                ( '000000030456', '08930-5595' ),
                ( '000000030836', '07895-4719' ),
                ( '000000030968', '00034-0527' ),
                ( '000000030990', '00052-8193' ),
                ( '000000031202', '06156-7911' ),
                ( '000000031211', '09525-2769' ),
                ( '000000031516', '01285-6443' ),
                ( '000000031732', '09050-6146' ),
                ( '000000033159', '04815-7688' ),
                ( '000000033776', '03967-1973' ),
                ( '000000033777', '03347-4599' ),
                ( '000000033941', '08225-0500' ),
                ( '000000034004', '07743-5029' ),
                ( '000000034044', '09853-2739' ),
                ( '000000034200', '09581-0700' ),
                ( '000000034267', '01738-7330' ),
                ( '000000034368', '09871-4420' ),
                ( '000000034475', '07725-4689' ),
                ( '000000034518', '06199-0920' ),
                ( '000000035214', '08389-4462' ),
                ( '000000035832', '01638-8155' ),
                ( '000000035841', '00682-6223' ),
                ( '000000035852', '09727-2065' ),
                ( '000000035854', '08530-0499' ),
                ( '000000035861', '08754-4710' ),
                ( '000000035867', '08382-1122' ),
                ( '000000036951', '01689-8760' ),
                ( '000000037088', '02152-3447' ),
                ( '000000037208', '06199-0920' ),
                ( '000000037324', '01681-0084' ),
                ( '000000037325', '01094-9766' ),
                ( '000000037326', '01995-1346' ),
                ( '000000037466', '06199-0920' ),
                ( '000000037543', '06919-0122' ),
                ( '000000037556', '00515-8994' ),
                ( '000000037943', '01689-8760' ),
                ( '000000038519', '00034-0527' ),
                ( '000000038524', '06199-0920' ),
                ( '000000039332', '01777-1333' ),
                ( '000000040462', '03487-8810' ),
                ( '000000043906', '06199-0920' );

--/**************************************************************************************************/
				--Get given locationIds 

		INSERT INTO @GiveLocationIds
		SELECT DISTINCT
		 PDP_LocationID FROM Network_Development.dbo.Tbl_ProviderDirectory_VerificationProvider AS PDP WITH (NOLOCK)
		 WHERE PDP.PDP_DirectoryID IN (SELECT DISTINCT directoryID FROM @providersDirectory)




/**************************************************************************************************/
														 --Get Tax IDs and LocationId from Network 
        IF ( @TaxID IS NOT NULL )
            BEGIN 
                INSERT  INTO @LocationTaxID
                        SELECT DISTINCT
                                CL.CL_ID ,
                                CLN.CLN_TIN AS taxid
                        FROM    Network_Development.dbo.Tbl_Provider_ProviderInfo PPI
                                WITH ( NOLOCK )
                                INNER JOIN Network_Development.[dbo].[Tbl_Contract_LocationsNumbers] CLN ON ISNULL(PPI.PPI_ID,
                                                              '') = ISNULL(CLN.CLNS_ProviderID,
                                                              '')
                                LEFT JOIN Network_Development.[dbo].[Tbl_Contract_Locations] CL
                                WITH ( NOLOCK ) ON CL.CL_ID = CLN.CLNS_LocationID
                        WHERE   CLN.CLNS_Status = 1
                                AND ( CL.CL_ID IS NOT NULL )
                                AND ( CLN.CLN_TIN IS NOT NULL )
                        UNION
                        SELECT DISTINCT
                                CL.CL_ID ,
                                CLI.CCI_TIN AS taxid
                        FROM    Network_Development.dbo.Tbl_Provider_ProviderInfo PPI
                                WITH ( NOLOCK )
                                INNER JOIN Network_Development.[dbo].[Tbl_Contract_CPL] CPL
                                WITH ( NOLOCK ) ON CPL.CCPL_ProviderID = PPI.PPI_ID
                                LEFT JOIN Network_Development.[dbo].[Tbl_Contract_Locations] CL
                                WITH ( NOLOCK ) ON CPL.CCPL_LocationID = CL.CL_ID
                                LEFT JOIN Network_Development.[dbo].[Tbl_Contract_ContractInfo] CLI
                                WITH ( NOLOCK ) ON CLI.CCI_ID = CPL.CCPL_ContractID
                        WHERE   ( CLI.CCI_TermDate IS NULL
                                  OR CLI.CCI_TermDate > @now
                                )
                                AND ( CPL.CCPL_TermDate IS NULL
                                      OR CPL.CCPL_TermDate > @now
                                    )
                                AND ( CL.CL_ID IS NOT NULL )
                                AND ( CLI.CCI_TIN IS NOT NULL )
                        UNION
                        SELECT DISTINCT
                                CL.CL_ID ,
                                CL.CL_TIN AS taxid
                        FROM    Network_Development.dbo.Tbl_Provider_ProviderInfo PPI
                                WITH ( NOLOCK )
                                INNER JOIN Network_Development.[dbo].Tbl_Provider_ProviderAffiliation PPA
                                WITH ( NOLOCK ) ON PPA_ProviderID = PPI.PPI_ID
                                INNER JOIN Network_Development.[dbo].[Tbl_Contract_Locations] CL
                                WITH ( NOLOCK ) ON PPA_LocationID = CL.CL_ID
                        WHERE   ( PPA_TermDate IS NULL
                                  OR PPA_TermDate > @now
                                )
                                AND ( CL.CL_ID IS NOT NULL )
                                AND ( CL.CL_TIN IS NOT NULL );


													   --Get Tax IDs and ProviderID from Diamond 
                INSERT  INTO @LocationTaxID
                        SELECT DISTINCT
                                A.PCNDLOCID ,
                                LEFT(A.PCDEFVENDR, 9)
                        FROM    Diam_725_App.diamond.JPROVFM0_DAT AS F WITH ( NOLOCK )
                                JOIN Diam_725_App.diamond.JPROVAM0_DAT AS A
                                WITH ( NOLOCK ) ON A.PCPROVID = F.PAPROVID
                        WHERE   PCDEFVENDR NOT IN ( 'DONOTUSE', 'INFOR',
                                                    'DO NOT USE' )
                                AND F.PATYPE IN ( 'PCP', 'TPCP', 'MPCP',
                                                  'NPCP' );

/**************************************************************************************************/


/**************************************************************************************************/

												 --Get LocationId from ProviderSearchCore based on TaxID 
                INSERT  INTO @LocationIDs
                              SELECT DISTINCT
                                LTI.LocationID
                        FROM    search.Address AS a WITH ( NOLOCK )  
								JOIN search.provider AS P WITH (nolock) ON P.ProviderID = A.ProviderID
                                JOIN @LocationTaxID LTI ON LTI.Locationid = a.LocationID
                        WHERE   (@TaxID = LTI.taxid)
								AND LTI.LocationID IN (SELECT DISTINCT LocationID FROM @GiveLocationIds)	
						     	AND P.DiamProvID IN (SELECT DISTINCT DiamondID FROM @providersDirectory)

            END;

/**************************************************************************************************/
        IF ( @TaxID IS NULL
             AND @AddressID IS NOT NULL
           )
            BEGIN
                INSERT  INTO @LocationIDs
                        SELECT DISTINCT
                                T.LocationID
                        FROM    search.Address AS T WITH ( NOLOCK )
                        WHERE   T.AddressID = @AddressID;
            END;


/**************************************************************************************************/
        IF ( @TaxID IS NULL
             AND @AddressID IS NULL
           )
            BEGIN   
                INSERT  INTO @LocationIDs
                        SELECT DISTINCT
                                LocationID
                        FROM    search.Address AS a WITH ( NOLOCK );
            END;	
/**************************************************************************************************/
																		--Get address Details for provides under that TaxID	
        SELECT DISTINCT
                a.* ,
                DL.CreationTimestamp AS LastUpdatedDate ,
                DLU.UserName ,
                CASE WHEN CL.CL_EMRSystem = LV.DBLV_ID THEN LV.DBLV_Value
                END AS EmrSystem ,
                CASE WHEN CL.CL_EMR = -1 THEN CAST(1 AS BIT)
                     ELSE CAST(0 AS BIT)
                END AS EMR ,
                CL.CL_OfficeManager AS OfficeManager ,
                CL.CL_ReferralFax AS ReferralFax ,
                CASE WHEN PPC.PPC_ProviderID = PPI.PPI_ID
                     THEN ( PPI.PPI_LastName + ', ' + PPI.PPI_FirstName + ' '
                            + PPI.PPI_MiddleName )
                END AS Supervisor ,
                DL.ChangeStatus AS StatusLabel ,
                DL.SupportedDocumentId AS SupportedDocumentID ,
                DL.CrossReferenceSystemValue AS ConfirmationID ,
	/****		--Add here if any new field required from Datalog or DatalogRecord ********/
                DL.DataLogRecordId AS LastUpdateRequestID ,
                CL.CL_NPI AS GroupNPI ,
                p.DiamProvID AS DiamondID
        INTO    #address
        FROM    search.Address AS a WITH ( NOLOCK )
                JOIN @LocationIDs AS aid ON aid.LocationID = a.LocationID
                INNER JOIN search.Provider AS p WITH ( NOLOCK ) ON a.ProviderID = p.ProviderID
                LEFT JOIN Network_Development.dbo.Tbl_Contract_Locations AS CL
                WITH ( NOLOCK ) ON CL.CL_ID = a.LocationID
                LEFT JOIN Network_Development.dbo.Tbl_Provider_ProviderCoverage
                AS PPC WITH ( NOLOCK ) ON PPC.PPC_ProviderID = p.NetDevProvID
                                          AND PPC.PPC_LocationID = a.LocationID
                LEFT JOIN Network_Development.dbo.Tbl_Provider_ProviderInfo AS PPI
                WITH ( NOLOCK ) ON PPI.PPI_ID = p.NetDevProvID
                LEFT JOIN Network_Development.dbo.Tbl_Database_ListValues AS LV
                WITH ( NOLOCK ) ON LV.DBLV_List = 71
                                   AND LV.DBLV_ID = CL_EMRSystem
                LEFT JOIN changed.DataLogRecord AS DL WITH ( NOLOCK ) ON DL.TablePKFieldValue = a.AddressID
                                                              AND DL.TableName = 'search.Address'
                LEFT JOIN changed.DataLogUser AS DLU WITH ( NOLOCK ) ON DLU.DataLogRecordId = DL.DataLogRecordId
        WHERE   p.ProviderType IN ( 'PCP', 'MPCP', 'NPCP', 'NPP', 'VSN', 'BH',
                                    'SPEC', 'ANC' )
				AND P.DiamProvID IN (SELECT DISTINCT DiamondID FROM @providersDirectory)				
									; 

/**************************************************************************************************/												
													--Remove Duplicate Addresses
        SELECT 
	  DISTINCT  T.[AddressID] ,
                T.LocationID ,
                T.[Street] ,
                T.[City] ,
                T.[Zip] ,
                T.[County] ,
                T.[Phone] ,
                T.[AfterHoursPhone] ,
                T.[Fax] ,
                T.[Email] ,
                T.[WebSite] ,
                T.[BusStop] ,
                T.[Accessibility] ,
                T.[Walkin] ,
                T.[BuildingSign] ,
                T.[AppointmentNeeded] ,
                T.[Hours] ,
                T.[MedicalGroup] ,
                T.[FederallyQualifiedHC] ,
                T.[State] ,
                T.EMR ,
                T.EmrSystem ,
                T.OfficeManager ,
                T.ReferralFax ,
                T.Supervisor ,
                T.GroupNPI ,
                T.DiamondID ,
                T.LastUpdatedDate AS LastUpdatedDate ,
                DATEADD(MONTH, @ExpirationMonths, T.LastUpdatedDate) AS NextUpdateRequireDate ,
                T.username AS UserName ,
                T.StatusLabel AS StatusLabel ,
                T.SupportedDocumentID AS SupportedDocumentID ,
                T.ConfirmationID AS ConfirmationID ,
                T.LastUpdateRequestID AS LastUpdateRequestID
        INTO    #tempAddressObject
        FROM    ( SELECT    * ,
                            ROW_NUMBER() OVER ( PARTITION BY Street, City, Zip,
                                                County, State ORDER BY lastupdateddate DESC ) AS ranking
                  FROM      #address AS a WITH ( NOLOCK )
                ) T
        WHERE   T.ranking = 1
                AND ( T.AddressID = @AddressID
                      OR @AddressID IS NULL
                    )
					;
/**************************************************************************************************/	
														--Get Address Details
        SELECT 
	  DISTINCT  T.[AddressID] ,
                T.LocationID ,
                T.[Street] ,
                T.[City] ,
                T.[Zip] ,
                T.[County] ,
                T.[Phone] ,
                T.[AfterHoursPhone] ,
                T.[Fax] ,
                T.[Email] ,
                T.[WebSite] ,
                T.[BusStop] ,
                T.[Accessibility] ,
                T.[Walkin] ,
                T.[BuildingSign] ,
                T.[AppointmentNeeded] ,
                T.[Hours] ,
                T.[MedicalGroup] ,
                T.[FederallyQualifiedHC] ,
                T.[State] ,
                T.EMR ,
                T.EmrSystem ,
                T.OfficeManager ,
                T.ReferralFax ,
                T.Supervisor ,
                T.GroupNPI ,
                T.DiamondID
        FROM    #tempAddressObject AS T WITH ( NOLOCK );
		
/**************************************************************************************************/	
															--Get last update signature
        SELECT DISTINCT
                T.AddressID AS RecordID ,
		--T.LocationID as LocationID,
                T.LastUpdatedDate AS LastUpdatedDate ,
                T.username AS LastUpdatedBy ,
                T.LastUpdateRequestID AS LastUpdateRequestID ,
                T.NextUpdateRequireDate AS NextUpdateRequireDate ,
                T.ConfirmationID AS ConfirmationID ,
                T.StatusLabel AS ChangeStatus
        FROM    #tempAddressObject T
        WHERE   T.LastUpdatedDate = ( SELECT    MAX(LastUpdatedDate)
                                      FROM      #tempAddressObject AS T2 WITH ( NOLOCK )
                                      WHERE     T2.LastUpdateRequestID = T.LastUpdateRequestID
                                    )
                AND T.StatusLabel IN ( 'Completed', 'Updated' );

/**************************************************************************************************/	
															 --Get Collection of PendingChanges
        SELECT  T.AddressID AS RecordID ,
	   --T.LocationID as LocationID,
                T.SupportedDocumentID AS SupportedDocumentID ,
                T.LastUpdatedDate AS PendingUpdateDate ,
                T.UserName AS PendingUpdateBy ,
                T.LastUpdateRequestID AS PendingUpdateRequestID ,
                T.ConfirmationID AS ConfirmationID ,
                T.StatusLabel AS ChangeStatus
        FROM    #address T
                JOIN #tempAddressObject T2 WITH ( NOLOCK ) ON T2.AddressID = T.AddressID
        WHERE   T.StatusLabel <> 'Completed'
        ORDER BY T.LastUpdateRequestID ASC;


/**************************************************************************************************/	
        DROP TABLE #tempAddressObject;
        DROP TABLE #address;	

/**************************************************************************************************/

    END; 


      --  SELECT DISTINCT a.*,
      --                DL.creationtimestamp AS LastUpdatedDate, 
      --                DLU.username,
					 -- Null as StatusLabel,
					 -- Null as PendingUpdateDate,
					 -- Null as PendingUpdateBy,
					 -- Null as PendingRequestID,
					 -- Null as LastUpdateRequestID 
      --INTO   #address 
      --FROM   @ProviderDetails AS PD 
      --       JOIN search.address AS a WITH (nolock) 
      --         ON a.providerid = PD.providerid 
      --       LEFT JOIN changed.datalogrecord AS DL WITH (nolock) 
      --              ON DL.tablepkfieldvalue = PD.providerid 
      --       LEFT JOIN changed.dataloguser AS DLU WITH (nolock) 
      --              ON DLU.datalogrecordid = DL.datalogrecordid 
      --WHERE  DL.creationtimestamp = (SELECT Max(creationtimestamp) 
      --                               FROM   changed.datalog AS DL1 
      --                               WHERE 
      --       DL1.tablepkfieldvalue = DL.tablepkfieldvalue) 
      --        OR Dl.creationtimestamp IS NULL 
GO
/****** Object:  StoredProcedure [changed].[GetAreaOfExpertiseForDropDown]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [changed].[GetAreaOfExpertiseForDropDown] 
					
	
AS 
  BEGIN 
      SET nocount ON 


	Select distinct
		LV.DBLV_Value as AreaOfExpertise

	From Network_Development.dbo.Tbl_Provider_ProviderSpecialtiesExpertise  PSE with (nolock) 
	Inner join Network_Development.dbo.Tbl_Database_ListValues as LV with (nolock) on  LV.dblv_List = 37 and PSE.PSPE_Area = LV.DBLV_ID


END

GO
/****** Object:  StoredProcedure [changed].[GetChangeRequestStatus]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [changed].[GetChangeRequestStatus]
    @DiamondID VARCHAR(12) = NULL ,
    @MonthsRange INT = 3
AS
    BEGIN 
        SET NOCOUNT ON; 

	  	  /*
			Modification Log:
			
		*/
/**************************************************************************************************/

								--Declare Variables

			
        DECLARE @providerSDirectory TABLE
            (
              DiamondID VARCHAR(12) ,
              DirectoryID VARCHAR(12) NULL
            );

/**************************************************************************************************/
												--List of Providers to Include
												
        INSERT  INTO @providerSDirectory
                ( DiamondID, DirectoryID )
        VALUES  ( '000000000133', '08519-1633' ),
                ( '000000000140', '00056-6828' ),
                ( '000000000149', '03177-9940' ),
                ( '000000000150', '01471-2734' ),
                ( '000000000160', '00832-4042' ),
                ( '000000000168', '01510-4763' ),
                ( '000000000173', '01557-2508' ),
                ( '000000000196', '08052-0000' ),
                ( '000000000204', '00476-9365' ),
                ( '000000000209', '07336-1299' ),
                ( '000000000230', '08285-1172' ),
                ( '000000000252', '07536-6231' ),
                ( '000000000302', '05647-4241' ),
                ( '000000000303', '00694-5087' ),
                ( '000000000306', '01835-0433' ),
                ( '000000000312', '07796-4485' ),
                ( '000000000320', '00552-5250' ),
                ( '000000000325', '00348-1155' ),
                ( '000000000329', '05784-8589' ),
                ( '000000000336', '00565-1098' ),
                ( '000000000360', '01625-2527' ),
                ( '000000000362', '00489-3123' ),
                ( '000000000368', '00816-4038' ),
                ( '000000000369', '02106-8101' ),
                ( '000000000376', '00346-5948' ),
                ( '000000000383', '01759-6122' ),
                ( '000000000397', '00046-2886' ),
                ( '000000000399', '01643-7828' ),
                ( '000000000403', '04236-5713' ),
                ( '000000000407', '01045-7379' ),
                ( '000000000420', '01745-6699' ),
                ( '000000000424', '01767-0393' ),
                ( '000000000427', '01746-9795' ),
                ( '000000000450', '00655-0445' ),
                ( '000000000459', '00383-2749' ),
                ( '000000000481', '05356-0918' ),
                ( '000000000483', '00578-2495' ),
                ( '000000000484', '00347-6383' ),
                ( '000000000488', '05751-5905' ),
                ( '000000000489', '01170-8050' ),
                ( '000000000493', '01874-0305' ),
                ( '000000000508', '00654-7430' ),
                ( '000000000520', '00924-1892' ),
                ( '000000000525', '01991-6228' ),
                ( '000000000527', '01830-2289' ),
                ( '000000000529', '06860-3339' ),
                ( '000000000532', '01296-3358' ),
                ( '000000000553', '00234-8894' ),
                ( '000000000565', '06802-5495' ),
                ( '000000000572', '04574-1372' ),
                ( '000000000576', '00233-9115' ),
                ( '000000000583', '00693-3009' ),
                ( '000000000597', '01970-3315' ),
                ( '000000000625', '09529-3377' ),
                ( '000000000628', '00517-1696' ),
                ( '000000000632', '00356-1514' ),
                ( '000000000637', '01885-5282' ),
                ( '000000000653', '01810-5930' ),
                ( '000000000657', '00411-3163' ),
                ( '000000000659', '01012-7562' ),
                ( '000000000666', '04281-8709' ),
                ( '000000000667', '09583-2509' ),
                ( '000000000669', '08102-2035' ),
                ( '000000000718', '01669-8656' ),
                ( '000000000736', '03861-2916' ),
                ( '000000000742', '04687-0011' ),
                ( '000000000746', '05633-0143' ),
                ( '000000000754', '04250-1403' ),
                ( '000000000755', '00025-0501' ),
                ( '000000000773', '01867-0287' ),
                ( '000000000775', '07726-7297' ),
                ( '000000000787', '00023-9107' ),
                ( '000000000800', '00274-2792' ),
                ( '000000000824', '04815-7688' ),
                ( '000000000829', '04815-7688' ),
                ( '000000000834', '00794-6167' ),
                ( '000000000837', '00764-3911' ),
                ( '000000000838', '00773-0958' ),
                ( '000000000865', '01133-0422' ),
                ( '000000000872', '03738-6220' ),
                ( '000000000879', '04725-2480' ),
                ( '000000000881', '00723-0067' ),
                ( '000000000883', '06753-5800' ),
                ( '000000000886', '04449-1201' ),
                ( '000000000892', '01975-3396' ),
                ( '000000000893', '04767-4155' ),
                ( '000000000894', '06777-9707' ),
                ( '000000000906', '01528-5226' ),
                ( '000000000907', '09107-5781' ),
                ( '000000000910', '05784-8589' ),
                ( '000000000914', '00004-4491' ),
                ( '000000000928', '00505-1069' ),
                ( '000000000956', '00339-9644' ),
                ( '000000000971', '01176-7844' ),
                ( '000000000979', '00332-1227' ),
                ( '000000000984', '01795-0125' ),
                ( '000000000992', '00404-6319' ),
                ( '000000000994', '06899-7785' ),
                ( '000000001019', '00329-3300' ),
                ( '000000001024', '00304-5158' ),
                ( '000000001034', '01993-5499' ),
                ( '000000001038', '01601-5736' ),
                ( '000000001047', '07365-4828' ),
                ( '000000001051', '08442-2906' ),
                ( '000000001065', '01973-9483' ),
                ( '000000001082', '01738-7330' ),
                ( '000000001086', '02858-1598' ),
                ( '000000001091', '02862-0995' ),
                ( '000000001103', '02108-1873' ),
                ( '000000001115', '09332-9788' ),
                ( '000000001126', '01657-6789' ),
                ( '000000001142', '06549-6192' ),
                ( '000000001149', '08790-2782' ),
                ( '000000001152', '04425-7773' ),
                ( '000000001158', '02826-9057' ),
                ( '000000001165', '05708-5387' ),
                ( '000000001167', '01548-9544' ),
                ( '000000001176', '08930-5595' ),
                ( '000000001177', '00887-8451' ),
                ( '000000001178', '08083-9888' ),
                ( '000000001202', '01886-9520' ),
                ( '000000001208', '03805-3872' ),
                ( '000000001218', '07758-1580' ),
                ( '000000001248', '01515-0187' ),
                ( '000000001305', '07919-3920' ),
                ( '000000001648', '00413-8262' ),
                ( '000000001651', '01754-9154' ),
                ( '000000001653', '05205-9002' ),
                ( '000000001669', '05214-6789' ),
                ( '000000001670', '00966-5652' ),
                ( '000000001674', '00835-1024' ),
                ( '000000001698', '00608-7050' ),
                ( '000000001703', '01175-2727' ),
                ( '000000001708', '05416-5002' ),
                ( '000000001759', '01093-0310' ),
                ( '000000001768', '00236-5771' ),
                ( '000000001937', '07696-0897' ),
                ( '000000002052', '01239-2202' ),
                ( '000000002226', '00010-0907' ),
                ( '000000002554', '00361-2056' ),
                ( '000000002614', '01738-7330' ),
                ( '000000002810', '01334-3289' ),
                ( '000000003119', '08103-3336' ),
                ( '000000003153', '10180-4705' ),
                ( '000000003725', '01318-1438' ),
                ( '000000003752', '04414-3288' ),
                ( '000000003763', '01146-6991' ),
                ( '000000003870', '07588-2053' ),
                ( '000000003920', '07675-3980' ),
                ( '000000003938', '00856-3825' ),
                ( '000000003944', '04158-1510' ),
                ( '000000004010', '01477-8440' ),
                ( '000000004046', '03786-3387' ),
                ( '000000004104', '00832-4042' ),
                ( '000000004201', '05962-9620' ),
                ( '000000004242', '08760-8103' ),
                ( '000000004278', '03809-1166' ),
                ( '000000004286', '04454-2030' ),
                ( '000000004380', '00228-5134' ),
                ( '000000004480', '01260-6462' ),
                ( '000000004482', '08098-5103' ),
                ( '000000004530', '01318-1438' ),
                ( '000000005085', '02825-3387' ),
                ( '000000005174', '07534-1220' ),
                ( '000000005260', '01642-3330' ),
                ( '000000005319', '00728-0826' ),
                ( '000000005589', '07103-8649' ),
                ( '000000005850', '02051-2394' ),
                ( '000000005907', '01455-5006' ),
                ( '000000005909', '01833-1600' ),
                ( '000000006065', '09192-3785' ),
                ( '000000006400', '00230-1558' ),
                ( '000000006709', '00050-7905' ),
                ( '000000006814', '09219-0080' ),
                ( '000000006834', '00373-9003' ),
                ( '000000006860', '01994-0308' ),
                ( '000000007060', '00728-0826' ),
                ( '000000007273', '00363-1499' ),
                ( '000000007277', '02030-0144' ),
                ( '000000007338', '07280-3766' ),
                ( '000000007405', '05207-0388' ),
                ( '000000007529', '00444-5565' ),
                ( '000000007937', '07252-4441' ),
                ( '000000007938', '01755-8096' ),
                ( '000000008676', '00365-8803' ),
                ( '000000008709', '01818-0430' ),
                ( '000000008787', '05805-2296' ),
                ( '000000009111', '07676-8969' ),
                ( '000000009176', '07173-9478' ),
                ( '000000009177', '00919-4435' ),
                ( '000000009179', '07666-6812' ),
                ( '000000009274', '09113-1960' ),
                ( '000000009305', '09805-2277' ),
                ( '000000009705', '00030-1389' ),
                ( '000000009851', '06752-9761' ),
                ( '000000009889', '08402-0907' ),
                ( '000000010142', '01818-0430' ),
                ( '000000010278', '07810-4098' ),
                ( '000000010394', '07689-8406' ),
                ( '000000010442', '00790-3470' ),
                ( '000000010485', '00878-7851' ),
                ( '000000010554', '00002-4657' ),
                ( '000000010561', '00036-8943' ),
                ( '000000010706', '00452-2154' ),
                ( '000000010878', '00267-8675' ),
                ( '000000010898', '07701-2315' ),
                ( '000000011263', '08985-7290' ),
                ( '000000011409', '07764-0255' ),
                ( '000000011565', '01160-9439' ),
                ( '000000011736', '01689-8760' ),
                ( '000000011741', '01992-4577' ),
                ( '000000011799', '04083-3833' ),
                ( '000000011869', '00030-1389' ),
                ( '000000012166', '02609-7218' ),
                ( '000000012168', '02104-5801' ),
                ( '000000012169', '01807-9194' ),
                ( '000000012171', '03832-8558' ),
                ( '000000012265', '06199-0920' ),
                ( '000000012382', '08400-6846' ),
                ( '000000012428', '07919-3920' ),
                ( '000000012464', '01038-8589' ),
                ( '000000012669', '06255-2547' ),
                ( '000000012748', '03647-0522' ),
                ( '000000012988', '09132-6019' ),
                ( '000000013264', '08790-2782' ),
                ( '000000013867', '04179-4514' ),
                ( '000000013921', '06248-8240' ),
                ( '000000013923', '04264-8573' ),
                ( '000000013924', '05156-0237' ),
                ( '000000013925', '00107-2443' ),
                ( '000000013939', '04209-4897' ),
                ( '000000013973', '04111-2361' ),
                ( '000000014463', '05442-1880' ),
                ( '000000014465', '06159-5878' ),
                ( '000000014845', '05371-7831' ),
                ( '000000014902', '09911-9025' ),
                ( '000000014907', '01689-8760' ),
                ( '000000014922', '05468-0616' ),
                ( '000000014957', '04815-7688' ),
                ( '000000014959', '08930-5595' ),
                ( '000000014961', '06225-6132' ),
                ( '000000014970', '02563-4563' ),
                ( '000000014991', '04622-3611' ),
                ( '000000015122', '04510-7765' ),
                ( '000000015171', '09437-7780' ),
                ( '000000015173', '02300-5295' ),
                ( '000000015174', '01071-3570' ),
                ( '000000015354', '00044-9966' ),
                ( '000000015408', '07745-2105' ),
                ( '000000015432', '02479-9998' ),
                ( '000000015448', '04635-7409' ),
                ( '000000015522', '07782-0760' ),
                ( '000000015549', '06668-8640' ),
                ( '000000015602', '01689-8760' ),
                ( '000000015716', '01428-2962' ),
                ( '000000015885', '06188-5147' ),
                ( '000000016094', '01899-1087' ),
                ( '000000016863', '00730-0606' ),
                ( '000000016919', '01689-8760' ),
                ( '000000016935', '07745-2105' ),
                ( '000000017226', '07457-1132' ),
                ( '000000017318', '00833-0459' ),
                ( '000000017393', '06633-9988' ),
                ( '000000017427', '06685-2066' ),
                ( '000000017476', '05312-3785' ),
                ( '000000017519', '06751-7980' ),
                ( '000000017555', '07175-6626' ),
                ( '000000017889', '05967-0523' ),
                ( '000000017960', '05986-0563' ),
                ( '000000017961', '06945-9394' ),
                ( '000000017962', '00021-9400' ),
                ( '000000018272', '00617-1029' ),
                ( '000000018808', '07539-9922' ),
                ( '000000018847', '07434-2343' ),
                ( '000000018891', '09218-3016' ),
                ( '000000019152', '07720-9119' ),
                ( '000000019220', '03813-8150' ),
                ( '000000019278', '01917-8012' ),
                ( '000000019358', '08696-0365' ),
                ( '000000019752', '07672-5840' ),
                ( '000000019904', '07745-2105' ),
                ( '000000020198', '04772-5686' ),
                ( '000000020337', '07919-3920' ),
                ( '000000020809', '05976-2756' ),
                ( '000000022500', '01738-7330' ),
                ( '000000030046', '08602-2544' ),
                ( '000000030061', '01849-0199' ),
                ( '000000030078', '02131-2008' ),
                ( '000000030194', '04634-5687' ),
                ( '000000030456', '08930-5595' ),
                ( '000000030836', '07895-4719' ),
                ( '000000030968', '00034-0527' ),
                ( '000000030990', '00052-8193' ),
                ( '000000031202', '06156-7911' ),
                ( '000000031211', '09525-2769' ),
                ( '000000031516', '01285-6443' ),
                ( '000000031732', '09050-6146' ),
                ( '000000033159', '04815-7688' ),
                ( '000000033776', '03967-1973' ),
                ( '000000033777', '03347-4599' ),
                ( '000000033941', '08225-0500' ),
                ( '000000034004', '07743-5029' ),
                ( '000000034044', '09853-2739' ),
                ( '000000034200', '09581-0700' ),
                ( '000000034267', '01738-7330' ),
                ( '000000034368', '09871-4420' ),
                ( '000000034475', '07725-4689' ),
                ( '000000034518', '06199-0920' ),
                ( '000000035214', '08389-4462' ),
                ( '000000035832', '01638-8155' ),
                ( '000000035841', '00682-6223' ),
                ( '000000035852', '09727-2065' ),
                ( '000000035854', '08530-0499' ),
                ( '000000035861', '08754-4710' ),
                ( '000000035867', '08382-1122' ),
                ( '000000036951', '01689-8760' ),
                ( '000000037088', '02152-3447' ),
                ( '000000037208', '06199-0920' ),
                ( '000000037324', '01681-0084' ),
                ( '000000037325', '01094-9766' ),
                ( '000000037326', '01995-1346' ),
                ( '000000037466', '06199-0920' ),
                ( '000000037543', '06919-0122' ),
                ( '000000037556', '00515-8994' ),
                ( '000000037943', '01689-8760' ),
                ( '000000038519', '00034-0527' ),
                ( '000000038524', '06199-0920' ),
                ( '000000039332', '01777-1333' ),
                ( '000000040462', '03487-8810' ),
                ( '000000043906', '06199-0920' );

/******************************************************************************************************************/
				--Get Status for Provider Update




        SELECT DISTINCT
                T.DiamondID ,
                T.DataLogRecordId ,
                T.ProviderChangeStatus ,
                T.RequiredAction
        FROM    ( SELECT DISTINCT
                            P.DiamProvID AS DiamondID ,
                            DLR.DataLogRecordId ,
                            DLR.ChangeStatus AS ProviderChangeStatus ,
                            CASE WHEN DLR.ChangeStatus IN ( 'Pending',
                                                            'Completed' )
                                 THEN CAST(0 AS BIT)
                                 ELSE CAST(1 AS BIT)
                            END AS RequiredAction ,
                            DLR.CreationTimestamp ,
                            ROW_NUMBER() OVER ( PARTITION BY DiamondID ORDER BY CreationTimestamp DESC ) AS ranking
                  FROM      search.Provider AS P WITH ( NOLOCK )
                            INNER JOIN @providerSDirectory AS PD ON PD.DiamondID = P.DiamProvID
                            LEFT JOIN changed.DataLogRecord AS DLR WITH ( NOLOCK ) ON DLR.TablePKFieldValue = P.ProviderID
                                                              AND DLR.TableName = 'Search.Provider'
                                                              AND DATEDIFF(MONTH,
                                                              DLR.CreationTimestamp,
                                                              GETDATE()) <= @MonthsRange
                ) T
        WHERE   ( ISNULL(@DiamondID, '') = ''
                  OR @DiamondID = T.DiamondID
                )
                AND T.ranking < 2;

/******************************************************************************************************************/

					--Get Status for Address Update

       
        SELECT DISTINCT
                T.DiamondID ,
                T.DataLogRecordId ,
                T.AddressChangeStatus ,
                T.RequiredAction
        FROM    ( SELECT DISTINCT
                            P.DiamProvID AS DiamondID ,
                            DLR.DataLogRecordId ,
                            DLR.ChangeStatus AS AddressChangeStatus ,
                            CASE WHEN DLR.ChangeStatus IN ( 'Pending',
                                                            'Completed' )
                                 THEN CAST( 0 AS BIT)
                                 ELSE CAST(1 AS BIT)
                            END AS RequiredAction ,
                            DLR.CreationTimestamp ,
                            ROW_NUMBER() OVER ( PARTITION BY DiamondID ORDER BY CreationTimestamp DESC ) AS ranking
                  FROM      search.Provider AS P WITH ( NOLOCK )
                            JOIN search.Address AS A WITH ( NOLOCK ) ON A.ProviderID = P.ProviderID
                            JOIN @providerSDirectory AS PD ON PD.DiamondID = P.DiamProvID
                            LEFT JOIN changed.DataLogRecord AS DLR WITH ( NOLOCK ) ON DLR.TablePKFieldValue = A.AddressID
                                                              AND DLR.TableName = 'Search.Address'
                                                              AND DATEDIFF(MONTH,
                                                              DLR.CreationTimestamp,
                                                              GETDATE()) <= @MonthsRange
                ) T
        WHERE   ( ISNULL(@DiamondID, '') = ''
                  OR @DiamondID = T.DiamondID
                )
                AND T.ranking < 2;
/******************************************************************************************************************/

    END;

GO
/****** Object:  StoredProcedure [changed].[GetDataLogList]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [changed].[GetDataLogList]   
@DataLogRecordId int 
AS
BEGIN
	
	SET NOCOUNT ON
	
	SELECT [DataLogId],[DataLogRecordId],[TableName],[TablePKFiedName],[TablePKFieldValue],[ChangedFieldName],[ChangedOldValue],[ChangedNewValue]
			,[ModifiedBy],[LogType],[ChangedDataSource],[CreationTimestamp]
	FROM [changed].[DataLog] WITH (NOLOCK)
	WHERE [DataLogRecordId] = @DataLogRecordId
	
END


GO
/****** Object:  StoredProcedure [changed].[GetDataLogTableAndColumnSettingList]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [changed].[GetDataLogTableAndColumnSettingList]    
AS
BEGIN
	
	SET NOCOUNT ON
	
	SELECT [DataLogTableSettingId],[TableName],[TablePkFieldName],[IsActive],[CreationTimestamp]
	FROM [changed].[DataLogTableSetting] WITH (NOLOCK)
	WHERE [IsActive] = 1

	SELECT  [DataLogColumnSettingId],[DataLogTableSettingId],[FieldName],[IsManualUpdate],[IsActive]
	,[CreationTimestamp],ISNULL([DatabaseFieldName],[FieldName]) AS DatabaseFieldName 
	FROM [changed].[DataLogColumnSetting]  WITH (NOLOCK)
	WHERE [IsActive] = 1

	SELECT [DataLogColumnConditionSettingId],[DataLogTableSettingId],[FieldName],[MatchedValue],[IsActive]
	,[CreationTimestamp]
	FROM [changed].[DataLogColumnConditionSetting] WITH (NOLOCK)
	WHERE [IsActive] = 1
END




GO
/****** Object:  StoredProcedure [changed].[GetDirectoryUpdateMetrics]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [changed].[GetDirectoryUpdateMetrics]
    
AS
    BEGIN 
        SET NOCOUNT ON; 

			
--/********************************************************************************
--Get #pilotScope
--********************************************************************************/


IF OBJECT_ID('tempdb.dbo.#pilotScope', 'U') IS NOT NULL BEGIN DROP TABLE #pilotScope END
	IF OBJECT_ID('tempdb.dbo.#metrics', 'U') IS NOT NULL 
		BEGIN DROP TABLE #metrics END
	

CREATE TABLE #pilotScope ( DiamondID VARCHAR(12) , DirectoryID VARCHAR(12) NULL, LocationId INT, FaxLastFour VARCHAR(4), NetDevId int )

INSERT  INTO #pilotScope ( DiamondID, DirectoryID, LocationId, FaxLastFour )
VALUES  ( '000000000133', '08519-1633', 8519,'1633'),
        ( '000000000140', '00056-6828',00056,'6828' ),
        ( '000000000149', '03177-9940',03177,'9940' ),
        ( '000000000150', '01471-2734',01471,'2734' ),
        ( '000000000160', '00832-4042',00832,'4042' ),
        ( '000000000168', '01510-4763',01510,'4763' ),
        ( '000000000173', '01557-2508',01557,'2508' ),
        ( '000000000196', '08052-0000',08052,'0000' ),
        ( '000000000204', '00476-9365',00476,'9365' ),
        ( '000000000209', '07336-1299',07336,'1299' ),
        ( '000000000230', '08285-1172',08285,'1172' ),
        ( '000000000252', '07536-6231',07536,'6231' ),
        ( '000000000302', '05647-4241',05647,'4241' ),
        ( '000000000303', '00694-5087',00694,'5087' ),
        ( '000000000306', '01835-0433',01835,'0433' ),
        ( '000000000312', '07796-4485',07796,'4485' ),
        ( '000000000320', '00552-5250',00552,'5250' ),
        ( '000000000325', '00348-1155',00348,'1155' ),
        ( '000000000329', '05784-8589',05784,'8589' ),
        ( '000000000336', '00565-1098',00565,'1098' ),
        ( '000000000360', '01625-2527',01625,'2527' ),
        ( '000000000362', '00489-3123',00489,'3123' ),
        ( '000000000368', '00816-4038',00816,'4038' ),
        ( '000000000369', '02106-8101',02106,'8101' ),
        ( '000000000376', '00346-5948',00346,'5948' ),
        ( '000000000383', '01759-6122',01759,'6122' ),
        ( '000000000397', '00046-2886',00046,'2886' ),
        ( '000000000399', '01643-7828',01643,'7828' ),
        ( '000000000403', '04236-5713',04236,'5713' ),
        ( '000000000407', '01045-7379',01045,'7379' ),
        ( '000000000420', '01745-6699',01745,'6699' ),
        ( '000000000424', '01767-0393',01767,'0393' ),
        ( '000000000427', '01746-9795',01746,'9795' ),
        ( '000000000450', '00655-0445',00655,'0445' ),
        ( '000000000459', '00383-2749',00383,'2749' ),
        ( '000000000481', '05356-0918',05356,'0918' ),
        ( '000000000483', '00578-2495',00578,'2495' ),
        ( '000000000484', '00347-6383',00347,'6383' ),
        ( '000000000488', '05751-5905',05751,'5905' ),
        ( '000000000489', '01170-8050',01170,'8050' ),
        ( '000000000493', '01874-0305',01874,'0305' ),
        ( '000000000508', '00654-7430',00654,'7430' ),
        ( '000000000520', '00924-1892',00924,'1892' ),
        ( '000000000525', '01991-6228',01991,'6228' ),
        ( '000000000527', '01830-2289',01830,'2289' ),
        ( '000000000529', '06860-3339',06860,'3339' ),
        ( '000000000532', '01296-3358',01296,'3358' ),
        ( '000000000553', '00234-8894',00234,'8894' ),
        ( '000000000565', '06802-5495',06802,'5495' ),
        ( '000000000572', '04574-1372',04574,'1372' ),
        ( '000000000576', '00233-9115',00233,'9115' ),
        ( '000000000583', '00693-3009',00693,'3009' ),
        ( '000000000597', '01970-3315',01970,'3315' ),
        ( '000000000625', '09529-3377',09529,'3377' ),
        ( '000000000628', '00517-1696',00517,'1696' ),
        ( '000000000632', '00356-1514',00356,'1514' ),
        ( '000000000637', '01885-5282',01885,'5282' ),
        ( '000000000653', '01810-5930',01810,'5930' ),
        ( '000000000657', '00411-3163',00411,'3163' ),
        ( '000000000659', '01012-7562',01012,'7562' ),
        ( '000000000666', '04281-8709',04281,'8709' ),
        ( '000000000667', '09583-2509',09583,'2509' ),
        ( '000000000669', '08102-2035',08102,'2035' ),
        ( '000000000718', '01669-8656',01669,'8656' ),
        ( '000000000736', '03861-2916',03861,'2916' ),
        ( '000000000742', '04687-0011',04687,'0011' ),
        ( '000000000746', '05633-0143',05633,'0143' ),
        ( '000000000754', '04250-1403',04250,'1403' ),
        ( '000000000755', '00025-0501',00025,'0501' ),
        ( '000000000773', '01867-0287',01867,'0287' ),
        ( '000000000775', '07726-7297',07726,'7297' ),
        ( '000000000787', '00023-9107',00023,'9107' ),
        ( '000000000800', '00274-2792',00274,'2792' ),
        ( '000000000824', '04815-7688',04815,'7688' ),
        ( '000000000829', '04815-7688',04815,'7688' ),
        ( '000000000834', '00794-6167',00794,'6167' ),
        ( '000000000837', '00764-3911',00764,'3911' ),
        ( '000000000838', '00773-0958',00773,'0958' ),
        ( '000000000865', '01133-0422',01133,'0422' ),
        ( '000000000872', '03738-6220',03738,'6220' ),
        ( '000000000879', '04725-2480',04725,'2480' ),
        ( '000000000881', '00723-0067',00723,'0067' ),
        ( '000000000883', '06753-5800',06753,'5800' ),
        ( '000000000886', '04449-1201',04449,'1201' ),
        ( '000000000892', '01975-3396',01975,'3396' ),
        ( '000000000893', '04767-4155',04767,'4155' ),
        ( '000000000894', '06777-9707',06777,'9707' ),
        ( '000000000906', '01528-5226',01528,'5226' ),
        ( '000000000907', '09107-5781',09107,'5781' ),
        ( '000000000910', '05784-8589',05784,'8589' ),
        ( '000000000914', '00004-4491',00004,'4491' ),
        ( '000000000928', '00505-1069',00505,'1069' ),
        ( '000000000956', '00339-9644',00339,'9644' ),
        ( '000000000971', '01176-7844',01176,'7844' ),
        ( '000000000979', '00332-1227',00332,'1227' ),
        ( '000000000984', '01795-0125',01795,'0125' ),
        ( '000000000992', '00404-6319',00404,'6319' ),
        ( '000000000994', '06899-7785',06899,'7785' ),
        ( '000000001019', '00329-3300',00329,'3300' ),
        ( '000000001024', '00304-5158',00304,'5158' ),
        ( '000000001034', '01993-5499',01993,'5499' ),
        ( '000000001038', '01601-5736',01601,'5736' ),
        ( '000000001047', '07365-4828',07365,'4828' ),
        ( '000000001051', '08442-2906',08442,'2906' ),
        ( '000000001065', '01973-9483',01973,'9483' ),
        ( '000000001082', '01738-7330',01738,'7330' ),
        ( '000000001086', '02858-1598',02858,'1598' ),
        ( '000000001091', '02862-0995',02862,'0995' ),
        ( '000000001103', '02108-1873',02108,'1873' ),
        ( '000000001115', '09332-9788',09332,'9788' ),
        ( '000000001126', '01657-6789',01657,'6789' ),
        ( '000000001142', '06549-6192',06549,'6192' ),
        ( '000000001149', '08790-2782',08790,'2782' ),
        ( '000000001152', '04425-7773',04425,'7773' ),
        ( '000000001158', '02826-9057',02826,'9057' ),
        ( '000000001165', '05708-5387',05708,'5387' ),
        ( '000000001167', '01548-9544',01548,'9544' ),
        ( '000000001176', '08930-5595',08930,'5595' ),
        ( '000000001177', '00887-8451',00887,'8451' ),
        ( '000000001178', '08083-9888',08083,'9888' ),
        ( '000000001202', '01886-9520',01886,'9520' ),
        ( '000000001208', '03805-3872',03805,'3872' ),
        ( '000000001218', '07758-1580',07758,'1580' ),
        ( '000000001248', '01515-0187',01515,'0187' ),
        ( '000000001305', '07919-3920',07919,'3920' ),
        ( '000000001648', '00413-8262',00413,'8262' ),
        ( '000000001651', '01754-9154',01754,'9154' ),
        ( '000000001653', '05205-9002',05205,'9002' ),
        ( '000000001669', '05214-6789',05214,'6789' ),
        ( '000000001670', '00966-5652',00966,'5652' ),
        ( '000000001674', '00835-1024',00835,'1024' ),
        ( '000000001698', '00608-7050',00608,'7050' ),
        ( '000000001703', '01175-2727',01175,'2727' ),
        ( '000000001708', '05416-5002',05416,'5002' ),
        ( '000000001759', '01093-0310',01093,'0310' ),
        ( '000000001768', '00236-5771',00236,'5771' ),
        ( '000000001937', '07696-0897',07696,'0897' ),
        ( '000000002052', '01239-2202',01239,'2202' ),
        ( '000000002226', '00010-0907',00010,'0907' ),
        ( '000000002554', '00361-2056',00361,'2056' ),
        ( '000000002614', '01738-7330',01738,'7330' ),
        ( '000000002810', '01334-3289',01334,'3289' ),
        ( '000000003119', '08103-3336',08103,'3336' ),
        ( '000000003153', '10180-4705',10180,'4705' ),
        ( '000000003725', '01318-1438',01318,'1438' ),
        ( '000000003752', '04414-3288',04414,'3288' ),
        ( '000000003763', '01146-6991',01146,'6991' ),
        ( '000000003870', '07588-2053',07588,'2053' ),
        ( '000000003920', '07675-3980',07675,'3980' ),
        ( '000000003938', '00856-3825',00856,'3825' ),
        ( '000000003944', '04158-1510',04158,'1510' ),
        ( '000000004010', '01477-8440',01477,'8440' ),
        ( '000000004046', '03786-3387',03786,'3387' ),
        ( '000000004104', '00832-4042',00832,'4042' ),
        ( '000000004201', '05962-9620',05962,'9620' ),
        ( '000000004242', '08760-8103',08760,'8103' ),
        ( '000000004278', '03809-1166',03809,'1166' ),
        ( '000000004286', '04454-2030',04454,'2030' ),
        ( '000000004380', '00228-5134',00228,'5134' ),
        ( '000000004480', '01260-6462',01260,'6462' ),
        ( '000000004482', '08098-5103',08098,'5103' ),
        ( '000000004530', '01318-1438',01318,'1438' ),
        ( '000000005085', '02825-3387',02825,'3387' ),
        ( '000000005174', '07534-1220',07534,'1220' ),
        ( '000000005260', '01642-3330',01642,'3330' ),
        ( '000000005319', '00728-0826',00728,'0826' ),
        ( '000000005589', '07103-8649',07103,'8649' ),
        ( '000000005850', '02051-2394',02051,'2394' ),
        ( '000000005907', '01455-5006',01455,'5006' ),
        ( '000000005909', '01833-1600',01833,'1600' ),
        ( '000000006065', '09192-3785',09192,'3785' ),
        ( '000000006400', '00230-1558',00230,'1558' ),
        ( '000000006709', '00050-7905',00050,'7905' ),
        ( '000000006814', '09219-0080',09219,'0080' ),
        ( '000000006834', '00373-9003',00373,'9003' ),
        ( '000000006860', '01994-0308',01994,'0308' ),
        ( '000000007060', '00728-0826',00728,'0826' ),
        ( '000000007273', '00363-1499',00363,'1499' ),
        ( '000000007277', '02030-0144',02030,'0144' ),
        ( '000000007338', '07280-3766',07280,'3766' ),
        ( '000000007405', '05207-0388',05207,'0388' ),
        ( '000000007529', '00444-5565',00444,'5565' ),
        ( '000000007937', '07252-4441',07252,'4441' ),
        ( '000000007938', '01755-8096',01755,'8096' ),
        ( '000000008676', '00365-8803',00365,'8803' ),
        ( '000000008709', '01818-0430',01818,'0430' ),
        ( '000000008787', '05805-2296',05805,'2296' ),
        ( '000000009111', '07676-8969',07676,'8969' ),
        ( '000000009176', '07173-9478',07173,'9478' ),
        ( '000000009177', '00919-4435',00919,'4435' ),
        ( '000000009179', '07666-6812',07666,'6812' ),
        ( '000000009274', '09113-1960',09113,'1960' ),
        ( '000000009305', '09805-2277',09805,'2277' ),
        ( '000000009705', '00030-1389',00030,'1389' ),
        ( '000000009851', '06752-9761',06752,'9761' ),
        ( '000000009889', '08402-0907',08402,'0907' ),
        ( '000000010142', '01818-0430',01818,'0430' ),
        ( '000000010278', '07810-4098',07810,'4098' ),
        ( '000000010394', '07689-8406',07689,'8406' ),
        ( '000000010442', '00790-3470',00790,'3470' ),
        ( '000000010485', '00878-7851',00878,'7851' ),
        ( '000000010554', '00002-4657',00002,'4657' ),
        ( '000000010561', '00036-8943',00036,'8943' ),
        ( '000000010706', '00452-2154',00452,'2154' ),
        ( '000000010878', '00267-8675',00267,'8675' ),
        ( '000000010898', '07701-2315',07701,'2315' ),
        ( '000000011263', '08985-7290',08985,'7290' ),
        ( '000000011409', '07764-0255',07764,'0255' ),
        ( '000000011565', '01160-9439',01160,'9439' ),
        ( '000000011736', '01689-8760',01689,'8760' ),
        ( '000000011741', '01992-4577',01992,'4577' ),
        ( '000000011799', '04083-3833',04083,'3833' ),
        ( '000000011869', '00030-1389',00030,'1389' ),
        ( '000000012166', '02609-7218',02609,'7218' ),
        ( '000000012168', '02104-5801',02104,'5801' ),
        ( '000000012169', '01807-9194',01807,'9194' ),
        ( '000000012171', '03832-8558',03832,'8558' ),
        ( '000000012265', '06199-0920',06199,'0920' ),
        ( '000000012382', '08400-6846',08400,'6846' ),
        ( '000000012428', '07919-3920',07919,'3920' ),
        ( '000000012464', '01038-8589',01038,'8589' ),
        ( '000000012669', '06255-2547',06255,'2547' ),
        ( '000000012748', '03647-0522',03647,'0522' ),
        ( '000000012988', '09132-6019',09132,'6019' ),
        ( '000000013264', '08790-2782',08790,'2782' ),
        ( '000000013867', '04179-4514',04179,'4514' ),
        ( '000000013921', '06248-8240',06248,'8240' ),
        ( '000000013923', '04264-8573',04264,'8573' ),
        ( '000000013924', '05156-0237',05156,'0237' ),
        ( '000000013925', '00107-2443',00107,'2443' ),
        ( '000000013939', '04209-4897',04209,'4897' ),
        ( '000000013973', '04111-2361',04111,'2361' ),
        ( '000000014463', '05442-1880',05442,'1880' ),
        ( '000000014465', '06159-5878',06159,'5878' ),
        ( '000000014845', '05371-7831',05371,'7831' ),
        ( '000000014902', '09911-9025',09911,'9025' ),
        ( '000000014907', '01689-8760',01689,'8760' ),
        ( '000000014922', '05468-0616',05468,'0616' ),
        ( '000000014957', '04815-7688',04815,'7688' ),
        ( '000000014959', '08930-5595',08930,'5595' ),
        ( '000000014961', '06225-6132',06225,'6132' ),
        ( '000000014970', '02563-4563',02563,'4563' ),
        ( '000000014991', '04622-3611',04622,'3611' ),
        ( '000000015122', '04510-7765',04510,'7765' ),
        ( '000000015171', '09437-7780',09437,'7780' ),
        ( '000000015173', '02300-5295',02300,'5295' ),
        ( '000000015174', '01071-3570',01071,'3570' ),
        ( '000000015354', '00044-9966',00044,'9966' ),
        ( '000000015408', '07745-2105',07745,'2105' ),
        ( '000000015432', '02479-9998',02479,'9998' ),
        ( '000000015448', '04635-7409',04635,'7409' ),
        ( '000000015522', '07782-0760',07782,'0760' ),
        ( '000000015549', '06668-8640',06668,'8640' ),
        ( '000000015602', '01689-8760',01689,'8760' ),
        ( '000000015716', '01428-2962',01428,'2962' ),
        ( '000000015885', '06188-5147',06188,'5147' ),
        ( '000000016094', '01899-1087',01899,'1087' ),
        ( '000000016863', '00730-0606',00730,'0606' ),
        ( '000000016919', '01689-8760',01689,'8760' ),
        ( '000000016935', '07745-2105',07745,'2105' ),
        ( '000000017226', '07457-1132',07457,'1132' ),
        ( '000000017318', '00833-0459',00833,'0459' ),
        ( '000000017393', '06633-9988',06633,'9988' ),
        ( '000000017427', '06685-2066',06685,'2066' ),
        ( '000000017476', '05312-3785',05312,'3785' ),
        ( '000000017519', '06751-7980',06751,'7980' ),
        ( '000000017555', '07175-6626',07175,'6626' ),
        ( '000000017889', '05967-0523',05967,'0523' ),
        ( '000000017960', '05986-0563',05986,'0563' ),
        ( '000000017961', '06945-9394',06945,'9394' ),
        ( '000000017962', '00021-9400',00021,'9400' ),
        ( '000000018272', '00617-1029',00617,'1029' ),
        ( '000000018808', '07539-9922',07539,'9922' ),
        ( '000000018847', '07434-2343',07434,'2343' ),
        ( '000000018891', '09218-3016',09218,'3016' ),
        ( '000000019152', '07720-9119',07720,'9119' ),
        ( '000000019220', '03813-8150',03813,'8150' ),
        ( '000000019278', '01917-8012',01917,'8012' ),
        ( '000000019358', '08696-0365',08696,'0365' ),
        ( '000000019752', '07672-5840',07672,'5840' ),
        ( '000000019904', '07745-2105',07745,'2105' ),
        ( '000000020198', '04772-5686',04772,'5686' ),
        ( '000000020337', '07919-3920',07919,'3920' ),
        ( '000000020809', '05976-2756',05976,'2756' ),
        ( '000000022500', '01738-7330',01738,'7330' ),
        ( '000000030046', '08602-2544',08602,'2544' ),
        ( '000000030061', '01849-0199',01849,'0199' ),
        ( '000000030078', '02131-2008',02131,'2008' ),
        ( '000000030194', '04634-5687',04634,'5687' ),
        ( '000000030456', '08930-5595',08930,'5595' ),
        ( '000000030836', '07895-4719',07895,'4719' ),
        ( '000000030968', '00034-0527',00034,'0527' ),
        ( '000000030990', '00052-8193',00052,'8193' ),
        ( '000000031202', '06156-7911',06156,'7911' ),
        ( '000000031211', '09525-2769',09525,'2769' ),
        ( '000000031516', '01285-6443',01285,'6443' ),
        ( '000000031732', '09050-6146',09050,'6146' ),
        ( '000000033159', '04815-7688',04815,'7688' ),
        ( '000000033776', '03967-1973',03967,'1973' ),
        ( '000000033777', '03347-4599',03347,'4599' ),
        ( '000000033941', '08225-0500',08225,'0500' ),
        ( '000000034004', '07743-5029',07743,'5029' ),
        ( '000000034044', '09853-2739',09853,'2739' ),
        ( '000000034200', '09581-0700',09581,'0700' ),
        ( '000000034267', '01738-7330',01738,'7330' ),
        ( '000000034368', '09871-4420',09871,'4420' ),
        ( '000000034475', '07725-4689',07725,'4689' ),
        ( '000000034518', '06199-0920',06199,'0920' ),
        ( '000000035214', '08389-4462',08389,'4462' ),
        ( '000000035832', '01638-8155',01638,'8155' ),
        ( '000000035841', '00682-6223',00682,'6223' ),
        ( '000000035852', '09727-2065',09727,'2065' ),
        ( '000000035854', '08530-0499',08530,'0499' ),
        ( '000000035861', '08754-4710',08754,'4710' ),
        ( '000000035867', '08382-1122',08382,'1122' ),
        ( '000000036951', '01689-8760',01689,'8760' ),
        ( '000000037088', '02152-3447',02152,'3447' ),
        ( '000000037208', '06199-0920',06199,'0920' ),
        ( '000000037324', '01681-0084',01681,'0084' ),
        ( '000000037325', '01094-9766',01094,'9766' ),
        ( '000000037326', '01995-1346',01995,'1346' ),
        ( '000000037466', '06199-0920',06199,'0920' ),
        ( '000000037543', '06919-0122',06919,'0122' ),
        ( '000000037556', '00515-8994',00515,'8994' ),
        ( '000000037943', '01689-8760',01689,'8760' ),
        ( '000000038519', '00034-0527',00034,'0527' ),
        ( '000000038524', '06199-0920',06199,'0920' ),
        ( '000000039332', '01777-1333',01777,'1333' ),
        ( '000000040462', '03487-8810',03487,'8810' ),
        ( '000000043906', '06199-0920',06199,'0920' )

/**************************************************************************************************
Testing

SELECT V.PDP_DirectoryID, COUNT(1) FROM Network_Development.dbo.Tbl_ProviderDirectory_VerificationProvider V WITH(NOLOCK) JOIN #pilotScope scope ON V.PDP_DirectoryID = scope.DirectoryID GROUP BY V.PDP_DirectoryID  ORDER BY COUNT(1) DESC
		SELECT DISTINCT  V.PDP_ProviderID  FROM Network_Development.dbo.Tbl_ProviderDirectory_VerificationProvider V WITH(NOLOCK) JOIN #pilotScope scope ON V.PDP_DirectoryID = scope.DirectoryID								--714 distinct provider id's within #pilotScope
        SELECT DISTINCT  V.PDP_ProviderID, v.PDP_LocationID  FROM Network_Development.dbo.Tbl_ProviderDirectory_VerificationProvider V WITH(NOLOCK) JOIN #pilotScope scope ON V.PDP_DirectoryID = scope.DirectoryID				--748 distinct provider/location combos withing #pilotScope

		SELECT DISTINCT  V.PDL_DirectoryID, COUNT(1) FROM Network_Development.dbo.Tbl_ProviderDirectory_VerificationLocation V WITH(NOLOCK) JOIN #pilotScope scope ON V.PDL_DirectoryID = scope.DirectoryID GROUP BY V.PDL_DirectoryID ORDER BY COUNT(1) DESC --300 distinct DirectoryId's 
		SELECT DISTINCT  V.PDL_LocationID, COUNT(1) FROM Network_Development.dbo.Tbl_ProviderDirectory_VerificationLocation V WITH(NOLOCK) JOIN #pilotScope scope ON V.PDL_DirectoryID = scope.DirectoryID GROUP BY V.PDL_LocationID ORDER BY COUNT(1) DESC --300 distinct DirectoryId's 

		--Diamon Id's 
		SELECT * FROM Network_Development.dbo.Tbl_ProviderDirectory_VerificationLocation V WITH(NOLOCK) JOIN #pilotScope scope ON V.PDL_DirectoryID = scope.DirectoryID WHERE V.PDL_LocationID = 1689
		
		--Based on Verification Table

			SELECT distinct V.PDP_DirectoryID, V.PDP_ProviderID, V.PDP_LocationID FROM Network_Development.dbo.Tbl_ProviderDirectory_VerificationProvider V WITH(NOLOCK) JOIN #pilotScope scope ON V.PDP_DirectoryID = scope.DirectoryID   --748
			SELECT V.PDP_DirectoryID, V.PDP_ProviderID, V.PDP_LocationID FROM Network_Development.dbo.Tbl_ProviderDirectory_VerificationProvider V WITH(NOLOCK) JOIN #pilotScope scope ON V.PDP_DirectoryID = scope.DirectoryID			--1196

		--Based on Search.Provider
			
			SELECT V.PDP_DirectoryID, V.PDP_ProviderID, V.PDP_LocationID, V.PDP_FaxNumber FROM search.Provider P WITH(NOLOCK) JOIN #pilotScope scope ON P.NetDevProvID = scope.ProviderId			--1196

			
			

**************************************************************************************************/
		

-- Pilot Scope/Captured Providers

	DECLARE @pilotProviders TABLE ( ProviderId INT )
	INSERT INTO @pilotProviders ( ProviderId )
	SELECT distinct V.PDP_ProviderID FROM Network_Development.dbo.Tbl_ProviderDirectory_VerificationProvider V WITH(NOLOCK) JOIN #pilotScope scope ON V.PDP_DirectoryID = scope.DirectoryID
	--SELECT * FROM @pilotProviders

	DECLARE @capturedProviders TABLE ( PPI_ID int)
	INSERT INTO @capturedProviders ( PPI_ID )
	SELECT DISTINCT P.NetDevProvID FROM changed.DataLogRecord DLR WITH(NOLOCK) 
	JOIN search.Provider P WITH(NOLOCK) ON DLR.TablePKFieldValue = P.ProviderID
	WHERE DLR.ChangedDataSource = 'Directory Update' AND DLR.TableName = 'search.Provider'
	--SELECT * FROM @capturedProviders		
	-------------------------------------------------------------------------------------------------

			
-- Pilot Scope/Captured Locations
	DECLARE @pilotLocations TABLE (LocationId int)
	INSERT INTO @pilotLocations (LocationId )
	SELECT DISTINCT V.PDP_LocationID FROM Network_Development.dbo.Tbl_ProviderDirectory_VerificationProvider V WITH(NOLOCK) JOIN #pilotScope scope ON V.PDP_DirectoryID = scope.DirectoryID
	--SELECT * FROM @pilotLocations

	DECLARE @capturedLocations TABLE ( LocationId int)
	INSERT INTO @capturedLocations ( LocationId )
	SELECT DISTINCT A.LocationID FROM changed.DataLogRecord DLR WITH(NOLOCK) 
	JOIN search.Address A WITH(NOLOCK) ON DLR.TablePKFieldValue = A.AddressId
	WHERE DLR.ChangedDataSource = 'Directory Update' AND DLR.TableName = 'search.Address'
	--SELECT * FROM @capturedLocations
	-------------------------------------------------------------------------------------------------

-- Pilot Scope/Captured Provider/Location
	DECLARE @pilotProviderLocations TABLE (ProviderId INT, LocationId int)
	INSERT INTO @pilotProviderLocations ( ProviderId, LocationId )
	SELECT distinct V.PDP_ProviderID, V.PDP_LocationID FROM Network_Development.dbo.Tbl_ProviderDirectory_VerificationProvider V WITH(NOLOCK) JOIN #pilotScope scope ON V.PDP_DirectoryID = scope.DirectoryID
	--SELECT * FROM @pilotProviderLocations

	DECLARE @capturedProviderLocations TABLE ( PPI_ID INT, LocationId INT)
	INSERT INTO @capturedProviderLocations ( PPI_ID, LocationId)
		SELECT DISTINCT 
		ProviderId = DLR.NewXmlObject.value('(/Provider/NetDevProviderId)[1]', 'int'),
		LocationId = DLR.NewXmlObject.value('(/Provider/Addresses/Address/LocationId)[1]', 'int')
	FROM changed.DataLogRecord DLR WITH(NOLOCK) 
	WHERE DLR.ChangedDataSource = 'Directory Update' AND DLR.TableName = 'search.Provider' 
	--SELECT * FROM @capturedProviderLocations

	--Pilot Scope/Captured Completion Map

	DECLARE @ScopeCaptureMap TABLE (ScopeProvider int, ScopeLocation int, CapturedProvider int, CapturedLocation int)
	INSERT INTO @ScopeCaptureMap (ScopeProvider, ScopeLocation, CapturedProvider, CapturedLocation)
	SELECT scope.ProviderId, scope.LocationId, captured.PPI_ID, captured.LocationId FROM @pilotProviderLocations  scope
	LEFT JOIN @capturedProviderLocations captured 
	ON captured.PPI_ID = scope.ProviderId AND scope.LocationId = captured.LocationId
		
	DECLARE @ScopeTotal DECIMAL(9,2), @CapturedTotal DECIMAL(9,2), @ScopeProviderTotal DECIMAL(9,2), @CapturedProviderTotal DECIMAL(9,2), @ScopeLocationTotal DECIMAL(9,2), @CapturedLocationTotal DECIMAL(9,2)
	
	SELECT @ScopeProviderTotal =	CONVERT(DECIMAL(9,2), COUNT(DISTINCT ScopeProvider)) FROM @ScopeCaptureMap
--	SELECT @CapturedProviderTotal = CONVERT(DECIMAL(9,2), COUNT(DISTINCT CapturedProvider)) FROM @ScopeCaptureMap 
	SELECT @CapturedProviderTotal = CONVERT(DECIMAL(9,2), COUNT(DISTINCT PPI_ID)) FROM @capturedProviders where PPI_ID is not null
	SELECT @ScopeLocationTotal =	CONVERT(DECIMAL(9,2), COUNT(DISTINCT ScopeLocation)) FROM @ScopeCaptureMap
--	SELECT @CapturedLocationTotal = CONVERT(DECIMAL(9,2), COUNT(DISTINCT CapturedLocation)) FROM @ScopeCaptureMap
	SELECT @CapturedLocationTotal = CONVERT(DECIMAL(9,2), COUNT(DISTINCT LocationID)) FROM @capturedLocations where LocationId is not null
	SELECT @ScopeTotal =			COUNT(1) FROM @ScopeCaptureMap
	SELECT @CapturedTotal =			COUNT(1) FROM @ScopeCaptureMap WHERE CapturedProvider IS NOT NULL AND CapturedLocation IS NOT NULL


	--SELECT 
	--	CONVERT(INT, @ScopeTotal) AS 'PilotScopeTotal',
	--	CONVERT(INT, @CapturedTotal) AS 'CapturedTotal', 
	--	CASE WHEN @CapturedTotal IS NOT NULL AND @CapturedTotal != 0 THEN CONVERT(VARCHAR,CONVERT(DECIMAL(9,2),   (@CapturedTotal / @ScopeTotal) * 100)) + '%' ELSE '0%' END AS 'CapturedPercentage',

	--	CONVERT(INT, @ScopeProviderTotal) AS 'ScopeProviderTotal',
	--	CONVERT(INT, @CapturedProviderTotal) AS 'CapturedProviderTotal', 
	--	CASE WHEN @CapturedProviderTotal IS NOT NULL AND @CapturedProviderTotal != 0 THEN CONVERT(VARCHAR,CONVERT(DECIMAL(9,2),   (@CapturedProviderTotal / @ScopeProviderTotal) * 100)) + '%' ELSE '0%' END AS 'CapturedProviderPercentage',
        
	--	CONVERT(INT, @ScopeLocationTotal) AS 'ScopeLocationTotal',
	--	CONVERT(INT, @CapturedLocationTotal) AS 'CapturedLocationTotal', 
	--	CASE WHEN @CapturedLocationTotal IS NOT NULL AND @CapturedLocationTotal != 0 THEN CONVERT(VARCHAR,CONVERT(DECIMAL(9,2),   (@CapturedLocationTotal / @ScopeLocationTotal) * 100)) + '%' ELSE '0%' END AS 'CapturedLocationPercentage'	


/***************************************************************************************************************************************************************************************************************************************/

	--Providers/Locations with and without changes
	Declare @capturedProvidersWithChanges TABLE (providerID int)
	Declare @capturedProvidersWithoutChanges TABLE (providerID int) 
	Declare @capturedLocationsWithChanges TABLE (LocationID int)
	 Declare @capturedLocationsWithoutChanges Table (LocationID int)
	 Declare @providersNotResponded TABLE (ProviderID int)
	 Declare @LocationsNotResponded TABLE (LocationID int)
	 Declare @countProviderwithchanges int, @countProviderWithoutChanges int, @countLocationsWithChanges int, @countLocationsWithoutChanges int
	
	--Providers with changes
	INSERT INTO @capturedProvidersWithChanges 
	SELECT   distinct p.NetDevProvID as CapturedProvidersWithChanges from changed.DataLogRecord    as DLR with (nolock)
	Inner join changed.DataLog as DL with (nolock) on  DL.DataLogRecordId = DLR.DataLogRecordId and  DL.ChangedDataSource = 'Directory Update'
	Inner JOIN search.Provider P WITH(NOLOCK) ON DLR.TablePKFieldValue = P.ProviderID
	inner join @capturedProviders CLP on CLP.PPI_ID = p.NetDevProvID
	where DLR.ChangedDataSource = 'Directory Update'  and DLR.TableName = 'search.Provider'  
	and CLP.PPI_ID is not null

	
	--Locations with changes
	INSERT INTO @capturedLocationsWithChanges
	Select a.LocationID  from Search.Address as A with (nolock) 
	join @capturedLocations as P on p.LocationId = a.LocationID
	Join changed.DataLogRecord as DLR with (nolock) on A.AddressID = dlr.TablePKFieldValue and dlr.TableName = 'search.address' and dlr.ChangedDataSource = 'Directory Update'
	join changed.DataLog as DL with (nolock) on DL.DataLogRecordId = dlr.DataLogRecordId and dl.TableName = 'search.Address' and dl.ChangedDataSource = 'Directory Update' and a.AddressID = dl.TablePKFieldValue
	where p.LocationId is not null
	
	
	--Providers without changes
	INSERT INTO @capturedProvidersWithoutChanges
	Select distinct CP.PPI_ID 
	from @capturedProviders CP where Cp.PPI_ID not in (select distinct ProviderID from @capturedProvidersWithChanges)
	and CP.PPI_ID is not null


	--Locations without changes
	INSERT INTO @capturedLocationsWithoutChanges 
	select distinct LocationId 
	from @capturedLocations  CL where CL.LocationId not in (select distinct LocationID from @capturedLocationsWithChanges)


	Select @countProviderwithchanges = count( distinct providerID) from @capturedProvidersWithChanges 
	Select @countProviderwithoutchanges = count( distinct providerID) from @capturedProvidersWithoutChanges 
	Select @countLocationsWithChanges = count(distinct LocationID) from @capturedLocationsWithChanges 
	Select @countLocationsWithoutChanges = count(distinct LocationID) from @capturedLocationsWithoutChanges 

/***************************************************************************************************************************************************************************************************************************************/
	
	SELECT 
		CONVERT(INT, @ScopeTotal) AS 'PilotScopeTotal',
		CONVERT(INT, @CapturedTotal) AS 'CapturedTotal', 
		CASE WHEN @CapturedTotal IS NOT NULL AND @CapturedTotal != 0 THEN CONVERT(VARCHAR,CONVERT(DECIMAL(9,2),   (@CapturedTotal / @ScopeTotal) * 100)) + '%' ELSE '0%' END AS 'CapturedPercentage',

		CONVERT(INT, @ScopeProviderTotal) AS 'ScopeProviderTotal',
		CONVERT(INT, @CapturedProviderTotal) AS 'CapturedProviderTotal', 
		CASE WHEN @CapturedProviderTotal IS NOT NULL AND @CapturedProviderTotal != 0 THEN CONVERT(VARCHAR,CONVERT(DECIMAL(9,2),   (@CapturedProviderTotal / @ScopeProviderTotal) * 100)) + '%' ELSE '0%' END AS 'CapturedProviderPercentage',

		@countProviderwithchanges AS 'CapturedProviderWithChanges',
		@countProviderwithoutchanges AS 'CapturedProviderWithoutChanges',
        
		CONVERT(INT, @ScopeLocationTotal) AS 'ScopeLocationTotal',
		CONVERT(INT, @CapturedLocationTotal) AS 'CapturedLocationTotal', 
		CASE WHEN @CapturedLocationTotal IS NOT NULL AND @CapturedLocationTotal != 0 THEN CONVERT(VARCHAR,CONVERT(DECIMAL(9,2),   (@CapturedLocationTotal / @ScopeLocationTotal) * 100)) + '%' ELSE '0%' END AS 'CapturedLocationPercentage',
		

		@countLocationsWithChanges AS 'CapturedLocationsWithChanges',
		@countLocationsWithoutChanges AS 'CapturedLocationsWithoutChanges' 

		into #metrics


/***************************************************************************************************************************************************************************************************************************************/
	Insert into @providersNotResponded
	Select distinct ProviderId from @pilotProviders where providerID not in (select distinct PPI_ID from @capturedProviders where PPI_ID is not null )

	
	Insert into @LocationsNotResponded
	Select distinct s.LocationId from @pilotLocations S
	where s.LocationId not in (select distinct LocationId from @capturedLocations where LocationId is not null)

/***************************************************************************************************************************************************************************************************************************************/
		--Get metrics
		Select * from #metrics




		--Get details of providers who had not responded at all
				select Distinct CLNS_LocationID as LocationId, Cast(PPI.PPI_ID as Varchar(5)) as NetDevProviderId, PPI_FirstName as FirstName , PPI_LastName as LastName, PPG_Gender  as Gender , PPI_License as License, PPI_UPIN as NPI, CLNS_Phone as Phone
		from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
		join @providersNotResponded CP on CP.providerID = PPI.PPI_ID
		Join Network_Development.dbo.Tbl_Provider_ProviderGender as PG with (nolock) on PG.PPG_ID = PPI.PPI_Gender
		Join Network_Development.dbo.Tbl_Contract_LocationsNumbers as CLNS with (nolock) on clns.CLNS_ProviderID = CP.ProviderID 
		join @LocationsNotResponded as L on l.LocationID = CLNS_LocationID
		Order by PPI_FirstName



		--Get Locations without any response
		Select Distinct 
		Cast(CL.CL_ID as varchar(5)) as LocationID, CL.CL_Address as Street, CL.CL_City as City, CL.CL_ZIp as zip, G.OGR_County as County from 
		Network_Development.dbo.tbl_COntract_Locations as CL 
		join Network_Development.dbo.Tbl_Codes_CountyGeoRegions as G with (nolock) on G.OGR_CountyCode = CL.CL_CountyCode
		join @LocationsNotResponded as CP on CP.LocationID = CL_ID



		
	IF OBJECT_ID('tempdb.dbo.#pilotScope', 'U') IS NOT NULL BEGIN DROP TABLE #pilotScope END
	IF OBJECT_ID('tempdb.dbo.#metrics', 'U') IS NOT NULL 
		BEGIN DROP TABLE #metrics END
	
	 
	 END


GO
/****** Object:  StoredProcedure [changed].[GetEthnicityForDropDown]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [changed].[GetEthnicityForDropDown] 
					
	
AS 
  BEGIN 
      SET nocount ON 


	SELECT DBLV_Value AS Ethnicity FROM Network_Development.dbo.Tbl_Database_ListValues WITH (nolock) WHERE DBLV_List = 73 ORDER BY DBLV_Value


END

GO
/****** Object:  StoredProcedure [changed].[GetExtraFieldstoUpdateDirectory]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [changed].[GetExtraFieldstoUpdateDirectory]
	 @ProviderID int
AS
BEGIN
	
		  /*
			Modification Log:
				12/19/2016		SS		Added result set to get BH area of expertise
				12/19/2016		SS		Added ProviderEmail ID in result set

			
		*/

	SET NOCOUNT ON
/****************************************************************************************************************************************/

								--Declare Local Variables
Declare @AddressIds table
(
	AddressID int not null
)

Declare @AffiliationIds table
(
	AddressID int not null
)

Insert into @AddressIds 
Select distinct AddressID from search.Address as a with (nolock) where a.ProviderID = @ProviderID

Insert into @AffiliationIds 
Select distinct AffiliationID from search.Address as a with (nolock)
inner join search.Affiliation as F with (nolock) on a.AddressID = f.AddressID and f.ProviderID = @ProviderID

/****************************************************************************************************************************************/
										--Select extra fields
Select distinct
		P.ProviderID as ProviderID,
		PPI_MediCareID as MediCareID,
		PPI_MediCalId as MediCalID,
		Case when PPI_CCS = 1 then CAST(1 AS BIT) else CAST(0 AS BIT) end as CCS,
		Case when PPI.PPI_Ethnicity = LV.DBLV_Abbreviation then LV.DBLV_Value end as Ethinicity,
		PDRI_Software as Software,
		Case when PDRI_Eprescribe = -1 then CAST(1 AS BIT) else CAST(0 AS BIT) end as Eprescribe,
		PPI.PPI_Email as ProviderEmail	

From search.Provider as p with (nolock)
Join search.Address as a with  (nolock) on a.ProviderID = p.ProviderID
join Network_Development.dbo.tbl_provider_Providerinfo as PPI with (nolock) on PPI.PPI_ID = p.netdevprovid
left join Network_Development.dbo.Tbl_Provider_DrugRegistrationInfo as PDRI with (nolock) on PDRI.PDRI_ProviderID = P.NetDevProvID
left join Network_Development.dbo.Tbl_Database_ListValues as LV with (nolock) on PPI.PPI_Ethnicity = LV.DBLV_Abbreviation and LV.dblv_List = 73
where P.ProviderID = @ProviderID

/****************************************************************************************************************************************/

Select distinct 
		P.ProviderID as ProviderID,	
		A.AddressID as AddressID,
		A.LocationID as LocationID,
		Case when CL.CL_EMRSystem = LV.DBLV_ID then LV.DBLV_Value end as EmrSystem,									--LocationOnly
		Case when CL.CL_EMR IN(-1,'-1')  then CAST(1 AS BIT) else CAST(0 AS BIT) end as EMR,							
		Cl.CL_OfficeManager as OfficeManager, 
		Cl.CL_ReferralFax as ReferralFax,
		CL.CL_NPI as groupNPI,
		Case when PPC.PPC_ProviderID = PPI.PPI_ID then (PPI.PPI_LastName + ', ' + PPI.PPI_FirstName + ' ' + PPI.PPI_MiddleName) end  as Supervisor

From search.provider as P with (nolock)
join search.Address as a with  (nolock)  on A.ProviderID = p.ProviderID
join Network_Development.dbo.Tbl_Contract_Locations as CL with (nolock) on CL.CL_ID = a.LocationID
left join Network_Development.dbo.Tbl_Provider_ProviderCoverage as PPC with (nolock) on PPC.PPC_ProviderID = p.NetDevProvID and PPc.PPC_LocationID = a.LocationID
left join Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock) on PPI.PPI_ID = P.NetDevProvID
left join Network_Development.dbo.Tbl_Database_ListValues as LV with (nolock)  on LV.DBLV_List = 71 and LV.DBLV_ID = CL_EMRSystem
where a.AddressID in (select * from @AddressIds)




/****************************************************************************************************************************************/




											--Get BH area of Expertise
Select distinct
		P.ProviderID as ProviderID,
		LV.DBLV_Value as BhAreaOfExpertise

From search.Provider as p with (nolock)
Join search.Address as a with  (nolock) on a.ProviderID = p.ProviderID
join Network_Development.dbo.tbl_provider_Providerinfo as PPI with (nolock) on PPI.PPI_ID = p.netdevprovid
join Network_Development.dbo.Tbl_Provider_ProviderSpecialtiesExpertise  PSE with (nolock) on PSE.PSPE_ProviderID = PPI.PPI_ID
Inner join Network_Development.dbo.Tbl_Database_ListValues as LV with (nolock) on  LV.dblv_List = 37 and PSE.PSPE_Area = LV.DBLV_ID
where P.ProviderID = @ProviderID and P.ProviderType = 'BH'





	   

END
	


GO
/****** Object:  StoredProcedure [changed].[GetHospitalsforDropDown]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [changed].[GetHospitalsforDropDown] 
					
	
AS 
  BEGIN 
      SET nocount ON 

	  select distinct HospitalName from search.Affiliation a with (nolock) where a.ProviderType in ('PCP','MPCP','NPCP','NPP','VSN','BH','SPEC','ANC') 
and ISNULL(a.HospitalName,'') <> '' order by HospitalName

END

GO
/****** Object:  StoredProcedure [changed].[GetIPAforDropDown]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [changed].[GetIPAforDropDown] 
					
	
AS 
  BEGIN 
      SET nocount ON 


	  select distinct Case when  IPANAMe = 'Inland Empire Health Plan' THen IPAPAREntCOde else IPACODe end as IPACode,IPAName from search.Affiliation a with (nolock) where a.ProviderType in ('PCP','MPCP','NPCP','NPP','VSN','BH','SPEC','ANC') 
and ISNULL(a.IPAName,'') <> '' order by IPANAMe

END

GO
/****** Object:  StoredProcedure [changed].[GetPendingStatus]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rodolfo Gutierrez
-- Create date: 01/17/2017
-- Description:	Gets list of issues that have a status of Pending 
--				in Workfront  
-- =============================================
CREATE PROCEDURE [changed].[GetPendingStatus]
	-- Add the parameters for the stored procedure here
    @ShowVersion BIT = 0
AS
    BEGIN TRY
        DECLARE @Version VARCHAR(100) = '01/17/2017 10:06 AM Version 1.0';
      
        IF @ShowVersion = 1
            BEGIN
                SELECT  OBJECT_SCHEMA_NAME(@@PROCID) AS SchemaName ,
                        OBJECT_NAME(@@PROCID) AS ProcedureName ,
                        @Version AS VersionInformation;
                RETURN 0;
            END; 
        SET NOCOUNT ON;

        BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
            SET NOCOUNT ON;

            SELECT DISTINCT
                    ( DataLogRecordId ) ,
                    CrossReferenceSystemValue ,
                    ChangeStatus
            FROM    ProviderSearchCore.changed.DataLogRecord
            WHERE   ChangeStatus = 'Pending';

        END;

    END TRY 

    BEGIN CATCH 
        DECLARE @ErrorMessage VARCHAR(4000) ,
            @ErrorSeverity INT ,
            @ErrorState INT; 

        SET @ErrorMessage = ERROR_MESSAGE(); 
        SET @ErrorSeverity = ERROR_SEVERITY(); 
        SET @ErrorState = ERROR_STATE(); 
        RAISERROR(@ErrorMessage,@ErrorSeverity,@ErrorState); 
    END CATCH; 
GO
/****** Object:  StoredProcedure [changed].[GetProvidersByTaxID]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [changed].[GetProvidersByTaxID]
    @TaxID VARCHAR(9) ,
    @LocationID INT = NULL ,
    @ExpirationMonths INT = 3
AS
    BEGIN 
        SET NOCOUNT ON; 

	  /*
			Modification Log:
				12/7/2016		SS		Fixed issue to return provider only with address
				12/9/2016		SS		Renamed Parameter @AddressID to @LocationID.
				12/13/2016		SS		Added CrossReferenceSystemValue in Result Set
				12/13/2016		SS		Filtered providerType provided by QA (Bindu)
				12/13/2016		SS		Added filter to check termdate of COntract
				1/3/2017		SS		Added list to include only these providers
				1/3/2017		SS		Fixed bug related to Same provider with two DiamondIds (It was taking only one record but they can have different data so included both)
		*/


/**********************************************************************************************/
												--Declare Local Table Variables
        DECLARE @now DATE = GETDATE();
        DECLARE @ProviderTaxID TABLE
            (
              providerid VARCHAR(12) ,
              taxid VARCHAR(9)
            ); 
        DECLARE @ProviderDetails TABLE
            (
              providerid VARCHAR(12) ,
              firstname VARCHAR(100) NULL ,
              lastname VARCHAR(100) NULL ,
              organizationname VARCHAR(100) NULL ,
              npi VARCHAR(12) NULL ,
              providertype VARCHAR(20) NULL
            ); 

		DECLARE @GivenProviderIds TABLE(ProviderID INT );

        IF OBJECT_ID('tempdb..#ProviderDetails') IS NOT NULL
            DROP TABLE #ProviderDetails;
	
/**********************************************************************************************/

/**************************************************************************************************/
												--Inlclude Locations only
		
        DECLARE @providersDirectory TABLE
            (
              DiamondID VARCHAR(12) ,
              DirectoryID VARCHAR(12) NULL
            );
        INSERT  INTO @providersDirectory
                ( DiamondID, DirectoryID )
        VALUES  ( '000000000133', '08519-1633' ),
                ( '000000000140', '00056-6828' ),
                ( '000000000149', '03177-9940' ),
                ( '000000000150', '01471-2734' ),
                ( '000000000160', '00832-4042' ),
                ( '000000000168', '01510-4763' ),
                ( '000000000173', '01557-2508' ),
                ( '000000000196', '08052-0000' ),
                ( '000000000204', '00476-9365' ),
                ( '000000000209', '07336-1299' ),
                ( '000000000230', '08285-1172' ),
                ( '000000000252', '07536-6231' ),
                ( '000000000302', '05647-4241' ),
                ( '000000000303', '00694-5087' ),
                ( '000000000306', '01835-0433' ),
                ( '000000000312', '07796-4485' ),
                ( '000000000320', '00552-5250' ),
                ( '000000000325', '00348-1155' ),
                ( '000000000329', '05784-8589' ),
                ( '000000000336', '00565-1098' ),
                ( '000000000360', '01625-2527' ),
                ( '000000000362', '00489-3123' ),
                ( '000000000368', '00816-4038' ),
                ( '000000000369', '02106-8101' ),
                ( '000000000376', '00346-5948' ),
                ( '000000000383', '01759-6122' ),
                ( '000000000397', '00046-2886' ),
                ( '000000000399', '01643-7828' ),
                ( '000000000403', '04236-5713' ),
                ( '000000000407', '01045-7379' ),
                ( '000000000420', '01745-6699' ),
                ( '000000000424', '01767-0393' ),
                ( '000000000427', '01746-9795' ),
                ( '000000000450', '00655-0445' ),
                ( '000000000459', '00383-2749' ),
                ( '000000000481', '05356-0918' ),
                ( '000000000483', '00578-2495' ),
                ( '000000000484', '00347-6383' ),
                ( '000000000488', '05751-5905' ),
                ( '000000000489', '01170-8050' ),
                ( '000000000493', '01874-0305' ),
                ( '000000000508', '00654-7430' ),
                ( '000000000520', '00924-1892' ),
                ( '000000000525', '01991-6228' ),
                ( '000000000527', '01830-2289' ),
                ( '000000000529', '06860-3339' ),
                ( '000000000532', '01296-3358' ),
                ( '000000000553', '00234-8894' ),
                ( '000000000565', '06802-5495' ),
                ( '000000000572', '04574-1372' ),
                ( '000000000576', '00233-9115' ),
                ( '000000000583', '00693-3009' ),
                ( '000000000597', '01970-3315' ),
                ( '000000000625', '09529-3377' ),
                ( '000000000628', '00517-1696' ),
                ( '000000000632', '00356-1514' ),
                ( '000000000637', '01885-5282' ),
                ( '000000000653', '01810-5930' ),
                ( '000000000657', '00411-3163' ),
                ( '000000000659', '01012-7562' ),
                ( '000000000666', '04281-8709' ),
                ( '000000000667', '09583-2509' ),
                ( '000000000669', '08102-2035' ),
                ( '000000000718', '01669-8656' ),
                ( '000000000736', '03861-2916' ),
                ( '000000000742', '04687-0011' ),
                ( '000000000746', '05633-0143' ),
                ( '000000000754', '04250-1403' ),
                ( '000000000755', '00025-0501' ),
                ( '000000000773', '01867-0287' ),
                ( '000000000775', '07726-7297' ),
                ( '000000000787', '00023-9107' ),
                ( '000000000800', '00274-2792' ),
                ( '000000000824', '04815-7688' ),
                ( '000000000829', '04815-7688' ),
                ( '000000000834', '00794-6167' ),
                ( '000000000837', '00764-3911' ),
                ( '000000000838', '00773-0958' ),
                ( '000000000865', '01133-0422' ),
                ( '000000000872', '03738-6220' ),
                ( '000000000879', '04725-2480' ),
                ( '000000000881', '00723-0067' ),
                ( '000000000883', '06753-5800' ),
                ( '000000000886', '04449-1201' ),
                ( '000000000892', '01975-3396' ),
                ( '000000000893', '04767-4155' ),
                ( '000000000894', '06777-9707' ),
                ( '000000000906', '01528-5226' ),
                ( '000000000907', '09107-5781' ),
                ( '000000000910', '05784-8589' ),
                ( '000000000914', '00004-4491' ),
                ( '000000000928', '00505-1069' ),
                ( '000000000956', '00339-9644' ),
                ( '000000000971', '01176-7844' ),
                ( '000000000979', '00332-1227' ),
                ( '000000000984', '01795-0125' ),
                ( '000000000992', '00404-6319' ),
                ( '000000000994', '06899-7785' ),
                ( '000000001019', '00329-3300' ),
                ( '000000001024', '00304-5158' ),
                ( '000000001034', '01993-5499' ),
                ( '000000001038', '01601-5736' ),
                ( '000000001047', '07365-4828' ),
                ( '000000001051', '08442-2906' ),
                ( '000000001065', '01973-9483' ),
                ( '000000001082', '01738-7330' ),
                ( '000000001086', '02858-1598' ),
                ( '000000001091', '02862-0995' ),
                ( '000000001103', '02108-1873' ),
                ( '000000001115', '09332-9788' ),
                ( '000000001126', '01657-6789' ),
                ( '000000001142', '06549-6192' ),
                ( '000000001149', '08790-2782' ),
                ( '000000001152', '04425-7773' ),
                ( '000000001158', '02826-9057' ),
                ( '000000001165', '05708-5387' ),
                ( '000000001167', '01548-9544' ),
                ( '000000001176', '08930-5595' ),
                ( '000000001177', '00887-8451' ),
                ( '000000001178', '08083-9888' ),
                ( '000000001202', '01886-9520' ),
                ( '000000001208', '03805-3872' ),
                ( '000000001218', '07758-1580' ),
                ( '000000001248', '01515-0187' ),
                ( '000000001305', '07919-3920' ),
                ( '000000001648', '00413-8262' ),
                ( '000000001651', '01754-9154' ),
                ( '000000001653', '05205-9002' ),
                ( '000000001669', '05214-6789' ),
                ( '000000001670', '00966-5652' ),
                ( '000000001674', '00835-1024' ),
                ( '000000001698', '00608-7050' ),
                ( '000000001703', '01175-2727' ),
                ( '000000001708', '05416-5002' ),
                ( '000000001759', '01093-0310' ),
                ( '000000001768', '00236-5771' ),
                ( '000000001937', '07696-0897' ),
                ( '000000002052', '01239-2202' ),
                ( '000000002226', '00010-0907' ),
                ( '000000002554', '00361-2056' ),
                ( '000000002614', '01738-7330' ),
                ( '000000002810', '01334-3289' ),
                ( '000000003119', '08103-3336' ),
                ( '000000003153', '10180-4705' ),
                ( '000000003725', '01318-1438' ),
                ( '000000003752', '04414-3288' ),
                ( '000000003763', '01146-6991' ),
                ( '000000003870', '07588-2053' ),
                ( '000000003920', '07675-3980' ),
                ( '000000003938', '00856-3825' ),
                ( '000000003944', '04158-1510' ),
                ( '000000004010', '01477-8440' ),
                ( '000000004046', '03786-3387' ),
                ( '000000004104', '00832-4042' ),
                ( '000000004201', '05962-9620' ),
                ( '000000004242', '08760-8103' ),
                ( '000000004278', '03809-1166' ),
                ( '000000004286', '04454-2030' ),
                ( '000000004380', '00228-5134' ),
                ( '000000004480', '01260-6462' ),
                ( '000000004482', '08098-5103' ),
                ( '000000004530', '01318-1438' ),
                ( '000000005085', '02825-3387' ),
                ( '000000005174', '07534-1220' ),
                ( '000000005260', '01642-3330' ),
                ( '000000005319', '00728-0826' ),
                ( '000000005589', '07103-8649' ),
                ( '000000005850', '02051-2394' ),
                ( '000000005907', '01455-5006' ),
                ( '000000005909', '01833-1600' ),
                ( '000000006065', '09192-3785' ),
                ( '000000006400', '00230-1558' ),
                ( '000000006709', '00050-7905' ),
                ( '000000006814', '09219-0080' ),
                ( '000000006834', '00373-9003' ),
                ( '000000006860', '01994-0308' ),
                ( '000000007060', '00728-0826' ),
                ( '000000007273', '00363-1499' ),
                ( '000000007277', '02030-0144' ),
                ( '000000007338', '07280-3766' ),
                ( '000000007405', '05207-0388' ),
                ( '000000007529', '00444-5565' ),
                ( '000000007937', '07252-4441' ),
                ( '000000007938', '01755-8096' ),
                ( '000000008676', '00365-8803' ),
                ( '000000008709', '01818-0430' ),
                ( '000000008787', '05805-2296' ),
                ( '000000009111', '07676-8969' ),
                ( '000000009176', '07173-9478' ),
                ( '000000009177', '00919-4435' ),
                ( '000000009179', '07666-6812' ),
                ( '000000009274', '09113-1960' ),
                ( '000000009305', '09805-2277' ),
                ( '000000009705', '00030-1389' ),
                ( '000000009851', '06752-9761' ),
                ( '000000009889', '08402-0907' ),
                ( '000000010142', '01818-0430' ),
                ( '000000010278', '07810-4098' ),
                ( '000000010394', '07689-8406' ),
                ( '000000010442', '00790-3470' ),
                ( '000000010485', '00878-7851' ),
                ( '000000010554', '00002-4657' ),
                ( '000000010561', '00036-8943' ),
                ( '000000010706', '00452-2154' ),
                ( '000000010878', '00267-8675' ),
                ( '000000010898', '07701-2315' ),
                ( '000000011263', '08985-7290' ),
                ( '000000011409', '07764-0255' ),
                ( '000000011565', '01160-9439' ),
                ( '000000011736', '01689-8760' ),
                ( '000000011741', '01992-4577' ),
                ( '000000011799', '04083-3833' ),
                ( '000000011869', '00030-1389' ),
                ( '000000012166', '02609-7218' ),
                ( '000000012168', '02104-5801' ),
                ( '000000012169', '01807-9194' ),
                ( '000000012171', '03832-8558' ),
                ( '000000012265', '06199-0920' ),
                ( '000000012382', '08400-6846' ),
                ( '000000012428', '07919-3920' ),
                ( '000000012464', '01038-8589' ),
                ( '000000012669', '06255-2547' ),
                ( '000000012748', '03647-0522' ),
                ( '000000012988', '09132-6019' ),
                ( '000000013264', '08790-2782' ),
                ( '000000013867', '04179-4514' ),
                ( '000000013921', '06248-8240' ),
                ( '000000013923', '04264-8573' ),
                ( '000000013924', '05156-0237' ),
                ( '000000013925', '00107-2443' ),
                ( '000000013939', '04209-4897' ),
                ( '000000013973', '04111-2361' ),
                ( '000000014463', '05442-1880' ),
                ( '000000014465', '06159-5878' ),
                ( '000000014845', '05371-7831' ),
                ( '000000014902', '09911-9025' ),
                ( '000000014907', '01689-8760' ),
                ( '000000014922', '05468-0616' ),
                ( '000000014957', '04815-7688' ),
                ( '000000014959', '08930-5595' ),
                ( '000000014961', '06225-6132' ),
                ( '000000014970', '02563-4563' ),
                ( '000000014991', '04622-3611' ),
                ( '000000015122', '04510-7765' ),
                ( '000000015171', '09437-7780' ),
                ( '000000015173', '02300-5295' ),
                ( '000000015174', '01071-3570' ),
                ( '000000015354', '00044-9966' ),
                ( '000000015408', '07745-2105' ),
                ( '000000015432', '02479-9998' ),
                ( '000000015448', '04635-7409' ),
                ( '000000015522', '07782-0760' ),
                ( '000000015549', '06668-8640' ),
                ( '000000015602', '01689-8760' ),
                ( '000000015716', '01428-2962' ),
                ( '000000015885', '06188-5147' ),
                ( '000000016094', '01899-1087' ),
                ( '000000016863', '00730-0606' ),
                ( '000000016919', '01689-8760' ),
                ( '000000016935', '07745-2105' ),
                ( '000000017226', '07457-1132' ),
                ( '000000017318', '00833-0459' ),
                ( '000000017393', '06633-9988' ),
                ( '000000017427', '06685-2066' ),
                ( '000000017476', '05312-3785' ),
                ( '000000017519', '06751-7980' ),
                ( '000000017555', '07175-6626' ),
                ( '000000017889', '05967-0523' ),
                ( '000000017960', '05986-0563' ),
                ( '000000017961', '06945-9394' ),
                ( '000000017962', '00021-9400' ),
                ( '000000018272', '00617-1029' ),
                ( '000000018808', '07539-9922' ),
                ( '000000018847', '07434-2343' ),
                ( '000000018891', '09218-3016' ),
                ( '000000019152', '07720-9119' ),
                ( '000000019220', '03813-8150' ),
                ( '000000019278', '01917-8012' ),
                ( '000000019358', '08696-0365' ),
                ( '000000019752', '07672-5840' ),
                ( '000000019904', '07745-2105' ),
                ( '000000020198', '04772-5686' ),
                ( '000000020337', '07919-3920' ),
                ( '000000020809', '05976-2756' ),
                ( '000000022500', '01738-7330' ),
                ( '000000030046', '08602-2544' ),
                ( '000000030061', '01849-0199' ),
                ( '000000030078', '02131-2008' ),
                ( '000000030194', '04634-5687' ),
                ( '000000030456', '08930-5595' ),
                ( '000000030836', '07895-4719' ),
                ( '000000030968', '00034-0527' ),
                ( '000000030990', '00052-8193' ),
                ( '000000031202', '06156-7911' ),
                ( '000000031211', '09525-2769' ),
                ( '000000031516', '01285-6443' ),
                ( '000000031732', '09050-6146' ),
                ( '000000033159', '04815-7688' ),
                ( '000000033776', '03967-1973' ),
                ( '000000033777', '03347-4599' ),
                ( '000000033941', '08225-0500' ),
                ( '000000034004', '07743-5029' ),
                ( '000000034044', '09853-2739' ),
                ( '000000034200', '09581-0700' ),
                ( '000000034267', '01738-7330' ),
                ( '000000034368', '09871-4420' ),
                ( '000000034475', '07725-4689' ),
                ( '000000034518', '06199-0920' ),
                ( '000000035214', '08389-4462' ),
                ( '000000035832', '01638-8155' ),
                ( '000000035841', '00682-6223' ),
                ( '000000035852', '09727-2065' ),
                ( '000000035854', '08530-0499' ),
                ( '000000035861', '08754-4710' ),
                ( '000000035867', '08382-1122' ),
                ( '000000036951', '01689-8760' ),
                ( '000000037088', '02152-3447' ),
                ( '000000037208', '06199-0920' ),
                ( '000000037324', '01681-0084' ),
                ( '000000037325', '01094-9766' ),
                ( '000000037326', '01995-1346' ),
                ( '000000037466', '06199-0920' ),
                ( '000000037543', '06919-0122' ),
                ( '000000037556', '00515-8994' ),
                ( '000000037943', '01689-8760' ),
                ( '000000038519', '00034-0527' ),
                ( '000000038524', '06199-0920' ),
                ( '000000039332', '01777-1333' ),
                ( '000000040462', '03487-8810' ),
                ( '000000043906', '06199-0920' );

--/**************************************************************************************************/

		INSERT INTO @GivenProviderIds
		SELECT DISTINCT PDP_providerId FROM Network_Development.dbo.Tbl_ProviderDirectory_VerificationProvider PDP WITH (nolock)
		JOIN @providersDirectory AS PD ON PD.DirectoryID = PDP.PDP_DirectoryID
		

		
--/**************************************************************************************************/


												  --Get Tax IDs and ProviderID from Network 
        INSERT  INTO @ProviderTaxID
                SELECT DISTINCT
                        PPI_ID ,
                        CLN.CLN_TIN AS taxid
                FROM    Network_Development.dbo.Tbl_Provider_ProviderInfo PPI
                        WITH ( NOLOCK )
                        INNER JOIN Network_Development.[dbo].[Tbl_Contract_LocationsNumbers] CLN ON ISNULL(PPI.PPI_ID,
                                                              '') = ISNULL(CLN.CLNS_ProviderID,
                                                              '')
                        LEFT JOIN Network_Development.[dbo].[Tbl_Contract_Locations] CL
                        WITH ( NOLOCK ) ON CL.CL_ID = CLN.CLNS_LocationID
                WHERE   CLN.CLNS_Status = 1
                UNION
                SELECT DISTINCT
                        PPI_ID ,
                        CLI.CCI_TIN AS taxid
                FROM    Network_Development.dbo.Tbl_Provider_ProviderInfo PPI
                        WITH ( NOLOCK )
                        INNER JOIN Network_Development.[dbo].[Tbl_Contract_CPL] CPL
                        WITH ( NOLOCK ) ON CPL.CCPL_ProviderID = PPI.PPI_ID
                        LEFT JOIN Network_Development.[dbo].[Tbl_Contract_Locations] CL
                        WITH ( NOLOCK ) ON CPL.CCPL_LocationID = CL.CL_ID
                        LEFT JOIN Network_Development.[dbo].[Tbl_Contract_ContractInfo] CLI
                        WITH ( NOLOCK ) ON CLI.CCI_ID = CPL.CCPL_ContractID
                WHERE   ( CLI.CCI_TermDate IS NULL
                          OR CLI.CCI_TermDate > @now
                        )
                        AND ( CPL.CCPL_TermDate IS NULL
                              OR CPL.CCPL_TermDate > @now
                            )
                UNION
                SELECT DISTINCT
                        PPI.PPI_ID ,
                        CL.CL_TIN AS taxid
                FROM    Network_Development.dbo.Tbl_Provider_ProviderInfo PPI
                        WITH ( NOLOCK )
                        INNER JOIN Network_Development.[dbo].Tbl_Provider_ProviderAffiliation PPA
                        WITH ( NOLOCK ) ON PPA_ProviderID = PPI.PPI_ID
                        INNER JOIN Network_Development.[dbo].[Tbl_Contract_Locations] CL
                        WITH ( NOLOCK ) ON PPA_LocationID = CL.CL_ID
                WHERE   ( PPA_TermDate IS NULL
                          OR PPA_TermDate > @now
                        )
                        AND ( PPI.PPI_ID IS NOT NULL )
                        AND ( CL.CL_TIN IS NOT NULL );

												  --Get Tax IDs and ProviderID from Diamond 
        INSERT  INTO @ProviderTaxID
                SELECT DISTINCT
                        F.PAPROVID ,
                        LEFT(A.PCDEFVENDR, 9)
                FROM    Diam_725_App.diamond.JPROVFM0_DAT AS F WITH ( NOLOCK )
                        JOIN Diam_725_App.diamond.JPROVAM0_DAT AS A WITH ( NOLOCK ) ON A.PCPROVID = F.PAPROVID
                WHERE   PCDEFVENDR NOT IN ( 'DONOTUSE', 'INFOR', 'DO NOT USE' )
                        AND F.PATYPE IN ( 'PCP', 'TPCP', 'MPCP', 'NPCP' );

/**********************************************************************************************/
											    --Get ProviderID from ProviderSearchCore based on TaxID 
        INSERT  INTO @ProviderDetails																	
                SELECT DISTINCT
                        T.ProviderID ,
                        T.FirstName ,
                        T.LastName ,
                        T.OrganizationName ,
                        T.NPI ,
                        T.ProviderType
                FROM    ( SELECT    * ,
                                    ROW_NUMBER() OVER ( PARTITION BY FirstName,							--Removing Multiple DiamondIds for Other than PCP
                                                        LastName, Gender, NPI,
                                                        License,
                                                        OrganizationName,
                                                        NetDevProvID ORDER BY ProviderID ) AS ranking
                          FROM      search.Provider AS a WITH ( NOLOCK )
                        ) T
                        JOIN search.Address AS ad WITH ( NOLOCK ) ON ad.ProviderID = T.ProviderID
                        JOIN @ProviderTaxID AS PTI ON PTI.providerid = ISNULL(T.NetDevProvID,
                                                              T.DiamProvID)
                WHERE   @TaxID = PTI.taxid
						AND AD.LocationID = @LocationID
						AND PTI.providerid IN (SELECT DISTINCT providerid FROM @GivenProviderIds)			--Added to get specific provider from the list 
                        AND T.ranking = 1
                        AND T.ProviderType IN ( 'NPP','VSN', 'BH', 'SPEC', 'ANC' )
				UNION
				      SELECT DISTINCT
                        T.ProviderID ,
                        T.FirstName ,
                        T.LastName ,
                        T.OrganizationName ,
                        T.NPI ,
                        T.ProviderType
                FROM    ( SELECT    * ,
                                    ROW_NUMBER() OVER ( PARTITION BY FirstName,							--Including all diamondIDs for PCps
														DiamProvID,
                                                        LastName, Gender, NPI,
                                                        License,
                                                        OrganizationName,
                                                        NetDevProvID ORDER BY ProviderID ) AS ranking
                          FROM      search.Provider AS a WITH ( NOLOCK )
                        ) T
                        JOIN search.Address AS ad WITH ( NOLOCK ) ON ad.ProviderID = T.ProviderID
                        JOIN @ProviderTaxID AS PTI ON PTI.providerid = ISNULL(T.NetDevProvID,
                                                              T.DiamProvID)
                WHERE   @TaxID = PTI.taxid
						AND AD.LocationID = @LocationID
						AND PTI.providerid IN (SELECT DISTINCT providerid FROM @GivenProviderIds)			--Added to get specific provider from the list 
                        AND T.ranking = 1
                        AND T.ProviderType IN ( 'PCP', 'MPCP', 'NPCP','TPCP'); 

/**********************************************************************************************/
												--Select  upated Provider Details into temp table
        SELECT DISTINCT
                PD.* ,
                DL.CreationTimestamp AS LastUpdatedDate ,
                DATEADD(MONTH, @ExpirationMonths, DL.CreationTimestamp) AS NextUpdateRequireDate ,
                DLU.UserName ,
                DL.ChangeStatus AS StatusLabel ,
                DL.DataLogRecordId AS LastUpdateRequestID ,
                DL.SupportedDocumentId AS SupportedDocumentID ,
                DL.CrossReferenceSystemValue AS ConfirmationID 
	/****		--Add here if any new field required from Datalog or DatalogRecord ********/
        INTO    #ProviderDetails
        FROM    @ProviderDetails PD
                LEFT JOIN changed.DataLogRecord AS DL WITH ( NOLOCK ) ON DL.TablePKFieldValue = PD.providerid
                                                              AND DL.TableName = 'search.Provider'
                LEFT JOIN changed.DataLogUser AS DLU WITH ( NOLOCK ) ON DLU.DataLogRecordId = DL.DataLogRecordId; 

/**********************************************************************************************/
													--Select all provider information under TaxId or Under AddressID

  
        SELECT DISTINCT
                PD.providerid ,
                PD.firstname ,
                PD.lastname ,
                PD.providertype ,
                PD.organizationname ,
                PD.npi
        FROM    #ProviderDetails PD
                LEFT JOIN search.Address AS ad WITH ( NOLOCK ) ON ad.ProviderID = PD.providerid
        WHERE   ( @LocationID = ad.LocationID
                  OR @LocationID IS NULL
                )
                AND ( PD.LastUpdatedDate = ( SELECT MAX(LastUpdatedDate)
                                             FROM   #ProviderDetails AS T2
                                                    WITH ( NOLOCK )
                                             WHERE  T2.LastUpdateRequestID = PD.LastUpdateRequestID
                                           )
                      OR PD.LastUpdatedDate IS NULL
                    )
        ORDER BY PD.lastname ,
                PD.firstname ,
                PD.organizationname;
															--Last UPdate Information
        SELECT DISTINCT
                PD.providerid AS RecordId ,
                PD.LastUpdatedDate AS LastUpdatedDate ,
                PD.UserName AS LastUpdatedBy ,
                PD.LastUpdateRequestID AS LastUpdateRequestID ,
                PD.ConfirmationID AS ConfirmationID ,
                PD.NextUpdateRequireDate AS NextUpdateRequireDate ,
                PD.StatusLabel AS ChangeStatus
        FROM    #ProviderDetails PD
                LEFT JOIN search.Address AS ad WITH ( NOLOCK ) ON ad.ProviderID = PD.providerid
        WHERE   ( @LocationID = ad.LocationID
                  OR @LocationID IS NULL
                )
                AND PD.LastUpdatedDate = ( SELECT   MAX(LastUpdatedDate)
                                           FROM     #ProviderDetails AS T2
                                                    WITH ( NOLOCK )
                                           WHERE    T2.LastUpdateRequestID = PD.LastUpdateRequestID
                                         )
                AND PD.StatusLabel IN ( 'Completed', 'Updated' );

        SELECT DISTINCT									--Get pending update details
                PD.providerid AS RecordId ,
                PD.LastUpdatedDate AS PendingUpdateDate ,
                PD.UserName AS PendingUpdateBy ,
                PD.LastUpdateRequestID AS PendingUpdateRequestID ,
                PD.SupportedDocumentID AS SupportedDocumentID ,
                PD.ConfirmationID AS ConfirmationID ,
                PD.StatusLabel AS ChangeStatus
        FROM    #ProviderDetails PD
                LEFT JOIN search.Address AS ad WITH ( NOLOCK ) ON ad.ProviderID = PD.providerid
        WHERE   ( ad.LocationID = @LocationID
                  OR @LocationID IS NULL
                )
                AND PD.StatusLabel <> 'Completed'
        ORDER BY PD.LastUpdateRequestID ASC;

 /**********************************************************************************************/
    END; 









GO
/****** Object:  StoredProcedure [changed].[GetProvidersLastUpdatedDate]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [changed].[GetProvidersLastUpdatedDate]
    @TaxID VARCHAR(9) ,
    @LocationID INT = NULL ,
    @ExpirationMonths INT = 3
AS
    BEGIN 
        SET NOCOUNT ON; 

	  /*
			Modification Log:
				1
		*/


/**********************************************************************************************/
												--Declare Local Table Variables
        DECLARE @now DATE = GETDATE();
        DECLARE @ProviderTaxID TABLE
            (
              providerid VARCHAR(12) ,
              taxid VARCHAR(9)
            ); 
        DECLARE @ProviderDetails TABLE
            (
              providerid VARCHAR(12) ,
              firstname VARCHAR(100) NULL ,
              lastname VARCHAR(100) NULL ,
              organizationname VARCHAR(100) NULL ,
              npi VARCHAR(12) NULL ,
              providertype VARCHAR(20) NULL
            ); 

		DECLARE @GivenProviderIds TABLE(ProviderID INT );

        IF OBJECT_ID('tempdb..#ProviderDetails') IS NOT NULL
            DROP TABLE #ProviderDetails;
	
/**********************************************************************************************/

/**************************************************************************************************/
												--Inlclude Locations only
		
        DECLARE @providersDirectory TABLE
            (
              DiamondID VARCHAR(12) ,
              DirectoryID VARCHAR(12) NULL
            );
        INSERT  INTO @providersDirectory
                ( DiamondID, DirectoryID )
        VALUES  ( '000000000133', '08519-1633' ),
                ( '000000000140', '00056-6828' ),
                ( '000000000149', '03177-9940' ),
                ( '000000000150', '01471-2734' ),
                ( '000000000160', '00832-4042' ),
                ( '000000000168', '01510-4763' ),
                ( '000000000173', '01557-2508' ),
                ( '000000000196', '08052-0000' ),
                ( '000000000204', '00476-9365' ),
                ( '000000000209', '07336-1299' ),
                ( '000000000230', '08285-1172' ),
                ( '000000000252', '07536-6231' ),
                ( '000000000302', '05647-4241' ),
                ( '000000000303', '00694-5087' ),
                ( '000000000306', '01835-0433' ),
                ( '000000000312', '07796-4485' ),
                ( '000000000320', '00552-5250' ),
                ( '000000000325', '00348-1155' ),
                ( '000000000329', '05784-8589' ),
                ( '000000000336', '00565-1098' ),
                ( '000000000360', '01625-2527' ),
                ( '000000000362', '00489-3123' ),
                ( '000000000368', '00816-4038' ),
                ( '000000000369', '02106-8101' ),
                ( '000000000376', '00346-5948' ),
                ( '000000000383', '01759-6122' ),
                ( '000000000397', '00046-2886' ),
                ( '000000000399', '01643-7828' ),
                ( '000000000403', '04236-5713' ),
                ( '000000000407', '01045-7379' ),
                ( '000000000420', '01745-6699' ),
                ( '000000000424', '01767-0393' ),
                ( '000000000427', '01746-9795' ),
                ( '000000000450', '00655-0445' ),
                ( '000000000459', '00383-2749' ),
                ( '000000000481', '05356-0918' ),
                ( '000000000483', '00578-2495' ),
                ( '000000000484', '00347-6383' ),
                ( '000000000488', '05751-5905' ),
                ( '000000000489', '01170-8050' ),
                ( '000000000493', '01874-0305' ),
                ( '000000000508', '00654-7430' ),
                ( '000000000520', '00924-1892' ),
                ( '000000000525', '01991-6228' ),
                ( '000000000527', '01830-2289' ),
                ( '000000000529', '06860-3339' ),
                ( '000000000532', '01296-3358' ),
                ( '000000000553', '00234-8894' ),
                ( '000000000565', '06802-5495' ),
                ( '000000000572', '04574-1372' ),
                ( '000000000576', '00233-9115' ),
                ( '000000000583', '00693-3009' ),
                ( '000000000597', '01970-3315' ),
                ( '000000000625', '09529-3377' ),
                ( '000000000628', '00517-1696' ),
                ( '000000000632', '00356-1514' ),
                ( '000000000637', '01885-5282' ),
                ( '000000000653', '01810-5930' ),
                ( '000000000657', '00411-3163' ),
                ( '000000000659', '01012-7562' ),
                ( '000000000666', '04281-8709' ),
                ( '000000000667', '09583-2509' ),
                ( '000000000669', '08102-2035' ),
                ( '000000000718', '01669-8656' ),
                ( '000000000736', '03861-2916' ),
                ( '000000000742', '04687-0011' ),
                ( '000000000746', '05633-0143' ),
                ( '000000000754', '04250-1403' ),
                ( '000000000755', '00025-0501' ),
                ( '000000000773', '01867-0287' ),
                ( '000000000775', '07726-7297' ),
                ( '000000000787', '00023-9107' ),
                ( '000000000800', '00274-2792' ),
                ( '000000000824', '04815-7688' ),
                ( '000000000829', '04815-7688' ),
                ( '000000000834', '00794-6167' ),
                ( '000000000837', '00764-3911' ),
                ( '000000000838', '00773-0958' ),
                ( '000000000865', '01133-0422' ),
                ( '000000000872', '03738-6220' ),
                ( '000000000879', '04725-2480' ),
                ( '000000000881', '00723-0067' ),
                ( '000000000883', '06753-5800' ),
                ( '000000000886', '04449-1201' ),
                ( '000000000892', '01975-3396' ),
                ( '000000000893', '04767-4155' ),
                ( '000000000894', '06777-9707' ),
                ( '000000000906', '01528-5226' ),
                ( '000000000907', '09107-5781' ),
                ( '000000000910', '05784-8589' ),
                ( '000000000914', '00004-4491' ),
                ( '000000000928', '00505-1069' ),
                ( '000000000956', '00339-9644' ),
                ( '000000000971', '01176-7844' ),
                ( '000000000979', '00332-1227' ),
                ( '000000000984', '01795-0125' ),
                ( '000000000992', '00404-6319' ),
                ( '000000000994', '06899-7785' ),
                ( '000000001019', '00329-3300' ),
                ( '000000001024', '00304-5158' ),
                ( '000000001034', '01993-5499' ),
                ( '000000001038', '01601-5736' ),
                ( '000000001047', '07365-4828' ),
                ( '000000001051', '08442-2906' ),
                ( '000000001065', '01973-9483' ),
                ( '000000001082', '01738-7330' ),
                ( '000000001086', '02858-1598' ),
                ( '000000001091', '02862-0995' ),
                ( '000000001103', '02108-1873' ),
                ( '000000001115', '09332-9788' ),
                ( '000000001126', '01657-6789' ),
                ( '000000001142', '06549-6192' ),
                ( '000000001149', '08790-2782' ),
                ( '000000001152', '04425-7773' ),
                ( '000000001158', '02826-9057' ),
                ( '000000001165', '05708-5387' ),
                ( '000000001167', '01548-9544' ),
                ( '000000001176', '08930-5595' ),
                ( '000000001177', '00887-8451' ),
                ( '000000001178', '08083-9888' ),
                ( '000000001202', '01886-9520' ),
                ( '000000001208', '03805-3872' ),
                ( '000000001218', '07758-1580' ),
                ( '000000001248', '01515-0187' ),
                ( '000000001305', '07919-3920' ),
                ( '000000001648', '00413-8262' ),
                ( '000000001651', '01754-9154' ),
                ( '000000001653', '05205-9002' ),
                ( '000000001669', '05214-6789' ),
                ( '000000001670', '00966-5652' ),
                ( '000000001674', '00835-1024' ),
                ( '000000001698', '00608-7050' ),
                ( '000000001703', '01175-2727' ),
                ( '000000001708', '05416-5002' ),
                ( '000000001759', '01093-0310' ),
                ( '000000001768', '00236-5771' ),
                ( '000000001937', '07696-0897' ),
                ( '000000002052', '01239-2202' ),
                ( '000000002226', '00010-0907' ),
                ( '000000002554', '00361-2056' ),
                ( '000000002614', '01738-7330' ),
                ( '000000002810', '01334-3289' ),
                ( '000000003119', '08103-3336' ),
                ( '000000003153', '10180-4705' ),
                ( '000000003725', '01318-1438' ),
                ( '000000003752', '04414-3288' ),
                ( '000000003763', '01146-6991' ),
                ( '000000003870', '07588-2053' ),
                ( '000000003920', '07675-3980' ),
                ( '000000003938', '00856-3825' ),
                ( '000000003944', '04158-1510' ),
                ( '000000004010', '01477-8440' ),
                ( '000000004046', '03786-3387' ),
                ( '000000004104', '00832-4042' ),
                ( '000000004201', '05962-9620' ),
                ( '000000004242', '08760-8103' ),
                ( '000000004278', '03809-1166' ),
                ( '000000004286', '04454-2030' ),
                ( '000000004380', '00228-5134' ),
                ( '000000004480', '01260-6462' ),
                ( '000000004482', '08098-5103' ),
                ( '000000004530', '01318-1438' ),
                ( '000000005085', '02825-3387' ),
                ( '000000005174', '07534-1220' ),
                ( '000000005260', '01642-3330' ),
                ( '000000005319', '00728-0826' ),
                ( '000000005589', '07103-8649' ),
                ( '000000005850', '02051-2394' ),
                ( '000000005907', '01455-5006' ),
                ( '000000005909', '01833-1600' ),
                ( '000000006065', '09192-3785' ),
                ( '000000006400', '00230-1558' ),
                ( '000000006709', '00050-7905' ),
                ( '000000006814', '09219-0080' ),
                ( '000000006834', '00373-9003' ),
                ( '000000006860', '01994-0308' ),
                ( '000000007060', '00728-0826' ),
                ( '000000007273', '00363-1499' ),
                ( '000000007277', '02030-0144' ),
                ( '000000007338', '07280-3766' ),
                ( '000000007405', '05207-0388' ),
                ( '000000007529', '00444-5565' ),
                ( '000000007937', '07252-4441' ),
                ( '000000007938', '01755-8096' ),
                ( '000000008676', '00365-8803' ),
                ( '000000008709', '01818-0430' ),
                ( '000000008787', '05805-2296' ),
                ( '000000009111', '07676-8969' ),
                ( '000000009176', '07173-9478' ),
                ( '000000009177', '00919-4435' ),
                ( '000000009179', '07666-6812' ),
                ( '000000009274', '09113-1960' ),
                ( '000000009305', '09805-2277' ),
                ( '000000009705', '00030-1389' ),
                ( '000000009851', '06752-9761' ),
                ( '000000009889', '08402-0907' ),
                ( '000000010142', '01818-0430' ),
                ( '000000010278', '07810-4098' ),
                ( '000000010394', '07689-8406' ),
                ( '000000010442', '00790-3470' ),
                ( '000000010485', '00878-7851' ),
                ( '000000010554', '00002-4657' ),
                ( '000000010561', '00036-8943' ),
                ( '000000010706', '00452-2154' ),
                ( '000000010878', '00267-8675' ),
                ( '000000010898', '07701-2315' ),
                ( '000000011263', '08985-7290' ),
                ( '000000011409', '07764-0255' ),
                ( '000000011565', '01160-9439' ),
                ( '000000011736', '01689-8760' ),
                ( '000000011741', '01992-4577' ),
                ( '000000011799', '04083-3833' ),
                ( '000000011869', '00030-1389' ),
                ( '000000012166', '02609-7218' ),
                ( '000000012168', '02104-5801' ),
                ( '000000012169', '01807-9194' ),
                ( '000000012171', '03832-8558' ),
                ( '000000012265', '06199-0920' ),
                ( '000000012382', '08400-6846' ),
                ( '000000012428', '07919-3920' ),
                ( '000000012464', '01038-8589' ),
                ( '000000012669', '06255-2547' ),
                ( '000000012748', '03647-0522' ),
                ( '000000012988', '09132-6019' ),
                ( '000000013264', '08790-2782' ),
                ( '000000013867', '04179-4514' ),
                ( '000000013921', '06248-8240' ),
                ( '000000013923', '04264-8573' ),
                ( '000000013924', '05156-0237' ),
                ( '000000013925', '00107-2443' ),
                ( '000000013939', '04209-4897' ),
                ( '000000013973', '04111-2361' ),
                ( '000000014463', '05442-1880' ),
                ( '000000014465', '06159-5878' ),
                ( '000000014845', '05371-7831' ),
                ( '000000014902', '09911-9025' ),
                ( '000000014907', '01689-8760' ),
                ( '000000014922', '05468-0616' ),
                ( '000000014957', '04815-7688' ),
                ( '000000014959', '08930-5595' ),
                ( '000000014961', '06225-6132' ),
                ( '000000014970', '02563-4563' ),
                ( '000000014991', '04622-3611' ),
                ( '000000015122', '04510-7765' ),
                ( '000000015171', '09437-7780' ),
                ( '000000015173', '02300-5295' ),
                ( '000000015174', '01071-3570' ),
                ( '000000015354', '00044-9966' ),
                ( '000000015408', '07745-2105' ),
                ( '000000015432', '02479-9998' ),
                ( '000000015448', '04635-7409' ),
                ( '000000015522', '07782-0760' ),
                ( '000000015549', '06668-8640' ),
                ( '000000015602', '01689-8760' ),
                ( '000000015716', '01428-2962' ),
                ( '000000015885', '06188-5147' ),
                ( '000000016094', '01899-1087' ),
                ( '000000016863', '00730-0606' ),
                ( '000000016919', '01689-8760' ),
                ( '000000016935', '07745-2105' ),
                ( '000000017226', '07457-1132' ),
                ( '000000017318', '00833-0459' ),
                ( '000000017393', '06633-9988' ),
                ( '000000017427', '06685-2066' ),
                ( '000000017476', '05312-3785' ),
                ( '000000017519', '06751-7980' ),
                ( '000000017555', '07175-6626' ),
                ( '000000017889', '05967-0523' ),
                ( '000000017960', '05986-0563' ),
                ( '000000017961', '06945-9394' ),
                ( '000000017962', '00021-9400' ),
                ( '000000018272', '00617-1029' ),
                ( '000000018808', '07539-9922' ),
                ( '000000018847', '07434-2343' ),
                ( '000000018891', '09218-3016' ),
                ( '000000019152', '07720-9119' ),
                ( '000000019220', '03813-8150' ),
                ( '000000019278', '01917-8012' ),
                ( '000000019358', '08696-0365' ),
                ( '000000019752', '07672-5840' ),
                ( '000000019904', '07745-2105' ),
                ( '000000020198', '04772-5686' ),
                ( '000000020337', '07919-3920' ),
                ( '000000020809', '05976-2756' ),
                ( '000000022500', '01738-7330' ),
                ( '000000030046', '08602-2544' ),
                ( '000000030061', '01849-0199' ),
                ( '000000030078', '02131-2008' ),
                ( '000000030194', '04634-5687' ),
                ( '000000030456', '08930-5595' ),
                ( '000000030836', '07895-4719' ),
                ( '000000030968', '00034-0527' ),
                ( '000000030990', '00052-8193' ),
                ( '000000031202', '06156-7911' ),
                ( '000000031211', '09525-2769' ),
                ( '000000031516', '01285-6443' ),
                ( '000000031732', '09050-6146' ),
                ( '000000033159', '04815-7688' ),
                ( '000000033776', '03967-1973' ),
                ( '000000033777', '03347-4599' ),
                ( '000000033941', '08225-0500' ),
                ( '000000034004', '07743-5029' ),
                ( '000000034044', '09853-2739' ),
                ( '000000034200', '09581-0700' ),
                ( '000000034267', '01738-7330' ),
                ( '000000034368', '09871-4420' ),
                ( '000000034475', '07725-4689' ),
                ( '000000034518', '06199-0920' ),
                ( '000000035214', '08389-4462' ),
                ( '000000035832', '01638-8155' ),
                ( '000000035841', '00682-6223' ),
                ( '000000035852', '09727-2065' ),
                ( '000000035854', '08530-0499' ),
                ( '000000035861', '08754-4710' ),
                ( '000000035867', '08382-1122' ),
                ( '000000036951', '01689-8760' ),
                ( '000000037088', '02152-3447' ),
                ( '000000037208', '06199-0920' ),
                ( '000000037324', '01681-0084' ),
                ( '000000037325', '01094-9766' ),
                ( '000000037326', '01995-1346' ),
                ( '000000037466', '06199-0920' ),
                ( '000000037543', '06919-0122' ),
                ( '000000037556', '00515-8994' ),
                ( '000000037943', '01689-8760' ),
                ( '000000038519', '00034-0527' ),
                ( '000000038524', '06199-0920' ),
                ( '000000039332', '01777-1333' ),
                ( '000000040462', '03487-8810' ),
                ( '000000043906', '06199-0920' );

--/**************************************************************************************************/

		INSERT INTO @GivenProviderIds
		SELECT DISTINCT PDP_providerId FROM Network_Development.dbo.Tbl_ProviderDirectory_VerificationProvider PDP WITH (nolock)
		JOIN @providersDirectory AS PD ON PD.DirectoryID = PDP.PDP_DirectoryID
		

		
--/**************************************************************************************************/


												  --Get Tax IDs and ProviderID from Network 
        INSERT  INTO @ProviderTaxID
                SELECT DISTINCT
                        PPI_ID ,
                        CLN.CLN_TIN AS taxid
                FROM    Network_Development.dbo.Tbl_Provider_ProviderInfo PPI
                        WITH ( NOLOCK )
                        INNER JOIN Network_Development.[dbo].[Tbl_Contract_LocationsNumbers] CLN ON ISNULL(PPI.PPI_ID,
                                                              '') = ISNULL(CLN.CLNS_ProviderID,
                                                              '')
                        LEFT JOIN Network_Development.[dbo].[Tbl_Contract_Locations] CL
                        WITH ( NOLOCK ) ON CL.CL_ID = CLN.CLNS_LocationID
                WHERE   CLN.CLNS_Status = 1
                UNION
                SELECT DISTINCT
                        PPI_ID ,
                        CLI.CCI_TIN AS taxid
                FROM    Network_Development.dbo.Tbl_Provider_ProviderInfo PPI
                        WITH ( NOLOCK )
                        INNER JOIN Network_Development.[dbo].[Tbl_Contract_CPL] CPL
                        WITH ( NOLOCK ) ON CPL.CCPL_ProviderID = PPI.PPI_ID
                        LEFT JOIN Network_Development.[dbo].[Tbl_Contract_Locations] CL
                        WITH ( NOLOCK ) ON CPL.CCPL_LocationID = CL.CL_ID
                        LEFT JOIN Network_Development.[dbo].[Tbl_Contract_ContractInfo] CLI
                        WITH ( NOLOCK ) ON CLI.CCI_ID = CPL.CCPL_ContractID
                WHERE   ( CLI.CCI_TermDate IS NULL
                          OR CLI.CCI_TermDate > @now
                        )
                        AND ( CPL.CCPL_TermDate IS NULL
                              OR CPL.CCPL_TermDate > @now
                            )
                UNION
                SELECT DISTINCT
                        PPI.PPI_ID ,
                        CL.CL_TIN AS taxid
                FROM    Network_Development.dbo.Tbl_Provider_ProviderInfo PPI
                        WITH ( NOLOCK )
                        INNER JOIN Network_Development.[dbo].Tbl_Provider_ProviderAffiliation PPA
                        WITH ( NOLOCK ) ON PPA_ProviderID = PPI.PPI_ID
                        INNER JOIN Network_Development.[dbo].[Tbl_Contract_Locations] CL
                        WITH ( NOLOCK ) ON PPA_LocationID = CL.CL_ID
                WHERE   ( PPA_TermDate IS NULL
                          OR PPA_TermDate > @now
                        )
                        AND ( PPI.PPI_ID IS NOT NULL )
                        AND ( CL.CL_TIN IS NOT NULL );

												  --Get Tax IDs and ProviderID from Diamond 
        INSERT  INTO @ProviderTaxID
                SELECT DISTINCT
                        F.PAPROVID ,
                        LEFT(A.PCDEFVENDR, 9)
                FROM    Diam_725_App.diamond.JPROVFM0_DAT AS F WITH ( NOLOCK )
                        JOIN Diam_725_App.diamond.JPROVAM0_DAT AS A WITH ( NOLOCK ) ON A.PCPROVID = F.PAPROVID
                WHERE   PCDEFVENDR NOT IN ( 'DONOTUSE', 'INFOR', 'DO NOT USE' )
                        AND F.PATYPE IN ( 'PCP', 'TPCP', 'MPCP', 'NPCP' );

/**********************************************************************************************/
											    --Get ProviderID from ProviderSearchCore based on TaxID 
        INSERT  INTO @ProviderDetails																	
                SELECT DISTINCT
                        T.ProviderID ,
                        T.FirstName ,
                        T.LastName ,
                        T.OrganizationName ,
                        T.NPI ,
                        T.ProviderType
                FROM    ( SELECT    * ,
                                    ROW_NUMBER() OVER ( PARTITION BY FirstName,							--Removing Multiple DiamondIds for Other than PCP
                                                        LastName, Gender, NPI,
                                                        License,
                                                        OrganizationName,
                                                        NetDevProvID ORDER BY ProviderID ) AS ranking
                          FROM      search.Provider AS a WITH ( NOLOCK )
                        ) T
                        JOIN search.Address AS ad WITH ( NOLOCK ) ON ad.ProviderID = T.ProviderID
                        JOIN @ProviderTaxID AS PTI ON PTI.providerid = ISNULL(T.NetDevProvID,
                                                              T.DiamProvID)
                WHERE   @TaxID = PTI.taxid
						AND AD.LocationID = @LocationID
						AND PTI.providerid IN (SELECT DISTINCT providerid FROM @GivenProviderIds)			--Added to get specific provider from the list 
                        AND T.ranking = 1
                        AND T.ProviderType IN ( 'NPP','VSN', 'BH', 'SPEC', 'ANC' )
				UNION
				      SELECT DISTINCT
                        T.ProviderID ,
                        T.FirstName ,
                        T.LastName ,
                        T.OrganizationName ,
                        T.NPI ,
                        T.ProviderType
                FROM    ( SELECT    * ,
                                    ROW_NUMBER() OVER ( PARTITION BY FirstName,							--Including all diamondIDs for PCps
														DiamProvID,
                                                        LastName, Gender, NPI,
                                                        License,
                                                        OrganizationName,
                                                        NetDevProvID ORDER BY ProviderID ) AS ranking
                          FROM      search.Provider AS a WITH ( NOLOCK )
                        ) T
                        JOIN search.Address AS ad WITH ( NOLOCK ) ON ad.ProviderID = T.ProviderID
                        JOIN @ProviderTaxID AS PTI ON PTI.providerid = ISNULL(T.NetDevProvID,
                                                              T.DiamProvID)
                WHERE   @TaxID = PTI.taxid
						AND AD.LocationID = @LocationID
						AND PTI.providerid IN (SELECT DISTINCT providerid FROM @GivenProviderIds)			--Added to get specific provider from the list 
                        AND T.ranking = 1
                        AND T.ProviderType IN ( 'PCP', 'MPCP', 'NPCP','TPCP'); 

/**********************************************************************************************/
												--Select  upated Provider Details into temp table
        SELECT DISTINCT
                PD.* ,
                DL.CreationTimestamp AS LastUpdatedDate ,
                DATEADD(MONTH, @ExpirationMonths, DL.CreationTimestamp) AS NextUpdateRequireDate ,
                DLU.UserName ,
                DL.ChangeStatus AS StatusLabel ,
                DL.DataLogRecordId AS LastUpdateRequestID ,
                DL.SupportedDocumentId AS SupportedDocumentID ,
                DL.CrossReferenceSystemValue AS ConfirmationID 
	/****		--Add here if any new field required from Datalog or DatalogRecord ********/
        INTO    #ProviderDetails
        FROM    @ProviderDetails PD
                LEFT JOIN changed.DataLogRecord AS DL WITH ( NOLOCK ) ON DL.TablePKFieldValue = PD.providerid
                                                              AND DL.TableName = 'search.Provider'
                LEFT JOIN changed.DataLogUser AS DLU WITH ( NOLOCK ) ON DLU.DataLogRecordId = DL.DataLogRecordId; 

/**********************************************************************************************/
													--Select all provider information under TaxId or Under AddressID

  
        SELECT DISTINCT
				PD.providerid,
                PD.LastUpdatedDate,
				PD.NextUpdateRequireDate
        FROM    #ProviderDetails PD
                LEFT JOIN search.Address AS ad WITH ( NOLOCK ) ON ad.ProviderID = PD.providerid
        WHERE   ( @LocationID = ad.LocationID
                  OR @LocationID IS NULL
                )
                AND ( PD.LastUpdatedDate = ( SELECT MAX(LastUpdatedDate)
                                             FROM   #ProviderDetails AS T2
                                                    WITH ( NOLOCK )
                                             WHERE  PD.providerid = T2.providerid
                                           )
                      OR PD.LastUpdatedDate IS NULL
                    )
       ;
															--Last UPdate Information

 /**********************************************************************************************/
    END; 









GO
/****** Object:  StoredProcedure [changed].[GetSpecialtiesDropDown]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [changed].[GetSpecialtiesDropDown]

AS 
  BEGIN 
      SET nocount ON 

	  /*
			Modification Log:
				
		*/


/**********************************************************************************************/



	SELECT SpecialtyID,SPecialtyDesc FROM (
		Select distinct S.SpecialtyID, S.specialtyDesc,ROW_NUMBER() OVER (PARTITION BY s.SpecialtyDesc ORDER BY s.SpecialtyDesc) AS Ranking from search.Specialty s with (nolock) ) A
		WHERE A.Ranking = 1

 END 










GO
/****** Object:  StoredProcedure [changed].[GrantDenyReadWriteAccess]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [changed].[GrantDenyReadWriteAccess]
    @GrantPermissions BIT = 0 ,
    @DenyPermissions BIT = 0 ,
    @User VARCHAR(100) = 'ProviderSearchUser' ,
    @DatabaseName VARCHAR(100) = 'ProviderSearchCore' ,
    @RoleName VARCHAR(30) = 'db_DataReader'
AS
    BEGIN 
        SET NOCOUNT ON; 

        DECLARE @SQL NVARCHAR(255);
												
        IF ( @GrantPermissions = 1 )
            BEGIN	
                IF ( @RoleName <> 'db_Owner' )
                    BEGIN
                        IF (IS_ROLEMEMBER(@RoleName, @User) = 0)	--Check if already have read/write access
                            BEGIN  
                                SET @SQL = @DatabaseName
                                    + '.sys.sp_addrolemember ' + @RoleName
                                    + ',' + @User;
                                EXECUTE(@SQL);

                            END;
                    END;
            END;
/******************************************************************************************************************************/
        IF ( @DenyPermissions = 1 )
            BEGIN								--Don't allow to drop owner permissions
                IF ( @RoleName <> 'db_Owner' )
                    BEGIN
                        IF IS_ROLEMEMBER(@RoleName, @User) = 1	--Check if already have read/write access
                            BEGIN  
                                SET @SQL = @DatabaseName
                                    + '.sys.sp_droprolemember ' + @RoleName
                                    + ',' + @User;
                                EXECUTE(@SQL);

                            END;
                    END;
            END;

    END;

GO
/****** Object:  StoredProcedure [changed].[MergeStatusUpdates]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rodolfo Gutierrez
-- Create date: 01/17/2017
-- Description:	Merges list of updated status with DataLogRecord table  
-- =============================================
CREATE PROCEDURE [changed].[MergeStatusUpdates]
	-- Add the parameters for the stored procedure here
    @ShowVersion BIT = 0 ,
    @TVP UpdatedDataLogRecord READONLY
AS
    BEGIN TRY
        DECLARE @Version VARCHAR(100) = '01/17/2017 10:06 AM Version 1.0';
      
        IF @ShowVersion = 1
            BEGIN
                SELECT  OBJECT_SCHEMA_NAME(@@PROCID) AS SchemaName ,
                        OBJECT_NAME(@@PROCID) AS ProcedureName ,
                        @Version AS VersionInformation;
                RETURN 0;
            END; 
        SET NOCOUNT ON;

        BEGIN

            MERGE INTO [ProviderSearchCore].[changed].[DataLogRecord] AS TARGET
            USING @TVP AS SOURCE
            ON TARGET.[DataLogRecordId] = SOURCE.[DataLogRecordId]
            WHEN MATCHED AND SOURCE.Value3 = 'CLS'
                OR SOURCE.Value3 = 'RLV' THEN
                UPDATE SET
                         TARGET.ManualUpdateCrossReferenceStatus = SOURCE.Value3 ,
                         TARGET.ChangeStatus = 'Completed';
            RETURN @@ROWCOUNT;
        END;

    END TRY 

    BEGIN CATCH 
        DECLARE @ErrorMessage VARCHAR(4000) ,
            @ErrorSeverity INT ,
            @ErrorState INT; 

        SET @ErrorMessage = ERROR_MESSAGE(); 
        SET @ErrorSeverity = ERROR_SEVERITY(); 
        SET @ErrorState = ERROR_STATE(); 
        RAISERROR(@ErrorMessage,@ErrorSeverity,@ErrorState); 
    END CATCH; 
GO
/****** Object:  StoredProcedure [changed].[UpdateProviderDirectoryNDDB]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [changed].[UpdateProviderDirectoryNDDB]
	@ProviderType varchar(15) = null,
	@DataLogRecordID int
AS
BEGIN
	
	SET NOCOUNT ON


/*****************************************************************************
	ESTABLISH LOCAL VARIABLES 
 *****************************************************************************/
BEGIN
	declare @isProcessFailed bit,
	        @now datetime = getdate()	,
            @UpdateFailedCount int = 0,	
			@dblv_Id int,
			@propertyValueCount int = 0,
			@emrCount int = 0
/******************************************************************************/
END


/*****************************************************************************
	ESTABLISH TABLE VARIABLES 
 *****************************************************************************/
BEGIN
	/*** Purpose: Table variable to hold values for column which are going to be auto update the Provider_ProviderInfo table in NDDB ***/
	Declare @ProviderInfo Table																						
	(
		ProviderID int,
		[MiddleName] [varchar](100) NULL,
		[Gender] varchar(10) NULL,
		[NPI] [varchar](10) NULL,
		[License] [varchar](50)  NULL,
		[CCS] [bit] NULL,
		[Email] [varchar](100) NULL,
		[Language1] [varchar](5) NULL,
		[Language2] [varchar](5) NULL,
		[Language3] [varchar](5) NULL,
		[MediCalID] [char](10) NULL,
		[MedicareID] [varchar](20) NULL,
		[Ethnicity] [varchar](2) NULL																		
	)
	/*** Purpose: Table variable to hold values for column which are going to be auto update the tbl_Contract_Locations table in NDDB ***/ 
	Declare @ContractLocation table
	(	
		[LocationID] [int] null ,
		[OfficeEmail] [varchar](100) NULL,
		[OfficeManager] [varchar](100) NULL,
		[WalkIn] [bit] NULL,
		[OfficeHours] [varchar](100) NULL,
		[ApptOnly] [int] NULL ,
		[Signage] [varchar](255) NULL,
		[EMR] [smallint] NULL,
		[EMRSystem] int NULL,
		[ReferralFax] [varchar](10) NULL,
		[Website] [varchar](255) NULL,
		ClinicalLanguage tinyint NULL,
		StaffLanguage tinyint Null

	)
	/*** Purpose:  Table variable to hold values for column which are going to be auto update the tbl_Provider_DrugRegistrationInfo table in NDDB ***/ 
	Declare @DrugRegistrationInfo table
	(
		ProviderID int null,
		PDRI_Eprescribe int null,
		PDRI_Software nvarchar(50)
	)

	/*** Purpose:  Table variable to hold values for column which are going to be auto update the tbl_Contract_CPL table in NDDB ***/ 
	Declare @ContractCPL table 
	(
		ProviderID int,
		LocationID int,
		Phone varchar(14) null,
		Fax varchar(14) null
	)
	/*** Purpose:  Table variable to hold the DestinationID (Network_DevID) and the changedFieldname (ProviderSearchCore FIeldName) and the new value for that field ***/ 
	Declare @ProviderDataLog Table
	(
		DataLogId INT,
		DestinationID int,
		ChangedFieldName [varchar](100) NULL,
		ChangedNewValue varchar(500) NULL																
	)
	/*** Purpose:  Table variable to hold the DestinationID (Network_DevID) and the changedFieldname (ProviderSearchCore FIeldName) and the new value for that field ***/ 
	Declare @LocationDataLog Table
	(
		DestinationID int,
		ChangedFieldName [varchar](100) NULL,
		ChangedNewValue varchar(500) NULL																
	)
	/*** Purpose:  Table variable to hold the DestinationID (Network_DevID) and the changedFieldname (ProviderSearchCore FIeldName) and the new value for that field ***/ 
	Declare @ProviderLocationDataLog Table
	(
		DestinationProviderID int,
		DestinationLocationID int,
		ChangedFieldName [varchar](100) NULL,
		ChangedNewValue varchar(500) NULL																
	)

	/*** Purpose:  Table variable to hold values for column which are going to be auto update the tbl_Contract_LocationsNumbers table in NDDB ***/ 
	Declare @ContractLocationNumbers table
	(
		ProviderID int,
		LocationID int,
		Phone Varchar(14) null,
		Fax varchar(14) null
	)

		/*** Purpose:  Table variable to hold values for column which are going to be auto update the tbl_Contract_Locations table in NDDB and DataBaseListvalue table ***/ 
	Declare @AddressLanguage table
	(
		LocationID int,
		PropertyName varchar(50),
		PropertyValue varchar(500)
	)


END
/*****************************************************************************************
		Insert into data log table varibles from DataLog table along with Destination IDs
*****************************************************************************************/

	/*** Get updated data from DataLog table with Network_Dev ProviderID ***/
	Insert into @ProviderDataLog																							
		Select distinct DL.DataLogId,PPI.PPI_ID,Dl.ChangedFieldName as ChangedFieldName ,ISNULL(DL.ChangedNewValue,'') as ChangedNewValue
		From changed.DataLogRecord as DLR with (nolock)
		Inner join changed.DataLog as DL with (nolock) on DL.DataLogRecordId = DLR.DataLogRecordId
		Inner Join search.Provider as P with (nolock) on DL.TablePKFiedName = 'ProviderID' and DL.TablePKFieldValue = P.ProviderID  
		Inner join Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock) on PPI.PPI_ID =  P.NetDevProvID
		where (@DataLogRecordID = Dl.DataLogRecordId) and DL.TableName in ('Provider','Search.Provider','search.ProviderLanguage') --and ISNULL(Dl.ChangedNewValue,'') <> '' --and DL.LogType like '%Auto%' 
		and DL.CreationTimestamp = 
		(Select max(DL1.CreationTimeStamp) from changed.DataLog as DL1 where DL1.TablePKFieldValue = P.ProviderID and DL1.ChangedFieldName = DL.ChangedFieldName and DL1.ChangedNewValue = Dl.ChangedNewValue) 
		and DL.LogType like '%Auto%'


		/*** Get updated data from DataLog table with Network_Dev ProviderID ***/
	Insert into @LocationDataLog																								
		Select distinct CL.CL_ID,Dl.ChangedFieldName as ChangedFieldName ,ISNULL(DL.ChangedNewValue,'') as ChangedNewValue
		From changed.DataLogRecord as DLR with (nolock)
		Inner join changed.DataLog as DL with (nolock) on DL.DataLogRecordId = DLR.DataLogRecordId
		Inner Join search.Address as A with (nolock) on DL.TablePKFiedName = 'AddressID' and DL.TablePKFieldValue = A.AddressID  
		Inner join Network_Development.dbo.Tbl_Contract_Locations as CL with (nolock) on Cl.CL_ID= A.LocationID
		where DL.DataLogRecordId = @DataLogRecordID and DL.TableName in ('Address','Search.Address','search.AddressLanguage','AddressLanguage')-- and ISNULL(Dl.ChangedNewValue,'') <> ''  
		and DL.CreationTimestamp = 
		(Select max(DL1.CreationTimeStamp) from changed.DataLog as DL1 where DL1.TablePKFieldValue = A.AddressID and DL1.ChangedFieldName = DL.ChangedFieldName and DL1.ChangedNewValue = DL.ChangedNewValue) 
		and DL.LogType like '%Auto%' --and Dl.Status = 'Pending'	

		/*** Get updated data from DataLog table with Network_Dev ProviderID and LocationID ***/
	Insert into @ProviderLocationDataLog																								
		Select distinct P.NetDevProvID,CL.CL_ID,Dl.ChangedFieldName as ChangedFieldName ,ISNULL(DL.ChangedNewValue,'') as ChangedNewValue
		From changed.DataLogRecord as DLR with (nolock)
		Inner join changed.DataLog as DL with (nolock) on DL.DataLogRecordId = DLR.DataLogRecordId
		Inner Join search.Address as A with (nolock) on DL.TablePKFiedName = 'AddressID' and DL.TablePKFieldValue = A.AddressID  
		inner join search.Provider as P with (nolock) on A.ProviderID = P.ProviderID
		Inner join Network_Development.dbo.Tbl_Contract_Locations as CL with (nolock) on Cl.CL_ID= A.LocationID
		where DL.DataLogRecordId = @DataLogRecordID and DL.TableName in ('Address','Search.Address','search.AddressLanguage','AddressLanguage')-- and ISNULL(Dl.ChangedNewValue,'') <> ''  
		and DL.CreationTimestamp = 
		(Select max(DL1.CreationTimeStamp) from changed.DataLog as DL1 where DL1.TablePKFieldValue = A.AddressID and DL1.ChangedFieldName = DL.ChangedFieldName and DL1.ChangedNewValue = DL.ChangedNewValue) 
		and DL.LogType like '%Auto%' --and Dl.Status = 'Pending'	




/*****************************************************************************************
	Update Provider Info table (Network_Development.dbo.tbl_provider_providerinfo)
 ****************************************************************************************/
IF(@ProviderType <> 'PHRM' or @ProviderType is null)		
BEGIN
		BEGIN TRY
				/*** Insert Changes in @ProviderInfo ***/
				Insert into @ProviderInfo																						
				select 
				DestinationID as ProviderID,
				MiddleName,
				Case Gender 
					 when 'Male' then 2
					 when 'Female' then 1 end as Gender ,NPI,License,CCS,ProviderEmail,
				Null as Language1,
				Null as Language2,
				Null as Language3,
				 MediCalID,MediCareID,
					 Case when P.Ethnicity = LV.DBLV_Value then LV.DBLV_Abbreviation 
					 END
				from (
				select DestinationID,ChangedFieldName,ChangedNewValue
				 from @ProviderDataLog DL
				) a
				pivot(max(ChangedNewValue) for ChangedFieldName in (MiddleName,Gender,NPI,License,CCS,ProviderEmail,Language1,Language2,Language3,MediCalID,MediCareID,Ethnicity)) p
				left join Network_Development.dbo.Tbl_Database_ListValues as LV with (nolock) on ISNULL(P.Ethnicity,'') = LV.DBLV_Value and LV.DBLV_List = 73
				left join Network_Development.dbo.Tbl_Codes_Languages as L with (nolock) on L.LXDesc = P.Language1 or L.LXDesc = P.Language2 or L.LXDesc =  P.Language3;
		END TRY

		BEGIN CATCH
	
		Insert into changed.DirectoryUpdateLog 	
		SELECT @DataLogRecordID,'Tbl_provider_providerINfo',DL.ChangedFieldName,GETDATE(),'Failed',ERROR_MESSAGE(),ERROR_LINE(),'Bad data coming in'
		FROM @ProviderDataLog Dl WHERE DL.ChangedFieldName in ('MiddleName','Gender','NPI','License','CCS','ProviderEmail','Language1','Language2','Language3','LanguageDesc','MediCalID','MediCareID','Ethnicity');

	
		SET @UpdateFailedCount = @UpdateFailedCount + 1;

		END CATCH
/*****************************************************************************************/

		/***Split language into Language1, language2,langauge3 and get the language code to update the source ***/
		select DestinationID,
		ChangedFieldName ,
			Case when L.LXISOCODE = pl.ISOCode THEN L.LXCode
			    WHEN (PL.ISOCode IS null AND PL.Description = FL.LXDESC) THEN FL.LXCODE
			 END
		AS ChangedNewValue,
		cast(row_number() over (partition by DestinationId order by DL.DataLogId asc) as varchar(50)) as FieldCount into #temp2
		from @ProviderDataLog DL 
		left join search.Languages as PL with (nolock) on PL.Description = Dl.ChangedNewValue 
		LEFT JOIN Network_Development.dbo.Tbl_Codes_Languages AS L WITH (nolock) ON L.LXISOCODE = pl.ISOCode
		LEFT JOIN Diam_725_App.diamond.JLANGFM0_dat AS FL WITH (nolock) ON PL.DESCRIPTION = FL.LXDESC
		where Dl.ChangedFieldName = 'LanguageDesc' 

/*****************************************************************************************/


		/***Update @ProviderInfo with three langauges***/
		Update tt
		set Language1 = ISNULL(t1.ChangedNewValue,''),
		Language2 = ISNULL(t2.ChangedNewValue,''),
		Language3 =ISNULL(t3.ChangedNewValue,'')
		from @ProviderInfo tt 
		left join #temp2 t1 on t1.DestinationID = tt.ProviderID and t1.fieldCount = 1
		left join #temp2 t2 on t2.DestinationID = tt.ProviderID and t2.fieldCount = 2
		left join #temp2 t3 on t3.DestinationID = tt.ProviderID and t3.fieldCount = 3

/*****************************************************************************************/

		/*** Insert changes in @DrugResgistrationInfo ***/
	BEGIN TRY
		Insert into @DrugRegistrationInfo																						
		select 
		DestinationID,
		Case when Eprescribe in ('1','Yes','True') then -1 
			 when Eprescribe in ('0', 'No','False') then 0 end as Eprescribe,
		Software
		from (
		select DestinationID,ChangedFieldName,ChangedNewValue
		 from @ProviderDataLog DL
		) a
		pivot(max(ChangedNewValue) for ChangedFieldName in (Eprescribe,Software)) p
	END TRY

	BEGIN CATCH
		Insert into changed.DirectoryUpdateLog 	
		SELECT @DataLogRecordID,'Tbl_Provider_DrugRegistrationInfo',DL.ChangedFieldName,GETDATE(),'Failed',ERROR_MESSAGE(),ERROR_LINE(),'Bad data coming in'
		FROM @ProviderDataLog Dl WHERE DL.ChangedFieldName IN ('Eprescribe','Software')

		SET @UpdateFailedCount = @UpdateFailedCount + 1;

	END CATCH

/*****************************************************************************************/
	BEGIN TRY
		/*** Update source : NDDB : Tbl_provider_ProviderInfo ***/
		Update PPI
		SET
			PPI.PPI_MiddleName		=ISNULL(POI.MiddleName,PPI.PPI_MiddleName),
			PPI.PPI_Gender			=ISNULL(POI.Gender,PPI.PPI_Gender),
			PPI.PPI_UPIN			=ISNULL(POI.NPI,PPI.PPI_UPIN),
			PPI.PPI_License			=ISNULL(POI.License,PPI.PPI_License),
			PPI.PPI_CCS				=ISNULL(POI.CCS,PPI.PPI_CCS),
			PPI.PPI_Email			=ISNULL(POI.Email,PPI.PPI_Email),
			PPI.PPI_Language1		=ISNULL(POI.Language1,PPI.PPI_Language1),
			PPI.PPI_Language2		=ISNULL(POI.Language2,PPI.PPI_Language2),
			PPI.PPI_Language3		=ISNULL(POI.Language3,PPI.PPI_Language3),
			PPI.PPI_MediCalID		=ISNULL(POI.MediCalID,PPI.PPI_MediCalID),
			PPI.PPI_MedicareID		=ISNULL(POI.MedicareID,PPI.PPI_MedicareID),
			PPI.PPI_Ethnicity		=ISNULL(POI.Ethnicity,PPI.PPI_Ethnicity)
			From @ProviderInfo as POI 
			join Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI on POI.ProviderID = PPI.PPI_ID	
	END TRY

	BEGIN CATCH
		INSERT into changed.DirectoryUpdateLog 	
		SELECT @DataLogRecordID,'Tbl_Provider_ProviderInfo',DL.ChangedFieldName,GETDATE(),'Failed',ERROR_MESSAGE(),ERROR_LINE(),'Error updating ProviderInfo table'
		FROM @ProviderDataLog Dl WHERE DL.ChangedFieldName in ('MiddleName','Gender','NPI','License','CCS','ProviderEmail','Language1','Language2','Language3','LanguageDesc','MediCalID','MediCareID','Ethnicity');

		SET @UpdateFailedCount = @UpdateFailedCount + 1;

	END CATCH

		/*** After successful update this block will log the Table name, field and DataLogRecord id with Status= Completed in ProviderSearchCore.changed.DirectoryUpdateLog table ***/ 
		Insert into changed.DirectoryUpdateLog 
		select distinct DL.DataLogRecordID ,'Tbl_Provider_ProviderInfo', DL.ChangedFieldName,@now,
							Case when  DL.ChangedFieldName = 'MiddleName' and PPI.PPI_MiddleName = POI.MiddleName THEN  'Completed' 
							 when  PPI.PPI_Gender = POI.Gender and DL.ChangedFieldName = 'Gender' THEN  'Completed' 
							 when PPI.PPI_UPIN = POI.NPI and DL.ChangedFieldName = 'NPI' THEN  'Completed' 
							 when PPI.PPI_License = POI.License and DL.ChangedFieldName = 'License' THEN  'Completed' 
							 when PPI.PPI_CCS = POI.CCS and DL.ChangedFieldName = 'CCS' THEN  'Completed' 
							 when PPI.PPI_Email = POI.Email and DL.ChangedFieldName in('ProviderEmail') THEN  'Completed' 
							 when PPI.PPI_Language1  in(POI.Language1,POI.Language3,POI.Language3) and DL.ChangedFieldName in('Language1','LanguageDesc') THEN  'Completed' 
							 when PPI.PPI_Language2  in(POI.Language1,POI.Language3,POI.Language3) and DL.ChangedFieldName in('Language2','LanguageDesc') THEN  'Completed' 
							 when PPI.PPI_Language3 in(POI.Language1,POI.Language3,POI.Language3) and DL.ChangedFieldName in('Language3','LanguageDesc') THEN  'Completed' 
							 when PPI.PPI_MediCalID = POI.MediCalID and DL.ChangedFieldName = 'MediCalID' THEN  'Completed' 
							 when PPI.PPI_MedicareID = POI.MedicareID and DL.ChangedFieldName = 'MedicareID' THEN  'Completed' 
							 when PPI.PPI_Ethnicity = POI.Ethnicity and DL.ChangedFieldName = 'Ethnicity' THEN  'Completed' 
						else 'Failed' end as Status
		,null,null,null
		from changed.DataLog as DL with (nolock)
			Inner Join search.Provider as P with (nolock) on DL.TablePKFiedName = 'ProviderID' and DL.TablePKFieldValue = P.ProviderID  
			Inner join @ProviderInfo as POI on POI.ProviderID = P.NetDevProvID
			inner join Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock) on POI.ProviderID = PPI.PPI_ID 
		where DL.DataLogRecordID = @DataLogRecordID and DL.LogType like '%Auto%'
		and DL.ChangedFieldName in ('MiddleName','Gender','NPI','License','CCS','ProviderEmail','Language1','Language2','Language3','LanguageDesc','MediCalID','MediCareID','Ethnicity')
		AND @DataLogRecordID NOT IN (SELECT DISTINCT DatalogRecordID FROM changed.DirectoryUpdateLog WITH (nolock) WHERE UpdatedTable = 'Tbl_Provider_ProviderInfo');
		
/*****************************************************************************************/


/*****************************************************************************************/


	BEGIN TRY																											

		/*** Update Software Name/ Drug Registration Info table	 ***/
		Update PDRI
		SET						   
			PDRI.PDRI_Eprescribe = ISNULL(DRI.PDRI_Eprescribe,PDRI.PDRI_Eprescribe),
			PDRI.PDRI_Software	 = ISNULL(DRI.PDRI_Software,PDRI.PDRI_Software)
			From @DrugRegistrationInfo as DRI 
			join Network_Development.dbo.Tbl_Provider_DrugRegistrationInfo as PDRI  on PDRI.PDRI_ProviderID = DRI.ProviderID
	END TRY

	BEGIN CATCH

	INSERT into changed.DirectoryUpdateLog 	
		SELECT @DataLogRecordID,'Tbl_Provider_DrugRegistrationInfo',DL.ChangedFieldName,GETDATE(),'Failed',ERROR_MESSAGE(),ERROR_LINE(),'Error updating DrugInfo table'
		FROM @ProviderDataLog Dl WHERE DL.ChangedFieldName  IN ('Eprescibe','Software')

		SET @UpdateFailedCount = @UpdateFailedCount + 1;

	END CATCH

		Insert into changed.DirectoryUpdateLog 
		select DL.DataLogRecordID ,'Tbl_Provider_DrugRegistrationInfo', DL.ChangedFieldName,@now,
		Case when Dl.ChangedFieldName = 'Eprescribe' and PDRI.PDRI_Eprescribe = DRI.PDRI_Eprescribe then 'Completed'
							  when dl.ChangedFieldName = 'Software' and PDRI.PDRI_Software = DRI.PDRI_Software then 'Completed'
								else 'Failed' end as Status
		,null,null,null
		from changed.DataLog as DL with (nolock)
			Inner Join search.Provider as P with (nolock) on DL.TablePKFiedName = 'ProviderID' and DL.TablePKFieldValue = P.ProviderID  
			Inner join @DrugRegistrationInfo as DRI on DRI.ProviderID = P.NetDevProvID
			inner join Network_Development.dbo.Tbl_Provider_DrugRegistrationInfo as PDRI with (nolock) on PDRI.PDRI_ProviderID = DRI.ProviderID
		where DL.DataLogRecordID = @DataLogRecordID and DL.LogType like '%Auto%' and DL.ChangedFieldName in ('Eprescribe','Software')
		AND @DataLogRecordID NOT IN (SELECT DISTINCT DatalogRecordID FROM changed.DirectoryUpdateLog WITH (nolock) WHERE UpdatedTable = 'Tbl_Provider_DrugRegistrationInfo');

/*****************************************************************************************/

END


																													
/*****************************************************************************************
	Update Location tables (Contract_Locations, Contract_CPL, Contract_LocationNumbers)
 ****************************************************************************************/
		IF(@ProviderType <> 'PHRM' or @ProviderType is null)							
	BEGIN

		BEGIN TRY					
			Insert into @ContractLocation
			select 
				DestinationID 
				,[OfficeEmail] 
				,[OfficeManager] 
				,Case when WalkIn in ('Yes','1','True') Then 1 else 0 end as Walkin
				,[Hours]
				,Case when ApptOnly in ('Yes','1','True') Then 1 else 0 end as ApptOnly
				,[Signage] 
				,Case when EMR in('Yes','1','True')  then -1 ELSE 0 END as EMR	
				,Null as EmrSystem
				,[ReferralFax]
				,[Website] 
				,Null as ClinicalLanguage
				,Null StaffLanguage
			from (
			select DestinationID,ChangedFieldName,ChangedNewValue
			 from @LocationDataLog DL
			) a
			pivot(max(ChangedNewValue) for ChangedFieldName in (OfficeEmail,OfficeManager,Walkin,Hours,ApptOnly,Signage,EMR,EMRSystem,ReferralFax,WebSite)) p
	END TRY

	BEGIN CATCH
		Insert into changed.DirectoryUpdateLog 	
		SELECT @DataLogRecordID,'Tbl_Contract_Locatoins',DL.ChangedFieldName,GETDATE(),'Failed',ERROR_MESSAGE(),ERROR_LINE(),'Bad data coming in'
		FROM @LocationDataLog Dl WHERE DL.ChangedFieldName IN ('Email','OfficeEmail','OfficeManager','Walkin','OfficeHOurs','HOurs','ApptOnly','AppointmentNeeded',
																											'BuildingSIgn','Signage','EMR','EMRSystem','ReferralFax','WebSite','Clinical Staff Language','Non-Clinical Staff Language');

		SET @UpdateFailedCount = @UpdateFailedCount + 1;

	END CATCH

/*****************************************************************************************
Get Address Language, Insert into Database list value and get the ID to update Contract Location Table
*****************************************************************************************/

		Insert into @AddressLanguage
	SELECT DISTINCT DL.DestinationID,
	'Clinical Staff Language' as PropertyName,
	Dl.ChangedNewValue AS PropertyValue
	FROM @LocationDataLog DL
	WHERE DL.ChangedFieldName in( 'Clinical Staff Language')

	Insert into @AddressLanguage
	SELECT DISTINCT DL.DestinationID,
	'Non-Clinical Staff Language' as PropertyName,
	Dl.ChangedNewValue AS PropertyValue
	FROM @LocationDataLog DL
	WHERE DL.ChangedFieldName in( 'Non-Clinical Staff Language')


/*****************************************************************************************
Insert langauge into NetDev DataBaseLIst value if language is not avaialble
*****************************************************************************************/
														
--set variable to get the value for maximum Id column from Database_listvalue table in NDDB becuase that table does not have an Identity column
	BEGIN TRY
		set @propertyValueCount = (select count(PropertyValue) from @AddressLanguage)
		if(@propertyValueCount	> 0)

		BEGIN

		set @dblv_Id = (Select Max(DBLV_ID + 1) from  Network_Development.dbo.Tbl_Database_ListValues with (nolock) where dblv_list = 95)

																										--Inser not clinical and clinical langauge if does not exists in NDDV
				Insert into Network_Development.dbo.Tbl_Database_ListValues
				(DBLV_ID,DBLV_List,DBLV_Value,DBLV_Abbreviation,DBLV_Notes,DBLV_Date,DBLV_TermDate)
				select @dblv_Id,95,PropertyValue,null,null,getdate(),null from Network_Development.dbo.Tbl_Database_ListValues LV 
				right join	@AddressLanguage al on DBLV_Value = PropertyValue and DBLV_List = 95 
				where  DBLV_Value is  null and PropertyName = 'Clinical Staff Language'-- and DBLV_List = 95 

		set @dblv_Id = (Select Max(DBLV_ID + 1) from  Network_Development.dbo.Tbl_Database_ListValues with (nolock) where dblv_list = 95)

				Insert into Network_Development.dbo.Tbl_Database_ListValues
				(DBLV_ID,DBLV_List,DBLV_Value,DBLV_Abbreviation,DBLV_Notes,DBLV_Date,DBLV_TermDate)
				select @dblv_Id,95,PropertyValue,null,null,getdate(),null from Network_Development.dbo.Tbl_Database_ListValues LV 
				right join	@AddressLanguage al on DBLV_Value = PropertyValue and DBLV_List = 95 
				where  DBLV_Value is  null and PropertyName = 'Non-Clinical Staff Language' --and DBLV_List = 95 
		END

	END TRY

	BEGIN CATCH
		set @UpdateFailedCount  = @UpdateFailedCount + 1 ;

			Insert into changed.DirectoryUpdateLog 	
				SELECT @DataLogRecordID,'Tbl_DatabaseList_Values','Clinical/Non Langauges',GETDATE(),'Failed',ERROR_MESSAGE(),ERROR_LINE(),'Error in Inserting New Values'
				FROM @ProviderLocationDataLog Dl
				WHERE DL.ChangedFieldName IN ('Clinical Staff LANGUAGE','Non-Clinical Staff Language')

				SET @UpdateFailedCount = @UpdateFailedCount + 1;

	END CATCH


/*****************************************************************************************/
									    	--Update @ContractLocation with Clinical and non clinical IDs


		Update CL
		set CL.ClinicalLanguage = LV.DBLV_ID,
			 CL.StaffLanguage = LV1.DBLV_ID
		from @ContractLocation CL 
		join @AddressLanguage AL on AL.LocationID = CL.LocationID
		left join Network_Development.dbo.Tbl_Database_ListValues LV with (nolock) on LV.DBLV_Value = AL.PropertyValue and AL.PropertyName = 'Clinical Staff Language' and LV.DBLV_List = 95
		left join Network_Development.dbo.Tbl_Database_ListValues LV1 with (nolock) on LV1.DBLV_Value = AL.PropertyValue and AL.PropertyName = 'Non-Clinical Staff Language' and LV1.DBLV_List = 95


/*****************************************************************************************/
	BEGIN TRY
		Insert into @ContractCPL																							--Insert changes in @ContractCPL		
		select 
		DestinationProviderID as ProviderID,			--ProviderID NetDev
		DestinationLocationID as LocationID,			--LocationID of NDDB
		Phone,
		Fax
		from (
		select DestinationProviderID,DestinationLocationID,ChangedFieldName,ChangedNewValue
		 from @ProviderLocationDataLog PCDL 
		) a
		pivot(max(ChangedNewValue) for ChangedFieldName in (ProviderID,LocationID,Phone,Fax)) p
		END TRY
		BEGIN CATCH
				Insert into changed.DirectoryUpdateLog 	
				SELECT @DataLogRecordID,'Tbl_Contract_CPL',DL.ChangedFieldName,GETDATE(),'Failed',ERROR_MESSAGE(),ERROR_LINE(),'Bad data coming in'
				FROM @ProviderLocationDataLog Dl WHERE DL.ChangedFieldName IN ('Phone','Fax') 
										

				SET @UpdateFailedCount = @UpdateFailedCount + 1;

	END CATCH


/*****************************************************************************************/
	BEGIN TRY

		Insert into @ContractLocationNumbers																				--Insert changes in @ContractCPL		
		select 
		DestinationProviderID as ProviderID,			--ProviderID NDDB
		DestinationLocationID as LocationID,		--LocationID of NDDB
		Phone,
		Fax
		from (
		select DestinationProviderID,DestinationLocationID,ChangedFieldName,ChangedNewValue
		 from @ProviderLocationDataLog PCDL 
		) a
		pivot(max(ChangedNewValue) for ChangedFieldName in (ProviderID,LocationID,Phone,Fax)) p
		END TRY
		BEGIN CATCH
				Insert into changed.DirectoryUpdateLog 	
				SELECT @DataLogRecordID,'Tbl_Contract_LocationsNumbers',DL.ChangedFieldName,GETDATE(),'Failed',ERROR_MESSAGE(),ERROR_LINE(),'Bad data coming in'
				FROM @ProviderLocationDataLog Dl WHERE Dl.ChangedFieldName IN ('Phone','Fax')

				SET @UpdateFailedCount = @UpdateFailedCount + 1;

	END CATCH

/*****************************************************************************************/
	BEGIN TRY																								--Update source : NDDB : Contract_Locations 
		Update CL
		SET
			CL.CL_Email				= ISNULL(COL.OfficeEmail,CL.CL_Email),
			CL.CL_OfficeManager		= ISNULL(COL.OfficeManager,CL.CL_OfficeManager),
			CL.CL_Walkin			= ISNULL(COL.WalkIn,Cl.CL_walkin),
			CL.CL_OfficeHOurs		= ISNULL(COL.OfficeHours,Cl.CL_OfficeHours),
			CL.CL_ApptOnly			= ISNULL(COL.ApptOnly,Cl.CL_ApptOnly),
			CL.CL_Signage			= ISNULL(COL.Signage,Cl.CL_Signage),
			CL.CL_EMR				= ISNULL(COL.EMR,Cl.CL_EMR),
			CL.CL_EMRSystem			= ISNULL(COL.EMRSystem,Cl.CL_EMRSystem),
			CL.CL_ReferralFax		= ISNULL(COL.ReferralFax,Cl.CL_ReferralFax),
			CL.CL_WebSite			= ISNULL(COL.Website,Cl.CL_Website),
			CL.CL_StaffLanguage     = ISNULL(COL.StaffLanguage,Cl.CL_StaffLanguage),
			CL.CL_ClinicalLanguage  = ISNULL(COL.ClinicalLanguage,Cl.CL_ClinicalLanguage)
			From @ContractLocation as COL
			join Network_Development.dbo.Tbl_Contract_Locations as CL on COL.LocationID = CL.CL_ID 
	END TRY
	BEGIN CATCH
		INSERT into changed.DirectoryUpdateLog 	
		SELECT @DataLogRecordID,'Tbl_Contract_Locations',DL.ChangedFieldName,GETDATE(),'Failed',ERROR_MESSAGE(),ERROR_LINE(),'Error updating ContractLocations table'
		FROM @LocationDataLog Dl WHERE Dl.ChangedFieldName IN ('Email','OfficeEmail','OfficeManager','Walkin','OfficeHOurs','HOurs','ApptOnly','AppointmentNeeded',
																											'BuildingSIgn','Signage','EMR','EMRSystem','ReferralFax','WebSite','Clinical Staff Language','Non-Clinical Staff Language');

		SET @UpdateFailedCount = @UpdateFailedCount + 1;

	END CATCH

		Insert into changed.DirectoryUpdateLog 
		select DL.DataLogRecordID ,'Tbl_Contract_Locations', DL.ChangedFieldName,@now,
		Case when DL.ChangedFieldName in ('Email','OfficeEmail') and Cl.CL_Email = COL.OfficeEmail then 'Completed'
							when DL.ChangedFieldName = 'OfficeManager' and Cl.CL_OfficeManager = COL.OfficeManager then 'Completed'
							when DL.ChangedFieldName = 'Walkin' and Cl.CL_WalkIn = COL.WalkIn then 'Completed'
							when Dl.ChangedFieldName in('OfficeHours','Hours') and Cl.CL_OfficeHours = COL.OfficeHours then 'Completed'
							when DL.ChangedFieldName in('ApptOnly','appointmentNeeded') and CL.CL_ApptOnly = COL.OfficeHours then 'Completed'
							when DL.ChangedFieldName in ('Signage','BuildingSign') and Cl.CL_Signage = COL.Signage then 'Completed'
							When Dl.ChangedFieldName = 'EMR' and CL.CL_EMR = COL.EMR then 'Completed'
							when DL.ChangedFieldName = 'EMRSystem' and Cl.CL_EMRSystem = COL.EMRSystem then 'Completed'
						when Dl.ChangedFieldName = 'ReferralFax' and Cl.CL_ReferralFax = COL.ReferralFax then 'Completed'
							When Dl.ChangedFieldName = 'WebSite' and Cl.CL_Website = col.Website  then 'Completed'
							When Dl.ChangedFieldName = 'Clinical Staff Language' and Cl.CL_ClinicalLanguage = col.ClinicalLanguage  then 'Completed'
							When Dl.ChangedFieldName = 'Non-Clinical Staff Language' and Cl.CL_StaffLanguage = col.StaffLanguage  then 'Completed'
							else 'Failed' END as Status
		,null,null,null
		From changed.DataLog as DL with (nolock)
			Inner Join search.Address as A with (nolock) on DL.TablePKFiedName = 'AddressID' and DL.TablePKFieldValue = A.AddressID
			Inner join @ContractLocation as COL on COL.LocationID = A.LocationID
			inner join Network_Development.dbo.Tbl_Contract_Locations as CL with (nolock) on Cl.CL_ID = COL.LocationID
			where  DL.DataLogRecordID = @DataLogRecordID and DL.LogType like '%Auto%' and DL.ChangedFieldName in ('Email','OfficeEmail','OfficeManager','Walkin','OfficeHOurs','HOurs','ApptOnly','AppointmentNeeded',
																													'BuildingSIgn','Signage','EMR','EMRSystem','ReferralFax','WebSite','Clinical Staff Language','Non-Clinical Staff Language')
				AND @DataLogRecordID NOT IN (SELECT DISTINCT DatalogRecordID FROM changed.DirectoryUpdateLog WITH (nolock) WHERE UpdatedTable = 'Tbl_Contract_Locations');

/*****************************************************************************************/

/*****************************************************************************************/
	BEGIN TRY																											--Update source : NDDB : Contract_CPL 
		Update CPL
		SET
			CPL.CCPL_Phone = ISNULL(UCPL.Phone,CPL.CCPL_Phone),
			CPL.CCPL_Fax   = ISNULL(UCPL.Fax,CPL.CCPL_Fax)
			From @ContractCPL as UCPL 
			join Network_Development.dbo.Tbl_Contract_CPL as CPL  on CPL.CCPL_ProviderID = UCPL.ProviderID and CPL.CCPL_LocationID = UCPL.LocationID
	END TRY

	BEGIN CATCH

		INSERT into changed.DirectoryUpdateLog 	
		SELECT @DataLogRecordID,'Tbl_Contract_CPL',DL.ChangedFieldName,GETDATE(),'Failed',ERROR_MESSAGE(),ERROR_LINE(),'Error updating ContractCPL table'
		FROM @LocationDataLog Dl WHERE Dl.ChangedFieldName IN ('Phone','Fax')

		SET @UpdateFailedCount = @UpdateFailedCount + 1;

	END CATCH


		Insert into changed.DirectoryUpdateLog 
		select DL.DataLogRecordID ,'Tbl_Contract_CPL', DL.ChangedFieldName,@now,
		Case when DL.ChangedFieldName = 'Phone' and CPL.CCPL_PHone = UCPL.Phone	Then 'Completed'
								when DL.ChangedFieldName = 'Fax' and CPL.CCPL_Fax = UCPL.Fax	Then 'Completed' else 'Failed' END as status
		,null,null,null
		From changed.DataLog as DL with (nolock)
			Inner Join search.Address as A with (nolock) on DL.TablePKFiedName = 'AddressID' and DL.TablePKFieldValue = A.AddressID
			inner join search.Provider as p with (nolock) on p.ProviderID = a.ProviderID 
			Inner join @ContractCPL as UCPL on UCPL.ProviderID = p.NetDevProvID and UCPL.LocationID = a.LocationID
			inner join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock) on CPL.CCPL_ProviderID = ucpl.ProviderID and CPL.CCPL_LocationID = ucpl.locationID
			where DL.DataLogRecordID = @DataLogRecordID and DL.LogType like '%Auto%' and DL.ChangedFieldName in ('Phone','Fax')
			AND @DataLogRecordID NOT IN (SELECT DISTINCT DatalogRecordID FROM changed.DirectoryUpdateLog WITH (nolock) WHERE UpdatedTable = 'Tbl_Contract_CPL');


/*****************************************************************************************/

/*****************************************************************************************/

	BEGIN TRY																											--Update source : NDDB : Contract_LocationsNumbers 
	Update CLNS
	SET
		CLNS.CLNS_Phone = ISNULL(CLN.Phone,CLNS.CLNS_Phone),
		CLNS.CLNS_Fax   = ISNULL(CLN.Fax,CLNS.CLNS_Fax)
		From @ContractLocationNumbers as CLN 
		join Network_Development.dbo.Tbl_Contract_LocationsNumbers as CLNS  on CLNS.CLNS_ProviderID = CLN.ProviderID and CLNS.CLNS_LocationID = CLN.LocationID

	END TRY

	BEGIN CATCH

		INSERT into changed.DirectoryUpdateLog 	
		SELECT @DataLogRecordID,'Tbl_Contract_LocationsNumbers',DL.ChangedFieldName,GETDATE(),'Failed',ERROR_MESSAGE(),ERROR_LINE(),'Error updating LocationNumber table'
		FROM @ProviderLocationDataLog Dl WHERE Dl.ChangedFieldName IN ('Phone','Fax')

		SET @UpdateFailedCount = @UpdateFailedCount + 1;

	END CATCH


		Insert into changed.DirectoryUpdateLog 
		select DL.DataLogRecordID ,'Tbl_Contract_LocationsNumbers', DL.ChangedFieldName,@now,
		Case when DL.ChangedFieldName = 'Phone' and CLNS.CLNS_Phone = CLN.Phone	Then 'Completed'
								when DL.ChangedFieldName = 'Fax' and CLNS.CLNS_Fax = CLN.Fax	Then 'Completed' else 'Failed' END as status
		,null,null,null
		From changed.DataLog as DL with (nolock)
			Inner Join search.Address as A with (nolock) on DL.TablePKFiedName = 'AddressID' and DL.TablePKFieldValue = A.AddressID
			inner join search.Provider as p with (nolock) on p.ProviderID = a.ProviderID 
			Inner join @ContractLocationNumbers as CLN on CLN.ProviderID = P.NetDevProvID and CLN.LocationID = a.LocationID
			inner join Network_Development.dbo.Tbl_Contract_LocationsNumbers as CLNS with (nolock) on CLNS.CLNS_ProviderID = CLN.ProviderID and CLNS.CLNS_LocationID = CLN.LocationID
			where DL.DataLogRecordID = @DataLogRecordID and DL.LogType like '%Auto%' and DL.ChangedFieldName in ('Phone','Fax')
			AND @DataLogRecordID NOT IN (SELECT DISTINCT DatalogRecordID FROM changed.DirectoryUpdateLog WITH (nolock) WHERE UpdatedTable = 'Tbl_Contract_LocationsNumbers');

/*****************************************************************************************/

END
 
/*=====================================================================================================================================================================================================*/
	
/*=====================================================================================================================================================================================================*/
--Update status
		Update DUL
		set SystemError = null,
			ErrorLIne = null,
			ManualError = null
			from changed.DirectoryUpdateLog as DUL  where Status = 'Completed'

		Update DLR												--UpDATE auto complete date in DataLogRecordTable
		set DLR.AutoUpdateCompletedTimeStamp =  UDL.UpdatedTime
		from changed.DirectoryUpdateLog as UDL with (nolock)
		join changed.DataLogRecord as DLR on DLR.DataLogRecordId = UDL.DataLogRecordID and UDL.DataLogRecordID = @DataLogRecordID
		where DLR.DataLogRecordId = @DataLogRecordID and UDL.UpdatedTime = (Select max(UpdatedTime) from changed.DirectoryUpdateLog as DLR with (nolock) where DLR.DataLogRecordID = @DataLogRecordID)

		Update DLR												--Update auto Complete status into DataLogRecordTable
		set DLR.AutoUpdateStatus = Case when (select count(distinct status) from ProviderSearchCore.changed.DirectoryUpdateLog DUL with (nolock) where DUL.DatalogRecordID = @DataLogRecordID and  Convert(date,DUL.UpdatedTime) = CONVERT (date, GETDATE())
								  group by DataLogRecordID) > 1
									then 'Partially Updated' else UDL.Status end 
		from changed.DirectoryUpdateLog as UDL with (nolock)
		join changed.DataLogRecord as DLR  on DLR.DataLogRecordId = UDL.DataLogRecordID and UDL.DataLogRecordID = @DataLogRecordID
		where DLR.DataLogRecordId = @DataLogRecordID and  Convert(date,UDL.UpdatedTime) = CONVERT (date, GETDATE())  


		Update DL																										--Set log type to Manual if error in updating the source
		set DL.Logtype = Case when (DL.DataLogRecordID = @DataLogRecordID and DUl.Status = 'Failed' and DUL.UpdatedField = DL.ChangedFieldName) then 'Manual Update' else DL.Logtype end
		from changed.DataLog DL  join changed.DirectoryUpdateLog as DUL with (nolock) on DUL.DataLogRecordID = DL.DataLogRecordId and DUL.UpdatedField = DL.ChangedFieldName
		WHERE Dl.DataLogRecordId = @DataLogRecordID AND DUL.DataLogRecordID = @DataLogRecordID


/*=====================================================================================================================================================================================================*/


--IF any field is not updated automatically and procedure did not throw any exception then get status from DirectoryUpdateLog table 

		IF((SELECT COUNT(DISTINCT Status) FROM changed.DirectoryUpdateLog WITH (nolock) WHERE DataLogRecordID = @DataLogRecordID AND Status = 'Failed') > 0)
		BEGIN
		set @UpdateFailedCount  = @UpdateFailedCount + 1 ;
		END


/*=====================================================================================================================================================================================================*/

																	--Return Status

		IF(@UpdateFailedCount > 0)
		BEGIN
		set @isProcessFailed = CAST(0 AS BIT)
		select  @isProcessFailed as Status
		END
		else
		BEgin
		set @isProcessFailed = 1
		Select @isProcessFailed as Status
		END
END

/*=====================================================================================================================================================================================================*/


/***************************************************/
	--unit test to Test Bad Data
/***************************************************/
/*
	DECLARE @DataLogRecordIDTest INT = 1658


	--set type to Auto if it was set Manual before by update failed
	UPDATE changed.DataLog
	SET LogType = 'Auto update'
	WHERE ChangedFieldName  IN ('MiddleName','Gender','NPI','License','CCS','ProviderEmail','Language1','Language2','Language3','LanguageDesc','MediCalID','MediCareID','Ethnicity','Email','OfficeEmail','OfficeManager','Walkin','OfficeHOurs','HOurs','ApptOnly','AppointmentNeeded',
	'BuildingSIgn','Signage','EMR','EMRSystem','ReferralFax','WebSite','Clinical Staff Language','Non-Clinical Staff Language','Phone','Fax')


	AND DataLogRecordId = @DataLogRecordIDTest;


	--Update values with random values
	UPDATE changed.DataLog
	SET ChangedNewValue = '111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
	11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
	111111111111111111111111111111111111111111111111111111111111111'
	WHERE DataLogRecordId = @DataLogRecordIDTest AND LogType LIKE '%Auto%'

	--Delete old entries in directory update log
	DELETE FROM changed.DirectoryUpdateLog WHERE DataLogRecordID = @DataLogRecordIDTest

	--execute the procedure
	EXEC changed.UpdateProviderDirectoryNDDB
		 @ProviderType = '',
	    @DataLogRecordID = @DataLogRecordIDTest
	

	--see status in directoryUpdateLog
	SELECT * FROM changed.DirectoryUpdateLog WITH (nolock) WHERE DataLogRecordID = @DataLogRecordIDTest


	--see log type in dataLog
	SELECT * FROM changed.DataLog WITH (NOLOCK) WHERE DataLogRecordId = @DataLogRecordIDTest
	
	*/

/*=====================================================================================================================================================================================================*/

/***************************************************/
	--unit test to Test User Permission Issue
/***************************************************/
/*
	USE ProviderSearchCore
	GO

	DECLARE @DataLogRecordIDTest INT = 1658


	--set type to Auto if it was set Manual before by update failed
	UPDATE changed.DataLog
	SET LogType = 'Auto update'
	WHERE ChangedFieldName  IN ('MiddleName','Gender','NPI','License','CCS','ProviderEmail','Language1','Language2','Language3','LanguageDesc','MediCalID','MediCareID','Ethnicity','Email','OfficeEmail','OfficeManager','Walkin','OfficeHOurs','HOurs','ApptOnly','AppointmentNeeded',
	'BuildingSIgn','Signage','EMR','EMRSystem','ReferralFax','WebSite','Clinical Staff Language','Non-Clinical Staff Language','Phone','Fax')
	AND DataLogRecordId = @DataLogRecordIDTest;


	
	--Update values with random values
	UPDATE changed.DataLog
	SET ChangedNewValue = '111'
	WHERE DataLogRecordId = @DataLogRecordIDTest AND LogType LIKE '%Auto%'

	--Delete old entries in directory update log
	DELETE FROM changed.DirectoryUpdateLog WHERE DataLogRecordID = @DataLogRecordIDTest
	

	--Deny Write Permissions To user
	EXECUTE Network_Development.sys.sp_droprolemember @rolename = 'db_DataWriter', --sysName
	    @membername = 'ProviderSearchUser' -- sysname

	--Change the User
	EXECUTE AS LOGIN = 'ProviderSearchUSer'

	--execute the procedure
	EXEC changed.UpdateProviderDirectoryNDDB
		 @ProviderType = '',
	    @DataLogRecordID = @DataLogRecordIDTest
	
	--see status in directoryUpdateLog
	SELECT * FROM changed.DirectoryUpdateLog WITH (nolock) WHERE DataLogRecordID = @DataLogRecordIDTest


	--see log type in dataLog
	SELECT * FROM changed.DataLog WITH (NOLOCK) WHERE DataLogRecordId = @DataLogRecordIDTest

	--Revert Login
	REVERT;

	--Grant permissions Again
	EXECUTE Network_Development.sys.sp_Addrolemember @rolename = 'db_DataWriter', --sysName
	    @membername = 'ProviderSearchUser' -- sysname



	--check if permissions are granted back
	IF(IS_ROLEMEMBER('db_dataWriter', 'ProviderSearchUser') = 1)
	BEGIN
	PRINT 'Permissions Granted'
	END


	*/
/*=====================================================================================================================================================================================================*/

			--	TEST to see what is inserted into table variables

--SELECT * FROM @DrugRegistrationInfo
--select * from @ProviderInfo
--select * from @ProviderDataLog
--select * from @ContractCPL
--select * from @ContractLocation
--select * from @ContractLocationNumbers
--select * from @LocationDataLog
--select * from @ProviderLocationDataLog		--need review
--select * from @AddressLanguage

--SELECT @UpdateFailedCount AS failedCount



 
 /*=====================================================================================================================================================================================================*/






GO
/****** Object:  StoredProcedure [GeoCode].[AuditGeoCodedAddressCount]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create procedure [GeoCode].[AuditGeoCodedAddressCount]
	@count int = 0
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
	/*
			Modification Log:
			
				08/08/2016   1.00  RK      Written Initial Stored Procedure.
				09/28/2016   1.01  RK      Updated versioning.	
		        
	*/

		declare @Version varchar(100) = '09/28/2016 15:30 Version 1.01'
		declare @ReturnValues table
			(
			 ReturnCode int primary key
							not null
			,Reason varchar(200) not null
			)

		insert into @ReturnValues
				(ReturnCode, Reason)
			values (0, 'Normal Return')

		if @Showversion = 1
			begin
				select object_schema_name(@@PROCId) as SchemaName
					   ,object_name(@@PROCId) as ProcedureName
					   ,@Version as VersionInformation
				if isnull(@ShowReturn, 0) = 0
					return 0
			end

		if @ShowReturn = 1
			begin
				select *
					from @ReturnValues
				return 0
			end

		set nocount on

		insert into geocode.GeocodeCountAudit
				(
				 GeocodeDateTime
				,GeocodedRecordsCount
				)
			values
				(
				 convert (date, getdate())
				,@count
				);

		return 0

	end



GO
/****** Object:  StoredProcedure [GeoCode].[GetGeoCodeAddressCountByDate]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create procedure [GeoCode].[GetGeoCodeAddressCountByDate]
	@date datetime = null
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin

		/*
			Modification Log:
			
				08/08/2016   1.00	RK      Written Initial Stored Procedure.
				09/28/2016   1.01	RK      Updated versioning.			        	
		        
		*/

		declare @Version varchar(100) = '09/28/2016 15:30 Version 1.01'
		declare @ReturnValues table
			(
			 ReturnCode int primary key
							not null
			,Reason varchar(200) not null
			)

		insert into @ReturnValues
				(ReturnCode, Reason)
			values (0, 'Normal Return')

		if @Showversion = 1
			begin
				select object_schema_name(@@PROCId) as SchemaName
					   ,object_name(@@PROCId) as ProcedureName
					   ,@Version as VersionInformation
				if isnull(@ShowReturn, 0) = 0
					return 0
			end

		if @ShowReturn = 1
			begin
				select *
					from @ReturnValues
				return 0
			end

		set nocount on

		select @date as GeocodedDateTime
			   ,sum(GeocodedRecordsCount) as GeoCodedAddressesCount
			   ,(100000 - sum(GeocodedRecordsCount)) as Remaining
			from geocode.GeocodeCountAudit
			where (GeocodeDateTime = @date)-- or (GeoCodedDateTime = GETDATE())

		return 0

	end


/*
            ____________
___________/ UNIT TESTS \________________________

DECLARE
@date datetime = '09/16/2016'

EXEC [GeoCode].GetGeoCodeAddressCountByDate
@date 



_________________________________________________

*/





GO
/****** Object:  StoredProcedure [GeoCode].[GetProviderAddressInformation]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [GeoCode].[GetProviderAddressInformation]  ---- temporary changes for production
	@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
				08/08/2016	1.00	RK		Created new procedure
				08/22/2016	1.01	RK		Converted all the Address details into Capital casing and merged the resultant changes
											into the targeted table.				
				09/27/2016	1.02	RK		Added versioning
                                            Added DateTime variable to store the present DateTime.
				09/28/2016	1.03	RK      Updated versioning.
							1.04	RK		Updated Stored Procedure and added method to retrieve new and stale Addresses.
				09/29/2016	1.05	RGB		Renamed procedure to be more reflective of content and reformatted for readability
				09/30/2016  1.06    RK      Changed all the source tables to import the data.
				10/03/2016	1.07	RK		Included Pharmacies to get the Pharmacy address details for geocoding. Populated Pharmacies addresses
											into the GeoCode.addresses table.
				10/03/2016	1.08	RK		Changed value for ProviderId for "Pharmacies" to NPI.
				10/03/2016	1.09	RK		Removed condition to check for termed providers for IPA.
				10/27/2016	1.10	RK		Removed conditions to eliminate termed providers.
				12/21/2016	1.11	RK		Removed conditions in the select statement which retrieves only the provider records 
											whose Status = 1 in "Network_Development.dbo.Tbl_Contract_ContractInfo" table and
											IEHP_Network = 1 in "Pharmacy.Pharmacy.dbo.IEHP_Pharmacy_Providers" table
		*/

		declare @Version varchar(100) = '12/21/2016 14:28 Version 1.11'
		declare @ReturnValues table
			(
			 ReturnCode int primary key
							not null
			,Reason varchar(200) not null
			)

		insert into @ReturnValues
				(ReturnCode, Reason)
			values (0, 'Normal Return')			
											
		if @Showversion = 1
			begin
				select object_schema_name(@@PROCId) as SchemaName
					   ,object_name(@@PROCId) as ProcedureName
					   ,@Version as VersionInformation
				if isnull(@ShowReturn, 0) = 0
					return 0
			end

		if @ShowReturn = 1
			begin
				select *
					from @ReturnValues
				return 0
			end

		set nocount on

		declare @provtemp table
			(
			 ProviderId varchar(12)
			,ProviderType varchar(12)
			,SeqNo varchar(5)
			,RowHash varbinary(16)
			,AddressId int
			,Address varchar(255)
			,Address2 varchar(60)
			,City varchar(30)
			,County varchar(50)
			,State varchar(12)
			,Zipcode varchar(9)
			)
		declare @provc as geocode.AllProviderAddresses
		declare @now datetime = getdate()
		   ,@bar char(1) = '|'		

		--      Gather all the providers from the different sources.
		insert into @provc
				(
				 ProviderID
				,ProviderType
				,SeqNo
				,Address
				,Address2
				,City
				,State
				,Zip
				,County
				)

			-- All PCP, NPCP, MPCP, TPCP from Diam_725_App Database
			select distinct F.PAPROVID as ProviderId
				   ,F.PATYPE as ProviderType
				   ,isnull(A.PCSEQNO, '') as SeqNo
				   ,isnull(A.PCADDR1, '') as Address
				   ,isnull(A.PCADDR2,'') as Address2
				   ,A.PCCITY as City
				   ,A.PCSTATE as State
				   ,A.PCZIP as Zip
				   ,ZC.OZCA_county as County
				from Diam_725_App.diamond.JPROVFM0_DAT F with (nolock)
					inner join Diam_725_App.diamond.JPROVAM0_DAT A with (nolock)
						on A.PCPROVID = F.PAPROVID
						   and A.PCTYPE = F.PATYPE
					inner join Diam_725_App.diamond.JPROVCM0_DAT C with (nolock)
						on C.PBPROVID = F.PAPROVID
					left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
						on ZC.OZCA_zip = substring(A.PCZIP, 1, 5)
				where F.PAPROVID not in ('000000000087', '000000000088', '000000000089', '000000099999')
					and F.PATYPE in ('PCP', 'NPCP', 'MPCP', 'TPCP')
					and isnull(A.PCADDR1, '') != ''
					and isnull(A.PCCITY, '') != ''
					and isnull(A.PCZIP, '') != ''
					and isnull(A.PCCOUNTY, '') != ''
			union

-- ANC/DANC providers from Contract_CPL
			select distinct                                                      -- ANC/DANC   
					cast(ppi.PPI_ID as varchar(12)) as ProviderId
				   ,PT.PPY_Code as ProviderType
				   ,isnull(cast(Locations.CL_ID as varchar(10)), '') as SeqNo
				   ,isnull(Locations.CL_Address1, '') as Address
				   ,isnull(Locations.CL_Address2,'') as Address2
				   ,Locations.CL_City as City
				   ,CL_State as State
				   ,Locations.CL_Zip as Zip
				   ,ZC.OZCA_county as County
				from Network_Development.dbo.Tbl_Contract_Locations as Locations with (nolock)
					inner join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
						on CPL.CCPL_LocationID = Locations.CL_ID
					inner join Network_Development.dbo.Tbl_Provider_ProviderInfo as ppi with (nolock)
						on CPL.CCPL_ProviderID = ppi.PPI_ID
					left join Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock)
						on CCI.CCI_ID = CPL.CCPL_ContractID
					left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
						on ZC.OZCA_zip = Locations.CL_Zip
					inner join Network_Development.dbo.Tbl_Provider_ProviderType as PT with (nolock)
						on PT.PPY_ID = ppi.PPI_Type
				where PT.PPY_ID in (17, 28)
					and (ppi.PPI_UPIN is not null)
					and (ppi.PPI_ID is not null)
			union

--All ANC from AncillaryRoster view	 
			select distinct cast(PPI.PPI_ID as varchar(12)) as ProviderId
				   ,PT.PPY_Code as ProviderType
				   ,isnull(cast(Locations.CL_ID as varchar(10)), '') as SeqNo
				   ,isnull(Locations.CL_Address1, '') as Address
				   ,isnull(Locations.CL_Address2, '') as Address2
				   ,Locations.CL_City as City
				   ,Locations.CL_State as State
				   ,Locations.CL_Zip as Zip
				   ,ZC.OZCA_county as County
				from Network_Development.dbo.vw_IEHP_Ancillary_Roster with (nolock)
					inner join Network_Development.dbo.Tbl_Contract_Locations as Locations with (nolock)
						on LocationID = Locations.CL_ID
					inner join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
						on CPL.CCPL_ContractID = ContractID
					left join Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
						on PPI.PPI_ID = CPL.CCPL_ProviderID
					left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
						on ZC.OZCA_zip = Locations.CL_Zip
					left join Network_Development.dbo.Tbl_Provider_ProviderType as PT with (nolock)
						on PT.PPY_ID = PPI.PPI_Type
				where isnull(LocationID, 0) != 0
					and isnull(ContractID, 0) != 0
					and CL_Address is not null
					and CL_City is not null
					and CL_State is not null
					and CL_Zip is not null
					and PT.PPY_ID in (17, 28)
					and (ppi.PPI_ID is not null)
			union

--All UC from Network_Development 
			select distinct isnull(CCI.CCI_ContractDiamondID, cast(CPL.CCPL_ProviderID as varchar(12))) as ProviderId
				   ,'UC' as ProviderType
				   ,isnull(cast(CL.CL_ID as varchar(10)), '') as SeqNo
				   ,isnull(CL.CL_Address1, '') as Address
				   ,isnull(CL.CL_Address2,'') as Address2
				   ,CL.CL_City as City
				   ,CL.CL_State as State
				   ,CL.CL_Zip as Zip
				   ,ZC.OZCA_county as County
				from Network_Development.dbo.Tbl_Contract_UC_new as UCN with (nolock)
					inner join Network_Development.dbo.Tbl_Contract_ContractInfo CCI with (nolock)
						on CCI.CCI_ID = UCN.ContractID
					inner join Network_Development.dbo.Tbl_Contract_CPL CPL with (nolock)
						on CPL.CCPL_ContractID = CCI.CCI_ID
					inner join Network_Development.dbo.Tbl_Contract_Locations as CL with (nolock)
						on UCN.LocationID = CL.CL_ID
					left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
						on ZC.OZCA_zip = CL.CL_Zip
			union 

-- all UC providers
			select distinct cast(pdna.PDNA_ProviderID as varchar(12)) as ProviderId
				   ,'UC' as ProviderType
				   ,isnull(cast(pdna.PDNA_LocationID as varchar(10)), '') as SeqNo
				   ,isnull(cl.CL_Address1, '') as Address
				   ,isnull(cl.CL_Address2, '') as Address2
				   ,cl.CL_City as City
				   ,cl.CL_State as State
				   ,cl.CL_Zip as Zip
				   ,ZC.OZCA_county as County
				from Network_Development.dbo.Tbl_Provider_DelegatedNetwork_Affiliation pdna --on pdna.PDNA_ProviderId = ppi.ppi_id
					inner join Network_Development.dbo.Tbl_Contract_Locations as cl
						on cl.CL_ID = pdna.PDNA_LocationID
					left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
						on ZC.OZCA_zip = cl.CL_Zip
				where pdna.PDNA_Specialty = 124
				and (pdna.PDNA_ProviderID is not null)
					
			union

--All SPEC,PCP/SPEC, BH from Network_Development
			select distinct cast(PP.PPI_ID as varchar(12)) as ProviderId
				   ,PT.PPY_Diamond as ProviderType
				   ,isnull(cast(Locations.CL_ID as varchar(10)), '') as SeqNo
				   ,isnull(Locations.CL_Address1, '') as Address
				   ,isnull(Locations.CL_Address2, '') as Address2
				   ,Locations.CL_City as City
				   ,Locations.CL_State as State
				   ,Locations.CL_Zip as Zip
				   ,ZC.OZCA_county as County
				from Network_Development.dbo.Tbl_Provider_ProviderInfo as PP with (nolock)
					join Network_Development.dbo.Tbl_Provider_ProviderAffiliation as PPA with (nolock)
						on PPA.PPA_ProviderID = PP.PPI_ID
					join Network_Development.dbo.Tbl_Contract_Locations as Locations with (nolock)
						on PPA.PPA_LocationID = Locations.CL_ID
					join Network_Development.dbo.Tbl_Provider_ProviderType as PT with (nolock)
						on PT.PPY_ID = PP.PPI_Type
					left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
						on ZC.OZCA_zip = Locations.CL_Zip
				where PP.PPI_Type in (1, 6, 12, 13, 27, 29) 
					and (PP.PPI_ID is not null)
				
				union

--All SPEC,PCP/SPEC, BH from Network_Development
	select distinct cast(PP.PPI_ID as varchar(12)) as ProviderId
				   ,PT.PPY_Diamond as ProviderType
				   ,isnull(cast(Locations.CL_ID as varchar(10)), '') as SeqNo
				   ,isnull(Locations.CL_Address1, '') as Address
				   ,isnull(Locations.CL_Address2, '') as Address2
				   ,Locations.CL_City as City
				   ,Locations.CL_State as State
				   ,Locations.CL_Zip as Zip
				   ,ZC.OZCA_county as County
				from Network_Development.dbo.Tbl_Provider_ProviderInfo as PP with (nolock)
					 join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
						on CPL.CCPL_ProviderID = PP.PPI_ID
					join Network_Development.dbo.Tbl_Contract_Locations as Locations with (nolock)
						on CPL.CCPL_LocationID = Locations.CL_ID
					join Network_Development.dbo.Tbl_Provider_ProviderType as PT with (nolock)
						on PT.PPY_ID = PP.PPI_Type
					left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
						on ZC.OZCA_zip = Locations.CL_Zip
				where PP.PPI_Type in (1, 6, 12, 13, 27, 29)
					and (PP.PPI_ID is not null)
			union

--All IPA from Network_Development
			select distinct cast(PP.PPI_ID as varchar(12)) as ProviderId
				   ,PT.PPY_Diamond as ProviderType
				   ,isnull(cast(Locations.CL_ID as varchar(10)), '') as SeqNo
				   ,isnull(Locations.CL_Address1, '') as Address
				   ,isnull(Locations.CL_Address2,'') as Address2
				   ,Locations.CL_City as City
				   ,Locations.CL_State as State
				   ,Locations.CL_Zip as Zip
				   ,ZC.OZCA_county as County
				from Network_Development.dbo.Tbl_Provider_ProviderInfo as PP with (nolock)
					inner join Network_Development.dbo.Tbl_Provider_ProviderType as PT with (nolock)
						on PT.PPY_ID = PP.PPI_Type
					inner join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
						on CPL.CCPL_ProviderID = PP.PPI_ID
					inner join Network_Development.dbo.Tbl_Contract_Locations as Locations with (nolock)
						on CPL.CCPL_LocationID = Locations.CL_ID
					left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
						on Locations.CL_Zip = ZC.OZCA_zip
				where (PP.PPI_Type = 24)
					and (PP.PPI_ID is not null)
			union

--All LTSS from Network_Development
			select distinct cast(ppi.PPI_ID as varchar(12)) as ProviderId
				   ,'LTSS' as ProviderType
				   ,isnull(cast(Locations.CL_ID as varchar(10)), '') as SeqNo
				   ,isnull(Locations.CL_Address1, '') as Address
				   ,isnull(Locations.CL_Address2,'') as Address2
				   ,Locations.CL_City as City
				   ,Locations.CL_State as State
				   ,Locations.CL_Zip as Zip
				   ,ZC.OZCA_county as County
				from Network_Development.dbo.Tbl_Contract_Locations as Locations with (nolock)
					inner join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
						on CPL.CCPL_LocationID = Locations.CL_ID
					inner join Network_Development.dbo.Tbl_Provider_ProviderInfo as ppi with (nolock)
						on CPL.CCPL_ProviderID = ppi.PPI_ID
					inner join Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock)
						on CCI.CCI_ID = CPL.CCPL_ContractID
					left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
						on ZC.OZCA_zip = Locations.CL_Zip
				where (CCI.CCI_ContractTitle = 53)
					and (PPi.PPI_ID is not null)
					
			union

--All HOSP from Network_Development
			select distinct cast(PP.PPI_ID as varchar(12)) as ProviderId
				   ,'HOSP' as ProviderType
				   ,isnull(cast(Locations.CL_ID as varchar(10)), '') as SeqNo
				   ,isnull(Locations.CL_Address1, '') as Address
				   ,isnull(Locations.CL_Address2,'') as Address2
				   ,Locations.CL_City as City
				   ,Locations.CL_State as State
				   ,Locations.CL_Zip as Zip
				   ,ZC.OZCA_county as County
				from Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock)
					left join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
						on CCI.CCI_ID = CPL.CCPL_ContractID
					left join Network_Development.dbo.Tbl_Provider_ProviderInfo as PP with (nolock)
						on PP.PPI_ID = CPL.CCPL_ProviderID
					left join Network_Development.dbo.Tbl_Contract_Locations as Locations with (nolock)
						on Locations.CL_ID = CPL.CCPL_LocationID
					left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
						on ZC.OZCA_zip = Locations.CL_Zip
				where CCI.CCI_ContractType in (8, 9)					
					and PP.PPI_ID is not null
					
			union 

--All SNF from Network_Development
			select distinct cast(PPI.PPI_ID as varchar(12)) as ProviderId
				   ,'SNF' as ProviderType
				   ,isnull(cast(CL.CL_ID as varchar(10)), '') as SeqNo
				   ,isnull(CL.CL_Address1, '') as Address
				   ,isnull(CL.CL_Address2,'') as Address2
				   ,CL.CL_City as City
				   ,CL.CL_State as State
				   ,CL.CL_Zip as Zip
				   ,ZC.OZCA_county as County
				from Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
					inner join Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock)
						on CPL.CCPL_ContractID = CCI.CCI_ID
					inner join Network_Development.dbo.Tbl_Contract_Locations as CL with (nolock)
						on CPL.CCPL_LocationID = CL.CL_ID
					inner join Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
						on CPL.CCPL_ProviderID = PPI.PPI_ID
					left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
						on ZC.OZCA_zip = CL.CL_Zip
				where (
					   (CCI.CCI_ContractType = 17)
					   or (
						   CCI.CCI_ContractType = 18
						   and CCI.CCI_ContractTitle in (97, 30)
						  )
					  )
					and (PPI.PPI_ID is not null)
					
			union

--All VSN from "Network_Development.dbo.Tbl_Provider_ProviderAffiliation" table
			select distinct cast(PP.PPI_ID as varchar(12)) as ProviderId
				   ,'VSN' as ProviderType
				   ,isnull(cast(locations.CL_ID as varchar(10)), '') as SeqNo
				   ,isnull(locations.CL_Address1, '') as Address
				   ,isnull(locations.CL_Address2,'') as Address2
				   ,locations.CL_City as City
				   ,locations.CL_State as State
				   ,locations.CL_Zip as Zip
				   ,ZC.OZCA_county as County
				from Network_Development.dbo.Tbl_Provider_ProviderInfo as PP with (nolock)
					inner join Network_Development.dbo.Tbl_Provider_ProviderAffiliation as PPA with (nolock)
						on PP.PPI_ID = PPA.PPA_ProviderID
					inner join Network_Development.dbo.Tbl_Contract_Locations as locations with (nolock)
						on locations.CL_ID = PPA.PPA_LocationID
					left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
						on ZC.OZCA_zip = locations.CL_Zip
				where PP.PPI_Type in (15, 16)
					and (PP.PPI_ID is not null) 
					
			union
--All VSN from "Network_Development.dbo.Tbl_Contract_CPL" table
			select distinct cast(PP.PPI_ID as varchar(12)) as ProviderId
				   ,'VSN' as ProviderType
				   ,isnull(cast(locations.CL_ID as varchar(10)), '') as SeqNo
				   ,isnull(locations.CL_Address1, '') as Address
				   ,isnull(locations.CL_Address2,'') as Address2
				   ,locations.CL_City as City
				   ,locations.CL_State as State
				   ,locations.CL_Zip as Zip
				   ,ZC.OZCA_county as County
				from Network_Development.dbo.Tbl_Provider_ProviderInfo as PP with (nolock)
					inner join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
						on PP.PPI_ID = CPL.CCPL_ProviderID
					inner join Network_Development.dbo.Tbl_Contract_Locations as locations with (nolock)
						on locations.CL_ID = CPL.CCPL_LocationID
					left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
						on ZC.OZCA_zip = locations.CL_Zip
				where PP.PPI_Type in (15, 16)
					and (PP.PPI_ID is not null) 
					
			union

--NPP
			select distinct cast(PP.PPI_ID as varchar(12)) as ProviderId
				   ,'NPP' as ProviderType
				   ,isnull(cast(locations.CL_ID as varchar(10)), '') as SeqNo
				   ,isnull(locations.CL_Address1, '') as Address
				   ,isnull(locations.CL_Address2,'') as Address2
				   ,locations.CL_City as City
				   ,locations.CL_State as State
				   ,locations.CL_Zip as Zip
				   ,ZC.OZCA_county as County
				from Network_Development.dbo.Tbl_Provider_ProviderInfo as PP with (nolock)
					inner join Network_Development.dbo.Tbl_Provider_ProviderAffiliation as PPA with (nolock)
						on PP.PPI_ID = PPA.PPA_ProviderID
					inner join Network_Development.dbo.Tbl_Contract_Locations as locations with (nolock)
						on locations.CL_ID = PPA.PPA_LocationID
					left join Network_Development.dbo.Tbl_Contract_LocationsNumbers as LN with (nolock)
						on LN.CLNS_ProviderID = PP.PPI_ID
					left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
						on ZC.OZCA_zip = locations.CL_Zip
				where PP.PPI_Type in (5, 8, 9)
					and (PP.PPI_ID is not null)
			union

-- All PHARMACY providers
			select distinct cast(PH.NPI as varchar(12)) as ProviderId		--ph.id is unique id for each pharmacy in pharmacy table but this is not ned dev id
				   ,'PHRM' as ProviderType
				   ,isnull(cast(CL.CL_ID as varchar(10)), '') as SeqNo
				   ,PH.Address_1 as Address
				   ,'' as Address2
				   ,PH.City as City
				   ,PH.State as State
				   ,PH.Zip as Zip
				   ,ZC.OZCA_county as County
				from Pharmacy.Pharmacy.dbo.IEHP_Pharmacy_Providers as PH with (nolock)
					left join Network_Development.dbo.Tbl_Contract_Locations as CL with (nolock)
						on CL.CL_NPI = PH.NPI
					left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
						on ZC.OZCA_zip = PH.Zip
				where PH.NABP not in ('00000','99999')					   
				  and PH.NPI is not null


--      Update rowhash values for all of the providers 
		update @provc
			set	RowHash = hashbytes('MD5',
									ltrim(rtrim(upper(Address))) + @bar + isnull(ltrim(rtrim(upper(Address2))), '') + @bar + isnull(ltrim(rtrim(upper(City))),
																																	'') + @bar
									+ isnull(ltrim(rtrim(upper(State))), '') + @bar + isnull(Zip, ''))
			

		--      Go over each provider to check of changes, additions or no change situations
		insert into @provtemp
				(
				 ProviderId
				,ProviderType
				,SeqNo
				,RowHash
				,AddressId
				,Address
				,Address2
				,City
				,County
				,State
				,Zipcode								  		
				)
			select distinct ProviderID
				   ,ProviderType
				   ,SeqNo
				   ,p.RowHash
				   ,isnull(a.AddressID, 0)
				   ,p.Address
				   ,p.Address2
				   ,p.City
				   ,p.County
				   ,p.State
				   ,p.Zip
				from @provc p
					left join geocode.Addresses a
						on p.RowHash = a.RowHash

		-- 1. If the addressid is not mapped to the provider in the [GeoCode].Providers table then inactivate the existing provider map and add the new map.
		-- Inactivate
		update pr
			set	pr.Active = 0
			from geocode.Providers pr
				join @provtemp t
					on pr.ProviderId = t.ProviderId
					   and pr.ProviderType = t.ProviderType
					   and pr.SeqNo = t.SeqNo
					   and pr.AddressID <> t.AddressId
			where t.AddressId <> 0     

		-- insert the new provider whose address already exist in addresses table
		insert geocode.Providers
				(
				 ProviderId
				,ProviderType
				,SeqNo
				,AddressID
				,Active	
				)
			select distinct t.ProviderId
				   ,t.ProviderType
				   ,t.SeqNo
				   ,t.AddressId
				   ,1 Active
				from @provtemp t
					left join geocode.Providers p
						on t.ProviderId = p.ProviderId
						   and t.ProviderType = p.ProviderType
						   and t.SeqNo = p.SeqNo
						   and t.AddressId = p.AddressID
				where p.ProviderId is null
					and t.AddressId <> 0

		-- Add the non existant address to the repository
		insert geocode.Addresses
				(
				 Address
				,Address2
				,City
				,County
				,State
				,Zipcode
				,RowHash
				,IsAddressNew
				)
			select distinct t.Address
				   ,t.Address2
				   ,t.City
				   ,t.County
				   ,t.State
				   ,t.Zipcode
				   ,t.RowHash
				   ,1
				from @provtemp t
				where t.AddressId = 0
					and (
						 (t.Address is not null)
						 or (t.Address <> '')
						)
					and (
						 (t.City is not null)
						 or (t.City <> '')
						)
					and (
						 (t.Zipcode is not null)
						 or (t.Zipcode <> '')
						)
			  
		--update provtemp with addressId after inserting new addresses
		update t
			set	t.AddressId = a.AddressID
			from @provtemp t
				inner join geocode.Addresses a
					on a.RowHash = t.RowHash
			where t.AddressId = 0
				and (
					 (t.Address is not null)
					 or (t.Address <> '')
					)
				and (
					 (t.City is not null)
					 or (t.City <> '')
					)
				and (
					 (t.Zipcode is not null)
					 or (t.Zipcode <> '')
					)
			  
		-- Now add the new providers with new address.
		insert geocode.Providers
				(
				 ProviderId
				,ProviderType
				,SeqNo
				,AddressID
				,Active
				)
			select distinct t.ProviderId
				   ,t.ProviderType
				   ,t.SeqNo
				   ,t.AddressId
				   ,1 Active
				from @provtemp t
					left join geocode.Providers p
						on t.ProviderId = p.ProviderId
						   and t.ProviderType = p.ProviderType
						   and t.SeqNo = p.SeqNo
				where p.ProviderId is null
					and t.AddressId <> 0

		-- Now, Retrieve new Address records and Address records which are GeoCoded before 3 months. 
		select a.AddressID
			   ,a.Address
			   ,a.Address2
			   ,a.City
			   ,a.State
			   ,a.Zipcode
			   ,a.County
			from geocode.Addresses a with (nolock)
				left join geocode.GeocodedAddresses ga with (nolock)
					on a.GeoAddressID = ga.GeoAddressID
			where a.IsAddressNew = 1
				or a.GeoAddressID is null
				--or ((datediff(month, ga.GeocodedDateTime, @now)) = 3)
			order by AddressID
		return 0

	end


GO
/****** Object:  StoredProcedure [GeoCode].[getReport]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [GeoCode].[getReport]
	@ProviderId varchar(30) = null
   ,@ProviderType varchar(30) = null
   ,@Accuracy int = null
   ,@IsResultSame bit = null
   ,@GeoCodeDateTime date = null
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin

		/*
			Modification Log:
			
				08/08/2016   1.00  RK      Written Initial Stored Procedure.	
		        09/27/2016   1.01  RK      Added @ShowReturn and return code reason table. Updated "IsResultSame" condition.
				09/28/2016   1.02  RK      Updated versioning.
		*/
		declare @Version varchar(100) = '09/28/2016 15:30 Version 1.02'
		declare @ReturnValues table
			(
			 ReturnCode int primary key
							not null
			,Reason varchar(200) not null
			)

		insert into @ReturnValues
				(ReturnCode, Reason)
			values (0, 'Normal Return')

		if @Showversion = 1
			begin
				select object_schema_name(@@PROCId) as SchemaName
					   ,object_name(@@PROCId) as ProcedureName
					   ,@Version as VersionInformation
				if isnull(@ShowReturn, 0) = 0
					return 0
			end

		if @ShowReturn = 1
			begin
				select *
					from @ReturnValues
				return 0
			end

		set nocount on


		select P.ProviderId
			   ,P.ProviderType
			   ,P.SeqNo
			   ,GA.GeocodedDateTime
			   ,A.Address
			   ,A.Address2
			   ,A.City
			   ,A.State
			   ,A.Zipcode
			   ,A.County
			   ,GA.Latitude
			   ,GA.Longitude
			   ,GA.Accuracy
			   ,A.IsResultSame
			   ,GA.GeoAddress
			   ,GA.GeoCity
			   ,GA.GeoState
			   ,GA.GeoZipcode
			   ,GA.GeoCounty
			from geocode.Providers as P with (nolock)
				inner join geocode.Addresses as A with (nolock)
					on P.AddressID = A.AddressID
				left join geocode.GeocodedAddresses as GA with (nolock)
					on A.GeoAddressID = GA.GeoAddressID
			where (
				   (P.ProviderId = @ProviderId)
				   or (@ProviderId is null)
				  )
				and (
					 (P.ProviderType = @ProviderType)
					 or (@ProviderType is null)
					)
				and (
					 (cast(GA.GeocodedDateTime as date) = @GeoCodeDateTime)
					 or (@GeoCodeDateTime is null)
					)
				and (
					 (GA.Accuracy = @Accuracy)
					 or (@Accuracy is null)
					)
				and (
					 (A.IsResultSame = @IsResultSame)
					 or (@IsResultSame is null)
					)

		return 0

	end

/*     ___________ 
______/ Unit Test \_________________________________________________________________ 
DECLARE

@ProviderId varchar(30) = null,
@ProviderType varchar(30) = null,
@Accuracy int = null,
@IsResultSame bit =null,
@GeoCodeDateTime DATE = '2016-09-29'

EXEC [GeoCode].getReport
@ProviderId,
@ProviderType,
@Accuracy,
@IsResultSame,
@GeoCodeDateTime
_____________________________________________________________________________________
*/






GO
/****** Object:  StoredProcedure [GeoCode].[MergeResultantAddresses]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [GeoCode].[MergeResultantAddresses]
	@ProviderGeoCodedAddressResults geocode.ProviderGeoAddresses readonly
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
				08/08/2016   1.00  RK      Written Initial Stored Procedure.	
		        09/27/2016   1.01  RK      Added @ShowReturn and return code reason table. Updated "IsResultSame" condition.
				09/28/2016   1.02  RK      Updated versioning.
				09/30/2016   1.03  RK      modified "[GeoCode].ProviderGeoAddresses" user defined table type.
		*/
		declare @Version varchar(100) = '09/30/2016 12:30 Version 1.03'
		declare @ReturnValues table
			(
			 ReturnCode int primary key
							not null
			,Reason varchar(200) not null
			)

		insert into @ReturnValues
				(ReturnCode, Reason)
			values (0, 'Normal Return')

		if @Showversion = 1
			begin
				select object_schema_name(@@PROCId) as SchemaName
					   ,object_name(@@PROCId) as ProcedureName
					   ,@Version as VersionInformation
				if isnull(@ShowReturn, 0) = 0
					return 0
			end

		if @ShowReturn = 1
			begin
				select *
					from @ReturnValues
				return 0
			end

		set nocount on

		--insert new records
		insert into geocode.GeocodedAddresses
				(
				 GeoAddress
				,GeoCity
				,GeoCounty
				,GeoState
				,GeoZipcode
				,Latitude
				,Longitude
				,Accuracy
				,GeocodedDateTime
				)
			select distinct isnull(pgc.GeocodedStreetNumber, '') + ' ' + isnull(pgc.GeocodedRoute, '')
				   ,pgc.GeocodedCity
				   ,pgc.GeocodedCounty
				   ,pgc.GeocodedState
				   ,pgc.GeocodedZip
				   ,pgc.Lat
				   ,pgc.Lng
				   ,pgc.Accuracy
				   ,getdate()
				from @ProviderGeoCodedAddressResults pgc
				where not exists ( select gca.Latitude
									   ,gca.Longitude
									from geocode.GeocodedAddresses gca
									where gca.Latitude = pgc.Lat
										and gca.Longitude = pgc.Lng )
					and Lat is not null
					and Lng is not null

--update existing records

		update target
			set	target.GeocodeResult = source.GeoCodeResult
			   ,target.IsAddressNew = 0
			   ,target.GeoAddressID = ga.GeoAddressID
			   ,target.IsResultSame = case when (
												 isnull(ga.GeoCity, '') = isnull(target.City, '')
												 and isnull(ga.GeoState, '') = isnull(target.State, '')
												 and isnull(ga.GeoZipcode, '') = substring(isnull(target.Zipcode, ''), 1, 5)
												) then 1
										   else 0
									  end
			from geocode.Addresses as target
				inner join @ProviderGeoCodedAddressResults as source
					on target.AddressID = source.AddressID
				inner join geocode.GeocodedAddresses as ga
					on source.Lat = ga.Latitude
					   and source.Lng = ga.Longitude
			where source.GeoCodeResult is not null
				and (
					 Lat is not null
					 or Lat <> ''
					)
				and (
					 Lng is not null
					 or Lng <> ''
					)

		return 0

	end


GO
/****** Object:  StoredProcedure [Import].[AddConstraints]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [Import].[AddConstraints]
AS

BEGIN

--		BEGIN TRAN


--DROP FK
---------------

ALTER TABLE [search].[Address]  WITH CHECK ADD  CONSTRAINT [FK_Search_Address_Provider] FOREIGN KEY([ProviderID])
REFERENCES [search].[Provider] ([ProviderID])
--GO

ALTER TABLE [search].[Address] CHECK CONSTRAINT [FK_Search_Address_Provider]
--GO

----------------------
ALTER TABLE [search].[Affiliation]  WITH CHECK ADD  CONSTRAINT [FK_Search_Affiliation_Provider] FOREIGN KEY([ProviderID])
REFERENCES [search].[Provider] ([ProviderID])
--GO

ALTER TABLE [search].[Affiliation] CHECK CONSTRAINT [FK_Search_Affiliation_Provider]
--GO

-----------------------------------------------------------

ALTER TABLE [search].[AffiliationExtendedProperties]  WITH CHECK ADD  CONSTRAINT [FK_Search_AffiliationExtendedProperties_Affilation] FOREIGN KEY([AffilationID])
REFERENCES [search].[Affiliation] ([AffiliationID])
--GO

ALTER TABLE [search].[AffiliationExtendedProperties] CHECK CONSTRAINT [FK_Search_AffiliationExtendedProperties_Affilation]
--GO

----------------------------------------------------

ALTER TABLE [search].[ProviderAffiliationAddress]  WITH CHECK ADD  CONSTRAINT [FK_Search_ProviderAffilationAddress_Address] FOREIGN KEY([AddressID])
REFERENCES [search].[Address] ([AddressID])
--GO

ALTER TABLE [search].[ProviderAffiliationAddress] CHECK CONSTRAINT [FK_Search_ProviderAffilationAddress_Address]
--GO

-----------------------------------------------------------
ALTER TABLE [search].[ProviderAffiliationAddress]  WITH CHECK ADD  CONSTRAINT [FK_Search_ProviderAffilationAddress_Affiliation] FOREIGN KEY([AffiliationID])
REFERENCES [search].[Affiliation] ([AffiliationID])
--GO

ALTER TABLE [search].[ProviderAffiliationAddress] CHECK CONSTRAINT [FK_Search_ProviderAffilationAddress_Affiliation]
--GO


----------------------------------------------------------
ALTER TABLE [search].[ProviderAffiliationAddress]  WITH CHECK ADD  CONSTRAINT [FK_Search_ProviderAffilationAddress_Provider] FOREIGN KEY([ProviderID])
REFERENCES [search].[Provider] ([ProviderID])
--GO

ALTER TABLE [search].[ProviderAffiliationAddress] CHECK CONSTRAINT [FK_Search_ProviderAffilationAddress_Provider]
--GO
-------------------------------------------------------------
ALTER TABLE [search].[ProviderExtendedProperties]  WITH CHECK ADD  CONSTRAINT [FK_Search_ProviderExtendedProperties_Provider] FOREIGN KEY([ProviderID])
REFERENCES [search].[Provider] ([ProviderID])
--GO

ALTER TABLE [search].[ProviderExtendedProperties] CHECK CONSTRAINT [FK_Search_ProviderExtendedProperties_Provider]
--GO
--------------------------------------------------------
ALTER TABLE [search].[ProviderSpecialty]  WITH CHECK ADD  CONSTRAINT [FK_Search_ProviderSpecialty_Affiliation] FOREIGN KEY([AffiliationID])
REFERENCES [search].[Affiliation] ([AffiliationID])
--GO

ALTER TABLE [search].[ProviderSpecialty] CHECK CONSTRAINT [FK_Search_ProviderSpecialty_Affiliation]
--GO

--------------------
ALTER TABLE [search].[AddressLanguage]  WITH CHECK ADD  CONSTRAINT [FK_Search_AddressLanguage_Address] FOREIGN KEY([AddressID])
REFERENCES [search].[Address] ([AddressID])
--GO

ALTER TABLE [search].[AddressLanguage] CHECK CONSTRAINT [FK_Search_AddressLanguage_Address]
--GO
----------------------------
ALTER TABLE [search].[AddressLanguage]  WITH CHECK ADD  CONSTRAINT [FK_Search_AddressLanguage_Languages] FOREIGN KEY([LanguageID])
REFERENCES [search].[Languages] ([LanguageID])
--GO

ALTER TABLE [search].[AddressLanguage] CHECK CONSTRAINT [FK_Search_AddressLanguage_Languages]
--GO
-------------------------------------
ALTER TABLE [search].[ProviderLanguage]  WITH CHECK ADD  CONSTRAINT [FK_Search_ProviderLanguage_Languages] FOREIGN KEY([LanguageID])
REFERENCES [search].[Languages] ([LanguageID])
--GO

ALTER TABLE [search].[ProviderLanguage] CHECK CONSTRAINT [FK_Search_ProviderLanguage_Languages]
--GO

--------------------
ALTER TABLE [search].[ProviderSpecialty]  WITH CHECK ADD  CONSTRAINT [FK_Search_ProviderSpecialty_Provider] FOREIGN KEY([ProviderID])
REFERENCES [search].[Provider] ([ProviderID])
--GO

ALTER TABLE [search].[ProviderSpecialty] CHECK CONSTRAINT [FK_Search_ProviderSpecialty_Provider]
--GO


----------------------
ALTER TABLE [search].[ProviderSpecialty]  WITH CHECK ADD  CONSTRAINT [FK_Search_ProviderSpecialty_Specialty] FOREIGN KEY([SpecialtyID])
REFERENCES [search].[Specialty] ([SpecialtyID])
--GO

ALTER TABLE [search].[ProviderSpecialty] CHECK CONSTRAINT [FK_Search_ProviderSpecialty_Specialty]
--GO

-------------------------
ALTER TABLE [search].[ProviderLanguage]  WITH CHECK ADD  CONSTRAINT [FK_Search_ProviderLanguage_Provider] FOREIGN KEY([ProviderID])
REFERENCES [search].[Provider] ([ProviderID])
----

ALTER TABLE [search].[ProviderLanguage] CHECK CONSTRAINT [FK_Search_ProviderLanguage_Provider]
--GO

-----------------
ALTER TABLE [search].[AddressExtendedProperties]  WITH CHECK ADD  CONSTRAINT [FK_Search_AddressExtendedProperties_Address] FOREIGN KEY([AddressID])
REFERENCES [search].[Address] ([AddressID])

ALTER TABLE [search].[AddressExtendedProperties] CHECK CONSTRAINT [FK_Search_AddressExtendedProperties_Address]

--------------
--------
ALTER TABLE [search].[ExcludedAddresses]  WITH CHECK ADD  CONSTRAINT [FK__ExcludedA__Exclu__59063A47] FOREIGN KEY([AddressID])
REFERENCES [search].[Address] ([AddressID])

ALTER TABLE [search].[ExcludedAddresses] CHECK CONSTRAINT [FK__ExcludedA__Exclu__59063A47]
-----------

ALTER TABLE [search].[ExcludedAffiliations]  WITH CHECK ADD  CONSTRAINT [FK__ExcludedA__Exclu__5AEE82B9] FOREIGN KEY([AffiliationID])
REFERENCES [search].[Affiliation] ([AffiliationID])

ALTER TABLE [search].[ExcludedAffiliations] CHECK CONSTRAINT [FK__ExcludedA__Exclu__5AEE82B9]

------------------------------

ALTER TABLE [search].[ExcludedProviders]  WITH CHECK ADD  CONSTRAINT [FK__ExcludedP__Exclu__571DF1D5] FOREIGN KEY([ProviderId])
REFERENCES [search].[Provider] ([ProviderID])

ALTER TABLE [search].[ExcludedProviders] CHECK CONSTRAINT [FK__ExcludedP__Exclu__571DF1D5]




END



GO
/****** Object:  StoredProcedure [Import].[DropConstraints]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [Import].[DropConstraints]
		@truncate	bit = 0
AS

BEGIN

--		BEGIN TRAN


--DROP FK
---------------
IF (OBJECT_ID('search.[FK_Search_Address_Provider]', 'F') IS NOT NULL )
	ALTER TABLE [search].[Address] DROP CONSTRAINT [FK_Search_Address_Provider]
--GO
---------------------------------------
IF (OBJECT_ID('search.[FK_Search_AddressLanguage_Address]', 'F') IS NOT NULL )
ALTER TABLE [search].[AddressLanguage] DROP CONSTRAINT [FK_Search_AddressLanguage_Address]
--GO
----------------------------
IF (OBJECT_ID('search.[FK_Search_AddressLanguage_Languages]', 'F') IS NOT NULL )
ALTER TABLE [search].[AddressLanguage] DROP CONSTRAINT [FK_Search_AddressLanguage_Languages]
--GO
------------------------------------------------------
IF (OBJECT_ID('search.[FK_Search_Affiliation_Provider]', 'F') IS NOT NULL )
ALTER TABLE [search].[Affiliation] DROP CONSTRAINT [FK_Search_Affiliation_Provider]
--GO
----------------------
IF (OBJECT_ID('search.[FK_Search_AffiliationExtendedProperties_Affilation]', 'F') IS NOT NULL )
ALTER TABLE [search].[AffiliationExtendedProperties] DROP CONSTRAINT [FK_Search_AffiliationExtendedProperties_Affilation]
--GO
-----------------
IF (OBJECT_ID('search.[FK_Search_ProviderAffilationAddress_Address]', 'F') IS NOT NULL )
ALTER TABLE [search].[ProviderAffiliationAddress] DROP CONSTRAINT [FK_Search_ProviderAffilationAddress_Address]
--GO
------------------
IF (OBJECT_ID('search.[FK_Search_ProviderAffilationAddress_Affiliation]', 'F') IS NOT NULL )
ALTER TABLE [search].[ProviderAffiliationAddress] DROP CONSTRAINT [FK_Search_ProviderAffilationAddress_Affiliation]
--GO
---------------------------------
IF (OBJECT_ID('search.[FK_Search_ProviderAffilationAddress_Provider]', 'F') IS NOT NULL )
ALTER TABLE [search].[ProviderAffiliationAddress] DROP CONSTRAINT [FK_Search_ProviderAffilationAddress_Provider]
--GO
---------------------------------------
IF (OBJECT_ID('search.[FK_Search_ProviderExtendedProperties_Provider]', 'F') IS NOT NULL )
ALTER TABLE [search].[ProviderExtendedProperties] DROP CONSTRAINT [FK_Search_ProviderExtendedProperties_Provider]
--GO
--------------------------------------------
IF (OBJECT_ID('search.[FK_Search_ProviderLanguage_Provider]', 'F') IS NOT NULL )
ALTER TABLE [search].[ProviderLanguage] DROP CONSTRAINT [FK_Search_ProviderLanguage_Provider]
--GO
----------------------------------
IF (OBJECT_ID('search.[FK_Search_ProviderLanguage_Languages]', 'F') IS NOT NULL )
ALTER TABLE [search].[ProviderLanguage] DROP CONSTRAINT [FK_Search_ProviderLanguage_Languages]
--GO
-------------------------------------------
IF (OBJECT_ID('search.[FK_Search_ProviderSpecialty_Affiliation]', 'F') IS NOT NULL )
ALTER TABLE [search].[ProviderSpecialty] DROP CONSTRAINT [FK_Search_ProviderSpecialty_Affiliation]
--GO
-----------------------

IF (OBJECT_ID('search.[FK_Search_ProviderSpecialty_Provider]', 'F') IS NOT NULL )
ALTER TABLE [search].[ProviderSpecialty] DROP CONSTRAINT [FK_Search_ProviderSpecialty_Provider]
--GO
-----------------------

IF (OBJECT_ID('search.[FK_Search_ProviderSpecialty_Specialty]', 'F') IS NOT NULL )
ALTER TABLE [search].[ProviderSpecialty] DROP CONSTRAINT [FK_Search_ProviderSpecialty_Specialty]
--GO


IF (OBJECT_ID('search.[FK_Search_AddressExtendedProperties_Address]', 'F') IS NOT NULL )
ALTER TABLE [search].AddressExtendedProperties DROP CONSTRAINT [FK_Search_AddressExtendedProperties_Address]

----------


IF (OBJECT_ID('search.[FK__ExcludedA__Exclu__59063A47]', 'F') IS NOT NULL )
ALTER TABLE [search].[ExcludedAddresses] DROP CONSTRAINT [FK__ExcludedA__Exclu__59063A47]

-------------
IF (OBJECT_ID('search.[FK__ExcludedA__Exclu__5AEE82B9]', 'F') IS NOT NULL )
ALTER TABLE [search].[ExcludedAffiliations] DROP CONSTRAINT [FK__ExcludedA__Exclu__5AEE82B9]
--------------

IF (OBJECT_ID('search.[FK__ExcludedP__Exclu__571DF1D5]', 'F') IS NOT NULL )
ALTER TABLE [search].[ExcludedProviders] DROP CONSTRAINT [FK__ExcludedP__Exclu__571DF1D5]


----------------
if (@truncate = 1)
BEGIN

			TRUNCATE TABLE [search].AddressLanguage

			TRUNCATE TABLE [search].ProviderSpecialty

			TRUNCATE TABLE [search].ProviderExtendedProperties

			TRUNCATE TABLE [search].AffiliationExtendedProperties

			TRUNCATE TABLE [search].ProviderLanguage

			TRUNCATE TABLE [search].ProviderAffiliationAddress

			TRUNCATE TABLE [search].Languages
			
			TRUNCATE TABLE [search].Specialty

			TRUNCATE TABLE [search].Address

			TRUNCATE TABLE [search].Affiliation

			TRUNCATE TABLE [search].Provider

			TRUNCATE TABLE Search.ExcludedAddresses
			TRUNCATE TABLE Search.ExcludedProviders
			TRUNCATE TABLE Search.ExcludedAffiliations
END
			
		--commit tran
		--Rollback tran
------------------------
--ADD FK
--------------------
END



GO
/****** Object:  StoredProcedure [Import].[InsertDataIntegrationTime]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Sheetal Soni
-- Create date: 9/23/2016
-- Description:	Procedure to track when the data was refreshed
-- =============================================
CREATE PROCEDURE [Import].[InsertDataIntegrationTime] 
	-- Add the parameters for the stored procedure here
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

    -- Insert statements for procedure here
        INSERT  INTO [search].DataIntegrationAudit
                ( Date )
        VALUES  ( GETDATE() );



		--Delete last Months Audit
        DELETE  FROM search.DataIntegrationAudit
        WHERE   DATEPART(m, Date) = DATEPART(m, DATEADD(m, -1, GETDATE()))
                AND DATEPART(yyyy, Date) = DATEPART(yyyy,
                                                    DATEADD(m, -1, GETDATE()));



		--Delete 1 month old records from IntegrationProcessAUdit Table
		
	IF OBJECT_ID(N'import.IntegrationProcessAudit', N'U') IS NOT NULL
BEGIN
		  DELETE  FROM import.IntegrationProcessAudit
			 WHERE   DATEPART(m, UpdateDate) = DATEPART(m, DATEADD(m, -1, GETDATE()))
                AND DATEPART(yyyy, UpdateDate) = DATEPART(yyyy,
                                     DATEADD(m, -1, GETDATE()));
END

    END;



GO
/****** Object:  StoredProcedure [Import].[MergeAddressProviderAffiliation]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

------------
CREATE Procedure [Import].[MergeAddressProviderAffiliation]
	@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
				10/03/2016		SS		Added delete statements to delete child table data.
		*/
		declare @now date = getdate()
		declare @Version varchar(100) = '10/03/2016 2:22 Version 1.00'
		declare @ReturnValues table
			(
			 ReturnCode int primary key
							not null
			,Reason varchar(200) not null
			)

		insert into @ReturnValues
				(ReturnCode, Reason)
			values (0, 'Normal Return')			
											
		if @Showversion = 1
			begin
				select object_schema_name(@@PROCId) as SchemaName
					   ,object_name(@@PROCId) as ProcedureName
					   ,@Version as VersionInformation
				if isnull(@ShowReturn, 0) = 0
					return 0
			end

		if @ShowReturn = 1
			begin
				select *
					from @ReturnValues
				return 0
			end

		set nocount on

		begin
			if object_id('tempdb..#APF') is not null
				drop table #APF

			create table #APF
				(
				 AddressId int not null
				,ProviderId int null
				,AffiliationId int null
				)

			insert into #APF
				select distinct a.AddressId
					   ,P.ProviderId
					   ,af.AffiliationId
					from Search.Provider as P with (nolock)
						inner join Search.Address as a with (nolock)
							on a.ProviderId = P.ProviderId
						inner join Search.Affiliation as af with (nolock)
							on af.ProviderId = P.ProviderId and a.AddressID = af.AddressID

-----------------------------------------------------------------

			merge Search.ProviderAffiliationAddress as TargetAPF
			using #APF as SourceAPF
			on (coalesce(TargetAPF.AddressId, '') = coalesce(SourceAPF.AddressId, ''))
				and (coalesce(TargetAPF.ProviderId, '') = coalesce(SourceAPF.ProviderId, ''))
				and (coalesce(TargetAPF.AffiliationId, '') = coalesce(SourceAPF.AffiliationId, ''))
			when not matched by target then
				insert (
						AddressId
					   ,ProviderId
					   ,AffiliationId
					   )
				values (
						SourceAPF.AddressId
					   ,SourceAPF.ProviderId
					   ,SourceAPF.AffiliationId

					   )
			when not matched by source then
				delete 

	-- Printing Output of Deleted,Inserted ProviderId
			output $action
			   ,DELETED.ProviderId as TargetProviderId
			   ,INSERTED.ProviderId as SourceProviderId;
			select @@ROWCOUNT;


/******************************************************************************************/
		--Drop temp objects

			if object_id('tempdb..#APF') is not null
				drop table #APF
/******************************************************************************************/
		end
	end
GO
/****** Object:  StoredProcedure [Import].[MergeAffiliationExtendedProperties]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

------------
CREATE Procedure [Import].[MergeAffiliationExtendedProperties]
@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
				10/03/2016		SS		Added delete statements to delete child table data.
		*/
		declare @now date = getdate()
		declare @Version varchar(100) = '10/03/2016 2:22 Version 1.00'
		declare @ReturnValues table
			(
			 ReturnCode int primary key
							not null
			,Reason varchar(200) not null
			)

		insert into @ReturnValues
				(ReturnCode, Reason)
			values (0, 'Normal Return')			
											
		if @Showversion = 1
			begin
				select object_schema_name(@@PROCId) as SchemaName
					   ,object_name(@@PROCId) as ProcedureName
					   ,@Version as VersionInformation
				if isnull(@ShowReturn, 0) = 0
					return 0
			end

		if @ShowReturn = 1
			begin
				select *
					from @ReturnValues
				return 0
			end

		set nocount on

		begin

			if object_id('tempdb..#AffiliationProperties') is not null
				drop table #AffiliationProperties

			create table #AffiliationProperties
				(
				 AffiliationId int not null
				,PropertyName varchar(30) not null
				,PropertyValue varchar(255) null
				)

			insert into #AffiliationProperties
			SELECT DISTINCT 
			af.AffiliationId,
			'DirectoryId',
			PPA.ppA_DirectoryId
			FROM Network_Development.dbo.Tbl_Provider_ProviderAffiliation ppa WITH (nolock)
			JOIN Network_Development.dbo.Tbl_Provider_AffiliationType AS at WITH (nolock) ON at.PAT_ID = ppa.PPA_AffiliationType
			JOIN Network_Development.dbo.Tbl_Database_ListValues dblv WITH (nolock) ON dblv.DBLV_ID = at.PAT_LOB AND dblv.DBLV_List = 83
			JOIN search.Provider AS P WITH (nolock) ON p.NetDevProvID = ppa.PPA_ProviderID
			JOIN search.Address AS A WITH (nolock) ON a.ProviderID = p.ProviderID
			JOIN search.Affiliation af WITH (nolock) ON PPA.PPA_PCPID = af.DirectoryID
			WHERE ppa.PPA_DirectoryID IS NOT null	AND (ppa.PPA_TermDate IS NULL OR ppa.PPA_TermDate >@now)

--------

--Remove dups

if object_id('tempdb..#distinctprop') is not null
				drop table #distinctprop

/****************************************************************************************/
--Create temp table #distinctAddresses to get all the unique records
SELECT * INTO #distinctprop FROM #AffiliationProperties WHERE 1 = 0	 

/****************************************************************************************/

	INSERT INTO #distinctprop
			Select Distinct 
			 [AffiliationID]
			 ,[PropertyName]
			 ,[PropertyValue]
			 from (  select *
				   ,row_number() over (partition BY a.AffiliationId order by a.AffiliationId ) as ranking						
				from #AffiliationProperties as a with (nolock)
				) T where T.ranking = 1



/*===============================================================================================================================*/


--Disable

		UPDATE T
		SET T.IsEnabled = 0
		FROM #distinctprop S
		RIGHT JOIN search.AffiliationExtendedProperties T ON S.AffiliationId = T.AffilationID AND s.PropertyName = t.PropertyName
		WHERE S.AffiliationId IS NULL AND ISNULL(T.IsEnabled,1) <> 0

--Enable
		
		UPDATE T
		SET T.IsEnabled = 1
		FROM #distinctprop S
		Inner JOIN search.AffiliationExtendedProperties T ON S.AffiliationId = T.AffilationID AND s.PropertyName = t.PropertyName
		WHERE  ISNULL(T.IsEnabled,0) <> 1


--Update

		UPDATE T
		SET T.Propertyvalue = S.Propertyvalue
		FROM #distinctprop S
		Inner JOIN search.AffiliationExtendedProperties T ON S.AffiliationId = T.AffilationID AND s.PropertyName = t.PropertyName

--Insert
		INSERT INTO search.AffiliationExtendedProperties 
		SELECT DISTINCT S.AffiliationId,S.PropertyName,S.PropertyValue,1 FROM #distinctprop s
		LEFT join search.AffiliationExtendedProperties p on p.AffilationID  = s.AffiliationId AND p.PropertyName = s.PropertyName AND p.PropertyValue = s.PropertyValue
		WHERE p.AffilationID IS NULL AND p.PropertyName IS NULL AND p.PropertyValue IS null

/*************************************************************************************************************************************/


			if object_id('tempdb..#AffiliationProperties') is not null
				drop table #AffiliationProperties


			if object_id('tempdb..#distinctprop') is not null
				drop table #distinctprop

/*************************************************************************************************************************************/

		end
	end
GO
/****** Object:  StoredProcedure [Import].[MergeAgeLimits]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

------------
create procedure [Import].[MergeAgeLimits]
	@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
				10/03/2016		SS		Added delete statements to delete child table data.
		*/
		declare @now date = getdate()
		declare @Version varchar(100) = '10/03/2016 2:22 Version 1.00'
		declare @ReturnValues table
			(
			 ReturnCode int primary key
							not null
			,Reason varchar(200) not null
			)

		insert into @ReturnValues
				(ReturnCode, Reason)
			values (0, 'Normal Return')			
											
		if @Showversion = 1
			begin
				select object_schema_name(@@PROCId) as SchemaName
					   ,object_name(@@PROCId) as ProcedureName
					   ,@Version as VersionInformation
				if isnull(@ShowReturn, 0) = 0
					return 0
			end

		if @ShowReturn = 1
			begin
				select *
					from @ReturnValues
				return 0
			end

		set nocount on



--------------------------


		merge search.AgeLimits as TargetAge
		using
			(
			 select distinct *
				from Network_Development.dbo.Tbl_Provider_AgeLimits
			) as SourceAge
		on (coalesce(TargetAge.AgeLimit, '') = coalesce(SourceAge.PAL_AgeLimit, ''))
			and (coalesce(TargetAge.AgeLimitDescription, '') = coalesce(SourceAge.PAL_AgeLimitDescription, ''))
		when not matched by target then
			insert (
					AgeLimit
				   ,AgeLimitDescription
				   ,AgeLimitSortOrder
				   ,LimitCategory
				   ,AgeLimitMin
				   ,AgeLimitMax
				   )
			values (
					SourceAge.PAL_AgeLimit
				   ,SourceAge.PAL_AgeLimitDescription
				   ,SourceAge.PAL_AgeLimitSortOrder
				   ,SourceAge.PAL_LimitCategory
				   ,SourceAge.PAL_AgeLimitMin
				   ,SourceAge.PAL_AgeLimitMax
				   );
	end




GO
/****** Object:  StoredProcedure [Import].[MergeAllAddressLanguages]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

------------

CREATE Procedure [Import].[MergeAllAddressLanguages]
		@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
				10/03/2016		SS		Added delete statements to delete child table data.
		*/
		declare @now date = getdate()
		declare @Version varchar(100) = '10/03/2016 2:22 Version 1.00'
		declare @ReturnValues table
			(
			 ReturnCode int primary key
							not null
			,Reason varchar(200) not null
			)

		insert into @ReturnValues
				(ReturnCode, Reason)
			values (0, 'Normal Return')			
											
		if @Showversion = 1
			begin
				select object_schema_name(@@PROCId) as SchemaName
					   ,object_name(@@PROCId) as ProcedureName
					   ,@Version as VersionInformation
				if isnull(@ShowReturn, 0) = 0
					return 0
			end

		if @ShowReturn = 1
			begin
				select *
					from @ReturnValues
				return 0
			end

		set nocount on


		begin


			if object_id('tempdb..#AddressLanguage') is not null
				drop table #AddressLanguage

			create table #AddressLanguage
				(
				 LanguageId int not null
				,AddressId int not null
				,Type varchar(30) null
				) 

			insert into #AddressLanguage
				SELECT distinct Lan.LanguageId
					   ,A.AddressId
					   ,'Non-Clinical Staff Language' as Type
					from Search.Address as A with (nolock)
						join Network_Development.dbo.Tbl_Contract_LocationLanguages as CL with (nolock)
							on A.LocationId = CL.CLL_Location
						inner join Network_Development.dbo.Tbl_Database_ListValues as LV with (nolock)
							on LV.DBLV_Id = cl.CLL_Proficiency
							   and LV.DBLV_List = 28
						INNER JOIN Network_Development.dbo.Tbl_Codes_Languages AS L WITH (nolock) ON L.LXISOCODE = CL.CLL_Language
						inner join Search.Languages as lan with (nolock)
							ON lan.Description = l.LXDesc
					where cl.CLL_Proficiency IN (1,3)
					order by A.AddressId
----------------------
			insert into #AddressLanguage
				SELECT distinct Lan.LanguageId
					   ,A.AddressId
					   ,'Clinical Staff Language' as Type
					from Search.Address as A with (nolock)
						join Network_Development.dbo.Tbl_Contract_LocationLanguages as CL with (nolock)
							on A.LocationId = CL.CLL_Location
						inner join Network_Development.dbo.Tbl_Database_ListValues as LV with (nolock)
							on LV.DBLV_Id = cl.CLL_Proficiency
							   and LV.DBLV_List = 28
						INNER JOIN Network_Development.dbo.Tbl_Codes_Languages AS L WITH (nolock) ON L.LXISOCODE = CL.CLL_Language
						inner join Search.Languages as lan with (nolock)
							ON lan.Description = l.LXDesc
					where cl.CLL_Proficiency IN (1,2)
					order by A.AddressId
/***********************************************************************************************************************************/


--Disabled
	
	UPDATE L
	SET L.IsEnabled = 0
	FROM #AddressLanguage S
	RIGHT JOIN search.AddressLanguage L  ON (coalesce(L.LanguageId, '') = coalesce(S.LanguageId, ''))
				and (coalesce(L.AddressId, '') = coalesce(S.AddressId, ''))
				and (coalesce(L.Type, '') = coalesce(S.Type, ''))
	WHERE  S.AddressID IS NULL AND S.LanguageID IS NULL AND S.Type IS null and ISNULL(L.IsEnabled,1) <> 0


--Enable
	UPDATE L
	SET L.IsEnabled = 1
	FROM #AddressLanguage S
	Inner JOIN search.AddressLanguage L  ON (coalesce(L.LanguageId, '') = coalesce(S.LanguageId, ''))
				and (coalesce(L.AddressId, '') = coalesce(S.AddressId, ''))
				and (coalesce(L.Type, '') = coalesce(S.Type, ''))
	WHERE ISNULL(L.IsEnabled,0) <> 1


--INSERT

			INSERT INTO search.AddressLanguage 
			SELECT DISTINCT al.LanguageID,
							al.AddressID,
							al.Type,1
			FROM #AddressLanguage AL
			LEFT JOIN search.AddressLanguage  T ON (coalesce(AL.LanguageId, '') = coalesce(T.LanguageId, ''))
				and (coalesce(AL.AddressId, '') = coalesce(T.AddressId, ''))
				and (coalesce(AL.Type, '') = coalesce(T.Type, ''))
			WHERE T.AddressID IS NULL AND t.LanguageID IS NULL AND t.Type IS null
								

/******************************************************************************************/
		--Drop temp objects

			if object_id('tempdb..#AddressLanguage') is not null
				drop table #AddressLanguage
/******************************************************************************************/


		end

	end
GO
/****** Object:  StoredProcedure [Import].[MergeAllLanguages]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [Import].[MergeAllLanguages]
	@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
				10/03/2016		SS		Added delete statements to delete child table data.
		*/
		declare @now date = getdate()
		declare @Version varchar(100) = '10/03/2016 2:22 Version 1.00'
		declare @ReturnValues table
			(
			 ReturnCode int primary key
							not null
			,Reason varchar(200) not null
			)

		insert into @ReturnValues
				(ReturnCode, Reason)
			values (0, 'Normal Return')			
											
		if @Showversion = 1
			begin
				select object_schema_name(@@PROCId) as SchemaName
					   ,object_name(@@PROCId) as ProcedureName
					   ,@Version as VersionInformation
				if isnull(@ShowReturn, 0) = 0
					return 0
			end

		if @ShowReturn = 1
			begin
				select *
					from @ReturnValues
				return 0
			end

		set nocount on


		begin
			if object_id('tempdb..#Languages') is not null
				drop table #Languages

			create table #Languages
				(
				 --Get all languages with their code from Network Dev and Diamond
				 LanguageId int identity(1, 1)
								not null
				,Description varchar(255) null
				,DiamCode varchar(15) null
				,NetDevCode varchar(15) null
				,ISOCOde varchar(5) null
				)

/*********************************************************************************************************
															--Languages from Diamond
			merge into #Languages as dst
			using Diam_725_App.diamond.JLANGFM0_DAT as src
			on dst.Description = src.LXDESC
			when matched then
				update set DiamCode = src.LXCODE
			when not matched then
				insert (Description, DiamCode)
				values (
						src.LXDESC
					   ,src.LXCODE
					   ); 
*********************************************************************************************************/
			merge into #Languages as dst
			using Network_Development.dbo.Tbl_Codes_Languages as src
			on dst.Description = src.LXDesc
			when matched then
				update set NetDevCode = src.LXCode
			when not matched then
				insert (
						Description
					   ,NetDevCode
					   ,ISOCOde
					   )
				values (
						src.LXDesc
					   ,src.LXCode
					   ,src.LXISOCODE
					   );
					   
					  
			merge into #Languages as dst
			using
				(
				 select distinct cast(CL.CL_StaffLanguage as char) as lxcode
					   ,LV.DBLV_Value as lxdesc
					from Network_Development.dbo.Tbl_Contract_Locations as CL with (nolock)
						left join Network_Development.dbo.Tbl_Database_ListValues as LV with (nolock)
							on LV.DBLV_Id = CL_StaffLanguage
					where LV.DBLV_List = 95
				) as src
			on dst.Description = src.lxdesc
			when matched then
				update set NetDevCode = src.lxcode
			when not matched then
				insert (
						Description
					   ,NetDevCode
					   )
				values (
						src.lxdesc
					   ,src.lxcode
					   
					   );
																				

			--Inserting Default Language for Hospitals, LTSS and SNF types			
			insert into #Languages
					(
					 --IdentityCOlumn
			Description
					,DiamCode
					,NetDevCode
					,ISOCOde
					)
				values
					(
					 'Translation Services Available'
					,'TS'
					,null
					,null
					)


/*Temp table to store Disctinct languages after tranformation (Removing comma seperated languages and duplicates for example: American Sign Language(ASL) and American Sign Language are same
so storing only one )*/
--drop table #distinctLanguages
			if object_id('tempdb..#distinctLanguages') is not null
				drop table #distinctLanguages

			create table #distinctLanguages
				(
				 LanguageId int identity
								not null
				,Description varchar(100) null
				,ISOCOde varchar(8) null
				)

			insert into #distinctLanguages
				select distinct split.l.value('.', 'varchar(max)') as Description
					   ,l.ISOCOde
					from (
						  select LanguageId
							   ,NetDevCode
							   ,DiamCode
							   ,ISOCOde
							   ,cast('<M>' + replace(Description, ', ', '</M><M>') + '</M>' as xml) as Description
							from #Languages
						 ) as l
						cross apply Description.nodes('/M') as split (l) --as lang;




																				
 --Get ISO code languages from Network Dev
			merge into #distinctLanguages as dst
			using
				(
				 select distinct *
					from Network_Development.dbo.Tbl_Codes_LanguagesISO with (nolock)
					where LAN_Include = -1
				) as src
			on src.LAN_LanguageName = dst.Description
			when matched then
				update set dst.ISOCOde = src.LAN_Code
			when not matched then
				insert (Description, ISOCOde)
				values (
						src.LAN_LanguageName
					   ,src.LAN_Code
					   );

				UPDATE #distinctLanguages
				SET ISOCOde = LXISOCODE
				FROM Network_Development.dbo.Tbl_Codes_Languages
				WHERE LXDesc = Description
				
				
						 

					--	 SELECT * FROM #distinctLanguages ORDER BY Description
------------------------------------------------------------
	

	--select top 100 * from #distinctLanguages
	--delete from #distinctLanguages where LanguageId = 4
	
			declare @LanguageIdsForDeletion table (LanguageId int)
			insert into @LanguageIdsForDeletion
					(
					 LanguageId
					)
				select L.LanguageId
					from #distinctLanguages DL
						right join Search.Languages L with (nolock)
							on L.Description = DL.Description
					where DL.LanguageId is null

	--Delete provider Langs
			delete PL
				from Search.ProviderLanguage PL
					join @LanguageIdsForDeletion D
						on PL.LanguageId = D.LanguageId

	--Delete addres lang
			delete AL
				from Search.AddressLanguage AL
					join @LanguageIdsForDeletion D
						on AL.LanguageId = D.LanguageId

	--delete lang
			delete L
				from Search.Languages L
					join @LanguageIdsForDeletion D
						on L.LanguageId = D.LanguageId


				merge Search.Languages as TargetLanguages
			using (SELECT DISTINCT Description,ISOCOde FROM #distinctLanguages) as SourceLanguages
			on (coalesce(TargetLanguages.Description, '') = coalesce(SourceLanguages.Description, ''))
			when matched
	
	and(coalesce(TargetLanguages.ISOCode, '') <> coalesce(SourceLanguages.ISOCOde, '')) then
				update set ISOCode = SourceLanguages.ISOCOde
			when not matched by target then
				insert (Description, ISOCode)
				values (
						Search.udf_TitleCase(SourceLanguages.Description)
					   ,SourceLanguages.ISOCOde
					   )
	WHEN NOT MATCHED BY SOURCE 
	THEN
	DELETE 

	-- Printing Output of Deleted,Inserted ProviderId
			output $action
			   ,DELETED.Description as TargetDescription
			   ,INSERTED.Description as SourceDescription;
			select @@ROWCOUNT;
/***************************************************************************************************/
		if object_id('tempdb..#Languages') is not null
				drop table #Languages

		if object_id('tempdb..#distinctLanguages') is not null
				drop table #distinctLanguages


/***************************************************************************************************/

		end
	end



GO
/****** Object:  StoredProcedure [Import].[MergeAllProviderAddress]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

------------

CREATE Procedure [Import].[MergeAllProviderAddress]
	@Showversion bit = 0
   ,@ShowReturn bit = 0
   ,@UseNewGeoCodingStuff bit = 0
as
	begin
		/*
			Modification Log:
				10/03/2016		SS	1.00		Added delete statements to delete child table data.
				11/9/2016		SS	1.01		Removed CLNS_Status = 1 from where condition
				12/8/2016		SS	1.02		Replaced SEQNO with LocationID from NetworkDev for PCPs
				11/17/2017		SS	1.03		Condition to bring only verified emails.
				11/17/2017		SS	1.04		Changed source of pcp address to nddb.
		*/
		declare @now date = getdate()
		declare @Version varchar(100) = '10/03/2016 2:22 Version 1.00'
		declare @ReturnValues table
			(
			 ReturnCode int primary key
							not null
			,Reason varchar(200) not null
			)

		insert into @ReturnValues
				(ReturnCode, Reason)
			values (0, 'Normal Return')			
											
		if @Showversion = 1
			begin
				select object_schema_name(@@PROCId) as SchemaName
					   ,object_name(@@PROCId) as ProcedureName
					   ,@Version as VersionInformation
				if isnull(@ShowReturn, 0) = 0
					return 0
			end

		if @ShowReturn = 1
			begin
				select *
					from @ReturnValues
				return 0
			end

		set nocount on


		begin
	--	declare @now date = getdate()
			if object_id('tempdb..#Address') is not null
				drop table #Address


			create table #Address
				(
				 AddressId int identity(1, 1)
							   not null
				,ProviderId int not null
				,Street varchar(100) null
				,City varchar(150) null
				,Zip varchar(9) null
				,County varchar(100) null
				,CountyCode int null
				,Phone varchar(20) null
				,AfterHoursPhone varchar(10) null
				,Fax varchar(20) null
				,Email varchar(100) null
				,WebSite varchar(100) null
				,BusStop int null
				,BusRoute varchar(30) null
				,Accessibility varchar(50) null
				,Walkin bit null
				,BuildingSign varchar(100) null
				,AppointmentNeeded bit null
				,Hours varchar(150) null
				,Latitude float null
				,Longitude float null
				,LocationId varchar(6) null
				,MedicalGroup varchar(100) null
				,ContractId int null
				,FederallyQualifiedHC bit null
				,State varchar(20) null
				,IsInternalOnly bit default 0
				,AddressRawHash varbinary(20) NULL
                ,Street2 VARCHAR(55) NULL
		        ,IsEnabled BIT DEFAULT 0

				)


	--	declare @now date = getdate()
			begin		--Merge Ancillary provider address
																					
				insert into #Address
					select distinct p.ProviderId as ProviderId
						   ,Locations.CL_Address1 as Street
						   ,Locations.CL_City as City
						   ,Locations.CL_Zip as Zip
						   ,ZC.OZCA_county as County
						   ,Locations.CL_CountyCode as CountyCode
						   ,CPL.CCPL_Phone as phone
						   ,null as AfterHoursPhone
						   ,-- ?? 
							CPL.CCPL_Fax as Fax
						   ,CASE WHEN Locations.CL_EmailVerified IS NOT NULL THEN Locations.CL_Email ELSE NULL end as Email
						   ,Locations.CL_Website as Website
						   ,Locations.CL_BusStop as Busstop
						   ,null as BusRoute
						   ,isnull(case	when isnull(Locations.CL_Parking, '') <> ''
											 and isnull(Locations.CL_ExtBuilding, '') <> ''
											 and isnull(Locations.CL_IntBuilding, '') <> ''
											 and isnull(Locations.CL_Restroom, '') <> ''
											 and isnull(Locations.CL_ExamRoom, '') <> ''
											 and isnull(Locations.CL_ExamTable, '') <> ''
										then Locations.CL_Parking + ',' + Locations.CL_ExtBuilding + ',' + Locations.CL_IntBuilding + ','
											 + Locations.CL_Restroom + ',' + Locations.CL_ExamRoom + ',' + Locations.CL_ExamTable
										else null
								   end, 'N/A') as Accessbility
						   ,Locations.CL_WalkIn as WalkIN
						   ,Locations.CL_Signage as BuildingSign
						   ,Locations.CL_ApptOnly as AppointmentNeeded
						   ,-- ??  
							Locations.CL_OfficeHours as Hours
						   ,null as Latitude
						   ,null as Longitude
						   ,Locations.CL_Id as LocationId
						   ,MG.PMG_Name as MedicalGroup
						   ,CPL.CCPL_ContractId as ContractId
						   ,case when Locations.CL_SafetyNet = 2 then 1														--CL_SafetyNet = 2 shows that a clinic is federally qualified
								 else 0
							end as FederallyQualifiedHC
						   ,case when (
									   Locations.CL_State is not null
									   and Locations.CL_State <> ''
									  ) then Locations.CL_State
								 else null
							end as State
							,Case when Locations.CL_ProviderDirectory IN (0,2)  then 1 else 0 end as 
							IsInternalOnly
							,null as AddressRawHash
							,Locations.CL_Address2 AS Street2
							,1 AS IsEnabled
						from Network_Development.dbo.Tbl_Contract_Locations as Locations with (nolock)
							inner join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
								on CPL.CCPL_LocationId = Locations.CL_Id
							inner join Network_Development.dbo.Tbl_Provider_ProviderInfo as ppi with (nolock)
								on CPL.CCPL_ProviderId = ppi.PPI_Id
							left join Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock)
								on CCI.CCI_Id = CPL.CCPL_ContractId
							left join Search.Provider as p with (nolock)
								on p.NetDevProvId = CPL.CCPL_ProviderId
							left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
								on ZC.OZCA_zip = Locations.CL_Zip
							left join Network_Development.dbo.Tbl_Provider_MedicalGroup as MG with (nolock)
								on MG.PMG_Id = Locations.CL_MedicalGroup
							
						where (p.ProviderType in ('anc', 'danc'))
							and (
								 CPL.CCPL_TermDate is null
								 or CPL.CCPL_TermDate > @now
								)
							and (
								 CCI.CCI_ExpDate is null
								 or CCI.CCI_ExpDate > @now
								)
							and (
								 Locations.CL_Address1 is not null
								 or Locations.CL_Address1 <> ''
								)
							
						order by Locations.CL_Id

			end
------------------------------------------------------------------------------------------------------
			begin		--Merge Hospital Address

				insert into #Address
					select distinct P.ProviderId as ProviderId
						   ,CL.CL_Address1 as Street
						   ,CL.CL_City as City
						   ,CL.CL_Zip as Zip
						   ,ZC.OZCA_county as County
						   ,CL.CL_CountyCode as CountyCode
						   ,CPL.CCPL_Phone as Phone
						   ,null as AfterHoursPhone
						   ,CPL.CCPL_Fax as Fax
						  ,CASE WHEN Cl.CL_EmailVerified IS NOT NULL THEN Cl.CL_Email ELSE NULL end as Email
						   ,CL.CL_Website as Website
						   ,CL.CL_BusStop as BusStop
						   ,null as BusRoute
						   ,case when CL.CL_LevelofAccess = 1 then 'B'
								 when CL.CL_LevelofAccess = 2 then 'L'
								 else 'N/A'
							end as Accessibility
						   ,null as Walkin
						   ,CL.CL_Signage as BuiluingSign
						   ,CL.CL_ApptOnly as AppointmentNeed
						   ,CL.CL_OfficeHours as Hours
						   ,null as Latitude
						   ,null as Longitude
						   ,CL.CL_Id as LocationId
						   ,MG.PMG_Name as MedicalGroup
						   ,CPL.CCPL_ContractId as ContractId
						   ,case when CL.CL_SafetyNet = 2 then 1
								 else 0
							end as FederallyQualifiedHC
						   ,case when (
									   CL.CL_State is not null
									   and CL.CL_State <> ''
									  ) then CL.CL_State
								 else null
							end as State
							,Case when CL.CL_ProviderDirectory IN (0,2)  then 1 else 0 end as 
							IsInternalOnly
							,null as AddressRawHash
							,CL.CL_Address2 AS Street2, 1 AS IsEnabled
						from Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock)
							inner join Search.Provider as P with (nolock)
								on P.DiamProvId = CCI.CCI_ContractDiamondId
							inner join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
								on CPL.CCPL_ContractId = CCI.CCI_Id
								   and CPL.CCPL_ProviderId = P.NetDevProvId
							inner join Network_Development.dbo.Tbl_Contract_Locations as CL with (nolock)
								on CPL.CCPL_LocationId = CL.CL_Id
							inner  join Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
								on CPL.CCPL_ProviderId = PPI.PPI_Id
							left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
								on ZC.OZCA_zip = CL.CL_Zip
							left join Network_Development.dbo.Tbl_Provider_MedicalGroup as MG with (nolock)
								on MG.PMG_Id = CL.CL_MedicalGroup
						where (P.ProviderType = 'HOSP')
							and (
								 CCI.CCI_ExpDate is null
								 or CCI.CCI_ExpDate > @now
								)
							and (
								 CPL.CCPL_TermDate is null
								 or CPL.CCPL_TermDate > @now
								)
							and (
								 CL.CL_Address1 is not null
								 or CL.CL_Address1 <> ''
								)
							
							and not exists ( select 1
												from #Address as a
												where a.ProviderId = P.ProviderId ) 

	
			end
------------------------------------------------------------------------------------------------------------------------
			begin		--Merge IPA Address
				insert into #Address			--IPA
					select distinct p.ProviderId as ProviderId
						   ,Locations.CL_Address1 as Street
						   ,Locations.CL_City as City
						   ,Locations.CL_Zip as Zip
						   ,ZC.OZCA_county as County
						   ,Locations.CL_CountyCode as CountyCode
						   ,CPL.CCPL_Phone as phone
						   ,null as AfterHoursPhone
						   ,-- ?? 
							CPL.CCPL_Fax as FAX
						  ,CASE WHEN Locations.CL_EmailVerified IS NOT NULL THEN Locations.CL_Email ELSE NULL end as Email
						   ,Locations.CL_Website as Website
						   ,Locations.CL_BusStop as Busstop
						   ,null as BusRoute
						   ,isnull(case	when isnull(Locations.CL_Parking, '') <> ''
											 and isnull(Locations.CL_ExtBuilding, '') <> ''
											 and isnull(Locations.CL_IntBuilding, '') <> ''
											 and isnull(Locations.CL_Restroom, '') <> ''
											 and isnull(Locations.CL_ExamRoom, '') <> ''
											 and isnull(Locations.CL_ExamTable, '') <> ''
										then Locations.CL_Parking + ',' + Locations.CL_ExtBuilding + ',' + Locations.CL_IntBuilding + ','
											 + Locations.CL_Restroom + ',' + Locations.CL_ExamRoom + ',' + Locations.CL_ExamTable
										else null
								   end, 'N/A') as Accessbility
						   ,Locations.CL_WalkIn as WalkIN
						   ,Locations.CL_Signage as BuildingSign
						   ,Locations.CL_ApptOnly as AppointmentNeeded
						   ,-- ??  
							Locations.CL_OfficeHours as Hours
						   ,null as Latitude
						   ,null as Longitude
						   ,Locations.CL_Id as LocationId
						   ,MG.PMG_Name as MedicalGroup
						   ,CPL.CCPL_ContractId as ContractId
						   ,case when Locations.CL_SafetyNet = 2 then 1
								 else 0
							end as FederallyQualifiedHC
						   ,case when (
									   Locations.CL_State is not null
									   and Locations.CL_State <> ''
									  ) then Locations.CL_State
								 else null
							end as State
							,Case when Locations.CL_ProviderDirectory IN (0,2)  then 1 else 0 end as 
							IsInternalOnly
							,null as AddressRawHash
							,Locations.CL_Address2  AS Street2, 1 AS IsEnabled
						from Network_Development.dbo.Tbl_Contract_Locations as Locations with (nolock)
							inner join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
								on CPL.CCPL_LocationId = Locations.CL_Id
							inner join Network_Development.dbo.Tbl_Provider_ProviderInfo as ppi with (nolock)
								on CPL.CCPL_ProviderId = ppi.PPI_Id
							inner join Search.Provider as p with (nolock)
								on p.NetDevProvId = CPL.CCPL_ProviderId
							left join Network_Development.dbo.Tbl_Provider_MedicalGroup as MG with (nolock)
								on MG.PMG_Id = Locations.CL_MedicalGroup
							left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
								on ZC.OZCA_zip = Locations.CL_Zip
						where (p.ProviderType in ('IPA'))
							and (
								 CPL.CCPL_TermDate is null
								 or CPL.CCPL_TermDate > @now
								)
							and (
								 Locations.CL_Address1 is not null
								 or Locations.CL_Address1 <> ''
								)
							
							and not exists ( select 1
												from #Address as a
												where a.ProviderId = p.ProviderId )

			end
--------------------------------------------------------------------------------------------------------------------
			begin		--Merge LTSS Address

				insert into #Address			--LTSS
					select distinct p.ProviderId as ProviderId
						   ,Locations.CL_Address1 as Street
						   ,Locations.CL_City as City
						   ,Locations.CL_Zip as Zip
						   ,ZC.OZCA_county as County
						   ,Locations.CL_CountyCode as CountyCode
						   ,CPL.CCPL_Phone as phone
						   ,null as AfterHoursPhone
						   ,-- ?? 
							CPL.CCPL_Fax as FAX
						   ,CASE WHEN Locations.CL_EmailVerified IS NOT NULL THEN Locations.CL_Email ELSE NULL end as Email
						   ,Locations.CL_Website as Website
						   ,Locations.CL_BusStop as Busstop
						   ,null as BusRoute
						   ,isnull(case	when isnull(Locations.CL_Parking, '') <> ''
											 and isnull(Locations.CL_ExtBuilding, '') <> ''
											 and isnull(Locations.CL_IntBuilding, '') <> ''
											 and isnull(Locations.CL_Restroom, '') <> ''
											 and isnull(Locations.CL_ExamRoom, '') <> ''
											 and isnull(Locations.CL_ExamTable, '') <> ''
										then Locations.CL_Parking + ',' + Locations.CL_ExtBuilding + ',' + Locations.CL_IntBuilding + ','
											 + Locations.CL_Restroom + ',' + Locations.CL_ExamRoom + ',' + Locations.CL_ExamTable
										else null
								   end, 'N/A') as Accessbility
						   ,Locations.CL_WalkIn as WalkIN
						   ,Locations.CL_Signage as BuildingSign
						   ,Locations.CL_ApptOnly as AppointmentNeeded
						   ,-- ??  
							Locations.CL_OfficeHours as Hours
						   ,null as Latitude
						   ,null as Longitude
						   ,Locations.CL_Id as LocationId
						   ,MG.PMG_Name as MedicalGroup
						   ,CPL.CCPL_ContractId as ContractId
						   ,case when Locations.CL_SafetyNet = 2 then 1
								 else 0
							end as FederallyQualifiedHC
						   ,case when (
									   Locations.CL_State is not null
									   and Locations.CL_State <> ''
									  ) then Locations.CL_State
								 else null
							end as State
							,Case when Locations.CL_ProviderDirectory IN (0,2)  then 1 else 0 end as 
							IsInternalOnly
							,null as AddressRawHash
							,Locations.CL_Address2 AS Street2, 1 AS IsEnabled
	
						from Network_Development.dbo.Tbl_Contract_Locations as Locations with (nolock)
							inner join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
								on CPL.CCPL_LocationId = Locations.CL_Id
							inner join Network_Development.dbo.Tbl_Provider_ProviderInfo as ppi with (nolock)
								on CPL.CCPL_ProviderId = ppi.PPI_Id
							inner join Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock)
								on CCI.CCI_Id = CPL.CCPL_ContractId
							inner join Search.Provider as p with (nolock)
								on p.NetDevProvId = CPL.CCPL_ProviderId
							left join Network_Development.dbo.Tbl_Provider_MedicalGroup as MG with (nolock)
								on MG.PMG_Id = Locations.CL_MedicalGroup
							left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
								on ZC.OZCA_zip = Locations.CL_Zip
						where (p.ProviderType in ('LTSS'))
							and (
								 CPL.CCPL_TermDate is null
								 or CPL.CCPL_TermDate > @now
								)
							and (
								 CCI.CCI_ExpDate is null
								 or CCI.CCI_ExpDate > @now
								)
							and (
								 Locations.CL_Address1 is not null
								 or Locations.CL_Address1 <> ''
								)
							
							and not exists ( select 1
												from #Address as a
												where a.ProviderId = p.ProviderId )
			end
-------------------------------------------------------------------------------------------------------------
			begin		--Merge NPP Address
				insert into #Address			--NPP
			select distinct P.ProviderId as ProviderId
						   ,locations.CL_Address1 as Street
						   ,locations.CL_City as City
						   ,locations.CL_Zip as Zip
						   ,ZC.OZCA_county as County
						   ,locations.CL_CountyCode as CountyCode
						   ,LN.CLNS_Phone as Phone
						   ,null as AfterHoursPhone
						   ,-- ?? 
							LN.CLNS_Fax as Fax
						   ,CASE WHEN Locations.CL_EmailVerified IS NOT NULL THEN Locations.CL_Email ELSE NULL end as Email
						   ,locations.CL_Website as Website
						   ,locations.CL_BusStop as Busstop
						   ,null as BusRoute
						   ,isnull(case	when isnull(locations.CL_Parking, '') <> ''
											 and isnull(locations.CL_ExtBuilding, '') <> ''
											 and isnull(locations.CL_IntBuilding, '') <> ''
											 and isnull(locations.CL_Restroom, '') <> ''
											 and isnull(locations.CL_ExamRoom, '') <> ''
											 and isnull(locations.CL_ExamTable, '') <> ''
										then locations.CL_Parking + ',' + locations.CL_ExtBuilding + ',' + locations.CL_IntBuilding + ','
											 + locations.CL_Restroom + ',' + locations.CL_ExamRoom + ',' + locations.CL_ExamTable
										else null
								   end, 'N/A') as Accessbility
						   ,locations.CL_WalkIn as WalkIN
						   ,locations.CL_Signage as BuildingSign
						   ,locations.CL_ApptOnly as AppointmentNeeded
						   ,-- ??  
							locations.CL_OfficeHours as Hours
						   ,null as Latitude
						   ,null as Longitude
						   ,locations.CL_Id as LocationId
						   ,MG.PMG_Name as MedicalGroup
						   ,null as ContractId
						   ,case when locations.CL_SafetyNet = 2 then 1
								 else 0
							end as FederallyQualifiedHC
						   ,case when (
									   locations.CL_State is not null
									   and locations.CL_State <> ''
									  ) then locations.CL_State
								 else null
							end as State
							,Case when Locations.CL_ProviderDirectory IN (0,2)  then 1 else 0 end as 
							IsInternalOnly
							,null as AddressRawHash
							,locations.CL_Address2  AS Street2, 1 AS IsEnabled
						from Search.Provider as P with (nolock)
							inner join Network_Development.dbo.Tbl_Provider_ProviderAffiliation as PPA with (nolock)
								on P.NetDevProvId = PPA.PPA_ProviderId
							inner join Network_Development.dbo.Tbl_Contract_Locations as locations with (nolock)
								on locations.CL_Id = PPA.PPA_LocationId
							left join Network_Development.dbo.Tbl_Contract_LocationsNumbers as LN with (nolock)
								on LN.CLNS_ProviderId = P.NetDevProvId
								   and LN.CLNS_LocationId = PPA.PPA_LocationId and LN.CLNS_Status = 1
							left join Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
								on PPI.PPI_Id = P.NetDevProvId
							left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
								on ZC.OZCA_zip = locations.CL_Zip
							left join Network_Development.dbo.Tbl_Provider_MedicalGroup as MG with (nolock)
								on MG.PMG_Id = locations.CL_MedicalGroup
						where P.ProviderType in ('NPP')
					--		and (LN.CLNS_Status = 1)
							and (
								 PPA.PPA_TermDate is null
								 or PPA.PPA_TermDate > @now
								)
							and (
								 locations.CL_Address1 is not null
								 or locations.CL_Address1 <> ''
								)
								
							and not exists ( select 1
												from #Address as a
											where a.ProviderId = P.ProviderId )
					UNION
							select distinct P.ProviderId as ProviderId
						   ,locations.CL_Address1 as Street
						   ,locations.CL_City as City
						   ,locations.CL_Zip as Zip
						   ,ZC.OZCA_county as County
						   ,locations.CL_CountyCode as CountyCode
						   ,LN.CLNS_Phone as Phone
						   ,null as AfterHoursPhone
						   ,-- ?? 
							LN.CLNS_Fax as Fax
						   ,CASE WHEN Locations.CL_EmailVerified IS NOT NULL THEN Locations.CL_Email ELSE NULL end as Email
						   ,locations.CL_Website as Website
						   ,locations.CL_BusStop as Busstop
						   ,null as BusRoute
						   ,isnull(case	when isnull(locations.CL_Parking, '') <> ''
											 and isnull(locations.CL_ExtBuilding, '') <> ''
											 and isnull(locations.CL_IntBuilding, '') <> ''
											 and isnull(locations.CL_Restroom, '') <> ''
											 and isnull(locations.CL_ExamRoom, '') <> ''
											 and isnull(locations.CL_ExamTable, '') <> ''
										then locations.CL_Parking + ',' + locations.CL_ExtBuilding + ',' + locations.CL_IntBuilding + ','
											 + locations.CL_Restroom + ',' + locations.CL_ExamRoom + ',' + locations.CL_ExamTable
										else null
								   end, 'N/A') as Accessbility
						   ,locations.CL_WalkIn as WalkIN
						   ,locations.CL_Signage as BuildingSign
						   ,locations.CL_ApptOnly as AppointmentNeeded
						   ,-- ??  
							locations.CL_OfficeHours as Hours
						   ,null as Latitude
						   ,null as Longitude
						   ,locations.CL_Id as LocationId
						   ,MG.PMG_Name as MedicalGroup
						   ,null as ContractId
						   ,case when locations.CL_SafetyNet = 2 then 1
								 else 0
							end as FederallyQualifiedHC
						   ,case when (
									   locations.CL_State is not null
									   and locations.CL_State <> ''
									  ) then locations.CL_State
								 else null
							end as State
							,Case when Locations.CL_ProviderDirectory IN (0,2)  then 1 else 0 end as 
							IsInternalOnly
							,null as AddressRawHash
							,locations.CL_Address2 AS Street2, 1 AS IsEnabled
						from Search.Provider as P with (nolock)
							inner join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
								on P.NetDevProvId = CPL.CCPL_ProviderID
							inner join Network_Development.dbo.Tbl_Contract_Locations as locations with (nolock)
								on locations.CL_Id = CPL.CCPL_LocationID
							left join Network_Development.dbo.Tbl_Contract_LocationsNumbers as LN with (nolock)
								on LN.CLNS_ProviderId = P.NetDevProvId
								   and LN.CLNS_LocationId = CPL.CCPL_LocationID and LN.CLNS_Status = 1
							left join Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
								on PPI.PPI_Id = P.NetDevProvId
							left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
								on ZC.OZCA_zip = locations.CL_Zip
							left join Network_Development.dbo.Tbl_Provider_MedicalGroup as MG with (nolock)
								on MG.PMG_Id = locations.CL_MedicalGroup
						where P.ProviderType in ('NPP')
							--and (LN.CLNS_Status = 1)
							and (
								 CPL.CCPL_Termdate is null
								 or CPL.CCPL_Termdate > @now
								)
							and (
								 locations.CL_Address1 is not null
								 or locations.CL_Address1 <> ''
								)
								
							and not exists ( select 1
											from #Address as a
												where a.ProviderId = P.ProviderId )
						order by P.ProviderId
			end
 --------------------------------------------------------------------------------------------------------------------  
			begin		--Merge PCP address
				insert into #Address
					select distinct P.ProviderId as ProviderId
						   ,CL.CL_Address1 as Street
						   ,Cl.CL_City as City
						   ,CL.CL_Zip as Zip
						   ,ZC.OZCA_county as County
						   ,CL.CL_CountyCode as CountyCode
						   ,CLNS.CLNS_Phone as Phone
						   ,null as AfterHoursPhone
						   ,CLNS.CLNS_Fax as Fax
						   ,CASE WHEN CL.CL_EmailVerified IS NOT NULL THEN CL.CL_Email ELSE NULL end as Email
						   ,CL.CL_Website as Website
						   ,Cl.CL_BusStop as BusStop
						   ,null as BusRoute
						  ,isnull(case	when isnull(CL.CL_Parking, '') <> ''
											 and isnull(CL.CL_ExtBuilding, '') <> ''
											 and isnull(CL.CL_IntBuilding, '') <> ''
											 and isnull(CL.CL_Restroom, '') <> ''
											 and isnull(CL.CL_ExamRoom, '') <> ''
											 and isnull(CL.CL_ExamTable, '') <> ''
										then CL.CL_Parking + ',' + CL.CL_ExtBuilding + ',' + CL.CL_IntBuilding + ','
											 + CL.CL_Restroom + ',' + CL.CL_ExamRoom + ',' + CL.CL_ExamTable
										else null
								   end, 'N/A') as Accessbility
						   ,CL.CL_Walkin AS Walkin
						   ,isnull(CL.CL_Signage, 'N/A') as BuildingSign
						   ,CL.CL_ApptOnly as AppointmentNeeded
						   ,Cl.CL_OfficeHours as Hours
						   ,null as Latitude
						   ,null as Longitude
						   ,CL.CL_ID as LocationId
						   ,mg.PMG_Name as MedicalGroup
						   ,null as ContractId
						   ,case when CL.CL_SafetyNet = 2 then 1
								 else 0
							end as FederallyQualifiedHC
						   ,CL.Cl_state AS [State]
							,Case when CL.CL_ProviderDirectory IN (0,2)  then 1 else 0 end as 
							IsInternalOnly
							,null as AddressRawHash
							,CL.CL_address2  AS Street2
							,1 AS IsEnabled
						from search.provider p with (nolock)
						INNER JOIN Network_Development.dbo.Tbl_Provider_ProviderAffiliation AS ppa WITH (nolock) 
								ON ppa.PPA_ProviderID = p.NetDevProvID
						INNER JOIN Network_Development.dbo.tbl_Contract_Locations AS CL WITH (nolock) 
								ON CL.CL_ID = ppa.PPA_LocationID
						LEFT JOIN Network_Development.dbo.Tbl_Contract_LocationsNumbers AS CLNS WITH (nolock)
								ON cl.CL_ID = CLNS.CLNS_LocationID AND p.NetDevProvID = CLNS.CLNS_ProviderID AND CLNS.CLNS_Status = 1
						LEFT JOIN Network_Development.dbo.Tbl_Provider_MedicalGroup mg WITH (nolock)
								ON mg.PMG_ID = CL.CL_MedicalGroup
						left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
								on ZC.OZCA_zip = cl.CL_Zip
						where (P.ProviderType = 'PCP')
							and (
								 ppa.PPA_TermDate is null
								 or ppa.PPA_TermDate >= @now
								)
						and not exists ( select 1
												from #Address as a
												where a.ProviderId = P.ProviderId )
						order by P.ProviderId
				
			end
---------------------------------------------------------------------------------------------------------
			begin		--Merge Pharmacy Address
				insert into #Address			--PHRM
					select distinct P.ProviderId as ProviderId
						   ,PH.Address_1 as Street
						   ,PH.City as City
						   ,PH.Zip as Zip
						   ,ZC.OZCA_county as County
						   ,CL.CL_CountyCode as CountyCode
						   ,PH.Phone as Phone
						   ,null as AfterHoursPhone
						   ,PH.Fax as Fax
						   ,PH.Email as Email
						   ,CL.CL_Website as WebSite
						   ,CL.CL_BusStop as BusStop
						   ,null as BusRoute
						   ,isnull(case	when isnull(CL.CL_Parking, '') <> ''
											 and isnull(CL.CL_ExtBuilding, '') <> ''
											 and isnull(CL.CL_IntBuilding, '') <> ''
											 and isnull(CL.CL_Restroom, '') <> ''
											 and isnull(CL.CL_ExamRoom, '') <> ''
											 and isnull(CL.CL_ExamTable, '') <> ''
										then CL.CL_Parking + ',' + CL.CL_ExtBuilding + ',' + CL.CL_IntBuilding + ',' + CL.CL_Restroom + ',' + CL.CL_ExamRoom
											 + ',' + CL.CL_ExamTable
										else null
								   end, 'N/A') as Accessbility
						   ,CL.CL_WalkIn as Walkin
						   ,CL.CL_Signage as BuildingSign
						   ,null as AppointmentNeeded
						   ,PH.Hours_of_Service as Hours
						   ,null as Latitude
						   ,null as Longitude
						   ,CL.CL_Id as LocationId
						   ,MG.PMG_Name as MedicalGroup
						   ,null as ContractId
						   ,case when CL.CL_SafetyNet = 2 then 1
								 else 0
							end as FederallyQualifiedHC
						   ,case when (
									   PH.State is not null
									   and PH.State <> ''
									  ) then PH.State
								 else null
							end as State	
							,Case when CL.CL_ProviderDirectory IN (0,2)  then 1 else 0 end as 
							IsInternalOnly						--Because ONly California Pharmacies are listed
							,null as AddressRawHash
							,Null  AS Street2, 1 AS IsEnabled
						from Pharmacy.Pharmacy.dbo.IEHP_Pharmacy_Providers as PH with (nolock)
							inner join Search.Provider as P with (nolock)
								on P.License = PH.CA_License
								   and P.NetDevProvId = PH.Id
							left outer join Network_Development.dbo.Tbl_Contract_Locations as CL with (nolock)
								on CL.CL_NPI = P.NPI
							left join Network_Development.dbo.Tbl_Provider_MedicalGroup as MG with (nolock)
								on MG.PMG_Id = CL.CL_MedicalGroup
							left outer join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
								on ZC.OZCA_zip = PH.Zip
						where (PH.ClosedDate > @now)
							or (PH.ClosedDate is null)
							and (
								 PH.Address_1 is not null
								 or PH.Address_1 <> ''
								)
								
							and not exists ( select 1
												from #Address as a
												where a.ProviderId = P.ProviderId ) 
			end
--------------------------------------------------------------------------------------------------------
			begin
				insert into #Address			--SNF
					select distinct P.ProviderId as ProviderId
						   ,CL.CL_Address1 as Street
						   ,CL.CL_City as City
						   ,CL.CL_Zip as Zip
						   ,ZC.OZCA_county as County
						   ,CL.CL_CountyCode as CountyCode
						   ,CPL.CCPL_Phone as Phone
						   ,null as AfterHoursPhone
						   ,CPL.CCPL_Fax as Fax
						   ,CASE WHEN CL.CL_EmailVerified IS NOT NULL THEN CL.CL_Email ELSE NULL end as Email
						   ,CL.CL_Website as WebSite
						   ,CL.CL_BusStop as BusStop
						   ,null as BusRoute
						   ,case when CL.CL_LevelofAccess = 1 then 'B'
								 when CL.CL_LevelofAccess = 2 then 'L'
								 else 'N/A'
							end as Accessibility
						   ,null as Walkin
						   ,CL.CL_Signage as BuiluingSign
						   ,CL.CL_ApptOnly as AppointmentNeed
						   ,CL.CL_OfficeHours as Hours
						   ,null as Latitude
						   ,null as Longitude
						   ,CL.CL_Id as LocationId
						   ,MG.PMG_Name as MedicalGroup
						   ,CPL.CCPL_ContractId as ContractId
						   ,case when CL.CL_SafetyNet = 2 then 1
								 else 0
							end as FederallyQualifiedHC
						   ,case when (
									   CL.CL_State is not null
									   and CL.CL_State <> ''
									  ) then CL.CL_State
								 else null
							end as State
							,Case when CL.CL_ProviderDirectory IN (0,2)  then 1 else 0 end as 
							IsInternalOnly
							,null as AddressRawHash
							,CL.CL_Address2 AS Street2, 1 AS IsEnabled
						from Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock)
							inner join Search.Provider as P with (nolock)
								on P.DiamProvId = CCI.CCI_ContractDiamondId
							inner join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
								on CPL.CCPL_ContractId = CCI.CCI_Id
							inner join Network_Development.dbo.Tbl_Contract_Locations as CL with (nolock)
								on CPL.CCPL_LocationId = CL.CL_Id
							inner  join Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
								on CPL.CCPL_ProviderId = PPI.PPI_Id
							left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
								on ZC.OZCA_zip = CL.CL_Zip
							left join Network_Development.dbo.Tbl_Provider_MedicalGroup as MG with (nolock)
								on MG.PMG_Id = CL.CL_MedicalGroup
						where P.ProviderType = 'SNF'
							and (
								 CPL.CCPL_TermDate is null
								 or CPL.CCPL_TermDate > @now
								)
							and (
								 CCI.CCI_ExpDate is null
								 or CCI.CCI_ExpDate > @now
								)
							and (
								 CL.CL_Address1 is not null
								 or CL.CL_Address1 <> ''
								)
								
							and not exists ( select 1
												from #Address as a
												where a.ProviderId = P.ProviderId ) 
			end	  
--------------------------------------------------------------------------------------------------------------------
			begin		--Merge SPec N Behav
				insert into #Address			--SPEC n BEhav
					select distinct P.ProviderId as ProviderId
						   ,locations.CL_Address1 as Street
						   ,locations.CL_City as City
						   ,locations.CL_Zip as Zip
						   ,ZC.OZCA_county as County
						   ,locations.CL_CountyCode as CountyCode
						   ,LN.CLNS_Phone as Phone
						   ,null as AfterHoursPhone
						   ,-- ??
							LN.CLNS_Fax as Fax
						   ,CASE WHEN Locations.CL_EmailVerified IS NOT NULL THEN Locations.CL_Email ELSE NULL end as Email
						   ,locations.CL_Website as Website
						   ,locations.CL_BusStop as Busstop
						   ,null as BusRoute
						   ,isnull(case	when isnull(locations.CL_Parking, '') <> ''
											 and isnull(locations.CL_ExtBuilding, '') <> ''
											 and isnull(locations.CL_IntBuilding, '') <> ''
											 and isnull(locations.CL_Restroom, '') <> ''
											 and isnull(locations.CL_ExamRoom, '') <> ''
											 and isnull(locations.CL_ExamTable, '') <> ''
										then locations.CL_Parking + ',' + locations.CL_ExtBuilding + ',' + locations.CL_IntBuilding + ','
											 + locations.CL_Restroom + ',' + locations.CL_ExamRoom + ',' + locations.CL_ExamTable
										else null
								   end, 'N/A') as Accessbility
						   ,locations.CL_WalkIn as WalkIN
						   ,locations.CL_Signage as BuildingSign
						   ,locations.CL_ApptOnly as AppointmentNeeded
						   ,-- ??  
							locations.CL_OfficeHours as Hours
						   ,null as Latitude
						   ,null as Longitude
						   ,locations.CL_Id as LocationId
						   ,MG.PMG_Name as MedicalGroup
						   ,null as ContractId
						   ,case when locations.CL_SafetyNet = 2 then 1
								 else 0
							end as FederallyQualifiedHC
						   ,case when (
									   locations.CL_State is not null
									   and locations.CL_State <> ''
									  ) then locations.CL_State
								 else null
							end as State
							,Case when Locations.CL_ProviderDirectory IN (0,2)  then 1 else 0 end as 
							IsInternalOnly
							,null as AddressRawHash
							,locations.CL_Address2 AS Street2, 1 AS IsEnabled
						from Search.Provider as P with (nolock)
							inner join Network_Development.dbo.Tbl_Provider_ProviderAffiliation as PPA with (nolock)
								on P.NetDevProvId = PPA.PPA_ProviderId
							inner join Network_Development.dbo.Tbl_Contract_Locations as locations with (nolock)
								on locations.CL_Id = PPA.PPA_LocationId
							left join Network_Development.dbo.Tbl_Contract_LocationsNumbers as LN with (nolock)
								on LN.CLNS_ProviderId = P.NetDevProvId
								   and LN.CLNS_LocationId = PPA.PPA_LocationId and LN.CLNS_Status = 1
							left join Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
								on PPI.PPI_Id = P.NetDevProvId
							left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
								on ZC.OZCA_zip = locations.CL_Zip
							left join Network_Development.dbo.Tbl_Provider_MedicalGroup as MG with (nolock)
								on MG.PMG_Id = locations.CL_MedicalGroup
						where P.ProviderType in ('SPEC', 'PCP/SPEC', 'BH')
							and (
								 PPA.PPA_TermDate is null
								 or PPA.PPA_TermDate > @now
								)
							and (
								 locations.CL_Address1 is not null
								 or locations.CL_Address1 <> ''
								)
								
						and not exists ( select 1
												from #Address as a
												where a.ProviderId = P.ProviderId )
			UNION
			select distinct P.ProviderId as ProviderId
						   ,locations.CL_Address1 as Street
						   ,locations.CL_City as City
						   ,locations.CL_Zip as Zip
						   ,ZC.OZCA_county as County
						   ,locations.CL_CountyCode as CountyCode
						   ,LN.CLNS_Phone as Phone
						   ,null as AfterHoursPhone
						   ,-- ??
							LN.CLNS_Fax as Fax
						   ,CASE WHEN Locations.CL_EmailVerified IS NOT NULL THEN Locations.CL_Email ELSE NULL end as Email
						   ,locations.CL_Website as Website
						   ,locations.CL_BusStop as Busstop
						   ,null as BusRoute
						   ,isnull(case	when isnull(locations.CL_Parking, '') <> ''
											 and isnull(locations.CL_ExtBuilding, '') <> ''
											 and isnull(locations.CL_IntBuilding, '') <> ''
											 and isnull(locations.CL_Restroom, '') <> ''
											 and isnull(locations.CL_ExamRoom, '') <> ''
											 and isnull(locations.CL_ExamTable, '') <> ''
										then locations.CL_Parking + ',' + locations.CL_ExtBuilding + ',' + locations.CL_IntBuilding + ','
											 + locations.CL_Restroom + ',' + locations.CL_ExamRoom + ',' + locations.CL_ExamTable
										else null
								   end, 'N/A') as Accessbility
						   ,locations.CL_WalkIn as WalkIN
						   ,locations.CL_Signage as BuildingSign
						   ,locations.CL_ApptOnly as AppointmentNeeded
						   ,-- ??  
							locations.CL_OfficeHours as Hours
						   ,null as Latitude
						   ,null as Longitude
						   ,locations.CL_Id as LocationId
						   ,MG.PMG_Name as MedicalGroup
						   ,null as ContractId
						   ,case when locations.CL_SafetyNet = 2 then 1
								 else 0
							end as FederallyQualifiedHC
						   ,case when (
									   locations.CL_State is not null
									   and locations.CL_State <> ''
									  ) then locations.CL_State
								 else null
							end as State
							,Case when Locations.CL_ProviderDirectory IN (0,2)  then 1 else 0 end as 
							IsInternalOnly
							,null as AddressRawHash
							,locations.CL_Address2  AS Street2, 1 AS IsEnabled
						from Search.Provider as P with (nolock)
							inner join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
								on P.NetDevProvId = CPL.CCPL_ProviderID
							inner join Network_Development.dbo.Tbl_Contract_Locations as locations with (nolock)
								on locations.CL_Id = CPL.CCPL_LocationID
							left join Network_Development.dbo.Tbl_Contract_LocationsNumbers as LN with (nolock)
								on LN.CLNS_ProviderId = P.NetDevProvId
								   and LN.CLNS_LocationId = CPL.CCPL_LocationID and LN.CLNS_Status = 1
							left join Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
								on PPI.PPI_Id = P.NetDevProvId
							left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
								on ZC.OZCA_zip = locations.CL_Zip
							left join Network_Development.dbo.Tbl_Provider_MedicalGroup as MG with (nolock)
								on MG.PMG_Id = locations.CL_MedicalGroup
						where P.ProviderType in ('SPEC', 'PCP/SPEC', 'BH') 
							--and (LN.CLNS_Status = 1)
							and (
								 CPL.CCPL_TermDate is null
							 or CPL.CCPL_TermDate > @now
								)
							and (
								 locations.CL_Address1 is not null
								 or locations.CL_Address1 <> ''
								)
								
							and not exists ( select 1
												from #Address as a
												where a.ProviderId = P.ProviderId )
			
						order by P.ProviderId
		
			end
---------------------------------------------------------------------------------------------
			begin		--Merge UC Address

				if object_id('tempdb..#UrgentCare') is not null
					drop table #UrgentCare

				select distinct																				--get urgent care diamondid , name and locationid
						cci.CCI_ContractDiamondId as DiamProvId
					   ,(isnull(uc.PMG_Name, uc.CCI_ContractName)) as OrganizationName
					   ,uc.LocationId as LocationId
					   ,null as NetDevProvId
					into #UrgentCare
					from Network_Development.dbo.Tbl_Contract_ContractInfo as cci with (nolock)
						inner join Network_Development.dbo.Tbl_Contract_UC_new as uc with (nolock)
							on uc.ContractId = cci.CCI_Id
							WHERE (CCI.CCI_TermDate IS NULL OR cci.CCI_TermDate > @now)
---------------------------------------
--address for delegated UC

				if object_id('tempdb..#delegatedUCAddress') is not null
					drop table #delegatedUCAddress
				select distinct 
						'' as DiamProvID
						,isnull(MG.PMG_Name, ppi.PPI_LastName) as OrganizationName
					   ,pdna.PDNA_LocationId as LocationId
					   ,pdna.PDNA_ProviderId as NetDevProvId
					into #delegatedUCAddress
					from Network_Development.dbo.Tbl_Provider_DelegatedNetwork_Affiliation pdna with (nolock) --on pdna.PDNA_ProviderId = ppi.ppi_id
						join Network_Development.dbo.Tbl_Contract_Locations as cl with (nolock)
							on cl.CL_Id = pdna.PDNA_LocationId
						left join Network_Development.dbo.Tbl_Provider_ProviderInfo as ppi with (nolock)
							on ppi.PPI_Id = pdna.PDNA_ProviderId
						left join Network_Development.dbo.Tbl_Provider_MedicalGroup as MG with (nolock)
							on MG.PMG_Id = cl.CL_MedicalGroup
					where pdna.PDNA_Specialty = 124 
-----------------------------
				
				INSERT INTO #UrgentCare
				select distinct Null,OrganizationName,LocationID,NetDevProvId from #delegatedUCAddress

---------------------------------
				insert into #Address
					select distinct P.ProviderId as ProviderId
						   ,Locations.CL_Address1 as Street
						   ,Locations.CL_City as City
						   ,Locations.CL_Zip as Zip
						   ,ZC.OZCA_county as County
						   ,Locations.CL_CountyCode as CountyCode
						   ,UCN.CLNS_Phone as Phone
						   ,UCN.CLNS_Fax as Fax
						   ,null as AfterHoursPhone
						   ,-- ?? 
							CASE WHEN Locations.CL_EmailVerified IS NOT NULL THEN Locations.CL_Email ELSE NULL end as Email
						   ,Locations.CL_Website as Website
						   ,Locations.CL_BusStop as Busstop
						   ,null as BusRoute
						   ,isnull(case	when isnull(Locations.CL_Parking, '') <> ''
											 and isnull(Locations.CL_ExtBuilding, '') <> ''
											 and isnull(Locations.CL_IntBuilding, '') <> ''
											 and isnull(Locations.CL_Restroom, '') <> ''
											 and isnull(Locations.CL_ExamRoom, '') <> ''
											 and isnull(Locations.CL_ExamTable, '') <> ''
										then Locations.CL_Parking + ',' + Locations.CL_ExtBuilding + ',' + Locations.CL_IntBuilding + ','
											 + Locations.CL_Restroom + ',' + Locations.CL_ExamRoom + ',' + Locations.CL_ExamTable
										else null
								   end, 'N/A') as Accessbility
						   ,Locations.CL_WalkIn as WalkIN
						   ,Locations.CL_Signage as BuildingSign
						   ,Locations.CL_ApptOnly as AppointmentNeeded
						   ,-- ??  
							Locations.CL_OfficeHours as Hours
						   ,null as Latitude
						   ,null as Longitude
						   ,UC.LocationId as LocationId
						   ,MG.PMG_Name as MedicalGroup
						   ,UCN.ContractId as ContractId
						   ,case when Locations.CL_SafetyNet = 2 then 1
								 else 0
							end as FederallyQualifiedHC
						   ,case when (
									   Locations.CL_State is not null
									   and Locations.CL_State <> ''
									  ) then Locations.CL_State
								 else null
							end as State
							,Case when Locations.CL_ProviderDirectory IN (0,2)  then 1 else 0 end as 
							IsInternalOnly
							,null as AddressRawHash
							,Locations.CL_Address2 AS Street2, 1 AS IsEnabled
						from Network_Development.dbo.Tbl_Contract_Locations as Locations with (nolock)
							inner join #UrgentCare as UC with (nolock)
								on UC.LocationId = Locations.CL_Id
							inner join Search.Provider as P with (nolock)
								on (P.netdevProviD= uc.netdevProvId and P.diamproviD = '') or (P.DiamProvID = UC.DiamProvID and P.netdevProvID is null)
							left join Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
								on PPI.PPI_Id = P.NetDevProvId
							left join Network_Development.dbo.Tbl_Contract_UC_new as UCN with (nolock)
								on UCN.LocationId = Locations.CL_Id
							left join Network_Development.dbo.Tbl_Provider_MedicalGroup as MG with (nolock)
								on MG.PMG_Id = Locations.CL_MedicalGroup
							left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
								on ZC.OZCA_zip = Locations.CL_Zip
						where (P.ProviderType = 'UC')
							and (
								 Locations.CL_Address1 is not null
								 or Locations.CL_Address1 <> ''
								)
								
							and not exists ( select 1
												from #Address as a
												where a.ProviderId = P.ProviderId )
						order by P.ProviderId
			
			
			end
---------------------------------------------------
			begin
				insert into #Address			--VSN
				select distinct P.ProviderId as ProviderId
						   ,locations.CL_Address1 as Street
						   ,locations.CL_City as City
						   ,locations.CL_Zip as Zip
						   ,ZC.OZCA_county as County
						   ,locations.CL_CountyCode as CountyCode
						   ,LN.CLNS_Phone as Phone
						   ,null as AfterHoursPhone
						   ,-- ??
							LN.CLNS_Fax as Fax
						   ,CASE WHEN Locations.CL_EmailVerified IS NOT NULL THEN Locations.CL_Email ELSE NULL end as Email
						   ,locations.CL_Website as Website
						   ,locations.CL_BusStop as Busstop
						   ,null as BusRoute
						   ,isnull(case	when isnull(locations.CL_Parking, '') <> ''
											 and isnull(locations.CL_ExtBuilding, '') <> ''
											 and isnull(locations.CL_IntBuilding, '') <> ''
											 and isnull(locations.CL_Restroom, '') <> ''
											 and isnull(locations.CL_ExamRoom, '') <> ''
											 and isnull(locations.CL_ExamTable, '') <> ''
										then locations.CL_Parking + ',' + locations.CL_ExtBuilding + ',' + locations.CL_IntBuilding + ','
											 + locations.CL_Restroom + ',' + locations.CL_ExamRoom + ',' + locations.CL_ExamTable
										else null
								   end, 'N/A') as Accessbility
						   ,locations.CL_WalkIn as WalkIN
						   ,locations.CL_Signage as BuildingSign
						   ,locations.CL_ApptOnly as AppointmentNeeded
						   ,-- ??  
							locations.CL_OfficeHours as Hours
						   ,null as Latitude
						   ,null as Longitude
						   ,locations.CL_Id as LocationId
						   ,MG.PMG_Name as MedicalGroup
						   ,null as ContractId
						   ,case when locations.CL_SafetyNet = 2 then 1
								 else 0
							end as FederallyQualifiedHC
						   ,case when (
									   locations.CL_State is not null
									   and locations.CL_State <> ''
									  ) then locations.CL_State
								 else null
							end as State
							,Case when Locations.CL_ProviderDirectory IN (0,2)  then 1 else 0 end as 
							IsInternalOnly
							,null as AddressRawHash
							,locations.CL_Address2 AS Street2, 1 AS IsEnabled
						from Search.Provider as P with (nolock)
							inner join Network_Development.dbo.Tbl_Provider_ProviderAffiliation as PPA with (nolock)
								on P.NetDevProvId = PPA.PPA_ProviderId
							inner join Network_Development.dbo.Tbl_Contract_Locations as locations with (nolock)
								on locations.CL_Id = PPA.PPA_LocationId
							left join Network_Development.dbo.Tbl_Contract_LocationsNumbers as LN with (nolock)
								on LN.CLNS_ProviderId = P.NetDevProvId
								   and LN.CLNS_LocationId = PPA.PPA_LocationId and LN.CLNS_Status = 1
							inner join Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
								on PPI.PPI_Id = P.NetDevProvId
							left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
								on ZC.OZCA_zip = locations.CL_Zip
							left join Network_Development.dbo.Tbl_Provider_MedicalGroup as MG with (nolock)
								on MG.PMG_Id = locations.CL_MedicalGroup
						where P.ProviderType in ('VSN')
							and (
								 PPA.PPA_TermDate is null
								 or PPA.PPA_TermDate > @now
								)
							and (
								 locations.CL_Address1 is not null
								 or locations.CL_Address1 <> ''
								)
								
							and not exists ( select 1
												from #Address as a
												where a.ProviderId = P.ProviderId )
					UNION
					select distinct P.ProviderId as ProviderId
						   ,locations.CL_Address1 as Street
						   ,locations.CL_City as City
						   ,locations.CL_Zip as Zip
						   ,ZC.OZCA_county as County
						   ,locations.CL_CountyCode as CountyCode
						   ,LN.CLNS_Phone as Phone
						   ,null as AfterHoursPhone
						   ,-- ??
							LN.CLNS_Fax as Fax
						  ,CASE WHEN Locations.CL_EmailVerified IS NOT NULL THEN Locations.CL_Email ELSE NULL end as Email
						   ,locations.CL_Website as Website
						   ,locations.CL_BusStop as Busstop
						   ,null as BusRoute
						   ,isnull(case	when isnull(locations.CL_Parking, '') <> ''
											 and isnull(locations.CL_ExtBuilding, '') <> ''
											 and isnull(locations.CL_IntBuilding, '') <> ''
											 and isnull(locations.CL_Restroom, '') <> ''
											 and isnull(locations.CL_ExamRoom, '') <> ''
											 and isnull(locations.CL_ExamTable, '') <> ''
										then locations.CL_Parking + ',' + locations.CL_ExtBuilding + ',' + locations.CL_IntBuilding + ','
											 + locations.CL_Restroom + ',' + locations.CL_ExamRoom + ',' + locations.CL_ExamTable
										else null
								   end, 'N/A') as Accessbility
						   ,locations.CL_WalkIn as WalkIN
						   ,locations.CL_Signage as BuildingSign
						   ,locations.CL_ApptOnly as AppointmentNeeded
						   ,-- ??  
							locations.CL_OfficeHours as Hours
						   ,null as Latitude
						   ,null as Longitude
						   ,locations.CL_Id as LocationId
						   ,MG.PMG_Name as MedicalGroup
						   ,null as ContractId
						   ,case when locations.CL_SafetyNet = 2 then 1
								 else 0
							end as FederallyQualifiedHC
						   ,case when (
									   locations.CL_State is not null
									   and locations.CL_State <> ''
									  ) then locations.CL_State
								 else null
							end as State
							,Case when Locations.CL_ProviderDirectory IN (0,2)  then 1 else 0 end as 
							IsInternalOnly
							,null as AddressRawHash
							,locations.CL_Address2 AS Street2, 1 AS IsEnabled

						from Search.Provider as P with (nolock)
							inner join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
								on P.NetDevProvId = CPl.CCPL_ProviderID
							inner join Network_Development.dbo.Tbl_Contract_Locations as locations with (nolock)
								on locations.CL_Id = CPl.CCPL_LocationID
							left join Network_Development.dbo.Tbl_Contract_LocationsNumbers as LN with (nolock)
								on LN.CLNS_ProviderId = P.NetDevProvId
								   and LN.CLNS_LocationId = CPl.CCPL_LocationID and LN.CLNS_Status = 1
							inner join Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
								on PPI.PPI_Id = P.NetDevProvId
							left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
								on ZC.OZCA_zip = locations.CL_Zip
							left join Network_Development.dbo.Tbl_Provider_MedicalGroup as MG with (nolock)
								on MG.PMG_Id = locations.CL_MedicalGroup
						where P.ProviderType in ('VSN')
							--and (LN.CLNS_Status = 1)
							and (
								 CPL.CCPL_TermDate is null
								 or CPL.CCPL_TermDate > @now
								)
							and (
								 locations.CL_Address1 is not null
								 or locations.CL_Address1 <> ''
								)
								
							and not exists ( select 1
												from #Address as a
												where a.ProviderId = P.ProviderId )
						order by P.ProviderId
			end	   --Merge VSN

			
-------------------------------------------------------------------------------------------
--Lat and lng from AddressGeoCoding Database
-------------------------------------------------------------------------------------------
Declare @bar char(1) = '|'


/*********************************************************************************************/
IF(@UseNewGeoCodingStuff = 1)
BEGIN


Update #Address 
set  AddressRawHash =  hashbytes('SHA1',ltrim(rtrim(upper(Street+' '+ISNULL(Street2,'')))) 
+ @bar + isnull(ltrim(rtrim(upper(City))), '') 
+ @bar + isnull(ltrim(rtrim(upper(State))), '') 
+ @bar + isnull(Zip, ''))
from #Address


Update DA			--Update lat and lng from new GeoCoded DB
Set DA.latitude = GAD.Latitude,
	DA.Longitude = GAD.Longitude
	from #Address as DA 
	Inner join AddressGeoCoding.GeoCode.RawAddress as GA with (nolock) on DA.AddressRawHash = GA.InputAddressHash
	Inner Join AddressGeoCoding.GeoCode.GeoCodeAddress as GAD with (nolock) on GAD.GeoCodeId = GA.GeoCodeId

Update DA			--update state from GeoCoded Table if not avaialbe in source
Set DA.State = GAD.State
	from #Address as DA 
	Inner join AddressGeoCoding.GeoCode.RawAddress as GA with (nolock) on DA.AddressRawHash = GA.InputAddressHash
	Inner Join AddressGeoCoding.GeoCode.GeoCodeAddress as GAD with (nolock) on GAD.GeoCodeId = GA.GeoCodeId
	where DA.State is null

END
-------------------------------------------------------------------------------------------
--Lat and lng from ProviderSearchCore.GeoCode Database
-------------------------------------------------------------------------------------------

IF(@UseNewGeoCodingStuff = 0)
BEGIN

--Declare @bar char(1) = '|'

	if object_id('tempdb..#TempGeoAddress') is not null
	drop table #TempGeoAddress

	select *, hashbytes('MD5',ltrim(rtrim(upper(Address+' '+ISNULL(Address2,'')))) 
	+ @bar + isnull(ltrim(rtrim(upper(City))),'') 
	+ @bar + isnull(ltrim(rtrim(upper(State))), '') 
	+ @bar + isnull(ZipCode, '')) as NewRowHash into #TempGeoAddress
	 from geocode.addresses


		Update #Address
	Set AddressRawHash = hashbytes('MD5',ltrim(rtrim(upper(street+' '+ISNULL(Street2,'')))) 
	+ @bar + isnull(ltrim(rtrim(upper(City))),'') 
	+ @bar + isnull(ltrim(rtrim(upper(State))), '') 
	+ @bar + isnull(Zip, ''))
	from #address


Update DA			--Update lat and lng from Old GeoCoded table 
Set DA.latitude = GAD.Latitude,
	DA.Longitude = GAD.Longitude
	from #Address as DA 
	Inner join #TempGeoAddress as GA with (nolock) on DA.AddressRawHash = GA.NewRowHash
	Inner Join GeoCode.GeocodedAddresses as GAD with (nolock) on GAD.GeoAddressID = GA.GeoAddressID

Update DA			--update state from Old GeoCoded Table if not avaialbe in source
Set DA.State = GAD.GeoState
	from #Address as DA 
	Inner join GeoCode.Addresses as GA with (nolock) on DA.AddressRawHash = GA.RowHash
	Inner Join GeoCode.GeocodedAddresses as GAD with (nolock) on GAD.GeoAddressID = GA.GeoAddressID
	where DA.State is null

	
END

-------------------------------------------------------------------------------------------

--Remove dups

if object_id('tempdb..#distinctAddresses') is not null
				drop table #distinctAddresses

/****************************************************************************************/
--Create temp table #distinctAddresses to get all the unique records
SELECT * INTO #distinctAddresses FROM #Address WHERE 1 = 0	 

/****************************************************************************************/

	INSERT INTO #distinctAddresses
			Select Distinct 
			ProviderID,
			Street,
			City,
			Zip,
			County,
			CountyCode,
			Phone,
			AfterHoursPhone,
			Fax,
			Email,
			WebSite,
			BusStop,
			BusRoute,
			Accessibility,
			Walkin,
			BuildingSign,
			AppointmentNeeded,
			Hours,
			Latitude,
			Longitude,
			LocationID,
			MedicalGroup,
			ContractID,
			FederallyQualifiedHC,
			State,
			IsInternalOnly,
			AddressRawHash,
			T.Street2,
			T.IsEnabled
			 from (  select *
				   ,row_number() over (partition by ProviderID, LocationID,ContractID order by ProviderID ) as ranking						
				from #Address as a with (nolock)
				) T where T.ranking = 1


/*******************************************************************************************************************************************/	
--Update Degree to Upper case

            UPDATE  AD
            SET     AD.MedicalGroup = CASE WHEN AD.MedicalGroup LIKE '% '
                                                + D.PPD_Degree + ' %'
                                           THEN REVERSE(( REPLACE(REVERSE(AD.MedicalGroup),
                                                              REVERSE(D.PPD_Degree),
                                                              UPPER(REVERSE(D.PPD_Degree))) ))
                                           WHEN AD.MedicalGroup LIKE '% '
                                                + D.PPD_Degree
                                           THEN REVERSE(( REPLACE(REVERSE(AD.MedicalGroup),
                                                              REVERSE(D.PPD_Degree),
                                                              UPPER(REVERSE(D.PPD_Degree))) ))
                                           WHEN AD.MedicalGroup LIKE '%'
                                                + D.PPD_Degree + '%'
                                           THEN REVERSE(REVERSE(REPLACE(( AD.MedicalGroup ),
                                                              REVERSE(D.PPD_Degree),
                                                              UPPER(REVERSE(D.PPD_Degree)))))
                                           ELSE MedicalGroup
                                      END
            FROM    #distinctAddresses AD
                    LEFT JOIN Network_Development.dbo.Tbl_Provider_ProviderDegree D
                    WITH ( NOLOCK ) ON AD.MedicalGroup LIKE '% '
                                       + D.PPD_Degree + '%'; 
			


/***************************************ENABLE / DISABLE Address RECORDS*******************************************************************/	

--Disable
	UPDATE T
	SET T.IsEnabled = 0
	FROM #distinctAddresses S
		RIGHT JOIN search.Address T  ON	   ( COALESCE(T.ProviderID,'') = COALESCE(S.ProviderId,''))
                                                       AND ( COALESCE(T.LocationID,'') = COALESCE(S.LocationId,''))
                                                       AND ( COALESCE(T.ContractID,'') = COALESCE(S.ContractId,''))
                 WHERE   S.AddressId IS NULL  AND ISNULL(T.IsEnabled,1) <> 0; 

--Enable
	UPDATE T
	SET T.IsEnabled = 1
	FROM #distinctAddresses S
		INNER JOIN search.Address T  ON	   ( COALESCE(T.ProviderID,'') = COALESCE(S.ProviderId,''))
                                                       AND ( COALESCE(T.LocationID,'') = COALESCE(S.LocationId,''))
                                                       AND ( COALESCE(T.ContractID,'') = COALESCE(S.ContractId,''))
                 WHERE ISNULL(T.IsEnabled,0) <> 1; 


--Update other fields when key fields matches
		UPDATE A
		SET A.Street				= (CASE WHEN ISNULL(A.Street,'')				<> ISNULL(AT.Street,'')					THEN search.udf_TitleCase(AT.Street)		ELSE A.Street				END),
			A.City					= (CASE WHEN ISNULL(A.City,'')					<> ISNULL(AT.City,'')					THEN search.udf_TitleCase(AT.City)			ELSE A.City					END),
			A.Zip					= (CASE WHEN ISNULL(A.Zip,'')					<> ISNULL(AT.Zip,'')					THEN AT.Zip									ELSE A.Zip					END),
			A.County				= (CASE WHEN ISNULL(A.County,'')				<> ISNULL(AT.County,'')					THEN search.udf_TitleCase(AT.County)		ELSE A.County				END),
			A.CountyCode			= (CASE WHEN ISNULL(A.CountyCode,'')			<> ISNULL(AT.CountyCode,'')				THEN AT.CountyCode							ELSE A.CountyCode			END),
			A.Phone					= (CASE WHEN ISNULL(A.Phone,'')					<> ISNULL(AT.Phone,'')					THEN AT.Phone								ELSE A.Phone				END),
			A.AfterHoursPhone		= (CASE WHEN ISNULL(A.AfterHoursPhone,'')		<> ISNULL(AT.AfterHoursPhone,'')		THEN AT.AfterHoursPhone						ELSE A.AfterHoursPhone		END),
			A.Fax					= (CASE WHEN ISNULL(A.Fax,'')					<> ISNULL(AT.Fax,'')					THEN AT.Fax									ELSE A.Fax					END),
			A.Email					= (CASE WHEN ISNULL(A.Email,'')					<> ISNULL(AT.Email,'')					THEN AT.Email								ELSE A.Email				END),
			A.WebSite				= (CASE WHEN ISNULL(A.WebSite,'')				<> ISNULL(AT.WebSite,'')				THEN AT.WebSite								ELSE A.WebSite				END),
			A.BusStop				= (CASE WHEN ISNULL(A.BusStop,'')				<> ISNULL(AT.BusStop,'')				THEN AT.BusStop								ELSE A.BusStop				END),
			A.BusRoute				= (CASE WHEN ISNULL(A.BusRoute,'')				<> ISNULL(AT.BusRoute,'')				THEN AT.BusRoute							ELSE A.BusRoute				END),
			A.Accessibility			= (CASE WHEN ISNULL(A.Accessibility,'')			<> ISNULL(AT.Accessibility,'')			THEN AT.Accessibility						ELSE A.Accessibility		END),
			A.Walkin				= (CASE WHEN ISNULL(A.Walkin,'')				<> ISNULL(AT.Walkin,'')					THEN AT.Walkin								ELSE A.Walkin				END),
			A.BuildingSign			= (CASE WHEN ISNULL(A.BuildingSign,'')			<> ISNULL(AT.BuildingSign,'')			THEN AT.BuildingSign						ELSE A.BuildingSign			END),
			A.AppointmentNeeded		= (CASE WHEN ISNULL(A.AppointmentNeeded,'')		<> ISNULL(AT.AppointmentNeeded,'')		THEN AT.AppointmentNeeded					ELSE A.AppointmentNeeded	END),
			A.Hours					= (CASE WHEN ISNULL(A.Hours,'')					<> ISNULL(AT.Hours,'')					THEN AT.Hours								ELSE A.Hours				END),
			A.Latitude				= (CASE WHEN ISNULL(A.Latitude,'')				<> ISNULL(AT.Latitude,'') 				THEN AT.Latitude							ELSE A.Latitude				END),
			A.Longitude				= (CASE WHEN ISNULL(A.Longitude,'')				<> ISNULL(AT.Longitude,'')				THEN AT.Longitude							ELSE A.Longitude			END),
			A.MedicalGroup			= (CASE WHEN ISNULL(A.MedicalGroup,'')			<> ISNULL(AT.MedicalGroup,'')			THEN search.udf_TitleCase(AT.MedicalGroup)	ELSE A.MedicalGroup			END),
			A.FederallyQualifiedHC	= (CASE WHEN ISNULL(A.FederallyQualifiedHC,'')	<> ISNULL(AT.FederallyQualifiedHC,'')	THEN AT.FederallyQualifiedHC				ELSE A.FederallyQualifiedHC END),
			A.State					= (CASE WHEN ISNULL(A.State,'')					<> ISNULL(AT.State,'')					THEN AT.State								ELSE A.State				END),
			A.IsInternalOnly		= (CASE WHEN ISNULL(A.IsInternalOnly,'')		<> ISNULL(AT.IsInternalOnly,'')			THEN AT.IsInternalOnly						ELSE A.IsInternalOnly		END),
			A.Street2				= (CASE WHEN ISNULL(A.Street2,'')				<> ISNULL(AT.Street2,'')				THEN AT.Street2	     						ELSE A.Street2				END)								

		FROM #distinctAddresses AT
		INNER JOIN search.Address AS A ON	( COALESCE(A.ProviderID,'') = COALESCE(AT.ProviderId,''))
										AND ( COALESCE(A.LocationID,'') = COALESCE(AT.LocationId,''))
										AND ( COALESCE(A.ContractID,'') = COALESCE(AT.ContractId,''))

				
--Insert new Records which were never in the Target table
		INSERT INTO search.Address
		SELECT    S.ProviderID ,
				  search.udf_TitleCase(S.street) ,
		          search.udf_TitleCase(S.City) ,
		          S.Zip ,
		          search.udf_TitleCase(S.County) ,
		          S.CountyCode ,
		          S.Phone ,
		          S.AfterHoursPhone ,
		          S.Fax ,
		          S.Email ,
		          S.WebSite ,
		          S.BusStop ,
		          S.BusRoute ,
		          S.Accessibility ,
		          S.Walkin ,
		          S.BuildingSign ,
		          S.AppointmentNeeded ,
		          S.Hours ,
		          S.Latitude ,
		          S.Longitude ,
		          S.LocationID ,
		          search.udf_TitleCase(S.MedicalGroup) ,
		          S.ContractID ,
		          S.FederallyQualifiedHC ,
		          S.State ,
		          S.IsInternalOnly ,
		          S.IsEnabled ,
		          S.Street2
		FROM #distinctAddresses S WITH (nolock)
		LEFT JOIN search.Address A ON 		( COALESCE(A.ProviderID,'') = COALESCE(S.ProviderId,''))
										AND ( COALESCE(A.LocationID,'') = COALESCE(S.LocationId,''))
										AND ( COALESCE(A.ContractID,'') = COALESCE(S.ContractId,''))
		WHERE A.AddressID IS null



/*******************************************************************************************************************************************/

--Update is INternal flag
            UPDATE  A
            SET     A.IsInternalOnly = CASE WHEN A.AddressID = EA.AddressID
                                            THEN 1
                                            ELSE 0
                                       END
            FROM    search.Address A
                    JOIN search.ExcludedAddresses EA WITH ( NOLOCK ) ON A.AddressID = EA.AddressID;


/************************************ DROP TEMP TABLES *****************************************************************************************/

		if object_id('tempdb..#Address') is not null
				drop table #Address

		if object_id('tempdb..#delegatedUCAddress') is not null
				drop table #delegatedUCAddress

				
		if object_id('tempdb..#distinctAddresses') is not null
				drop table #distinctAddresses

							
		if object_id('tempdb..#TempGeoAddress') is not null
				drop table #TempGeoAddress
										
		if object_id('tempdb..#UrgentCare') is not null
				drop table #UrgentCare


/*******************************************************************************************************************************************/

		end
	end



GO
/****** Object:  StoredProcedure [Import].[MergeAllProviderAffiliation]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

------------
CREATE Procedure [Import].[MergeAllProviderAffiliation]
 @Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
				10/03/2016	 1.00	SS		Added delete statements to delete child table data.
				11/12/2016	 1.01	SS		Fixed Bug (replaced join conditions)
				11/15/2016	 1.02 	SS		Address ID added for Hopsitals in Affilaitions
				11/15/2016	 1.03 	SS		ALl LOBS added in where condition of hospitals
				11/15/2016	 1.04	SS		Bug fixed for Urgent cares WF # 423827
				12/7/2016	 1.05	SS		Bug fixed for PCP affiliations. Removed where condition to check term date of affiliations in NetDEv
				6/29/2017	 1.06	SS		Bug fixed for Specialist. Removed where condition to check for admitters expiration date.
		*/
		declare @now date = getdate()
		declare @Version varchar(100) = '10/03/2016 2:22 Version 1.00'
		declare @ReturnValues table
			(
			 ReturnCode int primary key
							not null
			,Reason varchar(200) not null
			)

		insert into @ReturnValues
				(ReturnCode, Reason)
			values (0, 'Normal Return')			
											
		if @Showversion = 1
			begin
				select object_schema_name(@@PROCId) as SchemaName
					   ,object_name(@@PROCId) as ProcedureName
					   ,@Version as VersionInformation
				if isnull(@ShowReturn, 0) = 0
					return 0
			end

		if @ShowReturn = 1
			begin
				select *
					from @ReturnValues
				return 0
			end

		set nocount on


		begin
	--	declare @now date = getdate()
			if object_id('tempdb..#Affiliation') is not null
				drop table #Affiliation 

			create table #Affiliation
				(
				 AffiliationId int identity(1, 1)
								   not null
				,ProviderId int not null
				,DirectoryId varchar(20) null
				,LOB varchar(50) null
				,Panel varchar(15) null
				,IPAName varchar(50) null
				,IPAGroup varchar(30) null
				,IPACode varchar(3) null
				,IPAParentCode varchar(3) null
				,IPADesc varchar(50) null
				,HospitalName varchar(100) null
				,ProviderType varchar(15) null
				,AffiliationType varchar(50) null
				,AgeLimit varchar(30) null
				,AcceptingNewMbr bit null
				,EffectiveDate date null
				,TerminationDate date null
				,HospitalId varchar(12) null
				,IsHospitalAdmitter bit null
				,AcceptingNewMemberCode varchar(3) null
				,AddressId int null
				,IsInternalOnly bit default(0) NULL
                ,IsEnabled bit default(1) 
				)

		
------------------------------------------------------------------------------
			begin		--ANC
				insert into #Affiliation
					select distinct p.ProviderId as ProviderId
						   ,null as DirectoryId
						   ,case when LV.CLBS_LOB = 'Medi-Cal' then 'MED'
								 when LV.CLBS_LOB = 'MediCal' then 'MED'
								 when LV.CLBS_LOB = 'Coordinated Care Initiative - MediCal' then 'CCI'
								 when LV.CLBS_LOB = 'Dual Choice CalMediConnect' then 'CMC'
								 when LV.CLBS_LOB = 'MediCare' then 'CMC'
								 when LV.CLBS_LOB = 'Open Access' then 'OA'
								 when LV.CLBS_LOB = 'Healthy Kids' then 'PGM'
								 else LV.CLBS_LOB
							end as LOB
						   ,null as Panel
						   ,'IEHP Direct' as IPaName
						   ,null as IPAgroup
						   ,'JJJ' as IPACode
						   ,null as IPAParentCode
						   ,null as IPADesc
						   ,null as HospitalName
						   ,p.ProviderType as ProviderType
						   ,null as AffiliationType
						   ,null as AgeLimit
						   ,case when PPI.PPI_RosterSuppression = 5 then 0			--RosterSuprresion codes shows a provider is accepting new members or not
								 else 1
							end as AcceptingNewMember
						   ,CCI.CCI_OrgEffDate as EffectiveDate
						   ,CCi.CCI_termdate as  TermDate
						   ,null as HospitalId
						   ,null as IsHospitalAdmitter
						   ,null as AcceptingNewMemberCode
						  ,a.AddressId as AddressId
						   ,0 as IsInternalOnly, 1 as IsEnabled
						from Search.Provider p with (nolock)
							inner join Network_Development.dbo.Tbl_Contract_CPL as cpl with (nolock)
								on cpl.CCPL_ProviderId = p.NetDevProvId
							Inner join Search.Address a with (nolock)
								on a.ProviderId = p.ProviderId
								   and a.LocationId = cpl.CCPL_LocationId	
							Inner join Network_Development.dbo.tbl_Contract_ContractInfo as CCI with (nolock) on CCI.CCI_Id = Cpl.CCPL_COntractID
							left join Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
								on p.NetDevProvId = PPI.PPI_Id
							left join Network_Development.dbo.Tbl_Contract_ContractedSpecial as CCS with (nolock)
								on CCS.CCSP_ContractId = cpl.CCPL_ContractId and CCS.CCSP_contractID = CCI.CCI_ID
							left join Network_Development.dbo.Tbl_Contract_ContractedLOC as LOC with (nolock)
								on LOC.CLOC_ContractId = cpl.CCPL_ContractId and LOC.CLOC_ContractID = CCI.CCI_ID
							left join Network_Development.dbo.Tbl_Contract_ContractedLOB as CLOB with (nolock)
								on CLOB_ContractId = cpl.CCPL_ContractId and CLOB_ContractID = CCI.CCI_ID
							left join Network_Development.dbo.Tbl_Contract_ContractedLOBSelection as LV with (nolock)
								on (
									LV.CLBS_Id = CCSP_LOB
									or LV.CLBS_Id = CLOB_LOB
									or LV.CLBS_Id = CLOC_LOB
								   )
													--List value 83 is to get the LOB
						where p.ProviderType in ('ANC', 'DANC', 'LTSS', 'SNF', 'IPA')
							and (
								 CLOB_TermDate is null
								 or CLOB_TermDate > @now
								)
							and (
								 CLOC_ExpirationDate is null
								 or CLOC_ExpirationDate > @now
								)
							and (
								 CCSP_TermDate is null
								 or CCSP_TermDate > @now
								)
								and (CCI.CCI_termdate is null or CCI.CCI_termdate > getdate())
							and
							 (
							 CPL.CCPl_TermDate is null or CPl.CCPL_Termdate > @now
							)
							and (LV.CLBS_LOB is not null)
							and (LV.CLBS_LOB in ('Medi-Cal', 'MediCal', 'Dual Choice CalMediConnect', 'MediCare', 'Healthy Kids', 'Open Access', 'All LOBs'))
							and LV.CLBS_Exclude = 0
					union
					select distinct p.ProviderId as ProviderId
						   ,null as DirectoryId
						   ,case when LV.DBLV_Value = 'Medi-Cal' then 'MED'
								 when LV.DBLV_Value = 'Coordinated Care Initiative - MediCal' then 'CCI'
								 when LV.DBLV_Value = 'Dual Choice CalMediConnect' then 'CMC'
								 when LV.DBLV_Value = 'MediCare' then 'CMC'
								 else LV.DBLV_Value
							end as LOB
						   ,null as Panel
						   ,Case WHEN PDNA.PDNA_IPA = '00L' THEN 'Loma Linda University Health Care' else LV1.DBLV_Value end as IPaName
						   ,null as IPAgroup
						   ,PDNA.PDNA_IPA as IPACode
						   ,null as IPAParentCode
						   ,null as IPADesc
						   ,null as HospitalName
						   ,p.ProviderType as ProviderType
						   ,null as AffiliationType
						   ,null as AgeLimit
						   ,case when PPI.PPI_RosterSuppression = 5 then 0			--RosterSuprresion codes shows a provider is accepting new members or not
								 else 1
							end as AcceptingNewMember
						   ,PDNA.PDNA_EffDate as EffectiveDate
						   ,PDNA.PDNA_TermDate as TermDate
						   ,null as HospitalId
						   ,null as IsHospitalAdmitter
						   ,null as AcceptingNewMemberCode
						   ,a.AddressId as AddressId
						   ,0 as IsInternalOnly, 1 as IsEnabled
						from Search.Provider p with (nolock)
							left join Network_Development.dbo.Tbl_Provider_DelegatedNetwork_Affiliation as PDNA with (nolock)
								on PDNA_ProviderId = p.NetDevProvId
							left join Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
								on p.NetDevProvId = PPI.PPI_Id
							left join Network_Development.dbo.Tbl_Database_ListValues as LV with (nolock)
								on LV.DBLV_Id = PDNA.PDNA_LOB
								   and LV.DBLV_List = 83							--List value 83 is to get the LOB
							left join Network_Development.dbo.Tbl_Database_ListValues as LV1 with (nolock)
								on LV1.DBLV_Abbreviation = PDNA.PDNA_IPA
								   and LV1.DBLV_List = 76
							Inner join Search.Address a with (nolock)
								on a.ProviderId = p.ProviderId
								   and a.LocationId = PDNA.PDNA_LocationId		--List Value 76 is to get the IPA names for IPA codes
						where (p.ProviderType in ('ANC', 'DANC', 'LTSS', 'SNF', 'IPA'))
							and PDNA.PDNA_LOB in (1, 2)
							and (
								 PDNA_TermDate > @now
								 or PDNA_TermDate is null
								)	
			end
--------------------------------------------------------------------------------
			begin			--HOSP

				insert into #Affiliation
					select distinct P.ProviderId as ProviderId
						   ,C.PBUSERDEF as DirectoryId
						   ,C.PBLOB as LOB
						   ,C.PBPANEL as Panel
						   ,I.PJNAME1 as IPAName
						   ,I.PJNAME2 as IPAgroup
						   ,C.PBIPA as IPAcode
						   ,I.PJPARENT as IPAparentCode
						   ,I.PJDESCR as IPADesc
						   ,HC.[Hospital Name (Printing)] as HospitalName
						   ,F.PATYPE as ProviderType
						   ,null as AffiliationType
						   ,F.PAUSERDEF3 as AgeLimit
						   ,case F.PANEWPT
							  when 'Y' then 1
							  else 0
							end as AcceptingNewMbr
						   ,C.PBEFFDATE as EffectiveDate
						   ,C.PBTERMDATE as TerminationDate
						   ,HC.[Hospital Code] as HospitalId
						   ,case when PAH.PPAH_HospitalPrivilege = 7 then 1						--HospitalPrivilege = 7 shows that a hosp or provider has Admitting privilege
							end as IsHospitalAdmitter
						   ,null as AcceptingNewMemberCode
						   ,ad.AddressID as AddressId
						   ,0 as IsInternalOnly, 1 as IsEnabled
						from Diam_725_App.diamond.JPROVCM0_DAT (nolock) as C
							inner join Diam_725_App.diamond.JPROVFM0_DAT (nolock) as F
								on C.PBPROVId = F.PAPROVId
							inner join Search.Provider as P with (nolock)
								on C.PBPROVId = P.DiamProvId
								   and F.PAPROVId = P.DiamProvId
								   and F.PANATLId = P.NPI
							inner join search.address as ad with (nolock) on ad.ProviderID = p.ProviderID
							left join Network_Development.dbo.Tbl_Codes_Hospitals as HC with (nolock)
								on HC.[Hospital Name (Printing)] = P.OrganizationName
							left join Network_Development.dbo.Tbl_Provider_ProviderAffiliationHosp as PAH with (nolock)
								on PAH.PPAH_ProviderId = P.NetDevProvId
							left join Diam_725_App.diamond.JIPAVAM0_DAT (nolock) as I
								on C.PBIPA = I.PJIPA
						where (C.PBPANEL <> '')
							and (P.ProviderType = 'HOSP')
							and (
								 C.PBTERMDATE is null
								 or C.PBTERMDATE >= @now
								)
					union
					select distinct p.ProviderId as ProviderId
						   ,null as DirectoryId
						   ,case when LV.CLBS_LOB = 'Medi-Cal' then 'MED'
								 when LV.CLBS_LOB = 'MediCal' then 'MED'
								 when LV.CLBS_LOB = 'Coordinated Care Initiative - MediCal' then 'CCI'
								 when LV.CLBS_LOB = 'Dual Choice CalMediConnect' then 'CMC'
								 when LV.CLBS_LOB = 'MediCare' then 'CMC'
								 when LV.CLBS_LOB = 'Open Access' then 'OA'
								 when LV.CLBS_LOB = 'Healthy Kids' then 'PGM'
								 else LV.CLBS_LOB
							end as LOB
						   ,null as Panel
						   ,'IEHP Direct' as IPaName
						   ,null as IPAgroup
						   ,'JJJ' as IPACode
						   ,null as IPAParentCode
						   ,null as IPADesc
						   ,null as HospitalName
						   ,p.ProviderType as ProviderType
						   ,null as AffiliationType
						   ,null as AgeLimit
						   ,case when CPL.CCPL_RosterSuppression = 5 then 0
								 else 1
							end as AcceptingNewMember
						   ,case when CCS.CCSP_ContractId = CCI.CCI_Id then CCSP_EffectiveDate
								 when LOC.CLOC_ContractId = CCI.CCI_Id then CLOC_EffectiveDate
								 when CLOB_ContractId = CCI.CCI_Id then CLOB_EffDate
							end as EffectiveDate
						   ,case when CCS.CCSP_ContractId = CCI.CCI_Id then CCSP_TermDate
								 when LOC.CLOC_ContractId = CCI.CCI_Id then CLOC_ExpirationDate
								 when CLOB_ContractId = CCI.CCI_Id then CLOB_ExpDate
							end as TermDate
						   ,null as HospitalId
						   ,null as IsHospitalAdmitter
						   ,null as AcceptingNewMemberCode
						   ,ad.AddressID as AddressId
						   ,0 as IsInternalOnly, 1 as IsEnabled
						from Search.Provider p with (nolock)
							inner join search.address as ad with (nolock) on ad.ProviderID = p.ProviderID
							left join Network_Development.dbo.Tbl_Contract_CPL as CPL  with (nolock)
								on CPL.CCPL_ProviderID = P.NetDevProvID
							left join Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock)
								on CCI.CCI_ID = CPL.CCPL_ContracTID
							left join Network_Development.dbo.Tbl_Contract_ContractedSpecial as CCS  with (nolock)
								on CCS.CCSP_ContractId = CCI.CCI_Id
							left join Network_Development.dbo.Tbl_Contract_ContractedLOC as LOC  with (nolock)
								on LOC.CLOC_ContractId = CCI.CCI_Id
							left join Network_Development.dbo.Tbl_Contract_ContractedLOB as CLOB  with (nolock)
								on CLOB_ContractId = CCI.CCI_Id
							
							left join Network_Development.dbo.Tbl_Contract_ContractedLOBSelection as LV with (nolock)
								on (
									LV.CLBS_Id = CCSP_LOB
									or LV.CLBS_Id = CLOB_LOB
									or LV.CLBS_Id = CLOC_LOB
								   )							--List value 83 is to get the LOB

						where p.ProviderType in ('HOSP')
							and (
								 CLOB_TermDate is null
								 or CLOB_TermDate > @now
								)
							and (
								 CLOC_ExpirationDate is null
								 or CLOC_ExpirationDate > @now
								)
							and (
								 CCSP_TermDate is null
								 or CCSP_TermDate > @now
								)
							and (LV.CLBS_LOB is not null)
							and (LV.CLBS_LOB in ('Medi-Cal', 'MediCal', 'Dual Choice CalMediConnect', 'MediCare', 'Healthy Kids', 'Open Access', 'All LObs'))
							and LV.CLBS_Exclude = 0
			end
------------------------------------------------------------------------------------------
			begin				--NPP
				insert into #Affiliation				--NPP
						select distinct P.ProviderId as ProviderId
						   ,PPA.PPA_PCPId as DirectoryId
						   ,case when LV.DBLV_Value = 'Medi-Cal' then 'MED'
								 when LV.DBLV_Value = 'Coordinated Care Initiative - MediCal' then 'CCI'
								 when LV.DBLV_Value = 'Dual Choice CalMediConect' then 'CMC'
								 when LV.DBLV_Value = 'MediCare' then 'CMC'
								 else LV.DBLV_Value
							end as LOB
						   ,null as Panel
						   ,Case WHEN PPA.PPA_IPAId = '00L' THEN 'Loma Linda University Health Care' else LV1.DBLV_Value end as IPaName
						   ,null as IPAgroup
						   ,PPA.PPA_IPAId as IPACode
						   ,null as IPAParentCode
						   ,null as IPADesc
						   ,HC.[Hospital Name (Printing)] as HospitalName
						   ,AT.PAT_PROVAType as ProviderType
						   ,AT.PAT_AffiliationType as AffiliationType
						   ,AL.PAL_AgeLimit as AgeLimit
						   ,case when PPI.PPI_RosterSuppression = 5 then 0			--RosterSuprresion codes shows a provider is accepting new members or not
								 else 1
							end as AcceptingNewMember
						   ,PPA.PPA_EffDate as EffectiveDate
						   ,PPA.PPA_TermDate as TermDate
						   ,PPA.PPA_HospitalId as HospitalId
						   ,case when isnull(PAD.PAD_ProviderId, '') = P.NetDevProvId then 1
								 when isnull(PAH.PPAH_HospitalPrivilege, '') = 7 then 1
								 when (
									   PPA.PPA_HospitalId in ('N/A', '9999', 'C/o', 'OPSC', '0088')
									   or PPA.PPA_HospitalId is null
									  ) then null
								 when (
									   isnull(PAD.PAD_ProviderId, '') = P.NetDevProvId
									   and isnull(PAD.PAD_ProviderId, '') = PAD.PAD_AdmitterId
									  ) then 0
								 when PAH.PPAH_HospitalPrivilege in (1, 2, 3, 8) then 0
								 else null
							end as IsHospitalAdmitter
						   ,null as AcceptingNewMemberCode
						   ,a.AddressId as AddressId
						   ,0 as IsInternalOnly, 1 as IsEnabled
						from Network_Development.dbo.Tbl_Provider_ProviderAffiliation as PPA with (nolock)
							inner join Network_Development.dbo.Tbl_Provider_AffiliationType as AT with (nolock)
								on AT.PAT_Id = PPA.PPA_AffiliationType
							left join Network_Development.dbo.Tbl_Provider_ProviderAffiliationIPA as PIPA with (nolock) on
								 PIPA.PPAI_ProviderID = PPA.PPA_ProviderID and PIPA.PPAI_IPAID = PPA.PPA_IPAID
							left join Network_Development.dbo.Tbl_Provider_AgeLimits as AL with (nolock) on
								 AL.PAL_AgeLimitID = PPAI_AgeLimit
							inner join Network_Development.dbo.Tbl_Database_ListValues as LV with (nolock)
								on LV.DBLV_Id = AT.PAT_LOB
								   and LV.DBLV_List = 83							--List value 83 is to get the LOB
							inner join Network_Development.dbo.Tbl_Database_ListValues as LV1 with (nolock)
								on LV1.DBLV_Abbreviation = PPA.PPA_IPAId
								   and LV1.DBLV_List = 76			--List Value 76 is to get the IPA names for IPA codes
							inner join Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
								on PPI.PPI_Id = PPA.PPA_ProviderId
							inner join Network_Development.dbo.Tbl_Contract_LocationsNumbers as LocationsNumbers with (nolock)
								on PPA.PPA_LocationId = LocationsNumbers.CLNS_LocationId
								   and PPA.PPA_ProviderId = LocationsNumbers.CLNS_ProviderId
							inner join Search.Provider as P with (nolock)
								on P.NetDevProvId = PPI.PPI_Id
							left join (
									   select *
										from (
											  select *
												   ,row_number() over (partition by PPAH_ProviderId, PPAH_HospitalId order by PPAH_DateEntered desc) as ranking						--join to identify all the ProviderId with Admitter Privilege (if one hospita has two privilege get one with latest entered date)
												from Network_Development.dbo.Tbl_Provider_ProviderAffiliationHosp as PAH with (nolock)
											 ) as T
										where ranking = 1
									  ) as PAH
								on PAH.PPAH_ProviderId = PPA.PPA_ProviderId
								   and PPAH_HospitalId = PPA.PPA_HospitalId
							left join Network_Development.dbo.Tbl_Provider_ProviderAdmitters as PAD with (nolock)
								on PAD.PAD_ProviderId = PPA.PPA_ProviderId and (PAD.PAD_TermDate is null  or PAD.PAD_TermDate > @now)
							left join Network_Development.dbo.Tbl_Provider_ProviderAffiliationIPA as PPAI with (nolock)
								on PPAI.PPAI_ProviderId = PPI.PPI_Id
							left join Network_Development.dbo.Tbl_Codes_Hospitals as HC with (nolock)
								on HC.[Hospital Code] = PPA.PPA_HospitalId
							INNER join Search.Address a with (nolock)
								on a.ProviderId = P.ProviderId
								   and a.LocationId = PPA.PPA_LocationId
						where (AT.PAT_AffiliationType in ('NMW', 'NMW/CCI', 'NMW/DUAL CHOICE', 'NP', 'NP/CCI', 'NP/DUAL CHOICE', 'NP/UC', 'PA', 'PA/CCI',
														  'PA/DUAL CHOICE', 'PA/UC'))
							and (
								 PPA.PPA_TermDate is null
								 or PPA.PPA_TermDate > @now
								)
									and 
								(		 PIPA.PPAI_TermDate is null
										or PIPA.PPAI_TermDate > @now
								)	
								--and (PIPA.PPAI_IPAStatus = 1)
							and (
								 (
								  LV.DBLV_Value <> 'MediCare'
								  or LV.DBLV_Value <> 'Dual Choice CalMediConect'
								 )
								 or (
									 (
									  LV.DBLV_Value = 'MediCare'
									  and PPI.PPI_MedicareOptOut = 0
									 )
									 or (
										 LV.DBLV_Value = 'Dual Choice CalMediConect'
										 and PPI.PPI_MedicareOptOut = 0
										)
									)
								)
			
			end
------------------------------------------------------------------------------------------------------------------------
			begin				--PCP
			
		

				insert into #Affiliation
						select distinct P.ProviderId as ProviderId
						   ,C.PBUSERDEF as DirectoryId
						   ,case when HC.[Hospital Name (Printing)] = 'Open Access' then 'OA'
								 when F2.PANAME1 = 'Open Access' then 'OA'
								-- WHEN C.PBPANEL = '206' and C.PBLOB = 'MED' THEN 'CMC'
							
								 else C.PBLOB
							end as LOB
						   ,C.PBPANEL as Panel
						   ,I.PJNAME1 as IPAName
						   ,I.PJNAME2 as IPAgroup
						   ,C.PBIPA as IPAcode
						   ,I.PJPARENT as IPAparentCode
						   ,I.PJDESCR as IPADesc
						   ,case when PPA.PPA_PCPId = C.PBUSERDEF then HC.[Hospital Name (Printing)]
								 else F2.PANAME1
							end as HospitalName
						   ,F.PATYPE as ProviderType
						   ,case when P.ProviderType = 'PCP' then 'PCP'
								 when P.ProviderType = 'NPCP' then 'NON-PAR PCP'
								 when P.ProviderType = 'MPCP' then 'MOBILE PCP'
								 when P.ProviderType = 'TPCP' then 'TEMPORARY PCP'
								 else 'PCP'
							end as AffiliationType
						   ,F.PAUSERDEF3 as AgeLimit
						   ,case  WHEN C.PBFACILNUMB in('001','002','003','007') THEN 1 ELSE 0 
							end as AcceptingNewMbr
						   ,C.PBEFFDATE as EffectiveDate
						   ,C.PBTERMDATE as TerminationDate
						   ,case when (ISNULL(PPA.PPA_PCPId,'') = C.PBUSERDEF) then PPA.PPA_HospitalId
								 else ('00' + PIP.PIHOSP)
							end as hospitalId
						   ,case when (
									   isnull(PAD.PAD_ProviderId, '') = P.NetDevProvId
									   and (
											PAD.PAD_TermDate is not null
											or PAD.PAD_TermDate < @now
										   )
									   and isnull(PAH.PPAH_HospitalPrivilege, '') = 7
									  ) then 1
								 when isnull(PAH.PPAH_HospitalPrivilege, '') = 7 then 1
								 when (
									   PPA.PPA_HospitalId in ('N/A', '9999', 'C/o', 'OPSC', '0088', '0089')
									   or PPA.PPA_HospitalId is null
									  ) then null
								 when (
									   isnull(PAD.PAD_ProviderId, '') = P.NetDevProvId
									   and isnull(PAD.PAD_ProviderId, '') = PAD.PAD_AdmitterId
									  ) then 0
								 when PAH.PPAH_HospitalPrivilege in (1, 2, 3, 8) then 0
								 else null
							end as IsHospitalAdmitter
						   ,C.PBFACILNUMB as AcceptingNewMemberCode
						   ,a.AddressId as AddressId
						   ,0 as IsInternalOnly, 1 as IsEnabled
						from Diam_725_App.diamond.JPROVFM0_DAT (nolock) as F
							inner join Search.Provider as P with (nolock)
								on F.PAPROVId = P.DiamProvId
					
							inner join Diam_725_App.diamond.JPROVCM0_DAT (nolock) as C
								on F.PAPROVId = C.PBPROVId
							left join Diam_725_App.diamond.JIPAVAM0_DAT (nolock) as I
								on C.PBIPA = I.PJIPA
							left join Diam_725_App.diamond.JPANELM0_DAT (nolock) as PIP
								on PIP.PIPANEL = C.PBPANEL
							left join Diam_725_App.diamond.JPROVFM0_DAT as F2 (nolock)
								on F2.PAPROVId = PIP.PIPROVF
							left join Diam_725_App.diamond.JPROVAM0_DAT as A2 (nolock)
								on F.PAPROVId = A2.PCPROVId
							left join Network_Development.dbo.Tbl_Provider_ProviderAffiliation as PPA with (nolock)
								on PPA.PPA_ProviderId = P.NetDevProvId 
								   and ISNULL(PPA.PPA_PCPId,'') = C.PBUSERDEF  and (PPA.PPA_TermDate is null or PPa.PPA_TermDate > @now)
							left join Network_Development.dbo.Tbl_Codes_Hospitals as HC with (nolock)
								on HC.[Hospital Code] = PPA.PPA_HospitalId
							left join (
									   select *
										from (
											  select *
												   ,row_number() over (partition by PPAH_ProviderId, PPAH_HospitalId order by PPAH_DateEntered desc) as ranking						--join to identify all the ProviderId with Admitter Privilege (if one hospita has two privilege get one with latest entered date)
												from Network_Development.dbo.Tbl_Provider_ProviderAffiliationHosp as PAH with (nolock)
											 ) as T
										where ranking = 1
									  ) as PAH
								on PAH.PPAH_ProviderId = PPA.PPA_ProviderId
								   and PPAH_HospitalId = PPA.PPA_HospitalId
							left join Network_Development.dbo.Tbl_Provider_ProviderAdmitters as PAD with (nolock)
								on PAD.PAD_ProviderId = PPA.PPA_ProviderId and (PAD.PAD_TermDate is null  or PAD.PAD_TermDate > @now)
									Inner join Search.Address a with (nolock)
								on a.ProviderId = P.ProviderId and a.IsInternalOnly = 0
								   and a.LocationId = ISNULL(A2.PCNDLOCID,F.PANDLOCID)
						where P.ProviderType in ('PCP', 'NPCP', 'MPCP', 'TPCP')
							and C.PBPANEL < > ''
							and F.PATYPE in ('PCP', 'NPCP', 'MPCP', 'TPCP')
							and (
								 C.PBTERMDATE is null
								 or C.PBTERMDATE >= @now
								)
							and (C.PBPARFLAG = 'Y')
							and (C.PBPCPFLAG = 'Y')
							and (
								 C.PBUSERDEF <> ''
								 and C.PBUSERDEF is not null
								)
						

			end
--------------------------------------------------------------------------------------
			begin				--SPEC n BH
				insert into #Affiliation				--Spec n Behav
					
	select distinct P.ProviderId as ProviderId
						   ,PPA.PPA_PCPId as DirectoryId
						   ,case when LV.DBLV_Value = 'Medi-Cal' then 'MED'
								 when LV.DBLV_Value = 'Coordinated Care Initiative - MediCal' then 'CCI'
								 when LV.DBLV_Value = 'Dual Choice CalMediConect' then 'CMC'
								 when LV.DBLV_Value = 'MediCare' then 'CMC'
								 else LV.DBLV_Value
							end as LOB
						   ,null as Panel
						   ,Case WHEN PPA.PPA_IPAId = '00L' THEN 'Loma Linda University Health Care' else LV1.DBLV_Value end as IPaName
						   ,null as IPAgroup
						   ,PPA.PPA_IPAId as IPACode
						   ,null as IPAParentCode
						   ,null as IPADesc
						   ,HC.[Hospital Name (Printing)] as HospitalName
						   ,P.ProviderType as ProviderType
						   ,AT.PAT_AffiliationType as AffiliationType
						   ,AL.PAL_AgeLimit as AgeLimit
						   ,case when PPI.PPI_RosterSuppression = 5 then 0			--RosterSuprresion codes shows a provider is accepting new members or not
								 else 1
							end as AcceptingNewMember
						   ,PPA.PPA_EffDate as EffectiveDate
						   ,PPA.PPA_TermDate as TermDate
						   ,PPA.PPA_HospitalId as HospitalId
						   ,case when isnull(PAD.PAD_ProviderId, '') = P.NetDevProvId then 1
								 when isnull(PAH.PPAH_HospitalPrivilege, '') = 7 then 1
								 when (
									   PPA.PPA_HospitalId in ('N/A', '9999', 'C/o', 'OPSC', '0088')
									   or PPA.PPA_HospitalId is null
									  ) then null
								 when (
									   isnull(PAD.PAD_ProviderId, '') = P.NetDevProvId
									   and isnull(PAD.PAD_ProviderId, '') = PAD.PAD_AdmitterId
									  ) then 0
								 when PAH.PPAH_HospitalPrivilege in (1, 2, 3, 8) then 0
								 else null
							end as IsHospitalAdmitter
						   ,null as AcceptingNewMemberCode
						   ,a.AddressId as AddressId
						   ,0 as IsInternalOnly, 1 as IsEnabled
						from Network_Development.dbo.Tbl_Provider_ProviderAffiliation as PPA with (nolock)
							inner join Search.Provider as P with (nolock)
								on P.NetDevProvId = PPA.PPA_ProviderId
							inner join Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
								on PPI.PPI_Id = PPA.PPA_ProviderId
							inner join Network_Development.dbo.Tbl_Provider_AffiliationType as AT with (nolock)
								on AT.PAT_Id = PPA.PPA_AffiliationType
							left join Network_Development.dbo.Tbl_Provider_ProviderAffiliationIPA as PIPA with (nolock) on
								 PIPA.PPAI_ProviderID = PPA.PPA_ProviderID and PIPA.PPAI_IPAID = PPA.PPA_IPAID
							left join Network_Development.dbo.Tbl_Provider_AgeLimits as AL with (nolock) on
								 AL.PAL_AgeLimitID = PPAI_AgeLimit
							left join Network_Development.dbo.Tbl_Database_ListValues as LV with (nolock)
								on LV.DBLV_Id = AT.PAT_LOB
								   and LV.DBLV_List = 83							--List value 83 is to get the LOB
							left join Network_Development.dbo.Tbl_Database_ListValues as LV1 with (nolock)
								on LV1.DBLV_Abbreviation = PPA.PPA_IPAId
								   and LV1.DBLV_List = 76			--List Value 76 is to get the IPA names for IPA codes
							left join Network_Development.dbo.Tbl_Contract_LocationsNumbers as LocationsNumbers with (nolock)
								on PPA.PPA_LocationId = LocationsNumbers.CLNS_LocationId
								   and PPA.PPA_ProviderId = LocationsNumbers.CLNS_ProviderId
							left join (
									   select *
										from (
											  select *
												   ,row_number() over (partition by PPAH_ProviderId, PPAH_HospitalId order by PPAH_DateEntered desc) as ranking						--join to identify all the ProviderId with Admitter Privilege (if one hospita has two privilege get one with latest entered date)
												from Network_Development.dbo.Tbl_Provider_ProviderAffiliationHosp as PAH with (nolock)
											 ) as T
										where ranking = 1
									  ) as PAH
								on PAH.PPAH_ProviderId = PPA.PPA_ProviderId
								   and PPAH_HospitalId = PPA.PPA_HospitalId
							left join Network_Development.dbo.Tbl_Provider_ProviderAdmitters as PAD with (nolock)
								on PAD.PAD_ProviderId = P.NetDevProvId and (PAD.PAD_TermDate is null  or PAD.PAD_TermDate > @now)
							
							left join Network_Development.dbo.Tbl_Provider_ProviderAffiliationIPA as PPAI with (nolock)
								on PPAI.PPAI_ProviderId = PPI.PPI_Id
							left join Network_Development.dbo.Tbl_Codes_Hospitals as HC with (nolock)
								on HC.[Hospital Code] = PPA.PPA_HospitalId
							Inner join Search.Address a with (nolock)
								on a.ProviderId = P.ProviderId
								   and a.LocationId = PPA.PPA_LocationId
						where (P.ProviderType in ('SPEC', 'PCP/SPEC'))
							and (AT.PAT_PROVAType in ('SPEC', 'PCP/SPEC'))
							and (
								 PPA.PPA_TermDate is null
								 or PPA.PPA_TermDate > @now
								)
									and 
								(		 PIPA.PPAI_TermDate is null
										or PIPA.PPAI_TermDate > @now
								)	
								--and (PIPA.PPAI_IPAStatus = 1)
							and (
								 (
								  LV.DBLV_Value <> 'MediCare'
								  or LV.DBLV_Value <> 'Dual Choice CalMediConect'
								 )
								 or (
									 (
									  LV.DBLV_Value = 'MediCare'
									  and PPI.PPI_MedicareOptOut = 0
									 )
									 or (
										 LV.DBLV_Value = 'Dual Choice CalMediConect'
										 and PPI.PPI_MedicareOptOut = 0
										)
									)
								)
				
					union
					
					select distinct p.ProviderId as ProviderId
						   ,null as DirectoryId
						   ,case when LV.CLBS_LOB = 'Medi-Cal' then 'MED'
								 when LV.CLBS_LOB = 'MediCal' then 'MED'
								 when LV.CLBS_LOB = 'Coordinated Care Initiative - MediCal' then 'CCI'
								 when LV.CLBS_LOB = 'Dual Choice CalMediConnect' then 'CMC'
								 when LV.CLBS_LOB = 'MediCare' then 'CMC'
								 when LV.CLBS_LOB = 'Open Access' then 'OA'
								 when LV.CLBS_LOB = 'Healthy Kids' then 'PGM'
								 else LV.CLBS_LOB
							end as LOB
						   ,null as Panel
						   ,'IEHP Direct' as IPaName
						   ,null as IPAgroup
						   ,'JJJ' as IPACode
						   ,null as IPAParentCode
						   ,null as IPADesc
						   ,null as HospitalName
						   ,p.ProviderType as ProviderType
						   ,null as AffiliationType
						   ,AL.PAL_AgeLimit as AgeLimit
						   ,case when PPI.PPI_RosterSuppression = 5 then 0			--RosterSuprresion codes shows a provider is accepting new members or not
								 else 1
							end as AcceptingNewMember
						   ,case when CCS.CCSP_ContractId = CCI.CCI_Id then CCSP_EffectiveDate
								 when LOC.CLOC_ContractId = CCI.CCI_Id then CLOC_EffectiveDate
								 when CLOB_ContractId = CCI.CCI_Id then CLOB_EffDate
							end as EffectiveDate
						   ,case when CCS.CCSP_ContractId = CCI.CCI_Id then CCSP_TermDate
								 when LOC.CLOC_ContractId = CCI.CCI_Id then CLOC_ExpirationDate
								 when CLOB_ContractId = CCI.CCI_Id then CLOB_ExpDate
							end as TermDate
						   ,null as HospitalId
						   ,null as IsHospitalAdmitter
						   ,null as AcceptingNewMemberCode
						   ,a.AddressId as AddressId
						   ,0 as IsInternalOnly, 1 as IsEnabled
						from Search.Provider p
							left join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
								on CPL.CCPL_ProviderID= P.NetDevProvID
							left join Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock)
								on CCI.CCI_ID = CPL.CCPL_ContractID
							Inner join Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
								on p.NetDevProvId = PPI.PPI_Id
							left join Network_Development.dbo.Tbl_Provider_ProviderAffiliationIPA as PIPA with (nolock) on
								 PIPA.PPAI_ProviderID = P.NetDevProvID and PIPA.PPAI_IPAID = 'JJJ'
							left join Network_Development.dbo.Tbl_Provider_AgeLimits as AL with (nolock) on
								 AL.PAL_AgeLimitID = PPAI_AgeLimit
							left join Network_Development.dbo.Tbl_Contract_ContractedSpecial as CCS with (nolock)
								on CCS.CCSP_ContractId = CCI.CCI_Id
					
							left join Network_Development.dbo.Tbl_Contract_ContractedLOC as LOC with (nolock)
								on LOC.CLOC_ContractId = CCI.CCI_Id
							left join Network_Development.dbo.Tbl_Contract_ContractedLOB as CLOB with (nolock)
								on CLOB_ContractId = CCI.CCI_Id
							left join Network_Development.dbo.Tbl_Contract_ContractedLOBSelection as LV with (nolock)
								on (
									LV.CLBS_Id = CCSP_LOB
									or LV.CLBS_Id = CLOB_LOB
									or LV.CLBS_Id = CLOC_LOB
								   )							--List value 83 is to get the LOB
							left join Network_Development.dbo.Tbl_Provider_ProviderAffiliationHosp as PAH with (nolock)
								on PAH.PPAH_ProviderId = p.NetDevProvId				--join to identify all the ProviderId with Admitter Privilege
							left join Network_Development.dbo.Tbl_Provider_ProviderAdmitters as PAD with (nolock)
								on PAD.PAD_ProviderId = p.NetDevProvId and (PAD.PAD_TermDate is null  or PAD.PAD_TermDate > @now)
							Inner join Search.Address a with (nolock)
								on a.ProviderId = p.ProviderId
								   and a.LocationId = CPL.CCPL_LocationId
						where p.ProviderType in ('SPEC')
							and (
								 CLOB_TermDate is null
								 or CLOB_TermDate > @now
								)
										and 
								(		 PIPA.PPAI_TermDate is null
										or PIPA.PPAI_TermDate > @now
								)	
									--and (PIPA.PPAI_IPAStatus = 1)
							and (
								 CLOC_ExpirationDate is null
								 or CLOC_ExpirationDate > @now
								)
							and (
								 CCSP_TermDate is null
								 or CCSP_TermDate > @now
								)
							and (LV.CLBS_LOB is not null)
							and (LV.CLBS_LOB in ('Medi-Cal', 'MediCal', 'Dual Choice CalMediConnect', 'MediCare', 'Healthy Kids', 'Open Access','All Lobs'))
							and (LV.CLBS_Exclude = 0)
						


------------------------------------------------------------------------------------------------------------------------------------------------------------
				insert into #Affiliation		--BH affiliation
							select distinct p.ProviderId as ProviderId
						   ,ppa.PPA_PCPId as DirectoryId
						   ,case when LV.DBLV_Value = 'Medi-Cal' then 'MED'
								 when LV.DBLV_Value = 'Coordinated Care Initiative - MediCal' then 'CCI'
								 when LV.DBLV_Value = 'Dual Choice CalMediConect' then 'CMC'
								 when LV.DBLV_Value = 'MediCare' then 'CMC'
								 else LV.DBLV_Value
							end as LOB
						   ,null as Panel
						   ,Case WHEN PPA.PPA_IPAId = '00L' THEN 'Loma Linda University Health Care' else LV1.DBLV_Value end as IPaName
						   ,null as IPAgroup
						   ,ppa.PPA_IPAId as IPACode
						   ,null as IPAParentCode
						   ,null as IPADesc
						   ,HC.[Hospital Name (Printing)] as HospitalName
						   ,p.ProviderType as ProviderType
						   ,AT.PAT_AffiliationType as AffiliationType
						   ,AL.PAL_AgeLimit as AgeLimit
						   ,case when PPI.PPI_RosterSuppression = 5 then 0			--RosterSuprresion codes shows a provider is accepting new members or not
								 else 1
							end as AcceptingNewMember
						   ,ppa.PPA_EffDate as EffectiveDate
						   ,ppa.PPA_TermDate as TermDate
						   ,ppa.PPA_HospitalId as HospitalId
						   ,case when isnull(PAD.PAD_ProviderId, '') = p.NetDevProvId then 1
								 when isnull(PAH.PPAH_HospitalPrivilege, '') = 7 then 1
								 when (
									   ppa.PPA_HospitalId in ('N/A', '9999', 'C/o', 'OPSC', '0088')
									   or ppa.PPA_HospitalId is null
									  ) then null
								 when (
									   isnull(PAD.PAD_ProviderId, '') = p.NetDevProvId
									   and isnull(PAD.PAD_ProviderId, '') = PAD.PAD_AdmitterId
									  ) then 0
								 when PAH.PPAH_HospitalPrivilege in (1, 2, 3, 8) then 0
								 else null
							end as IsHospitalAdmitter
						   ,null as AcceptingNewMemberCode
						   ,a.AddressId as AddressId
						   ,0 as IsInternalOnly, 1 as IsEnabled
						from Network_Development.dbo.Tbl_Provider_ProviderAffiliation as ppa with (nolock)
							inner join Search.Provider as p with (nolock)
								on p.NetDevProvId = ppa.PPA_ProviderId
							inner join Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
								on PPI.PPI_Id = p.NetDevProvId
							inner join Network_Development.dbo.Tbl_Provider_AffiliationType as AT with (nolock)
								on AT.PAT_Id = ppa.PPA_AffiliationType
							
							inner join Network_Development.dbo.Tbl_Database_ListValues as LV with (nolock)
								on LV.DBLV_Id = AT.PAT_LOB
								   and LV.DBLV_List = 83							--List value 83 is to get the LOB
							inner join Network_Development.dbo.Tbl_Database_ListValues as LV1 with (nolock)
								on LV1.DBLV_Abbreviation = ppa.PPA_IPAId
								   and LV1.DBLV_List = 76
							left join Network_Development.dbo.Tbl_Provider_ProviderAffiliationIPA as PIPA with (nolock) on
								 PIPA.PPAI_ProviderID = PPA.PPA_ProviderID and PIPA.PPAI_IPAID = PPA.PPA_IPAID
							left join Network_Development.dbo.Tbl_Provider_AgeLimits as AL with (nolock) on
								 AL.PAL_AgeLimitID = PPAI_AgeLimit
							left join (
									   select *
										from (
											  select *
												   ,row_number() over (partition by PPAH_ProviderId, PPAH_HospitalId order by PPAH_DateEntered desc) as ranking						--join to identify all the ProviderId with Admitter Privilege (if one hospita has two privilege get one with latest entered date)
												from Network_Development.dbo.Tbl_Provider_ProviderAffiliationHosp as PAH with (nolock)
											 ) as T
										where ranking = 1
									  ) as PAH
								on PAH.PPAH_ProviderId = ppa.PPA_ProviderId
								   and PPAH_HospitalId = ppa.PPA_HospitalId
							left join Network_Development.dbo.Tbl_Provider_ProviderAdmitters as PAD with (nolock)
								on PAD.PAD_ProviderId = p.NetDevProvId and (PAD.PAD_TermDate is null  or PAD.PAD_TermDate > @now)
							left join Network_Development.dbo.Tbl_Codes_Hospitals as HC with (nolock)
								on HC.[Hospital Code] = ppa.PPA_HospitalId
							Inner join Search.Address a with (nolock)
								on a.ProviderId = p.ProviderId
								   and a.LocationId = ppa.PPA_LocationId
						where (p.ProviderType = 'BH')
							and (
								 ppa.PPA_TermDate is null
								 or ppa.PPA_TermDate > @now
								)
									and 
								(		 PIPA.PPAI_TermDate is null
										or PIPA.PPAI_TermDate > @now
								)	
								--and (PIPA.PPAI_IPAStatus = 1)
							and (
								 (
								  LV.DBLV_Value <> 'MediCare'
								  or LV.DBLV_Value <> 'Dual Choice CalMediConect'
								 )
								 or (
									 (
									  LV.DBLV_Value = 'MediCare'
									  and PPI.PPI_MedicareOptOut = 0
									 )
									 or (
										 LV.DBLV_Value = 'Dual Choice CalMediConect'
										 and PPI.PPI_MedicareOptOut = 0
										)
									)
								)
							

								union

					select distinct p.ProviderId as ProviderId
						   ,null as DirectoryId
						   ,case when LV.CLBS_LOB = 'Medi-Cal' then 'MED'
								 when LV.CLBS_LOB = 'MediCal' then 'MED'
								 when LV.CLBS_LOB = 'Coordinated Care Initiative - MediCal' then 'CCI'
								 when LV.CLBS_LOB = 'Dual Choice CalMediConnect' then 'CMC'
								 when LV.CLBS_LOB = 'MediCare' then 'CMC'
								 when LV.CLBS_LOB = 'Open Access' then 'OA'
								 when LV.CLBS_LOB = 'Healthy Kids' then 'PGM'
								 else LV.CLBS_LOB
							end as LOB
						   ,null as Panel
						   ,'IEHP Direct' as IPaName
						   ,null as IPAgroup
						   ,'JJJ' as IPACode
						   ,null as IPAParentCode
						   ,null as IPADesc
						   ,null as HospitalName
						   ,p.ProviderType as ProviderType
						   ,null as AffiliationType
						   ,AL.PAL_AgeLimit as AgeLimit
						   ,case when PPI.PPI_RosterSuppression = 5 then 0			--RosterSuprresion codes shows a provider is accepting new members or not
								 else 1
							end as AcceptingNewMember
						   ,case when CCS.CCSP_ContractId = CCI.CCI_Id then CCSP_EffectiveDate
								 when LOC.CLOC_ContractId = CCI.CCI_Id then CLOC_EffectiveDate
								 when CLOB_ContractId = CCI.CCI_Id then CLOB_EffDate
							end as EffectiveDate
						   ,case when CCS.CCSP_ContractId = CCI.CCI_Id then CCSP_TermDate
								 when LOC.CLOC_ContractId = CCI.CCI_Id then CLOC_ExpirationDate
								 when CLOB_ContractId = CCI.CCI_Id then CLOB_ExpDate
							end as TermDate
						   ,null as HospitalId
						   ,null as IsHospitalAdmitter
						   ,null as AcceptingNewMemberCode
						   ,a.AddressId as AddressId
						   ,0 as IsInternalOnly, 1 as IsEnabled
						from Search.Provider p
							left join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
								on CPL.CCPL_ProviderID= P.NetDevProvID
							left join Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock)
								on CCI.CCI_ID = CPL.CCPL_ContractID
							Inner join Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
								on p.NetDevProvId = PPI.PPI_Id
							left join Network_Development.dbo.Tbl_Provider_ProviderAffiliationIPA as PIPA with (nolock) on
								 PIPA.PPAI_ProviderID = P.NetDevProvID and PIPA.PPAI_IPAID = 'JJJ'
							left join Network_Development.dbo.Tbl_Provider_AgeLimits as AL with (nolock) on
								 AL.PAL_AgeLimitID = PPAI_AgeLimit
							left join Network_Development.dbo.Tbl_Contract_ContractedSpecial as CCS with (nolock)
								on CCS.CCSP_ContractId = CCI.CCI_Id
					
							left join Network_Development.dbo.Tbl_Contract_ContractedLOC as LOC with (nolock)
								on LOC.CLOC_ContractId = CCI.CCI_Id
							left join Network_Development.dbo.Tbl_Contract_ContractedLOB as CLOB with (nolock)
								on CLOB_ContractId = CCI.CCI_Id
							left join Network_Development.dbo.Tbl_Contract_ContractedLOBSelection as LV with (nolock)
								on (
									LV.CLBS_Id = CCSP_LOB
									or LV.CLBS_Id = CLOB_LOB
									or LV.CLBS_Id = CLOC_LOB
								   )							--List value 83 is to get the LOB
							left join Network_Development.dbo.Tbl_Provider_ProviderAffiliationHosp as PAH with (nolock)
								on PAH.PPAH_ProviderId = p.NetDevProvId				--join to identify all the ProviderId with Admitter Privilege
							left join Network_Development.dbo.Tbl_Provider_ProviderAdmitters as PAD with (nolock)
								on PAD.PAD_ProviderId = p.NetDevProvId and (PAD.PAD_TermDate is null  or PAD.PAD_TermDate > @now)
							Inner join Search.Address a with (nolock)
								on a.ProviderId = p.ProviderId
								   and a.LocationId = CPL.CCPL_LocationId
						where p.ProviderType in ('BH')
							and (
								 CLOB_TermDate is null
								 or CLOB_TermDate > @now
								)
										and 
								(		 PIPA.PPAI_TermDate is null
										or PIPA.PPAI_TermDate > @now
								)	
									--and (PIPA.PPAI_IPAStatus = 1)
							and (
								 CLOC_ExpirationDate is null
								 or CLOC_ExpirationDate > @now
								)
							and (
								 CCSP_TermDate is null
								 or CCSP_TermDate > @now
								)
							and (LV.CLBS_LOB is not null)
							and (LV.CLBS_LOB in ('Medi-Cal', 'MediCal', 'Dual Choice CalMediConnect', 'MediCare', 'Healthy Kids', 'Open Access', 'All Lobs'))
							and (LV.CLBS_Exclude = 0)
						

			end
-------------------------------------------------------------------------------------------------------------------------
			begin			--VSNx
	
				insert into #Affiliation				--VSN
					select distinct P.ProviderId as ProviderId
						   ,PPA.PPA_PCPId as DirectoryId
						   ,case when LV.DBLV_Value = 'Medi-Cal' then 'MED'
								 when LV.DBLV_Value = 'Coordinated Care Initiative - MediCal' then 'CCI'
								 when LV.DBLV_Value = 'Dual Choice CalMediConect' then 'CMC'
								 when LV.DBLV_Value = 'MediCare' then 'CMC'
								 else LV.DBLV_Value
							end as LOB
						   ,null as Panel
						   ,Case WHEN PPA.PPA_IPAId = '00L' THEN 'Loma Linda University Health Care' else LV1.DBLV_Value end as IPaName
						   ,null as IPAgroup
						   ,PPA.PPA_IPAId as IPACode
						   ,null as IPAParentCode
						   ,null as IPADesc
						   ,HC.[Hospital Name (Printing)] as HospitalName
						   ,AT.PAT_PROVAType as ProviderType
						   ,AT.PAT_AffiliationType as AffiliationType
						   ,AL.PAL_AgeLimit as AgeLimit
						   ,case when PPI.PPI_RosterSuppression = 5 then 0			--RosterSuprresion codes shows a provider is accepting new members or not
								 else 1
							end as AcceptingNewMember
						   ,PPA.PPA_EffDate as EffectiveDate
						   ,PPA.PPA_TermDate as TermDate
						   ,PPA.PPA_HospitalId as HospitalId
						   ,case when PAD.PAD_ProviderId = P.NetDevProvId then 1
								 when PAH.PPAH_HospitalPrivilege = 7 then 1
								 when (
									   PPA.PPA_HospitalId in ('N/A', '9999', 'C/o', 'OPSC', '0088')
									   or PPA.PPA_HospitalId is null
									  ) then null
								 when (
									   PAD.PAD_ProviderId = P.NetDevProvId
									   and PAD.PAD_ProviderId = PAD.PAD_AdmitterId
									  ) then 0
								 when PAH.PPAH_HospitalPrivilege in (1, 2, 3, 8) then 0
								 else null
							end as IsHospitalAdmitter
						   ,null as AcceptingNewMemberCode
						   ,A.AddressId as AddressId
						   ,0 as IsInternalOnly, 1 as IsEnabled
						from Network_Development.dbo.Tbl_Provider_ProviderAffiliation as PPA with (nolock)
							inner join Network_Development.dbo.Tbl_Provider_AffiliationType as AT with (nolock)
								on AT.PAT_Id = PPA.PPA_AffiliationType
							inner join Search.Provider as P with (nolock)
								on P.NetDevProvId = PPA.PPA_ProviderId
							inner join Search.Address as A with (nolock)
								on A.LocationId = PPA.PPA_LocationId
								   and P.ProviderId = A.ProviderId
							inner join Network_Development.dbo.Tbl_Database_ListValues as LV with (nolock)
								on LV.DBLV_Id = AT.PAT_LOB
								   and LV.DBLV_List = 83							--List value 83 is to get the LOB
							inner join Network_Development.dbo.Tbl_Database_ListValues as LV1 with (nolock)
								on LV1.DBLV_Abbreviation = PPA.PPA_IPAId
								   and LV1.DBLV_List = 76			--List Value 76 is to get the IPA names for IPA codes
							inner join Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
								on PPI.PPI_Id = PPA.PPA_ProviderId
							left join Network_Development.dbo.Tbl_Provider_ProviderAffiliationIPA as PIPA with (nolock) on
								 PIPA.PPAI_ProviderID = PPA.PPA_ProviderID and PIPA.PPAI_IPAID = PPA.PPA_IPAID
							left join Network_Development.dbo.Tbl_Provider_AgeLimits as AL with (nolock) on
								 AL.PAL_AgeLimitID = PPAI_AgeLimit
							left join (
									   select *
										from (
											  select *
												   ,row_number() over (partition by PPAH_ProviderId, PPAH_HospitalId order by PPAH_DateEntered desc) as ranking						--join to identify all the ProviderId with Admitter Privilege (if one hospita has two privilege get one with latest entered date)
												from Network_Development.dbo.Tbl_Provider_ProviderAffiliationHosp as PAH with (nolock)
											 ) as T
										where ranking = 1
									  ) as PAH
								on PAH.PPAH_ProviderId = PPA.PPA_ProviderId
								   and PPAH_HospitalId = PPA.PPA_HospitalId
							left join Network_Development.dbo.Tbl_Provider_ProviderAdmitters as PAD with (nolock)
								on PAD.PAD_ProviderId = PPA.PPA_ProviderId and (PAD.PAD_TermDate is null  or PAD.PAD_TermDate > @now)
							
							left join Network_Development.dbo.Tbl_Provider_ProviderAffiliationIPA as PPAI with (nolock)
								on PPAI.PPAI_ProviderId = P.NetDevProvId
							left join Network_Development.dbo.Tbl_Codes_Hospitals as HC with (nolock)
								on HC.[Hospital Code] = PPA.PPA_HospitalId
						where (P.ProviderType = 'VSN')
							and (AT.PAT_AffiliationType = 'VISION')
							and (
								 PPA.PPA_TermDate is null
								 or PPA.PPA_TermDate > @now
								)
									and 
								(		 PIPA.PPAI_TermDate is null
										or PIPA.PPAI_TermDate > @now
								)	
								--and (PIPA.PPAI_IPAStatus = 1)
							--and (PPA.PPA_EffDate <= @now)
							and (
								 (
								  LV.DBLV_Value <> 'MediCare'
								  or LV.DBLV_Value <> 'Dual Choice CalMediConect'
								 )
								 or (
									 (
									  LV.DBLV_Value = 'MediCare'
									  and PPI.PPI_MedicareOptOut = 0
									 )
									 or (
										 LV.DBLV_Value = 'Dual Choice CalMediConect'
										 and PPI.PPI_MedicareOptOut = 0
										)
									)
								)
					

								union
					select distinct p.ProviderId as ProviderId
						   ,null as DirectoryId
						   ,case when LV.CLBS_LOB = 'Medi-Cal' then 'MED'
								 when LV.CLBS_LOB = 'MediCal' then 'MED'
								 when LV.CLBS_LOB = 'Coordinated Care Initiative - MediCal' then 'CCI'
								 when LV.CLBS_LOB = 'Dual Choice CalMediConnect' then 'CMC'
								 when LV.CLBS_LOB = 'MediCare' then 'CMC'
								 when LV.CLBS_LOB = 'Open Access' then 'OA'
								 when LV.CLBS_LOB = 'Healthy Kids' then 'PGM'
								 else LV.CLBS_LOB
							end as LOB
						   ,null as Panel
						   ,'IEHP Direct' as IPaName
						   ,null as IPAgroup
						   ,'JJJ' as IPACode
						   ,null as IPAParentCode
						   ,null as IPADesc
						   ,null as HospitalName
						   ,p.ProviderType as ProviderType
						   ,null as AffiliationType
						   ,AL.PAL_AgeLimit as AgeLimit
						   ,case when PPI.PPI_RosterSuppression = 5 then 0			--RosterSuprresion codes shows a provider is accepting new members or not
								 else 1
							end as AcceptingNewMember
						   ,case when CCS.CCSP_ContractId = CCI.CCI_Id then CCSP_EffectiveDate
								 when LOC.CLOC_ContractId = CCI.CCI_Id then CLOC_EffectiveDate
								 when CLOB_ContractId = CCI.CCI_Id then CLOB_EffDate
							end as EffectiveDate
						   ,case when CCS.CCSP_ContractId = CCI.CCI_Id then CCSP_TermDate
								 when LOC.CLOC_ContractId = CCI.CCI_Id then CLOC_ExpirationDate
								 when CLOB_ContractId = CCI.CCI_Id then CLOB_ExpDate
							end as TermDate
						   ,null as HospitalId
						   ,null as IsHospitalAdmitter
						   ,null as AcceptingNewMemberCode
						   ,a.AddressId as AddressId
						   ,0 as IsInternalOnly, 1 as IsEnabled
						from Search.Provider p with (nolock)
							left join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
								on CPL.CCPL_ProviderID = P.NetDevProvID
							left join Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock)
								on CCI.CCI_ContractDiamondId = p.DiamProvId
							left join Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
								on p.NetDevProvId = PPI.PPI_Id
							
							left join Network_Development.dbo.Tbl_Provider_ProviderAffiliationIPA as PIPA with (nolock) on
								 PIPA.PPAI_ProviderID = CPL.CCPL_ProviderID and PIPA.PPAI_IPAID = 'JJJ'
							left join Network_Development.dbo.Tbl_Provider_AgeLimits as AL with (nolock) on
								 AL.PAL_AgeLimitID = PPAI_AgeLimit
							left join Network_Development.dbo.Tbl_Contract_ContractedSpecial as CCS with (nolock)
								on CCS.CCSP_ContractId = CCI.CCI_Id
							left join Network_Development.dbo.Tbl_Contract_ContractedLOC as LOC with (nolock)
								on LOC.CLOC_ContractId = CCI.CCI_Id
							left join Network_Development.dbo.Tbl_Contract_ContractedLOB as CLOB with (nolock)
								on CLOB_ContractId = CCI.CCI_Id
							left join Network_Development.dbo.Tbl_Contract_ContractedLOBSelection as LV with (nolock)
								on (
									LV.CLBS_Id = CCSP_LOB
									or LV.CLBS_Id = CLOB_LOB
									or LV.CLBS_Id = CLOC_LOB
								   )							--List value 83 is to get the LOB
							left join Network_Development.dbo.Tbl_Provider_ProviderAffiliationHosp as PAH with (nolock)
								on PAH.PPAH_ProviderId = p.NetDevProvId 				--join to identify all the ProviderId with Admitter Privilege
							left join Network_Development.dbo.Tbl_Provider_ProviderAdmitters as PAD with (nolock)
								on PAD.PAD_ProviderId = p.NetDevProvId and (PAD.PAD_TermDate is null  or PAD.PAD_TermDate > @now)
							Inner join Search.Address a with (nolock)
								on a.ProviderId = p.ProviderId
								   and a.LocationId = CPL.CCPL_LocationId
						where p.ProviderType in ('VSN')
							and (
								 CLOB_TermDate is null
								 or CLOB_TermDate > @now
								)
									and 
								(		 PIPA.PPAI_TermDate is null
										or PIPA.PPAI_TermDate > @now
								)	
								--and (PIPA.PPAI_IPAStatus = 1)
							and (
								 CLOC_ExpirationDate is null
								 or CLOC_ExpirationDate > @now
								)
							and (
								 CCSP_TermDate is null
								 or CCSP_TermDate > @now
								)
							and (LV.CLBS_LOB is not null)
							and (LV.CLBS_LOB in ('Medi-Cal', 'MediCal', 'Dual Choice CalMediConnect', 'MediCare', 'Healthy Kids', 'Open Access','All Lobs'))
							and (LV.CLBS_Exclude = 0)
						
			end
---------------------------------------------------------------------------------------------------------------------------------
--UC
			begin
				insert into #Affiliation
					select distinct p.ProviderId as ProviderId
						   ,null as DirectoryId
						   ,case when LV.DBLV_Value = 'Medi-Cal' then 'MED'
								 when LV.DBLV_Value = 'Coordinated Care Initiative - MediCal' then 'CCI'
								 when LV.DBLV_Value = 'Dual Choice CalMediConect' then 'CMC'
								 when LV.DBLV_Value = 'MediCare' then 'CMC'
								 else LV.DBLV_Value
							end as LOB
						   ,null as Panel
						   ,Case WHEN PDNA.PDNA_IPA = '00L' THEN 'Loma Linda University Health Care' else LV1.DBLV_Value end as IPaName
						   ,null as IPAgroup
						   ,PDNA.PDNA_IPA as IPACode
						   ,null as IPAParentCode
						   ,null as IPADesc
						   ,null as HospitalName
						   ,p.ProviderType as ProviderType
						   ,null as AffiliationType
						   ,null as AgeLimit
						   ,1 as AcceptingNewMember
						   ,PDNA.PDNA_EffDate as EffectiveDate
						   ,PDNA.PDNA_TermDate as TermDate
						   ,null as HospitalId
						   ,null as IsHospitalAdmitter
						   ,null as AcceptingNewMemberCode
						   ,a.AddressId as AddressId
						   ,0 as IsInternalOnly, 1 as IsEnabled
						from Search.Provider p with (nolock)
							inner join Network_Development.dbo.Tbl_Provider_DelegatedNetwork_Affiliation as PDNA with (nolock)
								on p.NetDevProvId = PDNA_ProviderId
							left join Network_Development.dbo.Tbl_Database_ListValues as LV with (nolock)
								on LV.DBLV_Id = PDNA.PDNA_LOB
								   and LV.DBLV_List = 83							--List value 83 is to get the LOB
							left join Network_Development.dbo.Tbl_Database_ListValues as LV1 with (nolock)
								on LV1.DBLV_Abbreviation = PDNA.PDNA_IPA
								   and LV1.DBLV_List = 76
							Inner join Search.Address as a with (nolock)
								on a.ProviderId = p.ProviderId
								   and a.LocationId = PDNA.PDNA_LocationId		--List Value 76 is to get the IPA names for IPA codes
						where (p.ProviderType = 'UC')
							and PDNA.PDNA_LOB in (1, 2)
							and (
								 PDNA_TermDate > @now
								 or PDNA_TermDate is null
								)
					union
					
		select distinct p.ProviderId as ProviderId
						   ,null as DirectoryId
						   ,case when LV.CLBS_LOB = 'Medi-Cal' then 'MED'
								 when LV.CLBS_LOB = 'MediCal' then 'MED'
								 when LV.CLBS_LOB = 'Coordinated Care Initiative - MediCal' then 'CCI'
								 when LV.CLBS_LOB = 'Dual Choice CalMediConnect' then 'CMC'
								 when LV.CLBS_LOB = 'MediCare' then 'CMC'
								 when LV.CLBS_LOB = 'Open Access' then 'OA'
								 when LV.CLBS_LOB = 'Healthy Kids' then 'PGM'
								 else LV.CLBS_LOB
							end as LOB
						   ,null as Panel
						   ,'IEHP Direct' as IPaName
						   ,null as IPAgroup
						   ,'JJJ' as IPACode
						   ,null as IPAParentCode
						   ,null as IPADesc
						   ,null as HospitalName
						   ,p.ProviderType as ProviderType
						   ,null as AffiliationType
						   ,null as AgeLimit
						   ,1 as AcceptingNewMember
						   ,CCI.CCI_OrgEffDate as EffectiveDate
						   ,CCI.CCI_ExpDate as TermDate
						   ,null as HospitalId
						   ,null as IsHospitalAdmitter
						   ,null as AcceptingNewMemberCode
						   ,a.AddressId as AddressId
						   ,0 as IsInternalOnly, 1 as IsEnabled
						from Search.Provider p with (nolock)
							inner join Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock)
								on p.DiamProvId = CCI.CCI_ContractDiamondId
							Inner join Search.Address a with (nolock)
								on a.ProviderId = p.ProviderId and a.contractID = cci.cci_id  
							left join Network_Development.dbo.Tbl_Contract_ContractedLOB as CLOB with (nolock)
								on CLOB_ContractId = CCI.CCI_Id and (CLOB_TermDate is null or CLOB_TermDate > @now)
							left join Network_Development.dbo.Tbl_Contract_ContractedSpecial as CCS with (nolock)
								on CCS.CCSP_ContractId = CCI.CCI_Id	and ( CCSP_TermDate is null or CCSP_TermDate > @now	)
							left join Network_Development.dbo.Tbl_Contract_ContractedLOC as LOC with (nolock)
								on LOC.CLOC_ContractId = CCI.CCI_Id	and (LOC.CLOC_ExpirationDate > @now or LOC.CLOC_ExpirationDate is null)
							left join Network_Development.dbo.Tbl_Contract_ContractedLOBSelection as LV with (nolock)
								on CLOB.CLOB_LOB = LV.CLBS_ID or CCS.CCSP_LOB = LV.CLBS_ID or LOC.CLOC_LOB = LV.CLBS_ID
						
						where p.ProviderType in ('UC')
							and (
								 CCI.CCI_ExpDate is null
								 or CCI.CCI_ExpDate > @now
								)
							and (LV.CLBS_LOB is not null) and LV.CLBS_Exclude = 0
							and (LV.CLBS_LOB in ('Medi-Cal', 'MediCal', 'Dual Choice CalMediConnect', 'MediCare', 'Healthy Kids', 'Open Access', 'All LOBs'))
							
							
							
							
							

			end

/*************************************************************************************************************************************************************************/
	--Remove Dups
			IF object_id('tempdb..#distinctAffiliations') is not null
				DROP TABLE #distinctAffiliations

	--Create temp table #distinctAffiliations
	SELECT * INTO #distinctAffiliations FROM #Affiliation WHERE 1 = 0

/*************************************************************************************************************************************************************************/
	INSERT INTO #distinctAffiliations
	Select Distinct 
			[ProviderID]
			,[DirectoryID]
			,[LOB]
			,[Panel]
			,[IPAName]
			,[IPAGroup]
			,[IPACode]
			,[IPAParentCode]
			,[IPADesc]
			,[HospitalName]
			,[ProviderType]
			,[AffiliationType]
			,[AgeLimit]
			,[AcceptingNewMbr]
			,[EffectiveDate]
			,[TerminationDate]
			,[HospitalID]
			,[IsHospitalAdmitter]
			,[AcceptingNewMemberCode]
			,[AddressID]
			,IsInternalOnly
			,IsEnabled
				 from (  select *
				   ,row_number() over (partition by ProviderId,LOB,PANEL,EffectiveDate,providerType,AffiliationTYpe,IPACOde,HospitalId,AddressID order by ProviderID ) as ranking						
				from #Affiliation as a with (nolock)
				) T where T.ranking = 1

/*************************************************************************************************************************************************************************/

	--Take IPA name from Diamond
	Update da
	set da.IPANAMe = Case when da.IPAcode = 'JJJ' Then 'IEHP Direct' else rtrim(I.PJNAME1) end
	from #distinctAffiliations da
	join Diam_725_App.diamond.JIPAVAM0_DAT as I with (nolock) on I.PJIPA = da.IPACode
	

--Remove dups hospital name for same Id because coming from two source with two name 	
	update a
		set	a.HospitalName = Case when a.HospitalName = 'John F Kennedy Memorial Hosp' then 'John F Kennedy Memorial Hospital'
								  when a.HospitalName = 'Victor Valley Hospital Acquisition Inc Dba' then 'Victor Valley Global Medical Center'
								else a.HospitalName end
		from #distinctAffiliations a 

--set Flag true if effective date is future date
	Update #distinctAffiliations
			set IsInternalOnly = Case When EffectiveDate > getdate()  THEN 1
									  when TerminationDate < getdate() THEN 1
									  When (EffectiveDate > getdate() and TerminationDate is null) THEN 1
									  when (EffectiveDate < getdate() and TerminationDate < getdate()) THEN 1

								 else IsInternalOnly end


								 
/***********************************************Enable/ Disable*******************************************************************************/

--DISABLE
			UPDATE D
			SET d.IsEnabled = 0
			FROM #distinctAffiliations DL 
						right join Search.Affiliation D
							on (coalesce(DL.ProviderId, '')			= coalesce(D.ProviderId, ''))
							   and (coalesce(DL.LOB, '')			= coalesce(D.LOB, ''))
							   and (coalesce(DL.Panel, '')			= coalesce(D.Panel, ''))
							   and (coalesce(DL.EffectiveDate, '')	= coalesce(D.EffectiveDate, ''))
							   and (coalesce(DL.ProviderType, '')	= coalesce(D.ProviderType, ''))
							   and (coalesce(DL.AffiliationType, '') = coalesce(D.AffiliationType, ''))
							   and (coalesce(DL.IPACode, '')		= coalesce(D.IPACode, ''))
							   and (coalesce(DL.HospitalId, '')		= coalesce(D.HospitalId, ''))
							   and (coalesce(DL.AddressId, '')		= coalesce(D.AddressId, ''))

			WHERE DL.AffiliationId is null and ISNULL(D.IsEnabled,1) <> 0


--ENABLE
	UPDATE D
			SET d.IsEnabled = 1
			FROM #distinctAffiliations DL 
						Inner join Search.Affiliation D
							on (coalesce(DL.ProviderId, '')			= coalesce(D.ProviderId, ''))
							   and (coalesce(DL.LOB, '')			= coalesce(D.LOB, ''))
							   and (coalesce(DL.Panel, '')			= coalesce(D.Panel, ''))
							   and (coalesce(DL.EffectiveDate, '')	= coalesce(D.EffectiveDate, ''))
							   and (coalesce(DL.ProviderType, '')	= coalesce(D.ProviderType, ''))
							   and (coalesce(DL.AffiliationType, '') = coalesce(D.AffiliationType, ''))
							   and (coalesce(DL.IPACode, '')		= coalesce(D.IPACode, ''))
							   and (coalesce(DL.HospitalId, '')		= coalesce(D.HospitalId, ''))
							   and (coalesce(DL.AddressId, '')		= coalesce(D.AddressId, ''))
			WHERE  ISNULL(D.IsEnabled,0) <> 1


--Update
	UPDATE AF
		SET AF.DirectoryID				= (CASE WHEN ISNULL(AF.DirectoryID,'')				<> ISNULL(DL.DirectoryId,'')				THEN DL.DirectoryId							ELSE AF.DirectoryID				END),
			AF.IPAName					= (CASE WHEN ISNULL(AF.IPAName,'')					<> ISNULL(DL.IPAName,'')					THEN Search.udf_TitleCase(DL.IPAName)		ELSE AF.IPAName					END),
			AF.IPAGroup					= (CASE WHEN ISNULL(AF.IPAGroup,'')					<> ISNULL(DL.IPAGroup,'')					THEN Search.udf_TitleCase(DL.IPAGroup)		ELSE AF.IPAGroup				END),
			AF.IPAParentCode			= (CASE WHEN ISNULL(AF.IPAParentCode,'')			<> ISNULL(DL.IPAParentCode,'')				THEN DL.IPAParentCode						ELSE AF.IPAParentCode			END),
			AF.IPADesc					= (CASE WHEN ISNULL(AF.IPADesc,'')					<> ISNULL(DL.IPADesc,'')					THEN Search.udf_TitleCase(DL.IPADesc)		ELSE AF.IPADesc					END),
			AF.HospitalName				= (CASE WHEN ISNULL(AF.HospitalName,'')				<> ISNULL(DL.HospitalName,'')				THEN Search.udf_TitleCase(DL.HospitalName)	ELSE AF.HospitalName			END),
			AF.AgeLimit					= (CASE WHEN ISNULL(AF.AgeLimit,'')					<> ISNULL(DL.AgeLimit,'')					THEN DL.AgeLimit							ELSE AF.AgeLimit				END),
			AF.AcceptingNewMbr			= (CASE WHEN ISNULL(AF.AcceptingNewmbr,'')			<> ISNULL(DL.AcceptingNewmbr,'')			THEN DL.AcceptingNewmbr						ELSE AF.AcceptingNewmbr			END),
			AF.IsHospitalAdmitter		= (CASE WHEN ISNULL(AF.IsHospitalAdmitter,'')		<> ISNULL(DL.IsHospitalAdmitter,'')			THEN DL.IsHospitalAdmitter					ELSE AF.IsHospitalAdmitter		END),
			AF.TerminationDate			= (CASE WHEN ISNULL(AF.TerminationDate,'')			<> ISNULL(DL.TerminationDate,'')			THEN DL.TerminationDate						ELSE AF.TerminationDate			END),
			AF.AcceptingNewMemberCode	= (CASE WHEN ISNULL(AF.AcceptingNewMemberCode,'')	<> ISNULL(DL.AcceptingNewMemberCode,'')		THEN DL.AcceptingNewMemberCode				ELSE AF.AcceptingNewMemberCode	END),
			AF.IsInternalOnly			= (CASE WHEN ISNULL(AF.IsInternalOnly,1)			<> DL.IsInternalOnly			THEN DL.IsInternalOnly						ELSE AF.IsInternalOnly			END)

		FROM #distinctAffiliations DL 
						Inner join search.Affiliation AF
							on (coalesce(DL.ProviderId, '')			= coalesce(AF.ProviderId, ''))
							   and (coalesce(DL.LOB, '')			= coalesce(AF.LOB, ''))
							   and (coalesce(DL.Panel, '')			= coalesce(AF.Panel, ''))
							   and (coalesce(DL.EffectiveDate, '')	= coalesce(AF.EffectiveDate, ''))
							   and (coalesce(DL.ProviderType, '')	= coalesce(AF.ProviderType, ''))
							   and (coalesce(DL.AffiliationType, '') = coalesce(AF.AffiliationType, ''))
							   and (coalesce(DL.IPACode, '')		= coalesce(AF.IPACode, ''))
							   and (coalesce(DL.HospitalId, '')		= coalesce(AF.HospitalId, ''))
							   and (coalesce(DL.AddressId, '')		= coalesce(AF.AddressId, ''))

--INSERT

	--Insert new Records which were never in the Target table
		INSERT INTO search.Affiliation
		
		SELECT    DL.ProviderID ,
		          DL.DirectoryID ,
		          DL.LOB ,
		          DL.Panel ,
		          Search.udf_TitleCase(Dl.IPAName) ,
		          Search.udf_TitleCase(Dl.IPAGroup) ,
		          DL.IPACode ,
		          DL.IPAParentCode ,
		          Search.udf_TitleCase(Dl.IPADesc) ,
		          Search.udf_TitleCase(Dl.HospitalName) ,
		          DL.ProviderType ,
		          DL.AffiliationType ,
		          DL.AgeLimit ,
		          DL.AcceptingNewMbr ,
		          DL.EffectiveDate ,
		          DL.TerminationDate ,
		          DL.HospitalID ,
		          DL.IsHospitalAdmitter ,
		          DL.AcceptingNewMemberCode ,
		          DL.AddressID ,
		          DL.IsInternalOnly ,
		          DL.IsEnabled
		FROM #distinctAffiliations AS DL WITH (nolock)
		LEFT JOIN search.Affiliation  AF
						ON     (coalesce(DL.ProviderId, '')			= coalesce(AF.ProviderId, ''))
							   and (coalesce(DL.LOB, '')			= coalesce(AF.LOB, ''))
							   and (coalesce(DL.Panel, '')			= coalesce(AF.Panel, ''))
							   and (coalesce(DL.EffectiveDate, '')	= coalesce(AF.EffectiveDate, ''))
							   and (coalesce(DL.ProviderType, '')	= coalesce(AF.ProviderType, ''))
							   and (coalesce(DL.AffiliationType, '') = coalesce(AF.AffiliationType, ''))
							   and (coalesce(DL.IPACode, '')		= coalesce(AF.IPACode, ''))
							   and (coalesce(DL.HospitalId, '')		= coalesce(AF.HospitalId, ''))
							   and (coalesce(DL.AddressId, '')		= coalesce(AF.AddressId, '')) 
		WHERE af.AffiliationID IS null
/***********************************************************************************************************************************************************************/

		--Update isInternalOnly flag if affiliation is added into Exclusion table
		Update A
		set A.IsinternalOnly = Case when A.AffiliationId = EAF.AffiliationID then 1
								else A.IsInternalOnly end
								from search.Affiliation A 
								join search.ExcludedAffiliations EAF with (nolock) on A.AffiliationId = EAF.AffiliationID


		--Change IPA name for IPA, IEHP to Upper case  from lower case
		create table #changetoUpperCase
		(
		 IpaName varchar(100) null
		)

	insert into #changetoUpperCase
		values ('ipa')
	insert into #changetoUpperCase
		values ('Iehp')

	update a
		set	a.IPAName = case when a.IPAName like '' + t.IpaName + '%'
								  or a.IPAName like '%' + t.IpaName + ''
								  or a.IPAName like '% ' + t.IpaName + ' %' then (replace((a.IPAName), (t.IpaName), upper((t.IpaName))))
							 else a.IPAName
						end
		from Search.Affiliation a 
			left join #changetoUpperCase t
				on a.IPAName like '%' + t.IpaName + '%'


/********************************************************  DROP TEMP TABLES ***************************************************************************************************************/
	

		if object_id('tempdb..#Affiliation') is not null
				drop table #Affiliation 
				
		if object_id('tempdb..#changetoUpperCase') is not null
				drop table #changetoUpperCase 
				
		if object_id('tempdb..#distinctAffiliations') is not null
				drop table #distinctAffiliations 

/***********************************************************************************************************************************************************************/

END

END


GO
/****** Object:  StoredProcedure [Import].[MergeAllProviderExtendeProperties]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

------------
CREATE Procedure [Import].[MergeAllProviderExtendeProperties]
@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
				10/03/2016		SS		Added delete statements to delete child table data.
		*/
		declare @now date = getdate()
		declare @Version varchar(100) = '10/03/2016 2:22 Version 1.00'
		declare @ReturnValues table
			(
			 ReturnCode int primary key
							not null
			,Reason varchar(200) not null
			)

		insert into @ReturnValues
				(ReturnCode, Reason)
			values (0, 'Normal Return')			
											
		if @Showversion = 1
			begin
				select object_schema_name(@@PROCId) as SchemaName
					   ,object_name(@@PROCId) as ProcedureName
					   ,@Version as VersionInformation
				if isnull(@ShowReturn, 0) = 0
					return 0
			end

		if @ShowReturn = 1
			begin
				select *
					from @ReturnValues
				return 0
			end

		set nocount on

		begin


			if object_id('tempdb..#ProviderExtendedProperties') is not null
				drop table #ProviderExtendedProperties

			create table #ProviderExtendedProperties
				(
				 ProviderId int not null
				,PropertyName varchar(30) not null
				,PropertyValue varchar(255) null
				)

			insert into #ProviderExtendedProperties				--VSN
				select distinct P.ProviderId as ProviderId
					   ,'EyeExamOnly' as PropertyName
					   ,case when CTL.CTL_Description = 'Participating Provider Agreement - Vision (Exam Only)' then cast('Yes' as varchar(50))
							 else cast('No' as varchar(50))
						end as PropertyValue
					from Search.Provider as P with (nolock)
						inner join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
							on P.NetDevProvId = CPL.CCPL_ProviderId
						inner join Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock)
							on CPL.CCPL_ContractId = CCI.CCI_Id
						inner join Network_Development.dbo.Tbl_Contract_ContractTitle as CTL with (nolock)
							on CCI.CCI_ContractTitle = CTL.CTL_Id
					where P.ProviderType = 'VSN'
						and (
							 CCI_TermDate is null
							 or CCI_TermDate > @now
							)
						and CPL.CCPL_TermDate is null
						or CPL.CCPL_TermDate > @now
 --order by ProviderId
				union all
				select distinct P.ProviderId as ProviderId
					   ,'FrameLensOnly' as PropertyName
					   ,case when CTL.CTL_Description = 'Participating Provider Agreement - Vision (Frames and Lens Only)' then cast('Yes' as varchar(50))
							 else cast('No' as varchar(50))
						end as PropertyValue
					from Search.Provider as P with (nolock)
						inner join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
							on P.NetDevProvId = CPL.CCPL_ProviderId
						inner join Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock)
							on CPL.CCPL_ContractId = CCI.CCI_Id
						inner join Network_Development.dbo.Tbl_Contract_ContractTitle as CTL with (nolock)
							on CCI.CCI_ContractTitle = CTL.CTL_Id
					where P.ProviderType = 'VSN'
						and (
							 CCI_TermDate is null
							 or CCI_TermDate > @now
							)
						and CPL.CCPL_TermDate is null
						or CPL.CCPL_TermDate > @now
----------------------------
--Update Eye Exam 
--Update PEP 
--SET PEP.PropertyValue =  CASE WHEN CTL.[CTL_Description] = 'Participating Provider Agreement - Vision (Exam Only)' THEN 'Yes' Else 'NO' end 
--FROM 
--Network_Development.dbo.Tbl_ProviderDirectory_Providers as PDP with (nolock) 
--		INNER JOIN Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock) ON PDP.PDPR_LocationId = CPL.CCPL_LocationId AND PDP.PDPR_ProviderId = CPL.CCPL_ProviderId 
--		INNER JOIN Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock) ON CPL.CCPL_ProviderId = PPI.PPI_Id
--		INNER JOIN [search].Provider as P with (nolock) on P.License = PPI.PPI_License
--		INNER JOIN #ProviderExtendedProperties	 as PEP with (nolock) on PEP.ProviderId = P.ProviderId
--		INNER JOIN Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock) ON CPL.CCPL_ContractId = CCI.CCI_Id 
--		INNER JOIN Network_Development.dbo.Tbl_Contract_ContractTitle as CTL with (nolock) ON CCI.CCI_ContractTitle = CTL.CTL_Id 
-- where P.ProviderType = 'VSN' and P.ProviderId = PEP.ProviderId and PEP.Propertyname = 'EyeExamOnly' 
 --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			insert into #ProviderExtendedProperties
				select 
			distinct p.ProviderId as ProviderId
					   ,'HospitalAccreditation' as PropertyName
					   ,CA_Long as PropertyValue
					from Search.Provider as p with (nolock)
						join Network_Development.dbo.Tbl_Provider_ProviderInfo as ppi with (nolock)
							on ppi.PPI_Id = p.NetDevProvId
						join Network_Development.dbo.Tbl_Contract_Accreditation as CA with (nolock)
							on CA.CA_Id = ppi.PPI_AccredBody
					where p.ProviderType = 'HOSP'
						--and (
						--	 ppi.PPI_AccredExpDate is null
						--	 or ppi.PPI_AccredExpDate > @now
						--	)

			insert into #ProviderExtendedProperties
				select distinct P.ProviderId as ProviderId
					   ,'PharmacyType' as PropertName
					   ,cast(PC.PT_Desc as varchar) as PropertyValue
					from Search.Provider as P with (nolock)
						inner join Pharmacy.Pharmacy.dbo.IEHP_Pharmacy_Providers as PH with (nolock)
							on PH.Id = P.NetDevProvId
						left join Pharmacy.Pharmacy.dbo.PharmType_Codes as PC (nolock)
							on PC.PT_Code = PH.Pharmacy_Type
				union all
				select distinct P.ProviderId as ProviderId
					   ,'PharmacyStarRating' as PropertyName
					   ,cast(PH.StarRating as varchar) as PropertyValue
					from Search.Provider as P with (nolock)
						inner join Pharmacy.Pharmacy.dbo.IEHP_Pharmacy_Providers as PH with (nolock)
							on PH.Id = P.NetDevProvId
				union all
				select distinct P.ProviderId as ProviderId
					   ,'PharmacyDeliver' as PropertName
					   ,cast(PH.DELIVER as varchar) as PropertyValue
					from Search.Provider as P with (nolock)
						inner join Pharmacy.Pharmacy.dbo.IEHP_Pharmacy_Providers as PH with (nolock)
							on PH.Id = P.NetDevProvId
					order by P.ProviderId;


	/***********************************HOSPITAL ACCRED LINK PART********************************************************************************************/

			insert into #ProviderExtendedProperties
			select 
			distinct p.ProviderId as ProviderId
					   ,'HospitalAccreditationLink' as PropertyName
					   ,PPI_AccredLink as PropertyValue
					from Search.Provider as p with (nolock)
						join Network_Development.dbo.Tbl_Provider_ProviderInfo as ppi with (nolock)
							on ppi.PPI_Id = p.NetDevProvId
						where p.ProviderType = 'HOSP' and PPI_AccredLink is not null and PPI_AccredLink <> 'Not Available'



/****************************************SCORE LINK***************************************************************************************/

		; with cte as (
			select 
			distinct p.ProviderId as ProviderId
					   ,'HospitalScoreLink' as PropertyName
					   ,cl_scorelink as PropertyValue
					   ,row_number() over (partition by p.ProviderID,cl_scorelink order by p.providerid ) as ranki
					   ,row_number() over (partition by p.ProviderID order by p.providerId ) as ranking
											 
					from Search.Provider as p with (nolock)
						join search.Address as a with (nolock) on a.ProviderID = p.ProviderID
						join  Network_Development.dbo.Tbl_Contract_Locations as CL with (nolock)
							on CL.cl_id = a.LocationID
						where p.ProviderType = 'HOSP' 
						) insert into #ProviderExtendedProperties
						select distinct ProviderId,PropertyName,PropertyValue
						 from cte where ranki = 1 and PropertyValue is not null
/***************************************************************************************************************************************************************/

		;	with	cte
					  as (
						  select distinct ProviderId
							   ,PropertyName
							   ,PropertyValue
							from #ProviderExtendedProperties
						 )
				select distinct a1.ProviderId
					   ,a1.PropertyName
					   ,case when (
								   select count(PropertyValue)
									from cte a2
									where a1.ProviderId = a2.ProviderId
										and a1.PropertyName = a2.PropertyName
									group by ProviderId
									   ,PropertyName
								  ) > 1
								  and (PropertyName not in ('PharmacyDeliver', 'PharmacyStarRating', 'PharmacyType', 'HospitalAccreditation')) then 'Yes'
							 else PropertyValue
						end as propertyvalue
					into #SourceProvExp
					from cte a1
					order by ProviderId

/*===============================================================================================================================*/


--Disable

		UPDATE T
		SET T.IsEnabled = 0
		FROM #SourceProvExp S
		RIGHT JOIN search.ProviderExtendedProperties T ON S.ProviderId = T.ProviderID AND s.PropertyName = t.PropertyName
		WHERE S.ProviderId IS NULL AND ISNULL(T.IsEnabled,1) <> 0

--Enable
		
		UPDATE T
		SET T.IsEnabled = 1
		FROM #SourceProvExp S
		Inner JOIN search.ProviderExtendedProperties T ON S.ProviderId = T.ProviderID AND s.PropertyName = t.PropertyName
		WHERE  ISNULL(T.IsEnabled,0) <> 1


--Update

		UPDATE T
		SET T.Propertyvalue = S.Propertyvalue
		FROM #SourceProvExp S
		Inner JOIN search.ProviderExtendedProperties T ON S.ProviderId = T.ProviderID AND s.PropertyName = t.PropertyName

--Insert
		INSERT INTO search.ProviderExtendedProperties 
		SELECT S.ProviderId,S.PropertyName,S.PropertyValue,1 FROM #SourceProvExp s
		LEFT join search.ProviderExtendedProperties p on p.ProviderID = s.ProviderId AND p.PropertyName = s.PropertyName
		WHERE p.ProviderID IS NULL AND p.PropertyName IS null

/*************************************************************************************************************************************/


			if object_id('tempdb..#ProviderExtendedProperties') is not null
				drop table #ProviderExtendedProperties

				
			if object_id('tempdb..#SourceProvExp') is not null
				drop table #SourceProvExp


/*************************************************************************************************************************************/

		end
	end
GO
/****** Object:  StoredProcedure [Import].[MergeAllProviderLanguages]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

------------
CREATE Procedure [Import].[MergeAllProviderLanguages]
	@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
				10/03/2016		SS		Added delete statements to delete child table data.
		*/
		declare @now date = getdate()
		declare @Version varchar(100) = '10/03/2016 2:22 Version 1.00'
		declare @ReturnValues table
			(
			 ReturnCode int primary key
							not null
			,Reason varchar(200) not null
			)

		insert into @ReturnValues
				(ReturnCode, Reason)
			values (0, 'Normal Return')			
											
		if @Showversion = 1
			begin
				select object_schema_name(@@PROCId) as SchemaName
					   ,object_name(@@PROCId) as ProcedureName
					   ,@Version as VersionInformation
				if isnull(@ShowReturn, 0) = 0
					return 0
			end

		if @ShowReturn = 1
			begin
				select *
					from @ReturnValues
				return 0
			end

		set nocount on




--All Provider Languages

		begin
			if object_id('tempdb..#ProviderLanguage') is not null
				drop table #ProviderLanguage


			create table #ProviderLanguage
				(
				 ProviderId int not null
				,LanguageId int not null
				)

			insert into #ProviderLanguage		--NPP
				select  distinct P.ProviderId as ProviderId
					   ,L.LanguageId
					from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
						inner join Search.Provider as P with (nolock)
							on P.License = PPI.PPI_License
							   and P.NetDevProvId = PPI.PPI_Id
						inner join Network_Development.dbo.Tbl_Codes_Languages as CL with (nolock)
							on PPI_Language1 = CL.LXCode
						inner join Search.Languages as L with (nolock)
							on L.Description = CL.LXDesc --CL.LXDesc like '%'+ L.Description + '%'
					where PPI.PPI_Language1 is not null
						and P.ProviderType = 'NPP'
				union all
				select  distinct P.ProviderId as ProviderId
					   ,L.LanguageId
					from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
						inner join Search.Provider as P with (nolock)
							on P.License = PPI.PPI_License
							   and P.NetDevProvId = PPI.PPI_Id
						inner join Network_Development.dbo.Tbl_Codes_Languages as CL with (nolock)
							on PPI_Language2 = CL.LXCode
						inner join Search.Languages as L with (nolock)
							on L.Description = CL.LXDesc
					where PPI.PPI_Language2 is not null
						and P.ProviderType = 'NPP'
				union all
				select  distinct P.ProviderId as ProviderId
					   ,L.LanguageId
					from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
						inner join Search.Provider as P with (nolock)
							on P.License = PPI.PPI_License
							   and P.NetDevProvId = PPI.PPI_Id
						inner join Network_Development.dbo.Tbl_Codes_Languages as CL with (nolock)
							on PPI_Language3 = CL.LXCode
						inner join Search.Languages as L with (nolock)
							on L.Description = CL.LXDesc
					where PPI.PPI_Language3 is not null
						and P.ProviderType = 'NPP'
					order by P.ProviderId	

			insert into #ProviderLanguage		--IPA
				select  distinct P.ProviderId as ProviderId
					   ,L.LanguageId
					from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
						inner join Search.Provider as P with (nolock)
							on P.License = PPI.PPI_License
							   and P.NetDevProvId = PPI.PPI_Id
						inner join Network_Development.dbo.Tbl_Codes_Languages as CL with (nolock)
							on PPI_Language1 = CL.LXCode
						inner join Search.Languages as L with (nolock)
							on L.Description = CL.LXDesc
					where PPI.PPI_Language1 is not null
						and P.ProviderType = 'IPA'
				union all
				select  distinct P.ProviderId as ProviderId
					   ,L.LanguageId
					from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
						inner join Search.Provider as P with (nolock)
							on P.License = PPI.PPI_License
							   and P.NetDevProvId = PPI.PPI_Id
						inner join Network_Development.dbo.Tbl_Codes_Languages as CL with (nolock)
							on PPI_Language2 = CL.LXCode
						inner join Search.Languages as L with (nolock)
							on L.Description = CL.LXDesc
					where PPI.PPI_Language1 is not null
						and P.ProviderType = 'IPA'
				union all
				select  distinct P.ProviderId as ProviderId
					   ,L.LanguageId
					from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
						inner join Search.Provider as P with (nolock)
							on P.License = PPI.PPI_License
							   and P.NetDevProvId = PPI.PPI_Id
						inner join Network_Development.dbo.Tbl_Codes_Languages as CL with (nolock)
							on PPI_Language3 = CL.LXCode
						inner join Search.Languages as L with (nolock)
							on L.Description = CL.LXDesc
					where PPI.PPI_Language1 is not null
						and P.ProviderType = 'IPA'
					order by P.ProviderId
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			insert into #ProviderLanguage		--PCP
				select  distinct P.ProviderId as ProviderId
					   ,L.LanguageId
					from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
						inner join Search.Provider as P with (nolock)
							on  P.NetDevProvId = PPI.PPI_Id
						inner join Network_Development.dbo.Tbl_Codes_Languages as CL with (nolock)
							on PPI_Language1 = CL.LXCode
						inner join Search.Languages as L with (nolock)
							on L.Description = CL.LXDesc
					where PPI.PPI_Language1 is not null
						and P.ProviderType in ('PCP', 'NPCP', 'MPCP', 'TPCP')
				union all
				select  distinct P.ProviderId as ProviderId
					   ,L.LanguageId
					from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
						inner join Search.Provider as P with (nolock)
							on  P.NetDevProvId = PPI.PPI_Id
						inner join Network_Development.dbo.Tbl_Codes_Languages as CL with (nolock)
							on PPI_Language2 = CL.LXCode
						inner join Search.Languages as L with (nolock)
							on L.Description = CL.LXDesc
					where PPI.PPI_Language2 is not null
						and P.ProviderType in ('PCP', 'NPCP', 'MPCP', 'TPCP')
				union all
				select  distinct P.ProviderId as ProviderId
					   ,L.LanguageId
					from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
						inner join Search.Provider as P with (nolock)
							on  P.NetDevProvId = PPI.PPI_Id
						inner join Network_Development.dbo.Tbl_Codes_Languages as CL with (nolock)
							on PPI_Language3 = CL.LXCode
						inner join Search.Languages as L with (nolock)
							on L.Description = CL.LXDesc
					where PPI.PPI_Language3 is not null
						and P.ProviderType in ('PCP', 'NPCP', 'MPCP', 'TPCP')
					order by P.ProviderId

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			insert into #ProviderLanguage		--PHRM
				select  distinct P.ProviderId as ProviderId
					   ,L.LanguageId as Language
					from Pharmacy.Pharmacy.dbo.IEHP_Pharmacy_Providers as PH with (nolock)
						inner join Search.Provider as P with (nolock)
							on P.NPI = PH.NPI
							   and P.NetDevProvId = PH.Id
						inner join Network_Development.dbo.Tbl_Codes_Languages as CL with (nolock)
							on PH.Language_1 = CL.LXCode
						inner join Search.Languages as L with (nolock)
							on L.Description = CL.LXDesc
					where (
						   PH.Language_1 is not null
						   or PH.Language_1 <> ''
						  )
						and P.ProviderType = 'PHRM'
				union all
				select  distinct P.ProviderId as ProviderId
					   ,L.LanguageId as Language
					from Pharmacy.Pharmacy.dbo.IEHP_Pharmacy_Providers as PH with (nolock)
						inner join Search.Provider as P with (nolock)
							on P.NPI = PH.NPI
							   and P.NetDevProvId = PH.Id
						inner join Network_Development.dbo.Tbl_Codes_Languages as CL with (nolock)
							on PH.Language_2 = CL.LXCode
						inner join Search.Languages as L with (nolock)
							on L.Description = CL.LXDesc
					where (
						   PH.Language_2 is not null
						   or PH.Language_2 <> ''
						  )
						and P.ProviderType = 'PHRM'
				union all
				select  distinct P.ProviderId as ProviderId
					   ,L.LanguageId as Language
					from Pharmacy.Pharmacy.dbo.IEHP_Pharmacy_Providers as PH with (nolock)
						inner join Search.Provider as P with (nolock)
							on P.NPI = PH.NPI
							   and P.NetDevProvId = PH.Id
						inner join Network_Development.dbo.Tbl_Codes_Languages as CL with (nolock)
							on PH.Language_3 = CL.LXCode
						inner join Search.Languages as L with (nolock)
							on L.Description = CL.LXDesc
					where (
						   PH.Language_3 is not null
						   or PH.Language_3 <> ''
						  )
						and P.ProviderType = 'PHRM'
				union all
				select  distinct P.ProviderId as ProviderId
					   ,L.LanguageId as Language
					from Pharmacy.Pharmacy.dbo.IEHP_Pharmacy_Providers as PH with (nolock)
						inner join Search.Provider as P with (nolock)
							on P.NPI = PH.NPI
							   and P.NetDevProvId = PH.Id
						inner join Network_Development.dbo.Tbl_Codes_Languages as CL with (nolock)
							on PH.Language_4 = CL.LXCode
						inner join Search.Languages as L with (nolock)
							on L.Description = CL.LXDesc
					where (
						   PH.Language_4 is not null
						   or PH.Language_4 <> ''
						  )
						and P.ProviderType = 'PHRM' 

			insert into #ProviderLanguage		--Spec n Behav
				select  distinct P.ProviderId as ProviderId
					   ,L.LanguageId
					from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
						inner join Search.Provider as P with (nolock)
							on P.License = PPI.PPI_License
							   and P.NetDevProvId = PPI.PPI_Id
						inner join Network_Development.dbo.Tbl_Codes_Languages as CL with (nolock)
							on PPI_Language1 = CL.LXCode
						inner join Search.Languages as L with (nolock)
							on L.Description = CL.LXDesc
					where PPI.PPI_Language1 is not null
						and P.ProviderType in ('SPEC', 'PCP/SPEC', 'BH')
				union all
				select  distinct P.ProviderId as ProviderId
					   ,L.LanguageId
					from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
						inner join Search.Provider as P with (nolock)
							on P.License = PPI.PPI_License
							   and P.NetDevProvId = PPI.PPI_Id
						inner join Network_Development.dbo.Tbl_Codes_Languages as CL with (nolock)
							on PPI_Language2 = CL.LXCode
						inner join Search.Languages as L with (nolock)
							on L.Description = CL.LXDesc
					where PPI.PPI_Language2 is not null
						and P.ProviderType in ('SPEC', 'PCP/SPEC', 'BH')
				union all
				select  distinct P.ProviderId as ProviderId
					   ,L.LanguageId
					from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
						inner join Search.Provider as P with (nolock)
							on P.License = PPI.PPI_License
							   and P.NetDevProvId = PPI.PPI_Id
						inner join Network_Development.dbo.Tbl_Codes_Languages as CL with (nolock)
							on PPI_Language3 = CL.LXCode
						inner join Search.Languages as L with (nolock)
							on L.Description = CL.LXDesc
					where PPI.PPI_Language3 is not null
						and P.ProviderType in ('SPEC', 'PCP/SPEC', 'BH')
					order by P.ProviderId

			insert into #ProviderLanguage		--UC
				select  distinct P.ProviderId as ProviderId
					   ,L.LanguageId
					from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
						inner join Search.Provider as P with (nolock)
							on P.License = PPI.PPI_License
							   and P.NetDevProvId = PPI.PPI_Id
						inner join Network_Development.dbo.Tbl_Codes_Languages as CL with (nolock)
							on PPI_Language1 = CL.LXCode
						inner join Search.Languages as L with (nolock)
							on L.Description = CL.LXDesc
					where PPI.PPI_Language1 is not null
						and P.ProviderType = 'UC'
				union all
				select  distinct P.ProviderId as ProviderId
					   ,L.LanguageId
					from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
						inner join Search.Provider as P with (nolock)
							on P.License = PPI.PPI_License
							   and P.NetDevProvId = PPI.PPI_Id
						inner join Network_Development.dbo.Tbl_Codes_Languages as CL with (nolock)
							on PPI_Language2 = CL.LXCode
						inner join Search.Languages as L with (nolock)
							on L.Description = CL.LXDesc
					where PPI.PPI_Language2 is not null
						and P.ProviderType = 'UC'
				union all
				select  distinct P.ProviderId as ProviderId
					   ,L.LanguageId
					from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
						inner join Search.Provider as P with (nolock)
							on P.License = PPI.PPI_License
							   and P.NetDevProvId = PPI.PPI_Id
						inner join Network_Development.dbo.Tbl_Codes_Languages as CL with (nolock)
							on PPI_Language3 = CL.LXCode
						inner join Search.Languages as L with (nolock)
							on L.Description = CL.LXDesc
					where PPI.PPI_Language3 is not null
						and P.ProviderType = 'UC'
					order by P.ProviderId

			insert into #ProviderLanguage		--VSN
				select  distinct P.ProviderId as ProviderId
					   ,L.LanguageId
					from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
						inner join Search.Provider as P with (nolock)
							on P.License = PPI.PPI_License
							   and P.NetDevProvId = PPI.PPI_Id
						inner join Network_Development.dbo.Tbl_Codes_Languages as CL with (nolock)
							on PPI_Language1 = CL.LXCode
						inner join Search.Languages as L with (nolock)
							on L.Description = CL.LXDesc
					where PPI.PPI_Language1 is not null
						and P.ProviderType = 'VSN'
				union all
				select  distinct P.ProviderId as ProviderId
					   ,L.LanguageId
					from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
						inner join Search.Provider as P with (nolock)
							on P.License = PPI.PPI_License
							   and P.NetDevProvId = PPI.PPI_Id
						inner join Network_Development.dbo.Tbl_Codes_Languages as CL with (nolock)
							on PPI_Language2 = CL.LXCode
						inner join Search.Languages as L with (nolock)
							on L.Description = CL.LXDesc
					where PPI.PPI_Language2 is not null
						and P.ProviderType = 'VSN'
				union all
				select  distinct P.ProviderId as ProviderId
					   ,L.LanguageId
					from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
						inner join Search.Provider as P with (nolock)
							on P.License = PPI.PPI_License
							   and P.NetDevProvId = PPI.PPI_Id
						inner join Network_Development.dbo.Tbl_Codes_Languages as CL with (nolock)
							on PPI_Language3 = CL.LXCode
						inner join Search.Languages as L with (nolock)
							on L.Description = CL.LXDesc
					where PPI.PPI_Language3 is not null
						and P.ProviderType = 'VSN'
					order by P.ProviderId

			insert into #ProviderLanguage		--ANC
				select  distinct P.ProviderId as ProviderId
					   ,L.LanguageId
					from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
						inner join Search.Provider as P with (nolock)
							on P.NetDevProvId = PPI.PPI_Id
						inner join Network_Development.dbo.Tbl_Codes_Languages as CL with (nolock)
							on PPI_Language1 = CL.LXCode
						inner join Search.Languages as L with (nolock)
							on L.Description = CL.LXDesc
					where PPI.PPI_Language1 is not null
						and P.ProviderType in ('ANC', 'DANC')
				union all
				select  distinct P.ProviderId as ProviderId
					   ,L.LanguageId
					from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
						inner join Search.Provider as P with (nolock)
							on P.License = PPI.PPI_License
							   and P.NetDevProvId = PPI.PPI_Id
						inner join Network_Development.dbo.Tbl_Codes_Languages as CL with (nolock)
							on PPI_Language2 = CL.LXCode
						inner join Search.Languages as L with (nolock)
							on L.Description = CL.LXDesc
					where PPI.PPI_Language2 is not null
						and P.ProviderType in ('ANC', 'DANC')
				union all
				select  distinct P.ProviderId as ProviderId
					   ,L.LanguageId
					from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
						inner join Search.Provider as P with (nolock)
							on P.License = PPI.PPI_License
							   and P.NetDevProvId = PPI.PPI_Id
						inner join Network_Development.dbo.Tbl_Codes_Languages as CL with (nolock)
							on PPI_Language3 = CL.LXCode
						inner join Search.Languages as L with (nolock)
							on L.Description = CL.LXDesc
					where PPI.PPI_Language3 is not null
						and P.ProviderType in ('ANC', 'DANC')
					order by P.ProviderId
	 
			insert into #ProviderLanguage		--HOSP
				select distinct P.ProviderId as ProviderId
					   ,LanguageId
					from Search.Provider as P with (nolock)
						inner join Search.Languages as L with (nolock)
							on L.Description = 'Translation Services Available'
					where P.ProviderType = 'HOSP'

		
			insert into #ProviderLanguage		--LTSS
				select distinct P.ProviderId as ProviderId
					   ,LanguageId
					from Search.Provider as P with (nolock)
						inner join Search.Languages as L with (nolock)
							on L.Description = 'Translation Services Available'
					where P.ProviderType = 'LTSS'

			insert into #ProviderLanguage		--SNF
				select distinct P.ProviderId as ProviderId
					   ,LanguageId
					from Search.Provider as P with (nolock)
						inner join Search.Languages as L with (nolock)
							on L.Description = 'Translation Services Available'
					where P.ProviderType = 'SNF'
  
/***************************************************************************************************************************************/

--Disabled
	
	UPDATE L
	SET L.IsEnabled = 0
	FROM #ProviderLanguage S
	RIGHT JOIN search.ProviderLanguage L ON L.ProviderID = S.ProviderId AND L.LanguageID = S.LanguageId
	WHERE (S.ProviderId IS NULL OR S.LanguageId IS NULL) AND ISNULL(L.IsEnabled,1) <> 0

--Enable
	
	UPDATE L
	SET L.IsEnabled = 1
	FROM #ProviderLanguage S
	INNER JOIN search.ProviderLanguage L ON L.ProviderID = S.ProviderId AND L.LanguageID = S.LanguageId
	WHERE ISNULL(L.IsEnabled,0) <> 1


--Insert
	INSERT INTO search.ProviderLanguage
	SELECT DISTINCT T.LanguageID,T.ProviderId,1 AS IsEnabled FROM #ProviderLanguage T
	LEFT join search.ProviderLanguage pl on t.ProviderId = pl.ProviderID AND t.LanguageId = pl.LanguageID
	WHERE pl.providerid IS NULL AND pl.LanguageID IS null
	
/**************************************************************************************************************/
	if object_id('tempdb..#ProviderLanguage') is not null
				drop table #ProviderLanguage



/**************************************************************************************************************/				


		end
	end
GO
/****** Object:  StoredProcedure [Import].[MergeAllProviders]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

------------
CREATE Procedure [Import].[MergeAllProviders]
@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
				10/03/2016		SS		Added delete statements to delete child table data.
		*/
		
		declare @now date = getdate()
		declare @Version varchar(100) = '10/03/2016 2:22 Version 1.00'
		declare @ReturnValues table
			(
			 ReturnCode int primary key
							not null
			,Reason varchar(200) not null
			)

		insert into @ReturnValues
				(ReturnCode, Reason)
			values (0, 'Normal Return')			
											
		if @Showversion = 1
			begin
				select object_schema_name(@@PROCId) as SchemaName
					   ,object_name(@@PROCId) as ProcedureName
					   ,@Version as VersionInformation
				if isnull(@ShowReturn, 0) = 0
					return 0
			end

		if @ShowReturn = 1
			begin
				select *
					from @ReturnValues
				return 0
			end

		set nocount on

		begin													--Create Temp table to store diamond id from net dev to avoid duplicates

--declare @now date = getdate()
			declare @Prov table
				(
				 CLNS_ProviderId int
				,CLNS_DiamondId varchar(12)
				)
			insert into @Prov
				select distinct CLNS_ProviderId
					   ,CLNS_DiamondId
					from Network_Development.dbo.Tbl_Contract_LocationsNumbers
					where CLNS_ProviderId is not null
						and CLNS_DiamondId is not null
						and CLNS_Status = 1
	
			insert into @Prov
				select distinct CLNS_ProviderId
					   ,CLNS_DiamondId
					from Network_Development.dbo.Tbl_Contract_LocationsNumbers t1
					where CLNS_ProviderId is not null
						and CLNS_Status = 1
						and not exists ( select 1
											from @Prov t2
											where t1.CLNS_ProviderId = t2.CLNS_ProviderId )

			begin

				if object_id('tempdb..#Providers') is not null
					drop table #Providers 

				create table #Providers
					(
					 ProviderId int identity(1, 1)
									not null
					,DiamProvId varchar(12) not null
					,FirstName varchar(100) null
					,LastName varchar(60) null
					,Gender varchar(6) null
					,OrganizationName varchar(200) null
					,License varchar(50) null
					,NPI varchar(10) null
					,ProviderType varchar(12) null
					,NetDevProvId varchar(12) null
					,IsInternalOnly bit default 0
					,IsEnabled BIT DEFAULT 1
					,MemberShipStatus VARCHAR(75) NULL
                    ,PreferredFirstName VARCHAR(100) null
					)
				begin		--Merge ANC providers
					insert into #Providers			--ANC
						select distinct isnull(LN.CLNS_DiamondId, '') as DiamProvId
							   ,																										--Can not insert null into DiamProvId so Inserting empty String
								PP.PPI_FirstName + ' ' + isnull(PP.PPI_MiddleName, '') as FirstName
							   ,case when (
										   PP.PPI_FirstName is null
										   or PP.PPI_FirstName = ''
										  )
										  and (
											   PP.PPI_LastName is not null
											   or PP.PPI_LastName <> ''
											  ) then null					--If provider is organization then inserting into Organization field
									 else PP.PPI_LastName
								end as LastName
							   ,PG.PPG_Gender as Gender
							   ,case when (
										   PP.PPI_FirstName is null
										   and PP.PPI_LastName <> ''
										  ) then PP.PPI_LastName
									 else 'N/A'
								end as OrganizationName
							   ,PP.PPI_License as License
							   ,PP.PPI_UPIN as NPI
							   ,PPY_Code as ProviderType
							   ,PP.PPI_Id as NetDevProvId
							   ,Case when CCi.CCI_contractType in (10,12) Then 1
									 WHEN PP.PPI_ProviderStatus = 7	  THEN 1 
								ELSE 0 end as IsInternalOnly
								,1 AS IsEnabled
								,dblv.DBLV_Value AS MemberShipStatus
								,PP.PPI_PreferredFirstName AS PreferredFirstName

							from Network_Development.dbo.Tbl_Provider_ProviderInfo as PP with (nolock)
								inner join Network_Development.dbo.Tbl_Provider_ProviderType as PT with (nolock)
									on PT.PPY_Id = PP.PPI_Type
								left join Network_Development.dbo.tbl_Contract_CPL as CPL with (nolock) on CPl.CCPL_ProviderID = PP.PPI_Id
								left join Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock) on CCI.CCI_ID = cpl.CCPL_ContractID
								left join Network_Development.dbo.Tbl_Provider_ProviderGender as PG with (nolock)
									on PG.PPG_Id = PP.PPI_Gender
								left join @Prov as LN
									on LN.CLNS_ProviderId = PP.PPI_Id
								left join Network_Development.dbo.Tbl_Provider_ProviderSpecialties as PSP with (nolock)
									on PSP_Id = PP.PPI_Specialty1
								LEFT JOIN Network_Development.dbo.Tbl_Database_ListValues AS  dblv WITH (nolock) ON DBLV_List = 125 AND DBLV_ID = pp.PPI_MembershipStatus
							where PT.PPY_Id in ('17', '28') and  (CCI.CCI_TermDate is null or (CCI.CCI_TermDate >getdate()) and CPL.CCPL_TermDate is null or CPL.CCPL_TermDate > GETDATE())
								and (PP.PPI_UPIN is not null)
								and (PSP_Id <> 124 or PSP_ID is null)
							order by PPY_Code	
												--PPY_Id 17,18 are provider type ANC,DANC
				end
-----------------------------------------------------------------------------
				begin			--Merge HOSpitals
					insert into #Providers			--HOSP
						select distinct isnull(CCI.CCI_ContractDiamondId, '') as DiamProvId
							   ,null as FirstName
							   ,null as LastName
							   ,null as Gender
							   ,case when (
										   CCI.CCI_DBA is null
										   or CCI.CCI_DBA = ''
										  ) then CCI.CCI_ContractName
									 else CCI.CCI_DBA
								end as OrganizationName
							   ,PP.PPI_License as License
							   ,PP.PPI_UPIN as NPI
							   ,'HOSP' as ProviderType
							   ,PP.PPI_Id as NetDevProvId
							    ,Case  WHEN PP.PPI_ProviderStatus = 7	  THEN 1 
								ELSE 0 end as IsInternalOnly
								,1 AS IsEnabled
								,dblv.DBLV_Value AS MemberShipStatus
								,pp.PPI_PreferredFirstName AS PreferredFirstName
							from Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock)
								inner join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
									on CPL.CCPL_ContractId = CCI.CCI_Id
								inner join Network_Development.dbo.Tbl_Provider_ProviderInfo as PP with (nolock)
									on PP.PPI_Id = CPL.CCPL_ProviderId
								LEFT JOIN Network_Development.dbo.Tbl_Database_ListValues AS  dblv WITH (nolock) ON DBLV_List = 125 AND DBLV_ID = pp.PPI_MembershipStatus
							where CCI.CCI_ContractType in (8, 9)
								and( CCI.CCI_TermDate is null
								or CCI_TermDate > @now)
								and (
									 CPL.CCPL_TermDate is null
									 or CPL.CCPL_TermDate > @now
									)
								and not exists ( select 1
													from #Providers
													where CCI.CCI_ContractDiamondId = #Providers.DiamProvId )
								and not exists ( select 1
													from #Providers
													where PP.PPI_Id = #Providers.NetDevProvId )
			--order by CCI.CCI_ContractName
	--Avoid duplicates by chekcing if diamond Id already exists.
				end
-------------------------------------------------------------------------------------------------
				begin		--Merge IPA
					insert into #Providers			--IPA
						select distinct isnull(LN.CLNS_DiamondId, '') as ProviderId
							   ,PP.PPI_FirstName + ' ' + isnull(PP.PPI_MiddleName, '') as FirstName
							   ,case when (
										   PP.PPI_FirstName is null
										   or PP.PPI_FirstName = ''
										  )
										  and (
											   PP.PPI_LastName is not null
											   or PP.PPI_LastName <> ''
											  ) then null
									 else PP.PPI_LastName
								end as LastName
							   ,PG.PPG_Gender as Gender
							   ,case when (
										   PP.PPI_FirstName is null
										   and PP.PPI_LastName <> ''
										  ) then PP.PPI_LastName
									 else 'N/A'
								end as OrganizationName
							   ,PP.PPI_License as License
							   ,PP.PPI_UPIN as NPI
							   ,PPY_Diamond as ProviderType
							   ,PP.PPI_Id as NetDevProvId
							    ,Case when CCi.CCI_contractType in (10,12) Then 1
								 WHEN PP.PPI_ProviderStatus = 7	  THEN 1 
								ELSE 0 end as IsInternalOnly
								,1 AS IsEnabled
								,dblv.DBLV_Value AS MemberShipStatus
								,PP.PPI_PreferredFirstName AS PreferredFirstName
							from Network_Development.dbo.Tbl_Provider_ProviderInfo as PP with (nolock)
								inner join Network_Development.dbo.Tbl_Provider_ProviderType as PT with (nolock)
									on PT.PPY_Id = PP.PPI_Type
								left join Network_Development.dbo.tbl_Contract_CPL as CPL with (nolock) on CPl.CCPL_ProviderID = PP.PPI_Id
								left join Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock) on CCI.CCI_ID = cpl.CCPL_ContractID
								left join Network_Development.dbo.Tbl_Provider_ProviderGender as PG with (nolock)
									on PG.PPG_Id = PP.PPI_Gender
								left join @Prov as LN 
									on LN.CLNS_ProviderId = PP.PPI_Id
								LEFT JOIN Network_Development.dbo.Tbl_Database_ListValues AS  dblv WITH (nolock) ON DBLV_List = 125 AND DBLV_ID = pp.PPI_MembershipStatus
							where PP.PPI_Type = 24  and  (CCI.CCI_TermDate is null or (CCI.CCI_TermDate >getdate()) and CPL.CCPL_TermDate is null or CPL.CCPL_TermDate > GETDATE())
								and not exists ( select 1
													from #Providers
													where LN.CLNS_DiamondId = #Providers.DiamProvId )
								and not exists ( select 1
													from #Providers
													where PP.PPI_Id = #Providers.NetDevProvId )																						
				end

------------------------------------------------------------------------------------------------------
				begin		--Merge LTSS
					insert into #Providers			--LTSS
						select distinct CCI.CCI_ContractDiamondId as DiamProvId
							   ,null as FirstName
							   ,null as LastName
							   ,null as Gender
							   ,case when CCI.CCI_DBA is not null then CCI.CCI_DBA
									 else CCI.CCI_ContractName
								end as OrganizationName
							   ,PPI.PPI_License as License
							   ,PPI.PPI_UPIN as NPI
							   ,'LTSS' as ProviderType
							   ,PPI.PPI_Id as NetDevProvId
							    ,Case when CCi.CCI_contractType in (10,12) Then 1
								 WHEN PPI.PPI_ProviderStatus = 7	  THEN 1 
								ELSE 0 end as IsInternalOnly
								,1 AS IsEnabled
								,dblv.DBLV_Value AS MemberShipStatus
								,PPI.PPI_PreferredFirstName AS PreferredFirstName
							from Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock)
								inner join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
									on CPL.CCPL_ContractId = CCI.CCI_Id
								inner join Network_Development.dbo.Tbl_Contract_Locations as CL with (nolock)
									on CPL.CCPL_LocationId = CL.CL_Id
								inner  join Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
									on CPL.CCPL_ProviderId = PPI.PPI_Id
								LEFT JOIN Network_Development.dbo.Tbl_Database_ListValues AS  dblv WITH (nolock) ON DBLV_List = 125 AND DBLV_ID = ppi.PPI_MembershipStatus
							where CCI.CCI_ContractTitle = 53
								and CCI.CCI_Status = 1
								and (
									 CPL.CCPL_TermDate > @now
									 or CPL.CCPL_TermDate is null
									)
								and not exists ( select 1
													from #Providers
													where CCI.CCI_ContractDiamondId = #Providers.DiamProvId )
								and not exists ( select 1
													from #Providers
													where PPI.PPI_Id = #Providers.NetDevProvId )
				end
--------------------------------------------------------------------------------------
				begin		--Merge NPP
					insert into #Providers			--NPP
						select distinct isnull(LN.CLNS_DiamondId, '') as DiamProvId
							   ,PP.PPI_FirstName + ' ' + isnull(PP.PPI_MiddleName, '') as FirstName
							   ,case when (
										   PP.PPI_FirstName is null
										   or PP.PPI_FirstName = ''
										  )
										  and (
											   PP.PPI_LastName is not null
											   or PP.PPI_LastName <> ''
											  ) then null
									 else PP.PPI_LastName
								end as LastName
							   ,PG.PPG_Gender as Gender
							   ,case when (
										   PP.PPI_FirstName is null
										   and PP.PPI_LastName <> ''
										  ) then PP.PPI_LastName
									 else 'N/A'
								end as OrganizationName
							   ,PP.PPI_License as License
							   ,PP.PPI_UPIN as NPI
							   ,PPY_Diamond as ProviderType
							   ,PP.PPI_Id as NetDevProvId
							    ,Case when CCi.CCI_contractType in (10,12) Then 1
								 WHEN PP.PPI_ProviderStatus = 7	  THEN 1 
								ELSE 0 end as IsInternalOnly
							   ,1 AS IsEnabled
							   ,dblv.DBLV_Value AS MemberShipStatus
							   ,PP.PPI_PreferredFirstName AS PreferredFirstName
							from Network_Development.dbo.Tbl_Provider_ProviderInfo as PP with (nolock)
								inner join Network_Development.dbo.Tbl_Provider_ProviderType as PT with (nolock)
									on PT.PPY_Id = PP.PPI_Type
								left join Network_Development.dbo.tbl_Contract_CPL as CPL with (nolock) on CPl.CCPL_ProviderID = PP.PPI_Id
								left join Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock) on CCI.CCI_ID = cpl.CCPL_ContractID
								left join Network_Development.dbo.Tbl_Provider_ProviderGender as PG with (nolock)
									on PG.PPG_Id = PP.PPI_Gender
								left join @Prov as LN 
									on LN.CLNS_ProviderId = PP.PPI_Id
								LEFT JOIN Network_Development.dbo.Tbl_Database_ListValues AS  dblv WITH (nolock) ON DBLV_List = 125 AND DBLV_ID = pp.PPI_MembershipStatus
							where PP.PPI_Type in ('5', '8', '9') and  (CCI.CCI_TermDate is null or (CCI.CCI_TermDate >getdate()) and CPL.CCPL_TermDate is null or CPL.CCPL_TermDate > GETDATE())
								and not exists ( select 1
													from #Providers
													where LN.CLNS_DiamondId = #Providers.DiamProvId )
								and not exists ( select 1
													from #Providers
													where PP.PPI_Id = #Providers.NetDevProvId )
				end
---------------------------------------------------------------------------------------------
				begin		--Merge PCP
					insert into #Providers			--PCP
-- If Provider is a organization
						select distinct isnull(LN.CLNS_DiamondId, '') as DiamProvId,
							   PP.PPI_FirstName + ' ' + isnull(PP.PPI_MiddleName, '') as FirstName
							   ,case when (
										   PP.PPI_FirstName is null
										   or PP.PPI_FirstName = ''
										  )
										  and (
											   PP.PPI_LastName is not null
											   or PP.PPI_LastName <> ''
											  ) then null
									 else PP.PPI_LastName
								end as LastName
							   ,PG.PPG_Gender as Gender
							   ,case when (
										   PP.PPI_FirstName is null
										   and PP.PPI_LastName <> ''
										  ) then PP.PPI_LastName
									 else 'N/A'
								end as OrganizationName
							   ,PP.PPI_License as License
							   ,PP.PPI_UPIN as NPI
							   ,CASE WHEN PP.PPI_Type = 1 THEN 'PCP' ELSE PT.PPY_Diamond end as ProviderType
							   ,PP.PPI_Id as NetDevProvId
							    ,Case WHEN PP.PPI_ProviderStatus IN(7,2) THEN 1 
								   WHEN	 PP.PPI_Group = 1 THEN 1
								ELSE 0 end as IsInternalOnly
							   ,1 AS IsEnabled
							   ,dblv.DBLV_Value AS MemberShipStatus
							   ,PP.PPI_PreferredFirstName AS PreferredFirstName
							from Network_Development.dbo.Tbl_Provider_ProviderInfo as PP with (nolock)
								inner join Network_Development.dbo.Tbl_Provider_ProviderType as PT with (nolock)
									on PT.PPY_Id = PP.PPI_Type
								INNER join Network_Development.dbo.Tbl_Provider_ProviderAffiliation ppa WITH (nolock) ON ppa.PPA_ProviderID = PP.PPI_ID
								left join @Prov as LN on LN.CLNS_ProviderId = PP.PPI_Id
								left join Network_Development.dbo.Tbl_Provider_ProviderGender as PG with (nolock)on PG.PPG_Id = PP.PPI_Gender
								LEFT JOIN Network_Development.dbo.Tbl_Database_ListValues AS  dblv WITH (nolock) ON DBLV_List = 125 AND DBLV_ID = pp.PPI_MembershipStatus
							where PP.PPI_Type in (10,1) and  (ppa.PPA_TermDate is null or (ppa.PPA_TermDate >@now))
UNION
						SELECT distinct isnull(LN.CLNS_DiamondId, '') as DiamProvId,
							   PP.PPI_FirstName + ' ' + isnull(PP.PPI_MiddleName, '') as FirstName
							   ,case when (
										   PP.PPI_FirstName is null
										   or PP.PPI_FirstName = ''
										  )
										  and (
											   PP.PPI_LastName is not null
											   or PP.PPI_LastName <> ''
											  ) then null
									 else PP.PPI_LastName
								end as LastName
							   ,PG.PPG_Gender as Gender
							   ,case when (
										   PP.PPI_FirstName is null
										   and PP.PPI_LastName <> ''
										  ) then PP.PPI_LastName
									 else 'N/A'
								end as OrganizationName
							   ,PP.PPI_License as License
							   ,PP.PPI_UPIN as NPI
							   ,CASE WHEN PP.PPI_Type = 1 THEN 'SPEC' ELSE PT.PPY_Diamond end as ProviderType
							   ,PP.PPI_Id as NetDevProvId
							    ,Case WHEN PP.PPI_ProviderStatus IN(7,2) THEN 1 
								WHEN	 PP.PPI_Group = 1 THEN 1
								ELSE 0 end as IsInternalOnly
							   ,1 AS IsEnabled
							   ,dblv.DBLV_Value AS MemberShipStatus
							   ,PP.PPI_PreferredFirstName AS PreferredFirstName
							from Network_Development.dbo.Tbl_Provider_ProviderInfo as PP with (nolock)
								inner join Network_Development.dbo.Tbl_Provider_ProviderType as PT with (nolock)
									on PT.PPY_Id = PP.PPI_Type
								INNER join Network_Development.dbo.Tbl_Contract_CPL ccpl WITH (nolock) ON ccpl.CCPL_ProviderID = PP.PPI_ID
								INNER JOIN Network_Development.dbo.Tbl_Contract_ContractInfo cci WITH (nolock) ON cci.CCI_ID = ccpl.CCPL_ContractID
								left join @Prov as LN on LN.CLNS_ProviderId = PP.PPI_Id
								left join Network_Development.dbo.Tbl_Provider_ProviderGender as PG with (nolock)on PG.PPG_Id = PP.PPI_Gender
								LEFT JOIN Network_Development.dbo.Tbl_Database_ListValues AS  dblv WITH (nolock) ON DBLV_List = 125 AND DBLV_ID = pp.PPI_MembershipStatus
							where PP.PPI_Type in (10,1) and  (ccpl.CCPL_TermDate is null or (ccpl.CCPL_TermDate >@now)) AND (cci.CCI_TermDate IS NULL OR cci.CCI_TermDate >@now)


				end
------------------------------------------------------------------------------------------------------------
				begin		--Merge PHRM
					insert into #Providers			--PHRM
						select distinct isnull(PH.DiamondId, '') as DiamProvId
							   ,null as FirstName
							   ,null as LastName
							   ,null as Gender
							   ,PH.Pharmacy_Name as OrganizationName
							   ,PH.CA_License as License
							   ,PH.NPI as NPI
							   ,'PHRM' as ProviderType
							   ,PH.Id as NetDevProvId		
							   ,0 as IsInternalOnly		
							   ,1 AS IsEnabled
							   ,NULL AS MemberShipStatus		
							   ,NULL AS PreferredFirstName								--ph.id is unique id for each pharmacy in pharmacy table but this is not ned dev id
							from Pharmacy.Pharmacy.dbo.IEHP_Pharmacy_Providers as PH with (nolock)
								left join Pharmacy.Pharmacy.dbo.PharmType_Codes as PTC with (nolock)
									on PH.Pharmacy_Type = PTC.PT_Code
							where (
								   (
									(PH.Cty) = 'Riv'
									or (PH.Cty) = 'SB'
								   )
								   and (
										(PH.NABP) not like '00000'
										and (PH.NABP) not like '99999'
									   )
								   and (
										(PH.ClosedDate) is null
										and PH.ClosedDate > @now
									   )
								  )
								or (
									((PH.Cty) = 'LA')
									and (
										 (PH.City) like 'Chino'
										 or (PH.City) like 'Pomona'
										 or (PH.City) like 'Montclair'
										 or (PH.City) = 'Chino Hills'
										)
									and ((PH.ClosedDate) is null)
								   )
								or (
									((PH.IEHP_Network) = '1')
									and ((PH.ClosedDate) is null)
								   )
								and not exists ( select 1
													from #Providers
													where PH.DiamondId = #Providers.DiamProvId )
		
				end
------------------------------------------------------------------------------------------------------------------
				begin			--Merge SNF
					insert into #Providers			--SNF
						select distinct isnull(CCI.CCI_ContractDiamondId, '') as DiamProvId
							   ,null as FirstName
							   ,null as LastName
							   ,null as Gender
							   ,case when CCI.CCI_DBA is not null then CCI.CCI_DBA
									 else CCI.CCI_ContractName
								end as OrganizationName
							   ,PPI.PPI_License as License
							   ,PPI.PPI_UPIN as NPI
							   ,'SNF' as ProviderType
							   ,PPI.PPI_Id as NetDevProvId
							   ,Case when CCi.CCI_contractType in (10,12) Then 1
							    WHEN PPI.PPI_ProviderStatus = 7	  THEN 1 
								 ELSE 0 end as IsInternalOnly
								 ,1 AS IsEnabled
								 ,dblv.DBLV_Value AS MemberShipStatus
								 ,PPI.PPI_PreferredFirstName AS PreferredFirstName
							from Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock)
								inner join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
									on CPL.CCPL_ContractId = CCI.CCI_Id
								inner join Network_Development.dbo.Tbl_Contract_Locations as CL with (nolock)
									on CPL.CCPL_LocationId = CL.CL_Id
								inner  join Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
									on CPL.CCPL_ProviderId = PPI.PPI_Id
								LEFT JOIN Network_Development.dbo.Tbl_Database_ListValues AS  dblv WITH (nolock) ON DBLV_List = 125 AND DBLV_ID = ppi.PPI_MembershipStatus
							where (
								   (CCI.CCI_ContractType = 17)
								   or (
									   CCI.CCI_ContractType = 18
									   and CCI.CCI_ContractTitle in (97, 30)
									  )
								  )
								and CCI.CCI_Status = 1
								and (
									 CPL.CCPL_TermDate > @now
									 or CPL.CCPL_TermDate is null
									)
								and not exists ( select 1
													from #Providers
													where CCI.CCI_ContractDiamondId = #Providers.DiamProvId )
								and not exists ( select 1
													from #Providers
													where PPI.PPI_Id = #Providers.NetDevProvId )
				end
---------------------------------------------------------------------------------------------------------------------------
				begin		--Merge Spec n Behav
					insert into #Providers			--SPEC n BEhav
						select distinct isnull(LN.CLNS_DiamondId, '') as DiamProvId
							   ,PP.PPI_FirstName + ' ' + isnull(PP.PPI_MiddleName, '') as FirstName
							   ,case when (
										   PP.PPI_FirstName is null
										   or PP.PPI_FirstName = ''
										  )
										  and (
											   PP.PPI_LastName is not null
											   or PP.PPI_LastName <> ''
											  ) then null
									 else PP.PPI_LastName
								end as LastName
							   ,PG.PPG_Gender as Gender
							   ,case when (
										   PP.PPI_FirstName is null
										   and PP.PPI_LastName <> ''
										  ) then PP.PPI_LastName
									 else 'N/A'
								end as OrganizationName
							   ,PP.PPI_License as License
							   ,PP.PPI_UPIN as NPI
							   ,case when PP.PPI_Type = 27 then PPY_Code
									 WHEN PP.PPI_Type = 1 THEN 'SPEC'
									 else PT.PPY_Diamond
								end as ProviderType
							   ,PP.PPI_Id as NetDevProvId
							    ,Case when CCi.CCI_contractType in (10,12) Then 1
								 WHEN PP.PPI_ProviderStatus = 7	  THEN 1 
								 ELSE 0 end as IsInternalOnly
								 ,1 AS IsEnabled
								 ,dblv.DBLV_Value AS MemberShipStatus
								 ,PP.PPI_PreferredFirstName AS PreferredFirstName
							from Network_Development.dbo.Tbl_Provider_ProviderInfo as PP with (nolock)
								inner join Network_Development.dbo.Tbl_Provider_ProviderType as PT with (nolock)
									on PT.PPY_Id = PP.PPI_Type
								left join Network_Development.dbo.tbl_Contract_CPL as CPL with (nolock) on CPl.CCPL_ProviderID = PP.PPI_Id
								left join Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock) on CCI.CCI_ID = cpl.CCPL_ContractID
								left join Network_Development.dbo.Tbl_Provider_ProviderGender as PG with (nolock)
									on PG.PPG_Id = PP.PPI_Gender
								left join @Prov as LN 
									on LN.CLNS_ProviderId = PP.PPI_Id
								LEFT JOIN Network_Development.dbo.Tbl_Database_ListValues AS  dblv WITH (nolock) ON DBLV_List = 125 AND DBLV_ID = pp.PPI_MembershipStatus
							where PP.PPI_Type in (1, 6, 12, 13, 29)  and  (CCI.CCI_TermDate is null or (CCI.CCI_TermDate >getdate()) and CPL.CCPL_TermDate is null or CPL.CCPL_TermDate > GETDATE())
								and not exists ( select 1
													from #Providers
													where LN.CLNS_DiamondId = #Providers.DiamProvId and #Providers.ProviderTYpe <> 'PCP')			----Specialist n BH
								and not exists ( select 1
													from #Providers
													where PP.PPI_Id = #Providers.NetDevProvId and #Providers.ProviderType <> 'PCP' )

					insert into #Providers
							select distinct isnull(LN.CLNS_DiamondId, '') as DiamProvId
							   ,PP.PPI_FirstName + ' ' + isnull(PP.PPI_MiddleName, '') as FirstName
							   ,case when (
										   PP.PPI_FirstName is null
										   or PP.PPI_FirstName = ''
										  )
										  and (
											   PP.PPI_LastName is not null
											   or PP.PPI_LastName <> ''
											  ) then null
									 else PP.PPI_LastName
								end as LastName
							   ,PG.PPG_Gender as Gender
							   ,case when (
										   PP.PPI_FirstName is null
										   and PP.PPI_LastName <> ''
										  ) then PP.PPI_LastName
									 else 'N/A'
								end as OrganizationName
							   ,PP.PPI_License as License
							   ,PP.PPI_UPIN as NPI
							   ,case when PP.PPI_Type = 27 then PPY_Code
									 else PT.PPY_Diamond
								end as ProviderType
							   ,PP.PPI_Id as NetDevProvId
							    ,Case 
									  when CCi.CCI_contractType in (10,12) Then 1
									   WHEN PP.PPI_ProviderStatus = 7	  THEN 1 
								 ELSE 0 end as IsInternalOnly
								 ,1 AS IsEnabled
								 ,dblv.DBLV_Value AS MemberShipStatus
								 ,PP.PPI_PreferredFirstName AS PreferredFirstName
							from Network_Development.dbo.Tbl_Provider_ProviderInfo as PP with (nolock)
								inner join Network_Development.dbo.Tbl_Provider_ProviderType as PT with (nolock)
									on PT.PPY_Id = PP.PPI_Type
								left join Network_Development.dbo.tbl_Contract_CPL as CPL with (nolock) on CPl.CCPL_ProviderID = PP.PPI_Id
								left join Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock) on CCI.CCI_ID = cpl.CCPL_ContractID
								left join Network_Development.dbo.Tbl_Provider_ProviderGender as PG with (nolock)
									on PG.PPG_Id = PP.PPI_Gender
								left join Network_Development.dbo.Tbl_Provider_ProviderSpecialties as PSP with (nolock)
									on PSP_Id = PP.PPI_Specialty1
								left join @Prov as LN
									on LN.CLNS_ProviderId = PP.PPI_Id
								LEFT JOIN Network_Development.dbo.Tbl_Database_ListValues AS  dblv WITH (nolock) ON DBLV_List = 125 AND DBLV_ID = pp.PPI_MembershipStatus
							where PP.PPI_Type in (27) and  (CCI.CCI_TermDate is null or (CCI.CCI_TermDate >getdate()) and CPL.CCPL_TermDate is null or CPL.CCPL_TermDate > GETDATE())
								and (PSP.PSP_ProviderDirectory in ('Family Counseling', 'Licensed Clinical Social Worker',
																   'Licensed Marriage and Family Therapy', 'Psychiatry', 'Psychiatry (Child and Adolescent)',
																   'Psychology', 'Qualified Autism Service Provider'))
								and not exists ( select 1
													from #Providers
													where PP.PPI_Id = #Providers.NetDevProvId )
								and not exists ( select 1
													from #Providers
													where LN.CLNS_DiamondId = #Providers.DiamProvId )			----Specialist n BH
				end
----------------------------------------------------------------------------------------------------------------------------------


				begin			--Merge VSN
					insert into #Providers			--VSN
						select distinct isnull(LN.CLNS_DiamondId, '') as ProviderId
							   ,PP.PPI_FirstName + ' ' + isnull(PP.PPI_MiddleName, '') as FirstName
							   ,case when (
										   PP.PPI_FirstName is null
										   or PP.PPI_FirstName = ''
										  )
										  and (
											   PP.PPI_LastName is not null
											   or PP.PPI_LastName <> ''
											  ) then null
									 else PP.PPI_LastName
								end as LastName
							   ,PG.PPG_Gender as Gender
							   ,case when (
										   PP.PPI_FirstName is null
										   and PP.PPI_LastName <> ''
										  ) then PP.PPI_LastName
									 else 'N/A'
								end as OrganizationName
							   ,PP.PPI_License as License
							   ,PP.PPI_UPIN as NPI
							   ,PPY_Diamond as ProviderType
							   ,PP.PPI_Id as NetDevProvId
							   ,Case  when CCi.CCI_contractType in (10,12) Then 1
							    WHEN PP.PPI_ProviderStatus = 7	  THEN 1 
								 ELSE 0 end as IsInternalOnly
								 ,1 AS IsEnabled
								 ,dblv.DBLV_Value AS MemberShipStatus
								 ,PP.PPI_PreferredFirstName AS PreferredFirstName
							from Network_Development.dbo.Tbl_Provider_ProviderInfo as PP with (nolock)
								inner join Network_Development.dbo.Tbl_Provider_ProviderType as PT with (nolock)
									on PT.PPY_Id = PP.PPI_Type
								left join Network_Development.dbo.tbl_Contract_CPL as CPL with (nolock) on CPl.CCPL_ProviderID = PP.PPI_Id
								left join Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock) on CCI.CCI_ID = cpl.CCPL_ContractID
								left join Network_Development.dbo.Tbl_Provider_ProviderGender as PG with (nolock)
									on PG.PPG_Id = PP.PPI_Gender
								left join @Prov as LN
									on LN.CLNS_ProviderId = PP.PPI_Id
								LEFT JOIN Network_Development.dbo.Tbl_Database_ListValues AS  dblv WITH (nolock) ON DBLV_List = 125 AND DBLV_ID = pp.PPI_MembershipStatus
							where PP.PPI_Type in ('15', '16') and  (CCI.CCI_TermDate is null or (CCI.CCI_TermDate >getdate()) and CPL.CCPL_TermDate is null or CPL.CCPL_TermDate > GETDATE())
								and not exists ( select 1
													from #Providers
													where LN.CLNS_DiamondId = #Providers.DiamProvId )
								and not exists ( select 1
													from #Providers
													where PP.PPI_Id = #Providers.NetDevProvId )
				END
             --   end


--Remove dups

if object_id('tempdb..#distinctProviders') is not null
				drop table #distinctProviders

/****************************************************************************************/
--Create temp table #distinctAddresses to get all the unique records
SELECT * INTO #distinctProviders FROM #Providers WHERE 1 = 0	 

/****************************************************************************************/

	INSERT INTO #distinctProviders
			Select Distinct 
			  [DiamProvID]
			 ,[FirstName]
			 ,[LastName]
			 ,[Gender]
			 ,[OrganizationName]
			 ,[License]
			 ,[NPI]
			 ,[ProviderType]
			 ,[NetDevProvID]
			 ,[IsInternalOnly]
			 ,[IsEnabled]
			 ,[MembershipStatus]
			 ,[PreferredFirstName]
			 from (  select *
				   ,row_number() over (partition BY a.DiamProvId, a.NetDevProvId, a.ProviderType order by a.NetDevProvId ) as ranking						
				from #Providers as a with (nolock)
				) T where T.ranking = 1


/*******************************************************************************************************************************************/


	--Get missing Diamond ids for pcp from diamond
	UPDATE P
	SET P.DiamprovId = PAPROVID
	FROM  #distinctProviders P
	JOIN Diam_725_App.diamond.jprovfm0_dat F WITH (nolock) ON  P.NetDevProvID = F.PANDPROVID
	WHERE p.ProviderType = 'PCP' AND (p.DiamProvID IS NULL OR p.DiamProvID = '')


			 
/************************************MAKE PROVIDERS INTERNAL ONLY**************************************************************************/

		-- Set IsInernalOnly to true, if provider has HBP (Hospital Based Provider) set to true.
		Update P
		set IsInternalOnly = 1
		from #distinctProviders P
		JOIN Network_Development.dbo.Tbl_Provider_ProviderInfo PPI
		ON P.NetDevProvId = PPI.PPI_ID
		where PPI.PPI_HBP = 1

		--Set isInternalOnly to true, if provider is suppressed or have restriction
		Update P
		Set P.IsinternalOnly = Case when PPI.PPI_RosterSuppression in (3) Then 1 else p.IsInternalOnly end
								from #distinctProviders P 
								Join Network_Development.dbo.tbl_provider_providerinfo ppi with (nolock) on ppi.ppi_id = p.netdevprovid

		--Set isInternalOnly to true, if provider is not accepting any patients
		Update P
		Set P.IsinternalOnly = Case when PPI.PPI_MembershipStatus in (5) Then 1 else p.IsInternalOnly end
								from #distinctProviders P 
								Join Network_Development.dbo.tbl_provider_providerinfo ppi with (nolock) on ppi.ppi_id = p.netdevprovid


/***************************************ENABLE / DISABLE PROVIDER RECORDS*******************************************************************/		

		--Set IsEnabled = 0 if provider is enabled and not returned in above select statements from source
		UPDATE D
		SET D.IsEnabled = 0
		FROM    #distinctProviders DL
				
					RIGHT JOIN search.Provider D ON ( D.DiamProvID = DL.DiamProvId)
                                                              AND ( ISNULL(D.ProviderType,'') = ISNULL(DL.ProviderType,''))
															  AND ( ISNULL(D.NetDevProvID,'') = ISNULL(DL.NetDevProvId,''))
                WHERE   DL.ProviderId IS NULL AND D.ProviderType <> 'UC'and ISNULL(D.IsEnabled,1) <> 0 ;

				--------------------------------------------------------------------------------
		--Set IsEnabled = 1 if provider is disabled and returned in above select statements from source
		UPDATE D
		SET D.IsEnabled = 1
		FROM    #distinctProviders DL
				
					INNER JOIN search.Provider D ON ( D.DiamProvID = DL.DiamProvId)
                                                              AND ( ISNULL(D.ProviderType,'') = ISNULL(DL.ProviderType,''))
															  AND ( ISNULL(D.NetDevProvID,'') = ISNULL(DL.NetDevProvId,''))
                WHERE   D.ProviderType <> 'UC'and ISNULL(D.IsEnabled,0) <> 1 ;
		        


/*******************************************UPDATE PROVIDER RECORD*****************************************************************************/	

	UPDATE P
	SET P.FirstName			=	(CASE WHEN P.FirstName <> PT.FirstName THEN Search.udf_TitleCase(PT.Firstname) ELSE P.FirstName END),
		P.LastName			=	(CASE WHEN P.LastName <> PT.LastName THEN Search.udf_TitleCase(PT.LastName) ELSE p.LastName END),
		P.License			=	(CASE WHEN P.License <> PT.License THEN PT.License ELSE p.License END),
		P.NPI				=	(CASE WHEN P.NPI <> PT.NPI THEN PT.NPI ELSE p.NPI END),
		P.Gender			=	(CASE WHEN P.Gender <> PT.Gender THEN Search.udf_TitleCase(PT.Gender) ELSE p.Gender END),
		P.OrganizationName	=	(CASE WHEN P.OrganizationName <> PT.OrganizationName THEN Search.udf_TitleCase(PT.OrganizationName) ELSE p.OrganizationName END),
		P.MemberShipStatus  =	(CASE WHEN ISNULL(P.MemberShipStatus,'') <> PT.MemberShipStatus THEN Search.udf_TitleCase(PT.MemberShipStatus) ELSE p.MemberShipStatus END),
		P.PreferredFirstName  =	(CASE WHEN ISNULL(P.PreferredFirstName,'') <> PT.PreferredFirstName THEN Search.udf_TitleCase(PT.PreferredFirstName) ELSE p.PreferredFirstName END),
		P.IsinternalOnly	=  (CASE WHEN P.IsinternalOnly <> PT.IsinternalOnly THEN PT.IsinternalOnly ELSE p.IsinternalOnly END)
	FROM #distinctProviders AS PT
	Inner JOIN search.Provider AS P ON P.DiamProvID = PT.DiamProvId AND ISNULL(P.NetDevProvID,'') = ISNULL(PT.NetDevProvId,'') AND P.ProviderType = PT.ProviderType


/**************************************** INSERT NEW PROVIDER RECORDS******************************************************************************/

	--Insert new Records which were never in the Target table
	INSERT INTO search.Provider
	SELECT DISTINCT
			S.DiamProvID,
			Search.udf_TitleCase(S.FirstName),
			Search.udf_TitleCase(S.LastName),
			Search.udf_TitleCase(S.Gender),
			Search.udf_TitleCase(S.Organizationname),
			S.License,
			S.NPI,
			S.ProviderType,
			S.NetDevProvID,
			S.IsInternalOnly,
			S.IsEnabled,
			Search.udf_TitleCase(S.MemberShipStatus),
			Search.udf_TitleCase(S.PreferredFirstName)

	FROM #distinctProviders S 
	LEFT JOIN search.Provider P ON P.NetDevProvID = S.NetDevProvId and   P.ProviderType = s.ProviderType
	WHERE	P.NetDevProvID IS null

/*******************************************************************************************************************************************/	
	--Update isINternal Flag for providers who are found in Excluded providers Table

		Update P
		set P.IsinternalOnly = Case when P.ProviderID = EP.ProviderID then 1
								else P.IsinternalOnly end
								from search.Provider p 
								join search.ExcludedProviders EP with (nolock) on p.ProviderID = EP.ProviderId

		

/*******************************************************************************************************************************************/	

				--Drop Temp tables
		if object_id('tempdb..#Providers') is not null
					drop table #Providers 

		if object_id('tempdb..#distinctProviders') is not null
					drop table #distinctProviders 
/*******************************************************************************************************************************************/	

	

			end
		end
	end
GO
/****** Object:  StoredProcedure [Import].[MergeAllProvSpecialty]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

------------
CREATE procedure [Import].[MergeAllProvSpecialty]
	@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
				10/03/2016	1.00 	SS		Added delete statements to delete child table data.
				11/15/2016	1.01	SS		Fixed bug (added condition to get specialty for PCPs)
		*/
		declare @now date = getdate()
		declare @Version varchar(100) = '10/03/2016 2:22 Version 1.00'
		declare @ReturnValues table
			(
			 ReturnCode int primary key
							not null
			,Reason varchar(200) not null
			)

		insert into @ReturnValues
				(ReturnCode, Reason)
			values (0, 'Normal Return')			
											
		if @Showversion = 1
			begin
				select object_schema_name(@@PROCId) as SchemaName
					   ,object_name(@@PROCId) as ProcedureName
					   ,@Version as VersionInformation
				if isnull(@ShowReturn, 0) = 0
					return 0
			end

		if @ShowReturn = 1
			begin
				select *
					from @ReturnValues
				return 0
			end

		set nocount on


		begin
			if object_id('tempdb..#ProvSpecialty') is not null
				drop table #ProvSpecialty

			create table #ProvSpecialty
				(
				 Id int identity(1, 1)
						not null
				,SpecialtyId int not null
				,ProviderId int not null
				,AffiliationId int null
				,BoardCertified bit not null,
				)


			insert into #ProvSpecialty			--ANC
				select distinct *
					from (
						  select distinct S.SpecialtyID
							   ,P.ProviderID
							   ,AF.AffiliationID
							   ,case when PPI.PPI_Specialty1Cert = 1 then 1
									 else 0
								end as BoardCertified
							from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
								inner join search.Provider as P with (nolock)
									on P.NetDevProvID = PPI.PPI_ID
								left join search.Affiliation as AF with (nolock)
									on AF.ProviderID = P.ProviderID
								inner join Network_Development.dbo.Tbl_Provider_ProviderSpecialties as PSP with (nolock)
									on PSP.PSP_ID = PPI.PPI_Specialty1
								inner join search.Specialty as S with (nolock)
									on S.SpecialtyCode = PSP.PSP_Code
							where (P.ProviderType in ('ANC', 'DANC'))
							 	and S.ServiceIdentifier = 1
								and (PPI.PPI_Specialty1 is not null)
								and (PPI.PPI_Specialty1CertNonDirect = 0)
						  union all
						  select distinct S.SpecialtyID
							   ,P.ProviderID
							   ,AF.AffiliationID
							   ,case when PPI.PPI_Specialty2Cert = 1 then 1
									 else 0
								end as BoardCertified
							from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
								inner join search.Provider as P with (nolock)
									on P.NetDevProvID = PPI.PPI_ID
								left join search.Affiliation as AF with (nolock)
									on AF.ProviderID = P.ProviderID
								inner join Network_Development.dbo.Tbl_Provider_ProviderSpecialties as PSP with (nolock)
									on PSP.PSP_ID = PPI.PPI_Specialty2
								inner join search.Specialty as S with (nolock)
									on S.SpecialtyCode = PSP.PSP_Code --and S.SpecialtyCode = PSP.PSP_Code
							where (P.ProviderType in ('ANC', 'DANC'))
								and S.ServiceIdentifier = 1
								and (PPI.PPI_Specialty2 is not null)
								and (PPI.PPI_Specialty2 <> PPI.PPI_Specialty1)
								and (PPI.PPI_Specialty2CertNonDirect = 0)
						  union all
						  select distinct S.SpecialtyID
							   ,P.ProviderID
							   ,AF.AffiliationID
							   ,case when PPI.PPI_Specialty3Cert = 1 then 1
									 else 0
								end as BoardCertified
							from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
								inner join search.Provider as P with (nolock)
									on P.NetDevProvID = PPI.PPI_ID
								left join search.Affiliation as AF with (nolock)
									on AF.ProviderID = P.ProviderID
								inner join Network_Development.dbo.Tbl_Provider_ProviderSpecialties as PSP with (nolock)
									on PSP.PSP_ID = PPI.PPI_Specialty3
								inner join search.Specialty as S with (nolock)
									on S.SpecialtyCode = PSP.PSP_Code --and S.SpecialtyCode = PSP.PSP_Code
							where (P.ProviderType in ('ANC', 'DANC'))
								and (PPI.PPI_Specialty3 is not null)
								and S.ServiceIdentifier = 1
								and (PPI.PPI_Specialty3 <> PPI.PPI_Specialty2)
								and (PPI.PPI_Specialty3 <> PPI.PPI_Specialty1)
								and (PPI.PPI_Specialty3CertNonDirect = 0)
						 ) as Specialty
				union
				select distinct S.SpecialtyID
					   ,P.ProviderID
					   ,AF.AffiliationID
					   ,0 as BoardCertified
					from Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock)
						left join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
							on CCPL_ContractID = CCI_ID
						inner join search.Provider as P with (nolock)
							on P.NetDevProvID = CCPL_ProviderID
						left join search.Affiliation as AF with (nolock)
							on AF.ProviderID = P.ProviderID
						inner join Network_Development.dbo.Tbl_Contract_ContractService as CCS with (nolock)
							on CCS.CSV_ContractedID = CCI_ID
						inner join Network_Development.dbo.Tbl_Provider_ProviderSpecialties as PSP with (nolock)
							on PSP.PSP_ID = CCS.CSV_Service
						inner join search.Specialty as S with (nolock)
							on S.SpecialtyCode = PSP.PSP_Code
					where (P.ProviderType in ('ANC', 'DANC'))

-------------------------------------------------------------

			insert into #ProvSpecialty			--HOSP
				select distinct *
					from (
						  select distinct S.SpecialtyID
							   ,P.ProviderID
							   ,AF.AffiliationID
							   ,case when PPI.PPI_Specialty1Cert = 1 then 1
									 else 0
								end as BoardCertified
							from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
								inner join search.Provider as P with (nolock)
									on P.NetDevProvID = PPI.PPI_ID
								left join search.Affiliation as AF with (nolock)
									on AF.ProviderID = P.ProviderID
								inner join Network_Development.dbo.Tbl_Provider_ProviderSpecialties as PSP with (nolock)
									on PSP.PSP_ID = PPI.PPI_Specialty1
								inner join search.Specialty as S with (nolock)
									on S.SpecialtyCode = PSP.PSP_Code --and S.SpecialtyCode = PSP.PSP_Code
							where (P.ProviderType = 'HOSP')
								and S.ServiceIdentifier = 1
								and (PPI.PPI_Specialty1 is not null)
								and (PPI.PPI_Specialty1CertNonDirect = 0)-- order by p.providerid
						  union all
						  select distinct S.SpecialtyID
							   ,P.ProviderID
							   ,AF.AffiliationID
							   ,case when PPI.PPI_Specialty2Cert = 1 then 1
									 else 0
								end as BoardCertified
							from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
								inner join search.Provider as P with (nolock)
									on P.NetDevProvID = PPI.PPI_ID
								left join search.Affiliation as AF with (nolock)
									on AF.ProviderID = P.ProviderID
								inner join Network_Development.dbo.Tbl_Provider_ProviderSpecialties as PSP with (nolock)
									on PSP.PSP_ID = PPI.PPI_Specialty2
								inner join search.Specialty as S with (nolock)
									on S.SpecialtyCode = PSP.PSP_Code --and S.SpecialtyCode = PSP.PSP_Code
							where (P.ProviderType = 'HOSP')
								and S.ServiceIdentifier = 1
								and (PPI.PPI_Specialty2 is not null)
								and (PPI.PPI_Specialty2 <> PPI.PPI_Specialty1)
								and (PPI.PPI_Specialty2CertNonDirect = 0) --order by p.providerid
						  union all
						  select distinct S.SpecialtyID
							   ,P.ProviderID
							   ,AF.AffiliationID
							   ,case when PPI.PPI_Specialty3Cert = 1 then 1
									 else 0
								end as BoardCertified
							from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
								inner join search.Provider as P with (nolock)
									on P.NetDevProvID = PPI.PPI_ID
								left join search.Affiliation as AF with (nolock)
									on AF.ProviderID = P.ProviderID
								inner join Network_Development.dbo.Tbl_Provider_ProviderSpecialties as PSP with (nolock)
									on PSP.PSP_ID = PPI.PPI_Specialty3
								inner join search.Specialty as S with (nolock)
									on S.SpecialtyCode = PSP.PSP_Code --and S.SpecialtyCode = PSP.PSP_Code
							where (P.ProviderType = 'HOSP')
								and S.ServiceIdentifier = 1
								and (PPI.PPI_Specialty3 is not null)
								and (PPI.PPI_Specialty3 <> PPI.PPI_Specialty2)
								and (PPI.PPI_Specialty3 <> PPI.PPI_Specialty1)
								and (PPI.PPI_Specialty3CertNonDirect = 0) --order by p.providerid
						 ) as SPECIALTY
				union
				select distinct S.SpecialtyID
					   ,P.ProviderID
					   ,AF.AffiliationID
					   ,0 as BoardCertified
					from Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock)
						left join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
							on CCPL_ContractID = CCI_ID
						inner join search.Provider as P with (nolock)
							on P.NetDevProvID = CCPL_ProviderID
						left join search.Affiliation as AF with (nolock)
							on AF.ProviderID = P.ProviderID
						inner join Network_Development.dbo.Tbl_Contract_ContractService as CCS with (nolock)
							on CCS.CSV_ContractedID = CCI_ID
						inner join Network_Development.dbo.Tbl_Provider_ProviderSpecialties as PSP with (nolock)
							on PSP.PSP_ID = CCS.CSV_Service
						inner join search.Specialty as S with (nolock)
							on S.SpecialtyCode = PSP.PSP_Code
					where (P.ProviderType in ('HOSP')) 
		--------------------------------------------------------------------------------

			insert into #ProvSpecialty			--IPA
				select distinct *
					from (
						  select distinct S.SpecialtyID
							   ,P.ProviderID
							   ,AF.AffiliationID
							   ,case when PPI.PPI_Specialty1Cert = 1 then 1
									 else 0
								end as BoardCertified
							from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
								inner join search.Provider as P with (nolock)
									on P.NetDevProvID = PPI.PPI_ID
								left join search.Affiliation as AF with (nolock)
									on AF.ProviderID = P.ProviderID
								inner join Network_Development.dbo.Tbl_Provider_ProviderSpecialties as PSP with (nolock)
									on PSP.PSP_ID = PPI.PPI_Specialty1
								inner join search.Specialty as S with (nolock)
									on S.SpecialtyCode = PSP.PSP_Code --and S.SpecialtyCode = PSP.PSP_Code
							where (P.ProviderType in ('IPA'))
								and S.ServiceIdentifier = 1
								and (PPI.PPI_Specialty1 is not null)
								and (PPI.PPI_Specialty1CertNonDirect = 0)-- order by p.providerid
						  union all
						  select distinct S.SpecialtyID
							   ,P.ProviderID
							   ,AF.AffiliationID
							   ,case when PPI.PPI_Specialty2Cert = 1 then 1
									 else 0
								end as BoardCertified
							from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
								inner join search.Provider as P with (nolock)
									on P.NetDevProvID = PPI.PPI_ID
								left join search.Affiliation as AF with (nolock)
									on AF.ProviderID = P.ProviderID
								inner join Network_Development.dbo.Tbl_Provider_ProviderSpecialties as PSP with (nolock)
									on PSP.PSP_ID = PPI.PPI_Specialty2
								inner join search.Specialty as S with (nolock)
									on S.SpecialtyCode = PSP.PSP_Code --and S.SpecialtyCode = PSP.PSP_Code
							where (P.ProviderType in ('IPA'))
								and S.ServiceIdentifier = 1
								and (PPI.PPI_Specialty2 is not null)
								and (PPI.PPI_Specialty2 <> PPI.PPI_Specialty1)
								and (PPI.PPI_Specialty2CertNonDirect = 0)--order by p.providerid
						  union all
						  select distinct S.SpecialtyID
							   ,P.ProviderID
							   ,AF.AffiliationID
							   ,case when PPI.PPI_Specialty3Cert = 1 then 1
									 else 0
								end as BoardCertified
							from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
								inner join search.Provider as P with (nolock)
									on P.NetDevProvID = PPI.PPI_ID
								left join search.Affiliation as AF with (nolock)
									on AF.ProviderID = P.ProviderID
								inner join Network_Development.dbo.Tbl_Provider_ProviderSpecialties as PSP with (nolock)
									on PSP.PSP_ID = PPI.PPI_Specialty3
								inner join search.Specialty as S with (nolock)
									on S.SpecialtyCode = PSP.PSP_Code --and S.SpecialtyCode = PSP.PSP_Code
							where (P.ProviderType in ('IPA'))
								and S.ServiceIdentifier = 1
								and (PPI.PPI_Specialty3 is not null)
								and (PPI.PPI_Specialty3 <> PPI.PPI_Specialty2)
								and (PPI.PPI_Specialty3 <> PPI.PPI_Specialty1)
								and (PPI.PPI_Specialty3CertNonDirect = 0) --order by p.providerid
						 ) as SPECIALTY
				union
				select distinct S.SpecialtyID
					   ,P.ProviderID
					   ,AF.AffiliationID
					   ,0 as BoardCertified
					from Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock)
						left join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
							on CCPL_ContractID = CCI_ID
						inner join search.Provider as P with (nolock)
							on P.NetDevProvID = CCPL_ProviderID
						left join search.Affiliation as AF with (nolock)
							on AF.ProviderID = P.ProviderID
						inner join Network_Development.dbo.Tbl_Contract_ContractService as CCS with (nolock)
							on CCS.CSV_ContractedID = CCI_ID
						inner join Network_Development.dbo.Tbl_Provider_ProviderSpecialties as PSP with (nolock)
							on PSP.PSP_ID = CCS.CSV_Service
						inner join search.Specialty as S with (nolock)
							on S.SpecialtyCode = PSP.PSP_Code
					where (P.ProviderType in ('IPA'))

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

			insert into #ProvSpecialty			--NPP
				select distinct *
					from (
						  select distinct S.SpecialtyID
							   ,P.ProviderID
							   ,AF.AffiliationID
							   ,case when PPI.PPI_Specialty1Cert = 1 then 1
									 else 0
								end as BoardCertified
							from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
								inner join search.Provider as P with (nolock)
									on P.NetDevProvID = PPI.PPI_ID
								left join search.Affiliation as AF with (nolock)
									on AF.ProviderID = P.ProviderID
								inner join Network_Development.dbo.Tbl_Provider_ProviderSpecialties as PSP with (nolock)
									on PSP.PSP_ID = PPI.PPI_Specialty1
								inner join search.Specialty as S with (nolock)
									on S.SpecialtyCode = PSP.PSP_Code --and S.SpecialtyCode = PSP.PSP_Code
							where (P.ProviderType = 'NPP')
								and S.ServiceIdentifier = 1
								and (PPI.PPI_Specialty1 is not null)
								and (PPI.PPI_Specialty1CertNonDirect = 0)-- order by p.providerid
						  union all
						  select distinct S.SpecialtyID
							   ,P.ProviderID
							   ,AF.AffiliationID
							   ,case when PPI.PPI_Specialty2Cert = 1 then 1
									 else 0
								end as BoardCertified
							from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
								inner join search.Provider as P with (nolock)
									on P.NetDevProvID = PPI.PPI_ID
								left join search.Affiliation as AF with (nolock)
									on AF.ProviderID = P.ProviderID
								inner join Network_Development.dbo.Tbl_Provider_ProviderSpecialties as PSP with (nolock)
									on PSP.PSP_ID = PPI.PPI_Specialty2
								inner join search.Specialty as S with (nolock)
									on S.SpecialtyCode = PSP.PSP_Code --and S.SpecialtyCode = PSP.PSP_Code
							where (P.ProviderType = 'NPP')
								and S.ServiceIdentifier = 1
								and (PPI.PPI_Specialty2 is not null)
								and (PPI.PPI_Specialty2 <> PPI.PPI_Specialty1)
								and (PPI.PPI_Specialty2CertNonDirect = 0) --order by p.providerid
						  union all
						  select distinct S.SpecialtyID
							   ,P.ProviderID
							   ,AF.AffiliationID
							   ,case when PPI.PPI_Specialty3Cert = 1 then 1
									 else 0
								end as BoardCertified
							from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
								inner join search.Provider as P with (nolock)
									on P.NetDevProvID = PPI.PPI_ID
								left join search.Affiliation as AF with (nolock)
									on AF.ProviderID = P.ProviderID
								inner join Network_Development.dbo.Tbl_Provider_ProviderSpecialties as PSP with (nolock)
									on PSP.PSP_ID = PPI.PPI_Specialty3
								inner join search.Specialty as S with (nolock)
									on S.SpecialtyCode = PSP.PSP_Code --and S.SpecialtyCode = PSP.PSP_Code
							where (P.ProviderType = 'NPP')
								and S.ServiceIdentifier = 1
								and (PPI.PPI_Specialty3 is not null)
								and (PPI.PPI_Specialty3 <> PPI.PPI_Specialty2)
								and (PPI.PPI_Specialty3 <> PPI.PPI_Specialty1)
								and (PPI.PPI_Specialty3CertNonDirect = 0) --order by p.providerid
						 ) as SPECIALTY
						


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			--LTSS n SNF
			--SNF
			insert into #ProvSpecialty
				select distinct *
					from (
						  select distinct S.SpecialtyID
							   ,P.ProviderID
							   ,AF.AffiliationID
							   ,case when PPI.PPI_Specialty1Cert = 1 then 1
									 else 0
								end as BoardCertified
							from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
								inner join search.Provider as P with (nolock)
									on P.NetDevProvID = PPI.PPI_ID
								left join search.Affiliation as AF with (nolock)
									on AF.ProviderID = P.ProviderID
								inner join Network_Development.dbo.Tbl_Provider_ProviderSpecialties as PSP with (nolock)
									on PSP.PSP_ID = PPI.PPI_Specialty1
								inner join search.Specialty as S with (nolock)
									on S.SpecialtyCode = PSP.PSP_Code --and S.SpecialtyCode = PSP.PSP_Code
							where (P.ProviderType = 'SNF')
								and S.ServiceIdentifier = 1
								and (PPI.PPI_Specialty1 is not null)
								and (PPI.PPI_Specialty1CertNonDirect = 0)-- order by p.providerid
						 ) as SPECIALTY
				union
				select distinct S.SpecialtyID
					   ,P.ProviderID
					   ,AF.AffiliationID
					   ,0 as BoardCertified
					from Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock)
						left join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
							on CCPL_ContractID = CCI_ID
						inner join search.Provider as P with (nolock)
							on P.NetDevProvID = CCPL_ProviderID
						left join search.Affiliation as AF with (nolock)
							on AF.ProviderID = P.ProviderID
						inner join Network_Development.dbo.Tbl_Contract_ContractService as CCS with (nolock)
							on CCS.CSV_ContractedID = CCI_ID
						inner join Network_Development.dbo.Tbl_Provider_ProviderSpecialties as PSP with (nolock)
							on PSP.PSP_ID = CCS.CSV_Service
						inner join search.Specialty as S with (nolock)
							on S.SpecialtyCode = PSP.PSP_Code
					where (P.ProviderType in ('SNF'))



						--LTSS
			insert into #ProvSpecialty
				select distinct *
					from (
						  select distinct S.SpecialtyID
							   ,P.ProviderID
							   ,AF.AffiliationID
							   ,case when PPI.PPI_Specialty1Cert = 1 then 1
									 else 0
								end as BoardCertified
							from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
								inner join search.Provider as P with (nolock)
									on P.NetDevProvID = PPI.PPI_ID
								left join search.Affiliation as AF with (nolock)
									on AF.ProviderID = P.ProviderID
								inner join Network_Development.dbo.Tbl_Provider_ProviderSpecialties as PSP with (nolock)
									on PSP.PSP_ID = PPI.PPI_Specialty1
								inner join search.Specialty as S with (nolock)
									on S.SpecialtyCode = PSP.PSP_Code --and S.SpecialtyCode = PSP.PSP_Code
							where (P.ProviderType = 'LTSS')
								and S.ServiceIdentifier = 1
								and (PPI.PPI_Specialty1 is not null)
								and (PPI.PPI_Specialty1CertNonDirect = 0)-- order by p.providerid
						 ) as SPECIALTY
				union
				select distinct S.SpecialtyID
					   ,P.ProviderID
					   ,AF.AffiliationID
					   ,0 as BoardCertified 
					from Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock)
						left join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
							on CCPL_ContractID = CCI_ID
						inner join search.Provider as P with (nolock)
							on P.NetDevProvID = CCPL_ProviderID
						left join search.Affiliation as AF with (nolock)
							on AF.ProviderID = P.ProviderID
						inner join Network_Development.dbo.Tbl_Contract_ContractService as CCS with (nolock)
							on CCS.CSV_ContractedID = CCI_ID
						inner join Network_Development.dbo.Tbl_Provider_ProviderSpecialties as PSP with (nolock)
							on PSP.PSP_ID = CCS.CSV_Service
						inner join search.Specialty as S with (nolock)
							on S.SpecialtyCode = PSP.PSP_Code
					where (P.ProviderType in ('LTSS'))




----------------------------------------------------------------------------
			insert into #ProvSpecialty			--PCP
				select distinct S.SpecialtyID
					   ,P.ProviderID
					   ,AF.AffiliationID
					   ,case when PPI.PPI_Specialty1Cert = 1 then 1
							 else 0
						end as BoardCertified
					from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
						inner join search.Provider as P with (nolock)
							on P.NetDevProvID = PPI.PPI_ID
						left join search.Affiliation as AF with (nolock)
							on AF.ProviderID = P.ProviderID
						inner join Network_Development.dbo.Tbl_Provider_ProviderSpecialties as PSP with (nolock)
							on PSP.PSP_ID = PPI.PPI_Specialty1
						inner join search.Specialty as S with (nolock)
							on S.SpecialtyCode = PSP.PSP_Code --and S.SpecialtyCode = PSP.PSP_Code
					where (P.ProviderType in ('PCP', 'NPCP', 'TPCP','MPCP'))
						and S.ServiceIdentifier = 1
						and (PPI.PPI_Specialty1 is not null)
						and (PPI.PPI_Specialty1CertNonDirect = 0)-- order by p.providerid
				union all
				select distinct S.SpecialtyID
					   ,P.ProviderID
					   ,AF.AffiliationID
					   ,case when PPI.PPI_Specialty2Cert = 1 then 1
							 else 0
						end as BoardCertified
					from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
						inner join search.Provider as P with (nolock)
							on P.NetDevProvID = PPI.PPI_ID
						left join search.Affiliation as AF with (nolock)
							on AF.ProviderID = P.ProviderID
						inner join Network_Development.dbo.Tbl_Provider_ProviderSpecialties as PSP with (nolock)
							on PSP.PSP_ID = PPI.PPI_Specialty2
						inner join search.Specialty as S with (nolock)
							on S.SpecialtyCode = PSP.PSP_Code --and S.SpecialtyCode = PSP.PSP_Code
				where (P.ProviderType in ('PCP', 'NPCP', 'TPCP','MPCP'))
						and S.ServiceIdentifier = 1
						and (PPI.PPI_Specialty2 is not null)
						and (PPI.PPI_Specialty2 <> PPI.PPI_Specialty1)
						and (PPI.PPI_Specialty2CertNonDirect = 0)--order by p.providerid
				union all
				select distinct S.SpecialtyID
					   ,P.ProviderID
					   ,AF.AffiliationID
					   ,case when PPI.PPI_Specialty3Cert = 1 then 1
							 else 0
						end as BoardCertified
					from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
						inner join search.Provider as P with (nolock)
							on P.NetDevProvID = PPI.PPI_ID
						left join search.Affiliation as AF with (nolock)
							on AF.ProviderID = P.ProviderID
						inner join Network_Development.dbo.Tbl_Provider_ProviderSpecialties as PSP with (nolock)
							on PSP.PSP_ID = PPI.PPI_Specialty3
						inner join search.Specialty as S with (nolock)
							on S.SpecialtyCode = PSP.PSP_Code --and S.SpecialtyCode = PSP.PSP_Code
				where (P.ProviderType in ('PCP', 'NPCP', 'TPCP','MPCP'))
						and S.ServiceIdentifier = 1
						and (PPI.PPI_Specialty3 is not null)
						and (PPI.PPI_Specialty3 <> PPI.PPI_Specialty2)
						and (PPI.PPI_Specialty3 <> PPI.PPI_Specialty1)
						and (PPI.PPI_Specialty3CertNonDirect = 0)
					order by P.ProviderID
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

			insert into #ProvSpecialty			--SPEC n Behav	
				select distinct S.SpecialtyID
					   ,P.ProviderID
					   ,AF.AffiliationID
					   ,case when PPI.PPI_Specialty1Cert = 1 then 1
							 else 0
						end as BoardCertified
					from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
						inner join search.Provider as P with (nolock)
							on P.NetDevProvID = PPI.PPI_ID
						left join search.Affiliation as AF with (nolock)
							on AF.ProviderID = P.ProviderID
						inner join Network_Development.dbo.Tbl_Provider_ProviderSpecialties as PSP with (nolock)
							on PSP.PSP_ID = PPI.PPI_Specialty1
						inner join search.Specialty as S with (nolock)
							on S.SpecialtyCode = PSP.PSP_Code --and S.SpecialtyCode = PSP.PSP_Code
					where (P.ProviderType in ('SPEC', 'PCP/SPEC', 'BH'))
						and S.ServiceIdentifier = 1
						and (PPI.PPI_Specialty1 is not null)
						and (PPI.PPI_Specialty1CertNonDirect = 0)-- order by p.providerid
				union all
				select distinct S.SpecialtyID
					   ,P.ProviderID
					   ,AF.AffiliationID
					   ,case when PPI.PPI_Specialty2Cert = 1 then 1
							 else 0
						end as BoardCertified
					from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
						inner join search.Provider as P with (nolock)
							on P.NetDevProvID = PPI.PPI_ID
						left join search.Affiliation as AF with (nolock)
							on AF.ProviderID = P.ProviderID
						inner join Network_Development.dbo.Tbl_Provider_ProviderSpecialties as PSP with (nolock)
							on PSP.PSP_ID = PPI.PPI_Specialty2
						inner join search.Specialty as S with (nolock)
							on S.SpecialtyCode = PSP.PSP_Code --and S.SpecialtyCode = PSP.PSP_Code
					where (P.ProviderType in ('SPEC', 'PCP/SPEC', 'BH'))
						and S.ServiceIdentifier = 1
						and (PPI.PPI_Specialty2 is not null)
						and (PPI.PPI_Specialty2 <> PPI.PPI_Specialty1)
						and (PPI.PPI_Specialty2CertNonDirect = 0)--order by p.providerid
				union all
				select distinct S.SpecialtyID
					   ,P.ProviderID
					   ,AF.AffiliationID
					   ,case when PPI.PPI_Specialty3Cert = 1 then 1
							 else 0
						end as BoardCertified
					from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
						inner join search.Provider as P with (nolock)
							on P.NetDevProvID = PPI.PPI_ID
						left join search.Affiliation as AF with (nolock)
							on AF.ProviderID = P.ProviderID
						inner join Network_Development.dbo.Tbl_Provider_ProviderSpecialties as PSP with (nolock)
							on PSP.PSP_ID = PPI.PPI_Specialty3
						inner join search.Specialty as S with (nolock)
							on S.SpecialtyCode = PSP.PSP_Code --and S.SpecialtyCode = PSP.PSP_Code
					where (P.ProviderType in ('SPEC', 'PCP/SPEC', 'BH'))
						and S.ServiceIdentifier = 1
						and (PPI.PPI_Specialty3 is not null)
						and (PPI.PPI_Specialty3 <> PPI.PPI_Specialty2)
						and (PPI.PPI_Specialty3 <> PPI.PPI_Specialty1)
						and (PPI.PPI_Specialty3CertNonDirect = 0)
					order by P.ProviderID
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

			if object_id('tempdb..#allVisionSpec') is not null
				drop table #allVisionSpec
			select distinct *
				into #allVisionSpec
				from (
					  select distinct case when (
												 P.ProviderID in (select distinct ProviderID
																	from search.ProviderExtendedProperties with (nolock)
																	where PropertyName = 'EyeExamOnly'
																		and PropertyValue = 'Yes')
												 and S.SpecialtyDesc = 'Optometry (Exam Only)'
												) then null
										   else S.SpecialtyID
									  end as SpecialtyId
						   ,P.ProviderID
						   ,AF.AffiliationID
						   ,case when PPI.PPI_Specialty1Cert = 1 then 1
								 else 0
							end as BoardCertified
						from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
							inner join search.Provider as P with (nolock)
								on P.NetDevProvID = PPI.PPI_ID
							left join search.Affiliation as AF with (nolock)
								on AF.ProviderID = P.ProviderID
							inner join Network_Development.dbo.Tbl_Provider_ProviderSpecialties as PSP with (nolock)
								on PSP.PSP_ID = PPI.PPI_Specialty1
							inner join search.Specialty as S with (nolock)
								on S.SpecialtyCode = PSP.PSP_Code --and S.SpecialtyCode = PSP.PSP_Code
						where (P.ProviderType = 'VSN')
							and S.ServiceIdentifier = 1
							and (PPI.PPI_Specialty1 is not null)
							and (PPI.PPI_Specialty1CertNonDirect = 0)-- order by p.providerid
					  union all
					  select distinct case when (
												 P.ProviderID in (select distinct ProviderID
																	from search.ProviderExtendedProperties with (nolock)
																	where PropertyName = 'EyeExamOnly'
																		and PropertyValue = 'Yes')
												 and S.SpecialtyDesc = 'Optometry (Exam Only)'
												) then null
										   else S.SpecialtyID
									  end as SpecialtyId
						   ,P.ProviderID
						   ,AF.AffiliationID
						   ,case when PPI.PPI_Specialty2Cert = 1 then 1
								 else 0
							end as BoardCertified
						from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
							inner join search.Provider as P with (nolock)
								on P.NetDevProvID = PPI.PPI_ID
							left join search.Affiliation as AF with (nolock)
								on AF.ProviderID = P.ProviderID
							inner join Network_Development.dbo.Tbl_Provider_ProviderSpecialties as PSP with (nolock)
								on PSP.PSP_ID = PPI.PPI_Specialty2
							inner join search.Specialty as S with (nolock)
								on S.SpecialtyCode = PSP.PSP_Code --and S.SpecialtyCode = PSP.PSP_Code
						where (P.ProviderType = 'VSN')
							and S.ServiceIdentifier = 1
							and (PPI.PPI_Specialty2 is not null)
							and (PPI.PPI_Specialty2 <> PPI.PPI_Specialty1)
							and (PPI.PPI_Specialty2CertNonDirect = 0)
					  union all
					  select distinct case when (
												 P.ProviderID in (select distinct ProviderID
																	from search.ProviderExtendedProperties
																	where PropertyName = 'EyeExamOnly'
																		and PropertyValue = 'Yes')
												 and S.SpecialtyDesc = 'Optometry (Exam Only)'
												) then null
										   else S.SpecialtyID
									  end as SpecialtyId
						   ,P.ProviderID
						   ,AF.AffiliationID
						   ,case when PPI.PPI_Specialty3Cert = 1 then 1
								 else 0
							end as BoardCertified
						from Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
							inner join search.Provider as P with (nolock)
								on P.NetDevProvID = PPI.PPI_ID
							left join search.Affiliation as AF with (nolock)
								on AF.ProviderID = P.ProviderID
							inner join Network_Development.dbo.Tbl_Provider_ProviderSpecialties as PSP with (nolock)
								on PSP.PSP_ID = PPI.PPI_Specialty3
							inner join search.Specialty as S with (nolock)
								on S.SpecialtyCode = PSP.PSP_Code --and S.SpecialtyCode = PSP.PSP_Code
						where (P.ProviderType = 'VSN')
							and S.ServiceIdentifier = 1
							and (PPI.PPI_Specialty3 is not null)
							and (PPI.PPI_Specialty3 <> PPI.PPI_Specialty2)
							and (PPI.PPI_Specialty3 <> PPI.PPI_Specialty1)
							and (PPI.PPI_Specialty3CertNonDirect = 0) --order by p.providerid
					 ) A
				where SpecialtyId is not null
	
			insert into #ProvSpecialty
				select *
					from #allVisionSpec
					where SpecialtyId is not null				
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Disable
		
		UPDATE PS
		SET PS.IsEnabled = 0
		FROM #ProvSpecialty T 
		RIGHT JOIN search.ProviderSpecialty PS ON (coalesce(PS.SpecialtyID, '') = coalesce(T.SpecialtyId, ''))
											  AND (coalesce(PS.ProviderID, '') = coalesce(T.ProviderId, ''))
											  AND (coalesce(Ps.AffiliationID, '') = coalesce(T.AffiliationId, ''))
		WHERE (T.SpecialtyId IS NULL OR T.ProviderId IS NULL) AND ISNULL(PS.isEnabled,1) <> 0


--Enable
		UPDATE PS
		SET PS.IsEnabled = 1
		FROM #ProvSpecialty T 
		INNER JOIN search.ProviderSpecialty PS ON (coalesce(PS.SpecialtyID, '') = coalesce(T.SpecialtyId, ''))
											  AND (coalesce(PS.ProviderID, '') = coalesce(T.ProviderId, ''))
											  AND (coalesce(Ps.AffiliationID, '') = coalesce(T.AffiliationId, ''))
		WHERE ISNULL(PS.isEnabled,0) <> 1

--Update

		UPDATE PS
		SET PS.BoardCertified = T.BoardCertified
		FROM #ProvSpecialty T 
		INNER JOIN search.ProviderSpecialty PS ON (coalesce(PS.SpecialtyID, '') = coalesce(T.SpecialtyId, ''))
											  AND (coalesce(PS.ProviderID, '') = coalesce(T.ProviderId, ''))
											  AND (coalesce(Ps.AffiliationID, '') = coalesce(T.AffiliationId, ''))
	
--Insert
		
		INSERT INTO search.ProviderSpecialty
		SELECT T.SpecialtyID
				,T.ProviderId
			   ,T.AffiliationID
			   ,T.BoardCertified
			   ,1
		FROM #ProvSpecialty  T
		LEFT JOIN search.ProviderSpecialty ps On (coalesce(PS.SpecialtyID, '') = coalesce(T.SpecialtyId, ''))
											  AND (coalesce(PS.ProviderID, '') = coalesce(T.ProviderId, ''))
											  AND (coalesce(Ps.AffiliationID, '') = coalesce(T.AffiliationId, ''))
		WHERE ps.ProviderID IS NULL AND ps.SpecialtyID IS NULL AND ps.AffiliationID IS null



/********************************************************************************************/
		if object_id('tempdb..#ProvSpecialty') is not null
				drop table #ProvSpecialty


	if object_id('tempdb..#allVisionSpec') is not null
				drop table #allVisionSpec

/********************************************************************************************/

		end
	end

--SELECT * from #ProvSpecialty



GO
/****** Object:  StoredProcedure [Import].[MergeBusInfo]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


------------
CREATE PROCEDURE [Import].[MergeBusInfo]
@Showversion BIT = 0
   ,@ShowReturn BIT = 0
AS
	BEGIN
		/*
			Modification Log:
				5/12/2017		SS		Created procedure to get bus info data into provider search schema
		*/
		
		declare @now date = getdate()
		declare @Version varchar(100) = '10/03/2016 2:22 Version 1.00'
		DECLARE @ReturnValues TABLE
			(
			 ReturnCode INT PRIMARY KEY
							NOT NULL
			,Reason VARCHAR(200) NOT NULL
			)

		INSERT INTO @ReturnValues
				(ReturnCode, Reason)
			VALUES (0, 'Normal Return')			
											
		IF @Showversion = 1
			BEGIN
				SELECT OBJECT_SCHEMA_NAME(@@PROCId) AS SchemaName
					   ,OBJECT_NAME(@@PROCId) AS ProcedureName
					   ,@Version AS VersionInformation
				IF ISNULL(@ShowReturn, 0) = 0
					RETURN 0
			END

		IF @ShowReturn = 1
			BEGIN
				SELECT *
					FROM @ReturnValues
				RETURN 0
			END

		SET NOCOUNT ON

		BEGIN		

		
INSERT INTO search.businfo
SELECT       DISTINCT 
	   [PDBR_CompanyStopId]		
      ,[PDBR_BusAgency]			
      ,[PDBR_RouteShortName]	
      ,[PDBR_RouteLongName]		
      ,[PDBR_StopID]			
      ,[PDBR_StopName]			
      ,[PDBR_StopArea]			
      ,[PDBR_Direction]			FROM 

Network_Development.DBO.Tbl_ProviderDirectory_BusStop_Routes WITH (NOLOCK)
WHERE NOT exists (select 1 from search.businfo with (nolock))


END
END
GO
/****** Object:  StoredProcedure [Import].[MergeSpecialty]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

------------
CREATE Procedure [Import].[MergeSpecialty]
@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
				10/03/2016		SS		Added delete statements to delete child table data.
		*/
		declare @now date = getdate()
		declare @Version varchar(100) = '10/03/2016 2:22 Version 1.00'
		declare @ReturnValues table
			(
			 ReturnCode int primary key
							not null
			,Reason varchar(200) not null
			)

		insert into @ReturnValues
				(ReturnCode, Reason)
			values (0, 'Normal Return')			
											
		if @Showversion = 1
			begin
				select object_schema_name(@@PROCId) as SchemaName
					   ,object_name(@@PROCId) as ProcedureName
					   ,@Version as VersionInformation
				if isnull(@ShowReturn, 0) = 0
					return 0
			end

		if @ShowReturn = 1
			begin
				select *
					from @ReturnValues
				return 0
			end

		set nocount on


		begin
			if object_id('tempdb..#Specialty') is not null
				drop table #Specialty

			create table #Specialty
				(
				 SpecialtyId int identity(1, 1)
								 not null
				,SpecialtyCode varchar(50) null
				,SpecialtyDesc varchar(100) null
				,ServiceIdentifier bit null
				,Category varchar(82) NULL
                ,SpanishTranslation VARCHAR(100) NULL
                ,NddbSpecialtyId INT null
				)

			insert into #Specialty
				select distinct																	--Insert all specialty
						PSP_Code as SpecialtyCode
					   ,Search.udf_TitleCase(PSP_ProviderDirectory) as SpecialtyDesc
					   ,PSP_Current as ServiceIdentifier
					   ,PSP_CategoryHeader as Category
					   ,PSP_Spanish AS SpanishTranslation
					   ,PSP_ID AS NddbSpecialtyId
					from Network_Development.dbo.Tbl_Provider_ProviderSpecialties with (nolock)
					where PSP_Code is not null
						   and PSP_ProviderDirectory is not null

			update #Specialty
				set	SpecialtyDesc = case 
										 when SpecialtyCode in ('OBGYN') then 'OB/GYN'
										 when SpecialtyCode in ('GP-1') then 'General Practice Outpatient OB Only'
										 when SpecialtyCode in ('ENDRE') then 'Reproductive Endocrinology'
										 when SpecialtyCode in ('INFER') then 'Infertility'
										 when SpecialtyCode in ('FPOB') then 'Family Practice OB'
										 when SpecialtyCode in ('CNMW') then 'Certified Nurse Midwife'
										 when SpecialtyCode in ('FPOP') then 'Family Practice Outpatient OB only'
										 else SpecialtyDesc END
				
				from #Specialty 

--------------------------
--Populate new Id column (Temporary)

DECLARE @COUNT INT = (SELECT COUNT(nddbspecialtyId) FROM search.Specialty WHERE nddbspecialtyid IS NOT NULL)

IF(@COUNT > 0)
BEGIN

--Update		
		
	UPDATE S
	SET	s.SpanishTranslation = T.SpanishTranslation,
		S.SpecialtyDesc = T.SpecialtyDesc,
		S.SpecialtyCode = T.SpecialtyCode,
		S.ServiceIdentifier = T.ServiceIdentifier,
		S.Category = T.Category
	FROM #Specialty T
	JOIN search.Specialty S ON S.NddbspecialtyId = T.NddbSpecialtyId


--Insert
		INSERT INTO search.Specialty 
		SELECT DISTINCT S.SpecialtyCode,
						S.SpecialtyDesc,
						S.ServiceIdentifier,
						S.Category,
						s.SpanishTranslation,
						S.NddbSpecialtyId
		FROM	#Specialty s
		LEFT JOIN search.Specialty T ON  S.NddbSpecialtyId = T.nddbspecialtyId
		WHERE T.SpecialtyID IS null


END
ELSE
BEGIN

	UPDATE S
	SET	s.NddbSpecialtyId = T.NddbSpecialtyId
	FROM #Specialty T
	JOIN search.Specialty S ON T.SpecialtyDesc = S.SpecialtyDesc



END

--------------------------




	
	
/********************************************************************/
		if object_id('tempdb..#Specialty') is not null
				drop table #Specialty
			
/********************************************************************/


		end
	end
GO
/****** Object:  StoredProcedure [Import].[MergeUrgentCareProviders]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

------------
CREATE Procedure [Import].[MergeUrgentCareProviders]

	@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
				10/03/2016		SS		Added delete statements to delete child table data.
				11/28/2016		SS		Added column NPI and License for Delegated UC providers
		*/
		
		declare @now date = getdate()
		declare @Version varchar(100) = '10/03/2016 2:22 Version 1.00'
		declare @ReturnValues table
			(
			 ReturnCode int primary key
							not null
			,Reason varchar(200) not null
			)

		insert into @ReturnValues
				(ReturnCode, Reason)
			values (0, 'Normal Return')			
											
		if @Showversion = 1
			begin
				select object_schema_name(@@PROCId) as SchemaName
					   ,object_name(@@PROCId) as ProcedureName
					   ,@Version as VersionInformation
				if isnull(@ShowReturn, 0) = 0
					return 0
			end

		if @ShowReturn = 1
			begin
				select *
					from @ReturnValues
				return 0
			end

		set nocount on
--declare @now date = getdate()
		if object_id('tempdb..#UCProviders') is not null
			drop table #UCProviders 


		create table #UCProviders
			(
			 ProviderId int identity(1, 1)
							not null
			,DiamProvId varchar(12) not null
			,FirstName varchar(50) null
			,LastName varchar(30) null
			,Gender varchar(6) null
			,OrganizationName varchar(150) null
			,License varchar(15) null
			,NPI varchar(10) null
			,ProviderType varchar(12) null
			,NetDevProvId varchar(12) null
			,IsInternalOnly bit default 0
			,IsEnabled BIT DEFAULT 1 
			,MemberShipStatus VARCHAR(75) NULL
            ,PreferredFirstName VARCHAR(100) null
			)

--getting urgent care from tbl_uc_new and diamond id from contract info table

		declare @UrgentCare table
			(
			 DiamProvId varchar(12)
			,OrganizationName varchar(150)
			,LocationId int
			,IsInternalOnly bit default 0
			)

		insert into @UrgentCare
			select distinct																				--get urgent care diamondid , name and locationid
					cci.CCI_ContractDiamondId as DiamProvId
				   ,(isnull(uc.PMG_Name, uc.CCI_ContractName)) as OrganizationName
				   ,uc.LocationId as LocationId
				   ,0 as IsInternalOnly
				from Network_Development.dbo.Tbl_Contract_ContractInfo as cci with (nolock)
					inner join Network_Development.dbo.Tbl_Contract_UC_new as uc with (nolock)
							on uc.ContractId = cci.CCI_Id
				where (
					   cci.CCI_TermDate > @now
					   or cci.CCI_TermDate is null
					  )

		insert into #UCProviders
			select distinct isnull(DiamProvId, '') as DiamProvId
				   ,null as FirstName
				   ,null as LastName
				   ,null as Gender
				   ,OrganizationName as OrganizationName
				   ,Null as license
				   ,Null as NPI
				   ,'UC' as ProviderType
				   ,Null as NetDevProvId
				   ,IsInternalOnly as IsInternalOnly
				   ,1 AS IsEnabled
				   ,NULL AS MembershipStatus
				   ,NULL AS PreferredFirstName

				from @UrgentCare 

--Getting Delegate urgent cares
		declare @delegatedUC table
			(
			 OrganizationName varchar(150)
			 ,License varchar(50)
			 ,NPI varchar(12)
			,NetDevProvId int
			,IsInternalOnly bit default 0
			,IsEnabled BIT DEFAULT 1 
			,MemberShipStatus VARCHAR(75) NULL
            ,PreferredFirstName VARCHAR(100) null
			)

		insert into @delegatedUC
			select distinct isnull(MG.PMG_Name, ppi.PPI_LastName) as OrganizationName
			,PPI.PPI_License
			,PPI.PPI_UPIN
				   ,pdna.PDNA_ProviderId as NetDevProvId
				   , 0  as IsInternalOnly
				   ,1 AS IsEnabled
				   ,NULL,null
				from Network_Development.dbo.Tbl_Provider_DelegatedNetwork_Affiliation pdna  with (nolock)--on pdna.PDNA_ProviderId = ppi.ppi_id
					join Network_Development.dbo.Tbl_Contract_Locations as cl with (nolock)
						on cl.CL_Id = pdna.PDNA_LocationId
					left join Network_Development.dbo.Tbl_Provider_ProviderInfo as ppi with (nolock)
						on ppi.PPI_Id = pdna.PDNA_ProviderId
					left join Network_Development.dbo.Tbl_Provider_MedicalGroup as MG with (nolock)
						on MG.PMG_Id = cl.CL_MedicalGroup
				where pdna.PDNA_Specialty = 124
					and (
						 pdna.PDNA_TermDate is null
						 or pdna.PDNA_TermDate > @now
						)


		merge #UCProviders as Target
		using @delegatedUC as Source
		on Target.OrganizationName = Source.OrganizationName
		when not matched by target then
			insert (
					DiamProvId
				   ,FirstName
				   ,LastName
				   ,Gender
				   ,OrganizationName
				   ,License
				   ,NPI
				   ,ProviderType
				   ,NetDevProvId
				   ,IsInternalOnly
				   ,IsEnabled
				   ,MemberShipStatus
				   ,PreferredFirstName
				   )
			values (
					''
				   ,null
				   ,null
				   ,null
				   ,Source.OrganizationName
				   ,Source.License
				   ,Source.NPI
				   ,'UC'
				   ,Source.NetDevProvId	
				   ,Source.IsInternalOnly
				   ,Source.IsEnabled
				   ,Source.MemberShipStatus
				   ,Source.PreferredFirstName
				   );

--Remove dups


if object_id('tempdb..#distinctProviders') is not null
				drop table #distinctProviders

/****************************************************************************************/
--Create temp table #distinctAddresses to get all the unique records
SELECT * INTO #distinctProviders FROM #UCProviders WHERE 1 = 0	 

/****************************************************************************************/

	INSERT INTO #distinctProviders
			Select Distinct 
			  [DiamProvID]
			 ,[FirstName]
			 ,[LastName]
			 ,[Gender]
			 ,[OrganizationName]
			 ,[License]
			 ,[NPI]
			 ,[ProviderType]
			 ,[NetDevProvID]
			 ,[IsInternalOnly]
			 ,[IsEnabled]
			 ,[MembershipStatus]
			 ,[PreferredFirstName]
			 from (  select *
				   ,row_number() over (partition BY a.DiamProvId, a.NetDevProvId, a.ProviderType,a.OrganizationName order by a.OrganizationName ) as ranking						
				from #UCProviders as a with (nolock)
				) T where T.ranking = 1


/***********************************************Enable / disable***************************************************/

--Disable
				UPDATE D
				SET d.IsEnabled = 0
				FROM    #distinctProviders DL
				
					RIGHT JOIN search.Provider D WITH ( NOLOCK ) ON ( D.DiamProvID = DL.DiamProvId)
                                                              AND ( ISNULL(D.ProviderType,'') = 'UC')
															  AND ( ISNULL(D.NetDevProvID,'') = ISNULL(DL.NetDevProvId,''))
															  AND ( ISNULL(D.OrganizationName,'') = ISNULL(DL.OrganizationName,''))
                WHERE   DL.ProviderId IS NULL AND D.ProviderType = 'UC' AND ISNULL(D.IsEnabled,1) <> 0;

--Enable--------------------------------------------------------------------

				UPDATE D
				SET d.IsEnabled = 0
				FROM    #distinctProviders DL
					 INNER JOIN search.Provider D WITH ( NOLOCK ) ON ( D.DiamProvID = DL.DiamProvId)
                                                              AND ( ISNULL(D.ProviderType,'') = 'UC')
															  AND ( ISNULL(D.NetDevProvID,'') = ISNULL(DL.NetDevProvId,''))
															  AND ( ISNULL(D.OrganizationName,'') = ISNULL(DL.OrganizationName,''))
                WHERE  D.ProviderType = 'UC' AND ISNULL(D.IsEnabled,0) <> 1;

--Update----------------------------------------------------------------------
				
				UPDATE P
				SET P.FirstName			=	(CASE WHEN P.FirstName <> PT.FirstName THEN Search.udf_TitleCase(PT.Firstname) ELSE P.FirstName END),
					P.LastName			=	(CASE WHEN P.LastName <> PT.LastName THEN Search.udf_TitleCase(PT.LastName) ELSE p.LastName END),
					P.License			=	(CASE WHEN P.License <> PT.License THEN PT.License ELSE p.License END),
					P.NPI				=	(CASE WHEN P.NPI <> PT.NPI THEN PT.NPI ELSE p.NPI END),
					P.Gender			=	(CASE WHEN P.Gender <> PT.Gender THEN Search.udf_TitleCase(PT.Gender) ELSE p.Gender END),
					P.MemberShipStatus  =	(CASE WHEN ISNULL(P.MemberShipStatus,'') <> PT.MemberShipStatus THEN Search.udf_TitleCase(PT.MemberShipStatus) ELSE p.MemberShipStatus END),
					P.PreferredFirstName  =	(CASE WHEN ISNULL(P.PreferredFirstName,'') <> PT.PreferredFirstName THEN Search.udf_TitleCase(PT.PreferredFirstName) ELSE p.PreferredFirstName END)
				FROM #distinctProviders AS PT
				INNER JOIN search.Provider AS P ON P.DiamProvID = PT.DiamProvId AND ISNULL(P.NetDevProvID,'') = ISNULL(PT.NetDevProvId,'') AND PT.ProviderType = 'UC'
				AND ( ISNULL(P.OrganizationName,'') = ISNULL(PT.OrganizationName,''))


--Insert

				INSERT INTO search.Provider
				SELECT 
				S.DiamProvID,
				Search.udf_TitleCase(S.FirstName),
				Search.udf_TitleCase(S.LastName),
				Search.udf_TitleCase(S.Gender),
				Search.udf_TitleCase(S.Organizationname),
				S.License,
				S.NPI,
				S.ProviderType,
				S.NetDevProvID,
				S.IsInternalOnly,
				S.IsEnabled,
				S.MemberShipStatus,
				S.PreferredFirstName
				FROM #distinctProviders S 
				LEFT JOIN  search.provider p WITH (nolock) on  P.DiamProvID = S.DiamProvId AND ISNULL(P.NetDevProvID,'') = ISNULL(s.NetDevProvId,'') AND s.ProviderType = 'UC'
				AND ( ISNULL(P.OrganizationName,'') = ISNULL(s.OrganizationName,''))
				WHERE p.ProviderID IS NULL 


/*******************************************************************************************************************************************/	

--Update isINternal Flag for providers who are found in Excluded providers Table

		Update P
		set P.IsinternalOnly = Case when P.ProviderID = EP.ProviderID then 1
								else 0 end
								from search.Provider p 
								join search.ExcludedProviders EP with (nolock) on p.ProviderID = EP.ProviderId
	

/*******************************************************************************************************************************************/

/****************************************** DROP TEMP TABLES*******************************************************************************/
				

			if object_id('tempdb..#UCProviders') is not null
			drop table #UCProviders 

			if object_id('tempdb..#distinctProviders') is not null
			drop table #distinctProviders 

/*******************************************************************************************************************************************/	


END
GO
/****** Object:  StoredProcedure [Search].[BusStopTrans_SP]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:           Sheetal Soni
-- Create date:		 11/13/2017
-- Description:      Procedure to get bus information by bus stop num
-- =============================================
CREATE Procedure [Search].[BusStopTrans_SP]
@BusStopNum as varchar(4)
As
BEGIN
       --Declare @BusStopNum varchar(4)
       --SET @BusStopNum = '72'
      -- SELECT BusNumber, Route, isnull(Direction,'N/A')as Direction, isnull(Street,'N/A')as Street, isnull(Stop,'N/A')as stop 
      --select * FROM Resource_Guide.Resource_Guide.dbo.BusStopTrans
      -- WHERE BusNumber=@BusStopNum

	   Select RouteShortName as BusNumber,  BusAgency as Street, RouteLongName as Route,ISNULL(Direction,'N/A') as Direction, StopName as [Stop]
	   from search.businfo 
	   where StopId = @BusStopNum

END


GO
/****** Object:  StoredProcedure [Search].[GetAffiliationExtendedPropertyList]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ===================================================================================================== 
-- Authors:   Tony Do 
-- Create date: ~7/1/2016 
-- Modified date: ~10/18/2016
-- Description:   [search].[GetProvidersExtendedPropertyList] refactored from [search].[GetProviders] 
-- Return: Language
-- =====================================================================================================
CREATE procedure [Search].[GetAffiliationExtendedPropertyList] -- Add the parameters for the    
	@ProviderIdList [search].[ProviderIdList]		READONLY
	, @Showversion									BIT = 0
    ,@ShowReturn									BIT = 0
AS
BEGIN

		/*
			Modification Log:
				11/14/2016	1.00	SS		Modified SP, Added ShowVersion,ShowRetrun Parmeters.
		*/
		
		declare @now date = getdate()
		declare @Version varchar(100) = '11/14/2016 8:55 Version 1.00'
		declare @ReturnValues table
			(
			 ReturnCode int primary key
							not null
			,Reason varchar(200) not null
			)

		insert into @ReturnValues
				(ReturnCode, Reason)
			values (0, 'Normal Return')			
											
		if @Showversion = 1
			begin
				select object_schema_name(@@PROCId) as SchemaName
					   ,object_name(@@PROCId) as ProcedureName
					   ,@Version as VersionInformation
				if isnull(@ShowReturn, 0) = 0
					return 0
			end

		if @ShowReturn = 1
			begin
				select *
					from @ReturnValues
				return 0
			end


      SET NOCOUNT ON; 
	  --/* Affil Extended Properties */  
	  SELECT aep.AffilationID AS AffiliationId, aep.PropertyName, aep.PropertyValue
			FROM search.Provider p WITH (nolock)
			INNER JOIN @ProviderIdList Pl ON P.ProviderID = Pl.ProviderId 
			JOIN search.Affiliation af WITH (nolock) ON p.ProviderId = af.ProviderID AND af.IsEnabled = 1 
			JOIN search.AffiliationExtendedProperties aep WITH (nolock)  ON aep.AffilationID = af.AffiliationID AND aep.isEnabled = 1 
					
END

GO
/****** Object:  StoredProcedure [Search].[GetAffiliationList]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================= 
-- Authors:    Tony Do 
-- Create date: ~11/11/2016 
-- Modified date: ~11/11/2016
-- ============================================= 
CREATE Procedure [Search].[GetAffiliationList] 
   @Acceptingnewmembers BIT = 0,
   @Age                 DATETIME = NULL,
   @DirectoryID         VARCHAR(20) = NULL, 
   @HospitalName        VARCHAR(100) = NULL, 
   @IPAAffiliation      VARCHAR(3) = NULL,
   @IsHospitalAdmitter  BIT =0,
   @LineofBusiness      VARCHAR(3) = NULL, 
   @Panel               VARCHAR(15) = NULL, 
   @ProviderIdList [search].[ProviderIdList] READONLY   ,
   @Showversion								   BIT = 0
  ,@ShowReturn								   BIT = 0
as
	begin
		/*
			Modification Log:
				11/11/2016	1.00	SS		Modified SP, Added ShowVersion,ShowRetrun Parmeters.
				
		*/
		
		declare @now date = getdate()
		declare @Version varchar(100) = '11/11/2016 1:21 Version 1.00'
		declare @ReturnValues table
			(
			 ReturnCode int primary key
							not null
			,Reason varchar(200) not null
			)

		insert into @ReturnValues
				(ReturnCode, Reason)
			values (0, 'Normal Return')			
											
		if @Showversion = 1
			begin
				select object_schema_name(@@PROCId) as SchemaName
					   ,object_name(@@PROCId) as ProcedureName
					   ,@Version as VersionInformation
				if isnull(@ShowReturn, 0) = 0
					return 0
			end

		if @ShowReturn = 1
			begin
				select *
					from @ReturnValues
				return 0
			end 
      SET nocount ON; 	 

	  
      DECLARE 
              @ageDiff FLOAT = NULL, 
              @month   FLOAT = NULL; 
      DECLARE @AgeLimit TABLE 
        ( 
           age VARCHAR(max) 
        ) 

      SELECT @ageDiff = Datediff(year, @Age, Getdate()) --Get Age difference if 
      IF ( @ageDiff = 0 ) 
        --If age difference is less than a year then get months 
        BEGIN 
            SET @month = Datediff(month, @Age, Getdate()) 

            SELECT @ageDiff = @month / 12 --Get agediff minnimum value 
        END 

      INSERT INTO @AgeLimit 
      SELECT DISTINCT agelimit 
      FROM   [search].agelimits WITH (nolock) 
      --Select age code into @Agelimit between for the age diff  
      WHERE  ( @ageDiff BETWEEN agelimitmin AND agelimitmax ) 
              OR ( @ageDiff IS NULL ); 

     
  SELECT DISTINCT 
	  
	  A.[AffiliationID]
      ,A.[ProviderID]
      ,A.[DirectoryID]
      ,A.[LOB]
      ,A.[Panel]
      ,A.[IPAName]
      ,A.[IPAGroup]
      ,A.[IPACode]
      ,A.[IPAParentCode]
      ,A.[IPADesc]
      ,A.[HospitalName]
      ,A.[ProviderType]
      ,A.[AffiliationType]
      ,A.[AgeLimit]
      ,A.[AcceptingNewMbr]
      ,A.[EffectiveDate]
      ,A.[TerminationDate]
      ,A.[HospitalID]
      ,A.[IsHospitalAdmitter]
      ,A.[AcceptingNewMemberCode]
      ,alt.agelimitdescription AS AgeLimitDescription
	  ,A.AddressID 
      FROM   [search].affiliation A WITH (nolock) 
             INNER JOIN @ProviderIdList P
                     ON A.providerid = P.ProviderID 
             left JOIN @AgeLimit AS AL 
                     ON al.age = a.agelimit 
             left JOIN [search].agelimits AS ALT  with (nolock)
                     ON a.agelimit = alt.agelimit 
                        AND Alt.agelimitdescription <> 'FEMALE ALL AGES' 
						--WHERE 1 =1
      WHERE ( ( A.lob IN(@LineofBusiness,'All LOBs') ) 
                    OR ( ISNULL(@LineofBusiness,'') = '') ) 
          AND    ( ( A.ipacode = @IPAAffiliation or A.IPAParentCode = @IPAAffiliation)
                    OR ( ISNULL(@IPAAffiliation,'')= '' ) ) 
             AND ( ( A.panel = @Panel ) 
                    OR ( ISnull(@Panel,'')='' ) ) 
             AND ( ( A.directoryid = @DirectoryID ) 
                    OR ( Isnull(@DirectoryID,'') = '' ) ) 
             AND ( ( A.hospitalname = @HospitalName ) 
                    OR ( Isnull(@HospitalName,'') = '' ) ) 
             AND (( A.agelimit IN ( al.age ) 
                     OR ( Isnull(@Age,'') = '' ) ))
			AND ((A.IsHospitalAdmitter = @IsHospitalAdmitter) 
				OR (@IsHospitalAdmitter =0 ))
				AND ((A.AcceptingNewMbr = @Acceptingnewmembers) 
				OR (@Acceptingnewmembers =0 ))		
								
				END
GO
/****** Object:  StoredProcedure [Search].[getDropdownItems]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sheetal Soni>
-- Create date: <8/9/2016>
-- Description:	<Stored Procedure to feed API end points for dropdowns>
-- =============================================
CREATE Procedure [Search].[getDropdownItems]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--Get IPAs
--select distinct IPACODE, IPANAME from [search].Affiliation with (nolock)where (IPACODE IS NOT NULL) AND (IPANAME IS NOT NULL) order by IPANAME
	SELECT DISTINCT 
			CASE WHEN IPAParentcode IS NULL OR IPAParentcode = '' THEN IPACode
			ELSE IPAParentcode END AS IPAcode,IPAName FROM (
			(SELECT distinct IPAPARENTCODE,IPACODe,IPANAME, 
			ROW_NUMBER() OVER (PARTITION BY  IPACODE ORDER BY IPANAME DESC) AS ranking						
			FROM 
			[search].Affiliation AS PAH WITH(NOLOCK))) AS T
			WHERE  ranking = 1 and  (IPACODe is not null) and (IPANAMe is not null) and (IPACode <> 'NON') and (IPACode <> 'DCD')
			Order By IPAName


--Get Hospitals
Select distinct OrganizationName as HospitalName from [search].Provider where ProviderType = 'HOSP' and OrganizationName <> 'Jerral R Pulley Jr Lcsw'
order by OrganizationName

--Get Specialties
select distinct s.SpecialtyID,s.SpecialtyDesc, s.SpanishTranslation from [search].Specialty as s with (nolock)
join [search].providerspecialty as p on p.SpecialtyID = s.SpecialtyID 
inner join [search].Provider as sp on sp.ProviderID = p.ProviderID
where S.ServiceIdentifier = 1 and S.SpecialtyDesc not in 
 ('Licensed Marriage and Family Therapy','Mid-Wife','Nurse Practitioner','Physician Assistant',
 'Sports Medicine',
 'Therapeutic Pharmaceutical Agent (TPA) Services',
 'Critical Care Anesthesiologist',
 'Psychiatry',
 'Psychiatry (Child and Adolescent)',
 'Psychology',
 'Physical Therapy')
 and sp.ProviderType = 'SPEC' 
OR s.specialtyDesc in
 ('Acupuncturist',
 'Adult Orthopaedic Surgery',
 'Cardiac Surgery',
 'Cardiology (Invasive and Non-Invasive)',
 'Diagnostic Pharmaceutical Agent (DPA)',
 'Head and Neck Surgery',
 'MOHS-Micrographic Surgery',
 'Optician',
 'Orthopaedic',
 'Urogynecology',
 'Oncology Surgery',
 'Pathology - Speciality Services',
 'Pediatric Ophthalmology',
'Respiratory Therapist',
 'Surgery of the Hand') 
order by s.specialtyDesc 


--Get Languages
select distinct LanguageID,Description from [search].languages where ISOCODE is not null order by Description


--Get Specialties for BH
select distinct s.SpecialtyID,s.SpecialtyDesc, s.SpanishTranslation from [search].Specialty as s with (nolock)
where S.ServiceIdentifier = 1 and S.Category in ('Behav') OR S.SpecialtyDesc 
IN ('Autism Assessment','Behavioral Health','Developmental-Behavioral Pediatrics','Inpatient Behavioral Health Services','Pharmacy Services')
and S.SpecialtyID not in (2928)
order by s.specialtyDesc 

--Get Services  for Faciliteis (LTSS,SNF,ANC,IPA)

Select S.SpecialtyID, S.SpecialtyDesc, s.SpanishTranslation from [search].Specialty as S with (nolock) where S.SpecialtyDesc in (
'Ambulatory Surgery Center Services'
,'Outpatient Surgery Services'
,'Dental Full-Time Facility'
,'Psychiatric Hospital'
,'Rehab Facility'
,'Skilled Nursing Facility (all ages)'
,'SNF - Intermediate Care'
,'Surgical Center/Clinic (General Surgery)'
,'Surgical Center/Clinic (Specialty Surgery)'
) order by S.SpecialtyDesc

--Get other services
--select distinct s.SpecialtyID,s.SpecialtyDesc from [search].Specialty as s with (nolock)
--Inner join [search].ProviderSpecialty as PS with (nolock) on PS.SpecialtyID = s.SpecialtyID
--Inner join [search].Provider as p with (nolock) on p.ProviderID = ps.ProviderID
--where p.ProviderType not in ('ANC','DANC','LTSS','SNF','IPA','VSN','BH','UC','HOSP') and s.ServiceIdentifier = 0
--order by s.specialtyDesc 

Select Distinct S.SpecialtyID, S.SpecialtyDesc,s.SpanishTranslation from [search].Specialty S with (nolock) where
S.SpecialtyDesc not in ('Cardiac Event Holter and Pacemaker Follow Up','Consulting Services','Multispecialty Clinic') and
 S.SpecialtyDesc in (
'Air Ambulance Transportation Service'
,'Ground Ambulance - Emergent Transport'
,'Audiologist-Hearing Aid Fitter'
,'Breast Biopsy'
,'Community-Based Adult Services (CBAS)'
,'Laboratory'
,'Dialysis'
,'DME'
,'DME - Air Fluidized Bed'
,'DME - Basic and Standard Durable Medical Equipment'
,'DME - Bathroom Safety Equipment'
,'DME - Bone Growth Stimulators'
,'DME - Breast Prostheses and Accessories'
,'DME - Diabetic Test Strips and Supplies'
,'DME - Incontinence Supplies'
,'DME - Nebulizer and Supplies'
,'DME - Non-Invasive Bone Growth Stimulators'
,'DME - Wheelchairs'
,'DOC Band'
,'Emergency Ground Transportation'
,'Family Planning'
,'Fluoroscopy'
,'Gurney (Non-Emergency Van)'
,'Health Services'
,'Hearing Aid Accessories'
,'Hearing Aid Center'
,'Hearing Aid Dispenser'
,'Home Health Services (All Ages)'
,'Home Health - Dietery/Nutritional Services'
,'Home Health - Speech / Language Therapy'
,'Home Health Services (18+ only)'
,'Home Infusion Agency'
,'Home Visits Medicare Dual Choice'
,'Hand Therapy'
,'Hospitalist (Adults 16+)'
,'Hospitalist (Adults 18+)'
,'Hospitalist (Peds and Adults)'
,'Hospice Services'
,'Imaging/Diagnostic/X-Ray'
,'Cancer Genetic Laboratory Services'
,'Hematologic Category Testing Services'
,'Long Term Care'
,'Ocular and Maxillo-Facial Prosthetics'
,'Breast MRI'
,'Ocularist'
,'P & O - Orthotics'
,'Mobile Phlebotomy Services'
,'Polysomnography'
,'Prosthetics Case Management'
,'Prosthetics and Orthotics'
,'PT/INR Home Monitoring Services'
,'Radiation Oncology Services'
,'Rehabilitative Prosthetist'
,'Sleep Study / Disorder Diagnostic'
,'Skilled Nursing Services'
,'Ground Transportation (Non-Emergency)'
,'Transportation Broker'
,'Transportation Services'
,'Multispecialty Clinic'
,'Cardiac Event Holter and Pacemaker Follow Up'
,'Consulting Services'
,'Multispecialty Clinic'
,'Mid-Wife'
,'Nurse Practitioner'
,'Physician Assistant'
,'Nurse Anesthetists'
) or S.SpecialtyDesc like 'DME%' order by S.SpecialtyDesc

--Get database refreshed date/time
select max(date) as Date
  FROM [search].[DataIntegrationAudit]

END


GO
/****** Object:  StoredProcedure [Search].[GetProviderAffiliationList]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =====================================================================
-- Authors:   Tony Do 
-- Create date: ~10/28/2016 
-- Modified date: Nov 17, 2016
-- Description:   [search].[GetProviderAffiliationList]
-- Filtering Rules in this procedure should match 
--		with Affiliation section in GetSearchProviderList procedure
-- =====================================================================
CREATE Procedure [Search].[GetProviderAffiliationList] 
 @Acceptingnewmembers bit					= 0
,@AddressIdList								[search].[AddressIdList] READONLY   
,@AffiliationPanelExclusionList				[search].[AffiliationPanelList] READONLY
,@AffiliationLobExclusionList				[search].[AffiliationLobList] READONLY     
,@Age datetime								= null
,@DirectoryId varchar(20)					= null
,@HospitalName varchar(100)					= null
,@Internal bit								= 0
,@IPAAffiliation varchar(3)					= null
,@IsHospitalAdmitter bit					= 0
,@LineofBusiness varchar(3)					= null
,@Panel varchar(15)							= null
,@ProviderId int							= NULL
,@StatusCode varchar(3)						= null
,@Showversion								   BIT = 0
,@ShowReturn								   BIT = 0   
AS 
  BEGIN 
		/*
			Modification Log:
				11/14/2016	1.00	SS		Modified SP, Added ShowVersion,ShowRetrun Parmeters.
		*/		
		declare @Version varchar(100) = '11/14/2016 8:40 Version 1.00'
		declare @ReturnValues table
			(
			 ReturnCode int primary key
							not null
			,Reason varchar(200) not null
			)

		insert into @ReturnValues
				(ReturnCode, Reason)
			values (0, 'Normal Return')			
											
		if @Showversion = 1
			begin
				select object_schema_name(@@PROCId) as SchemaName
					   ,object_name(@@PROCId) as ProcedureName
					   ,@Version as VersionInformation
				if isnull(@ShowReturn, 0) = 0
					return 0
			end

		if @ShowReturn = 1
			begin
				select *
					from @ReturnValues
				return 0
			end

      -- SET NOCOUNT ON added to prevent extra result sets from 
      -- interfering with SELECT statements. 
		SET NOCOUNT ON;
		DECLARE @now datetime = getdate()
	  
		DECLARE @ageDiff FLOAT = NULL, @month   FLOAT = NULL; 
		DECLARE @AgeLimit TABLE ( age VARCHAR(max) ) 

		SELECT @ageDiff = Datediff(year, @Age, Getdate()) --Get Age difference if 
		IF ( @ageDiff = 0 ) 
        --If age difference is less than a year then get months 
        BEGIN 
            SET @month = Datediff(month, @Age, Getdate()) 
            SELECT @ageDiff = @month / 12 --Get agediff minnimum value 
        END 

		INSERT INTO @AgeLimit 
		SELECT DISTINCT agelimit 
		FROM   [search].agelimits WITH (NOLOCK)
		--Select age code into @Agelimit between for the age diff  
		WHERE		( @ageDiff BETWEEN agelimitmin AND agelimitmax ) 
				OR	( @ageDiff IS NULL ); 

     
		SELECT DISTINCT A.[AffiliationID], A.[ProviderID], A.[DirectoryID], A.[LOB], A.[Panel]
			,A.[IPAName], A.[IPAGroup], A.[IPACode], A.[IPAParentCode], A.[IPADesc], A.[HospitalName]
			,A.[ProviderType], A.[AffiliationType], A.[AgeLimit], A.[AcceptingNewMbr], A.[EffectiveDate]
			,A.[TerminationDate], A.[HospitalID], A.[IsHospitalAdmitter], A.[AcceptingNewMemberCode]
			,alt.agelimitdescription AS AgeLimitDescription, A.AddressID ,MC.CodeLabel as NewMemberCodeLabel ,MC.CodeDescription as NewMemberCodeDescription
		FROM   [search].affiliation A WITH (NOLOCK) 
					INNER JOIN [search].Provider P ON A.providerid = P.ProviderID 
					LEFT JOIN @AgeLimit AS AL ON al.age = a.agelimit 
					LEFT JOIN [search].agelimits AS ALT ON a.agelimit = alt.agelimit 
                        AND Alt.agelimitdescription <> 'FEMALE ALL AGES' 
					left join search.AcceptingNewMemberCodes MC with (nolock)
					on MC.StatusCode = A.AcceptingNewMemberCode
						--WHERE 1 =1
      WHERE  a.ProviderID = @ProviderId 	  
			AND  ( ISNULL(@LineofBusiness,'') = '' OR  A.lob IN(@LineofBusiness,'All LOBs') AND A.LOB not in (select lob from @AffiliationLobExclusionList) )
				 --Need to handle exclusion lob CCI	  
			AND  ( ISNULL(@Panel,'') = '' or (A.Panel = @Panel and A.Panel not in (select panelid from @AffiliationPanelExclusionList)) )                
            AND  ( ISNULL(@IPAAffiliation,'') = '' OR ( A.ipacode = @IPAAffiliation or A.IPAParentCode = @IPAAffiliation) ) 
            AND	 ( ISNULL(@DirectoryId,'')= ''OR A.directoryid = @DirectoryId) 
						AND ( ISNULL(@HospitalName,'') = '' or P.OrganizationName = @HospitalName OR  A.hospitalname = @HospitalName ) 
						AND	( ISNULL(@Age,'') = '' OR A.agelimit IN ( al.age ) )				
			-- Filter applies when @IsHospitalAdmitter = 1
			AND	( @IsHospitalAdmitter = 0 or  A.IsHospitalAdmitter = @IsHospitalAdmitter	)
		AND ((P.ProviderType = 'PCP' and @Acceptingnewmembers = 1 and p.MembershipStatus = 'Accepting New Patients')
					OR (P.ProviderType = 'PCP' and @Acceptingnewmembers = 0 and p.MembershipStatus In (SELECT DISTINCT SP.MembershipStatus FROM search.Provider Sp WHERE Sp.MembershipStatus <> 'Accepting New Patients'))
					OR (@Acceptingnewmembers = 0 and P.ProviderType <> 'PCP'))
	
			AND	(	@Internal = 1 
					OR (( @Internal = A.IsInternalOnly ) AND ( A.EffectiveDate is null or  A.EffectiveDate <= @now	)					 
					AND ( A.TerminationDate is null or A.TerminationDate >= @now ))
				)
				AND (A.AcceptingNewMemberCode = @StatusCode or @StatusCode is null)
END

GO
/****** Object:  StoredProcedure [Search].[GetProviderAndAddressList]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================= 
-- Authors:    Sheetal Soni
-- Create date: ~10/17/2016 
-- Description:   Procedure to Get Providers 
-- ============================================= 
CREATE Procedure [Search].[GetProviderAndAddressList] 

 @Age datetime								= null  
,@AppointmentNeeded bit						= null
,@Acceptingnewmembers bit					= null
,@AfterHoursPhone varchar(10)				= null
,@Accessibility varchar(50)					= null
,@BusStop int								= null
,@BusRoute varchar(30)						= null
,@BuildingSign varchar(100)					= null
,@Contractstatus date						= null
,@City varchar(30)							= null
,@CenterPoint_lat float						= null
,@CenterPoint_lng float						= null
,@County varchar(30)						= null
,@CountyCode int							= null
,@DiamProviderId varchar(12)				= null
,@DirectoryId varchar(12)					= null
,@DoctorTypes varchar(150)					= null
,@Email varchar(50)							= null
,@EnablePaging bit							= null
,@Facility bit								= null
,@Fax varchar(10)							= null
,@FederallyQualifiedHC bit					= null
,@Gender varchar(6)							= null
,@HospitalAffiliation varchar(12)			= null
,@HospitalName varchar(100)					= null
,@IPAAffiliation varchar(3)					= null
,@intMilesModifier int						= null
,@IsHospitalAdmitter bit					= null
,@IsInternal bit							= null
,@LicenseNumber varchar(15)				    = null
,@Language int								= null
,@LineofBusiness varchar(3)					= null
,@NetProviderId varchar(12)					= null
,@NationalProviderId varchar(10)			= null
,@Name varchar(100)							= null
,@OfficeName varchar(100)					= null
,@ProviderType varchar(15)					= null
,@Phone varchar(10)							= null
,@PageNumber int							= null
,@PageSize int								= null
,@Panel varchar(3)							= null
,@Radius int								= null
,@Specialty int								= null
,@ShowTermed bit							= null
,@ShowFuture bit							= null
,@SearchMethod varchar(1)					= null
,@Street varchar(100)						= null
,@WebSite varchar(100)						= null
,@Walkin bit								= null
,@ZipCode varchar(9)						= null	


AS
	BEGIN

		declare @xml xml, @ageDiff float = null, @month float = null, @EnglishLanguage varchar(7), @now date = getdate()
		declare @Version varchar(100) = '10/17/2016 11:22 Version 1.00'
		declare @ReturnValues table
			(
			 ReturnCode int primary key
							not null
			,Reason varchar(200) not null
			)
		declare @AgeLimit table 
			(
				age varchar(12)	
			)
		declare @tempProvSpecialty table
			(
			providerID int not null
			)
		declare @tempSPeciatlyID table
			(
			SpecialtyID int not null
			)
		declare @providerLanguageID table
			(
			ProviderID int not null
			)
													--Drop temp table if already exists
		if object_id('tempdb..#scope') is not null
		drop table #scope 
		create table #scope (provid int not null); 

		
	SET NOCOUNT ON; 


		select @ageDiff = datediff(year, @Age, @now)															--Get Age difference if 
		if (@ageDiff = 0) 
																												 --If age difference is less than a year then get months 
			begin 
				set @month = datediff(month, @Age, @now) 

				select @ageDiff = @month / 12																	--Get agediff minnimum value 
			end 

		insert into @AgeLimit
			select distinct AgeLimit
				from search.AgeLimits with (nolock) 
																												  --Select age code into @Agelimit between for the age diff  
				where (@ageDiff between AgeLimitMin and AgeLimitMax)
					or (@ageDiff is null); 


		 
		  
	-----------------------------------------------------------------------------------
	--Exclude Enligsh from search filters becuase it is default and not assigned to any providers
		
		IF(@Language IS NOT NULL)
			set @EnglishLanguage = (Select Description from search.Languages where LanguageId = @Language)
				IF(@EnglishLanguage = 'English')
					Set @Language = null
-----------------------------------------------------------------------------------------------------

 
      --- Create/Drop Indexes on table only for search purpose------                              
	If IndexProperty(Object_Id('search.Address'), 'IdX_C_Add_ProvId', 'IndexID') IS NOT Null	
	Drop INDEX IdX_C_Add_ProvId ON search.Address
	
	If IndexProperty(Object_Id('search.affiliation'), 'IdX_C_Aff_ProvId', 'IndexID') IS NOT Null	
	Drop INDEX IdX_C_Aff_ProvId ON search.affiliation

	If IndexProperty(Object_Id('search.ProviderSpecialty'), 'IdX_C_SPEC_ProvId', 'IndexID') IS NOT Null	
	Drop INDEX IdX_C_SPEC_ProvId ON search.ProviderSpecialty

	If IndexProperty(Object_Id('search.ProviderLanguage'), 'IdX_C_Lang_ProvId', 'IndexID') IS NOT Null	
	Drop INDEX IdX_C_SPEC_ProvId ON search.ProviderLanguage

    CREATE NONCLUSTERED INDEX IdX_C_Add_ProvId ON search.Address(ProviderID) INCLUDE (FAX,ZIP)
	CREATE NONCLUSTERED INDEX IdX_C_Aff_ProvId ON search.affiliation(ProviderID) INCLUDE (LOB,IPACODE,IPAParentCode)
	CREATE NONCLUSTERED INDEX IdX_C_SPEC_ProvId ON search.ProviderSpecialty(SpecialtyID) INCLUDE (ProviderID,BoardCertified)
	CREATE NONCLUSTERED INDEX IdX_C_lang_ProvId ON search.ProviderLanguage(LanguageID) INCLUDE (ProviderID)



-----------------------------------------------------------------------------------------------------
	 
	 /*
	 Select distinct ProviderID from ProviderSpecialty and ProviderLanguage Tables if search by Specialty to avoid
	 whole table scanning. 
	 */
	 IF(@DoctorTypes IS NOT NULL)
	 BEGIN
	 Insert into @tempSPeciatlyID
	 Select distinct SpecialtyID from search.Specialty where SpecialtyDesc IN  (select distinct *  from Split(@DoctorTypes, ','))			--Need to replace Split function

	 insert into @tempProvSpecialty
	 Select distinct ProviderID  from search.ProviderSpecialty where SpecialtyID in (Select distinct SpecialtyID from @tempSPeciatlyID)
	 END
	 
	 IF(@Specialty is not null)
	 Begin
	 Insert into @tempProvSpecialty
	 Select distinct ProviderID  from search.ProviderSpecialty where SpecialtyID = ISNULL(@Specialty,0) 
	 End

	 Insert into @providerLanguageID
	 Select distinct providerID from search.ProviderLanguage where Languageid  = @Language 
	

      /*************************************** 
      ----- Identify Matching Providers ------                              
      ***************************************/ 
		insert into #Scope
			select distinct P.ProviderID
				from search.Provider P
					INNER JOIN search.Address AD with (nolock)
						on P.ProviderID = AD.ProviderID
					left join search.Affiliation A with (nolock)
						on P.ProviderID = A.ProviderID 
						
				where  (
							ISNULL(@Name,'') = '' 
						 OR (isnull(P.LastName, '') like '%' + @Name + '%')
						 OR (isnull(P.FirstName, '') like '%' + @Name + '%')
						 OR left(ISNULL(P.firstname,''), charindex(' ', ISNULL(P.FirstName,'')) - 0) + ISNULL(P.lastname,'') like '%'+@Name+'%'
						 Or Isnull(P.FirstName,'') +' '+ ISnull(P.Lastname,'') like '%'+@Name+'%'
						 OR (isnull(P.OrganizationName, '') like '%' + @Name + '%')
						)
					and 
						(ISNULL(@DiamProviderID,'') = '' OR P.DiamProvID Like '%'+@DiamProviderId+'%' )
					and 
						(ISNULL(@NetProviderID,'') = '' OR P.NetDevProvID = @NetProviderId)
					and (ISNULL(@Facility,'') <> 1 and P.ProviderType = @ProviderType
						 or (@Facility = 1 and P.ProviderType in ('ANC', 'DANC', 'NPP') and ISNULL(@ProviderType,'')='')	--For other providers
						 or (ISNULL(@Facility,'') <> 1 and ISNULL(@ProviderType,'') = '')
						)
					and 
					    (ISNULL(@Gender,'') = '' OR P.Gender = @Gender)
					and  
					    (ISNULL(@NationalProviderId,'') = '' OR P.NPI like '%' + @NationalProviderId + '%')
					and 
					    (ISNULL(@LicenseNumber,'') = '' OR P.License like '%' + @LicenseNumber + '%')
					and 
					    (ISNULL(@IPAAffiliation,'') = '' OR A.IPACode = @IPAAffiliation OR A.IPAParentCode = @IPAAffiliation)
					and 
						(ISNULL(@ZipCode,'') = '' OR AD.Zip = @ZipCode)
					and 
						(ISNULL(@Fax,'') = '' OR AD.Fax = @Fax)
					and 
						(ISNULL(@LineofBusiness,'') = '' OR A.LOB = @LineofBusiness or A.LOB = 'all lobs')
					and 
						(ISNULL(@Specialty,'') = '' OR P.ProviderID IN (select distinct provideriD from @tempProvSpecialty))
					and 
						(ISNULL(@Age,'') = '' OR A.AgeLimit in (Select distinct age from @AgeLimit ))
					and 
						(ISNULL(@Language,'') = '' OR P.providerID in (Select distinct providerID from @providerLanguageID))
					and 
						(ISNULL(@DoctorTypes,'') = '' OR P.ProviderID IN (select distinct provideriD from @tempProvSpecialty)) 
					and 
						(ISNULL(@ShowFuture,'') = '' OR A.EffectiveDate >= @now and @ShowFuture = 1 and @IsInternal = 1)					 
					and 
						(ISNULL(@ShowTermed,'') = '' OR A.TerminationDate <= @now  and @ShowTermed = 1 and @IsInternal = 1)
					and 
						(
					    (ISNULL(@SearchMethod,'')='' and AD.City = @City)
					or  (@SearchMethod = 'L' 
						  and @intMilesModifier * acos(cos(radians(@CenterPoint_lat)) * cos(radians(AD.Latitude)) * cos(radians(AD.Longitude)
																														- radians(@CenterPoint_lng))
													   + sin(radians(@CenterPoint_lat)) * sin(radians(AD.Latitude))) <= @Radius Or AD.City = @City)
					or (ISNULL(@SearchMethod,'')=''and ISNULL(@City,'')= '')
						)
					and 
						(ISNULL(@Email,'') = '' OR AD.Email = @Email)
					and 
						(ISNULL(@Panel,'') = '' OR A.Panel = @Panel)
					and 
						(ISNULL(@DirectoryID,'') = '' OR A.DirectoryID = @DirectoryId)
					and 
						(ISNULL(@HospitalName,'') = '' OR  A.HospitalName = @HospitalName or P.OrganizationName = @HospitalName)
					and 
						(ISNULL(@Street,'') = '' OR AD.Street = @Street)
					and 
						(ISNULL(@County,'') = '' OR AD.County = @County)
					and 
						(ISNULL(@Walkin,'') = '' OR AD.Walkin = @Walkin)
					and 
						(ISNULL(@FederallyQualifiedHC,'') = '' OR AD.FederallyQualifiedHC = @FederallyQualifiedHC)
					and 
						(ISNULL(@CountyCode,'') = '' OR AD.CountyCode = @CountyCode)
					and 
						(ISNULL(@OfficeName,'') = '' OR AD.MedicalGroup like '%' + @OfficeName + '%')
					and 
						(ISNULL(@Phone,'') = '' OR AD.Phone = @Phone)
					and 
						(ISNULL(@AfterHoursPhone,'') = '' OR AD.AfterHoursPhone = @AfterHoursPhone)
					and 
						(ISNULL(@WebSite,'') = '' OR  AD.WebSite = @WebSite)
					and 
						(ISNULL(@BusStop,'') = ''  OR AD.BusStop = @BusStop)
					and 
						(ISNULL(@Accessibility,'') = '' OR AD.Accessibility = @Accessibility)
					and 
						(ISNULL(@BusRoute,'') = '' OR AD.BusRoute = @BusRoute)
					and 
						(ISNULL(@BuildingSign,'') = '' OR  AD.BuildingSign = @BuildingSign)
					and 
						(ISNULL(@IsHospitalAdmitter,'') = '' OR A.IsHospitalAdmitter = @IsHospitalAdmitter)
					and 
						(ISNULL(@Acceptingnewmembers,'') = '' OR A.AcceptingNewMbr = @Acceptingnewmembers)
					and 
						(ISNULL(@IsInternal,'') = '' and ISNULL(P.IsInternalOnly,0) = 0 or @IsInternal =1 );

				CREATE NONCLUSTERED INDEX IdX_C_Prov_ProvId ON #Scope(PROVId)
      /*************************************** 
      ------------- Pagination ------------ 
      ***************************************/ 
		if (@EnablePaging = 1) 
        --Create temp table to store paginated results 
			begin 
				Declare @temp table (provid int not null);

				with	pagedprovider
						  as (
							  select provid
								   ,pagedProviderCount = row_number() over (order by provid)
								from #scope
							 )
					insert @temp
						select scope.provid --into #temp 
							from pagedprovider
								inner join #scope as scope
									on pagedprovider.provid = scope.provid
							where pagedprovider.pagedProviderCount between (((@PageNumber - 1) * @PageSize) + 1)
																   and	   @PageNumber * @PageSize 

            --ORDER BY PROVId; 
				Truncate table #scope 

				insert into #scope
					select *
						from @temp 
			end 

  /*************************************** 
  ------------- Retrieve Data ------------ 
  ***************************************/ 
      /* Providers */ 
		select distinct ProviderID
			   ,DiamProvID
			   ,FirstName
			   ,LastName
			   ,Gender
			   ,OrganizationName
			   ,License
			   ,NPI
			   ,ProviderType
			   ,NetDevProvID
			from search.Provider P with (nolock)
				inner join #scope
					on P.ProviderID = #scope.provid;

		/*	Addresses*/
	select distinct A.AddressID
			   ,A.ProviderID
			  ,rtrim(A.Street+' '+ISNULL(A.Street2,'')) AS Street
			   ,A.City
			   ,A.Zip
			   ,A.County
			   ,A.CountyCode
			   ,A.Phone
			   ,A.AfterHoursPhone
			   ,A.Fax
			   ,A.Email
			   ,A.WebSite
			   ,A.BusStop
			   ,A.BusRoute
			   ,A.Accessibility
			   ,A.Walkin
			   ,A.BuildingSign
			   ,A.AppointmentNeeded
			   ,A.Hours
			   ,A.Latitude
			   ,A.Longitude
			   ,A.LocationID
			   ,A.MedicalGroup
			   ,A.ContractID
			   ,A.FederallyQualifiedHC
			   ,A.State
			   ,case when @SearchMethod = 'L' 
						  and @intMilesModifier * acos(cos(radians(@CenterPoint_lat)) * cos(radians(A.Latitude)) * cos(radians(A.Longitude)
																														- radians(@CenterPoint_lng))
													   + sin(radians(@CenterPoint_lat)) * sin(radians(A.Latitude))) <= @Radius or A.City = @City
					 then @intMilesModifier * acos(cos(radians(@CenterPoint_lat)) * cos(radians(A.Latitude)) * cos(radians(A.Longitude)
																												   - radians(@CenterPoint_lng))
												   + sin(radians(@CenterPoint_lat)) * sin(radians(A.Latitude)))
					 else ''
				end as Distance
			from search.Address A with (nolock)
				Left Join Search.Affiliation af with (nolock) on Af.addressID = A.AddressID and a.providerID= af.providerId
				inner join #scope
					on A.ProviderID = #scope.provid
			where 
					(ISNULL(@ZipCode,'') = '' OR A.Zip = @ZipCode)
				and 
					(ISNULL(@Fax,'')='' OR  A.Fax = @Fax)
				and 
					(ISNULL(@Email,'') = '' OR A.Email = @Email)
				and 
					(ISNULL(@Street,'') = '' OR A.Street = @Street)
				and 
					(ISNULL(@county,'')= '' OR A.County = @County)
				and 
					(ISNULL(@CountyCode,'')='' OR A.CountyCode = @CountyCode)
				and 
					(ISNULL(@Phone,'') = '' OR A.Phone = @Phone)
				and 
					(ISNULL(@AfterHoursPhone,'') = '' OR A.AfterHoursPhone = @AfterHoursPhone)
				and	
					(ISNULL(@WebSite,'') = '' OR A.WebSite = @WebSite)
				and 
					(ISNULL(@BusStop,'') = '' OR A.BusStop = @BusStop)
				and 
					(ISNULL(@Accessibility,'') = '' OR A.Accessibility = @Accessibility)
				and 
					(ISNULL(@BusRoute,'') = '' OR A.BusRoute = @BusRoute)
				and 
					(ISNULL(@BuildingSign,'') = '' OR A.BuildingSign = @BuildingSign)
				and 
					(ISNULL(@Walkin,'') = '' OR  A.Walkin = @Walkin)
				and 
					(ISNULL(@OfficeName,'') = '' OR A.MedicalGroup like '%' + @OfficeName + '%')
				and 
					(ISNULL(@FederallyQualifiedHC,'') = '' OR  A.FederallyQualifiedHC = @FederallyQualifiedHC)
				and 
				(
				    (ISNULL(@SearchMethod,'') = '' and A.City = @City)
				or  (@SearchMethod = 'L'
					  and @intMilesModifier * acos(cos(radians(@CenterPoint_lat)) * cos(radians(A.Latitude)) * cos(radians(A.Longitude)
																													- radians(@CenterPoint_lng))
												   + sin(radians(@CenterPoint_lat)) * sin(radians(A.Latitude))) <= @Radius Or A.City = @City) 
				or (ISNULL(@SearchMethod,'')='' and ISNULL(@City,'')='')
						) 
				and 
					(ISNULL(@IsInternal,'') = '' and ISNULL(A.IsInternalOnly,0) = 0 and ISNULL(AF.IsInternalOnly,0) = 0 or @IsInternal =1 )
	
---------------------------------------------------------------

	

      --/* Provider Language */ 
		select Distinct PL.LanguageID
			   ,PL.ProviderID
			   ,L.LanguageID
			   ,L.Description
			   ,L.ISOCode
			from search.Languages L with (nolock)
				inner join search.ProviderLanguage PL with (nolock)
					on L.LanguageID = PL.LanguageID
				inner join #scope
					on PL.ProviderID = #scope.provid 
     -- WHERE  ( ( PL.languageid = @Language ) OR ( @Language IS NULL ) OR (@Language = @languageid) ) 

      --/* Affiliations */ 
		select distinct A.AffiliationID
			   ,A.ProviderID
			   ,A.DirectoryID
			   ,A.LOB
			   ,A.Panel
			   ,A.IPAName
			   ,A.IPAGroup
			   ,A.IPACode
			   ,A.IPAParentCode
			   ,A.IPADesc
			   ,A.HospitalName
			   ,A.ProviderType
			   ,A.AffiliationType
			   ,A.AgeLimit
			   ,A.AcceptingNewMbr
			   ,A.EffectiveDate
			   ,A.TerminationDate
			   ,A.HospitalID
			   ,A.IsHospitalAdmitter
			   ,A.AcceptingNewMemberCode
			   ,ALT.AgeLimitDescription as AgeLimitDescription
			   ,A.AddressID
			from search.Affiliation A with (nolock)
				inner join #scope
					on A.ProviderID = #scope.provid
				left join search.AgeLimits as ALT
					on A.AgeLimit = ALT.AgeLimit
					   and ALT.AgeLimitDescription <> 'FEMALE ALL AGES'
			where 	(ISNULL(@LineofBusiness,'') = '' OR A.LOB = @LineofBusiness or A.LOB = 'all lobs')
				and 
					    (ISNULL(@IPAAffiliation,'') = '' OR A.IPACode = @IPAAffiliation OR A.IPAParentCode = @IPAAffiliation)
				and 
						(ISNULL(@Panel,'') = '' OR A.Panel = @Panel)
				and 
						(ISNULL(@DirectoryID,'') = '' OR A.DirectoryID = @DirectoryId)
				and 
						(ISNULL(@HospitalName,'') = '' OR  A.HospitalName = @HospitalName)
				and 
						(ISNULL(@Age,'') = '' OR A.AgeLimit in (Select distinct age from @AgeLimit ))
				and 
						(ISNULL(@IsHospitalAdmitter,'') = '' OR A.IsHospitalAdmitter = @IsHospitalAdmitter)
				and 
						(ISNULL(@Acceptingnewmembers,'') = '' OR A.AcceptingNewMbr = @Acceptingnewmembers)	 
				and 
						(ISNULL(@IsInternal,'') = '' and ISNULL(a.IsInternalOnly,0) = 0 or @IsInternal =1 )
				and		(
						@IsInternal = 1 and  A.EffectiveDate >= @now
						and @ShowFuture = 1
						or ISNULL(@ShowFuture,0) = 0
						)
				and		(
						@IsInternal = 1 and 
						  A.TerminationDate <= @now
						  and @ShowTermed = 1
						 or ISNULL(@ShowTermed,0) = 0
						)


      --/* Provider Extended Properties */ 
		select Distinct PA.ProviderID
			   ,PA.PropertyName
			   ,PA.PropertyValue
			from search.ProviderExtendedProperties PA with (nolock)
				inner join #scope
					on PA.ProviderID = #scope.provid

      --/* Provider Speacialties */ 
		select distinct S.SpecialtyID
			   ,S.SpecialtyCode
			   ,S.SpecialtyDesc
			   ,S.ServiceIdentifier
			   ,S.Category
			   ,PS.ProviderID
			   ,PS.BoardCertified
			from search.Specialty S with (nolock)
				inner join search.ProviderSpecialty PS with (nolock)
					on PS.SpecialtyID = S.SpecialtyID
				inner join #scope with (nolock)
					on PS.ProviderID = #scope.provid 

      --/* Address Languages */ 
		select distinct AL.LanguageID
			   ,AL.AddressID
			   ,AL.Type
			   ,L.LanguageID
			   ,L.Description
			   ,L.ISOCode
			from search.Languages L
				inner join search.AddressLanguage AL with (nolock)
					on L.LanguageID = AL.LanguageID
				inner join search.Address A with (nolock)
					on AL.AddressID = A.AddressID
				inner join #scope
					on A.ProviderID = #scope.provid; 

		drop table #scope
	
/* Drop all temp tables and Indexes created */
	
					Drop INDEX IdX_C_Add_ProvId ON search.Address
					Drop INDEX IdX_C_Aff_ProvId ON search.affiliation
					Drop INDEX IdX_C_SPEC_ProvId ON search.ProviderSpecialty
					Drop INDEX IdX_C_Lang_ProvId ON search.ProviderLanguage
				--	Drop table #scope
	END
GO
/****** Object:  StoredProcedure [Search].[GetProviderList]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- ================================================================================
-- Authors:    Tony Do, Sheetal Soni 
-- Create date: ~7/1/2016 
-- Description: Return Provider List which meet filtered conditions
--              and page number within page size.    
-- ================================================================================
CREATE PROCEDURE [Search].[GetProviderList] -- Add the parameters for the     
  @Age                                         DATETIME = NULL, 
  @AffiliationDependencyRequired               BIT = 0, 
  @AffiliationPanelExclusionList               [search].[AFFILIATIONPANELLIST] readonly, 
  @AffiliationLobExclusionList                 [search].[AFFILIATIONLOBLIST] readonly, 
  @AppointmentNeeded                           BIT = 0, 
  @Acceptingnewmembers                         BIT = 0, 
  @AfterHoursPhone                             VARCHAR(10) = NULL, 
  @Accessibility                               VARCHAR(50) = NULL, 
  @BusStop                                     INT = 0, 
  @BusRoute                                    VARCHAR(30) = NULL, 
  @BuildingSign                                VARCHAR(100) = NULL, 
  @Contractstatus                              DATE = NULL, 
  @City                                        VARCHAR(30) = NULL, 
  @CenterPoint_lat                             FLOAT = 0.0, 
  @CenterPoint_lng                             FLOAT = 0.0, 
  @County                                      VARCHAR(30) = NULL, 
  @CountyCode                                  INT = 0, 
  @DiamProviderId                              VARCHAR(12) = NULL, 
  @DirectoryId                                 VARCHAR(12) = NULL, 
  @DoctorTypes                                 [search].[DOCTORTYPES] readonly, 
  @Email                                       VARCHAR(50) = NULL, 
  @EnablePaging                                BIT = 0, 
  @Facility                                    BIT = 0, 
  @Fax                                         VARCHAR(10) = NULL, 
  @FederallyQualifiedHC                        BIT = 0, 
  @FirstNameSearch							   VARCHAR(100) = NULL,
  @Gender                                      VARCHAR(6) = NULL, 
  @HospitalAffiliation                         VARCHAR(12) = NULL, 
  @HospitalName                                VARCHAR(100) = NULL, 
  @IPAAffiliation                              VARCHAR(3) = NULL, 
  @intMilesModifier                            INT = 0, 
  @IsHospitalAdmitter                          BIT = 0, 
  @Internal                                    BIT = 0, 
  @LicenseNumber                               VARCHAR(15) = NULL, 
  @Language                                    INT = NULL, 
  @LastNameSearch							   VARCHAR(100) = NULL,
  @LineofBusiness                              VARCHAR(3) = NULL, 
  @MediCalPanel206                             [search].[PANELLOBLIST] readonly, 
  @NetProviderId                               VARCHAR(12) = NULL, 
  @NationalProviderId                          VARCHAR(10) = NULL, 
  @Name                                        VARCHAR(100) = NULL, 
  @OfficeName                                  VARCHAR(100) = NULL, 
  @ProviderType                                VARCHAR(15) = NULL, 
  @ProviderExtenedPropertiesDependencyRequired BIT = 0, 
  @ProviderSpecialtyDependencyRequired         BIT = 0, 
  @Phone                                       VARCHAR(10) = NULL, 
  @PageNumber                                  INT = 0, 
  @PageSize                                    INT = 0, 
  @Panel                                       VARCHAR(3) = NULL, 
  @Radius                                      INT = 0, 
  @Specialty                                   INT = 0, 
  @ShowTermed                                  BIT = 0, 
  @ShowFuture                                  BIT = 0, 
  @SortBy                                      VARCHAR(50), 
  @SearchMethod                                VARCHAR(1) = NULL, 
  @Street                                      VARCHAR(100) = NULL, 
  @WebSite                                     VARCHAR(100) = NULL, 
  @Walkin                                      BIT = 0, 
  @ZipCode                                     VARCHAR(9) = NULL ,  
  @StatusCode								   VARCHAR(3) = Null,
  @Showversion								   BIT = 0
 ,@ShowReturn								   BIT = 0
as
	begin 
		/*
			Modification Log:
				11/11/2016	1.00	SS		Modified SP, Added ShowVersion,ShowRetrun Parmeters.
				11/11/2016	1.01	SS		Corrected Where condition for InternalOnly
				11/14/2016  1.02    TD      Removed Isnull functions, Isnull function causes 3x+ slower
		*/

		/* ---------------------------------------------------------------- */
		-- ADD STORED PROCEDURE VERSION FOR SYSTEM ADMINISTRATOR MANAGEMENT
		/* ---------------------------------------------------------------- */		
		declare @Version varchar(100) = '11/11/2016 2:22 Version 1.00'
		declare @ReturnValues table
			(
			 ReturnCode int primary key
							not null
			,Reason varchar(200) not null
			)

		insert into @ReturnValues
				(ReturnCode, Reason)
			values (0, 'Normal Return')			
											
		if @Showversion = 1
			begin
				select object_schema_name(@@PROCId) as SchemaName
					   ,object_name(@@PROCId) as ProcedureName
					   ,@Version as VersionInformation
				if isnull(@ShowReturn, 0) = 0
					return 0
			end

		if @ShowReturn = 1
			begin
				select *
					from @ReturnValues
				return 0
			end

		/* ------------------------------------ */
		-- BEGIN STORED PROCEDURE CODES LOGIC
		/* ------------------------------------ */

      -- SET NOCOUNT ON added to prevent extra result sets from 
      -- interfering with SELECT statements. 
		SET nocount ON; 
		
	   DECLARE @ProviderTypes AS Table
	   (
		  ProviderType varchar(15)
	   )

	   INSERT INTO @ProviderTypes 
	   SELECT * FROM search.Split(@ProviderType,',')

	  

      --------------------------------
	  -- PRIVATE VARIABLES
	  --------------------------------
		DECLARE @returnedRecordCount INT = 0, 
              @xml                 XML, 
			  @EnglishLanguage     VARCHAR (7),
              @ageDiff             FLOAT = NULL, 
              @month               FLOAT = NULL,
			  @now				   date = getdate();
     
	  --------------------------------
	  -- PRIVATE OBJECT VARIABLES
	  --------------------------------
		DECLARE @AgeLimit TABLE ( age VARCHAR(15) ) 

	  -- If tempdb..#scope already existed then drop/delete it
		IF object_id('tempdb..#scope') is not null DROP TABLE #scope 
	  
	  -- CREATE #scope private object varible
		CREATE TABLE #scope (provid int not null,FirstName varchar(50),LastName varchar(30),OrganizationName varchar(200),Distance float,pageNumber int default(0),totalCount int default(0)); 

	  -- If tempdb..#scope2 already existed then drop/delete it
		IF object_id('tempdb..#scope2') is not null DROP TABLE #scope2 

	 -- CREATE #scope2 private object varible
		CREATE TABLE #scope2 (provid int not null,FirstName varchar(50),LastName varchar(30),OrganizationName varchar(200),Distance float,pageNumber int default(0),totalCount int default(0)); 

	  --------------------------------
	  -- BUILT AGE LIST DEFINITION		
	  --------------------------------	
	  --Get Age difference if 
	  SELECT @ageDiff = datediff(year, @Age, @now) 

	  --If age difference is less than a year then get months 
	  IF (@ageDiff = 0) 			
		BEGIN
			SET @month = datediff(month, @Age, @now) 
			--Get agediff minnimum value 
			SELECT @ageDiff = @month / 12																	
		END

		-- PULL DATA FROM TABLE AND SET TO @AgeLimit PRIVATE OBJECT VARIBLE
		INSERT INTO  @AgeLimit
		SELECT DISTINCT AgeLimit FROM search.AgeLimits with (nolock) 
		--Select age code into @Agelimit between for the age diff  
		WHERE (@ageDiff between AgeLimitMin and AgeLimitMax) OR (@ageDiff is null); 

		
	----------------------------------------------------------------------------------------------
	--Exclude Enligsh from search filters becuase it is default and not assigned to any providers
	----------------------------------------------------------------------------------------------
		DECLARE @languageid VARCHAR(2)
		SET @languageid = (SELECT LanguageID FROM search.Languages WHERE [Description] = 'English')
		
		IF(@EnglishLanguage = 'English') SET @Language = null
     
      /*************************************** 
      ----- Identify Matching Providers ------
      ***************************************/ 
	  
	  -- GET PROVIDERS which meet filtering conditions And SET to #scope object variable
	  -----------------------------------------------------------------------------------
		INSERT #scope (provid,FirstName,LastName,OrganizationName) SELECT DISTINCT P.ProviderID,P.FirstName,P.LastName,P.OrganizationName FROM search.Provider P
		WHERE 
				(	P.IsEnabled = 1 And	
				@Name is null
				  OR	(		(P.LastName IS NOT NULL AND P.LastName LIKE '%' + @Name + '%') 
							OR	(P.FirstName IS NOT NULL AND P.FirstName LIKE '%' + @Name + '%')
							OR	(P.PreferredFirstName IS NOT NULL AND P.PreferredFirstName LIKE '%' + @Name + '%')
							OR	( (P.FirstName IS NOT NULL AND P.FirstName  LIKE '%' + @FirstNameSearch + '%') AND (P.LastName IS NOT NULL AND P.LastName LIKE '%' + @LastNameSearch + '%' )  )
							OR  (P.OrganizationName IS NOT NULL AND P.OrganizationName LIKE '%' + @Name + '%')
						) 								
				)
				AND ( P.DiamProvID like '%'+@DiamProviderID+'%'	OR @DiamProviderID IS NULL		)
				AND ( P.NetDevProvID = @NetProviderID OR @NetProviderID IS NULl					)
				AND (	 (@Facility <> 1 and P.ProviderType = @ProviderType)
					  OR (@Facility = 1 and P.ProviderType in ('ANC', 'DANC', 'NPP') and @ProviderType is null)	--For other providers
					  OR ( @Facility <> 1 and @ProviderType is null)
					  
					)
				AND ( @Gender IS NULL OR P.Gender = @Gender )
				AND ( @NationalProviderId is null OR P.NPI like '%' + @NationalProviderId + '%' )						
				AND ( @LicenseNumber is null OR	 P.License like '%' + @LicenseNumber + '%'		)
				AND ( @Internal = 1 or (P.IsInternalOnly is null or P.IsInternalOnly = @Internal))
				AND ((@ProviderType = 'PCP' and @Acceptingnewmembers = 1 and p.MembershipStatus = 'Accepting New Patients')
					OR (@ProviderType = 'PCP' and @Acceptingnewmembers = 0 and p.MembershipStatus In (SELECT DISTINCT SP.MembershipStatus FROM search.Provider Sp WHERE Sp.MembershipStatus <> 'Accepting New Patients'))
					OR (@Acceptingnewmembers = 0 and p.ProviderType <> 'PCP'))
	
		
		-- FILTER OUT PROVIDERS don't have any address And SET NEW RESULT to #scope2 object variable
		---------------------------------------------------------------------------------------------
		INSERT #scope2	(provid,FirstName,LastName,OrganizationName,Distance) SELECT DISTINCT P.provid,P.FirstName,p.LastName,P.OrganizationName	
		-- GET DISTANCE if search by radius
		,CASE WHEN @SearchMethod <> 'L' THEN 0.0 ELSE @intMilesModifier * acos(cos(radians(@CenterPoint_lat)) * cos(radians(A.Latitude)) * cos(radians(A.Longitude) - radians(@CenterPoint_lng))
													   + sin(radians(@CenterPoint_lat)) * sin(radians(A.Latitude))) END AS Distance	
		FROM search.Address A with (nolock) INNER JOIN #scope P ON A.ProviderID = P.provid
		WHERE (	 A.IsEnabled = 1 And	@ZipCode is null OR A.Zip = @ZipCode									)
				AND (	@Fax is null OR A.Fax = @Fax										)
				AND (	@Email is null	OR A.Email = @Email									)
				AND (	@Street is null OR A.Street = @Street								)
				AND (	@County is null OR A.County = @County								)
				AND (	@CountyCode = 0 OR A.CountyCode = @CountyCode						)
				AND (	@Phone is null OR A.Phone = @Phone									)
				AND (	@AfterHoursPhone is null OR	A.AfterHoursPhone = @AfterHoursPhone	)
				AND (	@WebSite is null OR	A.WebSite = @WebSite							)
				AND (	@BusStop = 0 OR A.BusStop = @BusStop								)
				AND (	@Accessibility is null OR	A.Accessibility = @Accessibility		)
				AND (	@BusRoute is null OR A.BusRoute = @BusRoute							)
				AND (	@BuildingSign is null OR A.BuildingSign = @BuildingSign				)
				AND (	@Walkin = 0 OR A.Walkin = @Walkin									)
				AND (	@OfficeName is null OR A.MedicalGroup like '%' + @OfficeName + '%'	)
				AND (	@FederallyQualifiedHC = 0 OR A.FederallyQualifiedHC = @FederallyQualifiedHC		)
				AND (		(@SearchMethod is null and @City is null) OR (@SearchMethod is null and A.City = @City)
						OR  (@SearchMethod = 'L'
								AND @intMilesModifier * acos(cos(radians(@CenterPoint_lat)) * cos(radians(A.Latitude)) * cos(radians(A.Longitude)
																													- radians(@CenterPoint_lng))
												   + sin(radians(@CenterPoint_lat)) * sin(radians(A.Latitude))) <= @Radius 
								OR A.City = @City ) 				
					) 
				and ( @Internal = 1 or (@Internal = 0 and a.IsInternalOnly = 0)  )	
		
		-- GET THE MOST CLOSEST LOCATIONS FOR A PROVIDER WHICH HAS MORE THAN ONE LOCATION and Set result to #scope object variable
		---------------------------------------------------------------------------------------------------------------------------
		-- Clear records in #scope
		TRUNCATE TABLE #scope;		
		INSERT INTO #scope (provid,FirstName,LastName,OrganizationName,Distance) select provid,FirstName,LastName,OrganizationName,MIN(Distance)
				FROM #scope2 group by provid,FirstName,LastName,OrganizationName
		-- Clear records in #scope2
		TRUNCATE TABLE #scope2
	
		-- GET TOTAL FOUND RECORD COUNT
		DECLARE @providercount int = 0;
		SELECT  @providercount = count(*) FROM #scope
	
		-- ONLY EXECUE IF AFFILIATION REQUIRES if the searching plan is requested
		-------------------------------------------------------------------------
		IF @AffiliationDependencyRequired = 1
		BEGIN
			/* Exclude MED if Panel is 206 */
			DECLARE @Panel206 varchar(15),@Panel206Lob varchar(50)
			SELECT TOP 1 @Panel206=PanelId,@Panel206Lob=Lob FROM @MediCalPanel206

			


			-- FILTER OUT ADDRESSES don't have any affiliation And SET NEW RESULT to #scope2 object variable
			------------------------------------------------------------------------------------------------
			INSERT #scope2 (provid,FirstName,LastName,OrganizationName,Distance) SELECT DISTINCT P.provid,P.FirstName,p.LastName,P.OrganizationName,p.Distance
				FROM [search].[Address] adr WITH (nolock) INNER JOIN  [search].affiliation A WITH (nolock) ON adr.AddressId = A.AddressId
						INNER JOIN #scope P ON A.providerid = P.provid LEFT JOIN @AgeLimit AS AL ON al.age = a.agelimit 
						LEFT JOIN [search].agelimits AS ALT ON a.agelimit = alt.agelimit AND Alt.agelimitdescription <> 'FEMALE ALL AGES' 
			WHERE		(A.IsEnabled = 1 
			        AND	     @LineofBusiness is null OR A.lob IN(@LineofBusiness,'All LOBs') OR (@LineofBusiness = 'MM' and A.IPACode in ('MMD','01X','00X'))
			        AND      A.LOB not in (select lob from @AffiliationLobExclusionList)) 
					AND (   A.Panel is null OR  (A.Panel not in (select panelid from @AffiliationPanelExclusionList))) --and @LineofBusiness <> 'MM' OR @LineofBusiness IS NULL) OR (@LineofBusiness = 'MM' AND A.Panel in  (select panelid from @AffiliationPanelExclusionList))  )
					AND (	@Panel is null or A.Panel = @Panel ) 
					AND (	@IPAAffiliation IS NULL OR ( A.ipacode = @IPAAffiliation or A.IPAParentCode = @IPAAffiliation) )            		
					AND (	@DirectoryId IS NULL OR A.directoryid = @DirectoryId ) 
					AND (	@HospitalName IS NULL or P.OrganizationName = @HospitalName OR  A.hospitalname = @HospitalName ) 
					AND (	@Age IS NULL OR A.agelimit IN ( al.age ) 	)				
					AND (	@IsHospitalAdmitter = 0 or  A.IsHospitalAdmitter = @IsHospitalAdmitter	)
					--AND (   (A.ProviderType = 'PCP' and A.AcceptingNewMbr = @Acceptingnewmembers) OR (A.ProviderType <> 'PCP' and a.AcceptingNewMbr in (1,0,null) )) 
					
					AND	(	@Internal = 1 
						OR	(		( @Internal = A.IsInternalOnly) AND	( A.EffectiveDate is null or  A.EffectiveDate <= @now)					 
							  AND	( A.TerminationDate is null or A.TerminationDate >= @now ) )
							)
					
					
					AND (A.Panel is null OR A.Panel <> @Panel206 OR A.LOB <> @Panel206Lob )
					AND (A.AcceptingNewMemberCode = @StatusCode or @StatusCode is null)

		--	Clear records in #scope
		TRUNCATE TABLE #scope;
		--	Transfer data from #scope2 to #scope1
		INSERT INTO #scope select * from #scope2		
		-- Clear records in #scope2
		TRUNCATE TABLE #scope2

		END

  
		-- ONLY EXECUE IF PROVIDER EXTENED PROPERTIES REQUIRES if the searching plan is requested
		-----------------------------------------------------------------------------------------
		IF @ProviderExtenedPropertiesDependencyRequired = 1
		BEGIN
			-- FILTER OUT PROVIDERS don't have any Extended Properties And SET NEW RESULT to #scope2 object variable
			--------------------------------------------------------------------------------------------------------
			INSERT #scope2 (provid,FirstName,LastName,OrganizationName,Distance) SELECT distinct P.provid,P.FirstName,p.LastName,P.OrganizationName,p.Distance
				FROM search.ProviderExtendedProperties A WITH (NOLOCK) INNER JOIN #scope P ON A.ProviderID = P.provid
			
			-- Clear records in #scope
			TRUNCATE TABLE #scope;
			-- Transfer data from #scope2 to #scope
			INSERT INTO #scope select * from #scope2
			-- Clear records in #scope2
			TRUNCATE TABLE #scope2
		END

		-- ONLY EXECUE IF PROVIDER SPECIALTY REQUIRES if the searching plan is requested
		-----------------------------------------------------------------------------------------
		IF @ProviderSpecialtyDependencyRequired = 1
		BEGIN
			-- Get Doctor Type Count to enhanced Search
			DECLARE @DoctorTypeCount int
			SELECT  @DoctorTypeCount = count(*) FROM @DoctorTypes

			-- FILTER OUT PROVIDERS don't have any Specialties And SET NEW RESULT to #scope2 object variable
			------------------------------------------------------------------------------------------------
			INSERT #scope2 (provid,FirstName,LastName,OrganizationName,Distance) SELECT distinct P.provid,P.FirstName,p.LastName,P.OrganizationName,p.Distance		
				FROM search.ProviderSpecialty PS WITH (NOLOCK)	INNER JOIN search.Specialty sp  WITH (NOLOCK) ON PS.SpecialtyID = sp.SpecialtyID				
					INNER JOIN	#scope P WITH (NOLOCK) ON PS.ProviderID = P.provid 
			WHERE (	@Specialty = 0 OR	PS.SpecialtyID = @Specialty	)
					AND ( @DoctorTypeCount = 0 Or (1 in (select PATINDEX(([type] + '%'),sp.SpecialtyDesc)  from @DoctorTypes ))	)  --(sp.SpecialtyDesc in (select * from @DoctorTypes))	)

			-- Clear records in #scope
			TRUNCATE TABLE #scope;
			-- Transfer data from #scope2 to #scope
			INSERT INTO #scope select * from #scope2
			-- Clear records in #scope2
			TRUNCATE TABLE #scope2
		END

   
		IF @SortBy = 'OrganizationName' CREATE CLUSTERED INDEX IdX_C_Prov_ProvId ON #Scope(OrganizationName)
		ELSE
		BEGIN
			IF @SortBy = 'FirstName' CREATE CLUSTERED INDEX IdX_C_Prov_FirstName ON #Scope(FirstName);
			ELSE				
				IF @SortBy = 'LastName' CREATE CLUSTERED INDEX IdX_C_Prov_ProvId ON #Scope(LastName)				
				ELSE CREATE CLUSTERED INDEX IdX_C_Prov_ProvId ON #Scope(PROVId)							
		END
	
		
		-- Capture total record count before pagination starts
		-------------------------------------------------------
		SELECT @returnedRecordCount = count(*) FROM #scope;
		
		-------------------------------------	      
		------------- Pagination ------------ 
		-------------------------------------	      
		IF @EnablePaging = 1
		BEGIN 
								
			IF (@SortBy = 'ProviderId' or @SortBy = 'Distance')
			Begin
			
				WITH pagedprovider
					AS (	SELECT provid,pagedProviderCount = row_number() over (order by CASE @SortBy when 'Distance' Then Distance else provid End ) FROM #scope )
								INSERT #scope2 (provid,Distance,pageNumber) SELECT  scope.provid,scope.Distance,pagedprovider.pagedProviderCount 
									FROM pagedprovider INNER JOIN #scope as scope ON pagedprovider.provid = scope.provid
									WHERE pagedprovider.pagedProviderCount BETWEEN (((@PageNumber - 1) * @PageSize) + 1) AND	   @PageNumber * @PageSize 
			End
		ELSE
			Begin			
				WITH pagedprovider
					AS (	SELECT provid,pagedProviderCount = row_number() over (order by CASE @SortBy when 'FirstName' Then FirstName when 'OrganizationName' Then OrganizationName else LastName End) FROM #scope )
						INSERT #scope2 (provid,Distance,pageNumber) SELECT  scope.provid,scope.Distance,pagedprovider.pagedProviderCount 
								FROM pagedprovider INNER JOIN #scope AS scope ON pagedprovider.provid = scope.provid
								WHERE pagedprovider.pagedProviderCount BETWEEN (((@PageNumber - 1) * @PageSize) + 1) AND @PageNumber * @PageSize 
			End
						
			-- Clear records in #scope
			TRUNCATE TABLE #scope;
			-- Transfer data from #scope2 to #scope
			INSERT INTO #scope select * from #scope2
			-- Clear records in #scope2
			TRUNCATE TABLE #scope2
		END 

		---------------------------------------------------
		------------- RETRIEVE AND RETURN DATA ------------ 
		---------------------------------------------------      
		SELECT  ProviderID, DiamProvID, P.FirstName, P.LastName, Gender, P.OrganizationName, License
			   , NPI, ProviderType, NetDevProvID, s.Distance, @returnedRecordCount as TotalCount,p.MembershipStatus,p.PreferredFirstName
			FROM search.Provider P WITH (NOLOCK) INNER JOIN #scope s ON P.ProviderID = s.provid	
			ORDER BY s.pageNumber	
			
	END



GO
/****** Object:  StoredProcedure [Search].[GetProviders]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================= 
-- Authors:    Avinash Jonnalagadda, Sheetal Soni, Brandon Kepke 
-- Create date: ~7/1/2016 
-- Description:   
-- ============================================= 
-- exec [search].GetProviders @ProviderType='PCP',@SearchMethod='L', @Radius=4,@CenterPoint_lng=34.117693,@CenterPoint_lat=-117.779531
CREATE procedure [Search].[GetProviders] -- Add the parameters for the     
	@DiamProviderId varchar(12) = null
   ,@NetProviderId varchar(12) = null
   ,@NationalProviderId varchar(10) = null
   ,@LicenseNumber varchar(15) = null
   ,@ProviderType varchar(15) = null
   ,@LineofBusiness varchar(3) = null
   ,@Specialty int = 0
   ,@Name varchar(100) = null
   ,@Gender varchar(6) = null
   ,@Language varchar(2) = null
   ,@HospitalAffiliation varchar(12) = null
   ,@IPAAffiliation varchar(3) = null
   ,@Acceptingnewmembers bit = 0
   ,@Contractstatus date = null
   ,@City varchar(30) = null
   ,@Email varchar(24) = null
   ,@ShowTermed bit = 0
   ,@ShowFuture bit = 0
   ,@Fax varchar(10) = null
   ,@intMilesModifier int = 0
   ,@SearchMethod varchar(1) = null
   ,@CenterPoint_lat float = 0
   ,@CenterPoint_lng float = 0
   ,@Radius int = 0
   ,@Age datetime = null
   ,@ZipCode varchar(9) = null
   ,@Panel varchar(15) = null
   ,@DirectoryId varchar(20) = null
   ,@HospitalName varchar(100) = null
   ,@Street varchar(100) = null
   ,@County varchar(30) = null
   ,@CountyCode int = 0
   ,@Phone varchar(10) = null
   ,@AfterHoursPhone varchar(10) = null
   ,@WebSite varchar(100) = null
   ,@BusStop int = 0
   ,@BusRoute varchar(30) = null
   ,@Accessibility varchar(50) = null
   ,@Walkin bit = 0
   ,@BuildingSign varchar(100) = null
   ,@AppointmentNeeded bit = 0
   ,@DoctorTypes varchar(max) = null
   ,@PageNumber int = 0
   ,@PageSize int = 0
   ,@EnablePaging bit = 0
   ,@IsHospitalAdmitter bit = 0
   ,@FederallyQualifiedHC bit = 0
   ,@Internal bit = 0
   ,@OfficeName varchar(100) = null
   ,@Facility bit = 0
   ,@ProviderID int = 0
    ,@StatusCode   VARCHAR(3) = Null
as
	begin 
      -- SET NOCOUNT ON added to prevent extra result sets from 
      -- interfering with SELECT statements. 
		set nocount on; 

		declare @now date = getdate()
		declare @xml xml
		   ,@ageDiff float = null
		   ,@month float = null; 
		declare @AgeLimit table (age varchar(max)) 

		select @ageDiff = datediff(year, @Age, @now)															--Get Age difference if 
		if (@ageDiff = 0) 
																												 --If age difference is less than a year then get months 
			begin 
				set @month = datediff(month, @Age, @now) 

				select @ageDiff = @month / 12																	--Get agediff minnimum value 
			end 

		insert into @AgeLimit
			select distinct AgeLimit
				from search.AgeLimits with (nolock) 
																												  --Select age code into @Agelimit between for the age diff  
				where (@ageDiff between AgeLimitMin and AgeLimitMax)
					or (@ageDiff is null); 


		if object_id('tempdb..#scope') is not null
		drop table #scope 
		create table #scope (provid int not null); 
	-----------------------------------------------------------------------------------
	--Exclude Enligsh from search filters becuase it is default and not assigned to any providers
		declare @languageid varchar(2)
		set @languageid = (
						   select LanguageID
							from search.Languages
							where Description = 'English'
						  )
	
     
      /*************************************** 
      ----- Identify Matching Providers ------                              -- 
      ***************************************/ 
		insert #scope
			select distinct P.ProviderID
				from search.Provider P
					Inner join search.Address AD with (nolock)
						on P.ProviderID = AD.ProviderID
					left join search.Affiliation A with (nolock)
						on P.ProviderID = A.ProviderID
					left join search.ProviderSpecialty PS with (nolock)
						on P.ProviderID = PS.ProviderID
					left join search.Specialty sp with (nolock)
						on PS.SpecialtyID = sp.SpecialtyID
					left join search.ProviderLanguage PL with (nolock)
						on PL.ProviderID = P.ProviderID
					left join @AgeLimit AL
						on AL.age = A.AgeLimit
				
				where  (
						 (isnull(P.LastName, '') like '%' + @Name + '%')
						 or (isnull(P.FirstName, '') like '%' + @Name + '%')
						 or left(ISNULL(P.FirstName,''), charindex(' ', ISNULL(P.FirstName,'')) - 0) + ISNULL(P.LastName,'') like '%'+@Name+'%'
						 Or Isnull(P.FirstName,'') +' '+ ISnull(P.LastName,'') like '%'+@Name+'%'
						 or (isnull(P.OrganizationName, '') like '%' + @Name + '%')
						 or (@Name is null)
						)
					and (
							P.DiamProvID like '%'+@DiamProviderID+'%'
						OR @DiamProviderID IS NULL
						)
					and 
						(	P.NetDevProvID = @NetProviderID 
						OR @NetProviderID IS NULl
						)
					and 
						(
						(@Facility <> 1 and P.ProviderType = @ProviderType)
						 or (@Facility = 1 and P.ProviderType in ('ANC', 'DANC', 'NPP') and @ProviderType is null)	--For other providers
						 or ( @Facility <> 1 and @ProviderType is null)
						)
					and (
						P.Gender = @Gender
						 or @Gender IS NULL
						 )
					and  (
						 P.NPI like '%' + @NationalProviderId + '%'
						 or @NationalProviderId is null
						 )
						
					and (
						 P.License like '%' + @LicenseNumber + '%'
						 or @LicenseNumber is null
						)
					and (
						 
						  A.IPACode = @IPAAffiliation
						  or A.IPAParentCode = @IPAAffiliation
						  or @IPAAffiliation is null
						)
					and (
						 AD.Zip = @ZipCode
						 or @ZipCode is null
						)
					and (
						 AD.Fax = @Fax
						 or @Fax is null
						)
					and (
						 A.LOB = @LineofBusiness
						 or A.LOB = 'all lobs'
						 or @LineofBusiness is null
						)
					and (
						sp.SpecialtyID = @Specialty
						 or @Specialty = 0
						)
					and (
						 
						  A.EffectiveDate >= @now
						  and @ShowFuture = 1
						 or @ShowFuture = 0
						)
					and (
						 
						  A.TerminationDate <= @now
						  and @ShowTermed = 1
						 or @ShowTermed = 0
						)
					and (
					    (@SearchMethod IS NULL and AD.City = @City)
					or  (@SearchMethod = 'L' 
						  and @intMilesModifier * acos(cos(radians(@CenterPoint_lat)) * cos(radians(AD.Latitude)) * cos(radians(AD.Longitude)
																														- radians(@CenterPoint_lng))
													   + sin(radians(@CenterPoint_lat)) * sin(radians(AD.Latitude))) <= @Radius Or AD.City = @City)
					or (@SearchMethod is null and @City IS null)
						)

					and (
						 AD.Email = @Email
						 or @Email is null
						)
					and (
						 A.Panel = @Panel
						 or @Panel is null
						)
					and (
						 A.DirectoryID = @DirectoryId
						 or @DirectoryId is null
						)
					and (
						 A.HospitalName = @HospitalName
						 or P.OrganizationName = @HospitalName
						 or @HospitalName is null
						)
					and (
						 AD.Street = @Street
						 or @Street is null
						)
					and (
						 AD.County = @County
						 or @County is null
						)
					and (
						AD.Walkin = @Walkin
						 or @Walkin = 0
						)
					and (
						 AD.FederallyQualifiedHC = @FederallyQualifiedHC
						 or @FederallyQualifiedHC = 0
						)
					and (
						 AD.CountyCode = @CountyCode
						 or @CountyCode = 0
						)
					and (
						 AD.MedicalGroup like '%' + @OfficeName + '%'
						 or @OfficeName is null
						)
					and (
						 AD.Phone = @Phone
						 or @Phone is null
						)
					and (
						 AD.AfterHoursPhone = @AfterHoursPhone
						 or @AfterHoursPhone is null
						)
					and (
						 AD.WebSite = @WebSite
						 or @WebSite is null
						)
					and (
						 AD.BusStop = @BusStop
						 or @BusStop = 0
						)
					and (
						 AD.Accessibility = @Accessibility
						 or @Accessibility is null
						)
					and (
						 AD.BusRoute = @BusRoute
						 or @BusRoute is null
						)
					and (
						 PL.LanguageID = @Language
						 or @Language is null
						 or @Language = @languageid
						)
					and (
						 AD.BuildingSign = @BuildingSign
						 or @BuildingSign is null
						)
					and (
						 
						  @DoctorTypes is not null
						  and sp.SpecialtyDesc in (select *
													from Split(@DoctorTypes, ','))
						 or @DoctorTypes is null
						)
					and (
						 A.AgeLimit in (AL.age)
						 or @Age is null
						)
					and (
						 A.IsHospitalAdmitter = @IsHospitalAdmitter
						 or @IsHospitalAdmitter = 0
						)
					and (
						 A.AcceptingNewMbr = @Acceptingnewmembers
						)
								
					and (@Internal = 0 and ISNULL(P.IsInternalOnly,0) = 0 or @Internal = 1)
					and (P.ProviderID = @ProviderID  or @ProviderID = 0)
					AND P.IsEnabled = 1
						AND (A.AcceptingNewMemberCode = @StatusCode or @StatusCode is null)
						; 
		CREATE CLUSTERED INDEX IdX_C_Prov_ProvId ON #Scope(PROVId)
      /*************************************** 
      ------------- Pagination ------------ 
      ***************************************/ 
		if (@EnablePaging = 1) 
        --Create temp table to store paginated results 
			begin 
				Declare @temp table (provid int not null);

        --CREATE CLUSTERED INDEX IdX_C_Prov_ProvId ON #temp(PROVId) 
        ; 
				with	pagedprovider
						  as (
							  select provid
								   ,pagedProviderCount = row_number() over (order by provid)
								from #scope
							 )
					insert @temp
						select scope.provid --into #temp 
							from pagedprovider
								inner join #scope as scope
									on pagedprovider.provid = scope.provid
							where pagedprovider.pagedProviderCount between (((@PageNumber - 1) * @PageSize) + 1)
																   and	   @PageNumber * @PageSize 

            --ORDER BY PROVId; 
				Truncate table #scope 

				insert into #scope
					select *
						from @temp 
			end 

  /*************************************** 
  ------------- Retrieve Data ------------ 
  ***************************************/ 
      /* Providers */ 
		select Distinct ProviderID
			   ,DiamProvID
			   ,FirstName
			   ,LastName
			   ,Gender
			   ,OrganizationName
			   ,License
			   ,NPI
			   ,ProviderType
			   ,NetDevProvID
			from search.Provider P with (nolock)
				inner join #scope
					on P.ProviderID = #scope.provid;
	


      --/* Addresses */ 
		select Distinct A.AddressID
			   ,A.ProviderID
			   ,rtrim(A.Street+' '+ISNULL(A.Street2,'')) AS Street
			   ,A.Street AS Street1
			   ,A.Street2 AS Street2
			   ,A.City
			   ,A.Zip
			   ,A.County
			   ,A.CountyCode
			   ,A.Phone
			   ,A.AfterHoursPhone
			   ,A.Fax
			   ,A.Email
			   ,A.WebSite
			   ,A.BusStop
			   ,A.BusRoute
			   ,A.Accessibility
			   ,A.Walkin
			   ,A.BuildingSign
			   ,A.AppointmentNeeded
			   ,A.Hours
			   ,A.Latitude
			   ,A.Longitude
			   ,A.LocationID
			   ,A.MedicalGroup
			   ,A.ContractID
			   ,A.FederallyQualifiedHC
			   ,A.State
			   ,case when @SearchMethod = 'L' 
						  and @intMilesModifier * acos(cos(radians(@CenterPoint_lat)) * cos(radians(A.Latitude)) * cos(radians(A.Longitude)
																														- radians(@CenterPoint_lng))
													   + sin(radians(@CenterPoint_lat)) * sin(radians(A.Latitude))) <= @Radius or A.City = @City
					 then @intMilesModifier * acos(cos(radians(@CenterPoint_lat)) * cos(radians(A.Latitude)) * cos(radians(A.Longitude)
																												   - radians(@CenterPoint_lng))
												   + sin(radians(@CenterPoint_lat)) * sin(radians(A.Latitude)))
					 else ''
				end as Distance
			from search.Address A with (nolock)
			Left Join Search.Affiliation af with (nolock) on Af.addressID = A.AddressID and a.providerID= af.providerId
				inner join #scope
					on A.ProviderID = #scope.provid
			where --(
				 --  A.City = @City
				 --  or @City is null
				--  )
				--and
				 (
					 A.Zip = @ZipCode
					 or @ZipCode is null
					)
				and (
					 A.Fax = @Fax
					 or @Fax is null
					)
				and (
					 A.Email = @Email
					 or @Email is null
					)
				and (
					 A.Street = @Street
					 or @Street is null
					)
				and (
					 A.County = @County
					 or @County is null
					)
				and (
					 A.CountyCode = @CountyCode
					 or @CountyCode = 0
					)
				and (
					 A.Phone = @Phone
					 or @Phone is null
					)
				and (
					 A.AfterHoursPhone = @AfterHoursPhone
					 or @AfterHoursPhone is null
					)
				and (
					 A.WebSite = @WebSite
					 or @WebSite is null
					)
				and (
					 A.BusStop = @BusStop
					 or @BusStop = 0
					)
				and (
					 A.Accessibility = @Accessibility
					 or @Accessibility is null
					)
				and (
					 A.BusRoute = @BusRoute
					 or @BusRoute is null
					)
				and (
					 A.BuildingSign = @BuildingSign
					 or @BuildingSign is null
					)
				and (
					 A.Walkin = @Walkin
					 or @Walkin = 0
					)
				and (
					 A.MedicalGroup like '%' + @OfficeName + '%'
					 or @OfficeName is null
					)
				and (
					 A.FederallyQualifiedHC = @FederallyQualifiedHC
					 or @FederallyQualifiedHC = 0
					)
				and (
				    (@SearchMethod IS NULL and A.City = @City)
				or  (@SearchMethod = 'L'
					  and @intMilesModifier * acos(cos(radians(@CenterPoint_lat)) * cos(radians(A.Latitude)) * cos(radians(A.Longitude)
																													- radians(@CenterPoint_lng))
												   + sin(radians(@CenterPoint_lat)) * sin(radians(A.Latitude))) <= @Radius Or A.City = @City) 
				or (@SearchMethod is null and @City IS null)
						) 
				and (@Internal = 0 and ISNULL(a.IsInternalOnly,0) = 0 and ISNULL(AF.IsinternalOnly,0) = 0 or  @Internal =1 )	
				AND a.IsEnabled = 1
					
					 --MCC 
					 Order by A.City
     -- ORDER  BY #scope.provid 



      --/* Provider Language */ 
		select Distinct PL.LanguageID
			   ,PL.ProviderID
			   ,L.LanguageID
			   ,L.Description
			   ,L.ISOCode
			from search.Languages L with (nolock)
				inner join search.ProviderLanguage PL with (nolock)
					on L.LanguageID = PL.LanguageID
				inner join #scope
					on PL.ProviderID = #scope.provid 
     -- WHERE  ( ( PL.languageid = @Language ) OR ( @Language IS NULL ) OR (@Language = @languageid) ) 

      --/* Affiliations */ 
		select distinct A.AffiliationID
			   ,A.ProviderID
			   ,A.DirectoryID
			   ,A.LOB
			   ,A.Panel
			   ,A.IPAName
			   ,A.IPAGroup
			   ,A.IPACode
			   ,A.IPAParentCode
			   ,A.IPADesc
			   ,A.HospitalName
			   ,A.ProviderType
			   ,A.AffiliationType
			   ,A.AgeLimit
			   ,A.AcceptingNewMbr
			   ,A.EffectiveDate
			   ,A.TerminationDate
			   ,A.HospitalID
			   ,A.IsHospitalAdmitter
			   ,A.AcceptingNewMemberCode
			   ,ALT.AgeLimitDescription as AgeLimitDescription
			   ,A.AddressID
			   ,MC.CodeLabel as NewMemberCodeLabel
			   ,MC.CodeDescription as NewMemberCodeDescription
			from search.Affiliation A with (nolock)
				inner join #scope
					on A.ProviderID = #scope.provid
				left join @AgeLimit as AL
					on AL.age = A.AgeLimit
				left join search.AgeLimits as ALT with (nolock)
					on A.AgeLimit = ALT.AgeLimit
					   and ALT.AgeLimitDescription <> 'FEMALE ALL AGES'
				left join search.AcceptingNewMemberCodes MC with (nolock)
					on MC.StatusCode = A.AcceptingNewMemberCode
			where (
				   A.LOB = @LineofBusiness
				   or A.LOB = 'all lobs'
				   or @LineofBusiness is null
				  )
				and (
					 
					  A.IPACode = @IPAAffiliation
					  or A.IPAParentCode = @IPAAffiliation
					 
					 or @IPAAffiliation is null
					)
				and (
					 A.Panel = @Panel
					 or @Panel is null
					)
				and (
					 A.DirectoryID = @DirectoryId
					 or @DirectoryId is null
					)
				and (
					 A.HospitalName = @HospitalName
					 or @HospitalName is null
					)
				and (
					  A.AgeLimit in (AL.age)
					 or @Age is null
					)
				and (
					 A.IsHospitalAdmitter = @IsHospitalAdmitter
					 or @IsHospitalAdmitter = 0
					)
				and (
					 A.AcceptingNewMbr = @Acceptingnewmembers
					 or @Acceptingnewmembers = 0
					)		 
				and  (@Internal = 0 and ISNUll(a.IsInternalOnly,0) = 0 or  @Internal =1 )	
				 and (
					@Internal = 1  and @ShowFuture = 1
					 and  A.EffectiveDate >= @now
						 or @ShowFuture = 0
						)
					and (
						@Internal = 1 and @ShowTermed = 1 
						and A.TerminationDate <= @now
						 or @ShowTermed = 0
						)
						AND a.IsEnabled = 1
							AND (A.AcceptingNewMemberCode = @StatusCode or @StatusCode is null)


      --/* Provider Extended Properties */ 
		select Distinct PA.ProviderID
			   ,PA.PropertyName
			   ,PA.PropertyValue
			from search.ProviderExtendedProperties PA with (nolock)
				inner join #scope
					on PA.ProviderID = #scope.provid

      --/* Provider Speacialties */ 
		select distinct 
			T.SpecialtyID
			  ,T.SpecialtyCode
			   ,T.SpecialtyDesc
			   ,T.ServiceIdentifier
			   ,T.Category
			   ,T.ProviderID
			   ,T.BoardCertified

			   FROM (SELECT S.*,PS.ProviderID,PS.BoardCertified, ROW_NUMBER() OVER ( PARTITION BY S.SpecialtyDesc ORDER BY S.SpecialtyDesc DESC ) AS ranking 
			   	from search.Specialty S with (nolock)
				inner join search.ProviderSpecialty PS with (nolock)
					on PS.SpecialtyID = S.SpecialtyID
				inner join #scope with (nolock)
					on PS.ProviderID = #scope.provid 
					) T WHERE T.ranking = 1

      --/* Address Languages */ 
		select distinct AL.LanguageID
			   ,AL.AddressID
			   ,AL.Type
			   ,L.LanguageID
			   ,L.Description
			   ,L.ISOCode
			from search.Languages L
				inner join search.AddressLanguage AL with (nolock)
					on L.LanguageID = AL.LanguageID
				inner join search.Address A with (nolock)
					on AL.AddressID = A.AddressID
				inner join #scope
					on A.ProviderID = #scope.provid; 

		if object_id('tempdb..#scope') is not null
		drop table #scope 
	end 
/*     ___________ 
______/ Unit Test \_________________________________________________________________ 


DECLARE 
  @DiamProviderId      VARCHAR(12) = NULL, 
  @NetProviderId       VARCHAR(12) = NULL, 
  @NationalProviderId  VARCHAR(10) = NULL, 
  @LicenseNumber       VARCHAR(15) = NULL, 
  @ProviderType        VARCHAR(15) = null, 
  @LineofBusiness      VARCHAR(3) = NULL, 
  @Specialty           INT = 0, 
  @Name                VARCHAR(100) = NULL, 
  @Gender              VARCHAR(6) = NULL, 
  @Language            VARCHAR(2) = '13', 
  @HospitalAffiliation VARCHAR(12) = NULL, 
  @IPAAffiliation      VARCHAR(3) = NULL, 
  @Acceptingnewmembers BIT = 0, 
  @Contractstatus      DATE = NULL, 
  @City                VARCHAR(30) = NULL, 
  @Email               VARCHAR(24) = NULL, 
  @ShowTermed          BIT = 0, 
  @ShowFuture          BIT = 0, 
  @Fax                 VARCHAR(10) = NULL, 
  @intMilesModifier    INT = 0, 
  @SearchMethod        VARCHAR(1) = NULL, 
  @CenterPoint_lat     FLOAT = 0, 
  @CenterPoint_lng     FLOAT = 0, 
  @Radius              INT = 0, 
  @Age                 DATETIME = NULL, 
  @ZipCode             VARCHAR(9) = NULL, 
  @Panel               VARCHAR(15) = NULL, 
  @DirectoryId         VARCHAR(20) = NULL, 
  @HospitalName        VARCHAR(100) = NULL, 
  @Street              VARCHAR(100) = NULL, 
  @County              VARCHAR(30) = NULL, 
  @CountyCode          INT = 0, 
  @Phone               VARCHAR(10) = NULL, 
  @AfterHoursPhone     VARCHAR(10) = NULL, 
  @WebSite             VARCHAR(100) = NULL, 
  @BusStop             INT = 0, 
  @BusRoute            VARCHAR(30) = NULL, 
  @Accessibility       VARCHAR(50) = NULL, 
  @Walkin              BIT = 0, 
  @BuildingSign        VARCHAR(100) = NULL, 
  @AppointmentNeeded   BIT = 0, 
  @DoctorTypes         VARCHAR(max) = NULL, 
  @PageNumber          INT = 0, 
  @PageSize            INT = 0, 
  @EnablePaging        BIT = 0,
  @IsHospitalAdmitter  BIT =0,
  @FederallyQualifiedHC BIT =0 


        



EXEC [search].[GetProviders] 
   @DiamProviderId, 
@NetProviderId , 
@NationalProviderId , 
@LicenseNumber , 
@ProviderType , 
@LineofBusiness , 
@Specialty ,  
@Name , 
@Gender , 
@Language , 
@HospitalAffiliation , 
@IPAAffiliation , 
@Acceptingnewmembers , 
@Contractstatus, 
@City  , 
@Email , 
@ShowTermed , 
   @ShowFuture , 
@Fax , 
@intMilesModifier , 
@SearchMethod , 
@CenterPoint_lat , 
   @CenterPoint_lng, 
@Radius , 
@Age , 
@ZipCode , 
@Panel , 
@DirectoryId , 
@HospitalName , 
@Street , 
@County , 
@CountyCode , 
@Phone , 
@AfterHoursPhone , 
@WebSite , 
@BusStop , 
@BusRoute , 
@Accessibility , 
@Walkin , 
@BuildingSign, 
@AppointmentNeeded , 
  @DoctorTypes, 
@PageNumber , 
@PageSize, 
@EnablePaging,
      @IsHospitalAdmitter,
  @FederallyQualifiedHC  


____________________________________________________________________________________ 

*/ 
----By Provider Id 
--declare @ProviderId varchar(12) = '000000000103' 
--select * from Diam_725_App.diamond.jprovfm0_dat F where F.PAPROVId = @ProviderId 
--select * from Diam_725_App.diamond.jprovcm0_dat F where F.PBPROVId = @ProviderId 
--select * from Diam_725_App.diamond.jprovam0_dat F where F.PCPROVId = @ProviderId 
----By NPI 
--declare @Npi varchar(12) = '1205945250', @ProviderId varchar(12) = '' 
--select @ProviderId = F.PAPROVId FROM Diam_725_App.diamond.jprovfm0_dat F where F.PANATLId = @Npi
--select * from Diam_725_App.diamond.jprovfm0_dat F where F.PAPROVId = @ProviderId 
--select * from Diam_725_App.diamond.jprovcm0_dat F where F.PBPROVId = @ProviderId 
--select * from Diam_725_App.diamond.jprovam0_dat F where F.PCPROVId = @ProviderId 
----By License 
--declare @License varchar(12) = 'NP21908', @ProviderId varchar(12) = '' 
--select @ProviderId = F.PAPROVId FROM Diam_725_App.diamond.jprovfm0_dat F where F.PAUSERDEF5 = @License
--select * from Diam_725_App.diamond.jprovfm0_dat F where F.PAPROVId = @ProviderId 
--select * from Diam_725_App.diamond.jprovcm0_dat F where F.PBPROVId = @ProviderId 
--select * from Diam_725_App.diamond.jprovam0_dat F where F.PCPROVId = @ProviderId 
----select * from [search].Provider where providertype = 'UC' 
----select * from [search].Provider where npi = 1588042576 
----Get Distinct Provider Types Form [search].Provider 
----select distinct id,ProviderType from [search].Provider where providertype='pcp' 
----select p.Id,a.id from [search].address A 
--  right outer join [search].provider P on P.Id=A.ProviderId where P.providertype='uc'
--  and A.Id IS NULL 


GO
/****** Object:  StoredProcedure [Search].[GetProviders_test]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ============================================= 
-- Authors:    Avinash Jonnalagadda, Sheetal Soni, Brandon Kepke 
-- Create date: ~7/1/2016 
-- Description:   
-- ============================================= 
-- exec [search].GetProviders @ProviderType='PCP',@SearchMethod='L', @Radius=4,@CenterPoint_lng=34.117693,@CenterPoint_lat=-117.779531
CREATE Procedure [Search].[GetProviders_test] 
  -- Add the parameters for the     
  @DiamProviderID      VARCHAR(12) = NULL, 
  @NetProviderID       VARCHAR(12) = NULL, 
  @NationalProviderID  VARCHAR(10) = NULL, 
  @LicenseNumber       VARCHAR(15) = NULL, 
  @ProviderType        VARCHAR(15) = NULL, 
  @LineofBusiness      VARCHAR(3) = NULL, 
  @Specialty           INT = 0, 
  @Name                VARCHAR(100) = NULL, 
  @Gender              VARCHAR(6) = NULL, 
  @Language            VARCHAR(2) = NULL, 
  @HospitalAffiliation VARCHAR(12) = NULL, 
  @IPAAffiliation      VARCHAR(3) = NULL, 
  @Acceptingnewmembers BIT = 0, 
  @Contractstatus      DATE = NULL, 
  @City                VARCHAR(30) = NULL, 
  @Email               VARCHAR(24) = NULL, 
  @ShowTermed          BIT = 0, 
  @ShowFuture          BIT = 0, 
  @Fax                 VARCHAR(10) = NULL, 
  @intMilesModifier    INT = 0, 
  @SearchMethod        VARCHAR(1) = NULL, 
  @CenterPoint_lat     FLOAT = 0, 
  @CenterPoint_lng     FLOAT = 0, 
  @Radius              INT = 0, 
  @Age                 DATETIME = NULL, 
  @ZipCode             VARCHAR(9) = NULL, 
  @Panel               VARCHAR(15) = NULL, 
  @DirectoryID         VARCHAR(20) = NULL, 
  @HospitalName        VARCHAR(100) = NULL, 
  @Street              VARCHAR(100) = NULL, 
  @County              VARCHAR(30) = NULL, 
  @CountyCode          INT = 0, 
  @Phone               VARCHAR(10) = NULL, 
  @AfterHoursPhone     VARCHAR(10) = NULL, 
  @WebSite             VARCHAR(100) = NULL, 
  @BusStop             INT = 0, 
  @BusRoute            VARCHAR(30) = NULL, 
  @Accessibility       VARCHAR(50) = NULL, 
  @Walkin              BIT = 0, 
  @BuildingSign        VARCHAR(100) = NULL, 
  @AppointmentNeeded   BIT = 0, 
  @DoctorTypes         VARCHAR(max) = NULL, 
  @PageNumber          INT = 0, 
  @PageSize            INT = 0, 
  @EnablePaging        BIT = 0,
  @IsHospitalAdmitter  BIT =0,
  @FederallyQualifiedHC BIT =0,
  @Internal				BIT = 0,
  @OfficeName			VARCHAR(100) = NULL,
  @Facility				BIT = 0,
  @ReturnFullInfo		BIT = 0,
  @ProviderID			INT = 0,
 @ReturnObject			Varchar(200) = 'Provider'


AS 
  BEGIN 
      -- SET NOCOUNT ON added to prevent extra result sets from 
      -- interfering with SELECT statements. 
      SET nocount ON; 
	  DECLARE @providers bit = 0, @Affiliation bit = 0, @Address bit = 0, @ProviderExtendedProperties bit = 0, @ProviderSpecialties bit = 0,@AddressLanguages bit = 0, @ProviderLanguages bit = 0
	  DECLARE @now datetime = getdate()
	  SET @ReturnObject = ',' + @ReturnObject + ',';
	  SET @providers = CASE WHEN CHARINDEX(',Provider,',@ReturnObject) > 0 THEN 1 ELSE 0 END
	  SET @Affiliation = CASE WHEN CHARINDEX(',affiliation,',@ReturnObject) > 0 THEN 1 ELSE 0 END
	  SET @Address = CASE WHEN CHARINDEX(',address,',@ReturnObject) > 0 THEN 1 ELSE 0 END
	  SET @ProviderExtendedProperties = CASE WHEN CHARINDEX(',ProviderExtendedProperties,',@ReturnObject) > 0 THEN 1 ELSE 0 END
	  SET @ProviderSpecialties = CASE WHEN CHARINDEX(',ProviderSpecialties,',@ReturnObject) > 0 THEN 1 ELSE 0 END
	  SET @AddressLanguages = CASE WHEN CHARINDEX(',AddressLanguages,',@ReturnObject) > 0 THEN 1 ELSE 0 END
	  SET @ProviderLanguages = CASE WHEN CHARINDEX(',ProviderLanguages,',@ReturnObject) > 0 THEN 1 ELSE 0 END
	  
      DECLARE @xml     XML, 
              @ageDiff FLOAT = NULL, 
              @month   FLOAT = NULL; 
      DECLARE @AgeLimit TABLE 
        ( 
           age VARCHAR(max) 
        ) 

      SELECT @ageDiff = Datediff(year, @Age, Getdate()) --Get Age difference if 
      IF ( @ageDiff = 0 ) 
        --If age difference is less than a year then get months 
        BEGIN 
            SET @month = Datediff(month, @Age, Getdate()) 

            SELECT @ageDiff = @month / 12 --Get agediff minnimum value 
        END 

      INSERT INTO @AgeLimit 
      SELECT DISTINCT agelimit 
      FROM   [search].agelimits WITH (nolock) 
      --Select age code into @Agelimit between for the age diff  
      WHERE  ( @ageDiff BETWEEN agelimitmin AND agelimitmax ) 
              OR ( @ageDiff IS NULL ); 


      CREATE TABLE #scope 
        ( 
           provid INT NOT NULL 
        ); 

IF(@ProviderID <> 0)		--If searchID is passed to get his details
BEGIN
		insert into #scope (provid) values(@ProviderID)
END


IF( (Select count(provid) from #scope) < 1)	--if searchID is not passed
BEGIN	
						-----------------------------------------------------------------------------------
		--Exclude Enligsh from search filters becuase it is default and not assigned to any providers
		Declare 
		@languageid varchar(2)
		set @languageid = (select languageID from [search].Languages where Description  = 'English')
	
      --CREATE CLUSTERED INDEX IDX_C_Prov_ProvID ON #Scope(PROVID)    
      /*************************************** 
      ----- Identify Matching Providers ------                              -- 
      ***************************************/ 
      INSERT #scope 
      SELECT DISTINCT P.providerid 
      FROM   [search].provider P 
             LEFT JOIN [search].address AD WITH (NOLOCK)
                    ON P.providerid = AD.providerid 
             LEFT JOIN [search].affiliation A WITH (NOLOCK)
                    ON P.providerid = A.providerid 
             LEFT JOIN [search].providerspecialty PS WITH (NOLOCK)
                    ON P.providerid = PS.providerid 
             LEFT JOIN [search].specialty sp WITH (NOLOCK)
                    ON PS.specialtyid = sp.specialtyid 
             LEFT JOIN [search].providerlanguage PL WITH (NOLOCK)
                    ON pl.providerid = p.providerid 
             LEFT JOIN @AgeLimit AL 
                    ON al.age = A.agelimit 
	
   where  (
						 (isnull(P.LastName, '') like '%' + @Name + '%')
						 or (isnull(P.FirstName, '') like '%' + @Name + '%')
						 or left(ISNULL(P.FirstName,''), charindex(' ', ISNULL(P.FirstName,'')) - 0) + ISNULL(P.LastName,'') like '%'+@Name+'%'
						 Or Isnull(P.FirstName,'') +' '+ ISnull(P.LastName,'') like '%'+@Name+'%'
						 or (isnull(P.OrganizationName, '') like '%' + @Name + '%')
						 or (@Name is null)
						)
					and (
							P.DiamProvID like '%'+@DiamProviderID+'%'
						OR @DiamProviderID IS NULL
						)
					and 
						(	P.NetDevProvID = @NetProviderID 
						OR @NetProviderID IS NULl
						)
					and 
						(
						(@Facility <> 1 and P.ProviderType = @ProviderType)
						 or (@Facility = 1 and P.ProviderType in ('ANC', 'DANC', 'NPP') and @ProviderType is null)	--For other providers
						 or ( @Facility <> 1 and @ProviderType is null)
						)
					and (
						P.Gender = @Gender
						 or @Gender IS NULL
						 )
					and  (
						 P.NPI like '%' + @NationalProviderId + '%'
						 or @NationalProviderId is null
						 )
						
					and (
						 P.License like '%' + @LicenseNumber + '%'
						 or @LicenseNumber is null
						)
					and (
						 
						  A.IPACode = @IPAAffiliation
						  or A.IPAParentCode = @IPAAffiliation
						  or @IPAAffiliation is null
						)
					and (
						 AD.Zip = @ZipCode
						 or @ZipCode is null
						)
					and (
						 AD.Fax = @Fax
						 or @Fax is null
						)
					and (
						 A.LOB = @LineofBusiness
						 or A.LOB = 'all lobs'
						 or @LineofBusiness is null
						)
					and (
						sp.SpecialtyID = @Specialty
						 or @Specialty = 0
						)
					and (
						 
						  A.EffectiveDate >= @now
						  and @ShowFuture = 1
						 or @ShowFuture = 0
						)
					and (
						 
						  A.TerminationDate <= @now
						  and @ShowTermed = 1
						 or @ShowTermed = 0
						)
					and (
					    (@SearchMethod IS NULL and AD.City = @City)
					or  (@SearchMethod = 'L' 
						  and @intMilesModifier * acos(cos(radians(@CenterPoint_lat)) * cos(radians(AD.Latitude)) * cos(radians(AD.Longitude)
																														- radians(@CenterPoint_lng))
													   + sin(radians(@CenterPoint_lat)) * sin(radians(AD.Latitude))) <= @Radius Or AD.City = @City)
					or (@SearchMethod is null and @City IS null)
						)

					and (
						 AD.Email = @Email
						 or @Email is null
						)
					and (
						 A.Panel = @Panel
						 or @Panel is null
						)
					and (
						 A.DirectoryID = @DirectoryId
						 or @DirectoryId is null
						)
					and (
						 A.HospitalName = @HospitalName
						 or P.OrganizationName = @HospitalName
						 or @HospitalName is null
						)
					and (
						 AD.Street = @Street
						 or @Street is null
						)
					and (
						 AD.County = @County
						 or @County is null
						)
					and (
						AD.Walkin = @Walkin
						 or @Walkin = 0
						)
					and (
						 AD.FederallyQualifiedHC = @FederallyQualifiedHC
						 or @FederallyQualifiedHC = 0
						)
					and (
						 AD.CountyCode = @CountyCode
						 or @CountyCode = 0
						)
					and (
						 AD.MedicalGroup like '%' + @OfficeName + '%'
						 or @OfficeName is null
						)
					and (
						 AD.Phone = @Phone
						 or @Phone is null
						)
					and (
						 AD.AfterHoursPhone = @AfterHoursPhone
						 or @AfterHoursPhone is null
						)
					and (
						 AD.WebSite = @WebSite
						 or @WebSite is null
						)
					and (
						 AD.BusStop = @BusStop
						 or @BusStop = 0
						)
					and (
						 AD.Accessibility = @Accessibility
						 or @Accessibility is null
						)
					and (
						 AD.BusRoute = @BusRoute
						 or @BusRoute is null
						)
					and (
						 PL.LanguageID = @Language
						 or @Language is null
						 or @Language = @languageid
						)
					and (
						 AD.BuildingSign = @BuildingSign
						 or @BuildingSign is null
						)
					and (
						 
						  @DoctorTypes is not null
						  and sp.SpecialtyDesc in (select *
													from Split(@DoctorTypes, ','))
						 or @DoctorTypes is null
						)
					and (
						 A.AgeLimit in (AL.age)
						 or @Age is null
						)
					and (
						 A.IsHospitalAdmitter = @IsHospitalAdmitter
						 or @IsHospitalAdmitter = 0
						)
					and (
						 A.AcceptingNewMbr = @Acceptingnewmembers
						 or @Acceptingnewmembers = 0
						)
								
					and (@Internal = 0 and ISNULL(P.IsInternalOnly,0) = 0 or @Internal = 1)
					and (P.ProviderID = @ProviderID  or @ProviderID = 0)
						; 
		CREATE CLUSTERED INDEX IdX_C_Prov_ProvId ON #Scope(PROVId)
END
      /*************************************** 
      ------------- Pagination ------------ 
      ***************************************/ 
      IF ( @EnablePaging = 1 ) 
        --Create temp table to store paginated results 
        BEGIN 
            CREATE TABLE #temp 
              ( 
                 provid INT NOT NULL 
              ); 

        --CREATE CLUSTERED INDEX IDX_C_Prov_ProvID ON #temp(PROVID) 
        ; 
            WITH pagedprovider 
                 AS (SELECT provid, 
                            pagedProviderCount = Row_number() 
                                                   OVER ( 
                                                     ORDER BY provid) 
                     FROM   #scope) 
            INSERT #temp 
            SELECT scope.provid --into #temp 
            FROM   pagedprovider 
                   INNER JOIN #scope AS scope 
                           ON pagedprovider.provid = scope.provid 
            WHERE  pagedprovider.pagedprovidercount BETWEEN ( 
                   ( ( @PageNumber - 1 ) * @PageSize ) + 1 ) AND 
                   @PageNumber * @PageSize 

            --ORDER BY PROVID; 
            TRUNCATE TABLE #scope 

            INSERT INTO #scope 
            SELECT * 
            FROM   #temp 
        END 

  /*************************************** 
  ------------- Retrieve Data ------------ 
  ***************************************/ 
      /* Providers */ 
 IF(@providers = 1 OR @ReturnFullInfo = 1)
 Begin
      SELECT 

	   [ProviderID]
      ,[DiamProvID]
      ,[FirstName]
      ,[LastName]
      ,[Gender]
      ,[OrganizationName]
      ,[License]
      ,[NPI]
      ,[ProviderType]
      ,[NetDevProvID] 

      FROM   [search].provider P WITH (NOLOCK)
      INNER JOIN #scope ON P.providerid = #scope.provid

ENd 

IF( (@Address = 1) OR (@Address = 1 and @ProviderID <> 0 ) OR (@providers = 1) OR (@ReturnFullInfo = 1))
BEGIN
      --/* Addresses */ 
      SELECT 
	   A.[AddressID]
      ,A.[ProviderID]
      ,A.[Street]
      ,A.[City]
      ,A.[Zip]
      ,A.[County]
      ,A.[CountyCode]
      ,A.[Phone]
      ,A.[AfterHoursPhone]
      ,A.[Fax]
      ,A.[Email]
      ,A.[WebSite]
      ,A.[BusStop]
      ,A.[BusRoute]
      ,A.[Accessibility]
      ,A.[Walkin]
      ,A.[BuildingSign]
      ,A.[AppointmentNeeded]
      ,A.[Hours]
      ,A.[Latitude]
      ,A.[Longitude]
      ,A.[LocationID]
      ,A.[MedicalGroup]
      ,A.[ContractID]
      ,A.[FederallyQualifiedHC]
      ,A.[State]
      ,CASE 
               WHEN @SearchMethod = 'L' 
                    AND ( @intMilesModifier * Acos(Cos(Radians(@CenterPoint_lat) 
                                                   ) 
                                                   * 
                                                   Cos( 
                                                         Radians(A.latitude)) * 
                                                   Cos( 
                                                         Radians(A.longitude) 
                                                         - Radians( 
                                                         @CenterPoint_lng)) + 
                          Sin(Radians(@CenterPoint_lat) 
                          ) * Sin( 
                          Radians(A.latitude))) <= 
                          @Radius ) 
             THEN 
               @intMilesModifier * Acos(Cos(Radians(@CenterPoint_lat)) * 
             Cos( 
             Radians(A.latitude)) * 
             Cos 
                                        ( 
                                        Radians(A.longitude) - Radians( 
                                        @CenterPoint_lng)) + 
                                        Sin(Radians(@CenterPoint_lat)) * Sin( 
                                        Radians(A.latitude))) 
               ELSE '' 
             END AS Distance 
      FROM   [search].address A WITH (nolock) 
             INNER JOIN #scope ON A.providerid = #scope.provid 
			 
      WHERE  ( ( A.city = @City ) 
                OR ( @City IS NULL ) ) 
             AND ( ( A.zip = @ZipCode ) 
                    OR ( @ZipCode IS NULL ) ) 
             AND ( ( A.fax = @Fax ) 
                    OR ( @Fax IS NULL ) ) 
             AND ( ( A.email = @Email ) 
                    OR ( @Email IS NULL ) ) 
             AND ( ( A.street = @Street ) 
                    OR ( @Street IS NULL ) ) 
             AND ( ( A.county = @County ) 
                    OR ( @County IS NULL ) ) 
             AND ( ( A.countycode = @CountyCode ) 
                    OR ( @CountyCode = 0 ) ) 
             AND ( ( A.phone = @Phone ) 
                    OR ( @Phone IS NULL ) ) 
             AND ( ( A.afterhoursphone = @AfterHoursPhone ) 
                    OR ( @AfterHoursPhone IS NULL ) ) 
             AND ( ( A.website = @WebSite ) 
                    OR ( @WebSite IS NULL ) ) 
             AND ( ( A.busstop = @BusStop ) 
                    OR ( @BusStop = 0 ) ) 
             AND ( ( A.accessibility = @Accessibility ) 
                    OR ( @Accessibility IS NULL ) ) 
             AND ( ( A.busroute = @BusRoute ) 
                    OR ( @BusRoute IS NULL ) ) 
             AND ( ( A.buildingsign = @BuildingSign ) 
                    OR ( @BuildingSign IS NULL ) ) 
			AND ((A.Walkin = @Walkin) 
				    OR (@Walkin =0 ))
			AND ( ( A.MedicalGroup LIKE '%'+@OfficeName+'%' ) 
                    OR ( @OfficeName IS NULL ) ) 
			AND ((A.FederallyQualifiedHC = @FederallyQualifiedHC) 
				    OR (@FederallyQualifiedHC =0 ))	
				             AND ( ( @SearchMethod = 'L' 
                     AND @intMilesModifier * Acos(Cos(Radians(@CenterPoint_lat)) 
                                                  * 
                                                  Cos 
                                                  ( 
                                                      Radians(A.latitude)) * 
                                                  Cos 
                                                  ( 
                         Radians(A.longitude) - Radians( 
                         @CenterPoint_lng)) + 
                                                  Sin(Radians(@CenterPoint_lat)) 
                                                  * Sin( 
                                                  Radians(A.latitude))) <= 
                         @Radius 
                   ) 
                    OR ( @SearchMethod IS NULL ) ) --MCC 
    
	END 

IF( (@ProviderLanguages = 1) OR  (@ProviderLanguages = 1 and @ProviderID <> 0) OR ( @providers = 1) OR (@ReturnFullInfo = 1) )
      --/* Provider Language */ 
      SELECT 
	   PL.[LanguageID]
      ,PL.[ProviderID]
	  ,L. [LanguageID]
      ,L.[Description]
      ,L.[ISOCode] 
      FROM   [search].languages L WITH (nolock) 
      INNER JOIN [search].providerlanguage PL WITH (nolock) ON L.languageid = PL.languageid 
      INNER JOIN #scope ON PL.providerid = #scope.provid 
  

IF( (@affiliation = 1) OR (@affiliation = 1 and @ProviderID <> 0) or (@ReturnFullInfo = 1 )) 
BEGIN

      --/* Affiliations */ 
      SELECT DISTINCT 
	  
	  A.[AffiliationID]
      ,A.[ProviderID]
      ,A.[DirectoryID]
      ,A.[LOB]
      ,A.[Panel]
      ,A.[IPAName]
      ,A.[IPAGroup]
      ,A.[IPACode]
      ,A.[IPAParentCode]
      ,A.[IPADesc]
      ,A.[HospitalName]
      ,A.[ProviderType]
      ,A.[AffiliationType]
      ,A.[AgeLimit]
      ,A.[AcceptingNewMbr]
      ,A.[EffectiveDate]
      ,A.[TerminationDate]
      ,A.[HospitalID]
      ,A.[IsHospitalAdmitter]
      ,A.[AcceptingNewMemberCode]
      ,alt.agelimitdescription AS AgeLimitDescription
	  ,A.AddressID 
      FROM   [search].affiliation A WITH (nolock) 
             INNER JOIN #scope 
                     ON A.providerid = #scope.provid 
             left JOIN @AgeLimit AS AL 
                     ON al.age = a.agelimit 
             left JOIN [search].agelimits AS ALT 
                     ON a.agelimit = alt.agelimit 
                        AND Alt.agelimitdescription <> 'FEMALE ALL AGES' 
      WHERE ( ( A.lob IN(@LineofBusiness,'All LOBs') ) 
                    OR ( @LineofBusiness IS NULL ) ) 
          AND    ( ( A.ipacode = @IPAAffiliation or A.IPAParentCode = @IPAAffiliation)
                    OR ( @IPAAffiliation IS NULL ) ) 
             AND ( ( A.panel = @Panel ) 
                    OR ( @Panel IS NULL ) ) 
             AND ( ( A.directoryid = @DirectoryID ) 
                    OR ( @DirectoryID IS NULL ) ) 
             AND ( ( A.hospitalname = @HospitalName ) 
                    OR ( @HospitalName IS NULL ) ) 
             AND (( A.agelimit IN ( al.age ) 
                     OR ( @Age IS NULL ) ))
			AND ((A.IsHospitalAdmitter = @IsHospitalAdmitter) 
				OR (@IsHospitalAdmitter =0 ))
				AND ((A.AcceptingNewMbr = @Acceptingnewmembers) 
				OR (@Acceptingnewmembers =0 ))		 
END


IF( (@ProviderExtendedProperties = 1) OR (@ProviderExtendedProperties = 1 and @ProviderID <> 0) or (@ProviderExtendedProperties = 1 ) OR  (@ReturnFullInfo = 1)) 
BEGIN
      --/* Provider Extended Properties */ 
      SELECT  
	   PA.[ProviderID]
      ,PA.[PropertyName]
      ,PA.[PropertyValue]
      FROM   [search].providerextendedproperties PA WITH (nolock) 
      INNER JOIN #scope ON PA.providerid = #scope.provid
END

IF( (@ProviderSpecialties = 1) OR (@ProviderSpecialties = 1 and @ProviderID <> 0) or (@ProviderSpecialties = 1 )OR (@ReturnFullInfo = 1)) 
BEGIN
      --/* Provider Speacialties */ 
      SELECT DISTINCT 
	   S.[SpecialtyID]
      ,S.[SpecialtyCode]
      ,S.[SpecialtyDesc]
      ,S.[ServiceIdentifier]
      ,S.[Category]
      ,PS.providerid 
      ,PS.boardcertified 
      FROM   [search].specialty S WITH (nolock) 
      INNER JOIN [Search].providerspecialty PS WITH(nolock) ON PS.specialtyid = s.specialtyid 
      INNER JOIN #scope WITH (NOLOCK) ON PS.providerid = #scope.provid 

END
IF( (@AddressLanguages = 1) OR (@AddressLanguages = 1 and @ProviderID <> 0) or (@AddressLanguages = 1 ) OR (@ReturnFullInfo = 1)) 
BEGIN
      --/* Address Languages */ 
      SELECT  
	   AL.[LanguageID]
      ,AL.[AddressID]
      ,AL.[Type]
      ,L.[LanguageID]
      ,L.[Description]
      ,L.[ISOCode]
      FROM   [search].languages L 
      INNER JOIN [search].addresslanguage AL WITH (NOLOCK) ON L.languageid = AL.languageid 
             INNER JOIN [search].address A WITH (NOLOCK) ON AL.addressid = A.addressid 
             INNER JOIN #scope ON A.providerid = #scope.provid; 
END 
END

/*     ___________ 
______/ Unit Test \_________________________________________________________________ 


DECLARE 
  @DiamProviderID      VARCHAR(12) = NULL, 
  @NetProviderID       VARCHAR(12) = NULL, 
  @NationalProviderID  VARCHAR(10) = NULL, 
  @LicenseNumber       VARCHAR(15) = NULL, 
  @ProviderType        VARCHAR(15) = null, 
  @LineofBusiness      VARCHAR(3) = NULL, 
  @Specialty           INT = 0, 
  @Name                VARCHAR(100) = NULL, 
  @Gender              VARCHAR(6) = NULL, 
  @Language            VARCHAR(2) = '13', 
  @HospitalAffiliation VARCHAR(12) = NULL, 
  @IPAAffiliation      VARCHAR(3) = NULL, 
  @Acceptingnewmembers BIT = 0, 
  @Contractstatus      DATE = NULL, 
  @City                VARCHAR(30) = NULL, 
  @Email               VARCHAR(24) = NULL, 
  @ShowTermed          BIT = 0, 
  @ShowFuture          BIT = 0, 
  @Fax                 VARCHAR(10) = NULL, 
  @intMilesModifier    INT = 0, 
  @SearchMethod        VARCHAR(1) = NULL, 
  @CenterPoint_lat     FLOAT = 0, 
  @CenterPoint_lng     FLOAT = 0, 
  @Radius              INT = 0, 
  @Age                 DATETIME = NULL, 
  @ZipCode             VARCHAR(9) = NULL, 
  @Panel               VARCHAR(15) = NULL, 
  @DirectoryID         VARCHAR(20) = NULL, 
  @HospitalName        VARCHAR(100) = NULL, 
  @Street              VARCHAR(100) = NULL, 
  @County              VARCHAR(30) = NULL, 
  @CountyCode          INT = 0, 
  @Phone               VARCHAR(10) = NULL, 
  @AfterHoursPhone     VARCHAR(10) = NULL, 
  @WebSite             VARCHAR(100) = NULL, 
  @BusStop             INT = 0, 
  @BusRoute            VARCHAR(30) = NULL, 
  @Accessibility       VARCHAR(50) = NULL, 
  @Walkin              BIT = 0, 
  @BuildingSign        VARCHAR(100) = NULL, 
  @AppointmentNeeded   BIT = 0, 
  @DoctorTypes         VARCHAR(max) = NULL, 
  @PageNumber          INT = 0, 
  @PageSize            INT = 0, 
  @EnablePaging        BIT = 0,
  @IsHospitalAdmitter  BIT =0,
  @FederallyQualifiedHC BIT =0 


        



EXEC [search].[GetProviders] 
   @DiamProviderID, 
@NetProviderID , 
@NationalProviderID , 
@LicenseNumber , 
@ProviderType , 
@LineofBusiness , 
@Specialty ,  
@Name , 
@Gender , 
@Language , 
@HospitalAffiliation , 
@IPAAffiliation , 
@Acceptingnewmembers , 
@Contractstatus, 
@City  , 
@Email , 
@ShowTermed , 
   @ShowFuture , 
@Fax , 
@intMilesModifier , 
@SearchMethod , 
@CenterPoint_lat , 
   @CenterPoint_lng, 
@Radius , 
@Age , 
@ZipCode , 
@Panel , 
@DirectoryID , 
@HospitalName , 
@Street , 
@County , 
@CountyCode , 
@Phone , 
@AfterHoursPhone , 
@WebSite , 
@BusStop , 
@BusRoute , 
@Accessibility , 
@Walkin , 
@BuildingSign, 
@AppointmentNeeded , 
  @DoctorTypes, 
@PageNumber , 
@PageSize, 
@EnablePaging,
      @IsHospitalAdmitter,
  @FederallyQualifiedHC  


____________________________________________________________________________________ 

*/ 
----By Provider Id 
--declare @ProviderId varchar(12) = '000000000103' 
--select * from Diam_725_App.diamond.jprovfm0_dat F where F.PAPROVID = @ProviderId 
--select * from Diam_725_App.diamond.jprovcm0_dat F where F.PBPROVID = @ProviderId 
--select * from Diam_725_App.diamond.jprovam0_dat F where F.PCPROVID = @ProviderId 
----By NPI 
--declare @Npi varchar(12) = '1205945250', @ProviderId varchar(12) = '' 
--select @ProviderId = F.PAPROVID FROM Diam_725_App.diamond.jprovfm0_dat F where F.PANATLID = @Npi
--select * from Diam_725_App.diamond.jprovfm0_dat F where F.PAPROVID = @ProviderId 
--select * from Diam_725_App.diamond.jprovcm0_dat F where F.PBPROVID = @ProviderId 
--select * from Diam_725_App.diamond.jprovam0_dat F where F.PCPROVID = @ProviderId 
----By License 
--declare @License varchar(12) = 'NP21908', @ProviderId varchar(12) = '' 
--select @ProviderId = F.PAPROVID FROM Diam_725_App.diamond.jprovfm0_dat F where F.PAUSERDEF5 = @License
--select * from Diam_725_App.diamond.jprovfm0_dat F where F.PAPROVID = @ProviderId 
--select * from Diam_725_App.diamond.jprovcm0_dat F where F.PBPROVID = @ProviderId 
--select * from Diam_725_App.diamond.jprovam0_dat F where F.PCPROVID = @ProviderId 
----select * from [search].Provider where providertype = 'UC' 
----select * from [search].Provider where npi = 1588042576 
----Get Distinct Provider Types Form [search].Provider 
----select distinct id,ProviderType from [search].Provider where providertype='pcp' 
----select p.ID,a.id from [search].address A 
--  right outer join [search].provider P on P.Id=A.ProviderID where P.providertype='uc'
--  and A.Id IS NULL 
GO
/****** Object:  StoredProcedure [Search].[GetProvidersAddressLanguageList]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ========================================================================================
-- Authors:    Tony Do 
-- Create date: Oct 15, 2016 
-- Modified date: Nov 16, 2016
-- Description:   [search].[GetProvidersAddressLanguageList] refactored from [search].[GetProviders] 
-- Return: Language
-- ========================================================================================
CREATE procedure [Search].[GetProvidersAddressLanguageList] -- Add the parameters for the    
	@ProviderIdList [search].[ProviderIdList]	READONLY
   ,@Showversion								BIT = 0
   ,@ShowReturn								   BIT = 0
AS
BEGIN

		/*
			Modification Log:
				11/14/2016	1.00	SS		Modified SP, Added ShowVersion,ShowRetrun Parmeters.
		*/
		
		declare @now date = getdate()
		declare @Version varchar(100) = '11/14/2016 8:43 Version 1.00'
		declare @ReturnValues table
			(
			 ReturnCode int primary key
							not null
			,Reason varchar(200) not null
			)

		insert into @ReturnValues
				(ReturnCode, Reason)
			values (0, 'Normal Return')			
											
		if @Showversion = 1
			begin
				select object_schema_name(@@PROCId) as SchemaName
					   ,object_name(@@PROCId) as ProcedureName
					   ,@Version as VersionInformation
				if isnull(@ShowReturn, 0) = 0
					return 0
			end

		if @ShowReturn = 1
			begin
				select *
					from @ReturnValues
				return 0
			end

		SET NOCOUNT ON;
		--/* Address Languages */ 
		SELECT AL.LanguageID, AL.AddressID, AL.[Type], L.LanguageID, L.[Description], L.ISOCode
			FROM search.Languages L
				INNER JOIN search.AddressLanguage AL WITH (NOLOCK) ON L.LanguageID = AL.LanguageID
				INNER JOIN search.[Address] A WITH (NOLOCK) ON AL.AddressID = A.AddressID
				INNER JOIN @ProviderIdList P ON A.ProviderID = P.ProviderId 
					
END
GO
/****** Object:  StoredProcedure [Search].[GetProvidersAddressList]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================================================== 
-- Authors:    Tony Do 
-- Create date: Oct 15, 2016 
-- Modified date: Nov 16, 2016
-- Description:   [search].[GetProvidersAddressList] refactored from [search].[GetProviders] 
-- Return: Provider and Address
-- ============================================================================================== 
CREATE PROCEDURE [Search].[GetProvidersAddressList] -- Add the parameters for the     
	@Accessibility varchar(50) = null
	,@AfterHoursPhone varchar(10) = null
	,@BuildingSign varchar(100) = null
	,@BusStop int = 0
	,@BusRoute varchar(30) = null
	,@CenterPointLatitude float = 0
    ,@CenterPointLongititude float = 0
	,@City varchar(30) = null
	,@County varchar(30) = null
    ,@CountyCode int = 0
	,@Email varchar(24) = null
	,@Fax varchar(10) = null
	,@FederallyQualifiedHC bit = 0
	,@Internal bit = 0
	,@intMilesModifier int = 0
	,@OfficeName varchar(100) = null
	,@Phone varchar(10) = null
	,@ProviderIdList [search].[ProviderIdList] READONLY
	,@SearchMethod varchar(1) = null
	,@Street varchar(100) = null
	,@Radius int = 0
	,@Walkin bit = 0
	,@WebSite varchar(100) = null
	,@ZipCode varchar(9) = null
	,@Showversion								   BIT = 0
    ,@ShowReturn								   BIT = 0
AS
	begin 

		/*
			Modification Log:
				11/14/2016	1.00	SS		Modified SP, Added ShowVersion,ShowRetrun Parmeters.
		*/
		
		declare @now date = getdate()
		declare @Version varchar(100) = '11/14/2016 8:43 Version 1.00'
		declare @ReturnValues table
			(
			 ReturnCode int primary key
							not null
			,Reason varchar(200) not null
			)

		insert into @ReturnValues
				(ReturnCode, Reason)
			values (0, 'Normal Return')			
											
		if @Showversion = 1
			begin
				select object_schema_name(@@PROCId) as SchemaName
					   ,object_name(@@PROCId) as ProcedureName
					   ,@Version as VersionInformation
				if isnull(@ShowReturn, 0) = 0
					return 0
			end

		if @ShowReturn = 1
			begin
				select *
					from @ReturnValues
				return 0
			end
		
      -- SET NOCOUNT ON added to prevent extra result sets from 
      -- interfering with SELECT statements. 
		SET NOCOUNT ON;
			           
      --/* Addresses */ 
		SELECT A.AddressID, A.ProviderID,rtrim(A.Street+' '+ISNULL(A.Street2,'')) as Street, A.Street as Street1,A.Street2, A.City, A.Zip, A.County, A.CountyCode, A.Phone, A.AfterHoursPhone
			   ,A.Fax, A.Email, A.WebSite, A.BusStop, A.BusRoute, A.Accessibility, A.Walkin, A.BuildingSign, A.AppointmentNeeded
			   ,A.[Hours], A.Latitude, A.Longitude, A.LocationID, A.MedicalGroup, A.ContractID, A.FederallyQualifiedHC,A.[State]
			   ,CASE WHEN @SearchMethod = 'L' 
						  and @intMilesModifier * acos(cos(radians(@CenterPointLatitude)) * cos(radians(A.Latitude)) * cos(radians(A.Longitude)
																														- radians(@CenterPointLongititude))
													   + sin(radians(@CenterPointLatitude)) * sin(radians(A.Latitude))) <= @Radius or A.City = @City
					 THEN @intMilesModifier * acos(cos(radians(@CenterPointLatitude)) * cos(radians(A.Latitude)) * cos(radians(A.Longitude)
																												   - radians(@CenterPointLongititude))
												   + sin(radians(@CenterPointLatitude)) * sin(radians(A.Latitude)))
					 ELSE ''
				END AS Distance
			FROM search.Address A WITH (NOLOCK) INNER JOIN @ProviderIdList P ON A.ProviderID = P.ProviderId
			WHERE 
					(	A.IsEnabled = 1 )
				AND	(	@ZipCode is null OR A.Zip = @ZipCode			)
				AND (	@Fax is null OR A.Fax = @Fax					)
				AND (	@Email is null OR A.Email = @Email				)
				AND (	@Street is null OR A.Street = @Street			)
				AND (	@County is null OR A.County = @County			)
				AND (	@CountyCode = 0 OR A.CountyCode = @CountyCode	)
				AND (	@Phone is null OR  A.Phone = @Phone				)
				AND (	@AfterHoursPhone is null OR A.AfterHoursPhone = @AfterHoursPhone	)
				AND (	@WebSite is null OR A.WebSite = @WebSite		)
				AND (	@BusStop = 0 OR A.BusStop = @BusStop			)
				AND (	@Accessibility is null OR A.Accessibility = @Accessibility			)
				AND (	@BusRoute is null OR A.BusRoute = @BusRoute		)
				AND (	@BuildingSign is null OR A.BuildingSign = @BuildingSign				)
				AND (	@Walkin = 0 OR A.Walkin = @Walkin				)
				AND (	@OfficeName is null OR A.MedicalGroup like '%' + @OfficeName + '%'	)
				AND (	@FederallyQualifiedHC = 0 OR A.FederallyQualifiedHC = @FederallyQualifiedHC		)
				AND (		(	@SearchMethod is null and @City is null		)
						OR	(	@SearchMethod is null and A.City = @City	)
						OR  (	@SearchMethod = 'L'
								AND @intMilesModifier * acos(cos(radians(@CenterPointLatitude)) * cos(radians(A.Latitude)) * cos(radians(A.Longitude)
																													- radians(@CenterPointLongititude))
												   + sin(radians(@CenterPointLatitude)) * sin(radians(A.Latitude))) <= @Radius 
								Or A.City = @City	) 
				
					) 
				AND ( @Internal = 1 or (@Internal = 0 and a.IsInternalOnly = 0)  )	

			 Order by A.City		
	END
GO
/****** Object:  StoredProcedure [Search].[GetProvidersAffiliationList]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================
-- Authors:   Tony Do 
-- Create date: ~10/28/2016 
-- Modified date: 
-- Description:   [search].[GetProvidersAffiliationList]
-- Filtering Rules in this procedure should match 
--		with Affiliation section in GetSearchProviderList procedure
-- ================================================================================
CREATE Procedure [Search].[GetProvidersAffiliationList] 
 @Acceptingnewmembers bit					= 0
,@AddressIdList								[search].[AddressIdList] READONLY   
,@AffiliationPanelExclusionList				[search].[AffiliationPanelList] READONLY
,@AffiliationLobExclusionList				[search].[AffiliationLobList] READONLY     
,@Age datetime								= null
,@DirectoryId varchar(20)					= null
,@HospitalName varchar(100)					= null
,@Internal bit								= 0
,@IPAAffiliation varchar(3)					= null
,@IsHospitalAdmitter bit					= 0
,@LineofBusiness varchar(3)					= null
,@Panel varchar(15)							= null
,@ProviderIdList							[search].[ProviderIdList] READONLY    
,@StatusCode varchar(3)						= Null

,@Showversion								   BIT = 0
,@ShowReturn								   BIT = 0   
AS 
  BEGIN 
	
	  /*   ------------------------------------------------------------------------------------------------------
			Modification Log:
			11/14/2016	1.00	SS		Modified SP, Added ShowVersion,ShowRetrun Parmeters.
			11/15/2016  1.01    TD      REMOVED ISNULL FROM A.EffectiveDate and A.TerminationDate
			----------------------------------------------------------------------------------------------------
		*/
				
		declare @Version varchar(100) = '11/14/2016 8:53 Version 1.00'
		declare @ReturnValues table
			(
			 ReturnCode int primary key
							not null
			,Reason varchar(200) not null
			)

		insert into @ReturnValues
				(ReturnCode, Reason)
			values (0, 'Normal Return')			
											
		if @Showversion = 1
			begin
				select object_schema_name(@@PROCId) as SchemaName
					   ,object_name(@@PROCId) as ProcedureName
					   ,@Version as VersionInformation
				if isnull(@ShowReturn, 0) = 0
					return 0
			end

		if @ShowReturn = 1
			begin
				select *
					from @ReturnValues
				return 0
			end 

      -- SET NOCOUNT ON added to prevent extra result sets from 
      -- interfering with SELECT statements. 
      SET nocount ON; 	 
	  DECLARE @now datetime = getdate()
	  
      DECLARE 
              @ageDiff FLOAT = NULL, 
              @month   FLOAT = NULL; 
      DECLARE @AgeLimit TABLE 
        ( 
           age VARCHAR(max) 
        ) 

      SELECT @ageDiff = Datediff(year, @Age, Getdate()) --Get Age difference if 
      IF ( @ageDiff = 0 ) 
        --If age difference is less than a year then get months 
        BEGIN 
            SET @month = Datediff(month, @Age, Getdate()) 

            SELECT @ageDiff = @month / 12 --Get agediff minnimum value 
        END 

      INSERT INTO @AgeLimit 
      SELECT DISTINCT agelimit 
      FROM   [search].agelimits WITH (NOLOCK) 
      --Select age code into @Agelimit between for the age diff  
      WHERE  ( @ageDiff BETWEEN agelimitmin AND agelimitmax ) 
              OR ( @ageDiff IS NULL ); 

     
  SELECT DISTINCT 	  
	  A.[AffiliationID], A.[ProviderID], A.[DirectoryID], A.[LOB], A.[Panel], A.[IPAName],A.[IPAGroup]
      ,A.[IPACode], A.[IPAParentCode], A.[IPADesc], A.[HospitalName], A.[ProviderType], A.[AffiliationType]
      ,A.[AgeLimit], A.[AcceptingNewMbr], A.[EffectiveDate], A.[TerminationDate], A.[HospitalID], A.[IsHospitalAdmitter]
      ,A.[AcceptingNewMemberCode], alt.agelimitdescription AS AgeLimitDescription, A.AddressID ,MC.CodeLabel as NewMemberCodeLabel ,MC.CodeDescription as NewMemberCodeDescription
      FROM  
	   [search].affiliation A WITH (nolock)
             INNER JOIN [search].Provider P ON A.providerid = P.ProviderID 
             LEFT JOIN @AgeLimit AS AL ON al.age = A.agelimit 
             LEFT JOIN [search].agelimits AS ALT ON a.agelimit = alt.agelimit AND Alt.agelimitdescription <> 'FEMALE ALL AGES' 		
			 	left join search.AcceptingNewMemberCodes MC with (nolock)
					on MC.StatusCode = A.AcceptingNewMemberCode		
						
      WHERE		A.IsEnabled = 1 
			AND	A.ProviderID in (SELECT ProviderId FROM @ProviderIdList)	  
		--	AND  (	ISNULL(@LineofBusiness,'') = '' OR  A.lob IN(@LineofBusiness,'All LOBs') AND A.LOB NOT IN (SELECT lob FROM @AffiliationLobExclusionList) )				 
			AND	  (   @LineofBusiness is null OR A.lob IN(@LineofBusiness,'All LOBs')  OR(@LineofBusiness = 'MM' and A.IPACode in ('MMD','01X','00X')))
			AND	 (	ISNULL(@Panel,'') = '' OR (A.Panel = @Panel and A.Panel NOT IN (SELECT panelid FROM @AffiliationPanelExclusionList)) )                
        --  AND (   A.Panel is null OR  (A.Panel not in (select panelid from @AffiliationPanelExclusionList) and @LineofBusiness <> 'MM' OR @LineofBusiness IS NULL) OR (@LineofBusiness = 'MM' AND A.Panel in  (select panelid from @AffiliationPanelExclusionList))  )
		    AND  (	ISNULL(@IPAAffiliation,'') = '' OR ( A.ipacode = @IPAAffiliation or A.IPAParentCode = @IPAAffiliation) ) 
            AND	 (	ISNULL(@DirectoryId,'')= ''OR A.directoryid = @DirectoryId ) 
            AND	 (	ISNULL(@HospitalName,'') = '' or P.OrganizationName = @HospitalName OR  A.hospitalname = @HospitalName ) 
            AND	 (	ISNULL(@Age,'') = '' OR A.agelimit IN ( al.age ) )				
			-- Filter applies when @IsHospitalAdmitter = 1
			AND  ( @IsHospitalAdmitter = 0 or  A.IsHospitalAdmitter = @IsHospitalAdmitter )
		AND ((P.ProviderType = 'PCP' and @Acceptingnewmembers = 1 and p.MembershipStatus = 'Accepting New Patients')
					OR (p.ProviderType = 'PCP' and @Acceptingnewmembers = 0 and p.MembershipStatus In (SELECT DISTINCT SP.MembershipStatus FROM search.Provider Sp WHERE Sp.MembershipStatus <> 'Accepting New Patients'))
					OR (@Acceptingnewmembers = 0 and P.ProviderType <> 'PCP'))
	
			AND	 (		@Internal = 1 
					OR (	 ( @Internal = A.IsInternalOnly) AND (A.EffectiveDate IS NULL OR A.EffectiveDate <= @now)					 
						 AND ( A.TerminationDate is null or A.TerminationDate >= @now ) )
				 )
			AND (A.AcceptingNewMemberCode = @StatusCode or @StatusCode is null)
END

GO
/****** Object:  StoredProcedure [Search].[GetProvidersExtendedPropertyList]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ===================================================================================================== 
-- Authors:   Tony Do 
-- Create date: ~7/1/2016 
-- Modified date: ~10/18/2016
-- Description:   [search].[GetProvidersExtendedPropertyList] refactored from [search].[GetProviders] 
-- Return: Language
-- =====================================================================================================
CREATE procedure [Search].[GetProvidersExtendedPropertyList] -- Add the parameters for the    
	@ProviderIdList [search].[ProviderIdList]		READONLY
	, @Showversion									BIT = 0
    ,@ShowReturn									BIT = 0
AS
BEGIN

		/*
			Modification Log:
				11/14/2016	1.00	SS		Modified SP, Added ShowVersion,ShowRetrun Parmeters.
		*/
		
		declare @now date = getdate()
		declare @Version varchar(100) = '11/14/2016 8:55 Version 1.00'
		declare @ReturnValues table
			(
			 ReturnCode int primary key
							not null
			,Reason varchar(200) not null
			)

		insert into @ReturnValues
				(ReturnCode, Reason)
			values (0, 'Normal Return')			
											
		if @Showversion = 1
			begin
				select object_schema_name(@@PROCId) as SchemaName
					   ,object_name(@@PROCId) as ProcedureName
					   ,@Version as VersionInformation
				if isnull(@ShowReturn, 0) = 0
					return 0
			end

		if @ShowReturn = 1
			begin
				select *
					from @ReturnValues
				return 0
			end


      SET NOCOUNT ON; 
	  --/* Provider Extended Properties */  
	  SELECT PA.ProviderID, PA.PropertyName, PA.PropertyValue
			FROM search.ProviderExtendedProperties PA WITH (NOLOCK)
				  INNER JOIN @ProviderIdList P ON PA.ProviderID = P.ProviderId  AND pa.IsEnabled = 1
					
END

GO
/****** Object:  StoredProcedure [Search].[GetProvidersLanguageList]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ==========================================================================================
-- Authors:    Tony Do 
-- Create date: Oct 18, 2016 
-- Modified date: Nov 15, 2016
-- Description:   [search].[GetProvidesLanguageList] refactored from [search].[GetProviders] 
-- Return: Language
-- ========================================================================================== 
CREATE procedure [Search].[GetProvidersLanguageList] -- Add the parameters for the    
	@ProviderIdList [search].[ProviderIdList] READONLY
	,@Showversion								   BIT = 0
	,@ShowReturn								   BIT = 0
AS
BEGIN
		/*
			Modification Log:
			11/14/2016	1.00	SS		Modified SP, Added ShowVersion,ShowRetrun Parmeters.
			11/16/2016	1.01	TD		Formatted the codes.
		*/
		declare @now date = getdate()
		declare @Version varchar(100) = '11/14/2016 8:56 Version 1.00'
		declare @ReturnValues table
			(
			 ReturnCode int primary key
							not null
			,Reason varchar(200) not null
			)

		insert into @ReturnValues
				(ReturnCode, Reason)
			values (0, 'Normal Return')			
											
		if @Showversion = 1
			begin
				select object_schema_name(@@PROCId) as SchemaName
					   ,object_name(@@PROCId) as ProcedureName
					   ,@Version as VersionInformation
				if isnull(@ShowReturn, 0) = 0
					return 0
			end

		if @ShowReturn = 1
			begin
				select *
					from @ReturnValues
				return 0
			end

		SET nocount ON; 

		--/* Provider Language */ 
		SELECT PL.LanguageID, PL.ProviderID, L.LanguageID,L.[Description], L.ISOCode
			FROM search.Languages L WITH (NOLOCK)
				INNER JOIN search.ProviderLanguage PL WITH (NOLOCK) ON L.LanguageID = PL.LanguageID AND pl.IsEnabled = 1
				INNER JOIN @ProviderIdList P ON PL.ProviderID = P.ProviderId 

END

GO
/****** Object:  StoredProcedure [Search].[GetProviderSpeacialtyList]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================================================== 
-- Authors:  Tony Do 
-- Create date: Oct 15, 2016 
-- Modified date: Nov 15, 2016
-- Description:   [search].[GetProviderSpeacialtyList] refactored from [search].[GetProviders]    
-- ===============================================================================================  
CREATE PROCEDURE [Search].[GetProviderSpeacialtyList] -- Add the parameters for the     
	@ProviderId int = 0
	,@DoctorTypes  [search].[DoctorTypes]	READONLY  
	,@Showversion							BIT = 0
	,@ShowReturn							BIT = 0 
AS
	BEGIN 

		/*
			Modification Log:
				11/14/2016	1.00	SS		Modified SP, Added ShowVersion,ShowRetrun Parmeters.
		*/
		
		declare @now date = getdate()
		declare @Version varchar(100) = '11/14/2016 8:56 Version 1.00'
		declare @ReturnValues table
			(
			 ReturnCode int primary key
							not null
			,Reason varchar(200) not null
			)

		insert into @ReturnValues
				(ReturnCode, Reason)
			values (0, 'Normal Return')			
											
		if @Showversion = 1
			begin
				select object_schema_name(@@PROCId) as SchemaName
					   ,object_name(@@PROCId) as ProcedureName
					   ,@Version as VersionInformation
				if isnull(@ShowReturn, 0) = 0
					return 0
			end

		if @ShowReturn = 1
			begin
				select *
					from @ReturnValues
				return 0
			end

      -- SET NOCOUNT ON added to prevent extra result sets from 
      -- interfering with SELECT statements. 
	 SET NOCOUNT ON;
		
      --/* Provider Speacialties */ 
		SELECT distinct S.SpecialtyID, S.SpecialtyCode, S.SpecialtyDesc, S.ServiceIdentifier, S.Category, PS.ProviderID, PS.BoardCertified, S.SpanishTranslation
		FROM search.Specialty S WITH (NOLOCK) 
				INNER JOIN search.ProviderSpecialty PS WITH (NOLOCK) ON PS.SpecialtyID = S.SpecialtyID AND ps.IsEnabled = 1
		WHERE PS.ProviderID = @ProviderId AND S.SpecialtyDesc IN (SELECT * FROM @DoctorTypes)
      
	END	

GO
/****** Object:  StoredProcedure [Search].[GetProvidersSpeacialtyList]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ==============================================================================================
-- Authors:    Tony Do 
-- Create date: OCT 15, 2016 
-- Modified date: NOV 16, 2016
-- Description:   [search].[GetProviderSpeacialtyList] refactored from [search].[GetProviders]    
-- ==============================================================================================
CREATE PROCEDURE [Search].[GetProvidersSpeacialtyList] -- Add the parameters for the     
	@ProviderIdList	[search].[ProviderIdList]	READONLY     
	,@DoctorTypes  [search].[DoctorTypes]		READONLY   
	,@Showversion								BIT = 0
	,@ShowReturn								BIT = 0
AS
	BEGIN 

		/*
			Modification Log:
				11/14/2016	1.00	SS		Modified SP, Added ShowVersion,ShowRetrun Parmeters.
		*/		
		declare @now date = getdate()
		declare @Version varchar(100) = '11/14/2016 8:40 Version 1.00'
		declare @ReturnValues table
			(
			 ReturnCode int primary key
							not null
			,Reason varchar(200) not null
			)

		insert into @ReturnValues
				(ReturnCode, Reason)
			values (0, 'Normal Return')			
											
		if @Showversion = 1
			begin
				select object_schema_name(@@PROCId) as SchemaName
					   ,object_name(@@PROCId) as ProcedureName
					   ,@Version as VersionInformation
				if isnull(@ShowReturn, 0) = 0
					return 0
			end

		if @ShowReturn = 1
			begin
				select *
					from @ReturnValues
				return 0
			end


      -- SET NOCOUNT ON added to prevent extra result sets from 
      -- interfering with SELECT statements. 
		SET NOCOUNT ON;		
		DECLARE @DoctorTypeCount int
		SELECT @DoctorTypeCount = count(*) from @DoctorTypes

      --/* Provider Speacialties */ 
		SELECT DISTINCT  S.SpecialtyDesc, S.ServiceIdentifier, S.Category,PS.ProviderID,PS.BoardCertified, S.SpanishTranslation
		FROM search.Specialty S WITH (NOLOCK) 
				INNER JOIN search.ProviderSpecialty PS WITH (NOLOCK) ON PS.SpecialtyID = S.SpecialtyID AND ps.IsEnabled = 1
				INNER JOIN @ProviderIdList P ON PS.ProviderID = P.ProviderId
		WHERE  @DoctorTypeCount = 0 or S.SpecialtyDesc IN (SELECT * FROM @DoctorTypes)
      
	END	
GO
/****** Object:  StoredProcedure [Search].[GetProviderTypesCount]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--/*==================================================================================  
--    Author:		John Padilla
--    Description:  Gets provider type counts from search.ProviderTypeCount stored
--                  procedure
--    Date written: 11/07/2017
--==================================================================================*/
CREATE PROCEDURE [Search].[GetProviderTypesCount]
AS
 BEGIN TRY
 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statement.
	SET NOCOUNT ON;

 
	SELECT  ProviderType, Total
	FROM [search].[ProviderTypeCount] WITH (NOLOCK)

END TRY
BEGIN CATCH 
 

    DECLARE @Error INT ,
            @EMessage NVARCHAR(4000) ,
            @xstate INT;

    SELECT @EMessage = ERROR_MESSAGE() ,
            @Error = ERROR_NUMBER() ,
            @xstate = XACT_STATE();

    ROLLBACK TRANSACTION;

    -- Use RAISERROR inside the CATCH block to return error  
    -- information about the original error that caused  
    -- execution to jump to the CATCH block.  
    RAISERROR(
                    '[search].[GetProviderTypesCount]: %d: %s' ,
                    16 ,
                    1 ,
                    @Error ,
                    @EMessage
                );


END CATCH;
GO
/****** Object:  StoredProcedure [Search].[SetProviderTypeCounts]    Script Date: 3/14/2018 4:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- ================================================================================
-- Author:		John Padilla (JP)
-- Create date: 11/07/2017 
-- Description: Return Counts for various provider types to be used on 
--              Provider Search landing page. Then updates ProviderTypeCounts
--              table.  
-- ================================================================================
CREATE PROCEDURE [Search].[SetProviderTypeCounts]
AS
BEGIN TRY
        
	BEGIN TRANSACTION

	 /*=================================================================================================
			Modification Log:
				11/07/2017	1.00 JP	Initial creation.
				12/19/2017  1.02 JP Added  MembershipStatus & PreferredFirstName to #Result temporary
				                           Table. This was due to a modification to the 
	 =================================================================================================*/ 


		SET NOCOUNT ON;


	 /*=================================================================================================
		Declare Variables and UDTs
	 =================================================================================================*/
		declare @p49 search.DoctorTypes
		declare @p50 search.PanelLobList
		declare @p54 search.AffiliationPanelList
		declare @p55 search.AffiliationLobList


	 --/*=================================================================================================
		--Declare Temp Tables
	 --=================================================================================================*/ 
	  CREATE TABLE #Results 
	  (
		RowID SMALLINT IDENTITY(1,1) NOT NULL,
		ProviderId BIGINT NULL,
		DiamProvID BIGINT NULL,
		FirstName VARCHAR(50) NULL,
		LastName VARCHAR(50) NULL,
		Gender VARCHAR(10) NULL,
		OrganizationName VARCHAR(100) NULL,
		License VARCHAR(20) NULL,
		NPI VARCHAR(20) NULL,
		ProviderType VARCHAR(10) NULL,
		NetDevProvID VARCHAR(20) NULL,
		Distance INT NULL,
		TotalCount INT NULL,
        MembershipStatus varchar(75) NULL,
		PreferredFirstName varchar(100) NULL
	  ) 


	/*=================================================================================================
		Get Primary Care Provider (PCP) info
	=================================================================================================*/ 
	insert into @p49 values(N'Family Practice')
	insert into @p49 values(N'OB/GYN')
	insert into @p49 values(N'Pediatrics')
	insert into @p49 values(N'Internal Medicine')
	insert into @p49 values(N'General Practice')
	insert into @p50 values(N'206',N'MED')
	insert into @p54 values(N'210')
	insert into @p54 values(N'777')
	insert into @p54 values(N'555')
	insert into @p54 values(N'333')
	insert into @p55 values(N'CCI')


	INSERT INTO #Results 
	EXEC search.GetProviderList @DiamProviderId = NULL ,
								@NetProviderId = NULL ,
								@NationalProviderId = NULL ,
								@LicenseNumber = NULL ,
								@ProviderType = N'PCP' ,
								@LineofBusiness = NULL ,
								@Specialty = 0 ,
								@Name = NULL ,
								@Gender = NULL ,
								@Language = NULL ,
								@HospitalName = NULL ,
								@IPAAffiliation = NULL ,
								@Acceptingnewmembers = 1 ,
								@Contractstatus = NULL ,
								@City = NULL ,
								@Email = NULL ,
								@ShowTermed = 0 ,
								@ShowFuture = 0 ,
								@Fax = NULL ,
								@intMilesModifier = 0 ,
								@SearchMethod = NULL ,
								@CenterPoint_lat = 0 ,
								@CenterPoint_lng = 0 ,
								@Radius = 0 ,
								@Age = NULL ,
								@ZipCode = NULL ,
								@Panel = NULL ,
								@DirectoryId = NULL ,
								@Street = NULL ,
								@County = NULL ,
								@CountyCode = 0 ,
								@Phone = NULL ,
								@AfterHoursPhone = NULL ,
								@WebSite = NULL ,
								@BusStop = 0 ,
								@BusRoute = NULL ,
								@Accessibility = NULL ,
								@Walkin = 0 ,
								@BuildingSign = NULL ,
								@AppointmentNeeded = 0 ,
								@PageNumber = 1 ,
								@PageSize = 1 ,
								@EnablePaging = 1 ,
								@IsHospitalAdmitter = 0 ,
								@FederallyQualifiedHC = 0 ,
								@OfficeName = NULL ,
								@Internal = 0 ,
								@Facility = 0 ,
								@DoctorTypes = @p49 ,
								@MediCalPanel206 = @p50 ,
								@AffiliationDependencyRequired = 1 ,
								@ProviderExtenedPropertiesDependencyRequired = 0 ,
								@ProviderSpecialtyDependencyRequired = 1 ,
								@AffiliationPanelExclusionList = @p54 ,
								@AffiliationLobExclusionList = @p55 ,
								@SortBy = NULL ,
								@StatusCode = NULL;


							
	/*=================================================================================================
		Get Specialist info
	=================================================================================================*/
	DELETE FROM @p49
	DELETE FROM @p50
	DELETE FROM @p54
	DELETE FROM @p55

	insert into @p50 values(N'206',N'MED')
	insert into @p54 values(N'210')
	insert into @p54 values(N'777')
	insert into @p54 values(N'555')
	insert into @p54 values(N'333')

	INSERT INTO #Results 
	EXEC search.GetProviderList @DiamProviderId = NULL ,
								@NetProviderId = NULL ,
								@NationalProviderId = NULL ,
								@LicenseNumber = NULL ,
								@ProviderType = N'SPEC' ,
								@LineofBusiness = NULL ,
								@Specialty = 0 ,
								@Name = NULL ,
								@Gender = NULL ,
								@Language = NULL ,
								@HospitalName = NULL ,
								@IPAAffiliation = NULL ,
								@Acceptingnewmembers = 0 ,
								@Contractstatus = NULL ,
								@City = NULL ,
								@Email = NULL ,
								@ShowTermed = 0 ,
								@ShowFuture = 0 ,
								@Fax = NULL ,
								@intMilesModifier = 0 ,
								@SearchMethod = NULL ,
								@CenterPoint_lat = 0 ,
								@CenterPoint_lng = 0 ,
								@Radius = 0 ,
								@Age = NULL ,
								@ZipCode = NULL ,
								@Panel = NULL ,
								@DirectoryId = NULL ,
								@Street = NULL ,
								@County = NULL ,
								@CountyCode = 0 ,
								@Phone = NULL ,
								@AfterHoursPhone = NULL ,
								@WebSite = NULL ,
								@BusStop = 0 ,
								@BusRoute = NULL ,
								@Accessibility = NULL ,
								@Walkin = 0 ,
								@BuildingSign = NULL ,
								@AppointmentNeeded = 0 ,
								@PageNumber = 1 ,
								@PageSize = 1 ,
								@EnablePaging = 1 ,
								@IsHospitalAdmitter = 0 ,
								@FederallyQualifiedHC = 0 ,
								@OfficeName = NULL ,
								@Internal = 0 ,
								@Facility = 0 ,
								@DoctorTypes = @p49 ,
								@MediCalPanel206 = @p50 ,
								@AffiliationDependencyRequired = 1 ,
								@ProviderExtenedPropertiesDependencyRequired = 0 ,
								@ProviderSpecialtyDependencyRequired = 0 ,
								@AffiliationPanelExclusionList = @p54 ,
								@AffiliationLobExclusionList = @p55 ,
								@SortBy = NULL,
								@StatusCode = NULL;

							
	/*=================================================================================================
		Get Hospital info
	=================================================================================================*/
	DELETE FROM @p49
	DELETE FROM @p50
	DELETE FROM @p54
	DELETE FROM @p55


	insert into @p50 values(N'206',N'MED') 
	insert into @p54 values(N'210')
	insert into @p54 values(N'777')
	insert into @p54 values(N'555')
	insert into @p54 values(N'333')


	INSERT INTO #Results 
	EXEC search.GetProviderList @DiamProviderId = NULL ,
								@NetProviderId = NULL ,
								@NationalProviderId = NULL ,
								@LicenseNumber = NULL ,
								@ProviderType = N'HOSP' ,
								@LineofBusiness = NULL ,
								@Specialty = 0 ,
								@Name = NULL ,
								@Gender = NULL ,
								@Language = NULL ,
								@HospitalName = NULL ,
								@IPAAffiliation = NULL ,
								@Acceptingnewmembers = 0 ,
								@Contractstatus = NULL ,
								@City = NULL ,
								@Email = NULL ,
								@ShowTermed = 0 ,
								@ShowFuture = 0 ,
								@Fax = NULL ,
								@intMilesModifier = 0 ,
								@SearchMethod = NULL ,
								@CenterPoint_lat = 0 ,
								@CenterPoint_lng = 0 ,
								@Radius = 0 ,
								@Age = NULL ,
								@ZipCode = NULL ,
								@Panel = NULL ,
								@DirectoryId = NULL ,
								@Street = NULL ,
								@County = NULL ,
								@CountyCode = 0 ,
								@Phone = NULL ,
								@AfterHoursPhone = NULL ,
								@WebSite = NULL ,
								@BusStop = 0 ,
								@BusRoute = NULL ,
								@Accessibility = NULL ,
								@Walkin = 0 ,
								@BuildingSign = NULL ,
								@AppointmentNeeded = 0 ,
								@PageNumber = 1 ,
								@PageSize = 1 ,
								@EnablePaging = 1 ,
								@IsHospitalAdmitter = 0 ,
								@FederallyQualifiedHC = 0 ,
								@OfficeName = NULL ,
								@Internal = 0 ,
						        @Facility = 0 ,
								@DoctorTypes = @p49 ,
								@MediCalPanel206 = @p50 ,
								@AffiliationDependencyRequired = 0 ,
								@ProviderExtenedPropertiesDependencyRequired = 0 ,
								@ProviderSpecialtyDependencyRequired = 0 ,
								@AffiliationPanelExclusionList = @p54 ,
								@AffiliationLobExclusionList = @p55 ,
								@SortBy = NULL ,
								@StatusCode = NULL;



	/*=================================================================================================
		Get Pharmacy info
	=================================================================================================*/
	DELETE FROM @p49
	DELETE FROM @p50
	DELETE FROM @p54
	DELETE FROM @p55 
 
	insert into @p50 values(N'206',N'MED') 
	insert into @p54 values(N'210')
	insert into @p54 values(N'777')
	insert into @p54 values(N'555')
	insert into @p54 values(N'333')
 
	INSERT INTO #Results
	EXEC search.GetProviderList @DiamProviderId = NULL ,
								@NetProviderId = NULL ,
								@NationalProviderId = NULL ,
								@LicenseNumber = NULL ,
								@ProviderType = N'PHRM' ,
								@LineofBusiness = NULL ,
								@Specialty = 0 ,
								@Name = NULL ,
								@Gender = NULL ,
								@Language = NULL ,
								@HospitalName = NULL ,
								@IPAAffiliation = NULL ,
								@Acceptingnewmembers = 0 ,
								@Contractstatus = NULL ,
								@City = NULL ,
								@Email = NULL ,
								@ShowTermed = 0 ,
								@ShowFuture = 0 ,
								@Fax = NULL ,
								@intMilesModifier = 0 ,
								@SearchMethod = NULL ,
								@CenterPoint_lat = 0 ,
								@CenterPoint_lng = 0 ,
								@Radius = 0 ,
								@Age = NULL ,
								@ZipCode = NULL ,
								@Panel = NULL ,
								@DirectoryId = NULL ,
								@Street = NULL ,
								@County = NULL ,
								@CountyCode = 0 ,
								@Phone = NULL ,
								@AfterHoursPhone = NULL ,
								@WebSite = NULL ,
								@BusStop = 0 ,
								@BusRoute = NULL ,
								@Accessibility = NULL ,
								@Walkin = 0 ,
								@BuildingSign = NULL ,
								@AppointmentNeeded = 0 ,
								@PageNumber = 1 ,
								@PageSize = 1 ,
								@EnablePaging = 1 ,
								@IsHospitalAdmitter = 0 ,
								@FederallyQualifiedHC = 0 ,
								@OfficeName = NULL ,
								@Internal = 0 ,
								@Facility = 0 ,
								@DoctorTypes = @p49 ,
								@MediCalPanel206 = @p50 ,
								@AffiliationDependencyRequired = 0 ,
								@ProviderExtenedPropertiesDependencyRequired = 1 ,
								@ProviderSpecialtyDependencyRequired = 0 ,
								@AffiliationPanelExclusionList = @p54 ,
								@AffiliationLobExclusionList = @p55 ,
								@SortBy = N'LastName' ,
								@StatusCode = NULL;



	/*=================================================================================================
		Get Urgent Care info
	=================================================================================================*/

	DELETE FROM @p49
	DELETE FROM @p50
	DELETE FROM @p54
	DELETE FROM @p55 

	insert into @p50 values(N'206',N'MED')
	insert into @p54 values(N'210')
	insert into @p54 values(N'777')
	insert into @p54 values(N'555')
	insert into @p54 values(N'333')

	INSERT INTO #Results 
	EXEC search.GetProviderList @DiamProviderId = NULL ,
								@NetProviderId = NULL ,
								@NationalProviderId = NULL ,
								@LicenseNumber = NULL ,
								@ProviderType = N'UC' ,
								@LineofBusiness = NULL ,
								@Specialty = 0 ,
								@Name = NULL ,
								@Gender = NULL ,
								@Language = NULL ,
								@HospitalName = NULL ,
								@IPAAffiliation = NULL ,
								@Acceptingnewmembers = 0 ,
								@Contractstatus = NULL ,
								@City = NULL ,
								@Email = NULL ,
								@ShowTermed = 0 ,
								@ShowFuture = 0 ,
								@Fax = NULL ,
								@intMilesModifier = 0 ,
								@SearchMethod = NULL ,
								@CenterPoint_lat = 0 ,
								@CenterPoint_lng = 0 ,
								@Radius = 0 ,
								@Age = NULL ,
								@ZipCode = NULL ,
								@Panel = NULL ,
								@DirectoryId = NULL ,
								@Street = NULL ,
								@County = NULL ,
								@CountyCode = 0 ,
								@Phone = NULL ,
								@AfterHoursPhone = NULL ,
								@WebSite = NULL ,
								@BusStop = 0 ,
								@BusRoute = NULL ,
								@Accessibility = NULL ,
								@Walkin = 0 ,
								@BuildingSign = NULL ,
								@AppointmentNeeded = 0 ,
								@PageNumber = 1 ,
								@PageSize = 1 ,
								@EnablePaging = 1 ,
								@IsHospitalAdmitter = 0 ,
								@FederallyQualifiedHC = 0 ,
								@OfficeName = NULL ,
								@Internal = 0 ,
								@Facility = 0 ,
								@DoctorTypes = @p49 ,
								@MediCalPanel206 = @p50 ,
								@AffiliationDependencyRequired = 1 ,
								@ProviderExtenedPropertiesDependencyRequired = 0 ,
								@ProviderSpecialtyDependencyRequired = 0 ,
								@AffiliationPanelExclusionList = @p54 ,
								@AffiliationLobExclusionList = @p55 ,
								@SortBy = N'LastName' ,
								@StatusCode = NULL; 


	/*=================================================================================================
		Get Vision info
	=================================================================================================*/
	DELETE FROM @p49
	DELETE FROM @p50
	DELETE FROM @p54
	DELETE FROM @p55

	insert into @p50 values(N'206',N'MED')
	insert into @p54 values(N'210')
	insert into @p54 values(N'777')
	insert into @p54 values(N'555')
	insert into @p54 values(N'333')


	INSERT INTO #Results
	EXEC search.GetProviderList @DiamProviderId = NULL ,
								@NetProviderId = NULL ,
								@NationalProviderId = NULL ,
								@LicenseNumber = NULL ,
								@ProviderType = N'VSN' ,
								@LineofBusiness = NULL ,
								@Specialty = 0 ,
								@Name = NULL ,
								@Gender = NULL ,
								@Language = NULL ,
								@HospitalName = NULL ,
								@IPAAffiliation = NULL ,
								@Acceptingnewmembers = 0 ,
								@Contractstatus = NULL ,
								@City = NULL ,
								@Email = NULL ,
								@ShowTermed = 0 ,
								@ShowFuture = 0 ,
								@Fax = NULL ,
								@intMilesModifier = 0 ,
								@SearchMethod = NULL ,
								@CenterPoint_lat = 0 ,
								@CenterPoint_lng = 0 ,
								@Radius = 0 ,
								@Age = NULL ,
								@ZipCode = NULL ,
								@Panel = NULL ,
								@DirectoryId = NULL ,
								@Street = NULL ,
								@County = NULL ,
								@CountyCode = 0 ,
								@Phone = NULL ,
								@AfterHoursPhone = NULL ,
								@WebSite = NULL ,
								@BusStop = 0 ,
								@BusRoute = NULL ,
								@Accessibility = NULL ,
								@Walkin = 0 ,
								@BuildingSign = NULL ,
								@AppointmentNeeded = 0 ,
								@PageNumber = 1 ,
								@PageSize = 1 ,
								@EnablePaging = 1 ,
								@IsHospitalAdmitter = 0 ,
								@FederallyQualifiedHC = 0 ,
								@OfficeName = NULL ,
								@Internal = 0 ,
								@Facility = 0 ,
								@DoctorTypes = @p49 ,
								@MediCalPanel206 = @p50 ,
								@AffiliationDependencyRequired = 1 ,
								@ProviderExtenedPropertiesDependencyRequired = 1 ,
								@ProviderSpecialtyDependencyRequired = 1 ,
								@AffiliationPanelExclusionList = @p54 ,
								@AffiliationLobExclusionList = @p55 ,
								@SortBy = N'LastName' ,
								@StatusCode = NULL; 


	/*=================================================================================================
		Get Behavioral Health info
	=================================================================================================*/
	DELETE FROM @p49
	DELETE FROM @p50
	DELETE FROM @p54
	DELETE FROM @p55

	insert into @p50 values(N'206',N'MED') 
	insert into @p54 values(N'210')
	insert into @p54 values(N'777')
	insert into @p54 values(N'555')
	insert into @p54 values(N'333')
 
	INSERT INTO #Results
	EXEC search.GetProviderList @DiamProviderId = NULL ,
								@NetProviderId = NULL ,
								@NationalProviderId = NULL ,
								@LicenseNumber = NULL ,
								@ProviderType = N'BH' ,
								@LineofBusiness = NULL ,
								@Specialty = 0 ,
								@Name = NULL ,
								@Gender = NULL ,
								@Language = NULL ,
								@HospitalName = NULL ,
								@IPAAffiliation = NULL ,
								@Acceptingnewmembers = 0 ,
								@Contractstatus = NULL ,
								@City = NULL ,
								@Email = NULL ,
								@ShowTermed = 0 ,
								@ShowFuture = 0 ,
								@Fax = NULL ,
								@intMilesModifier = 0 ,
								@SearchMethod = NULL ,
								@CenterPoint_lat = 0 ,
								@CenterPoint_lng = 0 ,
								@Radius = 0 ,
								@Age = NULL ,
								@ZipCode = NULL ,
								@Panel = NULL ,
								@DirectoryId = NULL ,
								@Street = NULL ,
								@County = NULL ,
								@CountyCode = 0 ,
								@Phone = NULL ,
								@AfterHoursPhone = NULL ,
								@WebSite = NULL ,
								@BusStop = 0 ,
								@BusRoute = NULL ,
								@Accessibility = NULL ,
								@Walkin = 0 ,
								@BuildingSign = NULL ,
								@AppointmentNeeded = 0 ,
								@PageNumber = 1 ,
								@PageSize = 1 ,
								@EnablePaging = 1 ,
								@IsHospitalAdmitter = 0 ,
								@FederallyQualifiedHC = 0 ,
								@OfficeName = NULL ,
								@Internal = 0 ,
								@Facility = 0 ,
								@DoctorTypes = @p49 ,
								@MediCalPanel206 = @p50 ,
								@AffiliationDependencyRequired = 1 ,
								@ProviderExtenedPropertiesDependencyRequired = 0 ,
								@ProviderSpecialtyDependencyRequired = 0 ,
								@AffiliationPanelExclusionList = @p54 ,
								@AffiliationLobExclusionList = @p55 ,
								@SortBy = N'LastName' ,
								@StatusCode = NULL;



	/*=================================================================================================
		Get OB/GYN info
	=================================================================================================*/
	DELETE FROM @p49
	DELETE FROM @p50
	DELETE FROM @p54
	DELETE FROM @p55

	insert into @p50 values(N'206',N'MED') 
	insert into @p54 values(N'210')
	insert into @p54 values(N'777')
	insert into @p54 values(N'555')
	insert into @p54 values(N'333')
 
	INSERT INTO #Results
	EXEC search.GetProviderList @DiamProviderID = NULL ,
								@NetProviderID = NULL ,
								@NationalProviderID = NULL ,
								@LicenseNumber = NULL ,
								@ProviderType = N'SPEC' ,
								@LineofBusiness = NULL ,
								@Specialty = 2434 ,
								@Name = NULL ,
								@Gender = NULL ,
								@Language = NULL ,
								@HospitalName = NULL ,
								@IPAAffiliation = NULL ,
								@Acceptingnewmembers = 0 ,
								@Contractstatus = NULL ,
								@City = NULL ,
								@Email = NULL ,
								@ShowTermed = 0 ,
								@ShowFuture = 0 ,
								@Fax = NULL ,
								@intMilesModifier = 0 ,
								@SearchMethod = NULL ,
								@CenterPoint_lat = 0 ,
								@CenterPoint_lng = 0 ,
								@Radius = 0 ,
								@Age = NULL ,
								@ZipCode = NULL ,
								@Panel = NULL ,
								@DirectoryID = NULL ,
								@Street = NULL ,
								@County = NULL ,
								@CountyCode = 0 ,
								@Phone = NULL ,
								@AfterHoursPhone = NULL ,
								@Website = NULL ,
								@BusStop = 0 ,
								@BusRoute = NULL ,
								@Accessibility = NULL ,
								@Walkin = 0 ,
								@BuildingSign = NULL ,
								@AppointmentNeeded = 0 ,
								@PageNumber = 1 ,
								@PageSize = 1 ,
								@EnablePaging = 1 ,
								@IsHospitalAdmitter = 0 ,
								@FederallyQualifiedHC = 0 ,
								@OfficeName = NULL ,
								@Internal = 0 ,
								@Facility = 0 ,
								@DoctorTypes = @p49 ,
								@MediCalPanel206 = @p50 ,
								@AffiliationDependencyRequired = 1 ,
								@ProviderExtenedPropertiesDependencyRequired = 0 ,
								@ProviderSpecialtyDependencyRequired = 1 ,
								@AffiliationPanelExclusionList = @p54 ,
								@AffiliationLobExclusionList = @p55 ,
								@SortBy = NULL ,
								@StatusCode = NULL;


	MERGE INTO search.ProviderTypeCount PTC
		USING 
		(
			SELECT
				RowId,
				CASE WHEN RowID = 1 THEN 'Pcp' 
						WHEN RowID = 2 THEN 'Specialist'
						WHEN RowID = 3 THEN 'Hospital'
						WHEN RowID = 4 THEN 'Pharmacy'
						WHEN RowID = 5 THEN 'UrgentCare'
						WHEN RowID = 6 THEN 'Vision'
						WHEN RowID = 7 THEN 'BehavioralHealth'
						WHEN RowID = 8 THEN 'Ob/Gyn'
						ELSE '' END ProviderType,
				Total
			FROM
			(
				SELECT  RowID, TotalCount Total
				FROM #Results
			)TbS
		)TBF
		ON PTC.RowId = TBF.RowId
	WHEN Matched THEN
		UPDATE
			SET PTC.Total = TBF.Total
	WHEN NOT MATCHED THEN
		INSERT
		(RowId, ProviderType,Total)
		VALUES (TBF.RowID, TBF.ProviderType, TBF.Total);  

	 IF OBJECT_ID('tempdb..#Results') IS NOT NULL DROP TABLE #Results

COMMIT TRANSACTION;
END TRY
BEGIN CATCH

    IF OBJECT_ID('tempdb..#Results') IS NOT NULL DROP TABLE #Results 
 

    DECLARE @Error INT ,
            @EMessage NVARCHAR(4000) ,
            @xstate INT;

    SELECT @EMessage = ERROR_MESSAGE() ,
            @Error = ERROR_NUMBER() ,
            @xstate = XACT_STATE();

    ROLLBACK TRANSACTION;

    -- Use RAISERROR inside the CATCH block to return error  
    -- information about the original error that caused  
    -- execution to jump to the CATCH block.  
    RAISERROR(
                    '[search].[SetProviderTypeCounts]: %d: %s' ,
                    16 ,
                    1 ,
                    @Error ,
                    @EMessage
                );
END CATCH;



GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "p"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 227
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "A"
            Begin Extent = 
               Top = 6
               Left = 265
               Bottom = 135
               Right = 466
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "dlr"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 267
               Right = 324
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "dl"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 399
               Right = 235
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PPI"
            Begin Extent = 
               Top = 402
               Left = 38
               Bottom = 531
               Right = 309
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CL"
            Begin Extent = 
               Top = 534
               Left = 38
               Bottom = 663
               Right = 251
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PDRI"
            Begin Extent = 
               Top = 666
               Left = 38
               Bottom = 795
               Right = 245
            End
            DisplayFlags = 280
            TopColumn = 0
        ' , @level0type=N'SCHEMA',@level0name=N'changed', @level1type=N'VIEW',@level1name=N'DirectoryUpdateReport'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N' End
         Begin Table = "PL"
            Begin Extent = 
               Top = 270
               Left = 273
               Bottom = 382
               Right = 443
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PL1"
            Begin Extent = 
               Top = 534
               Left = 289
               Bottom = 646
               Right = 459
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "L"
            Begin Extent = 
               Top = 648
               Left = 289
               Bottom = 760
               Right = 459
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "L1"
            Begin Extent = 
               Top = 762
               Left = 283
               Bottom = 874
               Right = 453
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "S"
            Begin Extent = 
               Top = 798
               Left = 38
               Bottom = 927
               Right = 211
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "S1"
            Begin Extent = 
               Top = 876
               Left = 249
               Bottom = 1005
               Right = 422
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PSP"
            Begin Extent = 
               Top = 1008
               Left = 38
               Bottom = 1137
               Right = 260
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PSP1"
            Begin Extent = 
               Top = 1140
               Left = 38
               Bottom = 1269
               Right = 260
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LV"
            Begin Extent = 
               Top = 1272
               Left = 38
               Bottom = 1401
               Right = 228
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LV1"
            Begin Extent = 
               Top = 1272
               Left = 266
               Bottom = 1401
               Right = 456
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LV3"
            Begin Extent = 
               Top = 1404
               Left = 38
               Bottom = 1533
               Right = 228
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LV4"
            Begin Extent = 
               Top = 6
               Left = 504
               Bottom = 135
               Right = 694
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PG"
            Begin Extent = 
               Top = 6
               Left = 732
               Bottom = 101
               Right = 902
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
     ' , @level0type=N'SCHEMA',@level0name=N'changed', @level1type=N'VIEW',@level1name=N'DirectoryUpdateReport'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane3', @value=N'    GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'changed', @level1type=N'VIEW',@level1name=N'DirectoryUpdateReport'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=3 , @level0type=N'SCHEMA',@level0name=N'changed', @level1type=N'VIEW',@level1name=N'DirectoryUpdateReport'
GO
