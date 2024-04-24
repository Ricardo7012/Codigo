#DOMAIN FIREWALL MUST BE OFF
# shutdown /r /f /t 0

clear-host
Get-Date
ping -n 1 RFWIN10

Restart-Computer -ComputerName  "RFWIN10.IEHP.LOCAL" -force

ping  RFWIN10 -t

#Get-ADuser -Filter "Name -eq 'RabbitMQLDAP'"
