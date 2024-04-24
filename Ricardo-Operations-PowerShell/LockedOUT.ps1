## LockedOUT

#import-module ActiveDirectory

Get-ADUser i3246 -Properties Name,Lockedout, lastLogonTimestamp,lockoutTime,logonCount,pwdLastSet | Select-Object Name, Lockedout,@{n='LastLogon';e={[DateTime]::FromFileTime($_.lastLogonTimestamp)}},@{n='lockoutTime';e={[DateTime]::FromFileTime($_.lockoutTime)}},@{n='pwdLastSet';e={[DateTime]::FromFileTime($_.pwdLastSet)}},logonCount


##Search-ADAccount -UsersOnly -lockedout

