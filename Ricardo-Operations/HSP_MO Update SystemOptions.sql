use HSP_MO
go
select * from SystemOptions where ItemValue like '%HSP3M1%'
select * from ImportLocations where LocationPath LIKE '%HSP3M1%'
select * from ScannedImages where ImagePath LIKE '%HSP3M1%'
select * from ReferenceCodes where [Description] LIKE '%HSP3M1%' and [Type] = 'PermissionedDirectory' AND code = 'MDP';

DECLARE @Pattern as varchar(max) = '\\HSP3M1\hsp\HSP\Documents'
DECLARE @Replacement AS VARCHAR(max) = '\\HSP3M1\hsp\HSP_MO\Documents'

UPDATE SystemOptions
       SET ItemValue = REPLACE(ItemValue, @Pattern, @Replacement);
UPDATE ImportLocations
       SET LocationPath = REPLACE(LocationPath, @Pattern, @Replacement);
UPDATE ScannedImages    
       SET ImagePath = REPLACE(ImagePath, @Pattern, @Replacement);
UPDATE ReferenceCodes
       SET [Description] = REPLACE([Description],@Pattern, @Replacement)
       WHERE [Type] = 'PermissionedDirectory' AND code = 'MDP';
