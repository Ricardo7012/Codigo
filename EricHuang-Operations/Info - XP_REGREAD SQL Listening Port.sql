DECLARE @InstName VARCHAR(16)
DECLARE @RegLoc VARCHAR(100)

SELECT @InstName = @@SERVICENAME

IF @InstName = 'MSSQLSERVER'
  BEGIN
    SET @RegLoc='Software\Microsoft\MSSQLServer\MSSQLServer\SuperSocketNetLib\Tcp\'
  END
 ELSE
  BEGIN
   SET @RegLoc='Software\Microsoft\Microsoft SQL Server\' + @InstName + '\MSSQLServer\SuperSocketNetLib\Tcp\'
  END

EXEC [master].[dbo].[xp_regread] 'HKEY_LOCAL_MACHINE', @RegLoc, 'tcpPort'