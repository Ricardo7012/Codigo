SELECT  *
FROM    master..sysmessages
--where error in (18053,17066)
--and msglangid=1033	-- English (substitute yours or comment this whole line)
WHERE   msglangid = 1033	-- English (substitute yours or comment this whole line)
ORDER BY error;

