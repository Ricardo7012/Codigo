
USE [HSP_Supplemental]
GO
CREATE ROLE [SpecialProgramsAdmin] AUTHORIZATION [dbo]
GO
GRANT SELECT ON [Landmark].[Optout] TO [SpecialProgramsAdmin]
GO
--GRANT DELETE ON [Landmark].[Optout] TO [SpecialProgramsAdmin]
--GO
GRANT INSERT ON [Landmark].[Optout] TO [SpecialProgramsAdmin]
GO
GRANT UPDATE ON [Landmark].[Optout] TO [SpecialProgramsAdmin]
GO
GRANT SELECT ON [Landmark].[MemberInclusion] TO [SpecialProgramsAdmin]
GO
--GRANT DELETE ON [Landmark].[MemberInclusion] TO [SpecialProgramsAdmin]
--GO
GRANT INSERT ON [Landmark].[MemberInclusion] TO [SpecialProgramsAdmin]
GO
GRANT UPDATE ON [Landmark].[MemberInclusion] TO [SpecialProgramsAdmin]
GO

USE [HSP_Supplemental]
GO
CREATE ROLE [SpecialProgramsUser] AUTHORIZATION [dbo]
GO
GRANT SELECT ON [Landmark].[Optout] TO [SpecialProgramsUser]
GO
GRANT SELECT ON [Landmark].[MemberInclusion] TO [SpecialProgramsUser]


USE [master]
GO
CREATE LOGIN [IEHP\SpecialProgramsAdmin] FROM WINDOWS WITH DEFAULT_DATABASE=[tempdb]
GO
USE [HSP_Supplemental]
GO
CREATE USER [IEHP\SpecialProgramsAdmin] FOR LOGIN [IEHP\SpecialProgramsAdmin]
GO
ALTER ROLE [SpecialProgramsAdmin] ADD MEMBER [IEHP\SpecialProgramsAdmin]
GO

USE [master]
GO
CREATE LOGIN [IEHP\SpecialProgramsUser] FROM WINDOWS WITH DEFAULT_DATABASE=[tempdb]
GO
USE [HSP_Supplemental]
GO
CREATE USER [IEHP\SpecialProgramsUser] FOR LOGIN [IEHP\SpecialProgramsUser]
GO
ALTER ROLE [SpecialProgramsUser] ADD MEMBER [IEHP\SpecialProgramsUser]
GO
