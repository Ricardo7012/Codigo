USE [ProviderSearch]
GO
/****** Object:  StoredProcedure [GeoCode].[GetProviderAddressInformation]    Script Date: 10/5/2016 5:43:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER procedure [GeoCode].[GetProviderAddressInformation]
	@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
				08/08/2016	1.00	RK		Created new procedure
				08/22/2016	1.01	RK		Converted all the Address details into Capital casing and merged the resultant changes
											into the targeted table.				
				09/27/2016	1.02	RK		Added versioning
                                            Added DateTime variable to store the present DateTime.
				09/28/2016	1.03	RK      Updated versioning.
							1.04	RK		Updated Stored Procedure and added method to retrieve new and stale Addresses.
				09/29/2016	1.05	RGB		Renamed procedure to be more reflective of content and reformatted for readability
				09/30/2016  1.06    RK      Changed all the source tables to import the data.
				10/03/2016	1.07	RK		Included Pharmacies to get the Pharmacy address details for geocoding. Populated Pharmacies addresses
											into the GeoCode.addresses table.
				10/03/2016	1.08	RK		Changed value for ProviderId for "Pharmacies" to NPI.
				10/03/2016	1.09	RK		Removed condition to check for termed providers for IPA.
		*/

		declare @Version varchar(100) = '10/03/2016 17:20 Version 1.09'
		declare @ReturnValues table
			(
			 ReturnCode int primary key
							not null
			,Reason varchar(200) not null
			)

		insert into @ReturnValues
				(ReturnCode, Reason)
			values (0, 'Normal Return')			
											
		if @Showversion = 1
			begin
				select object_schema_name(@@PROCId) as SchemaName
					   ,object_name(@@PROCId) as ProcedureName
					   ,@Version as VersionInformation
				if isnull(@ShowReturn, 0) = 0
					return 0
			end

		if @ShowReturn = 1
			begin
				select *
					from @ReturnValues
				return 0
			end

		set nocount on

		declare @provtemp table
			(
			 ProviderId varchar(12)
			,ProviderType varchar(12)
			,SeqNo varchar(5)
			,RowHash varbinary(16)
			,AddressId int
			,Address varchar(255)
			,Address2 varchar(60)
			,City varchar(30)
			,County varchar(50)
			,State varchar(12)
			,Zipcode varchar(9)
			)
		declare @provc as geocode.AllProviderAddresses
		declare @now datetime = getdate()
		   ,@bar char(1) = '|'		

		--      Gather all the providers from the different sources.
		insert into @provc
				(
				 ProviderID
				,ProviderType
				,SeqNo
				,Address
				,Address2
				,City
				,State
				,Zip
				,County
				)

			-- All PCP, NPCP, MPCP, TPCP from Diam_725_App Database
			select distinct F.PAPROVID as ProviderId
				   ,F.PATYPE as ProviderType
				   ,isnull(A.PCSEQNO, '') as SeqNo
				   ,isnull(A.PCADDR1, '') as Address
				   ,A.PCADDR2 as Address2
				   ,A.PCCITY as City
				   ,A.PCSTATE as State
				   ,A.PCZIP as Zip
				   ,case A.PCCOUNTY
					  when '36' then 'San Bernardino County'
					  when '33' then 'Riverside County'
					  when '19' then 'Los Angeles County'
					  when '30' then 'Orange County'
					  else null
					end as County
				from Diam_725_App.diamond.JPROVFM0_DAT F with (nolock)
					inner join Diam_725_App.diamond.JPROVAM0_DAT A with (nolock)
						on A.PCPROVID = F.PAPROVID
						   and A.PCTYPE = F.PATYPE
					inner join Diam_725_App.diamond.JPROVCM0_DAT C with (nolock)
						on C.PBPROVID = F.PAPROVID
				where F.PAPROVID not in ('000000000087', '000000000088', '000000000089', '000000099999')
					and F.PATYPE in ('PCP', 'NPCP', 'MPCP', 'TPCP')
					and isnull(F.PAADDR1, '') != ''
					and isnull(F.PACITY, '') != ''
					and isnull(F.PASTATE, '') != ''
					and isnull(A.PCCOUNTY, '') != ''
			union

