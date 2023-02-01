##Disk Size and Percentage
cls
Get-WMIObject Win32_LogicalDisk -Filter "DriveType=3" -Computer . | Select SystemName, DeviceID, VolumeName, @{Name="Total Size (GB)"; Expression={"{0:N1}" -F ($_.Size/1GB)}}, @{Name="Free Space (GB)"; Expression={"{0:N1}" -F ($_.Freespace/1GB)}}, @{Name="Free Space %"; Expression={"{0:N1}" -F (($_.Freespace/$_.Size)*100)}} | FT -AutoSize

