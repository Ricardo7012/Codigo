
EXEC sp_configure 'show advanced options', 1
GO
RECONFIGURE;
GO
EXEC sp_configure 'xp_cmdshell', 1
GO
RECONFIGURE;
GO

--SELECT @@SERVERNAME
BEGIN
--SELECT LEFT(ltrim(rtrim(@@ServerName)), Charindex('\', ltrim(rtrim(@@ServerName))) -1)
Declare @ip varchar(40)
Declare @ipLine varchar(200)  
Declare @pos int  
set nocount on            
	set @ip = NULL            
	Create table #temp (ipLine varchar(200))            
	Insert #temp exec master..xp_cmdshell 'ipconfig'            
	select @ipLine = ipLine            
	from #temp            
	where upper (ipLine) like '%IP ADDRESS%'            
	if (isnull (@ipLine,'***') != '***')            
	begin                   
		set @pos = CharIndex (':',@ipLine,1);                  
		set @ip = rtrim(ltrim(substring (@ipLine ,                  
		@pos + 1 ,                  
		len (@ipLine) - @pos)))             
	end   
	--SELECT * FROM #temp WHERE ipLine LIKE '%IPv4%'
	SELECT RIGHT(ipLine,15) as 'IP', @@SERVERNAME as 'ServerName' FROM #temp WHERE ipLine LIKE '%IPv4%'
DROP TABLE #temp  
SET NOCOUNT OFF  
END   
--declare @ip varchar(40)  
--exec sp_get_ip_address @ip out  print @ip

EXEC sp_configure 'show advanced options', 1
GO
RECONFIGURE;
GO
EXEC sp_configure 'xp_cmdshell', 0
GO
RECONFIGURE;
GO
