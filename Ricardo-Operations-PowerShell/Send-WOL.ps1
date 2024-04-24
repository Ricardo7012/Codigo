Clear-Host

Set-ExecutionPolicy Unrestricted -Force

function Send-WOL
{
<# 
  .SYNOPSIS  
    Send a WOL packet to a broadcast address
  .PARAMETER mac
   The MAC address of the device that need to wake up
  .PARAMETER ip
   The IP address where the WOL packet will be sent to
  .EXAMPLE 
   Send-WOL -mac 00:50:56:B8:5A:C4 -ip 172.18.207.132 
#>

[CmdletBinding()]
param(
[Parameter(Mandatory=$True,Position=1)]
[string]$mac,
[string]$ip, 
[int]$port
)
$broadcast = [Net.IPAddress]::Parse($ip)
 
$mac=(($mac.replace(":","")).replace("-","")).replace(".","")
$target=0,2,4,6,8,10 | % {[convert]::ToByte($mac.substring($_,2),16)}
$packet = (,[byte]255 * 6) + ($target * 16)
 
$UDPclient = new-Object System.Net.Sockets.UdpClient
$UDPclient.Connect($broadcast,$port)
[void]$UDPclient.Send($packet, 102) 
return $packet
}

Write-Host "MAC: $mac"
Write-Host "IP: $ip"
Write-Host "PORT: $port"

Send-WOL -mac 00:50:56:B8:5A:C4 -ip 172.18.207.132 -port 8

ping QVSQLHSP02 -n 3
