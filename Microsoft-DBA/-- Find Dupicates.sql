-- Find Dupicates

SELECT PlayerID
	, COUNT(*)
FROM Player
GROUP BY PlayerID
HAVING COUNT(*) > 1;
