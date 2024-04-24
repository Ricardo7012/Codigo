-- https://www.mssqltips.com/sqlservertip/2431/sql-server-column-level-encryption-example-using-symmetric-keys/

USE HSP;
GO
-- Create Table
CREATE TABLE dbo.A_Customer_data
    (
     Customer_id INT CONSTRAINT Pkey3 PRIMARY KEY
                     NOT NULL
    ,Customer_Name VARCHAR(100) NOT NULL
    ,Credit_card_number VARCHAR(25) NOT NULL
    );
-- Populate Table
INSERT  INTO dbo.A_Customer_data
VALUES  ( 74112, 'MSSQLTips2', '2147-4574-8475' );
GO
INSERT  INTO dbo.A_Customer_data
VALUES  ( 74113, 'MSSQLTips3', '4574-8475-2147' );
GO
INSERT  INTO dbo.A_Customer_data
VALUES  ( 74114, 'MSSQLTips4', '2147-8475-4574' );
GO
INSERT  INTO dbo.A_Customer_data
VALUES  ( 74115, 'MSSQLTips5', '2157-1544-8875' );
GO
-- Verify data
SELECT  *
FROM    dbo.A_Customer_data;
GO
------------------------------------------------------------------------------
USE master;
GO
SELECT  *
FROM    sys.symmetric_keys
WHERE   name = '##MS_ServiceMasterKey##';
GO
------------------------------------------------------------------------------
-- Create database Key
USE HSP;
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Password123';
GO
------------------------------------------------------------------------------
-- Create self signed certificate
USE HSP;
GO
CREATE CERTIFICATE Certificate1
WITH SUBJECT = 'Protect Data';
GO
------------------------------------------------------------------------------
-- Create symmetric Key
USE HSP;
GO
CREATE SYMMETRIC KEY SymmetricKey1 
WITH ALGORITHM = AES_128 
ENCRYPTION BY CERTIFICATE Certificate1;
GO
------------------------------------------------------------------------------
USE HSP;
GO
ALTER TABLE dbo.A_Customer_data
ADD Credit_card_number_encrypt VARBINARY(MAX) NULL;
GO
------------------------------------------------------------------------------
-- Populating encrypted data into new column
USE HSP;
GO
-- Opens the symmetric key for use
OPEN SYMMETRIC KEY SymmetricKey1
DECRYPTION BY CERTIFICATE Certificate1;
GO
UPDATE dbo.A_Customer_data
SET Credit_card_number_encrypt = EncryptByKey (Key_GUID('SymmetricKey1'),Credit_card_number)
FROM dbo.A_Customer_data;
GO
-- Closes the symmetric key
CLOSE SYMMETRIC KEY SymmetricKey1;
GO
------------------------------------------------------------------------------
USE HSP;
GO
ALTER TABLE dbo.A_Customer_data
DROP COLUMN Credit_card_number;
GO
------------------------------------------------------------------------------
USE HSP;
GO
OPEN SYMMETRIC KEY SymmetricKey1
DECRYPTION BY CERTIFICATE Certificate1;
GO
-- Now list the original ID, the encrypted ID 
SELECT Customer_id, Credit_card_number_encrypt AS 'Encrypted Credit Card Number',
CONVERT(varchar, DecryptByKey(Credit_card_number_encrypt)) AS 'Decrypted Credit Card Number'
FROM dbo.A_Customer_data;
 
 -- Close the symmetric key
CLOSE SYMMETRIC KEY SymmetricKey1;
GO
------------------------------------------------------------------------------
USE HSP;
GO
OPEN SYMMETRIC KEY SymmetricKey1
DECRYPTION BY CERTIFICATE Certificate1;
-- Performs the update of the record
INSERT INTO dbo.A_Customer_data
        ( Customer_id
        ,Customer_Name
        ,Credit_card_number
        )
VALUES  ( 0  -- Customer_id - int
        ,''  -- Customer_Name - varchar(100)
        ,''  -- Credit_card_number - varchar(25)
        ) (Customer_id, Customer_Name, Credit_card_number_encrypt)
VALUES (25665, 'mssqltips4', EncryptByKey( Key_GUID('SymmetricKey1'), CONVERT(varchar,'4545-58478-1245') ) );    
GO
------------------------------------------------------------------------------
Execute as user='test'
GO
SELECT Customer_id, Credit_card_number_encrypt AS 'Encrypted Credit Card Number',
CONVERT(varchar, DecryptByKey(Credit_card_number_encrypt)) AS 'Decrypted Credit Card Number'
FROM dbo.A_Customer_data;
------------------------------------------------------------------------------
GRANT VIEW DEFINITION ON SYMMETRIC KEY::SymmetricKey1 TO test; 
GO
GRANT VIEW DEFINITION ON Certificate::Certificate1 TO test;
GO
------------------------------------------------------------------------------

