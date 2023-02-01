SELECT  SERVERPROPERTY('computernamephysicalnetbios') AS ServerName ,
        dosi.virtual_machine_type_desc ,
        Server_type = CASE WHEN dosi.virtual_machine_type = 1 THEN 'Virtual'
                           ELSE 'Physical'
                      END
FROM    sys.dm_os_sys_info dosi;

