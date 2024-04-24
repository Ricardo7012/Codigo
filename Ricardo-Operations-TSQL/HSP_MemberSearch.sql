SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET STATISTICS TIME, IO ON 
USE HSP
go
EXEC ee_GetMemberCoverages @BillingEntityId = NULL,
                           @RelationshipCode = NULL,
                           @MemberLastName = 'Gomez',
                           @UseLastNameSoundex = 'N',
                           @MemberFirstName = NULL,
                           @SSNumber = NULL,
                           @HICN = NULL,
                           @MemberNumber = NULL,
                           @SubscriberNumber = NULL,
                           @DateOfBirth = NULL,
                           @HomePhone = NULL,
                           @NationalIndividualId = NULL,
                           @MemberPolicyNumber = NULL,
                           @GroupNumber = NULL,
                           @HouseHoldReferenceNumber = NULL,
                           @ResultCount = '100',
                           @SessionID = NULL,
                           @Usage = '|USAGE2|';

SET STATISTICS TIME, IO OFF	
