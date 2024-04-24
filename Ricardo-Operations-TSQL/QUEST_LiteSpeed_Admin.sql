SELECT s1.type, 
s1.backup_start_date, 
s1.backup_finish_date, 
s1.backup_size, 
s2.physical_device_name 
FROM msdb..backupset s1 
INNER JOIN msdb..backupmediafamily s2 
ON s1.media_set_id = s2.media_set_id 
WHERE s1.database_name = '' 
-- and s1.type in('D','L','I') -- sl.type in ('D','L') means full or Transaction Log backups (if 'I', Differential backups) 
-- and s1.backup_start_date >= (select max(backup_start_date) from msdb..backupset where database_name ='' and type ='D') -- change to the LogShipped Database 
ORDER BY s1.backup_start_date DESC 



 
SELECT TOP 20 * FROM LITESPEEDLOCAL..LITESPEEDACTIVITY WHERE ServerName='' ORDER BY STARTTIME DESC

select @@SERVERNAME
exec xp_sqllitespeed_version
exec xp_sqllitespeed_licenseinfo

--select * from msdb..backupset bs inner join msdb..backupmediafamily bf on bs.media_set_id = bf.media_set_id
 
select 
[backup_set_id]
,[backup_set_uuid]
,bs.[media_set_id]
,[first_family_number]
,[first_media_number]
,[last_family_number]
,[last_media_number]
,[catalog_family_number]
,[catalog_media_number]
,[position]
,[expiration_date]
,[software_vendor_id]
,[name]
,[description]
--,[user_name]
,[software_major_version]
,[software_minor_version]
,[software_build_version]
,[time_zone]
,[mtf_minor_version]
,[first_lsn]
,[last_lsn]
,[checkpoint_lsn]
,[database_backup_lsn]
,[database_creation_date]
,[backup_start_date]
,[backup_finish_date]
,[type]
,[sort_order]
,[code_page]
,[compatibility_level]
,[database_version]
,[backup_size]
,[database_name]
--,[server_name]
--,[machine_name]
,[flags]
,[unicode_locale]
,[unicode_compare_style]
,[collation_name]
,[is_password_protected]
,[recovery_model]
,[has_bulk_logged_data]
,[is_snapshot]
,[is_readonly]
,[is_single_user]
,[has_backup_checksums]
,[is_damaged]
,[begins_log_chain]
,[has_incomplete_metadata]
,[is_force_offline]
,[is_copy_only]
,[first_recovery_fork_guid]
,[last_recovery_fork_guid]
,[fork_point_lsn]
,[database_guid]
,[family_guid]
,[differential_base_lsn]
,[differential_base_guid]
,[compressed_backup_size]
,[key_algorithm]
,[encryptor_thumbprint]
,[encryptor_type]
from msdb..backupset bs inner join msdb..backupmediafamily bf on bs.media_set_id = bf.media_set_id 
where database_name = 'HSP_QA1' 
ORDER BY backup_finish_date DESC