-- ANC/DANC providers from Contract_CPL declare @now date = getdate()
			select distinct                                                      -- ANC/DANC   
					cast(ppi.PPI_ID as varchar(12)) as ProviderId
				   ,PT.PPY_Code as ProviderType
				   ,isnull(cast(Locations.CL_ID as varchar(10)), '') as SeqNo
				   ,		--LocationId as a seq No		
					isnull(Locations.CL_Address1, '') as Address
				   ,Locations.CL_Address2 as Address2
				   ,Locations.CL_City as City
				   ,CL_State as State
				   ,Locations.CL_Zip as Zip
				   ,ZC.OZCA_county as County
				from Network_Development.dbo.Tbl_Contract_Locations as Locations with (nolock)
					inner join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
						on CPL.CCPL_LocationID = Locations.CL_ID
					inner join Network_Development.dbo.Tbl_Provider_ProviderInfo as ppi with (nolock)
						on CPL.CCPL_ProviderID = ppi.PPI_ID
					left join Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock)
						on CCI.CCI_ID = CPL.CCPL_ContractID
					left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
						on ZC.OZCA_zip = Locations.CL_Zip
					inner join Network_Development.dbo.Tbl_Provider_ProviderType as PT with (nolock)
						on PT.PPY_ID = ppi.PPI_Type
				where PT.PPY_ID in ('17', '28')
					and (ppi.PPI_UPIN is not null)
			union

--All ANC from AncillaryRoster view	 
			select distinct cast(PPI.PPI_ID as varchar(12)) as ProviderId
				   ,PT.PPY_Code as ProviderType
				   ,isnull(cast(CL_ID as varchar(10)), '') as SeqNo
				   ,		--LocationId as a seq No		
					isnull(CL_Address1, '') as Address
				   ,CL_Address2 as Address2
				   ,CL_City as City
				   ,CL_State as State
				   ,CL_Zip as Zip
				   ,case CL_CountyCode
					  when '36' then 'San Bernardino County'
					  when '33' then 'Riverside County'
					  when '19' then 'Los Angeles County'
					  when '30' then 'Orange County'
					  else null
					end as County
				from Network_Development.dbo.vw_IEHP_Ancillary_Roster with (nolock)
					inner join Network_Development.dbo.Tbl_Contract_Locations with (nolock)
						on LocationID = CL_ID
					inner join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
						on CPL.CCPL_ContractID = ContractID
					left join Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
						on PPI.PPI_ID = CPL.CCPL_ProviderID
					left join Network_Development.dbo.Tbl_Provider_ProviderType as PT with (nolock)
						on PT.PPY_ID = PPI.PPI_Type
				where isnull(LocationID, 0) != 0
					and isnull(ContractID, 0) != 0
					and CL_Address is not null
					and CL_City is not null
					and CL_State is not null
					and CL_Zip is not null
					and PT.PPY_ID in ('17', '28')
			union

--All UC from Network_Development 
			select distinct isnull(CCI.CCI_ContractDiamondID, cast(CPL.CCPL_ProviderID as varchar(12))) as ProviderId
				   ,'UC' as ProviderType
				   ,isnull(cast(CL.CL_ID as varchar(10)), '') as SeqNo
				   ,		--LocationId as a seq No		
					isnull(CL.CL_Address1, '') as Address
				   ,CL.CL_Address2 as Address2
				   ,CL.CL_City as City
				   ,CL.CL_State as State
				   ,CL.CL_Zip as Zip
				   ,case CL.CL_CountyCode
					  when '36' then 'San Bernardino County'
					  when '33' then 'Riverside County'
					  when '19' then 'Los Angeles County'
					  when '30' then 'Orange County'
					  else null
					end as County
				from Network_Development.dbo.Tbl_Contract_UC_new as UCN with (nolock)
					inner join Network_Development.dbo.Tbl_Contract_ContractInfo CCI with (nolock)
						on CCI.CCI_ID = UCN.ContractID
					inner join Network_Development.dbo.Tbl_Contract_CPL CPL with (nolock)
						on CPL.CCPL_ContractID = CCI.CCI_ID
					inner join Network_Development.dbo.Tbl_Contract_Locations as CL with (nolock)
						on UCN.LocationID = CL.CL_ID
			union 

