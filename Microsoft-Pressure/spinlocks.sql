SET NOCOUNT ON
CREATE TABLE #spins([Spinlock Name] varchar(50),Collisions numeric,Spins numeric,[Spins/Collision] float,[Sleep Time (ms)] numeric,Backoffs numeric)
INSERT INTO #spins EXECUTE ('DBCC SQLPERF (''SPINLOCKSTATS'')')
SELECT TOP 20 * FROM #spins ORDER BY Collisions DESC
DROP TABLE #spins
GO
DBCC SQLPERF(SPINLOCKSTATS) 
GO