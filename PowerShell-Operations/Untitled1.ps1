<#
.SYNOPSIS
   <A brief description of the script>
.DESCRIPTION
   <A detailed description of the script>
.PARAMETER <paramName>
   <Description of script parameter>
.EXAMPLE
   <An example of using the script>
#>

CLS 
$Computer = $env:COMPUTERNAME $ADSI = [ADSI]("WinNT://$Computer") $Group = $ADSI.Create('Group', '5Star') $Group.SetInfo() $Group.Description = 'SQL READ Permissions - CONTACT DG DBA FOR CHANGES' $Group.SetInfo()
