USE HSP
go
SET quoted_identifier on
set ansi_nulls on
go

create procedure ii_BuildReportingDynamicSQL_ARCHDEV
    (
        @ResultSetName Description_t                -- The name of the table holding the export results (normally #ResultSet)
                                                    --	1
       ,@EntityIDName Name_t = null                 -- The name of the report entity ID (e.g. 'ProviderID')
       ,@AttributeEntityType StringShort_t = null   -- The EntityType for the entity, as found on the EntityAttributes table
       ,@AttributeID1 Id_t = null                   -- The IDs of the Attributes (probably passed as a parameter to the report)
       ,@AttributeID2 Id_t = null
       ,@AttributeID3 Id_t = null
       ,@AttributeID4 Id_t = null
       ,@AttributeID5 Id_t = null
       ,@AttributeID6 Id_t = null
       ,@AttributeID7 Id_t = null
       ,@AttributeID8 Id_t = null
       ,@AttributeID9 Id_t = null
       ,@AttributeID10 Id_t = null
       ,@GetTopAttributes YesNo_t = 'N'             -- Explained in Modifications
       ,@EntityParentType StringShort_t = null      -- From the EntityAttributeMapper table (These three are explained in the Modifications, also)
       ,@EntityParentID Id_t = null                 -- From the EntityAttributeMapper table. Mutually exclusive with @EntityParentCode
       ,@EntityParentCode Code_t = null             -- From the EntiytAttributeMapper table. Mutually exclusive with @EntityParentID
       ,@AsOfDate Date_t = null                     -- Explained in Modifications FL023040
                                                    --	2
       ,@ColumnList varchar(max) = null             -- Explained in the header
       ,@ResultSetIndexName StringShort_t = null    -- The name of an index on the result set, to help with the join to #ReportCustomAttributes (e.g. byProviderID)
       ,@XMLCustomAttributes YesNo_t = 'N'          -- Explained in Modifications 
                                                    --	3
       ,@TableUsage StringShort_t = null            -- Explained in the header
       ,@ResultTableName varchar(80) = null         -- Explained in the header
       ,@DebugFlag int = 0
       ,@ReportSQL varchar(max) out                 -- The actual string that is returned
       ,@ErrorMsg ErrorMsg_t out
    )
with encryption
as
    begin


        /*
 © 1996-2007 Health Solutions Plus, Inc. All Rights Reserved.THIS IS LICENSED MATERIAL.  ONLY LICENSED PERSONS AND ENTITIES ARE ALLOWED TO POSSESS EITHER THE ORIGINAL OR ANY COPY OF 
THE LICENSED MATERIAL WITHOUT THE PERMISSION OF THE LICENSOR, HEALTH SOLUTIONS PLUS, INC.  The source code, whether in
human readable, machine readable, or compiled form (“Code”) and all algorithms, data structures and database schemas are
the confidential and proprietary trade secrets of Health Solutions Plus, Inc. its successors or assigns, and they are not
to be reproduced by any means, modified, stored, displayed, disseminated in any form by any means, or disclosed to
employees or third parties except as specifically permitted in the Source Code License Agreement between Health Solutions
Plus, Inc. and Code Licensee or other entity, (“License”).  USE, REPRODUCTION OR DISCLOSURE OF THE CODE, OR OF THE
CONFIDENTIAL OR PROPRIETARY TRADE SECRET INFORMATION CONTAINED THEREIN, EXCEPT AS STRICTLY PERMITTED BY THE LICENSE IS
UNLAWFUL, AND WILL SUBJECT THE VIOLATOR TO CIVIL DAMAGES AND PENALTIES OR CRIMINAL PENALTIES IN ACCORDANCE WITH STATE AND
FEDERAL LAWS.
Support for this code is provided by HSP Tech Support at (631)271-7682 during the hours of 9:00 AM to 5:00PM EST.
THIS NOTICE IS NOT TO BE REMOVED FROM THE CODE UNDER ANY CIRCUMSTANCES AND MUST BE INCLUDED IN ANY COPIES WHICH MAY BE MADE
BY LICENSEE.
*/



        set nocount on

        declare @status int
               ,@internal int
               ,@error int
                --	1
               ,@AttributeName1 Name_t
               ,@AttributeName2 Name_t
               ,@AttributeName3 Name_t
               ,@AttributeName4 Name_t
               ,@AttributeName5 Name_t
               ,@AttributeName6 Name_t
               ,@AttributeName7 Name_t
               ,@AttributeName8 Name_t
               ,@AttributeName9 Name_t
               ,@AttributeName10 Name_t
                --	2
               ,@AttributesIncluded YesNo_t
                --	3
               ,@Match int
               ,@SortKeyExcluded real
               ,@ModifiedColumnList varchar(max)
               ,@tempSQL varchar(8000)
               ,@tempRCAId Id_t
               ,@ResultSetColumnList varchar(max)
               ,@ResultTableNameForSQL varchar(100)




        select  @status = 0
               ,@internal = 0
               ,@AttributeName1 = null
               ,@AttributeName2 = null
               ,@AttributeName3 = null
               ,@AttributeName4 = null
               ,@AttributeName5 = null
               ,@AttributesIncluded = 'N'
               ,@Match = 0
               ,@SortKeyExcluded = -99999
               ,@tempSQL = ''
               ,@tempRCAId = null


        if isnull(@ResultSetName, '') = ''
            begin
                select  @ErrorMsg = 'Resultset Name is required.'
                goto AppErrorExit
            end

        --Check system option to see if tablock hint should be added for minimum logging
        if isnull((
                      select    ItemValue
                      from  SystemOptions
                      where ItemType = 'MINLoggingForTableExport'
                  )
                 ,'OFF'
                 ) = 'ON'
            select  @ResultTableNameForSQL = @ResultTableName + ' WITH (TABLOCK) '
        else
            select  @ResultTableNameForSQL = @ResultTableName

        --
        --	1: Create the #ReportCustomAttributesTable, populate it with the entity id's from #ResultSet and the associated Attribute values.
        --	   Also get the appropriate column names
        --

        -- error checking for the custom attribute parameters and table
        if isnull(@AttributeID1, '') != ''
           or   isnull(@AttributeID2, '') != ''
           or   isnull(@AttributeID3, '') != ''
           or   isnull(@AttributeID4, '') != ''
           or   isnull(@AttributeID5, '') != ''
           or   isnull(@AttributeID6, '') != ''
           or   isnull(@AttributeID7, '') != ''
           or   isnull(@AttributeID8, '') != ''
           or   isnull(@AttributeID9, '') != ''
           or   isnull(@AttributeID10, '') != ''
            begin


                select  @tempRCAId = object_id('tempdb..#ReportCustomAttributes')
                if @tempRCAId is null
                    begin
                        select  @ErrorMsg = 'Custom Attributes have been provided, but the Temporary Table #ReportCustomAttributes has not been declared'
                        goto AppErrorExit
                    end -- if object_id('tempdb..#ReportCustomAttributes') is null

                select  @AttributesIncluded = 'Y'

            end -- if @AttributeID1 is not null...

        if @GetTopAttributes = 'Y'
            begin

                -- error checking for the top attributes parameters
                if isnull(@EntityParentType, '') = ''
                    begin
                        select  @ErrorMsg = '@GetTopAttributes has been chosen, but @EntityParentType has not been provided'
                        goto AppErrorExit
                    end -- if @EntityParentType is null

                if isnull(@EntityParentID, '') = ''
                   and  isnull(@EntityParentCode, '') = ''
                    begin
                        select  @ErrorMsg = '@GetTopAttributes has been chosen, but neither @EntityParentID nor @EntityParentCode have not been provided'
                        goto AppErrorExit
                    end -- if @EntityParentID is null...

                if isnull(@EntityParentID, '') != ''
                   and  isnull(@EntityParentCode, '') != ''
                    begin
                        select  @ErrorMsg = '@GetTopAttributes has been chosen, but both @EntityParentID and @EntityParentCode have been provided'
                        goto AppErrorExit
                    end -- if @EntityParentID is not null...


                -- create a table that holds the AttributeIDs and related SortKeys for custom attributes associated with the entity
                create table #TopCustomAttributes
                    (
                        AttributeID Id_t
                       ,SortKey Money_t null
                    )

                -- populate table according to @EntityParentType and @EntityParentCode or @EntityParentID. Do not include selected attributes
                insert into #TopCustomAttributes
                    (
                        AttributeID
                       ,SortKey
                    )
                select  CA.AttributeID
                       ,EAM.SortKey
                from    EntityAttributeMapper EAM with (index = uci)
                        inner join CustomAttributes CA with (index = Uci)
                            on EAM.AttributeID = CA.AttributeID
                               and CA.AttributeID not in (isnull(@AttributeID1, 0), isnull(@AttributeID2, 0), isnull(@AttributeID3, 0), isnull(@AttributeID4, 0)
                                                         ,isnull(@AttributeID5, 0), isnull(@AttributeID6, 0), isnull(@AttributeID7, 0), isnull(@AttributeID8, 0)
                                                         ,isnull(@AttributeID9, 0), isnull(@AttributeID10, 0)
                                                         )
                where   EAM.EntityParentType = @EntityParentType
                        and isnull(EAM.EntityParentCode, '') = isnull(@EntityParentCode, isnull(EAM.EntityParentCode, ''))
                        and isnull(EAM.EntityParentID, '') = isnull(@EntityParentID, isnull(EAM.EntityParentID, ''))

                select  @error = @@error
                if @error != 0
                    begin
                        select  @ErrorMsg = 'The top custom attributes cannot be loaded due to an error'
                        goto AppErrorExit
                    end -- if @error != 0

                -- if any SortKeys are null, put them at the end of the order
                update  TCA1
                set TCA1.SortKey = isnull((
                                              select    max(isnull(TCA2.SortKey, 0))
                                              from  #TopCustomAttributes TCA2
                                          )
                                         ,0
                                         ) + 1
                from    #TopCustomAttributes TCA1
                where   TCA1.SortKey is null

                -- 	FL013331 - If @GetTopAttributes is 'Y', then @AttributesIncluded must also be 'Y'
                select  @AttributesIncluded = 'Y'

            end

        -- if any attributed have been provided, or @GetTopAttributes = 'Y', then we need @AttributeEntityType
        if @AttributesIncluded = 'Y'
           and  isnull(@AttributeEntityType, '') = ''
            begin
                select  @ErrorMsg = 'Attributes are to be included, but the parameter @AttributeEntityType has not been specified'
                goto AppErrorExit
            end





        -- populate #ReportCustomAttributes with values that correspond to each EntityID and Attribute ID
        if isnull(@AttributeID1, '') != ''
           or   @GetTopAttributes = 'Y'
            begin

                if @GetTopAttributes = 'Y'
                   and  isnull(@AttributeID1, '') = ''
                    begin
                        -- assign @AttributeID1 the AttributeID in #TopCustomAttributes with the highest precedence (lowest SortKey)
                        select  @AttributeID1 = TCA.AttributeID
                        from    #TopCustomAttributes TCA
                        where   TCA.SortKey =
                            (
                                select  min(SortKey)
                                from    #TopCustomAttributes
                                where   SortKey != @SortKeyExcluded
                            )

                        -- null the SortKey of the last used AttributeID to ensure that no IDs are repeated
                        update  TCA
                        set TCA.SortKey = @SortKeyExcluded
                        from    #TopCustomAttributes TCA
                        where   TCA.AttributeID = @AttributeID1
                    end -- if @GetTopAttributes = 'Y'...

                if isnull(@AttributeID1, '') != ''
                    begin
                        -- get the Custom Attribute's name for the column name
                        select  @AttributeName1 = AttributeName
                        from    CustomAttributes
                        where   AttributeID = @AttributeID1

                        -- put the appropriate value into the temp table			
                        if @AttributeEntityType = 'Credential'
                            begin
                                -- for credential attributes, we need to ensure that the EntityParentType on the EntityAttributeMapper table is 'CREDENTIALTYPE'
                                update  RCA
                                set RCA.AttributeValue1 = EA.AttributeValue
                                from    EntityAttributeMapper EAM with (index = uci)
                                        inner join EntityAttributes EA with (index = Uci)
                                            on EAM.AttributeID = EA.AttributeID
                                        inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                            on EA.EntityID = RCA.EntityID
                                where   EAM.AttributeID = @AttributeID1
                                        and EAM.EntityParentType = 'CREDENTIALTYPE'
                            end
                        else
                            begin
                                -- for other attributes, we just need to make sure that the EntityType = @AttributeEntityType on the EntityAttributes table
                                if (@AsOfDate is null)
                                    begin
                                        update  RCA
                                        set RCA.AttributeValue1 = EA.AttributeValue
                                        from    EntityAttributes EA with (index = Uci)
                                                inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                                    on EA.EntityID = RCA.EntityID
                                        where   EA.AttributeID = @AttributeID1
                                                and EA.EntityType = @AttributeEntityType
                                    end
                                else -- AsOfDate is passed
                                    begin
                                        update  RCA
                                        set RCA.AttributeValue1 = EA.AttributeValue
                                        from    EntityAttributes EA with (index = Uci)
                                                inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                                    on EA.EntityID = RCA.EntityID
                                        where   EA.AttributeID = @AttributeID1
                                                and EA.EntityType = @AttributeEntityType
                                                and isnull(EA.AsOfDate, @AsOfDate) <= @AsOfDate


                                        update  RCA
                                        set RCA.AttributeValue1 = EAH.AttributeValue
                                        from    EntityAttributesHistory EAH
                                                inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                                    on EAH.EntityID = RCA.EntityID
                                        where   EAH.AttributeID = @AttributeID1
                                                and EAH.EntityType = @AttributeEntityType
                                                and @AsOfDate
                                                between EAH.EffectiveDate
                                                and     EAH.ExpirationDate
                                                and EAH.EffectiveDate != EAH.ExpirationDate
                                                and RCA.AttributeValue1 is null
                                    end
                            end

                        select  @error = @@error
                        if @error != 0
                            begin
                                select  @ErrorMsg
                                    = 'The values for the attribute ' + @AttributeName1
                                      + ' cannot be added to #ReportCustomAttributes due to an error. The table schema may be incorrect'
                                goto AppErrorExit
                            end -- if @error != 0

                    end -- if isnull(@AttributeID1, '') != ''

            end -- if isnull(@AttributeID1, '') != ''...

        if isnull(@AttributeID2, '') != ''
           or   @GetTopAttributes = 'Y'
            begin

                if @GetTopAttributes = 'Y'
                   and  isnull(@AttributeID2, '') = ''
                    begin
                        select  @AttributeID2 = TCA.AttributeID
                        from    #TopCustomAttributes TCA
                        where   TCA.SortKey =
                            (
                                select  min(SortKey)
                                from    #TopCustomAttributes
                                where   SortKey != @SortKeyExcluded
                            )

                        update  TCA
                        set TCA.SortKey = @SortKeyExcluded
                        from    #TopCustomAttributes TCA
                        where   TCA.AttributeID = @AttributeID2
                    end -- if @GetTopAttributes = 'Y'...

                if isnull(@AttributeID2, '') != ''
                    begin
                        select  @AttributeName2 = AttributeName
                        from    CustomAttributes
                        where   AttributeID = @AttributeID2

                        if @AttributeEntityType = 'Credential'
                            begin
                                update  RCA
                                set RCA.AttributeValue2 = EA.AttributeValue
                                from    EntityAttributeMapper EAM with (index = uci)
                                        inner join EntityAttributes EA with (index = Uci)
                                            on EAM.AttributeID = EA.AttributeID
                                        inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                            on EA.EntityID = RCA.EntityID
                                where   EAM.AttributeID = @AttributeID2
                                        and EAM.EntityParentType = 'CREDENTIALTYPE'
                            end
                        else
                            begin
                                if (@AsOfDate is null)
                                    begin
                                        update  RCA
                                        set RCA.AttributeValue2 = EA.AttributeValue
                                        from    EntityAttributes EA with (index = Uci)
                                                inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                                    on EA.EntityID = RCA.EntityID
                                        where   EA.AttributeID = @AttributeID2
                                                and EA.EntityType = @AttributeEntityType
                                    end
                                else -- AsOfDate is passed
                                    begin
                                        update  RCA
                                        set RCA.AttributeValue2 = EA.AttributeValue
                                        from    EntityAttributes EA with (index = Uci)
                                                inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                                    on EA.EntityID = RCA.EntityID
                                        where   EA.AttributeID = @AttributeID2
                                                and EA.EntityType = @AttributeEntityType
                                                and isnull(EA.AsOfDate, @AsOfDate) <= @AsOfDate


                                        update  RCA
                                        set RCA.AttributeValue2 = EAH.AttributeValue
                                        from    EntityAttributesHistory EAH
                                                inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                                    on EAH.EntityID = RCA.EntityID
                                        where   EAH.AttributeID = @AttributeID2
                                                and EAH.EntityType = @AttributeEntityType
                                                and @AsOfDate
                                                between EAH.EffectiveDate
                                                and     EAH.ExpirationDate
                                                and EAH.EffectiveDate != EAH.ExpirationDate
                                                and RCA.AttributeValue2 is null
                                    end

                            end

                        select  @error = @@error
                        if @error != 0
                            begin
                                select  @ErrorMsg
                                    = 'The values for the attribute ' + @AttributeName2
                                      + ' cannot be added to #ReportCustomAttributes due to an error. The table schema may be incorrect'
                                goto AppErrorExit
                            end -- if @error != 0

                    end -- if isnull(@AttributeID2, '') != ''

            end -- if isnull(@AttributeID2, '') != ''...

        if isnull(@AttributeID3, '') != ''
           or   @GetTopAttributes = 'Y'
            begin

                if @GetTopAttributes = 'Y'
                   and  isnull(@AttributeID3, '') = ''
                    begin
                        select  @AttributeID3 = TCA.AttributeID
                        from    #TopCustomAttributes TCA
                        where   TCA.SortKey =
                            (
                                select  min(SortKey)
                                from    #TopCustomAttributes
                                where   SortKey != @SortKeyExcluded
                            )

                        update  TCA
                        set TCA.SortKey = @SortKeyExcluded
                        from    #TopCustomAttributes TCA
                        where   TCA.AttributeID = @AttributeID3
                    end -- if @GetTopAttributes = 'Y'...

                if isnull(@AttributeID3, '') != ''
                    begin
                        select  @AttributeName3 = AttributeName
                        from    CustomAttributes
                        where   AttributeID = @AttributeID3

                        if @AttributeEntityType = 'Credential'
                            begin
                                update  RCA
                                set RCA.AttributeValue3 = EA.AttributeValue
                                from    EntityAttributeMapper EAM with (index = uci)
                                        inner join EntityAttributes EA with (index = Uci)
                                            on EAM.AttributeID = EA.AttributeID
                                        inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                            on EA.EntityID = RCA.EntityID
                                where   EAM.AttributeID = @AttributeID3
                                        and EAM.EntityParentType = 'CREDENTIALTYPE'
                            end
                        else
                            begin
                                if (@AsOfDate is null)
                                    begin
                                        update  RCA
                                        set RCA.AttributeValue3 = EA.AttributeValue
                                        from    EntityAttributes EA with (index = Uci)
                                                inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                                    on EA.EntityID = RCA.EntityID
                                        where   EA.AttributeID = @AttributeID3
                                                and EA.EntityType = @AttributeEntityType
                                    end
                                else -- AsOfDate is passed
                                    begin
                                        update  RCA
                                        set RCA.AttributeValue3 = EA.AttributeValue
                                        from    EntityAttributes EA with (index = Uci)
                                                inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                                    on EA.EntityID = RCA.EntityID
                                        where   EA.AttributeID = @AttributeID3
                                                and EA.EntityType = @AttributeEntityType
                                                and isnull(EA.AsOfDate, @AsOfDate) <= @AsOfDate


                                        update  RCA
                                        set RCA.AttributeValue3 = EAH.AttributeValue
                                        from    EntityAttributesHistory EAH
                                                inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                                    on EAH.EntityID = RCA.EntityID
                                        where   EAH.AttributeID = @AttributeID3
                                                and EAH.EntityType = @AttributeEntityType
                                                and @AsOfDate
                                                between EAH.EffectiveDate
                                                and     EAH.ExpirationDate
                                                and EAH.EffectiveDate != EAH.ExpirationDate
                                                and RCA.AttributeValue3 is null
                                    end


                            end

                        select  @error = @@error
                        if @error != 0
                            begin
                                select  @ErrorMsg
                                    = 'The values for the attribute ' + @AttributeName3
                                      + ' cannot be added to #ReportCustomAttributes due to an error. The table schema may be incorrect'
                                goto AppErrorExit
                            end -- if @error != 0

                    end -- if isnull(@AttributeID3, '') != ''

            end -- if isnull(@AttributeID3, '') != ''...

        if isnull(@AttributeID4, '') != ''
           or   @GetTopAttributes = 'Y'
            begin

                if @GetTopAttributes = 'Y'
                   and  isnull(@AttributeID4, '') = ''
                    begin
                        select  @AttributeID4 = TCA.AttributeID
                        from    #TopCustomAttributes TCA
                        where   TCA.SortKey =
                            (
                                select  min(SortKey)
                                from    #TopCustomAttributes
                                where   SortKey != @SortKeyExcluded
                            )

                        update  TCA
                        set TCA.SortKey = @SortKeyExcluded
                        from    #TopCustomAttributes TCA
                        where   TCA.AttributeID = @AttributeID4
                    end -- if @GetTopAttributes = 'Y'...

                if isnull(@AttributeID4, '') != ''
                    begin
                        select  @AttributeName4 = AttributeName
                        from    CustomAttributes
                        where   AttributeID = @AttributeID4

                        if @AttributeEntityType = 'Credential'
                            begin
                                update  RCA
                                set RCA.AttributeValue4 = EA.AttributeValue
                                from    EntityAttributeMapper EAM with (index = uci)
                                        inner join EntityAttributes EA with (index = Uci)
                                            on EAM.AttributeID = EA.AttributeID
                                        inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                            on EA.EntityID = RCA.EntityID
                                where   EAM.AttributeID = @AttributeID4
                                        and EAM.EntityParentType = 'CREDENTIALTYPE'
                            end
                        else
                            begin
                                if (@AsOfDate is null)
                                    begin
                                        update  RCA
                                        set RCA.AttributeValue4 = EA.AttributeValue
                                        from    EntityAttributes EA with (index = Uci)
                                                inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                                    on EA.EntityID = RCA.EntityID
                                        where   EA.AttributeID = @AttributeID4
                                                and EA.EntityType = @AttributeEntityType
                                    end
                                else -- AsOfDate is passed
                                    begin
                                        update  RCA
                                        set RCA.AttributeValue4 = EA.AttributeValue
                                        from    EntityAttributes EA with (index = Uci)
                                                inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                                    on EA.EntityID = RCA.EntityID
                                        where   EA.AttributeID = @AttributeID4
                                                and EA.EntityType = @AttributeEntityType
                                                and isnull(EA.AsOfDate, @AsOfDate) <= @AsOfDate


                                        update  RCA
                                        set RCA.AttributeValue4 = EAH.AttributeValue
                                        from    EntityAttributesHistory EAH
                                                inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                                    on EAH.EntityID = RCA.EntityID
                                        where   EAH.AttributeID = @AttributeID4
                                                and EAH.EntityType = @AttributeEntityType
                                                and @AsOfDate
                                                between EAH.EffectiveDate
                                                and     EAH.ExpirationDate
                                                and EAH.EffectiveDate != EAH.ExpirationDate
                                                and RCA.AttributeValue4 is null
                                    end

                            end

                        select  @error = @@error
                        if @error != 0
                            begin
                                select  @ErrorMsg
                                    = 'The values for the attribute ' + @AttributeName4
                                      + ' cannot be added to #ReportCustomAttributes due to an error. The table schema may be incorrect'
                                goto AppErrorExit
                            end -- if @error != 0

                    end -- if isnull(@AttributeID4, '') != ''

            end -- if isnull(@AttributeID4, '') != ''...

        if isnull(@AttributeID5, '') != ''
           or   @GetTopAttributes = 'Y'
            begin

                if @GetTopAttributes = 'Y'
                   and  isnull(@AttributeID5, '') = ''
                    begin
                        select  @AttributeID5 = TCA.AttributeID
                        from    #TopCustomAttributes TCA
                        where   TCA.SortKey =
                            (
                                select  min(SortKey)
                                from    #TopCustomAttributes
                                where   SortKey != @SortKeyExcluded
                            )

                        update  TCA
                        set TCA.SortKey = @SortKeyExcluded
                        from    #TopCustomAttributes TCA
                        where   TCA.AttributeID = @AttributeID5
                    end -- if @GetTopAttributes = 'Y'...

                if isnull(@AttributeID5, '') != ''
                    begin
                        select  @AttributeName5 = AttributeName
                        from    CustomAttributes
                        where   AttributeID = @AttributeID5

                        if @AttributeEntityType = 'Credential'
                            begin
                                update  RCA
                                set RCA.AttributeValue5 = EA.AttributeValue
                                from    EntityAttributeMapper EAM with (index = uci)
                                        inner join EntityAttributes EA with (index = Uci)
                                            on EAM.AttributeID = EA.AttributeID
                                        inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                            on EA.EntityID = RCA.EntityID
                                where   EAM.AttributeID = @AttributeID5
                                        and EAM.EntityParentType = 'CREDENTIALTYPE'
                            end
                        else
                            begin
                                if (@AsOfDate is null)
                                    begin
                                        update  RCA
                                        set RCA.AttributeValue5 = EA.AttributeValue
                                        from    EntityAttributes EA with (index = Uci)
                                                inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                                    on EA.EntityID = RCA.EntityID
                                        where   EA.AttributeID = @AttributeID5
                                                and EA.EntityType = @AttributeEntityType
                                    end
                                else -- AsOfDate is passed
                                    begin
                                        update  RCA
                                        set RCA.AttributeValue5 = EA.AttributeValue
                                        from    EntityAttributes EA with (index = Uci)
                                                inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                                    on EA.EntityID = RCA.EntityID
                                        where   EA.AttributeID = @AttributeID5
                                                and EA.EntityType = @AttributeEntityType
                                                and isnull(EA.AsOfDate, @AsOfDate) <= @AsOfDate


                                        update  RCA
                                        set RCA.AttributeValue5 = EAH.AttributeValue
                                        from    EntityAttributesHistory EAH
                                                inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                                    on EAH.EntityID = RCA.EntityID
                                        where   EAH.AttributeID = @AttributeID5
                                                and EAH.EntityType = @AttributeEntityType
                                                and @AsOfDate
                                                between EAH.EffectiveDate
                                                and     EAH.ExpirationDate
                                                and EAH.EffectiveDate != EAH.ExpirationDate
                                                and RCA.AttributeValue5 is null
                                    end
                            end

                        select  @error = @@error
                        if @error != 0
                            begin
                                select  @ErrorMsg
                                    = 'The values for the attribute ' + @AttributeName5
                                      + ' cannot be added to #ReportCustomAttributes due to an error. The table schema may be incorrect'
                                goto AppErrorExit
                            end -- if @error != 0

                    end -- if isnull(@AttributeID5, '') != ''

            end -- if isnull(@AttributeID5, '') != ''...

        if isnull(@AttributeID6, '') != ''
           or   @GetTopAttributes = 'Y'
            begin

                if @GetTopAttributes = 'Y'
                   and  isnull(@AttributeID6, '') = ''
                    begin
                        select  @AttributeID6 = TCA.AttributeID
                        from    #TopCustomAttributes TCA
                        where   TCA.SortKey =
                            (
                                select  min(SortKey)
                                from    #TopCustomAttributes
                                where   SortKey != @SortKeyExcluded
                            )

                        update  TCA
                        set TCA.SortKey = @SortKeyExcluded
                        from    #TopCustomAttributes TCA
                        where   TCA.AttributeID = @AttributeID6
                    end -- if @GetTopAttributes = 'Y'...

                if isnull(@AttributeID6, '') != ''
                    begin
                        select  @AttributeName6 = AttributeName
                        from    CustomAttributes
                        where   AttributeID = @AttributeID6

                        if @AttributeEntityType = 'Credential'
                            begin
                                update  RCA
                                set RCA.AttributeValue6 = EA.AttributeValue
                                from    EntityAttributeMapper EAM with (index = uci)
                                        inner join EntityAttributes EA with (index = Uci)
                                            on EAM.AttributeID = EA.AttributeID
                                        inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                            on EA.EntityID = RCA.EntityID
                                where   EAM.AttributeID = @AttributeID6
                                        and EAM.EntityParentType = 'CREDENTIALTYPE'
                            end
                        else
                            begin
                                if (@AsOfDate is null)
                                    begin
                                        update  RCA
                                        set RCA.AttributeValue6 = EA.AttributeValue
                                        from    EntityAttributes EA with (index = Uci)
                                                inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                                    on EA.EntityID = RCA.EntityID
                                        where   EA.AttributeID = @AttributeID6
                                                and EA.EntityType = @AttributeEntityType
                                    end
                                else -- AsOfDate is passed
                                    begin
                                        update  RCA
                                        set RCA.AttributeValue6 = EA.AttributeValue
                                        from    EntityAttributes EA with (index = Uci)
                                                inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                                    on EA.EntityID = RCA.EntityID
                                        where   EA.AttributeID = @AttributeID6
                                                and EA.EntityType = @AttributeEntityType
                                                and isnull(EA.AsOfDate, @AsOfDate) <= @AsOfDate


                                        update  RCA
                                        set RCA.AttributeValue6 = EAH.AttributeValue
                                        from    EntityAttributesHistory EAH
                                                inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                                    on EAH.EntityID = RCA.EntityID
                                        where   EAH.AttributeID = @AttributeID6
                                                and EAH.EntityType = @AttributeEntityType
                                                and @AsOfDate
                                                between EAH.EffectiveDate
                                                and     EAH.ExpirationDate
                                                and EAH.EffectiveDate != EAH.ExpirationDate
                                                and RCA.AttributeValue6 is null
                                    end

                            end

                        select  @error = @@error
                        if @error != 0
                            begin
                                select  @ErrorMsg
                                    = 'The values for the attribute ' + @AttributeName6
                                      + ' cannot be added to #ReportCustomAttributes due to an error. The table schema may be incorrect'
                                goto AppErrorExit
                            end -- if @error != 0

                    end -- if isnull(@AttributeID6, '') != ''

            end -- if isnull(@AttributeID6, '') != ''...

        if isnull(@AttributeID7, '') != ''
           or   @GetTopAttributes = 'Y'
            begin

                if @GetTopAttributes = 'Y'
                   and  isnull(@AttributeID7, '') = ''
                    begin
                        select  @AttributeID7 = TCA.AttributeID
                        from    #TopCustomAttributes TCA
                        where   TCA.SortKey =
                            (
                                select  min(SortKey)
                                from    #TopCustomAttributes
                                where   SortKey != @SortKeyExcluded
                            )
                        update  TCA
                        set TCA.SortKey = @SortKeyExcluded
                        from    #TopCustomAttributes TCA
                        where   TCA.AttributeID = @AttributeID7
                    end -- if @GetTopAttributes = 'Y'...

                if isnull(@AttributeID7, '') != ''
                    begin
                        select  @AttributeName7 = AttributeName
                        from    CustomAttributes
                        where   AttributeID = @AttributeID7

                        if @AttributeEntityType = 'Credential'
                            begin
                                update  RCA
                                set RCA.AttributeValue7 = EA.AttributeValue
                                from    EntityAttributeMapper EAM with (index = uci)
                                        inner join EntityAttributes EA with (index = Uci)
                                            on EAM.AttributeID = EA.AttributeID
                                        inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                            on EA.EntityID = RCA.EntityID
                                where   EAM.AttributeID = @AttributeID7
                                        and EAM.EntityParentType = 'CREDENTIALTYPE'
                            end
                        else
                            begin
                                if (@AsOfDate is null)
                                    begin
                                        update  RCA
                                        set RCA.AttributeValue7 = EA.AttributeValue
                                        from    EntityAttributes EA with (index = Uci)
                                                inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                                    on EA.EntityID = RCA.EntityID
                                        where   EA.AttributeID = @AttributeID7
                                                and EA.EntityType = @AttributeEntityType
                                    end
                                else -- AsOfDate is passed
                                    begin
                                        update  RCA
                                        set RCA.AttributeValue7 = EA.AttributeValue
                                        from    EntityAttributes EA with (index = Uci)
                                                inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                                    on EA.EntityID = RCA.EntityID
                                        where   EA.AttributeID = @AttributeID7
                                                and EA.EntityType = @AttributeEntityType
                                                and isnull(EA.AsOfDate, @AsOfDate) <= @AsOfDate


                                        update  RCA
                                        set RCA.AttributeValue7 = EAH.AttributeValue
                                        from    EntityAttributesHistory EAH
                                                inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                                    on EAH.EntityID = RCA.EntityID
                                        where   EAH.AttributeID = @AttributeID7
                                                and EAH.EntityType = @AttributeEntityType
                                                and @AsOfDate
                                                between EAH.EffectiveDate
                                                and     EAH.ExpirationDate
                                                and EAH.EffectiveDate != EAH.ExpirationDate
                                                and RCA.AttributeValue7 is null
                                    end

                            end

                        select  @error = @@error
                        if @error != 0
                            begin
                                select  @ErrorMsg
                                    = 'The values for the attribute ' + @AttributeName7
                                      + ' cannot be added to #ReportCustomAttributes due to an error. The table schema may be incorrect'
                                goto AppErrorExit
                            end -- if @error != 0

                    end -- if isnull(@AttributeID7, '') != ''

            end -- if isnull(@AttributeID7, '') != ''...

        if isnull(@AttributeID8, '') != ''
           or   @GetTopAttributes = 'Y'
            begin

                if @GetTopAttributes = 'Y'
                   and  isnull(@AttributeID8, '') = ''
                    begin
                        select  @AttributeID8 = TCA.AttributeID
                        from    #TopCustomAttributes TCA
                        where   TCA.SortKey =
                            (
                                select  min(SortKey)
                                from    #TopCustomAttributes
                                where   SortKey != @SortKeyExcluded
                            )

                        update  TCA
                        set TCA.SortKey = @SortKeyExcluded
                        from    #TopCustomAttributes TCA
                        where   TCA.AttributeID = @AttributeID8
                    end -- if @GetTopAttributes = 'Y'...

                if isnull(@AttributeID8, '') != ''
                    begin
                        select  @AttributeName8 = AttributeName
                        from    CustomAttributes
                        where   AttributeID = @AttributeID8

                        if @AttributeEntityType = 'Credential'
                            begin
                                update  RCA
                                set RCA.AttributeValue8 = EA.AttributeValue
                                from    EntityAttributeMapper EAM with (index = uci)
                                        inner join EntityAttributes EA with (index = Uci)
                                            on EAM.AttributeID = EA.AttributeID
                                        inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                            on EA.EntityID = RCA.EntityID
                                where   EAM.AttributeID = @AttributeID8
                                        and EAM.EntityParentType = 'CREDENTIALTYPE'
                            end
                        else
                            begin
                                if (@AsOfDate is null)
                                    begin
                                        update  RCA
                                        set RCA.AttributeValue8 = EA.AttributeValue
                                        from    EntityAttributes EA with (index = Uci)
                                                inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                                    on EA.EntityID = RCA.EntityID
                                        where   EA.AttributeID = @AttributeID8
                                                and EA.EntityType = @AttributeEntityType
                                    end
                                else -- AsOfDate is passed
                                    begin
                                        update  RCA
                                        set RCA.AttributeValue8 = EA.AttributeValue
                                        from    EntityAttributes EA with (index = Uci)
                                                inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                                    on EA.EntityID = RCA.EntityID
                                        where   EA.AttributeID = @AttributeID8
                                                and EA.EntityType = @AttributeEntityType
                                                and isnull(EA.AsOfDate, @AsOfDate) <= @AsOfDate


                                        update  RCA
                                        set RCA.AttributeValue8 = EAH.AttributeValue
                                        from    EntityAttributesHistory EAH
                                                inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                                    on EAH.EntityID = RCA.EntityID
                                        where   EAH.AttributeID = @AttributeID8
                                                and EAH.EntityType = @AttributeEntityType
                                                and @AsOfDate
                                                between EAH.EffectiveDate
                                                and     EAH.ExpirationDate
                                                and EAH.EffectiveDate != EAH.ExpirationDate
                                                and RCA.AttributeValue8 is null
                                    end

                            end

                        select  @error = @@error
                        if @error != 0
                            begin
                                select  @ErrorMsg
                                    = 'The values for the attribute ' + @AttributeName8
                                      + ' cannot be added to #ReportCustomAttributes due to an error. The table schema may be incorrect'
                                goto AppErrorExit
                            end -- if @error != 0

                    end -- if isnull(@AttributeID8, '') != ''

            end -- if isnull(@AttributeID8, '') != ''...

        if isnull(@AttributeID9, '') != ''
           or   @GetTopAttributes = 'Y'
            begin

                if @GetTopAttributes = 'Y'
                   and  isnull(@AttributeID9, '') = ''
                    begin
                        select  @AttributeID9 = TCA.AttributeID
                        from    #TopCustomAttributes TCA
                        where   TCA.SortKey =
                            (
                                select  min(SortKey)
                                from    #TopCustomAttributes
                                where   SortKey != @SortKeyExcluded
                            )

                        update  TCA
                        set TCA.SortKey = @SortKeyExcluded
                        from    #TopCustomAttributes TCA
                        where   TCA.AttributeID = @AttributeID9
                    end -- if @GetTopAttributes = 'Y'...

                if isnull(@AttributeID9, '') != ''
                    begin
                        select  @AttributeName9 = AttributeName
                        from    CustomAttributes
                        where   AttributeID = @AttributeID9

                        if @AttributeEntityType = 'Credential'
                            begin
                                update  RCA
                                set RCA.AttributeValue9 = EA.AttributeValue
                                from    EntityAttributeMapper EAM with (index = uci)
                                        inner join EntityAttributes EA with (index = Uci)
                                            on EAM.AttributeID = EA.AttributeID
                                        inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                            on EA.EntityID = RCA.EntityID
                                where   EAM.AttributeID = @AttributeID9
                                        and EAM.EntityParentType = 'CREDENTIALTYPE'
                            end
                        else
                            begin
                                if (@AsOfDate is null)
                                    begin
                                        update  RCA
                                        set RCA.AttributeValue9 = EA.AttributeValue
                                        from    EntityAttributes EA with (index = Uci)
                                                inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                                    on EA.EntityID = RCA.EntityID
                                        where   EA.AttributeID = @AttributeID9
                                                and EA.EntityType = @AttributeEntityType
                                    end
                                else -- AsOfDate is passed
                                    begin
                                        update  RCA
                                        set RCA.AttributeValue9 = EA.AttributeValue
                                        from    EntityAttributes EA with (index = Uci)
                                                inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                                    on EA.EntityID = RCA.EntityID
                                        where   EA.AttributeID = @AttributeID9
                                                and EA.EntityType = @AttributeEntityType
                                                and isnull(EA.AsOfDate, @AsOfDate) <= @AsOfDate


                                        update  RCA
                                        set RCA.AttributeValue9 = EAH.AttributeValue
                                        from    EntityAttributesHistory EAH
                                                inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                                    on EAH.EntityID = RCA.EntityID
                                        where   EAH.AttributeID = @AttributeID9
                                                and EAH.EntityType = @AttributeEntityType
                                                and @AsOfDate
                                                between EAH.EffectiveDate
                                                and     EAH.ExpirationDate
                                                and EAH.EffectiveDate != EAH.ExpirationDate
                                                and RCA.AttributeValue9 is null
                                    end

                            end

                        select  @error = @@error
                        if @error != 0
                            begin
                                select  @ErrorMsg
                                    = 'The values for the attribute ' + @AttributeName9
                                      + ' cannot be added to #ReportCustomAttributes due to an error. The table schema may be incorrect'
                                goto AppErrorExit
                            end -- if @error != 0

                    end -- if isnull(@AttributeID9, '') != ''

            end -- if isnull(@AttributeID9, '') != ''...

        if isnull(@AttributeID10, '') != ''
           or   @GetTopAttributes = 'Y'
            begin

                if @GetTopAttributes = 'Y'
                   and  isnull(@AttributeID10, '') = ''
                    begin
                        select  @AttributeID10 = TCA.AttributeID
                        from    #TopCustomAttributes TCA
                        where   TCA.SortKey =
                            (
                                select  min(SortKey)
                                from    #TopCustomAttributes
                                where   SortKey != @SortKeyExcluded
                            )

                        update  TCA
                        set TCA.SortKey = @SortKeyExcluded
                        from    #TopCustomAttributes TCA
                        where   TCA.AttributeID = @AttributeID10
                    end -- if @GetTopAttributes = 'Y'...

                if isnull(@AttributeID10, '') != ''
                    begin
                        select  @AttributeName10 = AttributeName
                        from    CustomAttributes
                        where   AttributeID = @AttributeID10

                        if @AttributeEntityType = 'Credential'
                            begin
                                update  RCA
                                set RCA.AttributeValue10 = EA.AttributeValue
                                from    EntityAttributeMapper EAM with (index = uci)
                                        inner join EntityAttributes EA with (index = Uci)
                                            on EAM.AttributeID = EA.AttributeID
                                        inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                            on EA.EntityID = RCA.EntityID
                                where   EAM.AttributeID = @AttributeID10
                                        and EAM.EntityParentType = 'CREDENTIALTYPE'
                            end
                        else
                            begin
                                if (@AsOfDate is null)
                                    begin
                                        update  RCA
                                        set RCA.AttributeValue10 = EA.AttributeValue
                                        from    EntityAttributes EA with (index = Uci)
                                                inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                                    on EA.EntityID = RCA.EntityID
                                        where   EA.AttributeID = @AttributeID10
                                                and EA.EntityType = @AttributeEntityType
                                    end
                                else -- AsOfDate is passed
                                    begin
                                        update  RCA
                                        set RCA.AttributeValue10 = EA.AttributeValue
                                        from    EntityAttributes EA with (index = Uci)
                                                inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                                    on EA.EntityID = RCA.EntityID
                                        where   EA.AttributeID = @AttributeID10
                                                and EA.EntityType = @AttributeEntityType
                                                and isnull(EA.AsOfDate, @AsOfDate) <= @AsOfDate


                                        update  RCA
                                        set RCA.AttributeValue10 = EAH.AttributeValue
                                        from    EntityAttributesHistory EAH
                                                inner join #ReportCustomAttributes RCA with (index = ByEntityId)
                                                    on EAH.EntityID = RCA.EntityID
                                        where   EAH.AttributeID = @AttributeID10
                                                and EAH.EntityType = @AttributeEntityType
                                                and @AsOfDate
                                                between EAH.EffectiveDate
                                                and     EAH.ExpirationDate
                                                and EAH.EffectiveDate != EAH.ExpirationDate
                                                and RCA.AttributeValue10 is null
                                    end
                            end

                        select  @error = @@error
                        if @error != 0
                            begin
                                select  @ErrorMsg
                                    = 'The values for the attribute ' + @AttributeName10
                                      + ' cannot be added to #ReportCustomAttributes due to an error. The table schema may be incorrect'
                                goto AppErrorExit
                            end -- if @error != 0

                    end -- if isnull(@AttributeID10, '') != ''

            end -- if isnull(@AttributeID10, '') != ''...

        --
        --	2: Build base select statement to return only the columns specified in @ColumnList, based upon AttributeNames above.
        --

        --	but first, ensure that every column name gets an alias prefix
        if isnull(@ColumnList, '') != ''
            begin
                select  @ModifiedColumnList = @ColumnList
                --select @ModifiedColumnList = replace(@ModifiedColumnList, ' ', '')
                select  @ModifiedColumnList = replace(@ModifiedColumnList, ',', ', RS.')
                select  @ModifiedColumnList = convert(varchar(max), 'RS.') + @ModifiedColumnList
            end

        if @XMLCustomAttributes = 'Y'
            begin
                select  @tempSQL = 'alter table ' + @ResultSetName + ' add CustomAttributes xml null '

                exec (@tempSQL)
                select  @error = @@error
                if @error != 0
                    begin
                        select  @ErrorMsg = 'Unable to alter Resultset table with custom attribute columns.'
                        goto ServerErrorExit
                    end

                select  @tempSQL
                    = 'update RS
								  set RS.CustomAttributes = ''<xml> '
                      + case when isnull(@AttributeID1, '') != '' then
                                  '<CustomAttribute Name="' + isnull(dbo.ff_ReplaceCharacterForXML(@AttributeName1), '') + '" DataType="' +
                    (
                        select  isnull(DataType, 'TXT')
                        from    CustomAttributes
                        where   AttributeID = @AttributeID1
                    )
                                  + '" Value="'' + isnull(dbo.ff_ReplaceCharacterForXML(RCA.AttributeValue1), '''') + ''"/> '
                             else                                                 ''
                        end
                      + case when isnull(@AttributeID2, '') != '' then
                                  '<CustomAttribute Name="' + isnull(dbo.ff_ReplaceCharacterForXML(@AttributeName2), '') + '" DataType="' +
                    (
                        select  isnull(DataType, 'TXT')
                        from    CustomAttributes
                        where   AttributeID = @AttributeID2
                    )
                                  + '" Value="'' + isnull(dbo.ff_ReplaceCharacterForXML(RCA.AttributeValue2), '''') + ''"/> '
                             else                                                 ''
                        end
                      + case when isnull(@AttributeID3, '') != '' then
                                  '<CustomAttribute Name="' + isnull(dbo.ff_ReplaceCharacterForXML(@AttributeName3), '') + '" DataType="' +
                    (
                        select  isnull(DataType, 'TXT')
                        from    CustomAttributes
                        where   AttributeID = @AttributeID3
                    )
                                  + '" Value="'' + isnull(dbo.ff_ReplaceCharacterForXML(RCA.AttributeValue3), '''') + ''"/> '
                             else                                                 ''
                        end
                      + case when isnull(@AttributeID4, '') != '' then
                                  '<CustomAttribute Name="' + isnull(dbo.ff_ReplaceCharacterForXML(@AttributeName4), '') + '" DataType="' +
                    (
                        select  isnull(DataType, 'TXT')
                        from    CustomAttributes
                        where   AttributeID = @AttributeID4
                    )
                                  + '" Value="'' + isnull(dbo.ff_ReplaceCharacterForXML(RCA.AttributeValue4), '''') + ''"/> '
                             else                                                 ''
                        end
                      + case when isnull(@AttributeID5, '') != '' then
                                  '<CustomAttribute Name="' + isnull(dbo.ff_ReplaceCharacterForXML(@AttributeName5), '') + '" DataType="' +
                    (
                        select  isnull(DataType, 'TXT')
                        from    CustomAttributes
                        where   AttributeID = @AttributeID5
                    )
                                  + '" Value="'' + isnull(dbo.ff_ReplaceCharacterForXML(RCA.AttributeValue5), '''') + ''"/> '
                             else                                                 ''
                        end
                      + case when isnull(@AttributeID6, '') != '' then
                                  '<CustomAttribute Name="' + isnull(dbo.ff_ReplaceCharacterForXML(@AttributeName6), '') + '" DataType="' +
                    (
                        select  isnull(DataType, 'TXT')
                        from    CustomAttributes
                        where   AttributeID = @AttributeID6
                    )
                                  + '" Value="'' + isnull(dbo.ff_ReplaceCharacterForXML(RCA.AttributeValue6), '''') + ''"/> '
                             else                                                 ''
                        end
                      + case when isnull(@AttributeID7, '') != '' then
                                  '<CustomAttribute Name="' + isnull(dbo.ff_ReplaceCharacterForXML(@AttributeName7), '') + '" DataType="' +
                    (
                        select  isnull(DataType, 'TXT')
                        from    CustomAttributes
                        where   AttributeID = @AttributeID7
                    )
                                  + '" Value="'' + isnull(dbo.ff_ReplaceCharacterForXML(RCA.AttributeValue7), '''') + ''"/> '
                             else                                                 ''
                        end
                      + case when isnull(@AttributeID8, '') != '' then
                                  '<CustomAttribute Name="' + isnull(dbo.ff_ReplaceCharacterForXML(@AttributeName8), '') + '" DataType="' +
                    (
                        select  isnull(DataType, 'TXT')
                        from    CustomAttributes
                        where   AttributeID = @AttributeID8
                    )
                                  + '" Value="'' + isnull(dbo.ff_ReplaceCharacterForXML(RCA.AttributeValue8), '''') + ''"/> '
                             else                                                 ''
                        end
                      + case when isnull(@AttributeID9, '') != '' then
                                  '<CustomAttribute Name="' + isnull(dbo.ff_ReplaceCharacterForXML(@AttributeName9), '') + '" DataType="' +
                    (
                        select  isnull(DataType, 'TXT')
                        from    CustomAttributes
                        where   AttributeID = @AttributeID9
                    )
                                  + '" Value="'' + isnull(dbo.ff_ReplaceCharacterForXML(RCA.AttributeValue9), '''') + ''"/> '
                             else                                                 ''
                        end
                      + case when isnull(@AttributeID10, '') != '' then
                                  '<CustomAttribute Name="' + isnull(dbo.ff_ReplaceCharacterForXML(@AttributeName10), '') + '" DataType="' +
                    (
                        select  isnull(DataType, 'TXT')
                        from    CustomAttributes
                        where   AttributeID = @AttributeID10
                    )
                                  + '" Value="'' + isnull(dbo.ff_ReplaceCharacterForXML(RCA.AttributeValue10), '''') + ''"/>'
                             else                                                 ''
                        end + ' </xml>''' + ' from ' + @ResultSetName + ' RS '
                      + case when isnull(@ResultSetIndexName, '') != '' then 'with(index = ' + @ResultSetIndexName + ')'
                             else                                                          ''
                        end
                      + case when @AttributesIncluded = 'Y' then
                                  ' inner join #ReportCustomAttributes RCA with(index = byEntityID) on RS.' + @EntityIDName + ' = RCA.EntityID'
                             else                                                          ''
                        end

                if @DebugFlag = 1
                    select  @tempSQL as '@tempSQL'

                if @tempSQL != ''
                    begin
                        exec (@tempSQL)
                        select  @error = @@error
                        if @error != 0
                            begin
                                select  @ErrorMsg = 'Unable to alter Resultset table with custom attribute columns.'
                                goto ServerErrorExit
                            end
                    end

                select  @ReportSQL
                    = convert(varchar(max), 'select ') + case when isnull(@ModifiedColumnList, '') = '' then convert(varchar(max), 'RS.*')
                                                              else                @ModifiedColumnList + convert(varchar(max), ',RS.CustomAttributes')
                                                         end + convert(varchar(max), ' from ') + convert(varchar(max), @ResultSetName)
                      + convert(varchar(max), ' RS ')
                      + case when isnull(@ResultSetIndexName, '') != '' then
                                  convert(varchar(max), 'with(index = ') + convert(varchar(max), @ResultSetIndexName) + convert(varchar(max), ')')
                             else
                                  convert(varchar(max), '')
                        end

            end -- else if @XMLCustomAttributes = 'Y'
        else
            begin
                select  @ReportSQL
                    = convert(varchar(max), 'select ') + case when isnull(@ModifiedColumnList, '') = '' then convert(varchar(max), 'RS.*')
                                                              else                @ModifiedColumnList
                                                         end
                      + case when isnull(@AttributeID1, '') != '' then
                                  convert(varchar(max), ', RCA.AttributeValue1 as ''') + convert(varchar(max), @AttributeName1) + convert(varchar(max), '''')
                             else                                        convert(varchar(max), '')
                        end
                      + case when isnull(@AttributeID2, '') != '' then
                                  convert(varchar(max), ', RCA.AttributeValue2 as ''') + convert(varchar(max), @AttributeName2) + convert(varchar(max), '''')
                             else                                        convert(varchar(max), '')
                        end
                      + case when isnull(@AttributeID3, '') != '' then
                                  convert(varchar(max), ', RCA.AttributeValue3 as ''') + convert(varchar(max), @AttributeName3) + convert(varchar(max), '''')
                             else                                        convert(varchar(max), '')
                        end
                      + case when isnull(@AttributeID4, '') != '' then
                                  convert(varchar(max), ', RCA.AttributeValue4 as ''') + convert(varchar(max), @AttributeName4) + convert(varchar(max), '''')
                             else                                        convert(varchar(max), '')
                        end
                      + case when isnull(@AttributeID5, '') != '' then
                                  convert(varchar(max), ', RCA.AttributeValue5 as ''') + convert(varchar(max), @AttributeName5) + convert(varchar(max), '''')
                             else                                        convert(varchar(max), '')
                        end
                      + case when isnull(@AttributeID6, '') != '' then
                                  convert(varchar(max), ', RCA.AttributeValue6 as ''') + convert(varchar(max), @AttributeName6) + convert(varchar(max), '''')
                             else                                        convert(varchar(max), '')
                        end
                      + case when isnull(@AttributeID7, '') != '' then
                                  convert(varchar(max), ', RCA.AttributeValue7 as ''') + convert(varchar(max), @AttributeName7) + convert(varchar(max), '''')
                             else                                        convert(varchar(max), '')
                        end
                      + case when isnull(@AttributeID8, '') != '' then
                                  convert(varchar(max), ', RCA.AttributeValue8 as ''') + convert(varchar(max), @AttributeName8) + convert(varchar(max), '''')
                             else                                        convert(varchar(max), '')
                        end
                      + case when isnull(@AttributeID9, '') != '' then
                                  convert(varchar(max), ', RCA.AttributeValue9 as ''') + convert(varchar(max), @AttributeName9) + convert(varchar(max), '''')
                             else                                        convert(varchar(max), '')
                        end
                      + case when isnull(@AttributeID10, '') != '' then
                                  convert(varchar(max), ', RCA.AttributeValue10 as ''') + convert(varchar(max), @AttributeName10) + ''''
                             else                                        ''
                        end + convert(varchar(max), ' from ') + convert(varchar(max), @ResultSetName) + convert(varchar(max), ' RS ')
                      + case when isnull(@ResultSetIndexName, '') != '' then
                                  convert(varchar(max), 'with(index = ') + convert(varchar(max), @ResultSetIndexName) + convert(varchar(max), ')')
                             else
                                  convert(varchar(max), '')
                        end
                      + case when @AttributesIncluded = 'Y' then
                                  convert(varchar(max), ' inner join #ReportCustomAttributes RCA with(index = byEntityID) on RS.')
                                  + convert(varchar(max), @EntityIDName) + convert(varchar(max), ' = RCA.EntityID')
                             else
                                  convert(varchar(max), '')
                        end
            end -- else (if @XMLCustomAttributes = 'Y')


        --
        --	3: Add SQL that inserts the results into the desired database table, according to @TableUsage, if specified.
        --

        if @TableUsage in ('|CREATE|', '|RECREATE|', '|INITIALIZE|', '|APPEND|')
           and  @ResultTableName is not null
            begin

                if @TableUsage in ('|INITIALIZE|', '|APPEND|')
                   and  isnull(@ModifiedColumnList, '') != ''
                    begin

                        -- create a columnlist which includes the Attribute values
                        -- this list will be used to compare columns to the target table in 
                        -- Isolate the columns for columnlist
                        select  @ResultSetColumnList = replace(@ReportSQL, 'select', '')    -- remove "select"		
                        select  @ResultSetColumnList = substring(@ResultSetColumnList, 0, charindex(' from', @ResultSetColumnList)) -- remove "from" and everything after
                        select  @ResultSetColumnList = replace(@ResultSetColumnList, 'RS.', '''')   -- remove "RS." alias
                        select  @ResultSetColumnList = replace(@ResultSetColumnList, ',', ''',') + '''' -- surround colum names with single quotes

                    end


                -- 	move to a table instead of passing back results
                select  @ReportSQL
                    = convert(varchar(max), 'insert into ') + convert(varchar(max), @ResultTableNameForSQL) + convert(varchar(max), ' ')
                      + convert(varchar(max), @ReportSQL)

                if @TableUsage in ('|CREATE|', '|RECREATE|')
                    begin

                        if @XMLCustomAttributes = 'Y'
                            begin
                                select  @ReportSQL
                                    = convert(varchar(max), 'select ')
                                      + case when isnull(@ModifiedColumnList, '') = '' then convert(varchar(max), 'RS.*')
                                             else                                  @ModifiedColumnList + convert(varchar(max), ',RS.CustomAttributes')
                                        end + convert(varchar(max), ' into ') + convert(varchar(max), @ResultTableName) + convert(varchar(max), ' from ')
                                      + convert(varchar(max), @ResultSetName) + convert(varchar(max), ' RS ')
                                      + case when isnull(@ResultSetIndexName, '') != '' then
                                                  convert(varchar(max), 'with(index = ') + convert(varchar(max), @ResultSetIndexName)
                                                  + convert(varchar(max), ')')
                                             else
                                                  convert(varchar(max), '')
                                        end
                                      + case when @AttributesIncluded = 'Y' then
                                                  convert(varchar(max), ' inner join #ReportCustomAttributes RCA with(index = byEntityID) on RS.')
                                                  + convert(varchar(max), @EntityIDName) + convert(varchar(max), ' = RCA.EntityID')
                                             else
                                                  convert(varchar(max), '')
                                        end
                            end -- else if @XMLCustomAttributes = 'Y'
                        else
                            begin
                                select  @ReportSQL
                                    = convert(varchar(max), 'select ') + case when isnull(@ModifiedColumnList, '') = '' then convert(varchar(max), 'RS.*')
                                                                              else                @ModifiedColumnList
                                                                         end
                                      + case when isnull(@AttributeID1, '') != '' then
                                                  convert(varchar(max), ', RCA.AttributeValue1 as ''') + convert(varchar(max), @AttributeName1)
                                                  + convert(varchar(max), '''')
                                             else                                        convert(varchar(max), '')
                                        end
                                      + case when isnull(@AttributeID2, '') != '' then
                                                  convert(varchar(max), ', RCA.AttributeValue2 as ''') + convert(varchar(max), @AttributeName2)
                                                  + convert(varchar(max), '''')
                                             else                                        convert(varchar(max), '')
                                        end
                                      + case when isnull(@AttributeID3, '') != '' then
                                                  convert(varchar(max), ', RCA.AttributeValue3 as ''') + convert(varchar(max), @AttributeName3)
                                                  + convert(varchar(max), '''')
                                             else                                        convert(varchar(max), '')
                                        end
                                      + case when isnull(@AttributeID4, '') != '' then
                                                  convert(varchar(max), ', RCA.AttributeValue4 as ''') + convert(varchar(max), @AttributeName4)
                                                  + convert(varchar(max), '''')
                                             else                                        convert(varchar(max), '')
                                        end
                                      + case when isnull(@AttributeID5, '') != '' then
                                                  convert(varchar(max), ', RCA.AttributeValue5 as ''') + convert(varchar(max), @AttributeName5)
                                                  + convert(varchar(max), '''')
                                             else                                        convert(varchar(max), '')
                                        end
                                      + case when isnull(@AttributeID6, '') != '' then
                                                  convert(varchar(max), ', RCA.AttributeValue6 as ''') + convert(varchar(max), @AttributeName6)
                                                  + convert(varchar(max), '''')
                                             else                                        convert(varchar(max), '')
                                        end
                                      + case when isnull(@AttributeID7, '') != '' then
                                                  convert(varchar(max), ', RCA.AttributeValue7 as ''') + convert(varchar(max), @AttributeName7)
                                                  + convert(varchar(max), '''')
                                             else                                        convert(varchar(max), '')
                                        end
                                      + case when isnull(@AttributeID8, '') != '' then
                                                  convert(varchar(max), ', RCA.AttributeValue8 as ''') + convert(varchar(max), @AttributeName8)
                                                  + convert(varchar(max), '''')
                                             else                                        convert(varchar(max), '')
                                        end
                                      + case when isnull(@AttributeID9, '') != '' then
                                                  convert(varchar(max), ', RCA.AttributeValue9 as ''') + convert(varchar(max), @AttributeName9)
                                                  + convert(varchar(max), '''')
                                             else                                        convert(varchar(max), '')
                                        end
                                      + case when isnull(@AttributeID10, '') != '' then
                                                  convert(varchar(max), ', RCA.AttributeValue10 as ''') + convert(varchar(max), @AttributeName10)
                                                  + convert(varchar(max), '''')
                                             else                                        convert(varchar(max), '')
                                        end + convert(varchar(max), ' into ') + convert(varchar(max), @ResultTableName) + convert(varchar(max), ' from ')
                                      + convert(varchar(max), @ResultSetName) + convert(varchar(max), ' RS ')
                                      + case when @AttributesIncluded = 'Y' then
                                                  convert(varchar(max), ' inner join #ReportCustomAttributes RCA with(index = byEntityID) on RS.')
                                                  + convert(varchar(max), @EntityIDName) + convert(varchar(max), ' = RCA.EntityID')
                                             else
                                                  convert(varchar(max), '')
                                        end + convert(varchar(max), ' where 0 = 1 ') + @ReportSQL
                            end -- else (if @XMLCustomAttributes = 'Y')

                    end --- of "if @TableUsage in ('|CREATE|', '|RECREATE|')"

                else if @TableUsage = '|INITIALIZE|'
                    select  @ReportSQL
                        = convert(varchar(max), 'truncate table ') + convert(varchar(max), @ResultTableName) + convert(varchar(max), ' ') + @ReportSQL

                -- 	if @TableUsage is |CREATE|, then the table shouldn't exist; if |RECREATE| then drop table
                if object_id(@ResultTableName, N'U') is not null
                    begin
                        if @TableUsage = '|CREATE|'
                            begin
                                select  @ErrorMsg = 'Result Table ' + @ResultTableName + ' already exists.'
                                goto AppErrorExit
                            end -- if @TableUsage = '|CREATE|'
                        else if @TableUsage = '|RECREATE|'
                                 begin
                                     exec ('drop table ' + @ResultTableName)
                                 end -- else if @TableUsage = '|RECREATE|'
                    end -- if exists (select 1 from sysobjects...

                -- 	if @TableUsage is |INITIALIZE| or |APPEND|, then the table should exist and match
                if @TableUsage in ('|INITIALIZE|', '|APPEND|')
                    begin

                        if isnull(@ModifiedColumnList, '') != '' -- new if block that will check columnlist passed in to target table
                            begin
                                exec @internal = ii_CompareTableSchema @Source = @ResultSetName
                                                                      ,@Target = @ResultTableName
                                                                      ,@Debug = @DebugFlag
                                                                      ,@ColumnList = @ResultSetColumnList
                                                                      ,@Result = @Match out
                                --drop table AITempResultset

                                if @Match = 0
                                    begin
                                        select  @ErrorMsg = 'Result Table ' + @ResultTableName + ' does not match table definition.'
                                        goto AppErrorExit
                                    end -- if @Match = 0

                            end
                        else
                            begin
                                if @AttributesIncluded = 'Y'
                                   and  @XMLCustomAttributes != 'Y'
                                    begin
                                        --- SG 12/3/2013: Found this bug while setting up client testing
                                        if @tempRCAId is null
                                            begin
                                                select  @tempRCAId = object_id('tempdb..#ReportCustomAttributes')
                                                if @tempRCAId is null
                                                    begin
                                                        select  @ErrorMsg
                                                            = 'Need to Custom Attributes as columns, but the Temporary Table #ReportCustomAttributes has not been declared'
                                                        goto AppErrorExit
                                                    end
                                            end --- of "if @tempRCAId is null"

                                        select  @tempSQL = ''

                                        if isnull(@AttributeID1, '') != ''
                                            select  @tempSQL = @tempSQL + 'alter table ' + @ResultSetName + ' add "' + @AttributeName1 + '" varchar( ' +
                                                (
                                                    select  convert(varchar, length)
                                                    from    tempdb..syscolumns
                                                    where   id = @tempRCAId
                                                            and name = 'AttributeValue1'
                                                )              + ') null '

                                        if isnull(@AttributeID2, '') != ''
                                            select  @tempSQL = @tempSQL + 'alter table ' + @ResultSetName + ' add "' + @AttributeName2 + '" varchar( ' +
                                                (
                                                    select  convert(varchar, length)
                                                    from    tempdb..syscolumns
                                                    where   id = @tempRCAId
                                                            and name = 'AttributeValue2'
                                                )              + ') null '

                                        if isnull(@AttributeID3, '') != ''
                                            select  @tempSQL = @tempSQL + 'alter table ' + @ResultSetName + ' add "' + @AttributeName3 + '" varchar( ' +
                                                (
                                                    select  convert(varchar, length)
                                                    from    tempdb..syscolumns
                                                    where   id = @tempRCAId
                                                            and name = 'AttributeValue3'
                                                )              + ') null '

                                        if isnull(@AttributeID4, '') != ''
                                            select  @tempSQL = @tempSQL + 'alter table ' + @ResultSetName + ' add "' + @AttributeName4 + '" varchar( ' +
                                                (
                                                    select  convert(varchar, length)
                                                    from    tempdb..syscolumns
                                                    where   id = @tempRCAId
                                                            and name = 'AttributeValue4'
                                                )              + ') null '

                                        if isnull(@AttributeID5, '') != ''
                                            select  @tempSQL = @tempSQL + 'alter table ' + @ResultSetName + ' add "' + @AttributeName5 + '" varchar( ' +
                                                (
                                                    select  convert(varchar, length)
                                                    from    tempdb..syscolumns
                                                    where   id = @tempRCAId
                                                            and name = 'AttributeValue5'
                                                )              + ') null '

                                        if isnull(@AttributeID6, '') != ''
                                            select  @tempSQL = @tempSQL + 'alter table ' + @ResultSetName + ' add "' + @AttributeName6 + '" varchar( ' +
                                                (
                                                    select  convert(varchar, length)
                                                    from    tempdb..syscolumns
                                                    where   id = @tempRCAId
                                                            and name = 'AttributeValue6'
                                                )              + ') null '

                                        if isnull(@AttributeID7, '') != ''
                                            select  @tempSQL = @tempSQL + 'alter table ' + @ResultSetName + ' add "' + @AttributeName7 + '" varchar( ' +
                                                (
                                                    select  convert(varchar, length)
                                                    from    tempdb..syscolumns
                                                    where   id = @tempRCAId
                                                            and name = 'AttributeValue7'
                                                )              + ') null '

                                        if isnull(@AttributeID8, '') != ''
                                            select  @tempSQL = @tempSQL + 'alter table ' + @ResultSetName + ' add "' + @AttributeName8 + '" varchar( ' +
                                                (
                                                    select  convert(varchar, length)
                                                    from    tempdb..syscolumns
                                                    where   id = @tempRCAId
                                                            and name = 'AttributeValue8'
                                                )              + ') null '

                                        if isnull(@AttributeID9, '') != ''
                                            select  @tempSQL = @tempSQL + 'alter table ' + @ResultSetName + ' add "' + @AttributeName9 + '" varchar( ' +
                                                (
                                                    select  convert(varchar, length)
                                                    from    tempdb..syscolumns
                                                    where   id = @tempRCAId
                                                            and name = 'AttributeValue9'
                                                )              + ') null '

                                        if isnull(@AttributeID10, '') != ''
                                            select  @tempSQL = @tempSQL + 'alter table ' + @ResultSetName + ' add "' + @AttributeName10 + '" varchar( ' +
                                                (
                                                    select  convert(varchar, length)
                                                    from    tempdb..syscolumns
                                                    where   id = @tempRCAId
                                                            and name = 'AttributeValue10'
                                                )              + ') null '


                                        if @DebugFlag = 1
                                            select  @tempSQL as 'to alter #Resultset'

                                        if @tempSQL != ''
                                            begin
                                                exec (@tempSQL)
                                                select  @error = @@error
                                                if @error != 0
                                                    begin
                                                        select  @ErrorMsg = 'Unable to alter Resultset table with custom attribute columns.'
                                                        goto ServerErrorExit
                                                    end
                                            end

                                    end -- else (if @XMLCustomAttributes = 'Y')


                                exec @internal = ii_CompareTableSchema @Source = @ResultSetName
                                                                      ,@Target = @ResultTableName
                                                                      ,@Debug = @DebugFlag
                                                                      ,@Result = @Match out

                                if @Match = 0
                                    begin
                                        select  @ErrorMsg = 'Result Table ' + @ResultTableName + ' does not match table definition.'
                                        goto AppErrorExit
                                    end -- if @Match = 0


                                if @AttributesIncluded = 'Y'
                                   and  @XMLCustomAttributes != 'Y'
                                    begin

                                        select  @tempSQL = ''

                                        if isnull(@AttributeID1, '') != ''
                                            select  @tempSQL = @tempSQL + 'alter table ' + @ResultSetName + ' drop column "' + @AttributeName1 + '" '

                                        if isnull(@AttributeID2, '') != ''
                                            select  @tempSQL = @tempSQL + 'alter table ' + @ResultSetName + ' drop column "' + @AttributeName2 + '" '

                                        if isnull(@AttributeID3, '') != ''
                                            select  @tempSQL = @tempSQL + 'alter table ' + @ResultSetName + ' drop column "' + @AttributeName3 + '" '

                                        if isnull(@AttributeID4, '') != ''
                                            select  @tempSQL = @tempSQL + 'alter table ' + @ResultSetName + ' drop column "' + @AttributeName4 + '" '

                                        if isnull(@AttributeID5, '') != ''
                                            select  @tempSQL = @tempSQL + 'alter table ' + @ResultSetName + ' drop column "' + @AttributeName5 + '" '

                                        if isnull(@AttributeID6, '') != ''
                                            select  @tempSQL = @tempSQL + 'alter table ' + @ResultSetName + ' drop column "' + @AttributeName6 + '" '

                                        if isnull(@AttributeID7, '') != ''
                                            select  @tempSQL = @tempSQL + 'alter table ' + @ResultSetName + ' drop column "' + @AttributeName7 + '" '

                                        if isnull(@AttributeID8, '') != ''
                                            select  @tempSQL = @tempSQL + 'alter table ' + @ResultSetName + ' drop column "' + @AttributeName8 + '" '

                                        if isnull(@AttributeID9, '') != ''
                                            select  @tempSQL = @tempSQL + 'alter table ' + @ResultSetName + ' drop column "' + @AttributeName9 + '" '

                                        if isnull(@AttributeID10, '') != ''
                                            select  @tempSQL = @tempSQL + 'alter table ' + @ResultSetName + ' drop column "' + @AttributeName10 + '" '


                                        if @DebugFlag = 1
                                            select  @tempSQL as 'remove changes to #Resultset'

                                        if @tempSQL != ''
                                            begin
                                                exec (@tempSQL)
                                                select  @error = @@error
                                                if @error != 0
                                                    begin
                                                        select  @ErrorMsg = 'Unable to remove custom attribute columns from Resultset table.'
                                                        goto ServerErrorExit
                                                    end
                                            end

                                    end --- of "if @AttributesIncluded = 'Y' and @XMLCustomAttributes != 'Y'"
                            end
                    end -- if @TableUsage  in ('|INITIALIZE|', '|APPEND|') 

            end -- if @TableUsage in ('|CREATE|', ...

        if @DebugFlag = 1
            select  @ReportSQL as '@ReportSQL'
                   ,@TableUsage as '@TableUsage'
                   ,@ResultTableName as '@ResultTableName'

    end -- create procedure ii_BuildReportingDynamicSQL_ARCHDEV

NormalExit:
select  @status = 0
return @status

BusinessErrorExit:
select  @status = 1
return @status

ServerErrorExit:
select  @status = 2
return @status

AppErrorExit:
select  @status = 3
return @status

go