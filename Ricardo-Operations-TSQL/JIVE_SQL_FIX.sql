USE JIVECOREV9
go
-- PLUGINS
-- Delete plugins (they will need to be reinstalled as needed)
DELETE FROM jiveplugin;
-- EMAIL
-- Disable active email addresses to prevent accidental sending.
--UPDATE jiveuser SET email = (REPLACE(email, '@', '_AT_') WHERE email LIKE '@junk.socialedgeconsulting.io');

UPDATE jiveuser SET email=replace(email, '@', '@noemail') WHERE email LIKE '%@%'

-- Unscramble emails
-- update jiveuser set email = replace(replace(email, '@junk.socialedgeconsulting.io', ''), '_AT_', '@');
-- EMAIL (OUTGOING)
UPDATE jiveproperty SET propvalue = 'DISABLED' WHERE name = 'mail.smtp.host';
-- disable email digest and email watch notices (insert first in case property is not there to prevent default behavior of sending)
INSERT INTO jiveproperty (name, propvalue) VALUES ('jive.digest.enabled', 'false');
INSERT INTO jiveproperty (name, propvalue) VALUES ('watches.emailNotifyEnabled','false');
UPDATE jiveProperty SET propvalue = 'false' WHERE name='jive.digest.enabled';
UPDATE jiveProperty SET propvalue = 'false' WHERE name='watches.emailNotifyEnabled';
-- EMAIL (INCOMING)
UPDATE jiveproperty SET propvalue = 'DISABLED' WHERE name = 'checkmail.host';
-- OTHER
UPDATE jiveproperty SET propvalue = 'https://jive9dev.iehp.local' WHERE name = 'jiveURL';
UPDATE jiveproperty SET propvalue = 'https://jive9dev.iehp.local/images/emoticons' WHERE name = 'globalRenderManager.EmoticonFilter.imageURL';
UPDATE jiveProperty SET propvalue = 'false' WHERE name = 'reporting.thirdParty.enabled'; -- Can reconfigure for lower environment after restore.
UPDATE jiveProperty set propvalue = 'false' WHERE name = 'docverse.enabled' or name='officeintegration.enabled'; -- Can reconfigure after restore if these are used.
--How-To: Refresh an on-prem server from another database
--4
-- APPS/ADD-ONS
--INSERT INTO jiveproperty (name, propvalue) VALUES ('jive.appsmarket.registry.enabled', 'false'); -- Insurance in case it is not present. Newer property Can reenable after config.

UPDATE jiveproperty SET propvalue = 'false' WHERE name = 'jive.appsmarket.registry.enabled';
UPDATE jiveproperty SET propvalue = 'false' WHERE name = 'jive.apps.enabled';
-- CLUSTER
-- wipe out the existing cluster
UPDATE jiveproperty SET propvalue = 'false' WHERE name = 'cache.clustering.enabled';
DELETE FROM jiveproperty WHERE name LIKE 'jive.cache.voldemort.servers%';
DELETE FROM jiveproperty WHERE name LIKE 'jive.cluster.jgroup%';
-- ANALYTICS
-- analytics does not seem to support a plain text password that is encrypted after start so
--we adjust and disable so we can configure from the admin UI
UPDATE jiveproperty SET propvalue = 'false' WHERE name = '__jive.analytics.enabled';
-- Reset the password even though it is disabled...caution is good.
UPDATE jiveproperty SET propvalue = '' WHERE name = '__jive.analytics.database.password';
--UPDATE jiveproperty SET propvalue = 'jdbc:postgresql://<ANALYTICSDB-HOST>:5432/<ANALYTICSDB-NAME>' WHERE name = '__jive.analytics.database.serverURL';

-- ACTIVITY ENGINE (EAE)
UPDATE jiveproperty SET propvalue = 'LOCALHOST:7020' WHERE name = 'jive.activitymanager.endpoints';
UPDATE jiveproperty SET propvalue = 'jdbc:postgresql://JIVESQLDEV\JIVEV9:5432/JIVECOREV9' WHERE name = 'jive.eae.db.url';
UPDATE jiveproperty SET propvalue = '' WHERE name = '__jive.eae.db.password';
-- delete this key to force a rebuild of the EAE index (only do this if you DID NOT migrate
--the EAE database)
DELETE FROM jiveproperty WHERE name IN ('jive.master.eae.key.node');
-- SEARCH
UPDATE jiveproperty SET propvalue = 'LOCALHOST' WHERE name = 'services.skyhook.host';
-- LDAP (if the system is using an ldap synchronization. Can finish configuring this from the
--admin console (username password etc.))
UPDATE jiveproperty SET propvalue = 'false' WHERE name = 'jive.sync.user.ldap';
--How-To: Refresh an on-prem server from another database
--5
--SSO, STATS, and DOCUMENT CONVERSION
UPDATE jiveproperty SET propvalue = 'false' WHERE name = 'saml.enabled';
UPDATE jiveproperty SET propvalue = 'LOCALHOST' WHERE name = 'jive.dv.service.hosts';
UPDATE jiveproperty SET propvalue = 'false' WHERE name = 'stats.enabled';

--END 
--FIX PERMISSIONS
USE JIVEEAEV9
GO
EXEC sys.sp_change_users_login @Action = 'Update_one', -- varchar(10)
    @UserNamePattern = 'JiveUser', -- sysname
    @LoginName = 'JiveUser' -- sysname

--RESET PASSWORDHASH
--UPDATE jiveUser SET passwordhash = '88495fc3f8a256fcacf5403224d45cb57b0a5a6b966af25d68e5011527933b73', creationdate = 1222816186405, userenabled=1 WHERE userid=1;