-- Calculate Local Time from UTC Date Time

DECLARE @utcDateTime DATETIME
DECLARE @utcNow DATETIME
DECLARE @localNow DATETIME
DECLARE @timeOffSet INT

SET @utcDateTime = ''

-- Figure out the time difference between UTC and Local time
SET @utcNow = GetUtcDate()
SET @localNow = GetDate()
SET @timeOffSet = DateDiff(hh, @utcNow, @localNow)

DECLARE @localTime DATETIME

SET @localTime = DateAdd(hh, @timeOffset, @utcDateTime)

-- Check Results
PRINT @localTime
