################################################################################################ 
## https://docs.microsoft.com/en-us/sql/database-engine/install-windows/install-sql-server-2016-from-the-command-prompt
################################################################################################

Setup.exe 
/q 
/ACTION=Install 
/FEATURES=SQL 
/INSTANCENAME=MSSQLSERVER 
/SQLSVCACCOUNT="<DomainName\UserName>" 
/SQLSVCPASSWORD="<StrongPassword>" 
/SQLSYSADMINACCOUNTS="<DomainName\UserName>" 
/AGTSVCACCOUNT="NT AUTHORITY\Network Service" 
/SQLSVCINSTANTFILEINIT="True" 
/IACCEPTSQLSERVERLICENSETERMS 

