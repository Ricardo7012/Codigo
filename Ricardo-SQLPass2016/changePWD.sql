/* 
FIND THE SA USER MEMBERNAME
sqlcmd -S D7HBLUE01A667\maps -i "C:\SQL\changePWD.sql" -o "C:\SQL\Output.txt"

IF ERROR: 

Named Pipes Provider: Could not open a connection to SQL Server [2].
Sqlcmd: Error: Microsoft SQL Server Native Client 10.0 : A network-related or instance-specific
error has occurred while establishing a connection to SQL Server. Server is not found or not
accessible. Check if instance name is correct and if SQL Server is configured to allow remote
connections. 
http://blog.mclaughlinsoftware.com/2009/05/16/fix-sql-server-2008-client/
*/

SET NOCOUNT ON
GO
PRINT '';
SELECT @@SERVERNAME AS [ServerName], GETDATE() AS [Date_Time], SUSER_NAME('1') AS 'SUSER_Name', CONVERT(CHAR(13), SERVERPROPERTY('ProductVersion')) AS [ProductVersion];
GO

BEGIN TRY
	ALTER LOGIN sa WITH PASSWORD = '1234567890';
END TRY
BEGIN CATCH
	SELECT
         ERROR_NUMBER() AS ErrorNumber
        ,UPPER(ERROR_MESSAGE()) AS ErrorMessage;
END CATCH;
GO

PRINT '****************Completed LOGIN sa change!******************************';