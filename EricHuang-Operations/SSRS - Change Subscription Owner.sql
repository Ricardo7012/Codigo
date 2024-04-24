DECLARE @OldUserID uniqueidentifier
DECLARE @NewUserID uniqueidentifier

SELECT * FROM dbo.Users --WHERE UserName = 'IEHP\v3001'

SELECT @OldUserID = UserID FROM dbo.Users WHERE UserName = 'IEHP\v3001'
SELECT @NewUserID = UserID FROM dbo.Users WHERE UserName = 'IEHP\i7658'

--SELECT * FROM dbo.Subscriptions WHERE OwnerID = @OldUserID
SELECT * FROM dbo.Subscriptions WHERE OwnerID <> @NewUserID
--SELECT * FROM dbo.Users WHERE UserID IN (SELECT OwnerID FROM dbo.Subscriptions WHERE OwnerID <> @NewUserID)

--UPDATE dbo.Subscriptions SET OwnerID = @NewUserID WHERE OwnerID = @OldUserID


SELECT u.UserName,
       COUNT(1) AS TotalScheduleSubscriptions
FROM dbo.ReportSchedule c
    JOIN dbo.Subscriptions d
        ON c.SubscriptionID = d.SubscriptionID
    JOIN dbo.Users AS u
        ON d.OwnerID = u.UserID
    JOIN dbo.Catalog e
        ON ItemID = Report_OID
GROUP BY u.UserName
ORDER BY 1;


SELECT u.UserName, 
	e.[Name] AS ReportName,
	d.[Description] AS SubscriptionDescription,
	e.[Path]
FROM dbo.ReportSchedule c
    JOIN dbo.Subscriptions d
        ON c.SubscriptionID = d.SubscriptionID
    JOIN dbo.Users AS u
        ON d.OwnerID = u.UserID
    JOIN dbo.Catalog e
        ON ItemID = Report_OID
WHERE u.UserName = 'IEHP\c1305';




SELECT u.UserName, 
	e.[Name] AS ReportName,
	e.[Path]
FROM dbo.Users AS u
    JOIN dbo.Catalog e
        ON e.CreatedByID = u.UserID
WHERE u.UserName = 'IEHP\i8466';




BEGIN TRANSACTION
--UPDATE dbo.Users SET UserName = 'IEHP\i8466' WHERE UserName = 'IEHP\c1305'
ROLLBACK
COMMIT

/*

DECLARE @OldUser NVARCHAR(260)= 'YOURDOMAIN\oldusername'
DECLARE @NewUser NVARCHAR(260)= 'YOURDOMAIN\serviceaccount'

DECLARE @NewUserID UNIQUEIDENTIFIER

--find the new user id
SELECT
    @NewUserID = uNew.UserID
FROM
    dbo.Users AS uNew
WHERE
    uNew.UserName = @NewUser

--update the userID if i
IF @NewUserID IS NOT NULL 
    BEGIN
        UPDATE
            s
        SET 
            s.OwnerID = @NewUserID
        FROM
            dbo.Subscriptions AS s
        JOIN 
            dbo.Users AS uOld ON s.OwnerID = uOld.UserID
                                 AND uOld.UserName = @OldUser
								 where s.SubscriptionID='752101D7-B11A-425A-81E0-C1A6BE07A066'
    END

*/
