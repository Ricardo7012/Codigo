USE [master]
GO
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'TDS')
BEGIN
CREATE DATABASE [TDS]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TDS', FILENAME = N'E:\MSSQL\Data\TDS.mdf' , SIZE = 2097152KB , MAXSIZE = 157286400KB , FILEGROWTH = 1048576KB )
 LOG ON 
( NAME = N'TDS_log', FILENAME = N'E:\MSSQL\Data\TDS_log.ldf' , SIZE = 1048576KB , MAXSIZE = 20971520KB , FILEGROWTH = 1048576KB )
END

GO
ALTER DATABASE [TDS] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [TDS].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [TDS] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [TDS] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [TDS] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [TDS] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [TDS] SET ARITHABORT OFF 
GO
ALTER DATABASE [TDS] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [TDS] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [TDS] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [TDS] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [TDS] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [TDS] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [TDS] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [TDS] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [TDS] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [TDS] SET  DISABLE_BROKER 
GO
ALTER DATABASE [TDS] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [TDS] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [TDS] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [TDS] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [TDS] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [TDS] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [TDS] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [TDS] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [TDS] SET  MULTI_USER 
GO
ALTER DATABASE [TDS] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [TDS] SET DB_CHAINING OFF 
GO
ALTER DATABASE [TDS] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [TDS] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [TDS] SET DELAYED_DURABILITY = DISABLED 
GO
USE [TDS]
GO
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'db_executor' AND type = 'R')
CREATE ROLE [db_executor]
GO
GRANT EXECUTE TO [db_executor] AS [dbo]
GO
GRANT UPDATE TO [public] AS [dbo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[goodDate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[goodDate](@indate date)
  RETURNS date
  AS
  BEGIN
  DECLARE @retval date;
  SELECT @retval = @indate;
  RETURN @retval;
  END' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dbo.meds]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[dbo.meds](
	[Memberid] [nvarchar](max) NULL,
	[Facility_Code] [nvarchar](max) NULL,
	[MRN] [nvarchar](max) NULL,
	[Start_Date] [nvarchar](max) NULL,
	[Stop_Date] [nvarchar](max) NULL,
	[NDC_Code] [nvarchar](max) NULL,
	[Medication_Name] [nvarchar](max) NULL,
	[SIG] [nvarchar](max) NULL,
	[DOSE] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[deceased]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[deceased](
	[column1] [float] NOT NULL,
	[column2] [int] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DonaldProposedHistorical]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DonaldProposedHistorical](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[MessageType] [char](16) NULL,
	[IEHPMemberId] [char](32) NULL,
	[Name] [varchar](128) NULL,
	[Address1] [varchar](128) NULL,
	[Address2] [varchar](128) NULL,
	[City] [varchar](128) NULL,
	[Zip] [char](10) NULL,
	[Phone] [varchar](64) NULL,
	[FacilityCode] [varchar](32) NULL,
	[FacilityName] [varchar](128) NULL,
	[MRN] [varchar](64) NULL,
	[ServiceDate] [datetime] NULL,
	[AdmitDate] [datetime] NULL,
	[DischargeDate] [datetime] NULL,
	[ICD10Codes] [varchar](256) NULL,
	[CPTCode] [varchar](256) NULL,
	[VisitNo] [varchar](64) NULL,
 CONSTRAINT [PK_Historical] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[elig]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[elig](
	[memberid] [char](12) NOT NULL,
	[personno] [char](2) NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[enc_admission]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[enc_admission](
	[memberid] [float] NULL,
	[service_date] [datetime2](7) NULL,
	[facility_code] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[enc_admit_discharge]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[enc_admit_discharge](
	[memberid] [float] NULL,
	[facility_code] [nvarchar](max) NULL,
	[admit_date] [datetime2](7) NULL,
	[discharge_date] [datetime2](7) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[encounters]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[encounters](
	[MemberId] [float] NULL,
	[Name] [nvarchar](max) NULL,
	[ADDRESSLINE1] [nvarchar](max) NULL,
	[ADDRESSLINE2] [nvarchar](max) NULL,
	[CITY] [nvarchar](max) NULL,
	[POSTALCODE] [nvarchar](max) NULL,
	[PHONE] [nvarchar](max) NULL,
	[Facility_Code] [nvarchar](max) NULL,
	[MRN] [nvarchar](max) NULL,
	[Service_Date] [datetime2](7) NULL,
	[Admit_Date] [datetime2](7) NULL,
	[Discharge_Date] [datetime2](7) NULL,
	[DX_ICD10_Codes] [nvarchar](max) NULL,
	[Procedure_CPT_Code] [nvarchar](max) NULL,
	[VISIT_] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[facility]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[facility](
	[code] [nvarchar](50) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[type] [char](1) NULL,
	[active] [char](10) NULL,
	[organization] [varchar](20) NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IEHP encounters q1 2017x]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[IEHP encounters q1 2017x](
	[Member_] [float] NULL,
	[Name] [nvarchar](max) NULL,
	[ADDRESSLINE1] [nvarchar](max) NULL,
	[ADDRESSLINE2] [nvarchar](max) NULL,
	[CITY] [nvarchar](max) NULL,
	[POSTALCODE] [nvarchar](max) NULL,
	[PHONE] [nvarchar](max) NULL,
	[Facility_Code] [nvarchar](max) NOT NULL,
	[MRN] [nvarchar](max) NULL,
	[Service_Date] [datetime2](7) NULL,
	[Admit_Date] [datetime2](7) NULL,
	[Discharge_Date] [datetime2](7) NULL,
	[DX_ICD10_Codes] [nvarchar](max) NULL,
	[Procedure_CPT_Code] [nvarchar](max) NULL,
	[VISIT_] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IEHP encounters q2 2017x]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[IEHP encounters q2 2017x](
	[Member_] [float] NULL,
	[Name] [nvarchar](max) NULL,
	[ADDRESSLINE1] [nvarchar](max) NULL,
	[ADDRESSLINE2] [nvarchar](max) NULL,
	[CITY] [nvarchar](max) NULL,
	[POSTALCODE] [nvarchar](max) NULL,
	[PHONE] [nvarchar](max) NULL,
	[Facility_Code] [nvarchar](max) NULL,
	[MRN] [nvarchar](max) NULL,
	[Service_Date] [datetime2](7) NULL,
	[Admit_Date] [datetime2](7) NULL,
	[Discharge_Date] [datetime2](7) NULL,
	[DX_ICD10_Codes] [nvarchar](max) NULL,
	[Procedure_CPT_Code] [nvarchar](max) NULL,
	[VISIT_] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IEHP encounters q3 2017x]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[IEHP encounters q3 2017x](
	[Member_] [float] NULL,
	[Name] [nvarchar](max) NULL,
	[ADDRESSLINE1] [nvarchar](max) NULL,
	[ADDRESSLINE2] [nvarchar](max) NULL,
	[CITY] [nvarchar](max) NULL,
	[POSTALCODE] [nvarchar](max) NULL,
	[PHONE] [nvarchar](max) NULL,
	[Facility_Code] [nvarchar](max) NULL,
	[MRN] [nvarchar](max) NULL,
	[Service_Date] [datetime2](7) NULL,
	[Admit_Date] [datetime2](7) NULL,
	[Discharge_Date] [datetime2](7) NULL,
	[DX_ICD10_Codes] [nvarchar](max) NULL,
	[Procedure_CPT_Code] [nvarchar](max) NULL,
	[VISIT_] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IEHP encounters q4 2017x]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[IEHP encounters q4 2017x](
	[Member_] [float] NULL,
	[Name] [nvarchar](max) NULL,
	[ADDRESSLINE1] [nvarchar](max) NULL,
	[ADDRESSLINE2] [nvarchar](max) NULL,
	[CITY] [nvarchar](max) NULL,
	[POSTALCODE] [nvarchar](max) NULL,
	[PHONE] [nvarchar](max) NULL,
	[Facility_Code] [nvarchar](max) NULL,
	[MRN] [nvarchar](max) NULL,
	[Service_Date] [datetime2](7) NULL,
	[Admit_Date] [datetime2](7) NULL,
	[Discharge_Date] [datetime2](7) NULL,
	[DX_ICD10_Codes] [nvarchar](max) NULL,
	[Procedure_CPT_Code] [nvarchar](max) NULL,
	[VISIT_] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IEHP labs 01-2017]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[IEHP labs 01-2017](
	[_MEMBER___] [nvarchar](max) NOT NULL,
	[_COLLECTIONDATE_] [nvarchar](max) NOT NULL,
	[_RESULT_CODE_] [nvarchar](max) NOT NULL,
	[_RESULT_NAME_] [nvarchar](max) NOT NULL,
	[_RESULT_VALUE_] [nvarchar](max) NOT NULL,
	[_RESULT_UNITS_] [nvarchar](max) NOT NULL,
	[_REF_RANGE_] [nvarchar](max) NOT NULL,
	[_ORDER_CODE_] [nvarchar](max) NOT NULL,
	[_ORDER_NAME_] [nvarchar](max) NOT NULL,
	[_FACILITY_CODE_] [nvarchar](max) NOT NULL,
	[_MRN_] [nvarchar](max) NOT NULL,
	[_VISIT__] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IEHP labs 20171201]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[IEHP labs 20171201](
	[_MEMBER___] [nvarchar](max) NULL,
	[_COLLECTIONDATE_] [nvarchar](max) NULL,
	[_RESULT_CODE_] [nvarchar](max) NULL,
	[_RESULT_NAME_] [nvarchar](max) NULL,
	[_RESULT_VALUE_] [nvarchar](max) NULL,
	[_RESULT_UNITS_] [nvarchar](max) NULL,
	[_REF_RANGE_] [nvarchar](max) NULL,
	[_ORDER_CODE_] [nvarchar](max) NULL,
	[_ORDER_NAME_] [nvarchar](max) NULL,
	[_FACILITY_CODE_] [nvarchar](max) NULL,
	[_MRN_] [nvarchar](max) NULL,
	[_VISIT__] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IEHP labs 20171214]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[IEHP labs 20171214](
	[MEMBER__] [nvarchar](max) NULL,
	[COLLECTIONDATE] [nvarchar](max) NULL,
	[RESULT_CODE] [nvarchar](max) NULL,
	[RESULT_NAME] [nvarchar](max) NULL,
	[RESULT_VALUE] [nvarchar](max) NULL,
	[RESULT_UNITS] [nvarchar](max) NULL,
	[REF_RANGE] [nvarchar](max) NULL,
	[ORDER_CODE] [nvarchar](max) NULL,
	[ORDER_NAME] [nvarchar](max) NULL,
	[FACILITY_CODE] [nvarchar](max) NULL,
	[MRN] [nvarchar](max) NULL,
	[VISIT_] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RAW_ADT_STORE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[RAW_ADT_STORE](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MRN] [varchar](50) NULL,
	[SOURCEID] [varchar](50) NULL,
	[MESSAGETYPE] [varchar](50) NULL,
	[MESSAGECONTENT] [varchar](max) NULL,
	[MESSAGEDT] [datetime] NULL,
	[CONTROLID] [varchar](255) NULL,
	[INPUTCP] [varchar](255) NULL,
	[RECEIVEDT] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RAW_MSG_STORE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[RAW_MSG_STORE](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MRN] [varchar](50) NOT NULL,
	[SOURCEID] [varchar](50) NOT NULL,
	[MESSAGETYPE] [varchar](50) NOT NULL,
	[MESSAGECONTENT] [varchar](max) NOT NULL,
	[MESSAGEDT] [datetime] NOT NULL,
	[CONTROLID] [varchar](255) NOT NULL,
	[INPUTCP] [varchar](255) NOT NULL,
	[RECEIVEDT] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RAW_ORU_STORE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[RAW_ORU_STORE](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MRN] [varchar](50) NOT NULL,
	[SOURCEID] [varchar](50) NOT NULL,
	[MESSAGETYPE] [varchar](50) NOT NULL,
	[MESSAGECONTENT] [varchar](max) NOT NULL,
	[RECEIVEDT] [datetime] NOT NULL,
	[CONTROLID] [varchar](255) NOT NULL,
	[INPUTCP] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tds]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tds](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[MessageId] [varchar](50) NOT NULL,
	[MRN] [varchar](128) NULL,
	[MemberId] [varchar](128) NULL,
	[LastName] [varchar](128) NULL,
	[FirstName] [varchar](128) NULL,
	[MiddleName] [varchar](128) NULL,
	[DOB] [datetime] NULL,
	[Gender] [varchar](50) NULL,
	[MessageDate] [datetime] NULL,
	[MessageType] [char](10) NULL,
	[MessageTrigger] [char](10) NULL,
	[Source] [varchar](128) NULL,
	[Location] [varchar](128) NULL,
	[InsertDate] [datetime] NULL,
	[MetaData] [varchar](max) NULL,
	[Message] [varchar](max) NULL,
	[Face] [char](1) NULL,
	[Connection] [varchar](50) NULL,
 CONSTRAINT [PK_tds] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_count_stays_by_week]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[v_count_stays_by_week]
AS
SELECT        TOP (100) PERCENT DATEDIFF(week, Admit_Date, Discharge_Date) AS weeks, COUNT(DATEDIFF(week, Admit_Date, Discharge_Date)) AS count
FROM            dbo.encounters
GROUP BY DATEDIFF(week, Admit_Date, Discharge_Date)
HAVING        (DATEDIFF(week, Admit_Date, Discharge_Date) > - 1) AND (DATEDIFF(week, Admit_Date, Discharge_Date) < 53)
ORDER BY weeks DESC
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_monthly_encounter]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[v_monthly_encounter]
AS
SELECT        TOP (100) PERCENT DATEPART(month, dbo.encounters.Admit_Date) AS month, COUNT(dbo.encounters.Admit_Date) AS count, dbo.facility.name
FROM            dbo.encounters INNER JOIN
                         dbo.facility ON dbo.encounters.Facility_Code = dbo.facility.code
GROUP BY DATEPART(month, dbo.encounters.Admit_Date), dbo.encounters.Facility_Code, dbo.facility.name
ORDER BY month, dbo.facility.name
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_vis_by_fac_by_mo]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[v_vis_by_fac_by_mo]
AS
SELECT        TOP (100) PERCENT b.name AS [facility name], DATEPART(mm, a.service_date) AS month, COUNT(DATEPART(mm, a.service_date)) AS visits
FROM            dbo.enc_admission AS a LEFT OUTER JOIN
                         dbo.facility AS b ON a.facility_code = b.code
GROUP BY DATEPART(mm, a.service_date), b.name
ORDER BY ''facility name'', month
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_weekly_encounter]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[v_weekly_encounter]
AS
SELECT        TOP (100) PERCENT DATEPART(wk, dbo.encounters.Admit_Date) AS week, COUNT(dbo.encounters.Admit_Date) AS count, dbo.facility.name
FROM            dbo.encounters INNER JOIN
                         dbo.facility ON dbo.encounters.Facility_Code = dbo.facility.code
GROUP BY DATEPART(wk, dbo.encounters.Admit_Date), dbo.encounters.Facility_Code, dbo.facility.name
ORDER BY Week, dbo.encounters.Facility_Code
' 
GO
SET ANSI_PADDING ON

GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[tds]') AND name = N'ix_MessageId_Source')
CREATE UNIQUE NONCLUSTERED INDEX [ix_MessageId_Source] ON [dbo].[tds]
(
	[MessageId] ASC,
	[Source] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__facility__Active__6FE99F9F]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[facility] ADD  CONSTRAINT [DF__facility__Active__6FE99F9F]  DEFAULT ((1)) FOR [type]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_tds_InsertDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tds] ADD  CONSTRAINT [DF_tds_InsertDate]  DEFAULT (getdate()) FOR [InsertDate]
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_tdsInsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_tdsInsert] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_tdsInsert]

		   @MessageId varchar(50),
	       @MRN	 varchar(128),
           @MemberId varchar(128),
           @LastName varchar(128),
           @FirstName varchar(128),
           @MiddleName varchar(128),
           @DOB date,
           @Gender varchar(50),
           @MessageDate datetime,
           @MessageType char(10),
           @MessageTrigger char(10),
           @Source varchar(128),
           @Location varchar(128),
           --@InsertDate datetime,
		   @MetaData varchar(max),
           @Message varchar(max),
		   @Face    char(1),
		   @Connection varchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
