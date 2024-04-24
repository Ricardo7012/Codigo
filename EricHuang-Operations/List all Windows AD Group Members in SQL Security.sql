/* SQL Server - Windows/AD Group Membership List*/

DECLARE @CurrentRow INT
DECLARE @TotalRows INT
SET @CurrentRow = 1

DECLARE  @SqlGroupMembership  TABLE(
    ACCOUNT_NAME      SYSNAME,
    ACCOUNT_TYPE      VARCHAR(30),
    ACCOUNT_PRIVILEGE VARCHAR(30),
    MAPPED_LOGIN_NAME SYSNAME,
    PERMISSION_PATH   SYSNAME
    )

DECLARE @WindowsGroupsOnServer TABLE(
	  UniqueRowID int IDENTITY (1, 1) Primary key NOT NULL 
	, Name		SYSNAME
	)
	
INSERT INTO @WindowsGroupsOnServer (NAME)
SELECT [NAME] FROM master.sys.server_principals WHERE TYPE = 'G' 

SELECT @TotalRows = MAX(UniqueRowID) FROM @WindowsGroupsOnServer

DECLARE @WindowsGroupName sysname 


-- Loop Each Windows Group present on the server
WHILE @CurrentRow <= @TotalRows 
   BEGIN 
  
  SELECT @WindowsGroupName  = [Name] 
  FROM @WindowsGroupsOnServer
  WHERE UniqueRowID = @CurrentRow 
  
	   BEGIN TRY
	   -- Insert found logins into table variable
	   INSERT INTO @SqlGroupMembership (ACCOUNT_NAME,ACCOUNT_TYPE,ACCOUNT_PRIVILEGE,MAPPED_LOGIN_NAME,PERMISSION_PATH)
       EXEC xp_logininfo @WindowsGroupName , 'members' 
	   END TRY

	   BEGIN CATCH
	   -- No action for if xp_logininfo fails
       END CATCH
       
	SELECT @CurrentRow = @CurrentRow + 1   
	
   END 
   
-- Display final results
SELECT  @@servername AS Servername
				, [PERMISSION_PATH] AS WindowsGroup
				, Account_Name
				, Mapped_Login_Name
				, Account_Type
				, Account_Privilege
FROM @SqlGroupMembership ORDER BY [PERMISSION_PATH], [ACCOUNT_NAME]
