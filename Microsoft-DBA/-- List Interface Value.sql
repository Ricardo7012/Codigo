-- List Interface Value

DECLARE @InterfaceName VARCHAR(25)

SET @InterfaceName = 'ADICardIn1'

SELECT *
FROM InterfaceConfig
WITH (NOLOCK)
WHERE InterfaceName LIKE @InterfaceName