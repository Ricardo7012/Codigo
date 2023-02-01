if (
select count(*) from sys.indexes i
			inner join sys.index_columns sic on sic.object_id = i.object_id and
					sic.index_id = i.index_id
			inner join  sys.columns sc on sc.object_id = sic.object_id and sc.column_id = sic.column_ID
		where
			i.object_id = object_ID('records') and
			i.name = 'ByReferenceNumber'
			and
			(
			(sic.is_included_column = 0 and sc.name ='ReferenceNumber' and sic.index_column_id = 1) or
			(sic.is_included_column = 1 and sc.name ='RecordType' and sic.index_column_id = 2) or
			(sic.is_included_column = 1 and sc.name ='RecordStatus' and sic.index_column_id = 3) or
			(sic.is_included_column = 1 and sc.name ='CheckId' and sic.index_column_id = 4) 
			)
			) != 4
begin
	drop index ByReferenceNumber on records
	create index ByReferenceNumber on Records(ReferenceNumber) include (RecordType, RecordStatus, CheckID)
end




/************** Emergency Rollback script


	drop index ByReferenceNumber on records
	create index ByReferenceNumber on Records(ReferenceNumber) 




*/