-- Check Service Broker State on Instance

SELECT far_service AS 'Far Service'
	, state_desc AS 'State Desc'
	, count(*) AS 'Messages'
FROM sys.conversation_endpoints
GROUP BY state_desc
	, far_service
ORDER BY far_service
	, state_desc