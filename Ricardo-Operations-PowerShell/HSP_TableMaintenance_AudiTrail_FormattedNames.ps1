## VERSION ##  Compress-Archive REQUIRES 5.0 ONLY 2 GB limit 
## Compress-Archive is currently 2 GB. This is a limitation of the underlying API
## https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.archive/compress-archive?view=powershell-5.0
## Windows Management Framework 5.0 KB -- Win8.1AndW2K12R2-KB3134758-x64.msu 
## https://www.microsoft.com/en-us/download/details.aspx?id=50395

$PSVersionTable.PSVersion |

###############################################################################
#Copy the dbo.AuditTrail table to a local file.
#    2.1 Open an administrative Command Prompt.
#    2.2 Change the local directory to the desired directory for the BCP file.
#    2.3 Execute the command:
CLS
CD \
#CD "C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn"
CD "I:\MSSQL (x86)\Client SDK\ODBC\130\Tools\Binn" ## QVSQLHSP01

###############################################################################
CLS
$HostName = $env:computername |
$FilePath = "E:\Audit\" |
$FileName1 = $hostname+"_FormattedNames.dat" |
$FileName2 = $hostname+"_AuditTrail.dat" |


###############################################################################
## BCP ##
$SQLServer=$HostName+".iehp.local" |
bcp HSP_MO.dbo.FormattedNames out $FilePath$FileName1 -S $SQLServer -T -n |
bcp HSP_MO.dbo.AuditTrail out $FilePath$FileName2 -S $SQLServer -T -n |

## CONFIRM ## 
#Get-ChildItem -Path $FilePath

###############################################################################
## COMPRESS ## Compress-Archive 5.0 ONLY ## & RENAME ##

$datetime = Get-Date -uformat "%Y-%m-%d_%H-%M-%S_" |
$NewFileName1 = $datetime+$FileName1+".zip" |
$NewFileName2 = $datetime+$FileName2+".zip" |

New-Item -ItemType Directory -Path $FilePath"Temp" |

#Compress-Archive -Path $FilePath -DestinationPath $archive1 -Verbose -WhatIf
Compress-Archive -LiteralPath $FilePath$FileName1 -CompressionLevel Optimal -DestinationPath $FilePath"Temp\"$NewFileName1 #-WhatIf |
Compress-Archive -LiteralPath $FilePath$FileName2 -CompressionLevel Optimal -DestinationPath $FilePath"Temp\"$NewFileName2 #-WhatIf |

###############################################################################
## CLEANUP ##
Remove-Item -path $FilePath$FileName1 -Recurse -Force #-WhatIf |
Remove-Item -path $FilePath$FileName2 -Recurse -Force #-WhatIf |

###############################################################################
## MOVE ##
$Destination = "\\dtsqlbkups\qvsqllit01backups\NonProduction\~HSPTableArchive" |
Copy-Item -Path $FilePath"temp\"*.* -Destination $Destination -Force |

#Move-Item -Path $FilePath"temp\"*.* -Destination $Destination$NewFileName1 #-WhatIf
#Move-Item -Path $FilePath"temp\"*.* -Destination $Destination$NewFileName2 #-WhatIf

Remove-Item -Path $FilePath"Temp" -Recurse -Force |

###############################################################################
## CONFIRM CLEANUP ## 
#Get-ChildItem -Path $FilePath
