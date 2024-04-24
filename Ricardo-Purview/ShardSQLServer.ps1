###########################################################################################
# Register database schema in shard map #
# https://blog.pythian.com/sharding-sql-server-database/ 
###########################################################################################
$ShardMapManager = new-ShardMapManager -UserName '' -Password '' -SqlServerName '.' -SqlDatabaseName ''

# $ShardMapManager is the shard map manager object
new-ListShardMap -KeyType $([guid]) -ShardMapManager $ShardMapManager -ListShardMapName 'ListShardMap'

$SchemaInfo = New-Object Microsoft.Azure.SqlDatabase.ElasticScale.ShardManagement.Schema.SchemaInfo

# Reference Table
$ReferenceTableName = "Product"
$SchemaInfo.Add($(New-Object Microsoft.Azure.SqlDatabase.ElasticScale.ShardManagement.Schema.ReferenceTableInfo($ReferenceTableName)))

# Sharded Table
$ShardedTableSchemaName = "dbo" 
$ShardedTableName = "ProductSold" 
$ShardedTableKeyColumnName = "StoreID" 
$SchemaInfo.Add($(New-Object Microsoft.Azure.SqlDatabase.ElasticScale.ShardManagement.Schema.ShardedTableInfo($ShardedTableSchemaName, $ShardedTableName, $ShardedTableKeyColumnName)))

$SchemaInfoCollection = $ShardMapManager.GetSchemaInfoCollection()

# Add the SchemaInfo for this Shard Map to the Schema Info Collection
$SchemaInfoCollection.Add('StoreListShardMap', $SchemaInfo)

###########################################################################################
# Create new databases and assign shards #
###########################################################################################
$ShardMapManager = Get-ShardMapManager -UserName 'example' -Password '****!' -SqlServerName 'example.database.windows.net' -SqlDatabaseName 'ShardAdmin'

# Get Shard Map. 
$ShardMap = Get-ListShardMap -KeyType $([guid]) -ShardMapManager $ShardMapManager -ListShardMapName $ShardMapName

# Add new DB to shard map
Add-Shard -ShardMap $ShardMap -SqlServerName $FullSQLServerName -SqlDatabaseName $ShardName | wait-process

# Add shard to shard map -- Mapped to $SourceDB because that's where it is currently
Add-ListMapping -keyType $([guid]) -ListShardMap $ShardMap -ListPoint $Guid -SqlServerName $FullSQLServerName -SQLDatabaseName $SourceDB | wait-process

###########################################################################################
# Assign the new shard to a Cloud Service for the Split-Merge process
###########################################################################################
$mod = $NumOfShards % $NumOfMergeSplitApps

if ($mod -eq 1) {
  $SplitMergeURL = "https://example-mergesplit.cloudapp.net"
  $LogOutput = (Get-Date).ToShortDateString() + " " + (Get-Date).ToShortTimeString() + " : " + $ShardName + " sent to " + $SplitMergeURL 
  Add-Content -Path $LogFile -value $LogOutput
}
elseif ($mod -eq 2) {
  $SplitMergeURL = "https://example-mergesplit2.cloudapp.net"
  $LogOutput = (Get-Date).ToShortDateString() + " " + (Get-Date).ToShortTimeString() + " : " + $ShardName + " sent to " + $SplitMergeURL 
  Add-Content -Path $LogFile -value $LogOutput
}
else{
  $SplitMergeURL = "https://example-mergesplit10.cloudapp.net"
  $LogOutput = (Get-Date).ToShortDateString() + " " + (Get-Date).ToShortTimeString() + " : " + $ShardName + " sent to " + $SplitMergeURL 
  Add-Content -Path $LogFile -value $LogOutput
}

# Queue up the split database operation
$OperationID = Submit-ShardletMoveRequest `
  -SplitMergeServiceEndpoint $SplitMergeURL `
  -ShardMapManagerServerName $ShardMapServerName `
  -ShardMapManagerDatabaseName $ShardMapDB `
  -ShardMapName $ShardMapName `
  -ShardKeyType 'guid' `
  -ShardletValue $Guid `
  -TargetServerName $FullSQLServerName `
  -TargetDatabaseName $ShardName `
  -UserName $AdminLogin `
  -Password $AdminPasswd `
  -CertificateThumbprint '####' #Unique to your project. See MS Tutorial

$LogOutput = (Get-Date).ToShortDateString() + " " + (Get-Date).ToShortTimeString() + " : " + "Operation ID: " + $OperationID
Add-Content -Path $LogFile -value $LogOutput

###########################################################################################
# Monitor split-merge processes
###########################################################################################
SELECT 
  [TimeStamp] LastUpdateTime, 
  [Status], 
  Progress [EstPercentDone], 
  OperationID, 
  CancelRequest [Cancelled], 
  Details 
FROM 
  RequestStatus 
WHERE
  OperationID IN (select operationid from requeststatus where [status] not in ('Queued', 'Canceled', 'Failed', 'Succeeded')) 
ORDER BY 
  LastUpdateTime desc;

SELECT
  *
FROM
  RequestStatus 
WHERE
  status IN ('Failed', 'Succeeded') 
ORDER BY 
  [timestamp] desc;

SELECT
  *
FROM
  RequestStatus 
WHERE
  status = 'queued' 
ORDER BY 
  [timestamp] desc;

###########################################################################################
# Change application code to use shard map
# Enable foreign key constraints
# The Split-Merge process does not perform INSERT or DELETE operations in any particular order, 
# and does not respect Foreign Key constraints. Because of this, all constraints must be disabled 
# prior to running the Split-Merge process.
###########################################################################################
