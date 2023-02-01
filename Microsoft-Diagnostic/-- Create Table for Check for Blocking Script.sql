-- Create Table for Check for Blocking Script

CREATE TABLE Blocking (
    BlockingID BigInt Identity(1,1) NOT NULL
    , resource_type NVarChar(60)
    , database_name SysName
    , assoc_entity_id BigInt
    , lock_req NVarChar(60)
    , wait_spid Int
    , wait_duration_ms Int
    , wait_type NVarChar(60)
    , wait_batch NVarChar(max)
    , wait_stmt NVarChar(max)
    , wait_host SysName
    , wait_user SysName
    , block_spid Int
    , block_stmt NVarChar(max)
    , block_host SysName
    , block_user SysName
    , DateAdded datetime NOT NULL DEFAULT (GetDate())
)
GO

CREATE UNIQUE CLUSTERED INDEX IX_Blocking_DateAdded_BlockingID_U_C ON Blocking
(
    DateAdded
    , BlockingID
) WITH (Fillfactor = 95)
GO