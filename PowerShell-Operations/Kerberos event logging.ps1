#How to enable Kerberos event logging 
# -- https://support.microsoft.com/en-in/help/262177/how-to-enable-kerberos-event-logging

New-Item          -Path HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\Kerberos\Parameters -Name "LogLevel" -Value "1" -Force
New-ItemProperty  -Path HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\Kerberos\Parameters -Name "LogLevel" -PropertyType DWORD -Value '1'

#
Remove-ItemProperty  -Path HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\Kerberos\Parameters -Name "LogLevel" 
