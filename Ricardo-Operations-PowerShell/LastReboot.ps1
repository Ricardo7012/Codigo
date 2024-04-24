#RUN AS ADMIN# 
Get-EventLog -ComputerName . -LogName System -After 1/1/2024 | Where-Object {$_.EventID -eq 1074} #| fl
Get-EventLog -ComputerName . -LogName System -After 1/1/2024 | Where-Object {$_.EventID -eq 6008} #| fl

#
Get-EventLog -ComputerName . -LogName System -After 1/1/2024 | Where-Object {$_.EventID -eq "6006" -or $_.EventID -eq "1074" -or $_.EventID -eq "6008"} | ft Machinename, TimeWritten, UserName, EventID, Message -AutoSize -Wrap

$xml=@'
<QueryList>
<Query Id="0" Path="System">
<Select Path="System">*[System[(EventID=6008)]]</Select>
</Query>
</QueryList>
'@
 
Get-WinEvent -FilterXml $xml -MaxEvents 2

whoami