-- all UC providers
			select distinct cast(pdna.PDNA_ProviderID as varchar(12)) as ProviderId
				   ,'UC' as ProviderType
				   ,isnull(cast(pdna.PDNA_LocationID as varchar(10)), '') as SeqNo
				   ,isnull(cl.CL_Address1, '') as Address
				   ,cl.CL_Address2 as Address2
				   ,cl.CL_City as City
				   ,cl.CL_State as State
				   ,cl.CL_Zip as Zip
				   ,case cl.CL_CountyCode
					  when '36' then 'San Bernardino County'
					  when '33' then 'Riverside County'
					  when '19' then 'Los Angeles County'
					  when '30' then 'Orange County'
					  else null
					end as County
				from Network_Development.dbo.Tbl_Provider_DelegatedNetwork_Affiliation pdna --on pdna.PDNA_ProviderId = ppi.ppi_id
					inner join Network_Development.dbo.Tbl_Contract_Locations as cl
						on cl.CL_ID = pdna.PDNA_LocationID
				where pdna.PDNA_Specialty = 124
					and (
						 pdna.PDNA_TermDate is null
						 or pdna.PDNA_TermDate > @now
						)
			union

--All SPEC,PCP/SPEC, BH from Network_Development
			select distinct cast(PP.PPI_ID as varchar(12)) as ProviderId
				   ,PT.PPY_Diamond as ProviderType
				   ,isnull(cast(Locations.CL_ID as varchar(10)), '') as SeqNo
				   ,		--LocationId as a seq No												
					isnull(Locations.CL_Address1, '') as Address
				   ,Locations.CL_Address2 as Address2
				   ,Locations.CL_City as City
				   ,Locations.CL_State as State
				   ,Locations.CL_Zip as Zip
				   ,ZC.OZCA_county as County
				from Network_Development.dbo.Tbl_Provider_ProviderInfo as PP with (nolock)
					inner join Network_Development.dbo.Tbl_Provider_ProviderAffiliation as PA with (nolock)
						on PA.PPA_ProviderID = PP.PPI_ID
					inner join Network_Development.dbo.Tbl_Contract_Locations as Locations with (nolock)
						on Locations.CL_ID = PA.PPA_LocationID
					left join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
						on CPL.CCPL_ProviderID = PP.PPI_ID
					left join Network_Development.dbo.Tbl_Provider_ProviderType as PT with (nolock)
						on PT.PPY_ID = PP.PPI_Type
					left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
						on ZC.OZCA_zip = Locations.CL_Zip
				where PP.PPI_Type in (1, 6, 12, 13, 27, 29)
			union

--All IPA from Network_Development
			select distinct cast(PP.PPI_ID as varchar(12)) as ProviderId
				   ,PT.PPY_Diamond as ProviderType
				   ,isnull(cast(Locations.CL_ID as varchar(10)), '') as SeqNo
				   ,isnull(Locations.CL_Address1, '') as Address
				   ,Locations.CL_Address2 as Address2
				   ,Locations.CL_City as City
				   ,Locations.CL_State as State
				   ,Locations.CL_Zip as Zip
				   ,ZC.OZCA_county as County
				from Network_Development.dbo.Tbl_Provider_ProviderInfo as PP with (nolock)
					inner join Network_Development.dbo.Tbl_Provider_ProviderType as PT with (nolock)
						on PT.PPY_ID = PP.PPI_Type
					inner join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
						on CPL.CCPL_ProviderID = PP.PPI_ID
					inner join Network_Development.dbo.Tbl_Contract_Locations as Locations with (nolock)
						on CPL.CCPL_LocationID = Locations.CL_ID
					left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
						on Locations.CL_Zip = ZC.OZCA_zip
				where (PP.PPI_Type = 24)
			union

