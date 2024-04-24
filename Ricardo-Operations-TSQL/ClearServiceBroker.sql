--CLEAR SERVICE BROKER
USE HSP_MO
GO
SELECT count(*)
FROM [HSP_MO].[dbo].[MembershipJobResponseQueue] WITH(NOLOCK)

declare @c uniqueidentifier
while(1=1)
begin
    select top 1 @c = conversation_handle from [dbo].[MembershipJobResponseQueue]
    if (@@ROWCOUNT = 0)
    break
    end conversation @c with cleanup
end

SELECT count(*) FROM [HSP_MO].[dbo].[MembershipJobResponseQueue] WITH(NOLOCK) 
SELECT count(*) FROM [dbo].[HistoryClaimRequestQueue] WITH(NOLOCK)
SELECT count(*) FROM [dbo].[HistoryClaimResponseQueue] WITH(NOLOCK)
SELECT count(*) FROM [dbo].[MembershipJobRequestQueue] WITH(NOLOCK)
SELECT count(*) FROM [dbo].[MembershipJobResponseQueue] WITH(NOLOCK)
