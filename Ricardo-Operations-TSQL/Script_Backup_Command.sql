set nocount on;

Declare @sql varchar(max),@count int = 0, @max int,@folder varchar(128),@DayDate VARCHAR(256)
IF OBJECT_ID('tempdb..#Results') IS NOT NULL DROP TABLE #Results

select RANK() over(order by Database_ID) rownum,name
into #Results
from sys.databases
where name <> 'tempdb'

select @max = count(1)
from #Results

set @folder = '\\dtsqlbkups\qvsqllit01backups\Production\MTSQLINT\'

SET @DayDate = Convert(varchar(8),RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(DAY, GETDATE())), 2))



while(@count < @max)
Begin

select @sql = 'BACKUP DATABASE '+name+' TO DISK='''+@folder+Convert(varchar(8),YEAR(GETDATE()))+Convert(varchar(8),RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(MONTH, GETDATE())), 2))+@DayDate+'_'+REPLACE(@@SERVERNAME,'\','_')+'_'+name+'.bak'+''' WITH COPY_ONLY, FORMAT,COMPRESSION, STATS=1;'
from #Results
where rownum = @count + 1

print @sql
--exec(@sql)

set @count = @count + 1

End

IF OBJECT_ID('tempdb..#Results') IS NOT NULL DROP TABLE #Results
