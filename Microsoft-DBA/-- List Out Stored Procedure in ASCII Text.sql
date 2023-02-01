-- List out Stored Procedure in ASCII Text

DECLARE @ProcReview varchar(45)

SET @ProcReview = 'Proc_ReconstructPlayer'

EXEC sp_helptext @ProcReview