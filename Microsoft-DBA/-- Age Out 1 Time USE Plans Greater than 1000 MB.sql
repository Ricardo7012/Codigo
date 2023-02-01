-- Age Out 1 Time USE Plans Greater than 1000 MB

DECLARE @MB DECIMAL(19, 3)
DECLARE @Count BIGINT
DECLARE @StrMB NVARCHAR(20)

SELECT @MB = sum(cast((
				CASE 
					WHEN usecounts = 1
						THEN size_in_bytes
					ELSE 0
					END
				) AS DECIMAL(12, 2))) / 1024 / 1024
	, @Count = sum(CASE 
			WHEN usecounts = 1
				THEN 1
			ELSE 0
			END)
	, @StrMB = convert(NVARCHAR(20), @MB)
FROM sys.dm_exec_cached_plans

IF @MB > 1000
	DBCC FREEPROCCACHE
ELSE
	RAISERROR (
			'Only % s MB is allocated to single - USE PLAN cache – no need to clear cache now.'
			, 10
			, 1
			, @StrMB
			)
GO


