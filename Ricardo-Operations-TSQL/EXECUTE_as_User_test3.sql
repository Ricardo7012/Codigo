SET STATISTICS TIME, IO ON;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
--GRANT EXEC ON xp_readerrorlog TO [iehp\i7850];

--CHECK TRUSTWORHTY
--SELECT name,is_trustworthy_on FROM sys.databases 
-- ALTER DATABASE [?] SET TRUSTWORTHY ON;

SELECT @@ServerName
     , CURRENT_USER AS CU
	 , SYSTEM_USER AS SU
	 , USER_NAME() AS UN
     , GETDATE() AS DT;

EXECUTE AS USER = 'IEHP\i4019';
SELECT @@ServerName
     , CURRENT_USER AS CU
	 , SYSTEM_USER AS SU
	 , USER_NAME() AS UN
     , GETDATE() AS DT;
--EXEC sp_readerrorlog 0, 1, 'ERROR', '';

--SELECT [sourceseq]
--      ,[fldABA]
--      ,[fldAccount]
--      ,[fldAccountID]
--      ,[fldText1]
--  FROM [ACH_Claims].[dbo].[tblAccounts]
--GO

SELECT * FROM fn_my_permissions(NULL,NULL)


REVERT;
GO
REVERT;
GO

SELECT @@ServerName
     , CURRENT_USER AS CU
	 , SYSTEM_USER AS SU
	 , USER_NAME() AS UN
     , GETDATE() AS DT;

--1.Value of error log file you want to read: 0 = current, 1 = Archive #1, 2 = Archive #2, etc... 
--2.Log file type: 1 or NULL = error log, 2 = SQL Agent log 
--3.Search string 1: String one you want to search for 
--4.Search string 2: String two you want to search for to further refine the results

SET STATISTICS TIME, IO OFF;

