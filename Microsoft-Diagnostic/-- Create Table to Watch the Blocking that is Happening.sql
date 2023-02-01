-- Create table to watch the blocking that is happening

CREATE TABLE Blocking (
	BlockingID BIGINT Identity(1, 1) NOT NULL
	, resource_type NVARCHAR(60)
	, database_name SYSNAME
	, assoc_entity_id BIGINT
	, lock_req NVARCHAR(60)
	, wait_spid INT
	, wait_duration_ms INT
	, wait_type NVARCHAR(60)
	, wait_batch NVARCHAR(max)
	, wait_stmt NVARCHAR(max)
	, wait_host SYSNAME
	, wait_user SYSNAME
	, block_spid INT
	, block_stmt NVARCHAR(max)
	, block_host SYSNAME
	, block_user SYSNAME
	, DateAdded DATETIME NOT NULL DEFAULT(GetDate())
	)
GO

CREATE UNIQUE CLUSTERED INDEX IX_Blocking_DateAdded_BlockingID_U_C ON Blocking (
	DateAdded
	, BlockingID
	)
	WITH (FILLFACTOR = 95)
GO