--All LTSS from Network_Development
			select distinct cast(ppi.PPI_ID as varchar(12)) as ProviderId
				   ,'LTSS' as ProviderType
				   ,isnull(cast(Locations.CL_ID as varchar(10)), '') as SeqNo
				   ,isnull(Locations.CL_Address1, '') as Address
				   ,Locations.CL_Address2 as Address2
				   ,Locations.CL_City as City
				   ,Locations.CL_State as State
				   ,Locations.CL_Zip as Zip
				   ,ZC.OZCA_county as County
				from Network_Development.dbo.Tbl_Contract_Locations as Locations with (nolock)
					inner join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
						on CPL.CCPL_LocationID = Locations.CL_ID
					inner join Network_Development.dbo.Tbl_Provider_ProviderInfo as ppi with (nolock)
						on CPL.CCPL_ProviderID = ppi.PPI_ID
					inner join Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock)
						on CCI.CCI_ID = CPL.CCPL_ContractID
					left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
						on ZC.OZCA_zip = Locations.CL_Zip
				where (CCI.CCI_ContractTitle = 53)
					and CCI.CCI_Status = 1
					and (
						 CPL.CCPL_TermDate is null
						 or CPL.CCPL_TermDate > @now
						)
					and (
						 CCI.CCI_ExpDate is null
						 or CCI.CCI_ExpDate > @now
						)
			union

--All HOSP from Network_Development
			select distinct cast(PP.PPI_ID as varchar(12)) as ProviderId
				   ,'HOSP' as ProviderType
				   ,isnull(cast(Locations.CL_ID as varchar(10)), '') as SeqNo
				   ,isnull(Locations.CL_Address1, '') as Address
				   ,Locations.CL_Address2 as Address2
				   ,Locations.CL_City as City
				   ,Locations.CL_State as State
				   ,Locations.CL_Zip as Zip
				   ,ZC.OZCA_county as County
				from Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock)
					left join Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
						on CCI.CCI_ID = CPL.CCPL_ContractID
					left join Network_Development.dbo.Tbl_Provider_ProviderInfo as PP with (nolock)
						on PP.PPI_ID = CPL.CCPL_ProviderID
					left join Network_Development.dbo.Tbl_Contract_Locations as Locations with (nolock)
						on Locations.CL_ID = CPL.CCPL_LocationID
					left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
						on ZC.OZCA_zip = Locations.CL_Zip
				where CCI.CCI_ContractType in (8, 9)
					
					and PP.PPI_ID is not null
					and CCI.CCI_TermDate is null
					or CCI_TermDate > @now
					and (
						 CPL.CCPL_TermDate is null
						 or CPL.CCPL_TermDate > @now
						)
					and (
						 CCI.CCI_ExpDate is null
						 or CCI.CCI_ExpDate > @now
						)
			union 

--All SNF from Network_Development
			select distinct cast(PPI.PPI_ID as varchar(12)) as ProviderId
				   ,'SNF' as ProviderType
				   ,isnull(cast(CL.CL_ID as varchar(10)), '') as SeqNo
				   ,isnull(CL.CL_Address1, '') as Address
				   ,CL.CL_Address2 as Address2
				   ,CL.CL_City as City
				   ,CL.CL_State as State
				   ,CL.CL_Zip as Zip
				   ,ZC.OZCA_county as County
				from Network_Development.dbo.Tbl_Contract_CPL as CPL with (nolock)
					inner join Network_Development.dbo.Tbl_Contract_ContractInfo as CCI with (nolock)
						on CPL.CCPL_ContractID = CCI.CCI_ID
					inner join Network_Development.dbo.Tbl_Contract_Locations as CL with (nolock)
						on CPL.CCPL_LocationID = CL.CL_ID
					inner join Network_Development.dbo.Tbl_Provider_ProviderInfo as PPI with (nolock)
						on CPL.CCPL_ProviderID = PPI.PPI_ID
					left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
						on ZC.OZCA_zip = CL.CL_Zip
				where (
					   (CCI.CCI_ContractType = 17)
					   or (
						   CCI.CCI_ContractType = 18
						   and CCI.CCI_ContractTitle in (97, 30)
						  )
					  )
					and CCI.CCI_Status = 1
					and (
						 CPL.CCPL_TermDate > @now
						 or CPL.CCPL_TermDate is null
						)
					and (
						 CCI.CCI_ExpDate is null
						 or CCI.CCI_ExpDate > @now
						)
			union

