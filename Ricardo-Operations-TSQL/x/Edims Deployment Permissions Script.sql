-- Make sure IEHP\_EDPIntake is mapped to the relevant databases: 
--	EdiManagementHub,
--	EdiManagementBlob,
--	HspMember,
--	Member,
--	MemberDoc,
--	X12277CA,
--	X124010,
--	X12834,
--	X12837I,
--	X12837P,
--	X12999,
--	X12TA1
-- [ServerName] -> Security -> Logins -> (Right click) IEHP\_EDPIntake -> User Mappings -> Check relevant databases


EXEC sp_MSforeachdb N'
IF N''?'' NOT IN(''master'', ''model'', ''msdb'', ''LiteSpeedLocal'',''tempdb'')
BEGIN
USE [?];
CREATE ROLE db_executor
GRANT EXECUTE TO db_executor;
ALTER ROLE [db_datareader]		ADD MEMBER [IEHP\_EDPIntake];
ALTER ROLE [db_executor]		ADD MEMBER [IEHP\_EDPIntake];
ALTER ROLE [db_datawriter]		ADD MEMBER [IEHP\_EDPIntake];
END;
';
GO