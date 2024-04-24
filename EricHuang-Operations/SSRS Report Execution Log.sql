select b.Path, a.UserName, a.Status, a.TimeStart, a.TimeEnd,
	a.TimeDataRetrieval, a.TimeProcessing, a.TimeProcessing
from ExecutionLog a with(nolock)
join Catalog b with(nolock) on a.ReportID = b.ItemID
where b.Name like 'R5602 - Sanctioned Provider%'
order by TimeStart desc