INSERT INTO [dbo].[tds]
           (
		   MessageId
		   ,[MRN]
           ,[MemberId]
           ,[LastName]
           ,[FirstName]
           ,[MiddleName]
           ,[DOB]
           ,[Gender]
           ,[MessageDate]
           ,[MessageType]
           ,[MessageTrigger]
           ,[Source]
           ,[Location]
           --,[InsertDate]
		   	,[MetaData]
           ,[Message]
		   ,[Face]
		   ,[Connection]
		   )
     VALUES
           (
		   @MessageId,
		   @MRN, 
           @MemberId,
           @LastName,
           @FirstName,
           @MiddleName,
           @DOB, 
           @Gender,
           @MessageDate, 
           @MessageType, 
           @MessageTrigger,
           @Source, 
           @Location,
           --@InsertDate, 
		   @MetaData,
           @Message,
		   @Face,
		   @Connection)
END

GO
GRANT ALTER ON [dbo].[sp_tdsInsert] TO [db_executor] AS [dbo]
GO
GRANT CONTROL ON [dbo].[sp_tdsInsert] TO [db_executor] AS [dbo]
GO
GRANT EXECUTE ON [dbo].[sp_tdsInsert] TO [db_executor] AS [dbo]
GO
GRANT TAKE OWNERSHIP ON [dbo].[sp_tdsInsert] TO [db_executor] AS [dbo]
GO
GRANT VIEW DEFINITION ON [dbo].[sp_tdsInsert] TO [db_executor] AS [dbo]
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'v_count_stays_by_week', NULL,NULL))
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
         Begin Table = "encounters"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 241
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
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_count_stays_by_week'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'v_count_stays_by_week', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_count_stays_by_week'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'v_monthly_encounter', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[46] 4[15] 2[20] 3) )"
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
         Begin Table = "encounters"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 240
               Right = 241
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "facility"
            Begin Extent = 
               Top = 6
               Left = 279
               Bottom = 170
               Right = 449
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
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_monthly_encounter'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'v_monthly_encounter', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_monthly_encounter'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'v_vis_by_fac_by_mo', NULL,NULL))
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
         Begin Table = "a"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 241
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "b"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 136
               Right = 416
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
      Begin ColumnWidths = 12
         Column = 3855
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_vis_by_fac_by_mo'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'v_vis_by_fac_by_mo', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_vis_by_fac_by_mo'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'v_weekly_encounter', NULL,NULL))
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
         Begin Table = "encounters"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 257
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "facility"
            Begin Extent = 
               Top = 6
               Left = 295
               Bottom = 102
               Right = 481
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
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_weekly_encounter'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'v_weekly_encounter', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_weekly_encounter'
GO
USE [master]
GO
ALTER DATABASE [TDS] SET  READ_WRITE 
GO
