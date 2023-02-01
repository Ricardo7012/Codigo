Declare @Date1 DATETIME = '2021-08-19 12:43:03'
DECLARE @Date2 DATETIME = '2021-08-19 21:43:40'
Select CONVERT(TIME,@Date2 - @Date1) as ElapsedTime
GO

--Started: 
--Thursday, August 19, 2021 12:42:03 PM
--Completed: 
--Thursday, August 19, 2021 9:43:40 PM
