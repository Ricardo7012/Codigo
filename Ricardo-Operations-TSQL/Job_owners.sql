--JOBS
SELECT 
s.job_id,
s.name AS JOBNAME,
       l.name AS OWNERNAME, 
	   s.description
FROM msdb..sysjobs s
    LEFT JOIN master.sys.syslogins l
        ON s.owner_sid = l.sid
ORDER BY [s].[name] desc

--PACKAGES
--SELECT s.name,
--       l.name
--FROM msdb..sysssispackages s
--    LEFT JOIN master.sys.syslogins l
--        ON s.ownersid = l.sid;

--SELECT * FROM msdb..sysjobs s

--dv-- DECB0EBF-897B-4D70-B8A6-A712C409F3C2 -- MEDHOK_Claims
--pv-- 3ADA310D-A305-4B9E-9F0B-D75114FB48CE -- MedHOK Integration - MediTrac Claims