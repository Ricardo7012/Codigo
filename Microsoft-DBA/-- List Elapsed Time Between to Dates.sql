-- List Elapsed Time Between to Dates

DECLARE @startTime DATETIME
DECLARE @endTime DATETIME

SET @startTime = '05-18-2014 09:21 PM'
SET @endTime = '06-05-2014 01:18 PM'

SELECT [DD:HH:MM:SS] =
    CAST((DATEDIFF(HOUR , @startTime, @endTime) / 24) AS VARCHAR)  + ':' +
    CAST((DATEDIFF(HOUR , @startTime, @endTime) % 24) AS VARCHAR)  + ':' +
    CAST((DATEDIFF(MINUTE, @startTime, @endTime) % 60) AS VARCHAR) + ':' +
    CAST((DATEDIFF(SECOND, @startTime, @endTime) % 60) AS VARCHAR),

    [StringFormat] =
    CAST((DATEDIFF(HOUR , @startTime, @endTime) / 24) AS VARCHAR) +
    ' Days ' +
    CAST((DATEDIFF(HOUR , @startTime, @endTime) % 24) AS VARCHAR) +
    ' Hours ' +
    CAST((DATEDIFF(MINUTE, @startTime, @endTime) % 60) AS VARCHAR) +
    ' Minutes ' +
    CAST((DATEDIFF(SECOND, @startTime, @endTime) % 60) AS VARCHAR) +
    ' Seconds '