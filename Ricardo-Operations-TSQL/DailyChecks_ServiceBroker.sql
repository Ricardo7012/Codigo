--Service Broker General Queue Information
--This query gives you all information about each queue in the database. Use this query to find out if a queue is enabled, if activation is enabled on the queue, etc.

SELECT *
FROM sys.service_queues;

--Viewing Messages on a Queue
--If you need to view the body of messages on a service broker queue, you can use this query to return the XML content of each message on the queue.
USE BPMAINDB;
SELECT CAST(Message_Body AS XML)
FROM dbo.QueryNotificationErrorsQueue WITH (NOLOCK);
SELECT CAST(Message_Body AS XML)
FROM dbo.EventNotificationErrorsQueue WITH (NOLOCK);
SELECT CAST(Message_Body AS XML)
FROM dbo.ServiceBrokerQueue WITH (NOLOCK);
SELECT CAST(Message_Body AS XML)
FROM dbo.MembershipJobRequestQueue WITH (NOLOCK);
SELECT CAST(Message_Body AS XML)
FROM dbo.MembershipJobResponseQueue WITH (NOLOCK);
SELECT CAST(Message_Body AS XML)
FROM dbo.HistoryClaimRequestQueue WITH (NOLOCK);
SELECT CAST(Message_Body AS XML)
FROM dbo.HistoryClaimResponseQueue WITH (NOLOCK);


--COUNT Messages ON a QUEUE
--You can use “Select count * from dbo.QueueName”, however that is slow, especially if there are thousands of messages presently on the queue. It is much faster to use the message count that service broker stores on each queue.
SELECT p.rows
FROM sys.objects        AS o
    JOIN sys.partitions AS p
        ON p.object_id = o.object_id
    JOIN sys.objects    AS q
        ON o.parent_object_id = q.object_id
WHERE q.name = 'QueryNotificationErrorsQueue'
      AND p.index_id = 1;

--Get the SPID of a Running Activation Sproc
--When an acitvation sproc is running on prod and causing problems, it can be difficult to figure out which SPID is associated with that sproc when we need to kill that process. The following query makes that easy to find:
SELECT *
FROM sys.dm_broker_activated_tasks;
--Find out of a conversation has been ended
