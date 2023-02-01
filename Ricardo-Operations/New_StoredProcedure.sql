-- =============================================
-- AUTHOR:		
-- CREATE DATE: 
-- DESCRIPTION:	
-- DATABASES USED:
-- TABLES USED:
-- TEST EXECUTION TIME:
-- TEST ROWS: 
-- 
--[schema].[prefix][Action][Object]

--Schema -> dbo, ssrs, etc.
--Prefix -> usp (lower case)
--Action -> Insert, Delete, Update, Select, Get, Validate, etc.
--Object -> Member, etc.

-- =============================================
CREATE PROCEDURE ssrs.usp_Action_Object
	@Param1 int, 
	@Param2 bit

	-- ENCRYPTION FOR PRODUCTION ONLY
	-- THIS IS A BEST PRACTICE TO PREVENT ACCIDENTAL CHANGES 
	-- MUST ENSURE CODE IS IN SOURCE CONTROL
--WITH ENCRYPTION
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

    --T-SQL HERE
	SELECT COUNT(*) FROM HSP_CT.dbo.Accounts WITH (NOLOCK)
END
GO
