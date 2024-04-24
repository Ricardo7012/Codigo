--https://www.mssqltips.com/sqlservertip/2191/how-to-check-sql-server-authentication-mode-using-t-sql-and-ssms/

DECLARE @AuthenticationMode INT  
EXEC master.dbo.xp_instance_regread N'HKEY_LOCAL_MACHINE', 
N'Software\Microsoft\MSSQLServer\MSSQLServer',   
N'LoginMode', @AuthenticationMode OUTPUT  

SELECT CASE @AuthenticationMode    
WHEN 1 THEN 'Windows Authentication'   
WHEN 2 THEN 'Windows and SQL Server Authentication'   
ELSE 'Unknown'  
END as [Authentication Mode]  
GO
SELECT CASE SERVERPROPERTY('IsIntegratedSecurityOnly')   
WHEN 1 THEN 'Windows Authentication'   
WHEN 0 THEN 'Windows and SQL Server Authentication'   
END as [Authentication Mode]  
GO
EXEC master.sys.xp_loginconfig 'login mode' 
GO
