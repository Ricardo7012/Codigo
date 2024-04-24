<#
# AUTHOR  : 	Victor Ashiedu
# WEBSITE : 	iTechguides.com
# BLOG    : 	iTechguides.com/blog
# CREATED : 	19-12-2014 
# UPDATED : 	18-02-2015 
# COMMENT : 	Get-FolderSize Function displays size of all folders in a 
#           	specified path. This tool is usefull if you want to determine 
#				large folders in a particular path. Multiple paths can be specified
# VERSION: 		2.1 
# CHANGE LOG: 	23/12/2014: Version 1.l -:  
				Version 1.0, used the parameter Greaterthan, Version 1.l Changed the parameter to FoldersOver
				
				18-02-2015: Version 2.0 -:
				#1 Added the Recurse parameter: Displays size of folder and sub-folders
				#2 Function displays folders less than or equal to 1GB in MB, and all folders
				Greater than 1GB in GB.
				#3 Amended function to display only folders that are greater than or equal to 100 MB.
				#4 Changed the report header "Path" to "Full Path". 
				#5 Including console info while user is awaiting result. 
           
#>
Function Get-FolderSize 
{

<#
.SYNOPSIS
	Get-FolderSize Function displays size of all folders in a specified path. 
	
.DESCRIPTION

	Get-FolderSize Function allows you to return folders greater than a specified size.
	See examples below for more info. 
	
.PARAMETER FolderPath
	Specifies the path you wish to check folder sizes. For example \\70411SRV\EventLogs
	Will return sizes (in GB) of all folders in \\70411SRV\EventLogs. FolderPath accepts
	both UNC and local path format. You can specify multiple paths in quotes, seperated
	by commas. 
	
.PARAMETER FoldersOver
	This parameter is specified in whole numbers (but represents values in GB). It instructs
	the Get-FolderSize function to return only folders greater than or equal to the specified
	value in GB. 
	
.PARAMETER Recurse
	If this parameter is specified, size of all folders and subfolders are displayed 
	If the Recurse parameter is not spefified (default), size of base folders are displayed.
	
.EXAMPLE
	To return size for all folders in C:\EventLogs, run the command:
	PS C:\>Get-FolderSize -FolderPath C:\EventLogs
	The command returns the following output:
	Permorning initial tasks, please wait...
	Calculating size of folders in C:\EventLogs. This may take sometime, please wait...
	
	Folder Name                             Full Path                               Size
	-----------                             ---------                               ----
	70411SRV                                C:\EventLogs\70411SRV                   384 MB
	70411SRV1                               C:\EventLogs\70411SRV1                  128 MB
	70411SRV2                               C:\EventLogs\70411SRV2                  128 MB
	70411SRV3                               C:\EventLogs\70411SRV3                  128 MB
	Softwares                               C:\EventLogs\Softwares                  2.34 GB

.EXAMPLE
	To return size for folders in C:\EventLogs greater or equal to 200BM, run the command:
	PS C:\> Get-FolderSize C:\EventLogs -FoldersOver 0.2
	Result of the above command is shown below:
	Permorning initial tasks, please wait...
	Calculating size of folders in C:\EventLogs. This may take sometime, please wait...

	Folder Name                             Full Path                               Size
	-----------                             ---------                               ----
	70411SRV                                C:\EventLogs\70411SRV                   384 MB
	Softwares                               C:\EventLogs\Softwares                  2.34 GB
	Notice that only folders greater than 200 MB were returned 
	
.EXAMPLE
	To return size of all folders and subfolders, specify the Recurse parameter:
	PS C:\> Get-FolderSize C:\EventLogs -Recurse
	
	Permorning initial tasks, please wait...
	Calculating size of folders in C:\EventLogs. This may take sometime, please wait...

	Folder Name                             Full Path                               Size
	-----------                             ---------                               ----
	70411SRV                                C:\EventLogs\70411SRV                   384 MB
	70411SRV1                               C:\EventLogs\70411SRV1                  128 MB
	70411SRV2                               C:\EventLogs\70411SRV2                  128 MB
	70411SRV3                               C:\EventLogs\70411SRV3                  128 MB
	Softwares                               C:\EventLogs\Softwares                  2.34 GB
	Acrobat 7                               C:\EventLogs\Softwares\Acrobat 7        209 MB
	Citrix                                  C:\EventLogs\Softwares\Citrix           96 MB
	Dell OM station                         C:\EventLogs\Softwares\Dell OM station  577 MB
	JAWS                                    C:\EventLogs\Softwares\JAWS             227 MB
	MDT 2012 Update1                        C:\EventLogs\Softwares\MDT 2012 Update1 118 MB
	OpenManageEssentials                    C:\EventLogs\Softwares\OpenManageEss... 891 MB
	Adobe Acrobat 7.0 Professional          C:\EventLogs\Softwares\Acrobat 7\Ado... 200 MB
	windows                                 C:\EventLogs\Softwares\Dell OM stati... 271 MB
	ManagementStation                       C:\EventLogs\Softwares\Dell OM stati... 254 MB
	support                                 C:\EventLogs\Softwares\Dell OM stati... 107 MB
	
	Notice that, we now have size of all folders and subfolders
	
	
#>

[CmdletBinding(DefaultParameterSetName='FolderPath')]
param 
(
[Parameter(Mandatory=$true,Position=0,ParameterSetName='FolderPath')]
[String[]]$FolderPath,
[Parameter(Mandatory=$false,Position=1,ParameterSetName='FolderPath')]
[String]$FoldersOver,
[Parameter(Mandatory=$false,Position=2,ParameterSetName='FolderPath')]
[switch]$Recurse

)

Begin 
{
#$FoldersOver and $ZeroSizeFolders cannot be used together
#Convert the size specified by Greaterhan parameter to Bytes
$size = 1000000000 * $FoldersOver

}

Process {#Check whether user has access to the folders.
	
	
		Try {
		Write-Host "Permorning initial tasks, please wait... " -ForegroundColor Magenta
		$ColItems = If ($Recurse) {Get-ChildItem $FolderPath -Recurse -ErrorAction Stop } 
		Else {Get-ChildItem $FolderPath -ErrorAction Stop } 
		
		} 
		Catch [exception]{}
		
		#Calculate folder size
		If ($ColItems) 
		{
		Write-Host "Calculating size of folders in $FolderPath. This may take sometime, please wait... " -ForegroundColor Magenta
		$Items = $ColItems | Where-Object {$_.PSIsContainer -eq $TRUE -and `
		@(Get-ChildItem -LiteralPath $_.Fullname -Recurse -ErrorAction SilentlyContinue | Where-Object {!$_.PSIsContainer}).Length -gt '0'}}
		

		ForEach ($i in $Items)
		{

		$subFolders = 
		If ($FoldersOver)
		{Get-ChildItem -Path $i.FullName -Recurse | Measure-Object -sum Length | Where-Object {$_.Sum -ge $size -and $_.Sum -gt 100000000  } }
		Else
		{Get-ChildItem -Path $i.FullName -Recurse | Measure-Object -sum Length | Where-Object {$_.Sum -gt 100000000  }} #added 25/12/2014: returns folders over 100MB
		#Return only values not equal to 0
		ForEach ($subFolder in $subFolders) {
		#If folder is less than or equal to 1GB, display in MB, If above 1GB, display in GB 
		$si = If (($subFolder.Sum -ge 1000000000)  ) {"{0:N2}" -f ($subFolder.Sum / 1GB) + " GB"} 
 	  	ElseIf (($subFolder.Sum -lt 1000000000)  ) {"{0:N0}" -f ($subFolder.Sum / 1MB) + " MB"} 
		$Object = New-Object PSObject -Property @{            
        'Folder Name'    = $i.Name                
        'Size'    =  $si
        'Full Path'    = $i.FullName          
        } 

		$Object | Select-Object 'Folder Name', 'Full Path',Size



} 

}


}
End {

Write-Host "Task completed...if nothing is displayed:
you may not have access to the path specified or 
all folders are less than 100 MB" -ForegroundColor Cyan


}

}
