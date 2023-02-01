-- SSIS DELETE CANDIDATES
DECLARE @continue INT
DECLARE @rowcount INT
 
SET @continue = 1
WHILE @continue = 1

	BEGIN TRY
	PRINT GETDATE()
	SET ROWCOUNT 10000

		BEGIN TRANSACTION 

			USE SSISDB;
			SET NOCOUNT ON;
			IF object_id('tempdb..#DELETE_CANDIDATES') IS NOT NULL
			BEGIN
				DROP TABLE #DELETE_CANDIDATES;
			END;

			CREATE TABLE #DELETE_CANDIDATES
			(
				operation_id bigint NOT NULL PRIMARY KEY
			);

			DECLARE @DaysRetention int = 14;
			INSERT INTO
				#DELETE_CANDIDATES
			(
				operation_id
			)
			SELECT
				IO.operation_id
			FROM
				internal.operations AS IO
			WHERE
				IO.start_time < DATEADD(day, -@DaysRetention, CURRENT_TIMESTAMP);

			--SELECT * FROM   #DELETE_CANDIDATES

			DELETE T
			FROM
				internal.event_message_context AS T
				INNER JOIN
					#DELETE_CANDIDATES AS DC
					ON DC.operation_id = T.operation_id;

			DELETE T
			FROM
				internal.event_messages AS T
				INNER JOIN
					#DELETE_CANDIDATES AS DC
					ON DC.operation_id = T.operation_id;

			DELETE T
			FROM
				internal.operation_messages AS T
				INNER JOIN
					#DELETE_CANDIDATES AS DC
					ON DC.operation_id = T.operation_id;

			-- etc
			-- Finally, remove the entry from operations
			DELETE T
			FROM
				internal.operations AS T
				INNER JOIN
					#DELETE_CANDIDATES AS DC
					ON DC.operation_id = T.operation_id;
		SET @rowcount = @@rowcount 
		COMMIT
		PRINT GETDATE()
    IF @rowcount = 0
    BEGIN
        SET @continue = 0
    END
	END TRY 

BEGIN CATCH 
IF @@TRANCOUNT > 0 
ROLLBACK
END CATCH
