
SELECT CASE
           WHEN CONVERT(VARCHAR(128), SERVERPROPERTY('productversion')) LIKE '8%'
               THEN
               'SQL2000'
           WHEN CONVERT(VARCHAR(128), SERVERPROPERTY('productversion')) LIKE '9%'
               THEN
               'SQL2005'
           WHEN CONVERT(VARCHAR(128), SERVERPROPERTY('productversion')) LIKE '10.0%'
               THEN
               'SQL2008'
           WHEN CONVERT(VARCHAR(128), SERVERPROPERTY('productversion')) LIKE '10.5%'
               THEN
               'SQL2008 R2'
           WHEN CONVERT(VARCHAR(128), SERVERPROPERTY('productversion')) LIKE '11%'
               THEN
               'SQL2012'
           WHEN CONVERT(VARCHAR(128), SERVERPROPERTY('productversion')) LIKE '12%'
               THEN
               'SQL2014'
           WHEN CONVERT(VARCHAR(128), SERVERPROPERTY('productversion')) LIKE '13%'
               THEN
               'SQL2016'
           WHEN CONVERT(VARCHAR(128), SERVERPROPERTY('productversion')) LIKE '14%'
               THEN
               'SQL2017'
           ELSE
               'unknown'
       END                              AS MajorVersion
     , SERVERPROPERTY('ProductLevel')   AS ProductLevel
     , SERVERPROPERTY('Edition')        AS Edition
     , SERVERPROPERTY('ProductVersion') AS ProductVersion
	 , CONNECTIONPROPERTY('net_transport')     AS net_transport
     , CONNECTIONPROPERTY('protocol_type')     AS protocol_type
     , CONNECTIONPROPERTY('auth_scheme')       AS auth_scheme
     , CONNECTIONPROPERTY('local_net_address') AS local_net_address
     , CONNECTIONPROPERTY('local_tcp_port')    AS local_tcp_port;
	--, CONNECTIONPROPERTY('client_net_address') AS client_net_address 