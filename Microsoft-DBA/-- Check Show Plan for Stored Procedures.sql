-- Check Show Plan for Stored Procedures

SET SHOWPLAN_ALL ON
GO

EXEC Proc_ReconstructPlayer 101
	, 1
	, 1
	, 1
GO

SET SHOWPLAN_ALL OFF
GO