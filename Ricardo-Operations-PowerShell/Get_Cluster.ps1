Import-Module FailoverClusters   
Get-ClusterLog -Destination . 
hostname 

  
$cluster = "PVWFCDBM01"  
$nodes = Get-ClusterNode -Cluster $cluster  
  
$nodes | Format-Table -property NodeName, State, NodeWeight  

Get-ClusterNode -Name pvdbmdata01 | Get-ClusterResource
Get-ClusterNode -Name pvdbmdata02 | Get-ClusterResource

Get-ClusterResource
# https://docs.microsoft.com/en-us/powershell/module/failoverclusters/get-clusterresource?view=win10-ps
Get-ClusterResource  | Format-List -Property *


# https://docs.microsoft.com/en-us/windows-server/storage/storage-spaces/understand-quorum
Get-ClusterQuorum

Get-Cluster

Get-Cluster | fl 

get-cluster | Get-Clustergroup

get-cluster | Get-ClusterNetwork

get-cluster | Get-ClusterNetworkInterface

Write-Output "##### Get Cluster Tests #####"
Get-Cluster
Write-Output "##### Get Cluster Parameter Tests #####"
Get-Cluster | Get-ClusterParameter
Write-Output "##### Get Cluster Group Tests #####"
get-cluster | Get-Clustergroup
Write-Output "##### Get Cluster Group Parameter Tests #####"
get-cluster | Get-Clustergroup | Get-ClusterParameter
Write-Output "##### Get Cluster Network Tests #####"
get-cluster | Get-ClusterNetwork
Write-Output "##### Get Cluster Network Parameter Tests #####"
get-cluster | Get-ClusterNetwork | Get-ClusterParameter
Write-Output "##### Get Cluster Network interface Tests #####"
get-cluster | Get-ClusterNetworkInterface
Write-Output "##### Get Cluster Network interface Parameter Tests #####"
get-cluster | Get-ClusterNetworkInterface | Get-ClusterParameter
Write-Output "##### Get Cluster Node Tests #####"
get-cluster | Get-ClusterNode
Write-Output "##### Get Cluster Node Parameter Tests #####"
get-cluster | Get-ClusterNode | Get-ClusterParameter
Write-Output "##### Get Cluster resource Tests #####"
get-cluster | Get-ClusterResource
Write-Output "##### Get Cluster resource Parameter Tests #####"
get-cluster | Get-ClusterResource | Get-ClusterParameter | ft * -groupby object
Write-Output "##### Get Cluster resource Type Tests #####"
get-cluster | Get-ClusterResourceType
Write-Output "##### Get Cluster resource type Parameter Tests #####"
get-cluster | Get-ClusterResourceType | Get-ClusterParameter -ErrorAction ignore | ft * -groupby object
Write-Output "##### Get Cluster Shared Volume Tests #####"
get-cluster | Get-ClusterSharedVolume
Write-Output "##### Get Cluster Shared Volume Parameter Tests #####"
get-cluster | Get-ClusterSharedVolume | Get-ClusterParameter