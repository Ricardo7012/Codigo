--*****************************
ALTER DATABASE [EdiManagement]
MODIFY FILE (NAME = [EdiManagement_log], 
FILENAME = 'L:\MSSQL\Data\EdiManagement_log.ldf');  
GO  
--*****************************
ALTER DATABASE [EDIOutbound]
MODIFY FILE (NAME = [EDIOutbound_log], 
FILENAME = 'L:\MSSQL\Data\EDIOutbound_log.ldf');  
GO  
--*****************************
ALTER DATABASE [IEHP_ProcessTempDB]
MODIFY FILE (NAME = [IEHP_ProcessTempDB_log], 
FILENAME = 'L:\MSSQL\Data\IEHP_ProcessTempDB_log.ldf');  
GO  
--*****************************
ALTER DATABASE [WPC_837I]
MODIFY FILE (NAME = [WPC_837I_log], 
FILENAME = 'L:\MSSQL\Data\WPC_837I_log.ldf');  
GO  
--*****************************
ALTER DATABASE [WPC_837P]
MODIFY FILE (NAME = [WPC_837P_log], 
FILENAME = 'L:\MSSQL\Data\_log.ldf');  
GO  
--*****************************
ALTER DATABASE [WPC_Valid_837I]
MODIFY FILE (NAME = [WPC_Valid_837I_log], 
FILENAME = 'L:\MSSQL\Data\WPC_Valid_837I_log.ldf');  
GO  
--*****************************
ALTER DATABASE [WPC_Valid_837P]
MODIFY FILE (NAME = [WPC_Valid_837P_log], 
FILENAME = 'L:\MSSQL\Data\WPC_Valid_837P_log.ldf');  
GO  
