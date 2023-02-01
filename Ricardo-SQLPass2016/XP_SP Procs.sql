
--Delete any information 6 months and later with this query:
DELETE FROM dbo.Refrdel WHERE Delete_date <=dateadd(day, -365, getdate())
GO
