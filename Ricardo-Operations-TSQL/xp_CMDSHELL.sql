--SELECT  *
--FROM    sys.configurations
--ORDER BY name;

EXEC sp_configure 'xp_cmdshell', 1 ;  
GO  
RECONFIGURE ;  
GO  

--EXEC master..xp_cmdshell 'bcp "select top 10 * from HSP_Supplemental.dbo.filelog " Queryout \\iehpshare\csr\Test.sylk -eTest.err -c -b5000 -S HSP3S1A -T'
EXEC master..xp_cmdshell 'bcp "select top 10 * from HSP_Supplemental.dbo.filelog " Queryout \\iehpshare\csr\Test.xlsx -t, -c -w -S HSP3S1A -T'
GO

EXEC sp_configure 'xp_cmdshell', 0 ;  
GO  
RECONFIGURE ;  
GO  

EXEC sp_configure 'Ad Hoc Distributed Queries', 1;  
GO  
RECONFIGURE;  
GO  
RECONFIGURE; 
EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1;   
EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParam', 1;

INSERT  INTO OPENROWSET('Microsoft.Jet.OLEDB.4.0',
                        'Excel 8.0;Database=\\iehpshare\csr\testing.xlsx;',
                        'SELECT Name, Date FROM [Sheet1$]')
        SELECT  [name] ,
                GETDATE()
        FROM    msdb.dbo.sysjobs;
GO

sp_configure 'show advanced options', 0; 
GO 
EXEC sp_configure 'Ad Hoc Distributed Queries', 0;  
GO  
RECONFIGURE;  
GO


SELECT  *
FROM    sys.configurations
ORDER BY name;
