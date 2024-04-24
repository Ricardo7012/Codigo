-- SQL Server 2012 SSISDB Catalog query
-- https://msdn.microsoft.com/en-us/library/hh479588(v=sql.110).aspx
-- Phil Streiff, MCDBA, MCITP, MCSA
-- 09/08/2016

USE [SSISDB];
GO
SELECT 
	pj.folder_id,
	pk.project_id, 
	pj.name 'folder', 
	pk.name, 
	pk.version_build--,
	--pj.deployed_by_name 'deployed_by' 
FROM
	catalog.packages pk JOIN catalog.projects pj 
	ON (pk.project_id = pj.project_id)
ORDER BY
	pj.folder_id,
	folder,
	pk.name

--FOLDER_ID
-- 1 = DEV
-- 2 MODELOFFICE

--USE [SSISDB];
--GO
--SELECT 
--	PK.*
--	,PJ.*
--FROM
--	catalog.packages pk JOIN catalog.projects pj 
--	ON (pk.project_id = pj.project_id)


