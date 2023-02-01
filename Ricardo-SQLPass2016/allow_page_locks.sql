--SELECT sys.tables.name, sys.indexes.name FROM sys.indexes inner join sys.tables  ON sys.tables.object_id = sys.indexes.object_id WHERE ALLOW_PAGE_LOCKS = 0

SELECT 'ALTER INDEX ' + sys.indexes.name + ' ON ' + sys.tables.name + ' SET (allow_page_locks = ON ) ' FROM sys.indexes inner join sys.tables  ON sys.tables.object_id = sys.indexes.object_id WHERE ALLOW_PAGE_LOCKS = 0

ALTER INDEX IX_EPODataChannelData_CreatedOn ON EPODataChannelData SET (allow_page_locks = ON ) 
ALTER INDEX PK_EPOAgentHandlerDataChannelWQ ON EPOAgentHandlerDataChannelWQ SET (allow_page_locks = ON ) 
--ALTER INDEX IX_EPOAgentHandlerDataChannelWQ_BatchUid ON EPOAgentHandlerDataChannelWQ SET (allow_page_locks = ON ) 
ALTER INDEX IX_EPOAgentHandlerDataChannelWQ_Target ON EPOAgentHandlerDataChannelWQ SET (allow_page_locks = ON ) 
ALTER INDEX IX_EPOAgentHandlerDataChannelWQ_DataID ON EPOAgentHandlerDataChannelWQ SET (allow_page_locks = ON ) 
ALTER INDEX IX_EPOAgentHandlerDataChannelWQ_GetWork ON EPOAgentHandlerDataChannelWQ SET (allow_page_locks = ON ) 
ALTER INDEX IX_EPOAgentHandlerDataChannelWQ_GetWorkAlt ON EPOAgentHandlerDataChannelWQ SET (allow_page_locks = ON ) 
ALTER INDEX IX_EPOAgentHandlerDataChannelWQ_GetCleanupList ON EPOAgentHandlerDataChannelWQ SET (allow_page_locks = ON ) 
ALTER INDEX IX_EPOAgentHandlerDataChannelWQ_GetCleanupListAlt ON EPOAgentHandlerDataChannelWQ SET (allow_page_locks = ON ) 
ALTER INDEX PK_EPOAgentHandlerDataChannelWQAttempts ON EPOAgentHandlerDataChannelWQAttempts SET (allow_page_locks = ON ) 
ALTER INDEX IX_EPOAgentHandlerDataChannelWQAttempts_ParentID ON EPOAgentHandlerDataChannelWQAttempts SET (allow_page_locks = ON ) 
ALTER INDEX UIX_EPOAgentHandlerDataChannelWQAttempts ON EPOAgentHandlerDataChannelWQAttempts SET (allow_page_locks = ON ) 
ALTER INDEX IX_EPOAgentHandlerDataChannelWQAttempts_GetCleanupList ON EPOAgentHandlerDataChannelWQAttempts SET (allow_page_locks = ON ) 
ALTER INDEX IX_EPOAgentHandlerDataChannelWQAttempts_ReleaseWork ON EPOAgentHandlerDataChannelWQAttempts SET (allow_page_locks = ON ) 

SELECT 'ALTER INDEX ' + sys.indexes.name + ' ON ' + sys.tables.name + ' SET (allow_page_locks = OFF ) ' FROM sys.indexes inner join sys.tables  ON sys.tables.object_id = sys.indexes.object_id WHERE ALLOW_PAGE_LOCKS = 1

ALTER INDEX IX_EPODataChannelData_CreatedOn ON EPODataChannelData SET (allow_page_locks = OFF ) 
ALTER INDEX PK_EPOAgentHandlerDataChannelWQ ON EPOAgentHandlerDataChannelWQ SET (allow_page_locks = OFF ) 
ALTER INDEX IX_EPOAgentHandlerDataChannelWQ_BatchUid ON EPOAgentHandlerDataChannelWQ SET (allow_page_locks = OFF ) 
ALTER INDEX IX_EPOAgentHandlerDataChannelWQ_Target ON EPOAgentHandlerDataChannelWQ SET (allow_page_locks = OFF ) 
ALTER INDEX IX_EPOAgentHandlerDataChannelWQ_DataID ON EPOAgentHandlerDataChannelWQ SET (allow_page_locks = OFF ) 
ALTER INDEX IX_EPOAgentHandlerDataChannelWQ_GetWork ON EPOAgentHandlerDataChannelWQ SET (allow_page_locks = OFF ) 
ALTER INDEX IX_EPOAgentHandlerDataChannelWQ_GetWorkAlt ON EPOAgentHandlerDataChannelWQ SET (allow_page_locks = OFF ) 
ALTER INDEX IX_EPOAgentHandlerDataChannelWQ_GetCleanupList ON EPOAgentHandlerDataChannelWQ SET (allow_page_locks = OFF ) 
ALTER INDEX IX_EPOAgentHandlerDataChannelWQ_GetCleanupListAlt ON EPOAgentHandlerDataChannelWQ SET (allow_page_locks = OFF ) 
ALTER INDEX PK_EPOAgentHandlerDataChannelWQAttempts ON EPOAgentHandlerDataChannelWQAttempts SET (allow_page_locks = OFF ) 
ALTER INDEX IX_EPOAgentHandlerDataChannelWQAttempts_ParentID ON EPOAgentHandlerDataChannelWQAttempts SET (allow_page_locks = OFF ) 
ALTER INDEX UIX_EPOAgentHandlerDataChannelWQAttempts ON EPOAgentHandlerDataChannelWQAttempts SET (allow_page_locks = OFF ) 
ALTER INDEX IX_EPOAgentHandlerDataChannelWQAttempts_GetCleanupList ON EPOAgentHandlerDataChannelWQAttempts SET (allow_page_locks = OFF ) 
ALTER INDEX IX_EPOAgentHandlerDataChannelWQAttempts_ReleaseWork ON EPOAgentHandlerDataChannelWQAttempts SET (allow_page_locks = OFF ) 