--All VSN from Network_Development
			select distinct cast(PP.PPI_ID as varchar(12)) as ProviderId
				   ,'VSN' as ProviderType
				   ,isnull(cast(locations.CL_ID as varchar(10)), '') as SeqNo
				   ,isnull(locations.CL_Address1, '') as Address
				   ,locations.CL_Address2 as Address2
				   ,locations.CL_City as City
				   ,locations.CL_State as State
				   ,locations.CL_Zip as Zip
				   ,ZC.OZCA_county as County
				from Network_Development.dbo.Tbl_Provider_ProviderInfo as PP with (nolock)
					inner join Network_Development.dbo.Tbl_Provider_ProviderAffiliation as PPA with (nolock)
						on PP.PPI_ID = PPA.PPA_ProviderID
					inner join Network_Development.dbo.Tbl_Contract_Locations as locations with (nolock)
						on locations.CL_ID = PPA.PPA_LocationID
					left join Network_Development.dbo.Tbl_Contract_LocationsNumbers as LN with (nolock)
						on LN.CLNS_ProviderID = PP.PPI_ID
					left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
						on ZC.OZCA_zip = locations.CL_Zip
				where PP.PPI_Type in ('15', '16')
					and (
						 PPA.PPA_TermDate is null
						 or PPA.PPA_TermDate > @now
						)
			union

--NPP
			select distinct cast(PP.PPI_ID as varchar(12)) as ProviderId
				   ,'NPP' as ProviderType
				   ,isnull(cast(locations.CL_ID as varchar(10)), '') as SeqNo
				   ,isnull(locations.CL_Address1, '') as Address
				   ,locations.CL_Address2 as Address2
				   ,locations.CL_City as City
				   ,locations.CL_State as State
				   ,locations.CL_Zip as Zip
				   ,ZC.OZCA_county as County
				from Network_Development.dbo.Tbl_Provider_ProviderInfo as PP with (nolock)
					inner join Network_Development.dbo.Tbl_Provider_ProviderAffiliation as PPA with (nolock)
						on PP.PPI_ID = PPA.PPA_ProviderID
					inner join Network_Development.dbo.Tbl_Contract_Locations as locations with (nolock)
						on locations.CL_ID = PPA.PPA_LocationID
					left join Network_Development.dbo.Tbl_Contract_LocationsNumbers as LN with (nolock)
						on LN.CLNS_ProviderID = PP.PPI_ID
					left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
						on ZC.OZCA_zip = locations.CL_Zip
				where PP.PPI_Type in ('5', '8', '9')
			union

-- All PHARMACY providers.
			select distinct cast(PH.NPI as varchar(12)) as ProviderId
				   ,														--ph.id is unique id for each pharmacy in pharmacy table but this is not ned dev id
					'PHRM' as ProviderType
				   ,isnull(cast(CL.CL_ID as varchar(12)), '') as SeqNo
				   ,PH.Address_1 as Address
				   ,null as Address2
				   ,PH.City as City
				   ,PH.State as State
				   ,PH.Zip as Zip
				   ,ZC.OZCA_county as County
				from Pharmacy.Pharmacy.dbo.IEHP_Pharmacy_Providers as PH with (nolock)
					left join Network_Development.dbo.Tbl_Contract_Locations as CL with (nolock)
						on CL.CL_NPI = PH.NPI
					left join Network_Development.dbo.Tbl_Codes_ZipCodes_CA as ZC with (nolock)
						on ZC.OZCA_zip = PH.Zip
				where (
					   (
						(PH.Cty) = 'Riv'
						or (PH.Cty) = 'SB'
					   )
					   and (
							(PH.NABP) not like '00000'
							and (PH.NABP) not like '99999'
						   )
					   and (
							(PH.ClosedDate) is null
							and PH.ClosedDate > getdate()
						   )
					  )
					or (
						((PH.Cty) = 'LA')
						and (
							 (PH.City) like 'Chino'
							 or (PH.City) like 'Pomona'
							 or (PH.City) like 'Montclair'
							 or (PH.City) = 'Chino Hills'
							)
						and ((PH.ClosedDate) is null)
					   )
					or (
						((PH.IEHP_Network) = '1')
						and ((PH.ClosedDate) is null)
					   )

