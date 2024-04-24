/*

Collected the Name of Windows Server Information from the below link
http://en.wikipedia.org/wiki/List_of_Microsoft_Windows_versions

The below script will only work on Windows Server Editions only 

****NOT for the Windows Clinet Version (like Windows 7, Windows 8 etc.,

Script by Satish Kumar Gajula
*/
CREATE TABLE #WinNames
(
WinID float,
WinName varchar(max)
)
insert into #WinNames values (3.10,'Windows NT 3.1')
insert into #WinNames values (3.50,'Windows NT 3.5')
insert into #WinNames values (3.51,'Windows NT 3.51')
insert into #WinNames values (4.0,'Windows NT 4.0')
insert into #WinNames values (5.0,'Windows 2000')
insert into #WinNames values (5.1,'Windows Server 2003')
insert into #WinNames values (5.2,'Windows Server 2003 R2')
insert into #WinNames values (3.50,'Windows NT 3.5')
insert into #WinNames values (3.10,'Windows NT 3.1')
insert into #WinNames values (6.0,'Windows Server 2008')
insert into #WinNames values (6.1,'Windows Server 2008 R2')
insert into #WinNames values (6.2,'Windows Server 2012')
insert into #WinNames values (6.3,'Windows Server 2012 R2')

SELECT OSVersion =RIGHT(@@version, LEN(@@version)- 3 -charindex (' ON ', @@VERSION)) into #WVer

select SUBSTRING(OSVersion, 11,4 ) AS WinID, OSVersion into  #WVer1 from #WVer


select WN.WinName, wn1.OSVersion 
from #WinNames WN
inner join #WVer1 wn1
on wn1.WinID = wn.WinID

drop table #WVer1
drop table #WVer
drop table #WinNames