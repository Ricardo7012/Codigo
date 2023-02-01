-- List Blocking on SQL

SELECT DES.Session_ID AS [Root Blocking Session ID]
	, DER.STATUS AS [Blocking Session Request Status]
	, DES.Login_Time AS [Blocking Session Login Time]
	, DES.Login_Name AS [Blocking Session Login Name]
	, DES.Host_Name AS [Blocking Session Host Name]
	, Coalesce(DER.Start_Time, DES.Last_Request_Start_Time) AS [Request Start Time]
	, CASE 
		WHEN DES.Last_Request_End_Time >= DES.Last_Request_Start_Time
			THEN DES.Last_Request_End_Time
		ELSE NULL
		END AS [Request End Time]
	, Substring(TEXT, DER.Statement_Start_Offset / 2, CASE 
			WHEN DER.Statement_End_Offset = - 1
				THEN DataLength(TEXT)
			ELSE DER.Statement_End_Offset / 2
			END) AS [Executing Command]
	, CASE 
		WHEN DER.Session_ID IS NULL
			THEN 'Blocking session does not have an open request and may be due to an uncommitted transaction.'
		WHEN DER.Wait_Type IS NOT NULL
			THEN 'Blocking session is currently experiencing a ' + DER.Wait_Type + ' wait.'
		WHEN DER.STATUS = 'Runnable'
			THEN 'Blocking session is currently waiting for CPU time.'
		WHEN DER.STATUS = 'Suspended'
			THEN 'Blocking session has been suspended by the scheduler.'
		ELSE 'Blocking session is currently in a ' + DER.STATUS + ' status.'
		END AS [Blocking Notes]
FROM Sys.DM_Exec_Sessions DES(READUNCOMMITTED)
LEFT JOIN Sys.DM_Exec_Requests DER(READUNCOMMITTED)
	ON DER.Session_ID = DES.Session_ID
OUTER APPLY Sys.DM_Exec_Sql_Text(DER.Sql_Handle)
WHERE DES.Session_ID IN (
		SELECT Blocking_Session_ID
		FROM Sys.DM_Exec_Requests(READUNCOMMITTED)
		WHERE Blocking_Session_ID <> 0
			AND Blocking_Session_ID NOT IN (
				SELECT session_id
				FROM Sys.DM_Exec_Requests(READUNCOMMITTED)
				WHERE Blocking_Session_ID <> 0
				)
		)
