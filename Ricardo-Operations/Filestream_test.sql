-- If a new SQL Server installation, activate at the server level
EXEC sp_configure filestream_access_level, 2;
GO
RECONFIGURE;
GO
--I should note that the significance of the "2" in the statement above is to turn on FILESTREAM for both TSQL and for streaming through the API. Option "1" will turn on just TSQL and option "0" disables FILESTREAM.
-- Create FilestreamTest database for testing using the default settings.
CREATE DATABASE [FilestreamTest]

-- Add the FILESTREAM FILEGROUP to the database
ALTER DATABASE FilestreamTest ADD
FILEGROUP FileStreamGroup1 CONTAINS FILESTREAM;
GO

--You must choose a local drive location for FILESTREAM filegroups which makes sense. A remote share that failed could break the file system. 
--You want to choose a local file location that will not be accessable to users through traditional Windows file sharing because this file 
--structure is an extension of your SQL database. If someone browses the folders and deletes a file, it is gone.
-- Add FILE to FilestreamTest for the FileStreamGroup1
ALTER DATABASE FilestreamTest ADD FILE ( 
NAME = FSGroup1File, 
FILENAME = 'F:\FILESTREAM\FilestreamTest')
TO FILEGROUP FileStreamGroup1;
GO
-- CREATE a test table which contains a varbinary(max) column that will use FILESTREAM. When creating the table, I had to associate the FileStreamGroup1 with this table to handle the FILESTREAM data.
-- Create the test table for FILESTREAM
USE FilestreamTest
GO
CREATE TABLE [dbo].[tFileStreamTest]( 
[id] [int] IDENTITY(1,1) NOT NULL, 
[FileStreamTest] [varbinary](max) FILESTREAM NULL, 
[FileGUID] UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL 
UNIQUE DEFAULT NEWID()
) ON [PRIMARY]
FILESTREAM_ON [FileStreamGroup1];
GO

--Imported an image file using OPENROWSET.
INSERT INTO dbo.tFileStreamTest (FileStreamTest)
SELECT * FROM 
OPENROWSET(BULK N'C:\Database_3.png' ,SINGLE_BLOB) AS Document
