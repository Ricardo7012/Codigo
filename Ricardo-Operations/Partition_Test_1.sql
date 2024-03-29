USE [HSP]
GO
BEGIN TRANSACTION
CREATE PARTITION FUNCTION [pf_ByEffectiveDate](date) AS RANGE RIGHT FOR VALUES (N'2001-01-01', N'2002-01-01', N'2003-01-01', N'2004-01-01', N'2005-01-01', N'2006-01-01', N'2007-01-01', N'2008-01-01', N'2009-01-01', N'2010-01-01', N'2011-01-01', N'2012-01-01', N'2013-01-01', N'2014-01-01', N'2015-01-01', N'2016-01-01', N'2017-01-01', N'2018-01-01')

CREATE PARTITION SCHEME [ps_ByEffectiveDate] AS PARTITION [pf_ByEffectiveDate] TO ([2001-2005], [2001-2005], [2001-2005], [2001-2005], [2001-2005], [2006-2010], [2006-2010], [2006-2010], [2006-2010], [2006-2010], [2011-2015], [2011-2015], [2011-2015], [2011-2015], [2011-2015], [2011-2015], [PRIMARY], [PRIMARY], [PRIMARY])

ALTER TABLE [dbo].[MemberAidCodesHistory] DROP CONSTRAINT [PK_MemberAidCodesHistory]

ALTER TABLE [dbo].[MemberAidCodesHistory] ADD  CONSTRAINT [PK_MemberAidCodesHistory] PRIMARY KEY NONCLUSTERED 
(
	[HistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

CREATE CLUSTERED INDEX [ClusteredIndex_on_ps_ByEffectiveDate_636221756408147856] ON [dbo].[MemberAidCodesHistory]
(
	[EffectiveDate]
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [ps_ByEffectiveDate]([EffectiveDate])

DROP INDEX [ClusteredIndex_on_ps_ByEffectiveDate_636221756408147856] ON [dbo].[MemberAidCodesHistory]

COMMIT TRANSACTION

--TABLE
SELECT  b.name
       ,a.partition_number
       ,a.rows
       ,a.*
FROM    sys.partitions a WITH ( NOLOCK )
        INNER JOIN sys.objects b ON a.object_id = b.object_id
WHERE   a.object_id = 574625090;

--INDEXES
SELECT  c.name
       ,a.partition_number
       ,a.rows
       ,a.*
       ,c.*
FROM    sys.partitions a WITH ( NOLOCK )
        INNER JOIN sys.indexes c ON a.object_id = c.object_id
                                    AND a.index_id = c.index_id
WHERE   a.object_id = 574625090;
