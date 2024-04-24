--POST Installation Check
-- Check the error log and event log for few days after the new  installation


EXEC xp_ReadErrorLog 0, 1, N'Error'