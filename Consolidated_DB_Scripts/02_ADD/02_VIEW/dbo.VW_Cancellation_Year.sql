
/****** Object:  View [dbo].[VW_Cancellation_Year]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_Cancellation_Year]'))
EXEC dbo.sp_executesql @statement = N'CREATE   VIEW [dbo].[VW_Cancellation_Year]
as
SELECT DISTINCT YEAR(GrantDate) as CancellationYear
FROM CancellationDetails_rpt with(nolock)' 



