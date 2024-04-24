
--IS IT ENABLED?
USE master 
GO
select @@ServerName AS servername, [name], is_broker_enabled FROM sys.databases
GO
SELECT is_broker_enabled FROM sys.databases WHERE name = ';
GO

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--CLEAR SERVICE BROKER
USE HSP_IT_SB2
GO
SELECT count(*)
FROM [dbo].[MembershipJobRequestQueue] WITH(NOLOCK)

declare @c uniqueidentifier
while(1=1)
begin
    select top 1 @c = conversation_handle from [dbo].[MembershipJobRequestQueue]
    if (@@ROWCOUNT = 0)
    break
    end conversation @c with cleanup
end


SELECT count(*) as [MembershipJobResponseQueue] from [dbo].[MembershipJobResponseQueue] 
SELECT count(*) as [HistoryClaimRequestQueue] from [dbo].[HistoryClaimRequestQueue]   
SELECT count(*) as [HistoryClaimResponseQueue] from [dbo].[HistoryClaimResponseQueue]  
SELECT count(*) as [MembershipJobRequestQueue] from [dbo].[MembershipJobRequestQueue]  
SELECT count(*) as [MembershipJobResponseQueue] from [dbo].[MembershipJobResponseQueue] 

-- https://davewentzel.com/content/monitoring-service-broker/
-- http://www.sqlservercentral.com/blogs/marlon-ribunal-sql-code-coffee-etc/2018/02/20/killing-a-service-broker-spid/
select distinct
       qs.name
     , qm.tasks_waiting
from sys.dm_broker_queue_monitors qm
    join sys.service_queues       qs
        on qm.queue_id = qs.object_id;
USE HSP_IT_SB2
go
SELECT DISTINCT Conversation_Handle [MembershipJobResponseQueue] from [dbo].[MembershipJobResponseQueue] 
SELECT DISTINCT Conversation_Handle [HistoryClaimRequestQueue] from [dbo].[HistoryClaimRequestQueue]   
SELECT DISTINCT Conversation_Handle [HistoryClaimResponseQueue] from [dbo].[HistoryClaimResponseQueue]  
SELECT DISTINCT Conversation_Handle [MembershipJobRequestQueue] from [dbo].[MembershipJobRequestQueue]  
SELECT DISTINCT Conversation_Handle [MembershipJobResponseQueue] from [dbo].[MembershipJobResponseQueue] 

select cast(Message_Body as xml)
from dbo.[MembershipJobRequestQueue] with (nolock);

--CONFIRM USER ID STEP 
--HSP1S1B.HSP_Supplemental 
--SELECT * FROM syn.Users WHERE userid = 2533

END CONVERSATION 'AA679F69-364B-E911-80EE-005056B85262' WITH cleanup

SELECT SPID FROM sys.dm_broker_activated_tasks

--KILL All SPIDs FROM SELECT ABOVE BY INDIVIDUAL SPID

--PVSQLEDI01 
--SELECT * FROM EdiManagementHub.ems.GlobalConfig
--Field: HspTaskAgentMemberParallelization 



