-- Check Index Names and Pages
use AdventureWorks2019
go

Select object_name(i.object_id) As 'Table Name'
    , i.name As 'Index Name'
    , i.type_desc AS 'Type Description'
    , Max(p.partition_number) As 'Ppartitions'
    , Sum(p.rows) As 'Rows'
    , Sum(au.data_pages) As 'Data Pages'
    , Sum(p.rows) / Sum(au.data_pages) As 'Rows Per Page'
From sys.indexes As i
Join sys.partitions As p
    On i.object_id = p.object_id
    And i.index_id = p.index_id
Join sys.allocation_units As au
    On p.hobt_id = au.container_id
Where object_name(i.object_id) Not Like 'sys%'
    And au.type_desc = 'IN_ROW_DATA'
Group By object_name(i.object_id)
    , i.name
    , i.type_desc
Having Sum(au.data_pages) > 100
Order By 'Table Name' ASC	