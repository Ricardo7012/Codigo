declare 
			@Columns varchar(max)
		,	@Model varchar(64) = 'Claims'
		,	@Entity varchar(512) = 'Claims_Detail'
		,	@View varchar(max), @Schema varchar(32) = 'DBA'
		,	@Object varchar(max)
		,	@TB varchar(256)


set @View = 'Create View [' + @Schema + '].[' + @Entity + ']' + char(13) + 'AS' + char(13) + 'Select'
set @TB = (select EntityTable from mdm.tblEntity where Model_ID in (select ID from mdm.tblModel where [Name] = @Model ) and [Name] = @Entity)
set @Object = 'if not exists (select 1 from sys.schemas where [name] = ''' + @Schema + ''')' + Char(13) + 'Begin' + char(13) + char(9) + 'Create Schema [' + @Schema + ']' + char(13) + 'End' + char(13) + 'GO' + char(13) + char(13) 

select @Columns = 
					STUFF
					(
						(
							select ', [' + TableColumn + '] as [' + DisplayName + ']' 
							from mdm.tblAttribute
							where Entity_ID in
							(
								select id
								from mdm.tblEntity
								where Model_ID in
								(
									select	ID
									from	mdm.tblModel
									where	[Name] = @Model
								)
								and [Name] = @Entity
							)
            
							FOR XML PATH('')
						)
						, 1, 1, ''
					)

select @Object = @Object + @view + @Columns + char(13) + 'From [MDM].[' + @TB + ']' + char(13) + 'where [ValidationStatus_ID] = 3 and [status_id] = 1'

print (@Object)
