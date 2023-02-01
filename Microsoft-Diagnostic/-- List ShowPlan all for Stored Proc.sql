-- List ShowPlan all for Stored Proc

DBCC TRACEON (310)
GO

DBCC TRACEON (330)
GO

SET SHOWPLAN_ALL ON
GO

-- Change Stored Procedure Name & Variables
EXEC Proc_ReconstructPlayer 101, 1, 1, 1
GO

SET SHOWPLAN_ALL OFF
GO