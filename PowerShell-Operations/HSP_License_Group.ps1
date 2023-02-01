###################################################
# CREATE GROUP
###################################################
$ComputerName = $env:ComputerName 
$cn = [ADSI]"WinNT://$ComputerName"
$group = $cn.Create(“Group”,”HSP”)
$group.SetInfo()
$group.description = “HSP group needed for HSPLicense created by [IT - Database Management]”
$group.SetInfo()

###################################################
# ADD AD USERS
###################################################
$domain = "IEHP"
$user1 = "HSPLICSRV"
$user2 = "HSPAdmin"

$group = [ADSI]"WinNT://$ComputerName/HSP,Group"
$group.Add("WinNT://$ComputerName/$domain/$user1,User")
$group.Add("WinNT://$ComputerName/$domain/$user2,User")
