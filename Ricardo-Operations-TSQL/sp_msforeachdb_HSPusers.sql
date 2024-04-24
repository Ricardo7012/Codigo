-- ************************************
-- PART 1
-- ************************************

USE [master]
GO
CREATE LOGIN [IEHP\HSP3BackupOperator] FROM WINDOWS WITH DEFAULT_DATABASE= [HSP_CT]
GO
CREATE LOGIN [IEHP\HSP3DataReader] FROM WINDOWS WITH DEFAULT_DATABASE= [HSP_CT]
GO
CREATE LOGIN [IEHP\HSP3DataWriter] FROM WINDOWS WITH DEFAULT_DATABASE= [HSP_CT]
GO
CREATE LOGIN [IEHP\HSP3DBOwner] FROM WINDOWS WITH DEFAULT_DATABASE= [HSP_CT]
GO
CREATE LOGIN [IEHP\HSP3Admins] FROM WINDOWS WITH DEFAULT_DATABASE= [HSP_CT]
GO


-- ************************************
-- PART 2
-- ************************************
DECLARE @sql1 varchar(1000)
DECLARE @sql2 varchar(1000) 

--SET @sql2 = 'CREATE USER [IEHP\HSP3BackupOperator] FOR LOGIN [IEHP\HSP3BackupOperator]'
--SET @sql2 = 'CREATE USER [IEHP\HSP3DataReader] FOR LOGIN [IEHP\HSP3DataReader]'
--SET @sql2 = 'CREATE USER [IEHP\HSP3DataWriter] FOR LOGIN [IEHP\HSP3DataWriter]'
--SET @sql2 = 'CREATE USER [IEHP\HSP3DBOwner] FOR LOGIN [IEHP\HSP3DBOwner]'
--SET @sql2 = 'CREATE USER [IEHP\HSP3Admins] FOR LOGIN [IEHP\HSP3Admins]'

--SET @sql2 = 'DROP USER [IEHP\HSP3BackupOperator]'
--SET @sql2 = 'DROP USER [IEHP\HSP3DataReader]'
--SET @sql2 = 'DROP USER [IEHP\HSP3DataWriter]'
--SET @sql2 = 'DROP USER [IEHP\HSP3DBOwner]'
--SET @sql2 = 'DROP USER [IEHP\HSP3Admins]'

--SELECT @sql1 = 'USE ? ; ' + @sql2
SELECT @sql1 = 'USE [?]
IF ''?'' <> ''master'' AND ''?'' <> ''model'' AND ''?'' <> ''msdb'' AND ''?'' <> ''tempdb''
BEGIN
USE [?] 
' + @sql2 + 
'END'
EXEC sp_msforeachdb @sql1 
PRINT @sql1 
--PRINT @sql2

-- ************************************
-- PART 3
-- ************************************
Use master
GO
--[IEHP\HSP3BackupOperator] --db_backupoperator
--[IEHP\HSP3DataReader]		--db_datareader
--[IEHP\HSP3DataWriter]		--db_datawriter
--[IEHP\HSP3DBOwner]		--db_owner
--[IEHP\HSP3Admins]			-- Server roles will ONLY be done manually

DECLARE @user VARCHAR(50) = '[IEHP\HSP3DataReader]'
DECLARE @role VARCHAR(50) = 'db_datareader'

DECLARE @dbname VARCHAR(50)   
DECLARE @statement NVARCHAR(max)

DECLARE db_cursor CURSOR 
LOCAL FAST_FORWARD
FOR  
SELECT name
FROM MASTER.dbo.sysdatabases
WHERE name NOT IN ('master','model','msdb','tempdb')  
OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @dbname  
WHILE @@FETCH_STATUS = 0  
BEGIN  

SELECT @statement = 'USE '+@dbname +'; '+ 
'CREATE USER '+ @user +' FOR LOGIN '+ @user +'; 
EXEC sp_addrolemember '''+ @role +''', '+ @user +';'

PRINT @statement

EXEC sp_executesql @statement

FETCH NEXT FROM db_cursor INTO @dbname  
END  
CLOSE db_cursor  
DEALLOCATE db_cursor 


CREATE ROLE [IEHP_Execute_Procedures] AUTHORIZATION [dbo]
GO
ALTER ROLE [IEHP_Execute_Procedures] ADD MEMBER [IEHP\HSP3DataReader]
GO
--GRANT EXECUTE ON [dbo].[clr_CheckPasswordComplexity] TO [IEHP_Execute_Procedures]
--GO

-- ************************************
-- PART 4 GRANT EXECUTE ON ALL SYSOBJECTS TYPE=P
-- ************************************
--[IEHP\HSP3BackupOperator] --db_backupoperator
--[IEHP\HSP3DataReader] --db_datareader
--[IEHP\HSP3DataWriter] --db_datawriter
--[IEHP\HSP3DBOwner] --db_owner
--[IEHP\HSP3Admins] -- Server roles will ONLY be done manually

DECLARE @user VARCHAR(50) = '[IEHP_Execute_Procedures]'
DECLARE @spname VARCHAR(50)   
DECLARE @statement NVARCHAR(max)

DECLARE db_cursor CURSOR 
LOCAL FAST_FORWARD
FOR  
	SELECT 
		[name]
	FROM dbo.sysobjects
	WHERE (type = 'P') 
	ORDER BY NAME
	OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @spname  
WHILE @@FETCH_STATUS = 0  
BEGIN  
	SELECT @statement = 'GRANT EXECUTE ON OBJECT:: ' + @spname + '
		TO ' + @user 
	PRINT @statement
	EXEC sp_executesql @statement
FETCH NEXT FROM db_cursor INTO @spname  
END  
CLOSE db_cursor  
DEALLOCATE db_cursor 
GO
