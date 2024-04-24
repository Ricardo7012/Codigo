# CreateLocalGroup
$Computer = $env:COMPUTERNAME
$ADSI = [ADSI]("WinNT://$Computer") 
$Group = $ADSI.Create('Group', 'HSP') 
$Group.SetInfo() 
$Group.Description  = 'SQL READ Permissions - CONTACT DG DBA FOR CHANGES'
$Group.SetInfo()

$LocalGroup1 = "5days_W"
$LocalGroup2 = "5days_R"
#$Computer    = $env:COMPUTERNAME
$Domain      = $env:userdomain

([ADSI]"WinNT://$Computer/$LocalGroup1,group")
([ADSI]"WinNT://$Computer/$LocalGroup2,group")

