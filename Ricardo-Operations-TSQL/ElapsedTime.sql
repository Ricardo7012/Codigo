DECLARE @StartDate DATETIME, @EndDate DATETIME
SET @StartDate = '2016-09-26 08:00:00'
SET @EndDate = GETDATE()

SELECT
    CAST(DATEDIFF(DAY, @StartDate, @EndDate) AS FLOAT) / 365.25 AS 'Years',
    DATEDIFF(MONTH, @StartDate, @EndDate) % 12 AS 'Months',
    DATEDIFF(DAY, DATEADD(MONTH, DATEDIFF(MONTH, @StartDate, @EndDate), @StartDate), @EndDate) AS 'Days',
    DATEDIFF(HOUR, DATEADD(DAY, DATEDIFF(DAY, @StartDate, @EndDate), @StartDate), @EndDate) AS 'Hours',
    DATEDIFF(MINUTE, DATEADD(HOUR, DATEDIFF(HOUR, @StartDate, @EndDate), @StartDate), @EndDate) AS 'Minutes',
    DATEDIFF(SECOND, DATEADD(MINUTE, DATEDIFF(MINUTE, @StartDate, @EndDate), @StartDate), @EndDate) AS 'Seconds'

SELECT CAST(DATEDIFF(DAY, @StartDate, @EndDate) AS FLOAT) / 365.25 AS TotalYears
SELECT DateDiff(MONTH, @StartDate, @EndDate) as TotalMonths
SELECT DateDiff(day, @StartDate, @EndDate) as TotalDays
SELECT DateDiff(hour, @StartDate, @EndDate) as TotalHours 
SELECT DateDiff(MINUTE, @StartDate, @EndDate) as TotalMinutes 
SELECT DateDiff(SECOND, @StartDate, @EndDate) as TotalSeconds 
SELECT DateDiff_big(MILLISECOND, @StartDate, @EndDate) as TotalMiliSeconds 
