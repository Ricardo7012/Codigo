-- https://msdn.microsoft.com/en-us/library/bb934049.aspx
-- http://sqlmag.com/database-security/using-transparent-data-encryption

USE master;
GO

SELECT  *
FROM    sys.certificates;

 --ENCRYPTION_STATE = 3 IS ENCRYPTED
SELECT  *
FROM    sys.dm_database_encryption_keys
WHERE   encryption_state = 3;

-- The master key must be in the master database.
USE master;
GO

-- Create the master key.
CREATE MASTER KEY ENCRYPTION BY PASSWORD= 'S6YDgyAIlEB1PHyU4FxuM@st3rr';
GO

SELECT  *
FROM    sys.symmetric_keys
--WHERE   name LIKE '%DatabaseMasterKey%'; 


-- Create a certificate.
CREATE CERTIFICATE IEHPSQLCertificate
WITH SUBJECT='IEHPSQLCertificate for TDE';
GO

--CONFIRM CERT EXISTS
SELECT  *
FROM    sys.certificates;


-- Use the database to enable TDE.
USE TDE_test;
GO
 
-- Associate the certificate to MyDatabase.
CREATE DATABASE ENCRYPTION KEY WITH ALGORITHM = AES_128 ENCRYPTION BY SERVER
    CERTIFICATE IEHPSQLCertificate;
GO
-- Warning: The certificate used for encrypting the database encryption key has not been backed up. You should immediately back up the certificate and the private key associated with the certificate. If the certificate ever becomes unavailable or if you must restore or attach the database on another server, you must have backups of both the certificate and the private key or you will not be able to open the database.


-- Encrypt the database.
ALTER DATABASE TDE_test
SET ENCRYPTION ON;
GO

-- ENCRYPTION_STATE = 3 IS ENCRYPTED
-- https://msdn.microsoft.com/en-us/library/bb677274.aspx
--Indicates whether the database is encrypted or not encrypted.
--0 = No database encryption key present, no encryption
--1 = Unencrypted
--2 = Encryption in progress
--3 = Encrypted
--4 = Key change in progress
--5 = Decryption in progress
--6 = Protection change in progress (The certificate or asymmetric key that is encrypting the database encryption key is being changed.)
SELECT  *
FROM    sys.dm_database_encryption_keys
WHERE   encryption_state = 3;

-- *************************************************************************** 
-- BACKUP, RESTORE AND MOVING ENCRYPTED DATABASES
-- *************************************************************************** 
USE master;
GO

BACKUP CERTIFICATE IEHPSQLCertificate
TO FILE = 'C:\Certs\IEHPSQLCertificate.cer'
WITH PRIVATE KEY (FILE='C:\Certs\IEHPSQLCertificate.cer',
ENCRYPTION BY PASSWORD='S6YDgyAIlEB1PHyU4Fxu');
-- AT THIS POINT YOU MAY GET AN PERMISSION ERROR. CHECK TO SEE IF THE FILE HAS BEEN CREATED IF SO YOU MAY IGNORE IT
USE master;
GO

-- *************************************************************************** 
-- Create a new master key.
-- *************************************************************************** 
--CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'S6YDgyAIlEB1PHyU4FxuM@st3rr';
 
-- RESTORE THE CERTIFICATE.
--CREATE CERTIFICATE IEHPSQLCertificate
--FROM FILE='c:\certs\IEHPSQLCertificate'
--WITH PRIVATE KEY (
--FILE = 'c:\certs\IEHPSQLCertificate',
--DECRYPTION BY PASSWORD='S6YDgyAIlEB1PHyU4Fxu');

-- *************************************************************************** 
-- *************************************************************************** 

USE master;
GO
SELECT  *
FROM    sys.certificates;

-- ENCRYPTION_STATE = 3 IS ENCRYPTED
SELECT  *
FROM    sys.dm_database_encryption_keys
WHERE   encryption_state = 3;


-- https://msdn.microsoft.com/en-us/library/ff773063.aspx
-- https://blogs.msdn.microsoft.com/alwaysonpro/2015/01/07/how-to-add-a-tde-encrypted-database-to-an-availability-group/
