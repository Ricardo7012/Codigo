CLS
Get-Service -ComputerName bizprod -name "EDPS*"

Get-Service -ComputerName bizprod -Name "EDPS.Enrichment.837I" | Restart-Service
Get-Service -ComputerName bizprod -Name "EDPS.Enrichment.837P" | Restart-Service
#Get-Service -ComputerName bizprod -Name "EDPS.Reporting.EVR" | Restart-Service
Get-Service -ComputerName bizprod -Name "EDPS.Validation.837I" | Restart-Service
Get-Service -ComputerName bizprod -Name "EDPS.Validation.837P" | Restart-Service
Get-Service -ComputerName bizprod -Name "EDPS.Validation.SLDeDupe" | Restart-Service

Get-Service -ComputerName bizprod -name "EDPS*"
