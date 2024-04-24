# CreateLocalGroup
$Computer = $env:COMPUTERNAME
$ADSI = [ADSI]("WinNT://$Computer") 
$Group = $ADSI.Create('Group', 'HSP') 
$Group.SetInfo() 
$Group.Description  = 'HSP REQ'
$Group.SetInfo()

$DomainUser1 = "HSPAdmin"
$DomainUser2 = "HSPLICSRV"
$DomainUser3 = "PVLICHSPSVC"
$LocalGroup  = "HSP"
#$Computer    = $env:COMPUTERNAME
$Domain      = $env:userdomain

([ADSI]"WinNT://$Computer/$LocalGroup,group").psbase.Invoke("Add",([ADSI]"WinNT://$Domain/$DomainUser1").path)

([ADSI]"WinNT://$Computer/$LocalGroup,group").psbase.Invoke("Add",([ADSI]"WinNT://$Domain/$DomainUser2").path)

([ADSI]"WinNT://$Computer/$LocalGroup,group").psbase.Invoke("Add",([ADSI]"WinNT://$Domain/$DomainUser3").path)
