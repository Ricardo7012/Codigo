#
Clear-Host
$env:COMPUTERNAME


# DONT RUN AS ADMIN
# BEST IF WE CHOOSE 7 DRIVE LETTERS AND ADD WITH GP

Get-SmbMapping

$cred = Get-Credential -Credential iehp\sqladmin9
New-PSDrive -Name "Q" -Root "\\172.18.204.31\smbtest\test" -Persist -PSProvider "FileSystem" -Credential $cred -Scope Global
Net Use                        
New-PSDrive -Name "R" -Root "\\172.18.204.32\smbtest\test" -Persist -PSProvider "FileSystem" -Credential $cred -Scope Global
Net Use                        
New-PSDrive -Name "U" -Root "\\172.18.204.33\smbtest\test" -Persist -PSProvider "FileSystem" -Credential $cred -Scope Global
Net Use                        
New-PSDrive -Name "V" -Root "\\172.18.204.34\smbtest\test" -Persist -PSProvider "FileSystem" -Credential $cred -Scope Global
Net Use                        
New-PSDrive -Name "W" -Root "\\172.18.204.35\smbtest\test" -Persist -PSProvider "FileSystem" -Credential $cred -Scope Global
Net Use                       
New-PSDrive -Name "X" -Root "\\172.18.204.36\smbtest\test" -Persist -PSProvider "FileSystem" -Credential $cred -Scope Global
Net Use                        
New-PSDrive -Name "Y" -Root "\\172.18.204.37\smbtest\test" -Persist -PSProvider "FileSystem" -Credential $cred -Scope Global
Net Use                        

Get-SMBMapping

#Remove-PSDrive -Name "Q" -Force
#Remove-PSDrive -Name "R" -Force
#Remove-PSDrive -Name "U" -Force
#Remove-PSDrive -Name "V" -Force
#Remove-PSDrive -Name "W" -Force
#Remove-PSDrive -Name "X" -Force
#Remove-PSDrive -Name "Y" -Force

