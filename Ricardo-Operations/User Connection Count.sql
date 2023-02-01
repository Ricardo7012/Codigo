-- https://www.mssqltips.com/sqlservertip/3171/identify-sql-server-databases-that-are-no-longer-in-use/ 

USE DBA_Admin_SQL1		-- CONNECT IEHPSQLA1\SQL1
GO
--USE DBA_Admin_SQL2	-- CONNECT IEHPSQLB1\SQL2
--GO
--USE DBA_Admin_SQL3	-- CONNECT IEHPSQLC2\SQL3
--GO
--USE DBA_Admin_SQL4	-- CONNECT IEHPSQLD2\SQL4
--GO

SELECT NAME
 ,MAX(number_of_connections) AS MAX#
FROM ConnectionsCount
GROUP BY NAME
ORDER BY NAME
GO
SELECT GETDATE()
GO