--      Update rowhash values for all of the providers 
		update @provc
			set	RowHash = hashbytes('MD5',
									ltrim(rtrim(upper(Address))) + @bar + isnull(ltrim(rtrim(upper(Address2))), '') + @bar + isnull(ltrim(rtrim(upper(City))),
																																	'') + @bar
									+ isnull(ltrim(rtrim(upper(State))), '') + @bar + isnull(Zip, ''))

		--      Go over each provider to check of changes, additions or no change situations
		insert into @provtemp
				(
				 ProviderId
				,ProviderType
				,SeqNo
				,RowHash
				,AddressId
				,Address
				,Address2
				,City
				,County
				,State
				,Zipcode								  		
				)
			select distinct ProviderID
				   ,ProviderType
				   ,SeqNo
				   ,p.RowHash
				   ,isnull(a.AddressID, 0)
				   ,p.Address
				   ,p.Address2
				   ,p.City
				   ,p.County
				   ,p.State
				   ,p.Zip
				from @provc p
					left join geocode.Addresses a
						on p.RowHash = a.RowHash

		-- 1. If the addressid is not mapped to the provider in the [GeoCode].Providers table then inactivate the existing provider map and add the new map.
		-- Inactivate
		update pr
			set	pr.Active = 0
			from geocode.Providers pr
				join @provtemp t
					on pr.ProviderId = t.ProviderId
					   and pr.ProviderType = t.ProviderType
					   and pr.SeqNo = t.SeqNo
					   and pr.AddressID <> t.AddressId
			where t.AddressId <> 0     

		-- insert the new map
		insert geocode.Providers
				(
				 ProviderId
				,ProviderType
				,SeqNo
				,AddressID
				,Active	
				)
			select distinct t.ProviderId
				   ,t.ProviderType
				   ,t.SeqNo
				   ,t.AddressId
				   ,1 Active
				from @provtemp t
					left join geocode.Providers p
						on t.ProviderId = p.ProviderId
						   and t.ProviderType = p.ProviderType
						   and t.SeqNo = p.SeqNo
						   and t.AddressId = p.AddressID
				where p.ProviderId is null
					and t.AddressId <> 0

		-- Add the non existant address to the repository
		insert geocode.Addresses
				(
				 Address
				,Address2
				,City
				,County
				,State
				,Zipcode
				,RowHash
				,IsAddressNew
				)
			select distinct t.Address
				   ,t.Address2
				   ,t.City
				   ,t.County
				   ,t.State
				   ,t.Zipcode
				   ,t.RowHash
				   ,1
				from @provtemp t
				where t.AddressId = 0
					and (
						 (t.Address is not null)
						 and (t.Address <> '')
						)
					and (
						 (t.City is not null)
						 and (t.City <> '')
						)
					and (
						 (t.Zipcode is not null)
						 and (t.Zipcode <> '')
						)
			  
		--update provtemp with addressId after inserting new addresses
		update t
			set	t.AddressId = a.AddressID
			from @provtemp t
				inner join geocode.Addresses a
					on a.RowHash = t.RowHash
			where t.AddressId = 0
				and (
					 (t.Address is not null)
					 and (t.Address <> '')
					)
				and (
					 (t.City is not null)
					 and (t.City <> '')
					)
				and (
					 (t.Zipcode is not null)
					 and (t.Zipcode <> '')
					)
			  
		-- Now add the new providers.
		insert geocode.Providers
				(
				 ProviderId
				,ProviderType
				,SeqNo
				,AddressID
				,Active
				)
			select distinct t.ProviderId
				   ,t.ProviderType
				   ,t.SeqNo
				   ,t.AddressId
				   ,1 Active
				from @provtemp t
					left join geocode.Providers p
						on t.ProviderId = p.ProviderId
						   and t.ProviderType = p.ProviderType
						   and t.SeqNo = p.SeqNo
				where p.ProviderId is null
					and t.AddressId <> 0

		-- Now, Retrieve new Address records and Address records which are GeoCoded before 3 months. 
		select a.AddressID
			   ,a.Address
			   ,a.Address2
			   ,a.City
			   ,a.State
			   ,a.Zipcode
			   ,a.County
			from geocode.Addresses a with (nolock)
				left join geocode.GeocodedAddresses ga with (nolock)
					on a.GeoAddressID = ga.GeoAddressID
			where a.IsAddressNew = 1
				or a.GeoAddressID is null
				or ((datediff(month, ga.GeocodedDateTime, @now)) = 3)
			order by AddressID
		return 0

	end

