 
$DomainName = "IEHP"
$ComputerName = "localhost"
$UserName = ""
$AdminGroup = [ADSI]"WinNT://$ComputerName/Administrators,group"
$User = [ADSI]"WinNT://$DomainName/$UserName,user"
$AdminGroup.Add($User.Path)