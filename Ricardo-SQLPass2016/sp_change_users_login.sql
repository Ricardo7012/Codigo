USE 
GO 
--SP_CHANGE_USERS_LOGIN 'update_one','[db_username]','[server_login]'

SP_CHANGE_USERS_LOGIN 'update_one','pubuser','pubuser'
GO

SP_CHANGE_USERS_LOGIN 'update_one','privuser','privuser'
GO

