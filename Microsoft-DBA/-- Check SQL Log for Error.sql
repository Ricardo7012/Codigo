-- Check SQL Log for Error

DECLARE @ErrorLog INT
DECLARE @LogType INT
DECLARE @SearchString0 VARCHAR(255) = NULL
DECLARE @SearchString1 VARCHAR(255) = NULL

-- 1. Value of error log file you want to read: (@ErrorLog) 0 = current, 1 = Archive #1, 2 = Archive #2, etc...
-- 2. Log file type: (@LogType) 1 or NULL = error log, 2 = SQL Agent log
-- 3. Search string 1: ('@SearchString0') String one you want to search for
-- 4. Search string 2: ('@SearchString1') String two you want to search for to further refine the results

SET @ErrorLog = 0
SET @LogType = 1
SET @SearchString0 = 'All rights'
SET @SearchString1 = ''



IF (@LogType IS NULL)
	BEGIN
		EXEC sys.xp_readerrorlog @ErrorLog
	END
ELSE
	BEGIN
		EXEC sys.xp_readerrorlog @ErrorLog
			, @LogType
			, @SearchString0
			, @SearchString1
	END
