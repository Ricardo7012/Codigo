SELECT s.SubscriptionID, s.OwnerID, s.Report_OID, s.Description, s.ModifiedDate
FROM ReportServer.dbo.Subscriptions s
WHERE s.Description LIKE 'QA1%'


SELECT 
	 s.LastStatus, s.LastRunTime,
	s.Description,
	c.Name, c.Path,
	s.SubscriptionID, s.OwnerID, s.Report_OID, c.ItemID
FROM ReportServer.dbo.Subscriptions s
JOIN ReportServer.dbo.Catalog c ON s.Report_OID = c.ItemID
WHERE c.Path LIKE '/Provider Services/Letters%' AND c.Name = 'LT_PS_PSR_1000_Transfer Members'


--ORDER BY ModifiedDate DESC

--Provider Member Transfer Conf. Letter
--UPDATE rpt.LetterCfg set SubscriptionID = '92F028E1-16DC-48CA-A139-4A3F9B6A0D08' where ReasonShortcut = 'TM01' --

--Provider Age Limit Change Letter
--UPDATE rpt.LetterCfg set SubscriptionID = 'B3863E1B-328E-467D-BD34-B558D4567838' where ReasonShortcut = 'AL01' --

--New Provider Confirmation Letter
--UPDATE rpt.LetterCfg set SubscriptionID = '278E8CA6-2111-454E-BA26-82A1A40DD0AC' where ReasonShortcut = 'ANP01' --

--Provider Status Change Confirmation Letter
--UPDATE rpt.LetterCfg set SubscriptionID = '75937F3A-3795-43D0-96EA-88C3C2E6DDF8' where ReasonShortcut = 'SC02' --

--Provider Affiliation Change Ack. Letter
--UPDATE rpt.LetterCfg set SubscriptionID = 'EECCC0B7-9C17-44C9-91ED-AA7F74E7DE8E' where ReasonShortcut = 'RG01' --

--Provider Demographics Change Letter
--UPDATE rpt.LetterCfg set SubscriptionID = 'A6BD1093-C179-4238-8E6B-71F65F34D35A' where ReasonShortcut = 'D03' --

--Provider Line of Business Change Letter
--UPDATE rpt.LetterCfg set SubscriptionID = '6E951A94-BC4D-4F51-B278-524F76BC99D6' where ReasonShortcut = 'LOB02' --

--Provider Physical Address Change Letter
--UPDATE rpt.LetterCfg set SubscriptionID = '2BD7F845-6AC1-4A78-A1AB-BB27F1A37716' where ReasonShortcut = 'PAC02'	--

--Provider Termination Ack. Letter
--UPDATE rpt.LetterCfg set SubscriptionID = 'E83BE44E-E2CC-4F3D-B2E7-575C7D0E8D79' where ReasonShortcut = 'T04' --

--Provider W-9 Confirmation Letter
--UPDATE rpt.LetterCfg set SubscriptionID = '561D7B02-7D30-4F85-8DF4-E7E302C193E7' where ReasonShortcut = 'W901' --

--Provider Address Change W-9 Letter
--UPDATE rpt.LetterCfg set SubscriptionID = 'CA128D7C-3E63-4106-9F2F-21298F5795B9' where ReasonShortcut = 'REL01' --

--Multiple Update Request Letter
--UPDATE rpt.LetterCfg set SubscriptionID = '44C27B53-E69C-4E55-86E9-30653C37AA5C' where ReasonShortcut = 'MUR01' --

--
--UPDATE rpt.LetterCfg set SubscriptionID = '' where ReasonShortcut = 'MDL01' --

--
--UPDATE rpt.LetterCfg set SubscriptionID = '' where ReasonShortcut = 'CD01 ' --
