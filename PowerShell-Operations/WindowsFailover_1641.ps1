Get-winEvent -ComputerName QLVNNCOR01 -filterHashTable @{logname ='Microsoft-Windows-FailoverClustering/Operational'; id=1641}| ft -AutoSize -Wrap 
